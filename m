Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D15687FB6
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:27:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A38768F8068
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 13:27:36 -0800 (PST)
Received: from smtp.tsag.net (smtp.tsag.net [208.118.68.4]) by cuda.sgi.com
	with ESMTP id V3tBUwxin0hScJoT for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 13:27:34 -0800 (PST)
From: Gerard Beekmans <GBeekmans@tsag.net>
Subject: RE: Unable to mount and repair filesystems
Date: Thu, 29 Jan 2015 21:27:32 +0000
Message-ID: <D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
In-Reply-To: <54CA9586.1010607@sandeen.net>
Content-Language: en-US
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

> -----Original Message-----
> Are you certain that the volume / storage behind dm-9 is in decent shape?
> (i.e. is it really even an xfs filesystem?)

The question "is it in decent shape" is probably the million dollar question.

What I do know is this:

* It's all LVM based
* The first problem partition is /dev/data/srv which in turn is a symlink to /dev/dm-9
* The second problem partition is /dev/os/opt which in turn is a symlink to /dev/dm-7

Both were originally formatted as XFS and /etc/fstab has same. Now I can' t be sure if the symlinks were always dm-7 and dm-9.

Comparing what "lvdisplay" tell in terms of block device major & minor numbers and compare to the dm-* symlinks, they all match up. So by all accounts it ought to be correct.

Running xfs_db on those two partitions shows what I understand to be the "right stuff" aside from an error when it first runs:

# xfs_db /dev/os/opt
Metadata corruption detected at block 0x4e2001/0x200
xfs_db: cannot init perag data (117). Continuing anyway.
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 3133440
rblocks = 0
rextents = 0
uuid = b4ab7d1d-d383-4c49-af2c-be120ff967a7
logstart = 262148
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 128000
agcount = 25
rbmblocks = 0
logblocks = 2560
versionnum = 0xb4b4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "opt\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 17
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 576
ifree = 135
fdblocks = 3079156
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x8a
bad_features2 = 0x8a
features_compat = 0
features_ro_compat = 0
features_incompat = 0
features_log_incompat = 0
crc = 0 (correct)
pquotino = 0
lsn = 0

> A VM crashing definitely should not result in a badly corrupt/unmountable
> filesystem.
> 
> Is there any other interesting part of the story? :)

The full setup is as follows:

The VM question is a VMware guest running on a vmware cluster. The actual files that make up the VM is stored on a SAN that VMware accesses via NFS.

The outage occurred at the SAN level making the NFS storage unavailable which in turn turned off all the VMs running on it (turned off in the virtual sense).

~50 VMs then were brought online and none had any serious issues. Most needed a form of fsck to bring things back to consistency. This is the only VM that suffered the way it did. Other VMs are a mix of Linux, BSD, OpenSolaris and Windows with all their varieties of filesystems (ext3, ext4, xfs, ntfs and so on).

It is possible that it is the vmware VMDK file that belongs to this VM that is the issue but it does not appear to be corrupt from a vmdk standpoint. Just the data inside of it.

Gerard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
