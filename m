Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C639C54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 16:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534B020728
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 16:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b5WVvfmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDXQ6Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:58:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgDXQ6P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 12:58:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGnHhS118451;
        Fri, 24 Apr 2020 16:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hSgsyFhOV562tsjX27UrLyaAi0A2iZtV/YNZJkc72/M=;
 b=b5WVvfmo1rQNOh8HjeGaKYDOh9fJrmSNKXJDfKEXa0zuiRRShR4YAwxM2WOovtV8iWgQ
 vdSSH7HotkVScZarrv86WIAEJsuV1zxWycHIoxhfCEL/YzTab4ECKWvaIMuWjHtUQpUn
 Q/SDbsRG6sR7nDjpmzE2lJeov146ixWA7nAGry9tM/EuwyalR1nelZabFxJSrBg+sjJi
 rb6ZhLsZE1HiWiYv4g2kCFfl5a3MqpFKp5n4bWWEwQFsO+CCZWGsaiLf67vxXRlqPHaL
 KgsU4NyO/kbqWeClsiiphk6DGFaWHb+fYyU6YEI/WVXKlcLE7MNVotZMiOsmUSqbZb5j vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30k7qe7y77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:58:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OGmP4T114450;
        Fri, 24 Apr 2020 16:58:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1q4qsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 16:58:11 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OGwAwr006515;
        Fri, 24 Apr 2020 16:58:10 GMT
Received: from dhcp-10-159-252-94.vpn.oracle.com (/10.159.252.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 09:58:09 -0700
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
 <20200423230515.GZ27860@dread.disaster.area>
 <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
 <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
 <20200424013948.GA2040@dread.disaster.area>
From:   Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <676ecd15-d8ea-0e18-6075-3cb11f8c2e15@oracle.com>
Date:   Fri, 24 Apr 2020 09:58:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424013948.GA2040@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=11
 spamscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=11 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 4/23/20 6:39 PM, Dave Chinner wrote:
> On Thu, Apr 23, 2020 at 04:19:52PM -0700, Wengang Wang wrote:
>> On 4/23/20 4:14 PM, Wengang Wang wrote:
>>> On 4/23/20 4:05 PM, Dave Chinner wrote:
>>>> On Thu, Apr 23, 2020 at 10:23:25AM -0700, Wengang Wang wrote:
>>>>> xfs_reclaim_inodes_ag() do infinate locking on
>>>>> pag_ici_reclaim_lock at the
>>>>> 2nd round of walking of all AGs when SYNC_TRYLOCK is set
>>>>> (conditionally).
>>>>> That causes dead lock in a special situation:
>>>>>
>>>>> 1) In a heavy memory load environment, process A is doing direct memory
>>>>> reclaiming waiting for xfs_inode.i_pincount to be cleared while holding
>>>>> mutex lock pag_ici_reclaim_lock.
>>>>>
>>>>> 2) i_pincount is increased by adding the xfs_inode to journal
>>>>> transection,
>>>>> and it's expected to be decreased when the transection related
>>>>> IO is done.
>>>>> Step 1) happens after i_pincount is increased and before
>>>>> truansection IO is
>>>>> issued.
>>>>>
>>>>> 3) Now the transection IO is issued by process B. In the IO path
>>>>> (IO could
>>>>> be more complex than you think), memory allocation and memory direct
>>>>> reclaiming happened too.
>>>> Sure, but IO path allocations are done under GFP_NOIO context, which
>>>> means IO path allocations can't recurse back into filesystem reclaim
>>>> via direct reclaim. Hence there should be no way for an IO path
>>>> allocation to block on XFS inode reclaim and hence there's no
>>>> possible deadlock here...
>>>>
>>>> IOWs, I don't think this is the deadlock you are looking for. Do you
>>>> have a lockdep report or some other set of stack traces that lead
>>>> you to this point?
>>> As I mentioned, the IO path can be more complex than you think.
> I don't think the IO path is complex. I *know* the IO path is
> complex. I also know how we manage that complexity to prevent things
> like stacked devices and filesystems from deadlocking, but I also
> know that there are bugs and other architectural deficiencies that
> may be playing a part here.
Right.
>
> The problem is, your description of the problem tells me nothing
> about where the problem might lie. You are telling me what you think
> the problem is, rather than explaining the way the problem comes
> about, what storage stack configuration and IO behaviour triggers
> it, etc. Hence I cannot determine what the problem you are seeing
> actually is, and hence I cannot evaluate whether your patch is
> correct.

