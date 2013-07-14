Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A95877F60
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 03:05:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 440C2AC003
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 01:05:47 -0700 (PDT)
Received: from mout.web.de (mout.web.de [212.227.15.3]) by cuda.sgi.com with
	ESMTP id MdzS4Rh499BxDgem for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 01:05:45 -0700 (PDT)
Received: from 3capp-webde-bs29.server.lan ([172.19.170.29]) by
	mriweb.server.lan (mriweb001) with ESMTP (Nemesis) id
	0M9tck-1Urhk82WRk-00B72Z for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 10:05:44 +0200
MIME-Version: 1.0
Message-ID: <trinity-f93ee630-12d7-49a7-a5ac-9038d9cfa0b0-1373789144486@3capp-webde-bs29>
From: "Thomas Schneider" <c.monty@web.de>
Subject: XFS errors on 3TB HDD that is identified of size 2TB only
Date: Sun, 14 Jul 2013 10:05:44 +0200 (CEST)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8100683280247634269=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8100683280247634269==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hi!<br/>
<br/>
On my new HDD WD30EZRX I created a GPT partition table and formatted it with XFS.<br/>
Then I put some data (approx. 2.4TB) on that new partition.<br/>
<br/>
However, after restarting the system the disk is identified of size 2TB only.<br/>
<i>knoppix@Microknoppix:~&#36; sudo fdisk -l<br/>
Disk /dev/sda: 2000.4 GB, 2000421444608 bytes<br/>
255 heads, 63 sectors/track, 243204 cylinders, total 3907073134 sectors<br/>
Units = sectors of 1 * 512 = 512 bytes<br/>
Sector size (logical/physical): 512 bytes / 4096 bytes<br/>
I/O size (minimum/optimal): 4096 bytes / 4096 bytes</i><br/>
<br/>
Checking the HDD with tool gdisk, I get this output for option &quot;i&quot; (show detailed information [...]):<br/>
<i>Command (? for help): i<br/>
Using 1<br/>
Partition GUID code: 0FC63DAF-8483-4772-8E79-3D69D8477DE4 (Linux filesystem)<br/>
Partition unique GUID: 37786D32-C98F-4624-9440-94F79BE79793<br/>
First sector: 2048 (at 1024.0 KiB)<br/>
Last sector: 5860533134 (at 2.7 TiB)<br/>
Partition size: 5860531087 sectors (2.7 TiB)<br/>
Attribute flags: 0000000000000000<br/>
Partition name: &#39;Linux filesystem&#39;</i><br/>
<br/>
Using option &quot;v&quot; (verify disk) I get this output:<br/>
<i>Expert command (? for help): v<br/>
<br/>
Caution: The CRC for the backup partition table is invalid. This table may<br/>
be corrupt. This program will automatically create a new backup partition<br/>
table when you save your partitions.<br/>
<br/>
Problem: The secondary header&#39;s self-pointer indicates that it doesn&#39;t reside<br/>
at the end of the disk. If you&#39;ve added a disk to a RAID array, use the &#39;e&#39;<br/>
option on the experts&#39; menu to adjust the secondary header&#39;s and partition<br/>
table&#39;s locations.<br/>
<br/>
Problem: Disk is too small to hold all the data!<br/>
(Disk size is 3907073134 sectors, needs to be 5860533168 sectors.)<br/>
The &#39;e&#39; option on the experts&#39; menu may fix this problem.<br/>
<br/>
Problem: partition 1 is too big for the disk.<br/>
<br/>
Identified 4 problems!</i><br/>
<br/>
My understanding of the issue is:<br/>
1. The HDD is not identified correctly by the mainboard/Bios with 3TB. This is confirmed by the hardware vendor of my mainboard &quot;Gigabyte P35-DS4&quot;, means the limit is 2.2TB<br/>
2. The partition is too small to keep data of size 2.4TB<br/>
<br/>
How can I recover the data?<br/>
Should I simply create a new partition table either with gdisk or parted?<br/>
Can I make a low-level copy using dd starting from sector 2048 until the end to another HDD WD30EZRX (that I have available) and then mount that partition?<br/>
Or are there any other options?<br/>
<br/>
THX</div></div></body></html>


--===============8100683280247634269==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8100683280247634269==--
