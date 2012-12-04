Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB42FhUx082366 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 20:15:43 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id A3Vff5jg6qAxZIN6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Dec 2012 18:18:04 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.13545873234143@bugs.debian.org>
Date: Tue, 4 Dec 2012 13:15:11 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20121204021511.GC32450@dastard>
References: <50BD3B94.4070505@talbragar.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50BD3B94.4070505@talbragar.com.au>
Reply-To: Dave Chinner <david@fromorbit.com>, 694624@bugs.debian.org
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
To: Pat Emblen <support@talbragar.com.au>, 694624@bugs.debian.org

On Tue, Dec 04, 2012 at 10:53:56AM +1100, Pat Emblen wrote:
> > If you are running scripts remotely and they don't handle errors
> > properly, then that's your problem....
> 
> OK, can you then fix the man page to describe the real behaviour of the
> program so that users have a chance to intelligently decide what error
> checking to do in their scripts.
>
> I.E the argument isn't a mount point, it's a path,

Patches to fix the documentation are welcome...

> and perhaps use
> 'filesystem' rather than 'xfs' consistently.

>From the man page:

    In  Linux  kernel  version  2.6.29,  the interface which XFS
    uses to freeze and unfreeze was elevated to the VFS, so that
    this tool can now be used on many other Linux filesystems.


> > If you can't unfreeze the root filesystem by running xfs-freeze -u
> > immediately afterwards then that's a filesystem bug, not a problem
> > with the userspace command.
> 
> It may also be a good idea to point out in the man page that you should be
> extremely careful running this if you are not logged in
> interactively, even a
> disconnected ssh session will prevent you running xfs_freeze -u to manually
> unfreeze the root filesystem.

Sure. Patches are welcome. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
