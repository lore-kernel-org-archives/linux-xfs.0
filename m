Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oALAtVTo098488 for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 04:55:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 239351C61FD9
	for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 02:57:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YQ64laQcQjcTDPlx for
	<xfs@oss.sgi.com>; Sun, 21 Nov 2010 02:57:08 -0800 (PST)
Date: Sun, 21 Nov 2010 05:57:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix exporting with left over 64-bit inodes
Message-ID: <20101121105703.GA24432@infradead.org>
References: <20101119133848.GA5471@infradead.org> <201011200929.08113@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201011200929.08113@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Christoph Hellwig <hch@infradead.org>, Samuel Kvasnica <samuel.kvasnica@ims.co.at>, xfs@oss.sgi.com

On Sat, Nov 20, 2010 at 09:29:06AM +0100, Michael Monnerie wrote:
> On Freitag, 19. November 2010 Christoph Hellwig wrote:
> > We now support mounting and using filesystems with 64-bit inodes even
> > when not mounted with the inode64 option (which now only controls if
> > we allocate new inodes in that space or not).  Make sure we always
> > use large NFS file handles when exporting a filesystem that may
> > contain 64-bit inodes.  Note that this only affects newly generated
> > file handles, any outstanding 32-bit file handle is still accepted.
> 
> Could that help with the problem of not being able to mount an NFS share 
> when the top shared dir itself is a 64bit inode?

No, that's an NFSD issue, and not fixable in XFS itself.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
