Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JAE3qs201824 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 05:14:16 -0500
Received: from mail.galactic.com.hk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6105C3DFBC8
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 03:14:41 -0700 (PDT)
Received: from mail.galactic.com.hk (galactic.com.hk [211.154.134.176]) by
	cuda.sgi.com with ESMTP id syVJ9b4tWPvhH1pc for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 03:14:41 -0700 (PDT)
Received: from galactic.com.hk (localhost [127.0.0.1])
	by mail.galactic.com.hk (8.13.4/8.13.4) with ESMTP id n7JAL9vg018386
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 18:21:17 +0800
From: "Frank Peng" <fpeng@galactic.com.hk>
Subject: xfs_quota: cannot set limits.Why ?
Date: Wed, 19 Aug 2009 18:21:09 +0800
Message-Id: <20090819101701.M38080@galactic.com.hk>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Dear sir,

linux-nr79:~ # cat /etc/issue
Welcome to openSUSE 11.1 - Kernel \r (\l).

linux-nr79:/boot # cat config-2.6.27.7-9-default | grep XFS
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_DMAPI=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_VXFS_FS=m

linux-nr79:~ # mount /dev/sdc1 /xfs
linux-nr79:~ # mount -o remount,usrquota,grpquota /xfs

linux-nr79:~ # mount
/dev/sda2 on / type ext3 (rw,acl,user_xattr)
/proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
fusectl on /sys/fs/fuse/connections type fusectl (rw)
securityfs on /sys/kernel/security type securityfs (rw)
/dev/sdc2 on /ext3 type ext3 (rw,usrquota,grpquota)
/dev/sdc1 on /xfs type xfs (rw,usrquota,grpquota)

linux-nr79:~ # xfs_quota -x -c 'limit bsoft=5m bhard=6m user01' /xfs
xfs_quota: cannot set limits: Function not implemented

Why cannot set limits? Any idea how I can use xfs quota? 
Thanks.


Best Regards,
Frank

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
