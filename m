Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78DC37F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 12:21:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6710F8F8059
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 10:21:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Pt4j0H9uZfwESKQm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 10:21:54 -0800 (PST)
Date: Mon, 16 Dec 2013 10:21:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/3] xfs: xfs_qm_dqrele mostly doesn't need locking
Message-ID: <20131216182152.GA22721@infradead.org>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
	<20131212102507.GX10988@dastard>
	<20131213132807.GB13689@infradead.org>
	<20131213213006.GU10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213213006.GU10988@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Dec 14, 2013 at 08:30:06AM +1100, Dave Chinner wrote:
> > 	if (atomic_dec_and_test(&dqp->q_nrefs)) {
> > 		if (list_lru_add(&mp->m_quotainfo->qi_lru, &dqp->q_lru))
> > 			XFS_STATS_INC(xs_qm_dquot_unused);
> > 	}
> > 
> > given that the only locking we need is the internal lru lock?
> 
> Yes, I think it is.
> 
> However, that involves changing all the callers of dqput to not hold
> the dqlock when they call, which is a bigger change than was
> necessary to avoid the lock contention problem. i.e. it doesn't seem
> to be in a fast path that needed immediate fixing, so I didn't touch
> it.

Given that the lru list lock nests inside dqlock we can just turn
dqput into:

void
xfs_qm_dqput(
	struct xfs_dquot        *dqp)
{
	ASSERT(dqp->q_nrefs > 0);
	ASSERT(XFS_DQ_IS_LOCKED(dqp));

	trace_xfs_dqput(dqp);

	xfs_qm_dqrele(dqp);
	xfs_dqunlock(dqp);
}

But with my other patch we can probably replace most callers
with xfs_qm_dqrele, and the remaining ones with an opencoded
version that first drops the lock easily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