I think my description is the generic description, stating  the problem 
in XFS.
The problem is there as long as memory direct reclaiming happens in the 
IO path.

More details about the IO may help to understanding the problem. But 
that's not the main idea of this patch.

I will provide the detail below.

>
>>> The real case I hit is that the process A is waiting for inode unpin on
>>> XFS A which is a loop device backed mount.
>> And actually, there is a dm-thin on top of the loop device..
> Makes no difference, really, because it's still the loop device
> that is doing the IO to the underlying filesystem...
I mentioned IO path here, not the IO its self.  In this case, the IO 
patch includes dm-thin.

We have to consider it as long as we are not sure if there is GPF_KERNEL 
(or any flags without NOFS, NOIO) allocation happens in dm-thin.

If dm-thin has GPF_KERNEL allocation and goes into memory direct 
reclaiming, the deadlock forms.

>>> And the backing file is from a different (X)FS B mount. So the IO is
>>> going through loop device, (direct) writes to (X)FS B.
>>>
>>> The (direct) writes to (X)FS B do memory allocations and then memory
>>> direct reclaims...
> THe loop device issues IO to the lower filesystem in
> memalloc_noio_save() context, which means all memory allocations in
> it's IO path are done with GFP_NOIO context. Hence those allocations
> will not recurse into reclaim on -any filesystem- and hence will not
> deadlock on filesystem reclaim. So what I said originally is correct
> even when we take filesystems stacked via loop devices into account.
You are right here. Seems loop device is doing NOFS|NOIO allocations.

The deadlock happened with a bit lower kernel version which is without 
loop device patch that does NOFS|NOIO allocation.

Well, here you are only talking about loop device, it's not enough to 
say it's also safe in case the memory reclaiming happens at higher layer 
above loop device in the IO path.

> Hence I'll ask again: do you have stack traces of the deadlock or a
> lockdep report? If not, can you please describe the storage setup
> from top to bottom and lay out exactly where in what layers trigger
> this deadlock?

Sharing the callback traces:

Process 61234 is holding mutex pag_ici_reclaim_lock

PID: 61234  TASK: ffff89e7bc6c1ec0  CPU: 39  COMMAND: "java"
  #0 [ffff9be677cdb470] __schedule at ffffffff8f866a9c
  #1 [ffff9be677cdb508] schedule at ffffffff8f8670b6
  #2 [ffff9be677cdb520] io_schedule at ffffffff8f0c73c6
  #3 [ffff9be677cdb538] __dta___xfs_iunpin_wait_3443 at ffffffffc0565087 
[xfs]
  #4 [ffff9be677cdb5b0] xfs_iunpin_wait at ffffffffc0567ca9 [xfs]
  #5 [ffff9be677cdb5c0] __dta_xfs_reclaim_inode_3357 at ffffffffc055b4cc 
[xfs]
  #6 [ffff9be677cdb610] xfs_reclaim_inodes_ag at ffffffffc055b916 [xfs]
  #7 [ffff9be677cdb7a0] xfs_reclaim_inodes_nr at ffffffffc055cb73 [xfs]
  #8 [ffff9be677cdb7c0] xfs_fs_free_cached_objects at ffffffffc056fe79 [xfs]
  #9 [ffff9be677cdb7d0] super_cache_scan at ffffffff8f287927
#10 [ffff9be677cdb828] shrink_slab at ffffffff8f1efa53
#11 [ffff9be677cdb910] shrink_node at ffffffff8f1f5628
#12 [ffff9be677cdb998] do_try_to_free_pages at ffffffff8f1f5b62
#13 [ffff9be677cdba00] try_to_free_pages at ffffffff8f1f5f09
#14 [ffff9be677cdba88] __alloc_pages_slowpath at ffffffff8f1e479d
#15 [ffff9be677cdbba8] __alloc_pages_nodemask at ffffffff8f1e2231
#16 [ffff9be677cdbc18] alloc_pages_current at ffffffff8f243bea
#17 [ffff9be677cdbc48] skb_page_frag_refill at ffffffff8f6f943c
#18 [ffff9be677cdbc68] sk_page_frag_refill at ffffffff8f6f947d
#19 [ffff9be677cdbc80] tcp_sendmsg_locked at ffffffff8f779103
#20 [ffff9be677cdbd30] tcp_sendmsg at ffffffff8f779cec
#21 [ffff9be677cdbd58] inet_sendmsg at ffffffff8f7a8f07
#22 [ffff9be677cdbd80] sock_sendmsg at ffffffff8f6f30ce
#23 [ffff9be677cdbda0] sock_write_iter at ffffffff8f6f3165
#24 [ffff9be677cdbe18] __vfs_write at ffffffff8f28447c
#25 [ffff9be677cdbea0] vfs_write at ffffffff8f284692
#26 [ffff9be677cdbee0] sys_write at ffffffff8f2848f5
#27 [ffff9be677cdbf28] do_syscall_64 at ffffffff8f003949


