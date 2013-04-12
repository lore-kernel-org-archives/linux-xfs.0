Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 390217CBF
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 12:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABE7DAC004
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 10:25:27 -0700 (PDT)
Received: from mail-vc0-f177.google.com (mail-vc0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	YvMzzBdj5RNtK1tS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 10:25:26 -0700 (PDT)
Received: by mail-vc0-f177.google.com with SMTP id hr11so2374538vcb.8
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 10:25:25 -0700 (PDT)
Message-ID: <51684382.50008@binghamton.edu>
Date: Fri, 12 Apr 2013 13:25:22 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
	<5141E5CF.10101@binghamton.edu>
	<5142AE40.6040408@hardwarefreak.com>
	<20130315114538.GF6369@dastard>
	<5143F94C.1020708@hardwarefreak.com>
	<20130316072126.GG6369@dastard> <515082C3.2000006@binghamton.edu>
	<515361B5.8050603@hardwarefreak.com>
	<5155F2B2.1010308@binghamton.edu>
	<20130331012231.GJ6369@dastard> <515C3BF3.60601@binghamton.edu>
In-Reply-To: <515C3BF3.60601@binghamton.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Stan,

IDid this post get lost in the shuffle?  Looking at it I think it could 
have been a bit unclear.  What I need to do anyways is have a second, 
off-site copy of my backup data.  So I'm going to be building a second 
array.  In copying, in order to preserve the hard link structure of the 
source array I'd have to run a sequence of cp -al / rsync calls that 
would mimic what rsnapshot did to get me to where I am right now.  (Note 
that I could also potentially use rsync --link-dest.)

So the question is how would the target xfs file system fare as far as 
my inode fragmentation situation is concerned?  I'm hoping that since 
the target would be a fresh file system, and since during the 'copy' 
phase I'd only be adding inodes, that the inode allocation would be more 
compact and orderly than what I have on the source array since.  What do 
you think?

Thanks.

-Dave

Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 04/03/2013 10:25 AM, Dave Hall wrote:
> So, assuming entropy has reached critical mass and that there is no 
> easy fix for this physical file system, what would happen if I 
> replicated this data to a new disk array?  When I say 'replicate', I'm 
> not talking about xfs_dump.  I'm talking about running a series of cp 
> -al/rsync operations (or maybe rsync with --link-dest) that will 
> precisely reproduce the linked data on my current array.  All of the 
> inodes would be re-allocated.  There wouldn't be any (or at least not 
> many) deletes.
>
> I am hoping that if I do this the inode fragmentation will be 
> significantly reduced on the target as compared to the source.  Of 
> course over time it may re-fragment, but with two arrays I can always 
> wipe one and reload it.
>
> -Dave
>
> Dave Hall
> Binghamton University
> kdhall@binghamton.edu
> 607-760-2328 (Cell)
> 607-777-4641 (Office)
>
>
> On 03/30/2013 09:22 PM, Dave Chinner wrote:
>> On Fri, Mar 29, 2013 at 03:59:46PM -0400, Dave Hall wrote:
>>> Dave, Stan,
>>>
>>> Here is the link for perf top -U:  http://pastebin.com/JYLXYWki.
>>> The ag report is at http://pastebin.com/VzziSa4L.  Interestingly,
>>> the backups ran fast a couple times this week.  Once under 9 hours.
>>> Today it looks like it's running long again.
>>      12.38%  [xfs]     [k] xfs_btree_get_rec
>>      11.65%  [xfs]     [k] _xfs_buf_find
>>      11.29%  [xfs]     [k] xfs_btree_increment
>>       7.88%  [xfs]     [k] xfs_inobt_get_rec
>>       5.40%  [kernel]  [k] intel_idle
>>       4.13%  [xfs]     [k] xfs_btree_get_block
>>       4.09%  [xfs]     [k] xfs_dialloc
>>       3.21%  [xfs]     [k] xfs_btree_readahead
>>       2.00%  [xfs]     [k] xfs_btree_rec_offset
>>       1.50%  [xfs]     [k] xfs_btree_rec_addr
>>
>> Inode allocation searches, looking for an inode near to the parent
>> directory.
>>
>> Whatthis indicates is that you have lots of sparsely allocated inode
>> chunks on disk. i.e. each 64 indoe chunk has some free inodes in it,
>> and some used inodes. This is Likely due to random removal of inodes
>> as you delete old backups and link counts drop to zero. Because we
>> only index inodes on "allocated chunks", finding a chunk that has a
>> free inode can be like finding a needle in a haystack. There are
>> heuristics used to stop searches from consuming too much CPU, but it
>> still can be quite slow when you repeatedly hit those paths....
>>
>> I don't have an answer that will magically speed things up for
>> you right now...
>>
>> Cheers,
>>
>> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
