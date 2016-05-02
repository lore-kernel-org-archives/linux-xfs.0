Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A15A27CCD
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 11:03:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 765DC8F8035
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 09:03:48 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id yMl8t7X5SgX1Tjcr
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 09:03:42 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id n129so113303172wmn.1
	for <xfs@oss.sgi.com>; Mon, 02 May 2016 09:03:42 -0700 (PDT)
Message-ID: <57277A59.3000306@plexistor.com>
Date: Mon, 02 May 2016 19:03:37 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>	
	<1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>	
	<5727753F.6090104@plexistor.com>
	<1462204291.11211.20.camel@kernel.org>
In-Reply-To: <1462204291.11211.20.camel@kernel.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Vishal Verma <vishal@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org

On 05/02/2016 06:51 PM, Vishal Verma wrote:
> On Mon, 2016-05-02 at 18:41 +0300, Boaz Harrosh wrote:
>> On 04/29/2016 12:16 AM, Vishal Verma wrote:
>>>
>>> All IO in a dax filesystem used to go through dax_do_io, which
>>> cannot
>>> handle media errors, and thus cannot provide a recovery path that
>>> can
>>> send a write through the driver to clear errors.
>>>
>>> Add a new iocb flag for DAX, and set it only for DAX mounts. In the
>>> IO
>>> path for DAX filesystems, use the same direct_IO path for both DAX
>>> and
>>> direct_io iocbs, but use the flags to identify when we are in
>>> O_DIRECT
>>> mode vs non O_DIRECT with DAX, and for O_DIRECT, use the
>>> conventional
>>> direct_IO path instead of DAX.
>>>
>> Really? What are your thinking here?
>>
>> What about all the current users of O_DIRECT, you have just made them
>> 4 times slower and "less concurrent*" then "buffred io" users. Since
>> direct_IO path will queue an IO request and all.
>> (And if it is not so slow then why do we need dax_do_io at all?
>> [Rhetorical])
>>
>> I hate it that you overload the semantics of a known and expected
>> O_DIRECT flag, for special pmem quirks. This is an incompatible
>> and unrelated overload of the semantics of O_DIRECT.
> 
> We overloaded O_DIRECT a long time ago when we made DAX piggyback on
> the same path:
> 
> static inline bool io_is_direct(struct file *filp)
> {
> 	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
> }
> 

No as far as the user is concerned we have not. The O_DIRECT user
is still getting all the semantics he wants, .i.e no syncs no
memory cache usage, no copies ...

Only with DAX the buffered IO is the same since with pmem it is faster.
Then why not? The basic contract with the user did not break.

The above was just an implementation detail to easily navigate
through the Linux vfs IO stack and make the least amount of changes
in every FS that wanted to support DAX.(And since dax_do_io is much
more like direct_IO then like page-cache IO)

> Yes O_DIRECT on a DAX mounted file system will now be slower, but -
> 
>>
>>>
>>> This allows us a recovery path in the form of opening the file with
>>> O_DIRECT and writing to it with the usual O_DIRECT semantics
>>> (sector
>>> alignment restrictions).
>>>
>> I understand that you want a sector aligned IO, right? for the
>> clear of errors. But I hate it that you forced all O_DIRECT IO
>> to be slow for this.
>> Can you not make dax_do_io handle media errors? At least for the
>> parts of the IO that are aligned.
>> (And your recovery path application above can use only aligned
>>  IO to make sure)
>>
>> Please look for another solution. Even a special
>> IOCTL_DAX_CLEAR_ERROR
> 
>  - see all the versions of this series prior to this one, where we try
> to do a fallback...
> 

And?

So now all O_DIRECT APPs go 4 times slower. I will have a look but if
it is really so bad than please consider an IOCTL or syscall. Or a special
O_DAX_ERRORS flag ...

Please do not trash all the O_DIRECT users, they are the more important
clients, like DBs and VMs.

Thanks
Boaz

>>
>> [*"less concurrent" because of the queuing done in bdev. Note how
>>   pmem is not even multi-queue, and even if it was it will be much
>>   slower then DAX because of the code depth and all the locks and
>> task
>>   switches done in the block layer. In DAX the final memcpy is done
>> directly
>>   on the user-mode thread]
>>
>> Thanks
>> Boaz
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
