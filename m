Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 184107F5E
	for <linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 02:57:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09C878F8033
	for <linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 00:57:31 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 8rz1n52csCMnG8LG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 00:57:30 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <c.monty@web.de>) id 1UyHBS-0003yM-B8
	for linux-xfs@oss.sgi.com; Sun, 14 Jul 2013 00:57:30 -0700
Date: Sun, 14 Jul 2013 00:57:30 -0700 (PDT)
From: "c.monty" <c.monty@web.de>
Message-ID: <1373788650050-35001.post@n7.nabble.com>
Subject: XFS formatted partition is shown as 2TB but should be 3TB
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
To: linux-xfs@oss.sgi.com

Hi!

On my new HDD WD30EZRX I created a GPT partition table and formatted it with
XFS.
Then I put some data (approx. 2.4TB) on that new partition.

However, after restarting the system the disk is identified of size 2TB
only.
/knoppix@Microknoppix:~$ sudo fdisk -l
Disk /dev/sda: 2000.4 GB, 2000421444608 bytes
255 heads, 63 sectors/track, 243204 cylinders, total 3907073134 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes/

Checking the HDD with tool gdisk, I get this output for option "i" (show
detailed information [...]):
/Command (? for help): i
Using 1
Partition GUID code: 0FC63DAF-8483-4772-8E79-3D69D8477DE4 (Linux filesystem)
Partition unique GUID: 37786D32-C98F-4624-9440-94F79BE79793
First sector: 2048 (at 1024.0 KiB)
Last sector: 5860533134 (at 2.7 TiB)
Partition size: 5860531087 sectors (2.7 TiB)
Attribute flags: 0000000000000000
Partition name: 'Linux filesystem'/

Using option "v" (verify disk) I get this output:
/Expert command (? for help): v

Caution: The CRC for the backup partition table is invalid. This table may
be corrupt. This program will automatically create a new backup partition
table when you save your partitions.

Problem: The secondary header's self-pointer indicates that it doesn't
reside
at the end of the disk. If you've added a disk to a RAID array, use the 'e'
option on the experts' menu to adjust the secondary header's and partition
table's locations.

Problem: Disk is too small to hold all the data!
(Disk size is 3907073134 sectors, needs to be 5860533168 sectors.)
The 'e' option on the experts' menu may fix this problem.

Problem: partition 1 is too big for the disk.

Identified 4 problems!/

My understanding of the issue is:
1. The HDD is not identified correctly by the mainboard/Bios with 3TB. This
is confirmed by the hardware vendor of my mainboard "Gigabyte P35-DS4",
means the limit is 2.2TB
2. The partition is too small to keep data of size 2.4TB

How can I recover the data?
Should I simply create a new partition table either with gdisk or parted?
Can I make a low-level copy using dd starting from sector 2048 until the end
to another HDD WD30EZRX (that I have available) and then mount that
partition?
Or are there any other options?

THX



--
View this message in context: http://xfs.9218.n7.nabble.com/XFS-formatted-partition-is-shown-as-2TB-but-should-be-3TB-tp35001.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
