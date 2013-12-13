Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3CFB7F85
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:30:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E132F30406B
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:30:24 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id WwQkGzVWK5RG41zR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 05:30:15 -0800 (PST)
Date: Fri, 13 Dec 2013 05:28:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/3] xfs: xfs_qm_dqrele mostly doesn't need locking
Message-ID: <20131213132807.GB13689@infradead.org>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
	<20131212102507.GX10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212102507.GX10988@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 09:25:07PM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have an atomic variable for the reference count, we
> don't need to take the dquot lock if we are not removing the last
> reference count. The dquot lock is a mutex, so we can't use
> atomic_dec_and_lock(), but we can open code it in xfs_qm_dqrele and
> hence avoid the dquot lock for most of the cases where we drop a
> reference count.
> 
> The result is that concurrent file creates jump from 24,000/s to
> 28,000/s, and the entire workload is now serialised on the dquot
> being locked during transaction commit. Another significant win,
> even though it's not the big one...

Maybe I'm missing something, but shou;dn't the following be enough to
be a valid dqput (plus asserts & tracing):


	if (atomic_dec_and_test(&dqp->q_nrefs)) {
		if (list_lru_add(&mp->m_quotainfo->qi_lru, &dqp->q_lru))
			XFS_STATS_INC(xs_qm_dquot_unused);
	}

given that the only locking we need is the internal lru lock?
> 
> While there, rename xfs_qm_dqrele to xfs_dqrele - the "qm" part of
> the name means nothing and just makes the code harder to read.

Please keep that out of the patch.  I don't mind dropping the
qm_ part, but there's a lot of functions that have it, and it should
be done for all of them at the same time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
