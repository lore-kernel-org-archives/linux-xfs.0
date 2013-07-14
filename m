Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04E497F51
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 10:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 748F7AC003
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 08:51:53 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	jmsjo97ftGsT3WQN for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 08:51:51 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id DB00C1F003F5
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 11:51:50 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 6wbDr3o8pAso for <xfs@oss.sgi.com>;
	Sun, 14 Jul 2013 11:51:40 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 4F8DA1F001DF
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 11:51:40 -0400 (EDT)
Date: Sun, 14 Jul 2013 11:51:40 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <22762971.1368.1373817100242.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <trinity-f93ee630-12d7-49a7-a5ac-9038d9cfa0b0-1373789144486@3capp-webde-bs29>
Subject: Re: XFS errors on 3TB HDD that is identified of size 2TB only
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
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Thomas Schneider" <c.monty@web.de>

> On my new HDD WD30EZRX I created a GPT partition table and formatted
> it with XFS.
> Then I put some data (approx. 2.4TB) on that new partition.
> 
> However, after restarting the system the disk is identified of size
> 2TB only.
> knoppix@Microknoppix:~$ sudo fdisk -l

Stop!  Wait a minute!  Stop it, boy!

(Sorry; Meat Loaf flashback.  :-)

You're looking at that partition table with fdisk, *which doesn't understand
GPT partition tables*; it's amazing it didn't complain louder.

You need to check it with parted, or something else that speaks GPT; the rest
your these here is invalid, being based on your assumption that there really is 
a problem... which there probably isn't.

If not with parted, how did you create the GPT partition in the first place?

Cheers,
-- jra

> Disk /dev/sda: 2000.4 GB, 2000421444608 bytes
> 255 heads, 63 sectors/track, 243204 cylinders, total 3907073134
> sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> 
> Checking the HDD with tool gdisk, I get this output for option "i"
> (show detailed information [...]):
> Command (? for help): i
> Using 1
> Partition GUID code: 0FC63DAF-8483-4772-8E79-3D69D8477DE4 (Linux
> filesystem)
> Partition unique GUID: 37786D32-C98F-4624-9440-94F79BE79793
> First sector: 2048 (at 1024.0 KiB)
> Last sector: 5860533134 (at 2.7 TiB)
> Partition size: 5860531087 sectors (2.7 TiB)
> Attribute flags: 0000000000000000
> Partition name: 'Linux filesystem'
> 
> Using option "v" (verify disk) I get this output:
> Expert command (? for help): v
> 
> Caution: The CRC for the backup partition table is invalid. This table
> may
> be corrupt. This program will automatically create a new backup
> partition
> table when you save your partitions.
> 
> Problem: The secondary header's self-pointer indicates that it doesn't
> reside
> at the end of the disk. If you've added a disk to a RAID array, use
> the 'e'
> option on the experts' menu to adjust the secondary header's and
> partition
> table's locations.
> 
> Problem: Disk is too small to hold all the data!
> (Disk size is 3907073134 sectors, needs to be 5860533168 sectors.)
> The 'e' option on the experts' menu may fix this problem.
> 
> Problem: partition 1 is too big for the disk.
> 
> Identified 4 problems!
> 
> My understanding of the issue is:
> 1. The HDD is not identified correctly by the mainboard/Bios with 3TB.
> This is confirmed by the hardware vendor of my mainboard "Gigabyte
> P35-DS4", means the limit is 2.2TB
> 2. The partition is too small to keep data of size 2.4TB
> 
> How can I recover the data?
> Should I simply create a new partition table either with gdisk or
> parted?
> Can I make a low-level copy using dd starting from sector 2048 until
> the end to another HDD WD30EZRX (that I have available) and then mount
> that partition?
> Or are there any other options?
> 
> THX
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
