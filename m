Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74EUrTS171597 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 09:30:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D5AD1D51AAE
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 07:31:44 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PEFA73xe71qmsQLW for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 07:31:44 -0700 (PDT)
Date: Tue, 4 Aug 2009 10:31:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: __xfs_get_blocks check pointer to the target
	device
Message-ID: <20090804143142.GA6712@infradead.org>
References: <1249329808.7686.26.camel@logos>
	<20090803214929.GB3167@infradead.org>
	<1249351241.7513.18.camel@logos>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1249351241.7513.18.camel@logos>
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
To: Ramon de Carvalho Valle <ramon@risesecurity.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, mszeredi@novell.com, hch@lst.de, xfs@oss.sgi.com

On Mon, Aug 03, 2009 at 11:00:41PM -0300, Ramon de Carvalho Valle wrote:
> On Mon, 2009-08-03 at 17:49 -0400, Christoph Hellwig wrote:
> > On Mon, Aug 03, 2009 at 05:03:28PM -0300, Ramon de Carvalho Valle wrote:
> > > The __xfs_get_blocks function does not check if the pointer to the target
> > > device is valid before dereferencing it.
> > 
> > It should never be zero.  It's set by xfs_imap_to_bmap to either
> > mp->m_ddev_targp which is always allocated, or to mp->m_rtdev_targp
> > which is always allocated if we have a realtime device, and
> > XFS_IS_REALTIME_INODE should only be true in that case.
> > 
> 
> While testing XFS code with a modified version of fsfuzzer on SLES 10
> SP3 (Kernel 2.6.16.60-0.49.3.ramon-ppc64), I came across the following
> Oops:

So you actually introduced the RT flag in the inode on a filesystem
where it can't happen software-wise.

I'd rather deal with this early on to protect the invariant that's
guaranteed inside the xfs code.

Something like the following untested patch:

Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c	2009-08-04 16:19:40.778532419 +0200
+++ linux-2.6/fs/xfs/xfs_inode.c	2009-08-04 16:28:06.352533058 +0200
@@ -343,6 +343,16 @@ xfs_iformat(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
+	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
+		     !ip->i_mount->m_rtdev_targp)) {
+		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
+			"corrupt dinode %Lu, has realtime flag set.",
+			ip->i_ino);
+		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
+				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
 	switch (ip->i_d.di_mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
