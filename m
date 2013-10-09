Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23E0C7F54
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:15:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB8E6304048
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:15:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UAj4HEe6AEzYKTl4 for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:15:20 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:15:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault
Message-ID: <20131009201509.GF4446@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
	<CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
	<20131004214353.GK4446@dastard>
	<CAGa4099NNUJV4_JbU0izLf0k3bcj3afHPTXt=HO2263_TESbNA@mail.gmail.com>
	<20131008202342.GA4446@dastard>
	<CAGa409_Wk9L5mD_p0MzCbMKxHFRrFWKaf+ejFD+tUnhmeHBO3g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa409_Wk9L5mD_p0MzCbMKxHFRrFWKaf+ejFD+tUnhmeHBO3g@mail.gmail.com>
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

On Wed, Oct 09, 2013 at 11:59:19AM -0700, Viet Nguyen wrote:
> On Tue, Oct 8, 2013 at 1:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Mon, Oct 07, 2013 at 01:09:09PM -0700, Viet Nguyen wrote:
> > > Thanks. That seemed to fix that bug.
> > >
> > > Now I'm getting a lot of this:
> > > xfs_da_do_buf(2): XFS_CORRUPTION_ERROR
> >
> > Right, that's blocks that are being detected as corrupt when they
> > are read. You can ignore that for now.
> >
> > > fatal error -- can't read block 8388608 for directory inode 8628218
> >
> > That's a corrupted block list of some kind - it should junk the
> > inode.
> >
> > > Then xfs_repair exits.
> >
> > I'm not sure why that happens. Is it exiting cleanly or crashing?
> > Can you take a metadump of the filesystem and provide it for someone
> > to debug the problems it causes repair?
> >
> 
> It seems to be exiting cleanly with return code 1. I created a metadump,
> but it's 9.6GB. I suppose I can put up on a secure FTP or something like
> that, but it does seem a big large to shuffle around.

How big is it when you compress it? I should get a lot smaller...

> > > What I've been doing is what I saw in the FAQ where I would use xfs_db
> > and
> > > write core.mode 0 for these inodes. But there are just so many of them.
> > And
> > > is that even the right thing to do?
> >
> > That marks the inode as "free" which effectively junks it and then
> > xfs_repair will free all it's extents next time it is run. Basically
> > you are removing the files from the filesystem and making them
> > unrecoverable.
> >
> 
> In the case of directories, it blows away just directory but xfs_repair
> later on scans for orphan files, no? Or am I mistaken on how that works.

It does do that, putting all the unreferenced files into lost+found.
But you lose all the names, and you have to manually work out what
all the files are and what they used to be named and what directory
they belonged to. So it's a mess that would be better avoided if at
all possible.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
