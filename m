Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q57CR3cA098202 for <xfs@oss.sgi.com>; Thu, 7 Jun 2012 07:27:03 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id 3CoRkFG0NShFwbny for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 05:27:01 -0700 (PDT)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 1A1423DB87
	for <xfs@oss.sgi.com>; Thu,  7 Jun 2012 14:27:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id F098A3DB17
	for <xfs@oss.sgi.com>; Thu,  7 Jun 2012 14:26:59 +0200 (CEST)
Date: Thu, 7 Jun 2012 05:26:59 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: attr vs. getfattr
Message-ID: <alpine.DEB.2.01.1206070508580.5568@trent.utfs.org>
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

Hi,

I have an issue with extended attributes on this machine (Debian/stable, 
2.6.32-5-amd64). This box is slowly being moved towards fully SELinux 
enabled and apparently some files have been labelled with SELinux 
attributes:

---------
# ls -l vnstat.conf
-rw-r--r--. 2 root root 2890 Jan 15 04:05 vnstat.conf

# ls -lZ vnstat.conf
-rw-r--r--. 2 root root unconfined_u:object_r:etc_t:s0 2890 Jan 15 04:05 vnstat.conf
---------

OK. But when I actually want to see the attributes, this happens:

---------
# getfattr --dump vnstat.conf
---------

I.e. "nothing" is printed. I understand there's "attr" specifically for 
XFS filesystems and at least it displays that there *is* an attribute 
stored, but it cannot get its value:

---------
# attr -l vnstat.conf
Attribute "selinux" has a 31 byte value for vnstat.conf

# attr -g selinux vnstat.conf 
attr_get: No data available
Could not get "selinux" for vnstat.conf
---------

Now that I know the attribute's name, I try to use "getfattr" to display 
its value:

---------
# getfattr -n selinux vnstat.conf
vnstat.conf: selinux: Operation not supported

via strace:

getxattr("vnstat.conf", "selinux", 0x0, 0) = -1 EOPNOTSUPP (Operation not supported)
---------

Can someone explain to me what's going on? The reason for all this that I 
actually want to remove the selinux attributes from some directories[0], 
but this isn't working either:

---------
# attr -r selinux vnstat.conf 
attr_remove: No data available
Could not remove "selinux" for vnstat.conf
---------

Tbh, I'm not too savvy with SELinux, but the system is in "permissive" 
mode, so it should not interfere:

---------
# getenforce
Permissive

# df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/data       27G   25G  1.6G  95% /data

# grep /data /proc/mounts
/dev/mapper/data /data xfs rw,seclabel,nosuid,nodev,relatime,attr2,nobarrier,noquota 0 0
# grep /data /etc/mtab
/dev/mapper/data /data xfs rw,nosuid,nodev,nobarrier 0 0

# grep _XFS /boot/config-2.6.32-5-amd64 
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
---------

Anyone got an idea what's going on here/what I am missing?

Thanks,
Christian.

[0] Why? Because I want to rsync from a remote machine, where
    the files do NOT have SELinux attributes. In essence the same
    scenario as in https://bugzilla.redhat.com/show_bug.cgi?id=461486
-- 
BOFH excuse #359:

YOU HAVE AN I/O ERROR -> Incompetent Operator error

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
