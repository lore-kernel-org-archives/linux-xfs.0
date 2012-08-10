Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7A8RkWL038149 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 03:27:46 -0500
Message-ID: <5024C5F6.30706@oracle.com>
Date: Fri, 10 Aug 2012 16:27:34 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/4] xfs: Introduce a new function to find the desired
	type of offset from page cache
References: <501B6B6F.2090101@oracle.com> <5023CC01.3060201@sgi.com>
	<5024C020.5080404@oracle.com>
In-Reply-To: <5024C020.5080404@oracle.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 08/10/12 16:02, Jie Liu wrote:
> On 08/09/12 22:41, Mark Tinguely wrote:
>> On 08/03/12 01:10, Jeff Liu wrote:
>>> Introduce helpers to probe data or hole offset from page cache for
>>> unwritten extents.
>>>
>>> ---
>>>   fs/xfs/xfs_file.c |  213
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   1 files changed, 213 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>>> index 98642cf..aff0c30 100644
>>> --- a/fs/xfs/xfs_file.c
>>> +++ b/fs/xfs/xfs_file.c
>>> @@ -36,6 +36,7 @@
>>>
>>
>>> + * keep the offset argument unchanged.
>>> + */
>>> +STATIC bool
>>> +xfs_lookup_buffer_offset(
>> I am fine with this helper routine.
>>
>>
>>> +
>>> +/*
>>> + * This routine is called to find out and return a data or hole offset
>>> + * from the page cache for unwritten extents according to the desired
>>> + * type for xfs_seek_data() or xfs_seek_hole().
>>> + *
>>> + * The argument offset is used to tell where we start to search from
>>> the
>>> + * page cache.  Map is used to figure out the end points of the
>>> range to
>>> + * lookup pages.
>>> + *
>>> + * Return true if the desired type of offset was found, and the
>>> argument
>>> + * offset is filled with that address.  Otherwise, return false and
>>> keep
>>> + * offset unchanged.
>>> + */
>>> +STATIC bool
>>> +xfs_find_get_desired_pgoff(
>>> +    struct inode        *inode,
>>> +    struct xfs_bmbt_irec    *map,
>>> +    unsigned int        type,
>>> +    loff_t            *offset)
>>> +{
>>> +    struct xfs_inode    *ip = XFS_I(inode);
>>> +    struct xfs_mount    *mp = ip->i_mount;
>>> +    struct pagevec        pvec;
>>> +    pgoff_t            index;
>>> +    pgoff_t            end;
>>> +    loff_t            endoff;
>>> +    loff_t            startoff = *offset;
>>> +    loff_t            lastoff = startoff;
>>> +    bool            found = false;
>>> +
>>> +    pagevec_init(&pvec, 0);
>>> +
>>> +    index = startoff>>  PAGE_CACHE_SHIFT;
>>> +    endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
>>> +    end = endoff>>  PAGE_CACHE_SHIFT;
>>> +    do {
>>> +        int        want;
>>> +        unsigned    nr_pages;
>>> +        unsigned int    i;
>>> +
>>> +        want = min_t(pgoff_t, end - index, (pgoff_t)PAGEVEC_SIZE);
>>> +        nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>>> +                      want);
>>> +        /*
>>> +         * No page mapped into given range.  If we are searching holes
>>> +         * and if this is the first time we got into the loop, it means
>>> +         * that the given offset is landed in a hole, return it.
>>> +         *
>>> +         * If we have already stepped through some block buffers to
>>> find
>>> +         * holes but they all contains data.  In this case, the last
>>> +         * offset is already updated and pointed to the end of the last
>>> +         * mapped page, if it does not reach the endpoint to search,
>>> +         * that means there should be a hole between them.
>>> +         */
>>> +        if (nr_pages == 0) {
>>> +            /* Data search found nothing */
>>> +            if (type == DATA_OFF)
>>> +                break;
>>> +
>>> +            ASSERT(type == HOLE_OFF);
>>> +            if (lastoff == startoff || lastoff<  endoff) {
>>> +                found = true;
>>> +                *offset = lastoff;
>>> +            }
>>> +            break;
>>> +        }
>>> +
>>> +        /*
>>> +         * At lease we found one page.  If this is the first time we
>>> +         * step into the loop, and if the first page index offset is
>>> +         * greater than the given search offset, a hole was found.
>>> +         */
>>> +        if (type == HOLE_OFF&&  lastoff == startoff&&
>>> +            lastoff<  page_offset(pvec.pages[0])) {
>>> +            found = true;
>>> +            break;
>>> +        }
>> I played with the code and appreciate the trickiness of the startoff.
>> I this can be refined a bit more. see below.
>>
>>> +
>>> +        for (i = 0; i<  nr_pages; i++) {
>>> +            struct page    *page = pvec.pages[i];
>>> +            loff_t        b_offset;
>>> +
>>> +            /*
>>> +             * Page index is out of range, searching done.
>>> +             * If the current offset is not reaches the end
>>> +             * of the specified search range, there should
>>> +             * be a hole between them.
>>> +             */
>>> +            if (page->index>  end) {
>>> +                if (type == HOLE_OFF&&  lastoff<  endoff) {
>>> +                    *offset = lastoff;
>>> +                    found = true;
>>> +                }
>>> +                goto out;
>>> +            }
>> Before we take the lock, we can check to see if the page starts later
>> than expected (a hole). The pre-loop start check can be removed and
>> something like the follow added:
>>
>>             /* Skip over this page if it precedes the start offset */
>>                         if (page_offset(page) + PAGE_SIZE < startoff)
>>                                 continue;
>>
>>                         if (type == HOLE_OFF && page_offset(page) >
>> lastoff) {
>>                                 *offset = lastoff;
>>                                 found = true;
>>                                 goto out;
>>                         }
>>
>> My experiment passes your newest, more extensive tests. I can give you
>> the
>> complete experiment patch if you want.
> It's better to show me your code, this really optimize the logic a bit
> than me.
>>
>>> +
>>> +            lock_page(page);
>>> +            /*
>>> +             * Page truncated or invalidated(page->mapping == NULL).
>>> +             * We can freely skip it and proceed to check the next
>>> +             * page.
>>> +             */
>>> +            if (unlikely(page->mapping != inode->i_mapping)) {
>>> +                unlock_page(page);
>>> +                continue;
>>> +            }
>>> +
>>> +            if (!page_has_buffers(page)) {
>>> +                unlock_page(page);
>>> +                continue;
>>> +            }
>> Would this be a hole condition? I suppose the next iteration of the
>> loop will figure this out.
> This is a fuzzy point to me.  If there is no buffer heads associated
> with a page, can we treat it as an invalid page like the mapping check
> up above?
In other words,  an unwritten extent have real block numbers on disk.
Hence a valid page mapping to that exent should have BHs associated
with, Am I right?

Thanks,
-Jeff
>>> +
>>> +            found = xfs_lookup_buffer_offset(page,&b_offset, type);
>>> +            if (found) {
>>> +                /*
>>> +                 * The found offset may be less than the start
>>> +                 * point to search if this is the first time to
>>> +                 * come here.
>>> +                 */
>>> +                *offset = max_t(loff_t, startoff, b_offset);
>>> +                goto out;
>>> +            }
>>> +
>>> +            /*
>>> +             * We either searching data but nothing was found, or
>>> +             * searching hole but found a data buffer.  In either
>>> +             * case, probably the next page contains the desired
>>> +             * things, update the last offset to it so.
>>> +             */
>>> +            lastoff = page_offset(page) + PAGE_SIZE;
>>> +            unlock_page(page);
>>> +        }
>>> +
>>> +        /*
>>> +         * The number of returned pages less than our desired, search
>>> +         * done.  In this case, nothing was found for searching data,
>>> +         * but we found a hole behind the last offset.
>>> +         */
>>> +        if (nr_pages<  want) {
>>> +            if (type == HOLE_OFF) {
>>> +                *offset = lastoff;
>>> +                found = true;
>>> +            }
>>> +            break;
>>> +        }
>>> +
>>> +        index = pvec.pages[i - 1]->index + 1;
>>> +        pagevec_release(&pvec);
>>> +    } while (index<  end);
>>> +
>>> +out:
>>> +    pagevec_release(&pvec);
>>> +    return found;
>>> +}
>>> +
>>>   STATIC loff_t
>>>   xfs_seek_data(
>>>       struct file        *file,
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
