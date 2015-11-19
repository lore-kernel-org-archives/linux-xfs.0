Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 64CC829DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 14:54:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 41F9E8F8049
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 12:54:38 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id nWqxpG8XL6ITYaXF
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2015 12:54:35 -0800 (PST)
Received: by wmdw130 with SMTP id w130so256429437wmd.0
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 12:54:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151119155525.GB13055@bfoster.bfoster>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119155525.GB13055@bfoster.bfoster>
Date: Thu, 19 Nov 2015 22:54:34 +0200
Message-ID: <CAE1zotK1hFN4MUQu-93PQNU0pZq3cNdXCi-F4CWup0Li3pq+KQ@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
From: Octavian Purdila <octavian.purdila@intel.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Nov 19, 2015 at 5:55 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
>> Naive implementation for non-mmu architectures: allocate physically
>> contiguous xfs buffers with alloc_pages. Terribly inefficient with
>> memory and fragmentation on high I/O loads but it may be good enough
>> for basic usage (which most non-mmu architectures will need).
>>
>> This patch was tested with lklfuse [1] and basic operations seems to
>> work even with 16MB allocated for LKL.
>>
>> [1] https://github.com/lkl/linux
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>> ---
>
> Interesting, though this makes me wonder why we couldn't have a new
> _XBF_VMEM (for example) buffer type that uses vmalloc(). I'm not
> familiar with mmu-less context, but I see that mm/nommu.c has a
> __vmalloc() interface that looks like it ultimately translates into an
> alloc_pages() call. Would that accomplish what this patch is currently
> trying to do?
>

Hi Brian,

Ah, that sounds nice! We could get rid of the #ifdefs and use a common
path in that case. vmalloc should work on non-mmu and it seems that
there is a vmalloc_to_page() we can use to get the physical pages.
I'll give it a try.

Is there a central place where we could enable the new _XBF_VMEM to be
the default for non-mmu arches?

> I ask because it seems like that would help clean up the code a bit, for
> one. It might also facilitate some degree of testing of the XFS bits
> (even if utilized sparingly in DEBUG mode if it weren't suitable enough
> for generic/mmu use). We currently allocate and map the buffer pages
> separately and I'm not sure if there's any particular reasons for doing
> that outside of some congestion handling in the allocation code and
> XBF_UNMAPPED buffers, the latter probably being irrelevant for nommu.
> Any other thoughts on that?
>
>>  fs/xfs/xfs_buf.c | 27 +++++++++++++++++++++++++++
>>  1 file changed, 27 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 8ecffb3..50b5246 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
> ...
>> @@ -816,11 +835,19 @@ xfs_buf_get_uncached(
>>       if (error)
>>               goto fail_free_buf;
>>
>> +#ifdef CONFIG_MMU
>>       for (i = 0; i < page_count; i++) {
>>               bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
>>               if (!bp->b_pages[i])
>>                       goto fail_free_mem;
>>       }
>> +#else
>> +     bp->b_pages[0] = alloc_pages(flags, order_base_2(page_count));
>> +     if (!bp->b_pages[0])
>> +             goto fail_free_buf;
>> +     for (i = 1; i < page_count; i++)
>> +             bp->b_pages[i] = bp->b_pages[i-1] + 1;
>> +#endif
>
> We still have a path into __free_page() further down in this function if
> _xfs_buf_map_pages() fails. Granted, _xfs_buf_map_pages() should
> probably never fail in this case, but it still looks like a land mine at
> the very least.
>

OK. Adding a i = 1; right before the #endif should take care of that,
if the vmalloc approach does not work.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
