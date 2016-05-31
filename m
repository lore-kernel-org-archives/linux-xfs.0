Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2CBC17CA0
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 01:11:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D626AC003
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 23:11:49 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id 85ed6hOQ6Zd424SJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 May 2016 23:11:45 -0700 (PDT)
Subject: Re: shrink_active_list/try_to_release_page bug? (was Re: xfs trace in
	4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage)
References: <20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<574BEA84.3010206@profihost.ag> <20160530223657.GP26977@dastard>
	<20160531010724.GA9616@bbox> <20160531025509.GA12670@dastard>
	<20160531035904.GA17371@bbox> <20160531060712.GC12670@dastard>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <574D2B1E.2040002@profihost.ag>
Date: Tue, 31 May 2016 08:11:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160531060712.GC12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,

Am 31.05.2016 um 08:07 schrieb Dave Chinner:
> On Tue, May 31, 2016 at 12:59:04PM +0900, Minchan Kim wrote:
>> On Tue, May 31, 2016 at 12:55:09PM +1000, Dave Chinner wrote:
>>> On Tue, May 31, 2016 at 10:07:24AM +0900, Minchan Kim wrote:
>>>> On Tue, May 31, 2016 at 08:36:57AM +1000, Dave Chinner wrote:
>>>>> But this is a dirty page, which means it may have delalloc or
>>>>> unwritten state on it's buffers, both of which indicate that there
>>>>> is dirty data in teh page that hasn't been written. XFS issues a
>>>>> warning on this because neither shrink_active_list nor
>>>>> try_to_release_page() check for whether the page is dirty or not.
>>>>>
>>>>> Hence it seems to me that shrink_active_list() is calling
>>>>> try_to_release_page() inappropriately, and XFS is just the
>>>>> messenger. If you turn laptop mode on, it is likely the problem will
>>>>> go away as kswapd will run with .may_writepage = false, but that
>>>>> will also cause other behavioural changes relating to writeback and
>>>>> memory reclaim. It might be worth trying as a workaround for now.
>>>>>
>>>>> MM-folk - is this analysis correct? If so, why is
>>>>> shrink_active_list() calling try_to_release_page() on dirty pages?
>>>>> Is this just an oversight or is there some problem that this is
>>>>> trying to work around? It seems trivial to fix to me (add a
>>>>> !PageDirty check), but I don't know why the check is there in the
>>>>> first place...
>>>>
>>>> It seems to be latter.
>>>> Below commit seems to be related.
>>>> [ecdfc9787fe527, Resurrect 'try_to_free_buffers()' VM hackery.]
>>>
>>> Okay, that's been there a long, long time (2007), and it covers a
>>> case where the filesystem cleans pages without the VM knowing about
>>> it (i.e. it marks bufferheads clean without clearing the PageDirty
>>> state).
>>>
>>> That does not explain the code in shrink_active_list().
>>
>> Yeb, My point was the patch removed the PageDirty check in
>> try_to_free_buffers.
> 
> *nod*
> 
> [...]
> 
>> And I found a culprit.
>> e182d61263b7d5, [PATCH] buffer_head takedown for bighighmem machines
> 
> Heh. You have the combined historic tree sitting around for code
> archeology, just like I do :)
> 
>> It introduced pagevec_strip wich calls try_to_release_page without
>> PageDirty check in refill_inactive_zone which is shrink_active_list
>> now.
> 
> <sigh>
> 
> It was merged 2 days before XFS was merged. Merging XFS made the
> code Andrew wrote incorrect:
> 
>> Quote from
>> "
>>     In refill_inactive(): if the number of buffer_heads is excessive then
>>     strip buffers from pages as they move onto the inactive list.  This
>>     change is useful for all filesystems. [....]
> 
> Except for those that carry state necessary for writeback to be done
> correctly on the dirty page bufferheads.  At the time, nobody doing
> work the mm/writeback code cared about delayed allocation. So we've
> carried this behaviour for 14 years without realising that it's
> probably the source of all the unexplainable warnings we've got from
> XFS over all that time.
> 
> I'm half tempted at this point to mostly ignore this mm/ behavour
> because we are moving down the path of removing buffer heads from
> XFS. That will require us to do different things in ->releasepage
> and so just skipping dirty pages in the XFS code is the best thing
> to do....

does this change anything i should test? Or is 4.6 still the way to go?

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
