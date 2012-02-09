Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q199pXG4157319 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 03:51:33 -0600
Message-ID: <4F3396ED.9070406@oracle.com>
Date: Thu, 09 Feb 2012 17:50:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
References: <4F2FE410.2040508@oracle.com>
	<20120208085557.GI20305@dastard>	<4F328163.8020800@oracle.com>
	<20120208224412.GA7479@dastard>
In-Reply-To: <20120208224412.GA7479@dastard>
Reply-To: jeff.liu@oracle.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 02/09/2012 06:44 AM, Dave Chinner wrote:

> On Wed, Feb 08, 2012 at 10:06:27PM +0800, Jeff Liu wrote:
>> On 02/08/2012 04:55 PM, Dave Chinner wrote:
>>
>>> On Mon, Feb 06, 2012 at 10:30:40PM +0800, Jeff Liu wrote:
>>>> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
>>>>
>>>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>>
>>> This has the same problems with $seq.out as 279, so I won't repeat
>>> them here.
>>>
>>> .....
>>>> +_cleanup()
>>>> +{
>>>> +	rm -f $src $dest
>>>> +}
>>>> +
>>>> +# seek_copy_test_01()
>>>> +# create a 100Mytes file in preallocation mode.
>>>> +# fallocate offset start from 0.
>>>> +# the first data extent offset start from 80991, write 4Kbytes,
>>>> +# and then skip 195001 bytes for next write.
>>>
>>> Oh, man, you didn't write a program to do this, do you?
>>
>> Unfortunately, I have already included file creation at seek_copy_tester :(
>>
>>> This is what
>>> xfs_io is for - to create arbitary file configurations as quickly as
>>> you can type them.  Then all you need is a simple program that
>>> copies the extents, and the test can check everything else.
>>
>> Yes, xfs_io is pretty cool, and it really convenient for file creation for XFS.
> 
> xfs_io is filesystem agnostic. Currently it needs the "-F" flag to
> tell it to work on non-xfs filesystems, but Eric posted patches a
> couple of days ago to remove that (i.e to automatically detect XFS
> filesystems and enable all the xfs specific stuff).

Awesome! I just playing around it, so far so cool. :)

> 
>> I wrote it(create_data_and_holes()) in seek_copy_tester since I'd make it as a general SEEK_DATA/SEEK_HOLE tester
>> for other file systems without this utility too.
> 
> xfs_io is used all throughout xfstests in generic tests. Just look
> at common.punch::_test_generic_punch as an example. That function
> uses xfs_io to test the different methods of perallocation and hole
> punching supported by a bunch of different filesystems in 3
> different tests. IOWs, the generic tests use fallocate and the XFS
> specific tests use XFS ioctls, but all tests use xfs_io to run the
> commands....

Now I understand your opinions, those changes will be reflect in V3.

> 
>>>> +# seek_copy_test_02()
>>>> +# create a 100Mytes file in preallocation mode.
>>>> +# fallocate offset start from 0.
>>>> +# the first data extent offset start from 0, write 16Kbytes,
>>>> +# and then skip 8Mbytes for next write.
>>>> +# Try flushing DIRTY pages to WRITEBACK mode, this is intended to
>>>> +# test data buffer lookup in WRITEBACK pages.
>>>
>>> There's no guarantee that that the seeks will occur while the pages
>>> are in the writeback. It's entirely dependent on IO latency -
>>> writing 16k of data to a disk cache will take less time than it
>>> takes to go back up into userspace and start the sparse copy.
>>> Indeed, i suspect that the 16x16k IOs that this tes does will fit
>>> all into that category even on basic SATA configs....
>>>
>>> Also, you could the fadvise command in xfs_io to do this, as
>>> POSIX_FADV_DONTNEED will trigger async writeback -it will then skip
>>> invalidation of pages under writeback so they will remain in the
>>> cache. i.e. '-c "fadvise -d 0 100m"'
>>>
>>> Ideally, we should add all the different sync methods to an xfs_io
>>> command...
>>
>> Thanks again for the detained info.
>> It's definitely depending on the IO latency to test cover those page status conversion.
>> I have verified the old patch with page probe routine on my laptop SATA disk controller,
>> but not tried against other faster controllers.  If we agree to make it as a general tester, maybe I can
>> try to implement it by referring to xfs_io fadvise, I guess it use posix_fadvise(2), will check it later.
> 
> Yes, it uses posix_fadvise64().
> 
> As it is, I spent 15 minutes adding support for sync_file_range()
> to xfs_io. The patch is attached below.

I'll apply your patch to try it out.

Thanks,
-Jeff

> 
>>>> +# the first data extent offset start from 512, write 4Kbytes,
>>>> +# and then skip 1Mbytes for next write.
>>>> +# don't make holes at the end of file.
>>>
>>> I'm not sure what this means - you always write zeros at the end of
>>> file, and the only difference is that "make holes at EOF" does an
>>> ftruncate to the total size before writing zeros up to it. It
>>> appears to me like you end up with the same file size and shape
>>> either way....
>>
>> Oops! this is a code bug. I want to create a hole at EOF if possible when "-E(wrote_hole_at_eof)" option was specified.
>> It can be fixed as below FIXME:
> 
> Yes, that'd work ;)
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
