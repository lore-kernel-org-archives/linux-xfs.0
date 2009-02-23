Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NLWHiY111102 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 15:32:18 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 424E71658A9D
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 13:31:46 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id CEFg1MwvGGjvkPXp for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2009 13:31:46 -0800 (PST)
Message-ID: <49A315BE.7090607@sandeen.net>
Date: Mon, 23 Feb 2009 15:31:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
References: <200902231243.33897.harry.mangalam@uci.edu>
	<49A30CB3.4040100@sandeen.net>
	<200902231320.05320.harry.mangalam@uci.edu>
In-Reply-To: <200902231320.05320.harry.mangalam@uci.edu>
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
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: xfs@oss.sgi.com

Harry Mangalam wrote:
> Thanks for the quick response Eric!
> 
> On Monday 23 February 2009, Eric Sandeen wrote:
>> Harry Mangalam wrote:
>>> Here's an unusual (long) tale of woe.
>>>
>>> We had a USRobotics 8700 NAS appliance with 4 SATA disks in
>>> RAID5:
> 
> <snip>
> 
>> However this wouldn't cause a superblock mis-read like this.  If
>> you get it mounted, you *may* run into what looks like directory
>> corruption on the PC, though, due to the alignment issue.
>>
>> Anyway, first, I'd look around for "XFSB" in the early few blocks
>> of your raid and see if the raid might possibly have been rebuilt
>> out of order.
>>
>> # dd if=/dev/md0 bs=4k count=32 | hexdump -C | grep XFSB
>>
>> or so...
>>
>> -Eric
> 
> No, I didn't find this - I did find some disk ID header stuff which 
> confirms that the filesystem is XFS and some other info that might be 
> useful, but no XFSB strings, even grepping 8MB into the device.
> 
> |<IPStorPartition|
> | version="3.0" s|
> |ize="595" owner=|
> |"NACS-SW-DIST" c|
> |hecksum="" signa|
> |ture="IpStOrDyNa|
> |MiCdIsK" dataSta|
> |rtAtSectorNo="16|

.... knowing the offsets of these might be helpful.  But perhaps you are
simply not trying to mount the thing which actually has xfs on it.

I don't know what IPStore is.  Perhaps your volume is encrypted?
Dunno... at any rate, doesn't seem at first glance like it's an xfs
problem, I'm afraid.

> |firstSector="222|
> |72" lastSector="|
> |2928740095" owne|

I might look at sector 22272 (about 10MB in) and see if that looks like
xfs :)

Or maybe just put it back in the NAS box, now, assembled the same way.

-Eric

> |128" logvol="0" |
> |category="Virtua|
> |l Device"/>.<Phy|
> |sicalDev guid="5|
> |95e9fbb-1951-09c|
> |3-a30c-000045d3a|
> |a3b" Comment="" |
> |WorldWideID="FAL|
> |CON  LVMDISK-M09|
> |N01  v1.0-0-0-00|
> |"/>.............|
> |................|

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
