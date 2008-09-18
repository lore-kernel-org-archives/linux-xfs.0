Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Sep 2008 14:33:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8ILXMBG020936
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2008 14:33:22 -0700
Message-ID: <48D2C97A.1070703@thebarn.com>
Date: Thu, 18 Sep 2008 14:34:50 -0700
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: REVIEW: Fix for incore extent corruption.
References: <48D19A83.4040608@thebarn.com> <48D1CD46.4010104@sgi.com> <48D1DCD5.7040502@thebarn.com> <48D218AE.9090400@sgi.com>
In-Reply-To: <48D218AE.9090400@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Russell, this fixes xfs_iext_irec_compact_full().  If we don't move
> all the records from the next page into the current page then we need
> to update the er_extoff of the modified page as we move the remaining
> extents up.  Would you mind giving it a go?
>
> --- a/fs/xfs/xfs_inode.c    2008-09-18 18:48:46.000000000 +1000
> +++ b/fs/xfs/xfs_inode.c    2008-09-18 18:57:18.000000000 +1000
> @@ -4623,6 +4623,7 @@ xfs_iext_irec_compact_full(
>                     (XFS_LINEAR_EXTS -
>                         erp_next->er_extcount) *
>                     sizeof(xfs_bmbt_rec_t));
> +                erp_next->er_extoff += ext_diff;
>             }
>         }
>
Cool I'll give it some run through when I done traveling.

I still think compact_full should simply be eliminated since
it really doesn't help, and it's obviously confusing code.
Or we should make sure it works and get rid of compact_pages
since compact_full behaves just like compact_pages when not
doing partial moves.

>
> Russell Cattelan wrote:
>> Lachlan McIlroy wrote:
>>> Russell Cattelan wrote:
>>>>
>>>> Reference:
>>>> http://oss.sgi.com/archives/xfs/2008-06/msg00209.html
>>>>
>>>>
>>>> It turns out that the code in question is still broken.
>>>>
>>>> xfs_iext_irec_compact_full will still corrupt the incore extent 
>>>> list if it does
>>>> the the partial copy of extents from one page to the next.
>>>> I haven't quit figured out where things get out of sync but somehow
>>>> if_real_bytes which tracks the total number of bytes available in
>>>> the extent buffers and if_bytes (which tracks the total bytes used
>>>> for extents.
>>>>
>>>> So at some point the inode thinks is has more extents than 
>>>> allocated pages allow.
>>>> So what happens is xfs_iext_idx_to_irec which uses idxp to pass IN the
>>>> absolute extent index is suppose to change  idxp on the way OUT and 
>>>> erp_idxp
>>>> to be a buffer index pair. What happens is that it doesn't find the 
>>>> extent so idxp
>>>> is left holding the same value as was passed in and erp_idx is 0.
>>>> This causes the extent code to then index way past the end of 
>>>> extent buffer 0
>>>> into garbage mem.
>>>>
>>>> with 4k ext buffers max extent count per buffer is 256.
>>>> example being:
>>>> IN:
>>>> idxp = 400
>>>> should become:
>>>> idexp = 144
>>>> erp_idxp = 1
>>>>
>>>> but we end up not finding the extent so
>>>> we have
>>>> idxp = 400
>>>> erp_idxp =0
>>>>
>>>> so we now index 6400 bytes into a 4k buffer.
>>>>
>>>> Which often times  is a pages of mostly 0 so we end up with access 
>>>> to block 0 errors.
>>>>
>>>> The more I looked at this code the more it didn't make sense to do 
>>>> partial moves.
>>>> Since the list of extent buffers is only scanned once vs restarting 
>>>> the list whenever a partial move is done,
>>>> it is very unlikely to actually free an extent buffer. (granted 
>>>> it's possible but unlikely)
>>>>
>>>> xfs_iext_irec_compact_pages does the same thing as 
>>>> xfs_iext_irec_compact_full except that doesn't handle partial moves.
>>>>
>>>> xfs_iext_irec_compact is written such that ratio of current extents 
>>>> has to be significantly smaller than the current allocated space
>>>> xfs_inode: 4513
>>>> nextents < ( nlists  * XFS_LINEAR_EXT) >> 3
>>>>
>>>> As it turns out 99% of the time it calls xfs_iext_irec_compact_pages
>>>> (which is why it has been so hard to track this bug down).
>>>>
>>>> If you change the 3 to a 1 so the code alway calls compact_full vs 
>>>> compact_pages the extent list will corrupt amost
>>>> immediately.
>>> Awesome work Russell, we'll give it a go.
>>>
>>>>
>>>> Since the code is broken, almost never used, and provides only 
>>>> micro optimization of incore space I propose we just
>>>> remove it all together.
>>> Are you sure the bug is in xfs_iext_irec_compact_full?
>>>
>>> Is it possible that we are still indexing beyond the page when using
>>> xfs_iext_irec_compact_pages but the pages just happen to be sequential
>>> so the indexing gets the extent anyway?
>> I added a bunch of printk to track this down,  the compact_pages path 
>> is hit
>> a lot in fact as far as I can tell all running file systems that 
>> shrink extents and don't crash :-)
>>
>> I should have done this originally my I'm including the modified 
>> makeextents that
>> I used to tickle this problem.
>> It reserves a bunch of space to create a contiguous extents then in 
>> unreserves space to
>> poke a bunch of holes creating a big extent list, it then goes back 
>> and writes the whole
>> file hopefully collapsing extents as it goes.
>>
>> i.e.
>> makeextents -v -c 512 foo ; xfs_bmap -v foo
>> should give you 1024 extents
>> makeextents -v -f -c 512 foo ; xfs_bmap -v foo
>> will do the same thing but fill in the file with writes.
>> The number of resulting extents vary, but sometimes you
>> end up with one extent. sometimes more.
>>
>> If you change the 3 to a 1 in the current code so compact_full is 
>> used vs compact_pages
>> and run the test it will hit some problem every time.
>> xexlist in kdb will show the corruption in the incore list.
>>
>> This will run the code through all 3 formats so if you are lucky you 
>> end up hitting all
>> the cases indirect > 256, direct <= 256, and inline <= 2
>>
>> note:  xfs_iext_indirect_to_direct does call compact_full but in that 
>> case we are already down
>> to under 256 extents (at least we should be ) and at that point 
>> compact_full will behave just like compact_pages.
>>
>>
>>>
>>>>
>>>> I'm also including an xfsidbg patch that for xexlist that prints 
>>>> out buffer offset and index.
>>>>
>>>> -Russell Cattelan
>>>>
>>>>
>>>
>>
>
