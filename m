Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pavilion.ashurst.eu.org ([85.119.82.45]:34040 "EHLO
        pavilion.ashurst.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdG3OgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jul 2017 10:36:05 -0400
From: Andy Bennett <andyjpb@ashurst.eu.org>
Date: Sun, 30 Jul 2017 15:36:00 +0100
MIME-Version: 1.0
Message-ID: <5310bb84-84f8-414a-97ae-90ecb380c4a9@ashurst.eu.org>
In-Reply-To: <20170727150416.GB5597@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
 <20170726111541.GB59833@bfoster.bfoster>
 <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
 <20170727124350.GB3858@bfoster.bfoster>
 <20170727150416.GB5597@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Subject: Re: Recover file after truncate
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi,

> The last reference I see of your inode in the log before the size goes
> to zero is this:
>
> ---------------------------------------------------------------------------- 
>                                           
> Oper (2): tid: c6720129  len: 56  clientid: TRANS  flags: none  
>                                                        
> INODE: #regs: 2   ino: 0x12c37053  flags: 0x1   dsize: 0   
>         blkno: 235989736  len: 32  boff: 9728              
> Oper (3): tid: c6720129  len: 176  clientid: TRANS  flags: none 
>                                                        
> INODE CORE                                                 
> magic 0x494e mode 0100644 version 3 format 2               
> nlink 1 uid 501 gid 100                                    
> atime 0x5977c96e mtime 0x5973ac16 ctime 0x5973ac16         
> size 0x1a81f2218 nblocks 0x1a81f3 extsize 0x0 nextents 0x2 
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0           
> flags 0x0 gen 0xb8791e20                                   
> ----------------------------------------------------------------------------
>
> This suggests the file size was 0x1a81f2218 (7115579928) and it had
> 0x1a81f3 (1737203) blocks across two extents (roughly 6.6GB). Note that
> the file size is not exactly aligned to the (blockcount * 4096).
>
> Further along, the following EFI exists:
>
> ----------------------------------------------------------------------------
> Oper (19): tid: 6a85c7fc  len: 48  clientid: TRANS  flags: none
> EFI:  #regs: 1    num_extents: 2  id: 0xffff8bfcb4f38990
> (s: 0x12a9233, l: 688643) (s: 0x34ae0d5, l: 1048560)
> ----------------------------------------------------------------------------
>
> ... which frees two extents that add up to 688643 + 1048560 = 1737203
> (0x1a81f3) blocks. The starting filesystem blocks for these extents are
> 0x12a9233 and 0x34ae0d5, respectively.
>
> If you can convert those starting fsb values to agno/agbno combinations
> as shown in my previous mail, you could confirm whether they reside in
> the free space btrees for the associated allocation group of each
> extent.

Here are the translations for those extents:

fsb 0x12a9233
	agno 0
	agbno 0x12a9233 (19567155)
	daddr 0x9549198 (156537240)

fsb 0x34ae0d5
	agno 1
	agno 0x14ae0d5 (21684437)
	daddr 0x15a48150 (363102544)


xfs_db's 'freesp -d' output contains:

-----
...
       0 19566515      639
       0 19567155  1396803
       0 20963959   408468
...
       1 20621811   106501
       1 21684437  1104130
       1 22788568   421464
...
-----

Both chunks of free space appear to have more blocks that the original 
extents.


> If so, you could convert each start fsb to a raw daddr (xfs_db
> -c "convert fsb 0x12a9233 daddr" <dev>) and use that to try and read
> each extent off the raw device as previously discussed.

156537240 is in 512 byte blocks which is 19567155 in 4096 byte blocks.

dd if=/dev/nvme0n1p8 bs=4096 skip=19567155 count=688643 of=extentfile.0


363102544 is in 512 byte blocks which is 45387818 in 4096 byte blocks.

dd if=/dev/nvme0n1p8 bs=4096 skip=45387818 count=1048560 of=extentfile.1

These files both look good and 'cat extentfile.0 >> extentfile.1' gives me 
back the original order of the file.

-----
$ wc -c extentfile.1
7115583488 extentfile.1

$ du -hs extentfile.1
6.7G    extentfile.1
-----

...which seems slightly larger than the original file as reported in the 
'INODE CORE' message that you found in the log.

The recovered file ends up being some 53 extents long; probably because the 
filesystem I recovered it too was rather full.

However, when I run it through my tool chain, I seem to get exactly what I 
expect.


> I have no idea whether those extents contain the file data you're after
> (note that I'm not sure we've actually confirmed your file data would
> have made it to disk), but if the file size values look sane that might
> be worth a try before you go fishing the device for raw data.

It seems that it did and we have been able to retrieve it!


Thanks so much for your help. I really appreiciate it, especially the time 
you took to poor through my logs.

Let me know if you're ever near London and I'll shout you dinner and 
drinks.





Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

