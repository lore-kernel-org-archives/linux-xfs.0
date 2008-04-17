Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 01:49:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3H8ms2A003719
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 01:48:57 -0700
Date: Thu, 17 Apr 2008 18:49:24 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080417084924.GX108924158@sgi.com>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403083151.GS103491721@sgi.com> <op.t9qpydgc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9qpydgc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 17, 2008 at 03:38:27PM +1000, Barry Naujok wrote:
> On Thu, 03 Apr 2008 18:31:51 +1000, David Chinner <dgc@sgi.com> wrote:
> 
> >On Wed, Apr 02, 2008 at 04:25:13PM +1000, Barry Naujok wrote:
> >>--- kern_ci.orig/fs/xfs/xfs_sb.h
> >>+++ kern_ci/fs/xfs/xfs_sb.h
> >>@@ -79,10 +79,18 @@ struct xfs_mount;
> >> #define XFS_SB_VERSION2_LAZYSBCOUNTBIT	0x00000002	/* Superblk 
> >> counters  */
> >> #define XFS_SB_VERSION2_RESERVED4BIT	0x00000004
> >> #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr 
> >> rework */
> >>+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
> >>
> >>-#define	XFS_SB_VERSION2_OKREALFBITS	\
> >>+#ifdef CONFIG_XFS_UNICODE
> >>+# define XFS_SB_VERSION2_OKREALFBITS	\
> >> 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> >>+	 XFS_SB_VERSION2_UNICODEBIT | \
> >> 	 XFS_SB_VERSION2_ATTR2BIT)
> >>+#else
> >>+# define XFS_SB_VERSION2_OKREALFBITS	\
> >>+	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> >>+	 XFS_SB_VERSION2_ATTR2BIT)
> >>+#endif
> >
> >Regardless of whether CONFIG_XFS_UNICODE is defined or not, we should
> >be defining this as a valid bit. What we want is  
> >xfs_sb_version_hasunicode()
> >to say "not supported" when CONFIG_XFS_UNICODE is not defined.
> >
> >IOWs, if the sb_cftino field is defined in the superblock,
> >XFS_SB_VERSION2_UNICODEBIT must be defined as well.
> 
> Either this or xfs_sb_good_version() has to be modified to support
> CONFIG_XFS_UNICODE=n correctly and that such a kernel will refuse to
> mount a Unicode XFS filesystem.

Do the check in the same place we checkfor block size > page size.
i.e. in xfs_mount_validate_sb() add:

#ifndef CONFIG_XFS_UNICODE
	if (xfs_sb_version_hasunicode()) {
		/* big fat warning to syslog */
		return XFS_ERROR(ENOSYS);
	}
#endif

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
