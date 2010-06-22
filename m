Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MEY7vZ241771 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:34:08 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B202E131A44E
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 07:40:57 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id aL9tnQJEVNx3UBLi for <xfs@oss.sgi.com>;
	Tue, 22 Jun 2010 07:40:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id 2E072BB1F
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 16:36:45 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CXwukQLb4pLt for <xfs@oss.sgi.com>;
	Tue, 22 Jun 2010 16:36:43 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id E332FBA45
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 16:36:42 +0200 (CEST)
Message-ID: <cone.1277217402.916517.87295.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: advice for repair after IO error on raid device
Date: Tue, 22 Jun 2010 16:36:42 +0200
Mime-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi list,

I recently I had a failed disk in a raid6 setup, which resulted in an IO 
error, which in turn caused XFS to shut down with the messages below.

I've seen on this list that incorrect use of xfs_repair might damage the fs 
even more, so I would like to ask for some advice on the best way to 
proceed.

Currently I have unmounted the filesystem, replaced the failed disk and 
rebuilt the raid array. I am upgrading xfstools to their latest version (the 
current version is 2.9.8). Any hints on how to continue would be highly 
appreciated.

Background: This is a Fedora Core 3 machine, with a vanilla 2.6.31 kernel.
The raid setup consists of 24x2TB disks in a raid6 setup. We use it to store 
our backup snapshots and the entire volume is written to tape once a week.

Thanks in advance,

roel

Jun 21 23:23:59 backup2 kernel: arcmsr6: abort device command of scsi id = 0 lun = 0
Jun 21 23:24:10 backup2 kernel: arcmsr6: ccb ='0xffff8800cb88ad40'????????????????????????????? isr got aborted command
Jun 21 23:24:10 backup2 kernel: arcmsr6: isr get an illegal ccb command???????????????????????????????? done acb = '0xffff880231c90408'ccb = '0xffff8800cb88ad40' ccbacb = '0xffff880231c90408' startdone = 0x0 ccboutstandingcount = 1
Jun 21 23:24:10 backup2 kernel: sd 6:0:0:0: [sdb] Unhandled error code
Jun 21 23:24:10 backup2 kernel: sd 6:0:0:0: [sdb] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
Jun 21 23:24:10 backup2 kernel: end_request: I/O error, dev sdb, sector 12887056410
Jun 21 23:24:10 backup2 kernel: I/O error in filesystem ("sdb1") meta-data dev sdb1 block 0x30020dff8?????? ("xfs_trans_read_buf") error 5 buf count 4096
Jun 21 23:24:10 backup2 kernel: xfs_force_shutdown(sdb1,0x1) called from line 414 of file fs/xfs/xfs_trans_buf.c.? Return address = 0xffffffffa0168eaf
Jun 21 23:24:10 backup2 kernel: xfs_force_shutdown(sdb1,0x2) called from line 811 of file fs/xfs/xfs_log.c.? Return address = 0xffffffffa015c35f
Jun 21 23:24:10 backup2 kernel: Filesystem "sdb1": I/O Error Detected.? Shutting down filesystem: sdb1
Jun 21 23:24:10 backup2 kernel: Please umount the filesystem, and rectify the problem(s)
Jun 21 23:24:20 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.
Jun 21 23:24:50 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.
Jun 21 23:25:20 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
