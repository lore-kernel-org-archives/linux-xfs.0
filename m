Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L5515P038898 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 00:05:01 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id xA8ACLrwatfpDdB4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 22:05:00 -0700 (PDT)
Message-ID: <503316F2.9050704@oracle.com>
Date: Tue, 21 Aug 2012 13:04:50 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data
	or hole offset from page cache
References: <5028FC2E.2010802@oracle.com> <20120820231309.GJ19235@dastard>
In-Reply-To: <20120820231309.GJ19235@dastard>
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
Cc: xfs@oss.sgi.com

On 08/21/12 07:13, Dave Chinner wrote:
> On Mon, Aug 13, 2012 at 09:07:58PM +0800, Jeff Liu wrote:
>> helper routine to lookup data or hole offset from page cache for unwritten extents.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ....
>> +		unsigned int	i;
>> +
>> +		want = min_t(pgoff_t, end - index, (pgoff_t)PAGEVEC_SIZE);
> No need for the cast to (pgoff_t) here. That's what the min_t()
> macro does for you.
Thanks for pointing this out.
>
>> +		for (i = 0; i < nr_pages; i++) {
>> +			struct page	*page = pvec.pages[i];
>> +			loff_t		b_offset;
>> +
>> +			/*
>> +			 * Page index is out of range, searching done.
>> +			 * If the current offset is not reaches the end
>> +			 * of the specified search range, there should
>> +			 * be a hole between them.
>> +			 */
>> +			if (page->index > end) {
>> +				if (type == HOLE_OFF && lastoff < endoff) {
>> +					*offset = lastoff;
>> +					found = true;
>> +				}
>> +				goto out;
>> +			}
>> +
>> +			lock_page(page);
>> +			/*
>> +			 * Page truncated or invalidated(page->mapping == NULL).
>> +			 * We can freely skip it and proceed to check the next
>> +			 * page.
>> +			 */
>> +			if (unlikely(page->mapping != inode->i_mapping)) {
>> +				unlock_page(page);
>> +				continue;
>> +			}
> Still need to check page->index again after locking the page. As
> this isn't performance critical, I don't think you need the check
> before the page is locked, anyway....
I understand that we have to check page->mapping with page locked
because race against inode truncation.
But could you teaching me why page->index will be changed in either
memory reclaim or truncates even if
the page returned with refcount > 0?

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
