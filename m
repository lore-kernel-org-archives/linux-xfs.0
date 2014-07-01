Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2945C7FA5
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 10:06:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3BD530404E
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 08:06:44 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id uyxQZMJR3N4Em0BF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Jul 2014 08:06:40 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id u56so9969214wes.35
	for <xfs@oss.sgi.com>; Tue, 01 Jul 2014 08:06:38 -0700 (PDT)
Received: from alyakaslap ([212.143.144.103]) by mx.google.com with ESMTPSA id
	hc4sm48686908wjc.38.2014.07.01.08.06.35 for <xfs@oss.sgi.com>
	(version=TLSv1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
	Tue, 01 Jul 2014 08:06:36 -0700 (PDT)
Message-ID: <4B2A412C75324EE9880358513C069476@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20131219105513.GZ31386@dastard>
	<8155F3F9D6094F40B4DA71BD561D2DE8@alyakaslap>
	<20131226230018.GJ20579@dastard>
	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>
	<20140113030230.GF3469@dastard>
	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>
	<20140113204314.GJ3469@dastard>
	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>
	<20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
In-Reply-To: <20140119231745.GF18112@dastard>
Subject: xfs_growfs_data_private memory leak
Date: Tue, 1 Jul 2014 18:06:38 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Greetings,

It appears that if xfs_growfs_data_private fails during the "new AG headers" 
loop, it does not free all the per-AG structures for the new AGs. When XFS 
is unmounted later, they are not freed as well, because 
xfs_growfs_data_private did not update the "sb_agcount" field, so 
xfs_free_perag will not free them. This happens on 3.8.13, but looking at 
the latest master branch, it seems to have the same issue.

Code like [1] in xfs_growfs_data, seems to fix the issue.

A follow-up question: if xfs_grows_data_private fails during the loop that 
updates all the secondary superblocks, what is the consequence? (I am aware 
that in the latest master branch, the loop is not broken on first error, but 
attempts to initialize whatever possible). When these secondary superblocks 
will get updated? Is there a way to force-update them? Otherwise, what can 
be the consequence of leaving them not updated?

Thanks,
Alex.

[1]
    /*
     * If we had an error, we might have allocated
     * PAGs, which are >=sb_agcount. We need to free
     * those, because they will not get freed in
     * xfs_free_perag().
     */
    if (error) {
        unsigned int n_pags = 0;
        xfs_perag_t* pags[16] = {0};
        xfs_agnumber_t start_agno = mp->m_sb.sb_agcount;

        do {
            unsigned int pag_idx = 0;

            spin_lock(&mp->m_perag_lock);
            n_pags = radix_tree_gang_lookup(&mp->m_perag_tree, (void**)pags, 
start_agno, ARRAY_SIZE(pags));
            for (pag_idx = 0; pag_idx < n_pags; ++pag_idx) {
                xfs_perag_t *deleted = NULL;

                /* for next lookup */
                start_agno = pags[pag_idx]->pag_agno + 1;

                /* nobody should really be touching these AGs...*/
                if (WARN_ON(atomic_read(&pags[pag_idx]->pag_ref) > 0)) {
                    pags[pag_idx] = NULL;
                    continue;
                }

                deleted = radix_tree_delete(&mp->m_perag_tree, 
pags[pag_idx]->pag_agno);
                ASSERT(deleted == pags[pag_idx]);
            }
            spin_unlock(&mp->m_perag_lock);

            /* now delete all those still marked for deletion */
            for (pag_idx = 0; pag_idx < n_pags; ++pag_idx) {
                if (pags[pag_idx])
                    call_rcu(&pags[pag_idx]->rcu_head, 
xfs_free_perag_rcu_cb);
            }
        } while (n_pags > 0);
    }

xfs_free_perag_rcu_cb is similar to __xfs_free_perag, but can be called from 
other files.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
