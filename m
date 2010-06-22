Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MEoth5242322 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:50:55 -0500
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED468159FA4E
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 07:57:47 -0700 (PDT)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id h2Xpa1NquZvdN5pE for <xfs@oss.sgi.com>;
	Tue, 22 Jun 2010 07:57:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id F2A74BB1F
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 16:53:34 +0200 (CEST)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m-YZayhbAN58 for <xfs@oss.sgi.com>;
	Tue, 22 Jun 2010 16:53:32 +0200 (CEST)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id B2458BA18
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 16:53:32 +0200 (CEST)
References: <cone.1277217402.916517.87295.1001@bork.lsof.org>
Message-ID: <cone.1277218412.674723.87295.1001@bork.lsof.org>
From: Roel van Meer <rolek@bokxing.nl>
Subject: Re: advice for repair after IO error on raid device
Date: Tue, 22 Jun 2010 16:53:32 +0200
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

Roel van Meer writes:

> Currently I have unmounted the filesystem, replaced the failed disk and 
> rebuilt the raid array. I am upgrading xfstools to their latest version (the 
> current version is 2.9.8). Any hints on how to continue would be highly 
> appreciated.

Trying to answer my own question. I _think_ this is the way to go:

1) Mount and unmount the fs, in order to replay the log.
2) Run xfs_repair -n
3) Run xfs_repair

If someone could confirm (or reject) that, that would be great.

(By the way, is it necessary to run xfs_repair with -n first? If not, are 
there advantages that would justify the extra time it takes?)

Thanks again,

roel


> Jun 21 23:23:59 backup2 kernel: arcmsr6: abort device command of scsi id = 0 lun = 0
> Jun 21 23:24:10 backup2 kernel: arcmsr6: ccb ='0xffff8800cb88ad40'????????????????????????????? isr got aborted command
> Jun 21 23:24:10 backup2 kernel: arcmsr6: isr get an illegal ccb command???????????????????????????????? done acb = '0xffff880231c90408'ccb = '0xffff8800cb88ad40' ccbacb = '0xffff880231c90408' startdone = 0x0 ccboutstandingcount = 1
> Jun 21 23:24:10 backup2 kernel: sd 6:0:0:0: [sdb] Unhandled error code
> Jun 21 23:24:10 backup2 kernel: sd 6:0:0:0: [sdb] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> Jun 21 23:24:10 backup2 kernel: end_request: I/O error, dev sdb, sector 12887056410
> Jun 21 23:24:10 backup2 kernel: I/O error in filesystem ("sdb1") meta-data dev sdb1 block 0x30020dff8?????? ("xfs_trans_read_buf") error 5 buf count 4096
> Jun 21 23:24:10 backup2 kernel: xfs_force_shutdown(sdb1,0x1) called from line 414 of file fs/xfs/xfs_trans_buf.c.? Return address = 0xffffffffa0168eaf
> Jun 21 23:24:10 backup2 kernel: xfs_force_shutdown(sdb1,0x2) called from line 811 of file fs/xfs/xfs_log.c.? Return address = 0xffffffffa015c35f
> Jun 21 23:24:10 backup2 kernel: Filesystem "sdb1": I/O Error Detected.? Shutting down filesystem: sdb1
> Jun 21 23:24:10 backup2 kernel: Please umount the filesystem, and rectify the problem(s)
> Jun 21 23:24:20 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.
> Jun 21 23:24:50 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.
> Jun 21 23:25:20 backup2 kernel: Filesystem "sdb1": xfs_log_force: error 5 returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
