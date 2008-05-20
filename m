Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 00:40:27 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K7eNjL016344
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 00:40:24 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAF07166D5E3
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 00:41:11 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id L0REeGWOfP1ctt1R for <xfs@oss.sgi.com>; Tue, 20 May 2008 00:41:11 -0700 (PDT)
In-reply-to: <20080520060838.GA6436@lst.de> (message from Christoph Hellwig on
	Tue, 20 May 2008 08:08:38 +0200)
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
References: <20080520060838.GA6436@lst.de>
Message-Id: <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 May 2008 09:40:56 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hch@lst.de
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

> Currently touch_atime and file_update_time directly update a/c/mtime
> in the inode and just mark the inode dirty afterwards.  This is pretty
> bad for some more complex filesystems that have various different types
> of dirtying an inode and/or need to store the data in another place
> for example for a buffer to be logged.
> 
> This patch changes touch_atime and file_update_time to not update the
> inode directly but rather call through ->setattr into the filessystem.

Do we know what effect this will have on read/write performance?  I
can imagine that some ->setattr() implementations are orders of
magnitude slower than just dirtying the inode.

> There is a new ATTR_UPDTIMES flag for these two calls so filesystems
> know it's just a timestampts update.  This allows some optimizations
> and also allow to kill the IS_NOCMTIME we curretly have for networked
> filesystem by letting them simpliy ignore these kind of updates.
> 
> There is also a new ATTR_VERSION flag sent from file_update_time
> that tells the filesystem to update i_version because this update
> has the same issues as the timestamp updates.
> 
> As a side-effect of the optimiation to not perfrom redundant timestamp
> updates has been moved from touch_atime and file_update_time to
> notify_change and thus applies to explicit utimes calls, too.

This optimization is fishy.  Remember, inode->i_*time are just cached
values, and the actual times on the (remote) filesystem itself can
differ.  Which means that we will now optimize out a "touch" because
we happened to have the current time cached in the inode.  Not that
this would be a likely event, but still...

So at least this check should be made dependent on ATTR_UPDTIMES, and
explicit time updates left alone.

Miklos
