Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o61NtLhN216885 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 18:55:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E176D1E1DD9A
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 16:58:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	SJMSf8qYB2KbSDFm for <xfs@oss.sgi.com>;
	Thu, 01 Jul 2010 16:58:06 -0700 (PDT)
Date: Fri, 2 Jul 2010 09:58:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs file system in process of becoming corrupt; though
	xfs_repair	thinks it's fine! ; -/ (was xfs_dump problem...)
Message-ID: <20100701235802.GW24712@dastard>
References: <4C26A51F.8020909@tlinx.org> <20100628022744.GX6590@dastard>
	<4C2A749E.4060006@tlinx.org> <20100629232532.GA24712@dastard>
	<4C2A87FF.7090804@dermichi.com> <4C2A92DA.1020202@tlinx.org>
	<20100630011647.GD24712@dastard> <4C2AAFC1.9080708@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C2AAFC1.9080708@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 29, 2010 at 07:45:21PM -0700, Linda A. Walsh wrote:
> To make matters more interesting -- xfsdump can't access a couple of
> files and a directory or two.
> =

> It thinks they are 'stale NFS handles' (I'm not running any NFS file
> systems).
> =

> in @  0.0 kB/s, out @  0.0 kB/s,  0.0 kB total, buffer   0% fullxfsdump: =
WARNING: unable to open directory: ino 2082342: Stale NFS file handle
> xfsdump: WARNING: unable to open directory: ino 2082343: Stale NFS file h=
andle

xfsdump uses the handle interfaces to open files direct from
bulkstat information, and this is a typical error when bulkstat
returns an inode and it is unlinked before dump opens the handle
created from the bulkstat information.

> in @ 4079 kB/s, out @ 4079 kB/s, 2040 kB total, buffer   0% fullxfsdump: =
dumping non-directory files
> in @ 68.0 MB/s, out @ 68.0 MB/s, 1209 GB total, buffer   0% fullll
> in @  107 MB/s, out @  105 MB/s, 2200 GB total, buffer   0% fullxfsdump: =
ending media file
> xfsdump: media file size 2362017678616 bytes
> xfsdump: dump size (non-dir files) : 2361953613176 bytes
> xfsdump: dump complete: 10926 seconds elapsed
> xfsdump: Dump Status: SUCCESS
> =

> Running xfs_db on the file system (finished dumping)
> a block get returns:

Just a reminder - you can't trust xfs_db output on a live mounted
filesystem....

> dir 1133368 block 0 extra leaf entry 5438b33d 79
> dir 1133368 block 0 extra leaf entry 6624beba 71
> dir 1133368 block 0 extra leaf entry 6d832f88 69
> dir 1133368 block 0 extra leaf entry e6279e2d 80
> dir ino 1133368 missing leaf entry for e627de2d/80
> dir ino 1133368 missing leaf entry for 7624beba/71
> dir ino 1133368 missing leaf entry for 5418b33d/79
> dir ino 1133368 missing leaf entry for 6d832f80/69

I'm not sure why the blockget thinks there's a extra
entries in block 0 in the directory, but then says the
entries for the same hash index are missing.

I'd need a metadump of the filesystem to be able to look at it
directly...

> xfs_repair -n now shows:
.....
> Phase 6 - check inode connectivity...
>        - traversing filesystem ...
> entry "10 Otome ha DO MY BEST desho=BF (off vocal).flac" (ino 2359102) in=
 dir 1133368 is a duplicate name, would junk entry
> entry "06 Otome ha DO MY BEST desho=BF Otome ver..flac" (ino 2359100) in =
dir 1133368 is a duplicate name, would junk entry
> entry "05 Otome ha DO MY BEST desho=BF Hime ver..flac" (ino 2359099) in d=
ir 1133368 is a duplicate name, would junk entry
> entry "04 Otome ha DO MY BEST desho=BF 2007ver..flac" (ino 2359086) in di=
r 1133368 is a duplicate name, would junk entry
....

Every single filename has some special character in it. Of course,
my question is why are there two copies of the same directory name?
Was the file created twice? How did these files get created? If you
just copy them, does the destination directory end up corrupted?

> It would appear that 2.6.34 might have some problems in it?

I don't think we changed anything at all directory related in
XFS in 2.6.34 so I'm a little perplexed as to why this is suddenly
all happening. Did these problems only show up when you updated to
2.6.34, or can you reproduce them on an older kernel?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
