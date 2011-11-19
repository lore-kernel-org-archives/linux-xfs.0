Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJJ6Vib076699 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 13:06:31 -0600
Received: from out2.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47AD826527A
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 11:06:29 -0800 (PST)
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26]) by cuda.sgi.com with ESMTP id v6xyB1XOSbDZJOyO
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 11:06:29 -0800 (PST)
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 41872204E1
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 14:06:29 -0500 (EST)
Date: Sat, 19 Nov 2011 10:59:19 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/9] XFS update for 3.0-stable
Message-ID: <20111119185919.GA30186@kroah.com>
References: <20111119181336.964593075@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111119181336.964593075@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Sat, Nov 19, 2011 at 01:13:36PM -0500, Christoph Hellwig wrote:
> This is the series of XFS fixes from current mainline which is important
> enough for 3.0-stable.  All but the first three would also be needed
> for 3.1-stable, but given the limited resources I plan to concentrate
> on 3.0-stable.  If anyone wants to take care for 3.1 by building a kernel
> with the remaining patches and run QA on them you are more welcome to
> help out with that tree.
> 
> Note that while the description of
> 
>         xfs: don't serialise direct IO reads on page cache checks
> 
> doesn't mention that is is a regression fix we later noticed that a
> large part of the speedups wasn't in fact new, but fixed a performance
> regression introduced in Linux 2.6.38 with commit:
> 
> 	xfs: introduce xfs_rw_lock() helpers for locking the inode

Thanks for the series of patches, I'll queue them up after this latest
3.0 release happens on Monday.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
