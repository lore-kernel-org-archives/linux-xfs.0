Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 09:13:10 -0700 (PDT)
Received: from mail.itsolut.com (mail.itsolut.com [64.182.153.89])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k81GD0DW021514
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 09:13:00 -0700
Received: from [192.168.1.3] (adsl-68-251-149-159.dsl.bltnin.ameritech.net [68.251.149.159])
	by mail.itsolut.com (Postfix) with ESMTP id 4E9D043223
	for <xfs@oss.sgi.com>; Fri,  1 Sep 2006 11:12:24 -0500 (EST)
Message-ID: <44F85BE7.2010001@gmail.com>
Date: Fri, 01 Sep 2006 12:12:23 -0400
From: Chris Hane <chrishane@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS and 3.2TB Partition
References: <44F714F2.7050502@gmail.com> <200609010836.32331.krienke@uni-koblenz.de>
In-Reply-To: <200609010836.32331.krienke@uni-koblenz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Thank for the input.  I appreciate everyones help!

I believe I am going to end up not partitioning the raid array and using 
it directly (as described in an email which I copied below).

When we get our next large storage machine in (we've are going to need a 
couple over the next year to store CD & DVD ISO Images), I'm going to 
experiment some more with the suggestions everyone has given me here.

As an FYI:  I'm using the latest versions of everything (parted 1.7.1, 
kernel 2.6.16, 3ware raid controller brand new)

Thanks for the help,
Chris....

Peter Grandi wrote:
 >>>> On Thu, 31 Aug 2006 12:57:22 -0400, Chris Hane
 >>>> <chrishane@gmail.com> said:
 >
 > chrishane> I am trying to create a 3.2TB partition on my Raid 5.
 > chrishane> Is there a document that could help?
 >
 > The 9500 is fairly recent, so it should not have a lot of 2TB
 > problems. But there are 2TB limits in several places. For example
 > old versions of the Linux kernel don't support more than 2TB per
 > _filesystem_.
 >
 > But I suspect that you are trying to create partitions in the
 > sense of the MS-DOS/MS-Windows partitioning scheme. Check
 > carefully whether that partitioning scheme allos partitions
 > larger than 2TB :-).
 >
 > Anyhow, usually for very large filesystems you don't need
 > partitions at all. Just use '/dev/sda'. Or check the other
 > partitioning schemes supported by Linux, some may have higher
 > limits.
 >
 > chrishane> I have a 3ware 9500 controller and 8 *500GB sata
 > chrishane> drives configured into a single RAID 5 array.
 >
 > Using RAID5 with 8 drives is a great crime. Nothing to do with
 > your partitioning problems, but since you mentioned it...
 > Consider reading carefully <URL:http://WWW.BAARF.com/>
 >

Rainer Krienke wrote:
> Am Donnerstag, 31. August 2006 18:57 schrieben Sie:
>> I am trying to create a 3.2TB partition on my Raid 5.  Is there a
>> document that could help?
>>
>> I have a 3ware 9500 controller and 8 *500GB sata drives configured into
>> a single RAID 5 array.
>>
> 
> I have a Raid with about 5TB and no problems creating an xfs filesystem on it. 
> The system is Novell SLES10 with a 2.6.16.21 kernel. 
> 
> At first there was a problem with the raid. The firmware of the raid device 
> needed an upgrade. Bevore the upgrade I had a maximum of 2TB. 
> 
> In dmesg (or /var/log/boot.msg on SLES10) you should see something like this 
> message if the device (sdc here) is handled correctly:
> 
> <5>sdc : very big device. try to use READ CAPACITY(16).
> <5>SCSI device sdc: 10156243968 512-byte hdwr sectors (5199997 MB)
> <5>sdc: Write Protect is off
> <7>sdc: Mode Sense: cb 00 00 08
> <5>SCSI device sdc: drive cache: write back
> <5>sdc : very big device. try to use READ CAPACITY(16).
> <5>SCSI device sdc: 10156243968 512-byte hdwr sectors (5199997 MB)
> 
> Bevore the firmware update there was an error when trying to read the capacity 
> via READ CAPACITY(16).  
> 
> I created the partitiions using parted. fdisk did not work.
> 
> Have a nice day
> Rainer
