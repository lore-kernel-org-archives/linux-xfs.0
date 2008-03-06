Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 22:13:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m266CSXW027587
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 22:12:33 -0800
Date: Thu, 6 Mar 2008 17:12:42 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [REVIEW] mkfs.xfs man page needs the default settings updated, TAKE 2.
Message-ID: <20080306061242.GG155407@sgi.com>
References: <ncc8x0zhwxw.fsf@sgi.com> <47CD6D0E.3090301@sandeen.net> <47CD6ED7.5050505@sandeen.net> <ncczltcfoqu.fsf_-_@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncczltcfoqu.fsf_-_@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Mar 06, 2008 at 03:41:29PM +1100, Niv Sardi wrote:
> Thanks to Eric for the comments, is this better ?

Not much of a changelog....


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
> +and is ignored on 64bits platforms. On 32 bits platforms, we can only

This is wrong. inode32 is the default on 64 bit platforms as well,
and it matters then as well.

> +use the first TB of disk space for inodes, so the allocator will try

That's not strictly true, either - it depends on inode size; 2k inodes
stratch this to 8TB.

> +to avoid this region, hence miss-using the first AG if this is set to
> +high (the worst case is a 4TB filesystem where a full AG will be
> +untouched by anything but inodes with a 25% maxpct).

No, it doesn't "miss-use" this space - it reserves it for inodes and
metadata and prevents data allocation in those AGs until all other space
is consumed.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
