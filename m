Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA372qBX243522 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 02:02:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E2E31CDD393
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 00:02:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lOIZQyT3Kk4GWXMC for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 00:02:49 -0700 (PDT)
Date: Thu, 3 Nov 2011 03:02:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] xfs: serialise unaligned direct IOs
Message-ID: <20111103070246.GA10579@infradead.org>
References: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 11:37:03AM +0530, Amit Sahrawat wrote:
> This is needed for long term kernel 2.6.35.14.
> Please let me know for any changes/suggestions.

It sounds like a fine candidate to backport, although the context
differs a lot from the actual changes commited to mainline.  A few
comments below:

> they are overlapping IO and the result of concurrent overlapping IOs
> is undefined - the result of either IO is a valid result so we let
> them race. Hence we only penalise unaligned IO, which already has a
> major overhead compared to aligned IO so this isn't a major problem.
> 

You probably should keep the original Signoff and reviewed-by tags,
and add your editor note on the top into [ ]  brackets.

> +		if (!need_i_mutex && ( unaligned_io || mapping->nrpages || pos >
> ip->i_size)) {

no space after the opening brace please, and split overly-long lines
into two:

		if (!need_i_mutex &&
		    (unaligned_io || mapping->nrpages || pos > ip->i_size)) {

>  		if (need_i_mutex) {
> -			/* demote the lock now the cached pages are gone */
> -			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);

> +			if (unaligned_io)
> +	                       	xfs_ioend_wait(ip);
> +	               /* demote the lock now the cached pages are gone if we can */
> +        	        else {
> +                 	        xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +	                        iolock = XFS_IOLOCK_SHARED;
> +        	        }

Please use the comment that was used upstream here:

			/*
			 * If we are doing unaligned IO, wait for all other IO
			 * to drain, otherwise demote the lock if we had to
			 * flush cached pages.
			 */

>  			mutex_unlock(&inode->i_mutex);
> 
> -			iolock = XFS_IOLOCK_SHARED;


>  			need_i_mutex = 0;

You also need to make the i_mutex unlock and need_i_mutex update
conditional here, otherwise you still serialize all O_DIRECT writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
