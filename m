Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Jul 2006 06:43:31 -0700 (PDT)
Received: from nz-out-0102.google.com (nz-out-0102.google.com [64.233.162.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6EDgnDW018141
	for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 06:42:49 -0700
Received: by nz-out-0102.google.com with SMTP id r28so222724nza
        for <xfs@oss.sgi.com>; Fri, 14 Jul 2006 06:42:28 -0700 (PDT)
Message-ID: <44B79F4D.3060603@gmail.com>
Date: Fri, 14 Jul 2006 21:42:37 +0800
From: "Michael Li (gmail)" <mikore.li@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS bmap to disk lba question.
References: <55EF1E5D5804A542A6CA37E446DDC2062D6068@mapibe17.exchange.xchg>
In-Reply-To: <55EF1E5D5804A542A6CA37E446DDC2062D6068@mapibe17.exchange.xchg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian Brings <sebas@silexmedia.com>, Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com

Hi, Nathan and Sebastian,

I have drafted a formula for the bmap->LBA mapping for a simple stripe 
group(RAID0) on IRIX/CXFS. Maybe it is some roughness,
If there is any mistake, correct me:

For example: if a file is on [200, 1000]( shown from xfs_bmap). And the 
stripe unit is 128kB.
stripe width is 3(totally 3 disks), xvm can told us the user data area 
begin after 4096 block.(This is changable by admin)
 
stripe_unit_size = 128KB
stripe_width = 3
sector_size = 512Btyes
chuck_blocks = stripe_unit_size/sector_size = 128KB/512B = 256 blocks.
stripe_line_blocks = chuck_block * stripe_width = 256 * 3 = 768 blocks
data_offset_to_disk_block0 = 4096 blocks.
file_sector_offset_in_stripe_line = BMAP % stripe_line_blocks = 200 % 
768 = 200
disk_id = file_sector_offset_in_stripe_line / chunk_blocks = 200 / 256 = 0
stripe_high = BMAP / strip_line_blocks = 200 / 768 = 0
File_head_sector = stripe_high * chuck_blocks + 
data_offset_to_disk_block0 + file_sector_offset_in_stripe_line
                          = 0*256 + 4096 + 200 = 4296

The LBA for the file's first block IS the above line: 4296.
To ensure it, just dd back the raw data from the disk at the offset 4296 
is ok.

However, I am not sure the result if there is a plex layer is inserted 
or on the  realtime volume...
Could you or other interested persons refine the calculation for some 
variation or is there any outstanding issue on it?

Thanks,

Michael

Sebastian Brings wrote:

>For Irix I am aware of two ways. One is to do the math, using xvm show
>-verbose phys/* and so on to get the sizes of labels and volume header
>and figure out where the first data block starts.
>The other way is to use a program which does direct IO read on an
>existing file and run it under control of "par -k". This produces plenty
>of output, but holds information like "read from device X starting at
>offset Y number of bytes Z. You then can match it with your xfs_bmap -v
>list.
>
>Cheers
>
>Sebastian 
>
>  
>
>>-----Original Message-----
>>From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
>>    
>>
>Of
>  
>
>>Nathan Scott
>>Sent: Freitag, 14. Juli 2006 07:31
>>To: Michael Li (gmail)
>>Cc: xfs@oss.sgi.com
>>Subject: Re: XFS bmap to disk lba question.
>>
>>On Fri, Jul 14, 2006 at 01:58:04AM +0800, Michael Li (gmail) wrote:
>>    
>>
>>>We know that the command xfs_bmap can show us the file's extent
>>>      
>>>
>range,
>  
>
>>>for example [20 - 100], but how can we know the real physical
>>>      
>>>
>secoter ID
>  
>
>>>(or
>>>named as LBA) of file's first block(512Bytes) on a raw disk? I've
>>>      
>>>
>read
>  
>
>>>XVM admin for IRIX,  it show us less clue for this mapping.
>>>      
>>>
>>For a single disk, its relatively simple.  bmap gives you the starting
>>offset for each extent in  basic blocks (512 bytes) always, which maps
>>directly to sectors on the logical device.
>>
>>You need to consider any partition table or volume manager header at
>>the start of a physical device, and factor that into the calculation,
>>they are not any one fixed size (I don't know how large an XVM label
>>would be for example).
>>
>>    
>>
>>>We can get this mapping method on linux, as linux/xfs is open
>>>      
>>>
>sourced,
>  
>
>>>but IRIX is not, we don't know how to do it on IRIX, although the
>>>filesystem is the in the same name XFS.
>>>      
>>>
>>The xfs_bmap command is basically the same between IRIX and Linux.
>>
>>    
>>
>>>Furthermore, is it the same way to mapping the bmap/LBA in a striped
>>>volume. ...
>>>unit is 128. each stripe unit has 32 512B-blocks. How can we map the
>>>first block in the file to one of disk's X sector?
>>>      
>>>
>>Well, it gets more complex now of course, bmap gives you one number
>>(for the single logical address space presented by the raid or volume
>>manager), and its an exercise for the reader to figure out which
>>actual disk that corresponds to based on the raid geometry.  Theres
>>no tools for doing this that I know of, you just have to sit down and
>>do the math... (well, thats how I've done it in the past anyway)... a
>>bit of a pain, I know.
>>
>>    
>>
>>>BTW: If we should not talk about IRIX here, I will stop posting such
>>>      
>>>
>a
>  
>
>>>topic here. Sorry for the noise.
>>>      
>>>
>>Heh, yes, its more usual to speak to SGI customer support folks for
>>this sort of topic.
>>
>>cheers.
>>
>>--
>>Nathan
>>
>>    
>>
>
>
>  
>
