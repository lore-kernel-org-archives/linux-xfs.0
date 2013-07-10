Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CB097F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 08:14:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FD018F8035
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 06:14:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uBxwIqhdOIWVN4lL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 06:14:06 -0700 (PDT)
Message-ID: <51DD5E26.7020709@oracle.com>
Date: Wed, 10 Jul 2013 21:14:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com> <51DCFF04.9070606@oracle.com>
	<20130710064855.GQ3438@dastard>
In-Reply-To: <20130710064855.GQ3438@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

Thanks for the quick response.

On 07/10/2013 02:48 PM, Dave Chinner wrote:

> On Wed, Jul 10, 2013 at 02:28:20PM +0800, Jeff Liu wrote:
>> Could anyone help to review this patch?
> 
> Sorry, I missed it.
> 
>>> On 32-bit machine, the s_maxbytes is larger than the MAX_LFS_FILESIZE limits if CONFIG_LBDAF is
>>> not enabled.  Hence it's possible to create a huge file via buffered-IO write with a given offset
>>> beyond this limitation. e.g.
>>>
>>> # block_size=4096
>>> # offset=$(((2**32 - 1) * $block_size))
>>> # xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
>>>
>>> In this case, xfs_io will hang at the page writeback stage soon since the given offset would
>>> cause an overflow at xfs_vm_writepage():
>>>
>>> end_index = offset >> PAGE_CACHE_SHIFT;
>>> last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
>>> if (page->index >= end_index) {
>>>                 unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
>>>
>>>                 /*
>>>                  * Just skip the page if it is fully outside i_size, e.g. due
>>>                  * to a truncate operation that is in progress.
>>>                  */
>>>                 if (page->index >= end_index + 1 || offset_into_page == 0) {
>>> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>                         unlock_page(page);
>>>                         return 0;
>>>                 }
>>> end_index is unsigned long so that the max value is '2^32-1 = 4294967295', and it
>>> would be evaluated to the max value with the given offset(when writing the page offset
>>> up to s_max_bytes) for above test case.  As a result, (page->index >= end_index + 1) is
>>> ok as (end_index + 1) is overflowed to ZERO.
>>>
>>> Actually, create a file as above on 32-bit machine should be failed with EFBIG error returned
>>> because there has strict check up at generic_write_checks() against the given offset with a
>>> *correct* s_max_bytes.
>>>
>>> This patch fix the s_max_bytes to MAX_LFS_FILESIZE if the pre-calculated value is greater
>>> than it.
> 
> Isn't MAX_LFS_FILESIZE defined on 32 bit systems to 8TB and the
> problem here is that we are overflowing at 16TB? If so, that means
> addin gthis patch will potentially cause problems with existing
> working setups that have (sparse) files larger than 8TB on 32 bit
> systems.

Yes, but maybe I should say end_index is wrapped to zero rather than
overflow in this situation.

> 
> So, can't we simply subtract PAGE_CACHE_SIZE from the offset
> being returned to avoid this overflow?

It seems that this change does not works to me because page->index is
greater than end_index in most cases for large files.
IOWs, what I mentioned in comment log is incorrect and it misled you.

I worked out another patch, it looks works for this test but I need to
run some extra tests before posting.

Thanks,
-Jeff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
