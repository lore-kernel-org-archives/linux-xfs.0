Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97GeuEB074836 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 11:40:57 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3QhPmGBFFhGXaUBs
	for <xfs@oss.sgi.com>; Sun, 15 Jan 2012 20:56:24 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 1E7B36C0CA
	for <xfs@oss.sgi.com>; Sun, 15 Jan 2012 22:56:23 -0600 (CST)
Message-ID: <4F13ADF6.90903@hardwarefreak.com>
Date: Sun, 15 Jan 2012 22:56:22 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Optimal XFS formatting options?
References: <33140169.post@talk.nabble.com>
	<4F12006F.8080805@hardwarefreak.com>
	<33145068.post@talk.nabble.com>
In-Reply-To: <33145068.post@talk.nabble.com>
Reply-To: stan@hardwarefreak.com
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

On 1/15/2012 6:27 PM, MikeJeezy wrote:
> 
>> So let's assume your vendor does the smart thing and allows you 
>> flexibility in specifying per drive strip size.  Assume for example the 
>> stripe unit (strip, chunk) of the array is 64KB, there are 10 stripe 
>> spindles (12-2=10), and the local device name of the LUN is /dev/sdb. 
>> To create an aligned XFS filesystem on this you would use something like: 
> 
>> $ mkfs.xfs -d su=64k sw=10 /dev/sdb 
> 
> Great explanations! (some of it I am still trying to understand :-)  In this
> case on my HP P2000 G3, I do have a 64k chunk size so I will do:
> 
> $ mkfs.xfs -d su=64k,sw=10 /dev/sdd

That should be fine.

> Question: Does the above command assume I do not already have a partition
> created?  I was 
> http://www.fhgfs.com/wiki/wikka.php?wakka=PartitionAlignment reading here 
> that the easiest way to acheive partition alignment is to create the file
> system directly on the storage device without any paritions - such as $
> mkfs.xfs /dev/sdd  (and your example above also hints at this)

That example and command assume you're not using partitions.

> When I created my current partiton, I used the following commands:
> 
> $ parted -a optimal /dev/sdd
> $ mklabel gpt
> $ mkpart primary 0 -0
> $ q
> 
> I would like to align the partiton as well, but I am not sure how to acheive
> this using parted.  This will be the only partition on the LUN, so not sure
> if I even need to create one (although I do like to stay consistent with my
> other volumes). 

If your drives have 512 byte physical sectors (not advanced format
drives with 4096 byte sectors) then there is no need to worry about
partition alignment.  And in fact, if you plan to put a single
filesystem on this entire 4.9TB virtual drive, you don't need to
partition the disk device at all.  Recall the dictionary definition of
"partition".  You're not dividing the whole into smaller pieces here.

> When printing the partition info with parted I see:
> 
> # (parted) p                                                                
> Model: HP P2000 G3 iSCSI (scsi)
> Disk /dev/sdd: 4900GB
> Sector size (logical/physical): 512B/512B
> Partition Table: gpt
> 
> Number  Start   End     Size    File system  Name     Flags
>  1      1049kB  4900GB  4900GB  xfs          primary
> 
> but from reading, I suspect the Sector size should be more like: 
> (logical/physical): 512B/65536B.  

No, that 65536 figure is wrong.  Their are only two possibilities for
sector size (logical/physical):  512/512 and 512/4096.  These are the
only two disk sector formats currently used on disk drives.
Partitioning utils look strictly at disk parameters, not RAID parameters.

Sectors deal with how many books (bytes) fit on each shelf (sector) in
the library, and which shelf (sector) we're going to store a given set
of books (bytes) on.  RAID parameters, such as stripe unit, deal with
how many shelves (sectors) worth of books (bytes) we can carry most
efficiently down the isle and place on the shelves at one time.

In short, sectors are a destination where we store bytes, much like
books on a shelf.  A stripe unit acts as a book cart in which we carry a
fixed number of books, allowing us to fill a fixed number of shelves
most efficiently per cart transported down the isle.

> Any thoughts on partition alignment or
> other thoughts in general?  Thank you.

Yes, don't use partitions if you don't need to divide your disk device
(LUN/virtual disk) into multiple pieces.  Now, if you need to make use
of snapshots or other volume management features, you may want to create
an LVM device on top of the disk device (LUN) and then make your XFS on
top of the LVM device.  If you have no need for LVM features, I'd say
directly format the LUN with XFS, no partition table necessary.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
