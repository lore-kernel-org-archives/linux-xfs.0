Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 21:29:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m265THoo025180
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 21:29:18 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0D3811FAB43
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 21:29:45 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id RT2IPUsqN1GEhOO9 for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 21:29:45 -0800 (PST)
Message-ID: <47CF8127.40900@sandeen.net>
Date: Wed, 05 Mar 2008 23:29:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] mkfs.xfs man page needs the default settings updated,
 TAKE 2.
References: <ncc8x0zhwxw.fsf@sgi.com> <47CD6D0E.3090301@sandeen.net>	<47CD6ED7.5050505@sandeen.net> <ncczltcfoqu.fsf_-_@sgi.com>
In-Reply-To: <ncczltcfoqu.fsf_-_@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Niv Sardi wrote:
> Thanks to Eric for the comments, is this better ?
> 
> Cheers,
> 
> -- Niv Sardi
> 
> 
> 
> From 7e0e328663858ecf13f35678f1a6d349c3d4dd5a Mon Sep 17 00:00:00 2001
> From: Niv Sardi <xaiki@sgi.com>
> Date: Fri, 22 Feb 2008 16:48:32 +1100
> Subject: [PATCH] Update mkfs manpage for new defaults:
> 
> log, attr and inodes v2,
> Drop the ability to turn unwritten extents off completly,
> reduce imaxpct for big filesystems, less AGs for single disks configs.
> ---
>  xfsprogs/man/man8/mkfs.xfs.8 |   41 ++++++++++++++++++-----------------------
>  1 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
> index b6024c3..afc284c 100644
> --- a/xfsprogs/man/man8/mkfs.xfs.8
> +++ b/xfsprogs/man/man8/mkfs.xfs.8
> @@ -304,10 +304,16 @@ bits.
>  This specifies the maximum percentage of space in the filesystem that
>  can be allocated to inodes. The default
>  .I value
> -is 25%. Setting the
> +is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
> +for filesystems over 50TB. Setting the
>  .I value
> -to 0 means that essentially all of the filesystem can
> -become inode blocks.
> +to 0 means that essentially all of the filesystem can become inode
> +blocks. Note that this is only used by inode32 (on 32bits platforms),
> +and is ignored on 64bits platforms. 

Really?  The m_maxicount tests in xfs_ialloc_ag_alloc and xfs_dialloc
don't seem to care about inode32 or not, unless I'm missing something.

> +On 32 bits platforms, we can only
> +use the first TB of disk space for inodes, 

well, that depends on the inode size...

> +so the allocator will try

the data allocator...

> +to avoid this region, hence miss-using the first AG if this is set to
> +high (the worst case is a 4TB filesystem where a full AG will be
> +untouched by anything but inodes with a 25% maxpct).

ah, ok.  It becomes slightly clearer.  :)

How about...

maxpct=value
	This specifies the maximum percentage of space in the
	filesystem that can be allocated to  inodes. The
	default value is 25% for filesystems under 1TB, 5% for
	filesystems under 50TB and 1% for filesystems over 50TB.

	In the default inode allocation mode, inode blocks are
	chosen such that inode numbers will not exceed 32 bits,
	which restricts the inode blocks to the lower portion of
	the filesystem.  The data block allocator will avoid these
	low blocks to accommodate the specified maxpct, so a high
	value may result in a filesystem with nothing but inodes
	in a significant portion of the lower blocks of the
	filesystem.  (This restriction is not present when
	the filesystem is mounted with the "inode64" option on
	64-bit platforms).

	Setting the value to 0 means that essentially all of the
	filesystem can become inode blocks, subject to inode32
	restrictions.

	This value can be modified with xfs_growfs(8).

eh... could be better... but how's it sound?

>  .TP
>  .BI align[= value ]
>  This is used to specify that inode allocation is or is not aligned. The
> @@ -325,18 +331,11 @@ that does not have the inode alignment feature
>  (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
>  .TP
>  .BI attr[= value ]
> -This is used to specify the version of extended attribute inline allocation
> -policy to be used.
> -By default, this is zero.  Once extended attributes are used for the
> -first time, the version will be set to either one or two.
> -The current version (two) uses a more efficient algorithm for managing
> -the available inline inode space than version one does, however, for
> -backward compatibility reasons (and in the absence of the
> -.B attr=2
> -mkfs option, or the
> -.B attr2
> -mount option), version one will be selected
> -by default when attributes are first used on a filesystem.
> +This is used to specify the version of extended attribute inline
> +allocation policy to be used.  By default, this is 2.  The current
> +version (two) uses a more efficient algorithm for managing the
> +available inline inode space than version one does. This option is
> +kept for backward compatibility, attr2 was added in kernel 2.6.16.

attr[=value] (hmm why the brackets; is value really optional?)
	This is used to specify the version of extended attribute
	inline allocation policy to be used.  By default, this is 2,
	which uses an efficient algorithm for managing the available
	inline inode space between attribute and extent data.

	The previous version 1, which has fixed regions for attribute
	and extent data, is kept for backwards compatibility with
	kernels older than version 2.6.16.

(aside: will older kernels refuse to mount attr2 filesystems?  I suppose
they will but I'm not sure they need to?)


-Eric

>  .RE
>  .TP
>  .BI \-l " log_section_options"
> @@ -389,15 +388,11 @@ and directory block size, the minimum log size is larger than 512 blocks.
>  .BI version= value
>  This specifies the version of the log. The
>  .I value
> -is either 1 or 2. Specifying
> +is either 1 or 2 (the default is 2).
>  .B version=2
> -enables the
> -.B sunit
> -suboption, and allows the logbsize to be increased beyond 32K.
> -Version 2 logs are automatically selected if a log stripe unit
> -is specified.  See
> -.BR sunit " and " su
> -suboptions, below.
> +allows bigger log buffer size (version 1 had a limit at 32K), and the
> +use of the sunit and su options. Possibility to use version=1 is left
> +for backward compatibility only.

version=value
	This specifies the version of the log.  The current default
	is 2, which allows for larger log buffer sizes, as well as
	supporting stripe-aligned log writes (see the sunit and su
	options, below).

	The previous version 1, which is limited to 32k log buffers
	and does not support stripe-aligned writes, is kept for
	backwards compatibility with kernels older than version
	2.XX.XX

>  .TP
>  .BI sunit= value
>  This specifies the alignment to be used for log writes. The
> -- 1.5.4.3 
