Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN1pDo8069794 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:51:14 -0600
Received: from mx1.u-picardie.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E199219DFE
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:53:10 -0800 (PST)
Received: from mx1.u-picardie.fr (mx1.u-picardie.fr [193.49.184.7]) by
	cuda.sgi.com with ESMTP id dPKCeVAW1RlN0ykj for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:53:10 -0800 (PST)
Received: from mailx.u-picardie.fr (oban.u-picardie.fr [193.49.184.8])
	by mx1.u-picardie.fr (Postfix) with ESMTP id 8B5A678016
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 02:53:09 +0100 (CET)
Received: from passoire.u-picardie.fr (passoire.u-picardie.fr [193.49.184.121])
	by mailx.u-picardie.fr (Postfix) with ESMTP id 69855580F8
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 02:53:09 +0100 (CET)
Received: from mailx.u-picardie.fr ([193.49.184.8])
	by passoire.u-picardie.fr (passoire.u-picardie.fr [193.49.184.121])
	(amavisd-new, port 10024)
	with LMTP id RHIS5semI6dl for <xfs@oss.sgi.com>;
	Thu, 23 Dec 2010 02:53:08 +0100 (CET)
Received: from ezri.u-picardie.fr (ezri.u-picardie.fr [193.49.184.104])
	by mailx.u-picardie.fr (Postfix) with ESMTP id 370D558105
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 02:53:08 +0100 (CET)
From: laurent+xfs@u-picardie.fr
Subject: able to mount a fs, unable to repair it
Date: Thu, 23 Dec 2010 02:53:08 +0100
Message-ID: <87r5d9uuez.fsf@ezri.u-picardie.fr>
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


Hi !

For a reason all my xfs FS got corrupted at the same time.
My setup is: xen host using lvm on top of soft raid6 on top of jbod
3ware connected sata disks.
Both the host and the VM fs got corrupted.

ATM host is using 2.6.32 (debian/squeeze), xfsprogs are 3.1.4

I've had 2 kinds of corruptions:
1) unable to mount the FS, been able to xfs_repair -L
2) able to mount the FS, xfs_check was reporting errors, unable to
xfs_repair the fs

For most of the FS, i've managed to either mkfs.xfs or xfs_repair then
rsync from the backup.

I'm left with my 1.5TB fs for which i also have a full backup, i'm
able to mount it (no kernel error or anything when
mounting it). xfs_check on this unmounted FS gives errors. xfs_repair
(after a long long time) is unable to find a suitable thingie to
repair the FS.

https://gist.github.com/752411 xfs_{db,check,repair,metadump} results.
(haven't checked the memory/disk usage when doing the metadump)

I can't really tell why all this happened in the first place.
Been having power supply issues some weeks ago, been upgrading from
lenny to squeeze, been playing with xen & lxc at the same, been doing
my xmas shopping a bit late ! :-)

I'd be curious to know how to repair the 1.5TB FS, any idea on what i
could do ?

TIA

-- 
Laurent

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
