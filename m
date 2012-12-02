Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB2Nglwf024617 for <xfs@oss.sgi.com>; Sun, 2 Dec 2012 17:42:48 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id Uu6EIgkBMjpRAeDN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Dec 2012 15:45:07 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.13544916421877@bugs.debian.org>
Message-ID: <50BBE4BC.3060708@talbragar.com.au>
Date: Mon, 03 Dec 2012 10:31:08 +1100
From: Pat Emblen <support@talbragar.com.au>
MIME-Version: 1.0
Reply-To: Pat Emblen <support@talbragar.com.au>, 694624@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: 694624@bugs.debian.org

Well it's your call, but I'll make my case for changing it.
- I think it is very dangerous default behaviour, particularly in 
scripts as it can prevent
the possibility of logging in to unfreeze a frozen root.
- The docs all strongly imply that it operates on mountpoints, so surely 
not many people
would have diliberately used it on general paths?"
         xfs_freeze -f | -u mount-point"
"The mount-point argument is the pathname of  the  directory  where  the
        file system  is  mounted."
- Because of the name and the wording of the man page, you don't expect 
xfs_freeze to
freeze an ext4 file system that isn't even mounted on the path you pass 
to it?!
- It's logical to have it work on mountpoints only. You wouldn't expect 
umount or fdisk to
work the same way? Do any other partition level tools work this way?
- At the very least I would expect it to require a 'force' option if it 
was going to freeze
the root system.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
