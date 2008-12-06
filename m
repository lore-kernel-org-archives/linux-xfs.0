Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB62aCRB002567 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 20:36:13 -0600
Received: from bob.dscon.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1786E16C792C
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 18:36:11 -0800 (PST)
Received: from bob.dscon.sk (bob.dscon.sk [88.86.113.10]) by cuda.sgi.com with
	ESMTP id 2rIAEUWyhdIiJDWX for <xfs@oss.sgi.com>;
	Fri, 05 Dec 2008 18:36:11 -0800 (PST)
Date: Sat, 6 Dec 2008 03:36:09 +0100
Subject: kernel 2.6.27.7 problem
Message-ID: <20081206023608.GA22135@bob.dscon.sk>
MIME-Version: 1.0
Content-Disposition: inline
From: xfs@bob.dscon.sk (DS)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

I have trouble with xfs after upgrade kernel 2.6.24.3 -> 2.6.27.7.

Message on console:
 end_request: I/O error, dev sde, sector 351572544
 I/O error in filesystem ("sde1") meta-data dev sde1 block 0x14f49201
 ("xlog_iodone") error 5 buf count 9728
 xfs_force_shutdown(sde1,0x2) called from line 1056 of file
 fs/xfs/xfs_log.c.  Return address = 0xffffffff80373233
 Filesystem "sde1": Log I/O Error Detected.  Shutting down filesystem:
 sde1
 Please umount the filesystem, and rectify the problem(s)


Remount is possible, but filesystem hangs up again.
After xfs_repair too.
It looks OK now after rebooting to old kernel.

On other similar system (same  disk array, other vol) I use 2.6.27.6 kernel  without problems.


System:
AMD x64, debian stable (etch)
filesytem is on iSCSI  storage

mount options:
rw,noatime,nodiratime,logbsize=256k,logbufs=8,quota

xfs_info:
meta-data=/dev/sde1              isize=256    agcount=16, agsize=5493104
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=87889584,
imaxpct=25
         =                       sunit=16     swidth=112 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


Any ideas.
Thanx

Dusan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
