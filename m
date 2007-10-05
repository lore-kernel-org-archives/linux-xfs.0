Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 22:16:44 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l955G7RF019839
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 22:16:10 -0700
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1IdfXj-0000vE-SO
	for xfs@oss.sgi.com; Thu, 04 Oct 2007 22:16:07 -0700
Message-ID: <13053632.post@talk.nabble.com>
Date: Thu, 4 Oct 2007 22:16:07 -0700 (PDT)
From: cyjoyp <cyjoyp@gmail.com>
Subject: Re: Reading directory entries from BMAP
In-Reply-To: <cc7060690710040952q342cf3fct20f523fb0fbdda3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <13040897.post@talk.nabble.com> <cc7060690710040952q342cf3fct20f523fb0fbdda3d@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Thanks for your reply....
I ll make it clear for you....

Manipulating this 16 bytes

 00 00 00 01 00 00 02 00 00 00 00 00 02 A0 00 02
 
   *21 bits out of A0 00 02 would form the block count : 2
   *19 bits out of 00 00 A0 would form the absolute block numbe :15h 
   *The remaining bits out 52 (52-19 =33 bits) would form the AG number : 0
   *The rest forms the logical offset.
   
  This means that I have to read 2 contiguos blocks from the location
15h*8=168.
  I really dont understand how the logial offset works.
  More I have the root folder with 1000 empty directoris created in the
root.
  So when I go to the position 168,I should be able to see only two
contigous blocks of directory entries,
  but I am not getting ..
  
 Instead I get values

sector number: 168
00  80  00  03  00  80  00  02  d2  ff  00  00  01  2e  00 00
b8  16  e9  8d  00  00  06  ed  b8 16 e9  8e  00  00  06 e8
b8  16  e9  8f   00  00  06  e3  be  95 a0 c2  00  00  0e 6b
be  95  a0  c3  00  00  0e  66  be  95 a0 c8  00  00  0e 4d
be  95  a0  c9  00  00  0e  48  be  95 a0 ca  00  00  0e 43

There is no magic number at the start ...

Are you able to understand??

thnks


   
   
   



















Bhagi rathi wrote:
> 
>>br_startoff is starting offset of a file. The problem you are facing is
not
>>clear to me.
>>XFS uses 16 bytes to represet start offset, length of the extent and then
>>start bloock
>   offset.
> 
>>If you are interested with directories of XFS, the blocks that start from
0
>   offset and with
>>in the file address space of 32GB is the name space. After name space, you
>  have
>>lookup space and then free space manager for directories. Typically,
reading
>  of
>  >directory entries is reading of the total blocks reported by stat
> command. A
>>directory
>> can be in single block format, embedded in the inode itself, etc.
> 
>>You are talking about bmbt_irec and then going towards directory entries.
>>This was
>> not clear to me.
> 
> -Saradhi.
> 
> On 10/4/07, cyjoyp <cyjoyp@gmail.com> wrote:
>>
>>
>> Hi there,
>>           I am a beginner in learning XFS file system.. I have a doubt,
>> dont
>> know whether is silly..If you could help me with this...Thank you..
>>
>>    An extent is 128 bit in size and uses the following struct,
>>
>>         typedef struct xfs_bmbt_irec {
>>                       xfs_fileoff_t              br_startoff;
>>                       xfs_fsblock_t            br_startblock;
>>                       xfs_filblks_t              br_blockcount;
>>                       xfs_exntst_t             br_state;
>>                      }
>>
>>      I have got in to the BMAP position after traversing the BTREE..
>>      The BMAP has a leaf and no other siblings..
>>      I have the extents for directory entries stored in the BMAP..
>>      This is where is struck badly..
>>
>>     Now I have a 16 byte value from which I can calculate the block count
>> ,AG number ,etc...
>>              00 00 00 01 00 00 02 00 00 00 00 00 02 A0 00 02
>>    In this case I lan up some where else instead going to the block of
>> directory entries..
>>    This br_startoff (logical offset) is causing a difference...I am going
>> wrong somwhere in this case..
>>
>>
>>      Could you please tell me br_startoff does really mean???
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
>>
>> --
>> View this message in context:
>> http://www.nabble.com/Reading-directory-entries-from-BMAP-tf4569129.html#a13040897
>> Sent from the Xfs - General mailing list archive at Nabble.com.
>>
>>
>> [[HTML alternate version deleted]]
>>
>>
>>
> 
> 
> [[HTML alternate version deleted]]
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/Reading-directory-entries-from-BMAP-tf4569129.html#a13053632
Sent from the Xfs - General mailing list archive at Nabble.com.
