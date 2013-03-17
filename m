Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5976A7F69
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 18:22:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 332D5304053
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 16:22:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6lZJjUhlK0cRWQMg for <xfs@oss.sgi.com>;
	Sun, 17 Mar 2013 16:22:11 -0700 (PDT)
Date: Mon, 18 Mar 2013 10:20:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs_repair and journalling
Message-ID: <20130317232005.GK6369@dastard>
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Sun, Mar 17, 2013 at 05:12:36PM +0530, Subranshu Patel wrote:
> What I understand is that, XFS being a journalling filesystem makes running
> xfs_repair after a unclean unmount unnecessary.

Correct.

> After a system crash or force power down, one can mount the filesystem
> which causes the journal to be replayed and handles the half finished
> writes.

What "half finished writes"? The journal replays only completely
written checkpoints. It tosses away half written writes because they
are not complete and so replaying them will result in filesystem
corruption....

> This is one part. But there can be other file corruption as well
> and these can be handled by xfs_repair.

I think you don't understand how OS level writeback caching works.
You will *lose* data on a power failure unless the application
spcifically writes it to disk with fdatasync/fsync(). This has
nothing to do with the filesystem, nor journal replay.  If the
application uses fsync, then the data on disk is consistent with
what is in the journal, so after journal replay, the data is there
on disk.

xfs_reapir is not full of magic pixie dust that miraculously
recovers data that was never written to disk....

> In case of EXT4, journal will not be replayed on performing mount. One need
> to invoke fsck which performs journal playback and then other corruption
> checks/recovery.
> Correct me if I am wrong.

ext4 behaves like this, but your basic assumption that fsck.ext4
performs data recovery/repair is wrong, same as for your assumption
that xfs_repair does this for XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
