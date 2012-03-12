Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CM1D1D147656 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 17:01:13 -0500
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id 24dhAss8bslmybcS for
	<xfs@oss.sgi.com>; Mon, 12 Mar 2012 15:01:12 -0700 (PDT)
Subject: repeatable attribute corruption
From: Roger Willcocks <roger@filmlight.ltd.uk>
Date: Mon, 12 Mar 2012 22:00:15 +0000
Message-Id: <1331589615.25204.35.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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

Hi folks,

On stock CentOS kernels from 5.5 (earliest I tried) through to the
latest 6.2 kernel (as of five days ago) 2.6.32-220.7.1.el6.x86_64 I can
repeatedly create a silent on-disk corruption. This typically shows up
later as:

XFS internal error xfs_da_do_buf(1) at line 2020 of
file /usr/src/redhat/BUILD/kernel-2.6.18/linux-2.6.18.x86_64/fs/xfs/xfs_da_btree.c

(or line 2112 of the same file).

The 'before' metadump is a bit big to attach to an email (~600k) so
here's a download link valid for 30 days -

http://private.filmlight.ltd.uk/c4c864ecca4ac13b/xfs_attrib_crash.taz

- this is a gzip-compressed tar file containing 

-rw-r--r--.  1 root root   10885632 Mar 12 18:02 xfs_metadump_hda6
-rw-r--r--.  1 root root       3558 Mar 12 18:15 zap.txt

The metadump expands to about 5GB. xfs_repair believes it to be clean.
I've not obfuscated the dump; it was originally a copy of the linux
header directory from the 5.5 kernel.

'zap.txt' simply overwrites a single existing extended (directory)
attribute with a slightly longer value. So, steps to repeat:

# xfs_mdrestore xfs_metadump_hda6 xfs.img 
# mkdir /mnt/disk1
# mount -o loop xfs.img /mnt/disk1
# setfattr --restore=zap.txt
# umount /mnt/disk1
# xfs_repair -n xfs.img
...
bad sibling back pointer for block 4 in attribute fork for inode 131
problem with attribute contents in inode 131
would clear attr fork
bad nblocks 8 for inode 131, would reset to 3
bad anextents 4 for inode 131, would reset to 0
...

-- 
Roger Willcocks <roger@filmlight.ltd.uk>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
