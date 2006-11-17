Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 21:56:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAH5uDaG013358
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 21:56:16 -0800
Date: Fri, 17 Nov 2006 16:55:21 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <20061117055521.GS11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net> <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local> <20061117023946.GN11034@melbourne.sgi.com> <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Nov 17, 2006 at 02:11:12PM +1000, Timothy Shimmin wrote:
> >so it translates is as though it was a 64 bit field,
> >not a 32 bit field.....
> >
> 
> So why not change xfs_sb_info to give the real offset of where
> the next field should go (if there was one), instead of giving the sizeof 
> the
> structure which is not where say a 32 bit field would go and
> is wrong IMHO.
> 
> i.e.
> 
> ===========================================================================
> Index: fs/xfs/xfs_mount.c
> ===========================================================================
> 
> --- a/fs/xfs/xfs_mount.c	2006-11-17 15:02:21.000000000 +1100
> +++ b/fs/xfs/xfs_mount.c	2006-11-17 14:48:43.261937705 +1100
> @@ -121,7 +121,7 @@ static const struct {
>     { offsetof(xfs_sb_t, sb_logsectsize),0 },
>     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
>     { offsetof(xfs_sb_t, sb_features2),	 0 },
> -    { sizeof(xfs_sb_t),			 0 }
> +    { offsetof(xfs_sb_t, sb_features2) + sizeof(__uint32_t), 0 }
> };

Whenever you add to the table, you now need to modify both the new
entry and the terminator to get it right.

Nor (IMO) is it obvious that it is a terminator or why it is
different to all the other entries in the structure. A field such as
sb_dummy or sb_pad before the terminator is fairly obvious, and it
means that you don't need to modify the table terminator every time
the superblock gets extended.

That way the code stays more consistent over time, diffs are smaller
and neater, and you can see at a simple diff just how the features
have been added over time (like I did this morning).....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
