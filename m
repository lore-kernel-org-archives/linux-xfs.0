Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFAA67F7D
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:23:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA1D2304039
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 13:23:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1HfGfKXBh6jnQM0g for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 13:23:44 -0700 (PDT)
Date: Wed, 9 Oct 2013 07:23:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault
Message-ID: <20131008202342.GA4446@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
	<CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
	<20131004214353.GK4446@dastard>
	<CAGa4099NNUJV4_JbU0izLf0k3bcj3afHPTXt=HO2263_TESbNA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa4099NNUJV4_JbU0izLf0k3bcj3afHPTXt=HO2263_TESbNA@mail.gmail.com>
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
To: Viet Nguyen <vietnguyen@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 07, 2013 at 01:09:09PM -0700, Viet Nguyen wrote:
> Thanks. That seemed to fix that bug.
> 
> Now I'm getting a lot of this:
> xfs_da_do_buf(2): XFS_CORRUPTION_ERROR

Right, that's blocks that are being detected as corrupt when they
are read. You can ignore that for now.

> fatal error -- can't read block 8388608 for directory inode 8628218

That's a corrupted block list of some kind - it should junk the
inode.

> Then xfs_repair exits.

I'm not sure why that happens. Is it exiting cleanly or crashing?
Can you take a metadump of the filesystem and provide it for someone
to debug the problems it causes repair?

> What I've been doing is what I saw in the FAQ where I would use xfs_db and
> write core.mode 0 for these inodes. But there are just so many of them. And
> is that even the right thing to do?

That marks the inode as "free" which effectively junks it and then
xfs_repair will free all it's extents next time it is run. Basically
you are removing the files from the filesystem and making them
unrecoverable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
