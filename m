Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6PF2DLs212759 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 10:02:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A01D385C3B
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 08:02:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eQROGeAdtAM27DG5 for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 08:02:57 -0700 (PDT)
Date: Sat, 25 Jul 2009 11:02:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: check for null single-block dir buffer
	pointer in phase6
Message-ID: <20090725150256.GA12148@infradead.org>
References: <4A69C660.9000604@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A69C660.9000604@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 24, 2009 at 09:34:08AM -0500, Eric Sandeen wrote:
> @@ -2524,7 +2525,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
>  
>  	if (!dotdot_update) {
>  		/* check btree and freespace */
> -		if (isblock) {
> +		if (isblock && bplist[0]) {
>  			xfs_dir2_block_tail_t	*btp;
>  			xfs_dir2_leaf_entry_t	*blp;

This doesn't look quite correct to me.  Now we falls through to the
final else statement when bplist[0] is zeroed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
