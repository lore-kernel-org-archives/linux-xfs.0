Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2C2xSuH233124 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 21:59:28 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id iliGLs0C3F3iTkpt
	for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 19:59:26 -0700 (PDT)
Message-ID: <4F5D6690.3010006@hardwarefreak.com>
Date: Sun, 11 Mar 2012 21:59:28 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 1B files, slow file creation, only AG0 used
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
	<4F5ADFCB.9010602@sandeen.net>
	<CAEm1PvmTCaw_eSNPPvQLvwu5X7ywseOBbALxMkSLnOT9iQd6fQ@mail.gmail.com>
In-Reply-To: <CAEm1PvmTCaw_eSNPPvQLvwu5X7ywseOBbALxMkSLnOT9iQd6fQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: mike@nauticaltech.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 3/9/2012 11:25 PM, Michael Spiegle wrote:

> Our "1B" files are spread out evenly into a tree of 65536 directories.
>  I've read the docs, and they seem explicit about new directories
> being created in new AGs, however we are not seeing that on our
> system.  All 1B files (despite being spread out across more than 64K
> dirs) are in the first AG.  I have tried remounting the filesystem
> with inode64 (and on 3.2.9), but this behavior does not seem to change
> even if I add more files afterwards.

When using the inode32 allocator and having 64k dirs, and seeing no
files in AGs other than AG0, might this tend to suggest that these are
zero length files or similar, being stored entirely within the directory
inodes, thus occupying no extents in other AGs?  Would this tend to
explain why 'everything' is in AG0?

> As mentioned above, the inode64 mount option doesn't seem to affect
> anything.  Can you think of anything else I should check that would
> prevent this from working?

If my guess about these files is correct, mounting with inode64 and
writing additional files should create new directory inodes in other
AGs, but you still won't see file extents in those other AGs, just as
you don't in the first AG.

Are you using this XFS filesystem as a poor man's database or something
similar?  This would tend to explain a billion files, with no extents,
wholly stored in directory inodes, only in AG0, while using the inode32
allocator.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
