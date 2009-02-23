Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NKft7T109261 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:41:55 -0600
Received: from smtp1.es.uci.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02E0A1990218
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 12:41:22 -0800 (PST)
Received: from smtp1.es.uci.edu (smtp1.es.uci.edu [128.200.80.34]) by
	cuda.sgi.com with ESMTP id 7V19JLTERH2dAHWC for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 12:41:22 -0800 (PST)
Received: from bongo.nac.uci.edu (bongo.nac.uci.edu [128.200.34.98])
	(authenticated bits=0)
	by smtp1.es.uci.edu (8.13.1/8.13.1) with ESMTP id n1NKfLFm009295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 12:41:22 -0800
Subject: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
Content-Disposition: inline
From: Harry Mangalam <harry.mangalam@uci.edu>
Date: Mon, 23 Feb 2009 12:43:33 -0800
MIME-Version: 1.0
Message-Id: <200902231243.33897.harry.mangalam@uci.edu>
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

Here's an unusual (long) tale of woe.

We had a USRobotics 8700 NAS appliance with 4 SATA disks in RAID5:
 <http://www.usr.com/support/product-template.asp?prod=8700>
which was a fine (if crude) ARM-based Linux NAS until it stroked out 
at some point, leaving us with a degraded RAID5 and comatose NAS 
device.

We'd like to get the files back of course and I've moved the disks to 
a Linux PC, hooked them up to a cheap Silicon Image 4x SATA 
controller and brought up the whole frankenmess with mdadm.  It 
reported a clean but degraded array.

(much mdadm stuff deleted)

Shortening this up considerably, I was able to get the RAID5 
reconstituted with a new disk, but was not so fortunate with the 
filesystem.

The docs and files on the USR web site imply that the native 
filesystem was originally XFS, but when I try to mount it as such, I 
can't:

mount -vvv -t xfs /dev/md1 /mnt
mount: fstab path: "/etc/fstab"
mount: lock path:  "/etc/mtab~"
mount: temp path:  "/etc/mtab.tmp"
mount: no LABEL=, no UUID=, going to mount /dev/md1 by path
mount: spec:  "/dev/md1"
mount: node:  "/mnt"
mount: types: "xfs"
mount: opts:  "(null)"
mount: mount(2) syscall: source: "/dev/md1", target: "/mnt", 
filesystemtype: "xfs", mountflags: -1058209792, data: (null)
mount: wrong fs type, bad option, bad superblock on /dev/md1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

and when I check dmesg:
[  245.008000] SGI XFS with ACLs, security attributes, realtime, large 
block numbers, no debug enabled
[  245.020000] SGI XFS Quota Management subsystem
[  245.020000] XFS: SB read failed
[  327.696000] md: md0 stopped.
[  327.696000] md: unbind<sdc1>
[  327.696000] md: export_rdev(sdc1)
[  327.696000] md: unbind<sde1>
[  327.696000] md: export_rdev(sde1)
[  327.696000] md: unbind<sdd1>
[  327.696000] md: export_rdev(sdd1)
[  439.660000] XFS: bad magic number
[  439.660000] XFS: SB validate failed

repeated attempts repeat the last 2 lines above.  This implies that 
the superblock is bad and xfs_repair also reports that:
xfs_repair /dev/md1
        - creating 2 worker thread(s)
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
...... <lots of ...>  ... 
..found candidate secondary superblock...
unable to verify superblock, continuing...
<lots of ...>  ... 
...found candidate secondary superblock...
unable to verify superblock, continuing...
<lots of ...>  ... 

So my question is what should I do now?  Neil Brown (mdadm author) 
suggested that Dave Chinner had investigated this in some other cases 
and had found that the Vendors of a number of such ARM-based NAS 
appliances had mucked up the implementation of XFS such that this 
situation is just a no-win.

I did find a few reports of people who had similar ARM-based XFS 
filesystems with similar problems but could not find any successful 
resolution.  The vendor has not responded to emails about this.

Any suggestions (other than restore from (nonexistant) backups)?

Harry



-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
