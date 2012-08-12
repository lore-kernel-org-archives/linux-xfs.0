Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7C7nwcV084781 for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 02:49:58 -0500
Received: from mx4.geneon.de (76.reverse.geneon.de [89.244.16.76]) by
	cuda.sgi.com with ESMTP id qAq77m051TApREPe for
	<xfs@oss.sgi.com>; Sun, 12 Aug 2012 00:49:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mx4.geneon.de (Postfix) with ESMTP id 6CE3B209C77
	for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 09:44:03 +0200 (CEST)
Received: from mx4.geneon.de ([127.0.0.1])
	by localhost (mx4 [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 31601-02-2 for <xfs@oss.sgi.com>;
	Sun, 12 Aug 2012 09:44:03 +0200 (CEST)
Received: from galaxy.nbg.geneon.de (backupnas [89.244.16.77])
	by mx4.geneon.de (Postfix) with ESMTP id 50F2A87431
	for <xfs@oss.sgi.com>; Sun, 12 Aug 2012 09:44:03 +0200 (CEST)
From: Andreas Vogler <andreas.vogler@geneon.de>
Date: Sun, 12 Aug 2012 09:49:48 +0200
Subject: AW: bad version from xfs_repair after raid crash
Message-ID: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E98@COSMOS.nbg.geneon.de>
References: <27CE2179D1925A4F9F4874725C3B4E0F0C5EFB6E94@COSMOS.nbg.geneon.de>
	<5026D290.10209@sandeen.net>
In-Reply-To: <5026D290.10209@sandeen.net>
Content-Language: de-DE
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


> Is your xfsprogs version up to date?


I guess the xfsprogs are rather old but they should be on the same level as the filesystem as they are part oft he same distro (OpenFiler 2.3, package is called xfsprogs=2.6.25-4-0.1).

> You could also include another email with the output from xfs_db -c "sb 0" -c "p" /dev/blah

Here ist he output of xfs_db:

magicnum = 0x58465342
blocksize = 4096
dblocks = 332800000
rblocks = 0
rextents = 0
uuid = 567f4c2f-ce9a-42a3-bbc2-e791cf43f8ae
logstart = 268435460
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 83200000
agcount = 4
rbmblocks = 0
logblocks = 32768
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 27
rextslog = 0
inprogress = 0
imax_pct = 5
icount = 1079360
ifree = 80
fdblocks = 178779506
frextents = 0
uquotino = 131
gquotino = 132
qflags = 0x77
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0x8

But I have already experimented a little bit, originally versionnum was 0xb4f4 but the next superblock (sb 1) contained 0xb4a4, so I tried to set it with xfs_db to this value, but it didn't make a difference.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