And  waiter (of that pag_ici_reclaim_lock) process has the following 
call back trace:

PID: 30224  TASK: ffff89f944cd0000  CPU: 52  COMMAND: "loop0"
  #0 [ffff9be663fcb0a8] __schedule at ffffffff8f866a9c
  #1 [ffff9be663fcb140] schedule at ffffffff8f8670b6
  #2 [ffff9be663fcb158] schedule_preempt_disabled at ffffffff8f86740e
  #3 [ffff9be663fcb168] __mutex_lock at ffffffff8f868d7c
  #4 [ffff9be663fcb228] __mutex_lock_slowpath at ffffffff8f8691c3
  #5 [ffff9be663fcb238] mutex_lock at ffffffff8f8691ff
  #6 [ffff9be663fcb250] xfs_reclaim_inodes_ag at ffffffffc055b9b2 [xfs]
  #7 [ffff9be663fcb3e0] xfs_reclaim_inodes_nr at ffffffffc055cb73 [xfs]
  #8 [ffff9be663fcb400] xfs_fs_free_cached_objects at ffffffffc056fe79 [xfs]
  #9 [ffff9be663fcb410] super_cache_scan at ffffffff8f287927
#10 [ffff9be663fcb468] shrink_slab at ffffffff8f1efa53
#11 [ffff9be663fcb550] shrink_node at ffffffff8f1f5628
#12 [ffff9be663fcb5d8] do_try_to_free_pages at ffffffff8f1f5b62
#13 [ffff9be663fcb640] try_to_free_pages at ffffffff8f1f5f09
#14 [ffff9be663fcb6c8] __alloc_pages_slowpath at ffffffff8f1e479d
#15 [ffff9be663fcb7e8] __alloc_pages_nodemask at ffffffff8f1e2231
#16 [ffff9be663fcb858] alloc_pages_current at ffffffff8f243bea
#17 [ffff9be663fcb888] new_slab at ffffffff8f250f09
#18 [ffff9be663fcb8f0] ___slab_alloc at ffffffff8f2517b5
#19 [ffff9be663fcb9b8] __slab_alloc at ffffffff8f255ddd
#20 [ffff9be663fcb9f8] kmem_cache_alloc at ffffffff8f251ab9
#21 [ffff9be663fcba38] mempool_alloc_slab at ffffffff8f1da935
#22 [ffff9be663fcba48] mempool_alloc at ffffffff8f1daa63
#23 [ffff9be663fcbac0] bio_alloc_bioset at ffffffff8f39a7f2
#24 [ffff9be663fcbb10] iomap_dio_actor at ffffffff8f2f1d2d
#25 [ffff9be663fcbb90] iomap_apply at ffffffff8f2f2a07
#26 [ffff9be663fcbc10] iomap_dio_rw at ffffffff8f2f3261
#27 [ffff9be663fcbcc0] __dta_xfs_file_dio_aio_write_3305 at 
ffffffffc0557078 [xfs]
#28 [ffff9be663fcbd10] xfs_file_write_iter at ffffffffc0557551 [xfs]
#29 [ffff9be663fcbd40] lo_rw_aio at ffffffffc075d2ea [loop]
#30 [ffff9be663fcbdc0] loop_queue_work at ffffffffc075ddc2 [loop]
#31 [ffff9be663fcbea8] kthread_worker_fn at ffffffff8f0b889a
#32 [ffff9be663fcbef8] loop_kthread_worker_fn at ffffffffc075b90e [loop]
#33 [ffff9be663fcbf08] kthread at ffffffff8f0b7fd5
#34 [ffff9be663fcbf50] ret_from_fork at ffffffff8fa00344

The deadlock happened in(under) loop device layer, the deadlock under 
loop device may won't happen in newest upstream code. But it still can 
happen at higher layers in the IO path.

thanks,
wengang

