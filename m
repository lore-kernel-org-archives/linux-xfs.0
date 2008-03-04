Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 07:38:51 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m24FcUf9029632
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 07:38:31 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 629ABF135CB
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 07:38:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id pGa93fKLGXAWBOsp for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 07:38:58 -0800 (PST)
Message-ID: <47CD6D0E.3090301@sandeen.net>
Date: Tue, 04 Mar 2008 09:38:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] mkfs.xfs man page needs the default settings updated.
References: <ncc8x0zhwxw.fsf@sgi.com>
In-Reply-To: <ncc8x0zhwxw.fsf@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Niv Sardi wrote:
> Manpages update for the new defaults, please review, I believe I got'em all.

(hmm attachments make it slightly trickier to reply inline...)

>>From 71011d480d52aaefe99ef252dfff513bf77f209e Mon Sep 17 00:00:00 2001
> From: Niv Sardi <xaiki@sgi.com>
> Date: Fri, 22 Feb 2008 16:48:32 +1100
> Subject: [PATCH] Update mkfs manpage for new defaults:
> 
> log, attr and inodes v2,
> Drop the ability to turn unwritten extents off completly,
> reduce imaxpct for big filesystems, less AGs for single disks configs.
> ---
>  xfsprogs/man/man8/mkfs.xfs.8 |   44 +++++------------------------------------
>  1 files changed, 6 insertions(+), 38 deletions(-)
> 
> diff --git a/xfsprogs/man/man8/mkfs.xfs.8 b/xfsprogs/man/man8/mkfs.xfs.8
> index b6024c3..f9a89af 100644
> --- a/xfsprogs/man/man8/mkfs.xfs.8
> +++ b/xfsprogs/man/man8/mkfs.xfs.8
> @@ -304,7 +304,8 @@ bits.
>  This specifies the maximum percentage of space in the filesystem that
>  can be allocated to inodes. The default
>  .I value
> -is 25%. Setting the
> +is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
> +for filesystems over 50TB. Setting the
>  .I value
>  to 0 means that essentially all of the filesystem can
>  become inode blocks.

Is it worth saying why you might want to override this?  (i.e. why was
it reduced for large filesystems, what was detrimental about having 25%
at 50T?)

> @@ -327,16 +328,10 @@ that does not have the inode alignment feature
>  .BI attr[= value ]
>  This is used to specify the version of extended attribute inline allocation
>  policy to be used.
> -By default, this is zero.  Once extended attributes are used for the
> +By default, this is 2.  Once extended attributes are used for the
>  first time, the version will be set to either one or two.

well, it will be set to what is specified, or the default, right?
Again, why would I choose one over the other?

>  The current version (two) uses a more efficient algorithm for managing
> -the available inline inode space than version one does, however, for
> -backward compatibility reasons (and in the absence of the
> -.B attr=2
> -mkfs option, or the
> -.B attr2
> -mount option), version one will be selected
> -by default when attributes are first used on a filesystem.
> +the available inline inode space than version one does.

ah so I would never want to use 1?  Or might I want to use it for
backwards compatibility?  or?

>  .RE
>  .TP
>  .BI \-l " log_section_options"
> @@ -389,15 +384,9 @@ and directory block size, the minimum log size is larger than 512 blocks.
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
> +allows the logbsize to be increased beyond 32K.

and it allows the sunit/su suboptions?  And what's this 32K thing, and
what's logbsize?  The first-time reader may wonder what's special about
32K.  Why would one want to use logv1 at this point, any reason?
Perhaps it would be better to document limitations of v1 rather than the
non-limitations of v2?  Or just drop v1 altogether?

>  .TP
>  .BI sunit= value
>  This specifies the alignment to be used for log writes. The
> @@ -430,27 +419,6 @@ suffixes). This value must be a multiple of the filesystem block size.
>  Version 2 logs are automatically selected if the log
>  .B su
>  suboption is specified.
> -.TP
> -.BI lazy-count= value
> -This changes the method of logging various persistent counters
> -in the superblock.  Under metadata intensive workloads, these
> -counters are updated and logged frequently enough that the superblock
> -updates become a serialisation point in the filesystem. The
> -.I value
> -can be either 0 or 1.
> -.IP
> -With
> -.BR lazy-count=1 ,
> -the superblock is not modified or logged on every change of the
> -persistent counters. Instead, enough information is kept in
> -other parts of the filesystem to be able to maintain the persistent
> -counter values without needed to keep them in the superblock.
> -This gives significant improvements in performance on some configurations.
> -The default
> -.I value
> -is 0 (off) so you must specify
> -.B lazy-count=1
> -if you want to make use of this feature.

lazy-count is no longer a configurable option?

-Eric

>  .RE
>  .TP
>  .BI \-n " naming_options"
> -- 1.5.4.1
> 
> 
> 
> 
> -- Niv Sardi 
