Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD04C33C8C
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 15:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B8B82081E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 15:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BX/zTP1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgAGPkY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 10:40:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727974AbgAGPkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 10:40:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578411622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfXsBziSfycjtdQIDxeTWgPx4jbch/ijppbuMtikU4c=;
        b=BX/zTP1Ke7FkGWPbmHLZ5jjXSqzXByc/p+6eZgJ4kay6QnOLhyaRptXHQYLnBOu7mBirB1
        ElPGWpexzN+VPSKxoa9zGwPQXimgp9PFUgQ+0te8oMK7Vg5v3Vs2EmZ5rm5bFG6FRI7CbP
        OjoWFb7tzyjoZMvT4cyJsGO9hITkOUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-UiLEDjjUOfq-wmPiyq0FfA-1; Tue, 07 Jan 2020 10:40:19 -0500
X-MC-Unique: UiLEDjjUOfq-wmPiyq0FfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58137802563;
        Tue,  7 Jan 2020 15:40:16 +0000 (UTC)
Received: from llong.remote.csb (dhcp-17-59.bos.redhat.com [10.18.17.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74D7E7BA50;
        Tue,  7 Jan 2020 15:40:12 +0000 (UTC)
Subject: Re: [PATCH] xfs: Fix false positive lockdep warning with sb_internal
 & fs_reclaim
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
References: <20200102155208.8977-1-longman@redhat.com>
 <20200104023657.GA23128@dread.disaster.area>
 <922bff4b-a463-11db-f969-d268462802a1@redhat.com>
 <20200106210127.GC23128@dread.disaster.area>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <92d8a1fc-4b9d-72bb-5b44-9da5f153945e@redhat.com>
Date:   Tue, 7 Jan 2020 10:40:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200106210127.GC23128@dread.disaster.area>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/6/20 4:01 PM, Dave Chinner wrote:
> On Mon, Jan 06, 2020 at 11:12:32AM -0500, Waiman Long wrote:
>> On 1/3/20 9:36 PM, Dave Chinner wrote:
>>> On Thu, Jan 02, 2020 at 10:52:08AM -0500, Waiman Long wrote:
>>>> Depending on the workloads, the following circular locking dependency
>>>> warning between sb_internal (a percpu rwsem) and fs_reclaim (a pseudo
>>>> lock) may show up:
> ....
>>>>   IOWs, this is a false positive, caused by the fact that
>>>>   xfs_trans_alloc() is called from both above and below memory reclaim
>>>>   as well as within /every level/ of freeze processing. Lockdep is
>>>>   unable to describe the staged flush logic in the freeze process that
>>>>   prevents deadlocks from occurring, and hence we will pretty much
>>>>   always see false positives in the freeze path....
>>>>
>>>> Perhaps breaking the fs_reclaim pseudo lock into a per filesystem lock
>>>> may fix the issue. However, that will greatly complicate the logic and
>>>> may not be worth it.
>>> ANd it won't work, because now we'll just get lockedp warnings on
>>> the per-fs reclaim lockdep context.
>> It may or may not work depending on how we are going to break it up. I
>> haven't thought through that alternative yet as I am expecting that it
>> will be a bigger change if we decide to go this route.
> A per-filesystem lock will not work because a single XFS filesystem
> can trigger this "locking" inversion -both contexts that lockdep
> warns about occur in the normal operation of that single filesystem.
>
> The only way to avoid this is to have multiple context specific
> reclaim lockdep contexts per filesystem, and that becomes a mess
> really quickly. The biggest problem with this is that the "lock
> context" is no longer validated consistently across the entire
> filesystem - we con only internally validate the order or each lock
> context against itself, and not against operations in the other lock
> contexts. Hence there's no global validation of lock orders -
> lockdep allows different lock orders in different contexts and so
> that defeats the purpose of using lockdep for this validation.
>
> Indeed, we've been down this path before with lockdep for XFS inode
> locking vs inode reclaim(*), and we removed it years ago because
> multiple lock contexts for different operations and/or life-cycle
> stages just hasn't been reliable or maintainable. We still get false
> positives because we haven't solved the "lockdep can't express the
> dependencies fully" problem, yet we've reduced the lock order
> validation scope of lockdep considerably....
>
That is true. You can make lockdep to check these kind of complicated
dependency accurately.


>>>> Another way to fix it is to disable the taking of the fs_reclaim
>>>> pseudo lock when in the freezing code path as a reclaim on the freezed
>>>> filesystem is not possible as stated above. This patch takes this
>>>> approach by setting the __GFP_NOLOCKDEP flag in the slab memory
>>>> allocation calls when the filesystem has been freezed.
>>> IOWs, "fix" it by stating that "lockdep can't track freeze
>>> dependencies correctly"?
>> The lockdep code has a singular focus on spotting possible deadlock
>> scenarios from a locking point of view.
> IMO, lockdep only works for very simplistic locking strategies.
> Anything complex requires more work to get lockdep annotations
> "correct enough" to prevent false positives than it does to actually
> read the code and very the locking is correct.
>
> Have you noticed we do runs of nested trylock-and-back-out-on-
> failure because we lock objects in an order that might deadlock
> because of cross-object state dependencies that can't be covered by
> lockdep?  e.g. xfs_lock_inodes() which nests up to 5 inodes deep,
> can nest 3 separate locks per inode and has to take into account
> journal flushing depenedencies when locking multiple inodes?
>
> Lockdep is very simplisitic and the complex annotations we need to
> handle situations like the above are very difficult to design,
> use and maintainr. It's so much simpler just to use big hammers like
> GFP_NOFS to shut up all the different types of false positives
> lockdep throws up for reclaim context false positives because after
> all these years there still isn't a viable mechanism to easily
> express this sort of complex dependency chain.
Regarding the trylock-and-back-out-on_failure code, do you think adding
new APIs with timeout for mutex and rwsem and may be spin count for
spinlock will help to at least reduce the number of failures that can
happen in the code. RT mutex does have a rt_mutex_timed_lock(), but
there is no equivalent for mutex and rwsem.
>> The freeze dependency has to be
>> properly translated into appropriate locking sequences to make lockdep
>> work correctly.i
> This is part of the problem - freeze context is not actually a lock
> but it's close enough that freezing on simple filesystems can be
> validated with lockdep annotations. i.e. same basic concept as the
> lockdep reclaim context. However, it just doesn't work reliably for
> more complex subsystems where there are much more subtle and complex
> behavioural interactions and dependencies that a single lock context
> cannot express or be annotated to express. That's where lockdep
> falls down....
>
>> I would say that the use of a global fs_reclaim pseudo
>> lock is not a perfect translation and so it has exception cases we need
>> to handle.
> Exactly the problem.
>
>>> Nope. We are getting rid of kmem_alloc wrappers and all the
>>> associated flags, not adding new ones. Part of that process is
>>> identifying all the places we currently use KM_NOFS to "shut up
>>> lockdep" and converting them to explicit __GFP_NOLOCKDEP flags.
>>>
>>> So right now, this change needs to be queued up behind the API
>>> changes that are currently in progress...
>> That is fine. I can wait and post a revised patch after that. Who is
>> going to make these changes?
> https://lore.kernel.org/linux-xfs/20191120104425.407213-1-cmaiolino@redhat.com/

Thanks for the pointer. I will rebase my patch on top of that.

Cheers,
Longman

