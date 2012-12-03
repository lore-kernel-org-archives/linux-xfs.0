Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3Nsjn2070307 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:54:45 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id ctqK5G7WdVcRivHF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Dec 2012 15:57:06 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B694624.13545788459726@bugs.debian.org>
Message-ID: <50BD3B94.4070505@talbragar.com.au>
Date: Tue, 04 Dec 2012 10:53:56 +1100
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

 > If you are running scripts remotely and they don't handle errors
 > properly, then that's your problem....

OK, can you then fix the man page to describe the real behaviour of the
program so that users have a chance to intelligently decide what error
checking to do in their scripts.
I.E the argument isn't a mount point, it's a path, and perhaps use
'filesystem' rather than 'xfs' consistently.

 > If you can't unfreeze the root filesystem by running xfs-freeze -u
 > immediately afterwards then that's a filesystem bug, not a problem
 > with the userspace command.

It may also be a good idea to point out in the man page that you should be
extremely careful running this if you are not logged in interactively, 
even a
disconnected ssh session will prevent you running xfs_freeze -u to manually
unfreeze the root filesystem.
Thanks
Pat Emblen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
