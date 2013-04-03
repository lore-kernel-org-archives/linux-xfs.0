Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95C7E7FAB
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 09:26:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 581258F8049
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 07:26:08 -0700 (PDT)
Received: from mail-ve0-f175.google.com (mail-ve0-f175.google.com
	[209.85.128.175]) by cuda.sgi.com with ESMTP id
	dbcFjULMN5eSYCU9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 07:26:06 -0700 (PDT)
Received: by mail-ve0-f175.google.com with SMTP id pb11so1699958veb.6
	for <xfs@oss.sgi.com>; Wed, 03 Apr 2013 07:26:05 -0700 (PDT)
Message-ID: <515C3BF3.60601@binghamton.edu>
Date: Wed, 03 Apr 2013 10:25:55 -0400
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
	<5155F2B2.1010308@binghamton.edu> <20130331012231.GJ6369@dastard>
In-Reply-To: <20130331012231.GJ6369@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

So, assuming entropy has reached critical mass and that there is no easy 
fix for this physical file system, what would happen if I replicated 
this data to a new disk array?  When I say 'replicate', I'm not talking 
about xfs_dump.  I'm talking about running a series of cp -al/rsync 
operations (or maybe rsync with --link-dest) that will precisely 
reproduce the linked data on my current array.  All of the inodes would 
be re-allocated.  There wouldn't be any (or at least not many) deletes.

I am hoping that if I do this the inode fragmentation will be 
significantly reduced on the target as compared to the source.  Of 
course over time it may re-fragment, but with two arrays I can always 
wipe one and reload it.

-Dave

Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 03/30/2013 09:22 PM, Dave Chinner wrote:
> On Fri, Mar 29, 2013 at 03:59:46PM -0400, Dave Hall wrote:
>    
>> Dave, Stan,
>>
>> Here is the link for perf top -U:  http://pastebin.com/JYLXYWki.
>> The ag report is at http://pastebin.com/VzziSa4L.  Interestingly,
>> the backups ran fast a couple times this week.  Once under 9 hours.
>> Today it looks like it's running long again.
>>      
>      12.38%  [xfs]     [k] xfs_btree_get_rec
>      11.65%  [xfs]     [k] _xfs_buf_find
>      11.29%  [xfs]     [k] xfs_btree_increment
>       7.88%  [xfs]     [k] xfs_inobt_get_rec
>       5.40%  [kernel]  [k] intel_idle
>       4.13%  [xfs]     [k] xfs_btree_get_block
>       4.09%  [xfs]     [k] xfs_dialloc
>       3.21%  [xfs]     [k] xfs_btree_readahead
>       2.00%  [xfs]     [k] xfs_btree_rec_offset
>       1.50%  [xfs]     [k] xfs_btree_rec_addr
>
> Inode allocation searches, looking for an inode near to the parent
> directory.
>
> Whatthis indicates is that you have lots of sparsely allocated inode
> chunks on disk. i.e. each 64 indoe chunk has some free inodes in it,
> and some used inodes. This is Likely due to random removal of inodes
> as you delete old backups and link counts drop to zero. Because we
> only index inodes on "allocated chunks", finding a chunk that has a
> free inode can be like finding a needle in a haystack. There are
> heuristics used to stop searches from consuming too much CPU, but it
> still can be quite slow when you repeatedly hit those paths....
>
> I don't have an answer that will magically speed things up for
> you right now...
>
> Cheers,
>
> Dave.
>    

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
