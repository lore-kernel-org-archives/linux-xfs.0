Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 07:10:19 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QEADtL032028
	for <linux-xfs@oss.sgi.com>; Tue, 26 Jun 2007 07:10:15 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1I3BkE-0008Lt-VW
	for linux-xfs@oss.sgi.com; Tue, 26 Jun 2007 07:10:14 -0700
Message-ID: <11306454.post@talk.nabble.com>
Date: Tue, 26 Jun 2007 07:10:14 -0700 (PDT)
From: Sandy1 <sundeep.saini@rediffmail.com>
Subject: Re: Wrong Data Pointer-XFS File system
In-Reply-To: <20070625232817.GC31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <11246839.post@talk.nabble.com> <20070625232817.GC31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi David,

I am already using FSB format, i am using this format for sparsing the
absolute block number,
as we know extent is 128 bit in size and uses the following packed layout:

LSB... bit 0-20              gives # blocks
        bits 21 to 72 (52)  gives absolute number
        bits 72 to 126 (54) gives logical file block offset
MSB..flag(last bit)

the value i am getting in absolute no. is in FSB and after multiplying with
no. of sectors in FS block i am trying to jump that value (pointer
location). But only in 0th AG i am able to get the data.Afterwards i am not
able to reach the data in next AGs.

I also read in document that "sb_agblklog"--> This value is used to generate
inode numbers and absolute block numbers defined in extent maps.

How i can use this value in interprating the absolute block number?

Is the above sparsing method is right or there is any other calculation?
Please guide me.

Regards
Sandy





David Chinner wrote:
> 
> On Thu, Jun 21, 2007 at 11:23:35PM -0700, Sandy1 wrote:
>> 
>> Hi,
>> I am Using SuSe 10.0 with Xfs file system. I am working on a File system
>> based project. During the initial research in On disk layout of File
>> system
>> , i found data pointer problem. I was not able to get the data location
>> as
>> per pointed by "absolute block no." in "xfs_bmbt_rec" extent pointers.
> 
> The xfs_bmbt_rec holds the address in FSB format, not DADDR format.
> 
>> When i create any file in 0th (zero`th) AG in that case i am able to
>> reach
>> on proper location by using "absolute block no." pointer.
>> 
>> But when i create any file in 1st or in 2nd AG and so on. I never got the
>> file data at the location pointed by "absolute block no.". I always found
>> the file data before the the pointed address.
> 
> FSB notation is sparse representation.
> 
>> I am not getting any value in Superblock that tells me about difference
>> in
>> pointer location with actual data.
>> 
>> This value always becomes multiple of the AG number.
>> 
>> Please help to get out from this problem.
>> 
>> Is there any other calculation for finding the data locations.
> 
> man xfs_db. Search for "convert".
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/Wrong-Data-Pointer-XFS-File-system-tf3963002.html#a11306454
Sent from the linux-xfs mailing list archive at Nabble.com.
