Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Jan 2007 00:02:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0B82bqw032039
	for <xfs@oss.sgi.com>; Thu, 11 Jan 2007 00:02:39 -0800
Message-ID: <45A5EEE1.6000802@melbourne.sgi.com>
Date: Thu, 11 Jan 2007 19:01:37 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: Review: fix mapping invalidation callouts
References: <20070108040309.GX33919298@melbourne.sgi.com> <20070110062344.GR33919298@melbourne.sgi.com> <45A4A645.5010708@sgi.com> <20070111064958.GC33919298@melbourne.sgi.com>
In-Reply-To: <20070111064958.GC33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com



David Chinner wrote:
> On Wed, Jan 10, 2007 at 08:39:33AM +0000, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Mon, Jan 08, 2007 at 03:03:09PM +1100, David Chinner wrote:
>>>
>>>> With the recent cancel_dirty_page() changes, a warning was
>>>> added if we cancel a dirty page that is still mapped into
>>>> the page tables.
>>>> This happens in XFS from fs_tosspages() and fs_flushinval_pages()
>>>> because they call truncate_inode_pages().
>>>>
>>>> truncate_inode_pages() does not invalidate existing page mappings;
>>>> it is expected taht this is called only when truncating the file
>>>> or destroying the inode and on both these cases there can be
>>>> no mapped ptes. However, we call this when doing direct I/O writes
>>>> to remove pages from the page cache. As a result, we can rip
>>>> a page from the page cache that still has mappings attached.
>>>>
>>>> The correct fix is to use invalidate_inode_pages2_range() instead
>>>> of truncate_inode_pages(). They essentially do the same thing, but
>>>> the former also removes any pte mappings before removing the page
>>> >from the page cache.
>>>> Comments?
>>>>
>>>> Cheers,
>>>>
>>>> Dave.
>>>> -- 
>>>> Dave Chinner
>>>> Principal Engineer
>>>> SGI Australian Software Group
>>>>
>>>>
>>>> ---
>>>> fs/xfs/linux-2.6/xfs_fs_subr.c |   10 ++++++++--
>>>> 1 file changed, 8 insertions(+), 2 deletions(-)
>>>>
>>>> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c
>>>> ===================================================================
>>>> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2006-12-12 
>>>> 12:05:17.000000000 +1100
>>>> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-01-08 
>>>> 09:30:22.056571711 +1100
>>>> @@ -21,6 +21,8 @@ int  fs_noerr(void) { return 0; }
>>>> int  fs_nosys(void) { return ENOSYS; }
>>>> void fs_noval(void) { return; }
>>>>
>>>> +#define XFS_OFF_TO_PCSIZE(off)	\
>>>> +	(((off) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT)
>>>
>>> I don't think this is right.
>>>
>>> Assuming 4k page size, first = 2k, last = 6k will result in
>>> invalidating page indexes 1 and 2 i.e. offset 4k -> 12k. In fact,
>>> we want to invalidate pages 0 and 1.
>>>
>>> IOWs, I think it should be:
>>>
>>> +#define XFS_OFF_TO_PCINDEX(off)	((off) >> PAGE_CACHE_SHIFT)
>>>
>>> Comments?
>>>
>> Makes sense to me.
> 
> Yeah, you'd think so. The first xfsqa run I do -after- checking it in
> (been running for 24 hours) I get a stack dump with the warning
> in cancel_dirty_page(), so clearly this isn't right either. I'm
> not sure WTF is going on here.
> 
> Chatz, don't push that mod yet....
> 

Ack.

Lets get Donald to pull 2.6.20-rc into 2.6.x-xfs, or do we need to wait
until you have this fixed?

David

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
