Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q582t2FH161359 for <xfs@oss.sgi.com>; Thu, 7 Jun 2012 21:55:02 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 6kQPvatInPuiDhCx for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 19:54:59 -0700 (PDT)
Message-ID: <4FD16983.5090901@sandeen.net>
Date: Thu, 07 Jun 2012 21:54:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: attr vs. getfattr
References: <alpine.DEB.2.01.1206070508580.5568@trent.utfs.org>
In-Reply-To: <alpine.DEB.2.01.1206070508580.5568@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On 6/7/12 7:26 AM, Christian Kujau wrote:
> Hi,
> 
> I have an issue with extended attributes on this machine (Debian/stable, 
> 2.6.32-5-amd64). This box is slowly being moved towards fully SELinux 
> enabled and apparently some files have been labelled with SELinux 
> attributes:
> 
> ---------
> # ls -l vnstat.conf
> -rw-r--r--. 2 root root 2890 Jan 15 04:05 vnstat.conf
> 
> # ls -lZ vnstat.conf
> -rw-r--r--. 2 root root unconfined_u:object_r:etc_t:s0 2890 Jan 15 04:05 vnstat.conf
> ---------
> 
> OK. But when I actually want to see the attributes, this happens:
> 
> ---------
> # getfattr --dump vnstat.conf
> ---------
> 
> I.e. "nothing" is printed. I understand there's "attr" specifically for 
> XFS filesystems and at least it displays that there *is* an attribute 
> stored, but it cannot get its value:

By default it's looking at the user namespace.  You want to look at security (or all) with -m:

[root@inode ~]# getfattr -m "^security\\." -d /sbin/modprobe
getfattr: Removing leading '/' from absolute path names
# file: sbin/modprobe
security.selinux="system_u:object_r:insmod_exec_t:s0"

[root@inode ~]# getfattr -m - -d /sbin/modprobe
getfattr: Removing leading '/' from absolute path names
# file: sbin/modprobe
security.selinux="system_u:object_r:insmod_exec_t:s0"

> ---------
> # attr -l vnstat.conf
> Attribute "selinux" has a 31 byte value for vnstat.conf
> 
> # attr -g selinux vnstat.conf 
> attr_get: No data available
> Could not get "selinux" for vnstat.conf

You need to tell it to use the security namespace w/ -S:

# attr -S -g selinux  /sbin/modprobe 
Attribute "selinux" had a 35 byte value for /sbin/modprobe:
system_u:object_r:insmod_exec_t:s0

> ---------
> 
> Now that I know the attribute's name, I try to use "getfattr" to display 
> its value:
> 
> ---------
> # getfattr -n selinux vnstat.conf
> vnstat.conf: selinux: Operation not supported

# getfattr -n security.selinux /sbin/modprobe
getfattr: Removing leading '/' from absolute path names
# file: sbin/modprobe
security.selinux="system_u:object_r:insmod_exec_t:s0"


> via strace:
> 
> getxattr("vnstat.conf", "selinux", 0x0, 0) = -1 EOPNOTSUPP (Operation not supported)
> ---------
> 
> Can someone explain to me what's going on? The reason for all this that I 
> actually want to remove the selinux attributes from some directories[0], 
> but this isn't working either:
> 
> ---------
> # attr -r selinux vnstat.conf 
> attr_remove: No data available
> Could not remove "selinux" for vnstat.conf
> ---------

# attr -S -r selinux vnstat.conf, I think, but I get permission denied.

> Tbh, I'm not too savvy with SELinux, but the system is in "permissive" 
> mode, so it should not interfere:
> 
> ---------
> # getenforce
> Permissive
> 
> # df -h .
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/data       27G   25G  1.6G  95% /data
> 
> # grep /data /proc/mounts
> /dev/mapper/data /data xfs rw,seclabel,nosuid,nodev,relatime,attr2,nobarrier,noquota 0 0
> # grep /data /etc/mtab
> /dev/mapper/data /data xfs rw,nosuid,nodev,nobarrier 0 0
> 
> # grep _XFS /boot/config-2.6.32-5-amd64 
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> ---------
> 
> Anyone got an idea what's going on here/what I am missing?

A lot of manpage reading and intuition-following and namespace-remembering.  ;)

It is kind of messy.  :(

-Eric

> Thanks,
> Christian.
> 
> [0] Why? Because I want to rsync from a remote machine, where
>     the files do NOT have SELinux attributes. In essence the same
>     scenario as in https://bugzilla.redhat.com/show_bug.cgi?id=461486

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
