Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L6gDGr047086 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 01:42:13 -0500
Message-ID: <50332DB7.1030303@oracle.com>
Date: Tue, 21 Aug 2012 14:41:59 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data
	or hole offset from page cache
References: <5028FC2E.2010802@oracle.com> <5032583F.6050207@sgi.com>
	<5033149C.5090401@oracle.com> <20120821052529.GO19235@dastard>
In-Reply-To: <20120821052529.GO19235@dastard>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 08/21/12 13:25, Dave Chinner wrote:
> On Tue, Aug 21, 2012 at 12:54:52PM +0800, Jie Liu wrote:
>> On 08/20/12 23:31, Mark Tinguely wrote:
>>> On 08/13/12 08:07, Jeff Liu wrote:
>>>> helper routine to lookup data or hole offset from page cache for
>>>> unwritten extents.
>>>>
>>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>>
>>>> ---
>>>>   fs/xfs/xfs_file.c |  213
>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   1 files changed, 213 insertions(+), 0 deletions(-)
>>>> +STATIC bool
>>>> +xfs_find_get_desired_pgoff(
>>>> +    struct inode        *inode,
>>>> +    struct xfs_bmbt_irec    *map,
>>>> +    unsigned int        type,
>>>> +    loff_t            *offset)
>>>> +{
>>> ...
>>>
>>>> +        for (i = 0; i<  nr_pages; i++) {
>>>> +            struct page    *page = pvec.pages[i];
>>>> +            loff_t        b_offset;
>>>> +
>>>> +            /*
>>>> +             * Page index is out of range, searching done.
>>>> +             * If the current offset is not reaches the end
>>>> +             * of the specified search range, there should
>>>> +             * be a hole between them.
>>>> +             */
>>>> +            if (page->index>  end) {
>>> Shouldn't this sample of the index also be locked?
>> Thanks for the review.  Yes, it should be locked in concert with the
>> sample of index below.
>>
>> However, as I have mentioned at v6,
>> http://oss.sgi.com/archives/xfs/2012-08/msg00028.html
>> I really don't understand why page->index will be changed as those pages
>> returned from pagevec_lookup() should
>> have refcount > 0.  Hence,  those pages can not be removed out of VM
>> cache upon memory reclaim IMHO.
> Ah, true, you are right. It's been a while since I looked at the
> reference count vs truncate vs page locks in detail, and I have
> always tended to err on the side of caution. I'd suggest you need to
> copy the comment from write_cache_pages() here to remind us why it
> is safe to do the check unlocked, otherwise in a couple of years
> time someone will be asking themselves why this is safe... :/
Thanks for your quick response and confirmation, I'll copy the comments so.

Thanks,
-Jeff
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
