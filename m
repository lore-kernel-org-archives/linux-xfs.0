Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o891p5iv076755 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 20:51:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ED1114EEACB
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 19:03:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uvnRbs44puKosaIR for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 19:03:06 -0700 (PDT)
Date: Wed, 8 Sep 2010 21:51:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: convert buffer cache hash to rbtree
Message-ID: <20100909015150.GB11362@infradead.org>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283958778-28610-5-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 09, 2010 at 01:12:58AM +1000, Dave Chinner wrote:
> I have selected rbtrees for indexing becuse they can have O(log n)
> search scalability, and insert and remove cost is not excessive,
> even on large trees. Hence we should be able to cache large numbers
> of buffers without incurring the excessive cache miss search
> penalties that the hash is imposing on us.

Once thing that worries me about the rbtrees is that the Linux
implementation doesn't allow for lockless readers.  But in the end the
buffer cache implementation is very well encapsulated, so if the need
arises we could easily change the underlying data structure.

> +	/*
> +	 * The buftarg cache should never be used by external devices.
> +	 * Ensure we catch any users with extreme prejudice.
> +	 */
> +	btp->bt_mp = external ? NULL : mp;

I'd much prefer to always initialize this field.  We currently have a
b_mount field struct xfs_buf which is used only in a few places
and initialized rather, ehmm, lazily.  If we could replace it with
->b_target->bt_mount we can shrink struct buf and make the information
available much more consistently.  Just adding the mount argument
to the buftarg and removing it from the buf would be a nice little
preparatory patch.

And yes, I think bt_mount would be much nicer name than bt_mp.

> @@ -210,8 +210,6 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
>  	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
>  	if (pag) {
>  		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> -		/* catch leaks in the positive direction during testing */
> -		ASSERT(atomic_read(&pag->pag_ref) < 1000);

Di you manage to hit this during testing?  Either way it should probably
be a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
