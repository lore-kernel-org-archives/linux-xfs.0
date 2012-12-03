Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Lmhji028445 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 15:48:43 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id K4ra9rV4Uynrs6qo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Dec 2012 13:51:05 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.135457131917921@bugs.debian.org>
Date: Tue, 4 Dec 2012 08:48:33 +1100
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20121203214833.GB32450@dastard>
References: <50BBE4BC.3060708@talbragar.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50BBE4BC.3060708@talbragar.com.au>
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

On Mon, Dec 03, 2012 at 10:31:08AM +1100, Pat Emblen wrote:
> Well it's your call, but I'll make my case for changing it.
> - I think it is very dangerous default behaviour, particularly in
> scripts as it can prevent
> the possibility of logging in to unfreeze a frozen root.

If you are running scripts remotely and they don't handle errors
properly, then that's your problem....

> - The docs all strongly imply that it operates on mountpoints, so
> surely not many people
> would have diliberately used it on general paths?"

I use it that way all the time. I didn't even realise the man page
says "mount points only".....

>         xfs_freeze -f | -u mount-point"
> "The mount-point argument is the pathname of  the  directory  where  the
>        file system  is  mounted."
> - Because of the name and the wording of the man page, you don't
> expect xfs_freeze to
> freeze an ext4 file system that isn't even mounted on the path you
> pass to it?!

Yes, I do expect it to freeze the filesystem under the directory
that is passed, regardless of whether it is a mount point or not.
The man page is wrong.

For example, when you have a directory tree quota set up and
exported by NFS, the users will only know the export path of the
root of the directory tree, and they expect that to behave as if
that is a filesystem mounted at that point. Hence we have to be able
to support freeze being issued at such locations, not just the root
of the filesystem.

FWIW, fsfreeze says exactly the same thing in the man page, but
behaves identically to xfs_freeze...

> - It's logical to have it work on mountpoints only. You wouldn't
> expect umount or fdisk to
> work the same way? Do any other partition level tools work this way?

No, but filesystem utilities are not partition level tools and
expecting them to work the same way is incorrect.

> - At the very least I would expect it to require a 'force' option if
> it was going to freeze
> the root system.

If you can't unfreeze the root filesystem by running xfs-freeze -u
immediately afterwards then that's a filesystem bug, not a problem
with the userspace command.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
