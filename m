Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p058w2AF135257 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 02:58:02 -0600
Received: from VA3EHSOBE005.bigfish.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C1EB1DBD9AA
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 01:00:09 -0800 (PST)
Received: from VA3EHSOBE005.bigfish.com (va3ehsobe005.messaging.microsoft.com
	[216.32.180.31]) by cuda.sgi.com with ESMTP id 5FC1DHgiMiQOJuX4
	for <xfs@oss.sgi.com>; Wed, 05 Jan 2011 01:00:09 -0800 (PST)
Received: from mail23-va3 (localhost.localdomain [127.0.0.1])	by
	mail23-va3-R.bigfish.com (Postfix) with ESMTP id 4957C1678543	for
	<xfs@oss.sgi.com>; Wed,  5 Jan 2011 09:00:09 +0000 (UTC)
Received: from VA3EHSMHS028.bigfish.com (unknown [10.7.14.241])	by
	mail23-va3.bigfish.com (Postfix) with ESMTP id 256F164004E	for
	<xfs@oss.sgi.com>; Wed,  5 Jan 2011 09:00:09 +0000 (UTC)
From: =?iso-8859-1?Q?Larsen=2C_Tore_H=F8ivaag?=
	<tore.hoivaag.larsen@cggveritas.com>
Date: Wed, 5 Jan 2011 08:59:59 +0000
Subject: using raid devices raw, loop devices ?
Message-ID: <CFFC47E79E870F4EBAD0CA24D8CD7652ED34D5BAAF@CRW-EXM01.int.cggveritas.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Lots of people is using >2TB luns labeled loop and using major device. 

# parted -s /dev/sdd print
Disk geometry for /dev/sdd: 0.000-10486938.000 megabytes
Disk label type: loop
Minor    Start       End     Filesystem  Flags
1          0.000 10486938.000  xfs     
            ^^^^

Comments?   What causes the occasional corruption? Boot time fsck, dmraid?  Volume manager daemons?


# parted -s /dev/sdd print
Disk geometry for /dev/sdd: 0.000-10486938.000 megabytes
Disk label type: loop
Minor    Start       End     Filesystem  Flags
1          0.000 10486938.000  xfs         
[root@argus-vnq1 TSDCLI-v2.3.zip]# dmesg | grep sdd
sdd : very big device. try to use READ CAPACITY(16).
SCSI device sdd: 21477249024 512-byte hdwr sectors (10996352 MB)
SCSI device sdd: drive cache: write back
sdd : very big device. try to use READ CAPACITY(16).
SCSI device sdd: 21477249024 512-byte hdwr sectors (10996352 MB)
SCSI device sdd: drive cache: write back
 sdd: unknown partition table
Attached scsi disk sdd at scsi8, channel 0, id 0, lun 0
XFS mounting filesystem sdd
Starting XFS recovery on filesystem: sdd (dev: sdd)
Ending XFS recovery on filesystem: sdd (dev: sdd)




Regards,
ToreL
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
