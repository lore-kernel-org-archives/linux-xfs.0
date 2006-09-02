Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Sep 2006 20:33:29 -0700 (PDT)
Received: from avalanche.hickorytech.net (smtp.hickorytech.net [216.114.192.16])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k823XCDW012434
	for <xfs@oss.sgi.com>; Fri, 1 Sep 2006 20:33:13 -0700
Message-ID: <44F8ECE7.2090102@mnsu.edu>
Date: Fri, 01 Sep 2006 21:31:03 -0500
From: "Jeffrey E. Hundstad" <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: vmsplice can't work well
References: <44F4440F.1090300@gmail.com> <20060829140542.GN12257@kernel.dk> <44F5CC08.8010205@mnsu.edu> <20060830174815.GF7331@kernel.dk> <44F5D3C6.1010108@mnsu.edu> <20060831092440.GC5528@kernel.dk> <20060901131913.GG5737019@melbourne.sgi.com>
In-Reply-To: <20060901131913.GG5737019@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Jens Axboe <axboe@kernel.dk>, xfs@oss.sgi.com, nathans@sgi.com

David Chinner wrote:
> On Thu, Aug 31, 2006 at 11:24:41AM +0200, Jens Axboe wrote:
>   
>> XFS list,
>>
>> On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
>>     
>>> Jens Axboe wrote:
>>>       
>>>> On Wed, Aug 30 2006, Jeffrey E. Hundstad wrote:
>>>>  
>>>>         
>>>>> I tried your splie-git...tar.gz file and tried the splice-cp.  It 
>>>>> produced files that are the right length... but the files only contain 
>>>>> nulls.  Here's the straces:
>>>>>    
>>>>>           
>>>> Works for me as well. Could be an fs issue, how large was the README and
>>>> what filesystem did you use?
>>>>
>>>>  
>>>>         
>>> The file was 1130 bytes (it was the README in that directory.)  The 
>>> filesystem is XFS.
>>>
>>>       
>> I can reproduce this quite easily, doing:
>>
>> nelson:~ # splice-cp sda.blktrace.0 foo
>>
>> nelson:~ # md5sum sda.blktrace.0 foo
>> 4754070ae77091468c830ea23b125d68  sda.blktrace.0
>> efdc7b9d00692fdfe91a691277209267  foo
>>     
>
> Busted write side - splice-in works fine, splice-out is an alias
> for /dev/zero. The reason it's full of NULLs:
>
> death:/mnt# xfs_bmap -vv foo
> foo: no extents
> death:/mnt#
>
> It's a hole.  Nothing has been flushed out to disk.
>
> Interesting - the inode is leaving pipe_to_file() dirty, the page is
> dirty, the buffer head is dirty, delay, mapped and uptodate. The
> page is the only page in the radix tree and the radix tree is marked
> dirty.
>
> But it never gets flushed out. Even when I use dd to seek past the
> first disk block and write further into the file, I still end up
> with a hole in the range where the original splice write should
> be which means it was no longer in the page cache.
>
> Copying a large file I can see dirty memory increase to tens of
> megabytes.  Nothing is going to disk, writeback is not going above
> zero.  Interestingly, when the write completes, the size of the page
> cache drops by almost exactly the size of the file being written -
> almost like a truncate_inode_pages() is occuring on file close.
>
> Oh, look - we _are_ tossing away all the pages on close.
>
> xfs_splice_write() hasn't updated the xfs inode size when extending the
> file. The linux inode  has the correct value, but xfs thinks that it's
> only got a speculative allocation EOF (i.e. 0) so we invalidate it
> before it gets to disk.
>
> The patch below just copies some code out of xfs_write() where it updates
> the xfs inode size and drops it in xfs_splice_write(). It's almost certainly not
> the right fix, but the bucket under the pipe will now catch most of the
> bits....
>
> Cheers,
>
> Dave.
>   

I can confirm that this patch allows splice-cp to work as expected!

Thanks all!

-- 
Jeffrey Hundstad
