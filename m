Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D27B7F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:42:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5969B8F8037
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:42:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ypfTla1USai935pK for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:42:22 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:41:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test xfs/287 failure
Message-ID: <20141001224155.GW4758@dastard>
References: <20141001152314.GH17405@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141001152314.GH17405@quack.suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Wed, Oct 01, 2014 at 05:23:14PM +0200, Jan Kara wrote:
>   Hello,
> 
>   so after installing latest xfsdump (just pulled git repo at oss.sgi.com),
> I'm getting failure in test xfs/287. The failure is:
> xfs/287 2s ... 2s
> _check_xfs_filesystem: filesystem on /dev/vdb2 is inconsistent (r) (see
> /var/lib/xfstests/results//xfs/287.full)
> 
> And the 287.full has:
> ...
> Phase 3 - for each AG...
>         - scan (but don't clear) agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
> directory flags set on non-directory inode 133
> directory flags set on non-directory inode 134
> directory flags set on non-directory inode 133
> would fix bad flags.
> directory flags set on non-directory inode 134
> would fix bad flags.
> ...
> 
> Complete file is attached. I'm using also the latest xfsprogs from git and
> kernel 3.17.0-rc5 (plus couple of my patches but these should have no
> influence).

It's a bug, but a minor inconvenience at worst. I sent patches to
fix this a couple of days ago:

http://oss.sgi.com/archives/xfs/2014-09/msg00510.html

$ sudo ./check xfs/287
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test4 3.17.0-rc7-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/ram1
MOUNT_OPTIONS -- /dev/ram1 /mnt/scr

xfs/287 1s ... 1s
Ran: xfs/287
Passed all 1 tests

$

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
