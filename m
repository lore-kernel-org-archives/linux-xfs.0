Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D89C54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 13:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28ED20736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 13:41:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LePPjrdU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgDXNld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:41:33 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58311 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726791AbgDXNld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 09:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587735692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJReWus574dTgokBL5W4Wy6y/bXkjNce8NGR7Kz3r7w=;
        b=LePPjrdU6msJEZgBco8A/Z0bDuLsgDqkQbXEpGQKfETX4XHlkylf/cR5Jsd5x94JtuIdTM
        As1E3TTDWRAu6Ti9SPvpHlHqOaS7RPnJ3YK4ewGgAL74ozjJf6tDOsjfRsg88EUw0x8Vs2
        WI+odzKiLn6536dVZWtrR4ciCnEyGzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-MTUcSXAyPTOmpu-GPsxurQ-1; Fri, 24 Apr 2020 09:41:30 -0400
X-MC-Unique: MTUcSXAyPTOmpu-GPsxurQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7B89BFC1
        for <linux-xfs@vger.kernel.org>; Fri, 24 Apr 2020 13:41:29 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D95B360605;
        Fri, 24 Apr 2020 13:41:28 +0000 (UTC)
Subject: Re: [PATCH RFC] xfs: log message when allocation fails due to
 alignment constraints
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <37a73948-ff5a-5375-c2e7-54174ae75462@redhat.com>
 <0db6c0a6-5a10-993c-d3f9-d56d36e3c911@redhat.com>
 <20200424124008.GB53690@bfoster>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <0382057a-f682-212c-8f06-f31a22f9f7e3@redhat.com>
Date:   Fri, 24 Apr 2020 08:41:28 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424124008.GB53690@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/24/20 7:40 AM, Brian Foster wrote:
> On Thu, Apr 23, 2020 at 02:52:39PM -0500, Eric Sandeen wrote:
>> On 4/23/20 2:34 PM, Eric Sandeen wrote:

...

>>> Track this case in the allocation args structure, and when an allocation
>>> fails due to alignment constraints, leave a clue in the kernel logs:
>>>
>>>  XFS (loop0): Failed metadata allocation due to 4-block alignment constraint
>>
>> Welp, I always realize what's wrong with the patch right after I send it;
>> I think this reports the failure on each AG that fails, even if a later
>> AG succeeds so I need to get the result up to a higher level.
>>
> 
> Hmm, yeah.. the inode chunk allocation code in particular can make
> multiple attempts at xfs_alloc_vextent() before the higher level
> operation ultimately fails.
> 
>> Still, can see what people think of the idea in general?
>>
> 
> Seems reasonable to me in general..
> 
>> Thanks,
>> -Eric
>>

...

>>> @@ -3067,8 +3071,10 @@ xfs_alloc_vextent(
>>>  	agsize = mp->m_sb.sb_agblocks;
>>>  	if (args->maxlen > agsize)
>>>  		args->maxlen = agsize;
>>> -	if (args->alignment == 0)
>>> +	if (args->alignment == 0) {
>>>  		args->alignment = 1;
>>> +		args->alignfail = 0;
>>> +	}
> 
> Any reason this is reinitialized only when the caller doesn't care about
> alignment? This seems more like something that should be reset on each
> allocation call..

Hm probably not :)
 
> BTW I'm also wondering if this is something that could be isolated to a
> single location by looking at perag state instead of plumbing the logic
> through the allocator args (which is already a mess). I guess we no
> longer have the allocator's perag reference once we're back in the inode
> allocation code, but the xfs_ialloc_ag_select() code does use a perag to
> filter out AGs without enough space. I wonder if that's enough to assume
> alignment is the problem if we attempt a chunk allocation and it
> ultimately fails..? We could also just consider looking at the perag
> again in xfs_dialloc() if the allocation fails, since it looks like we
> still have a reference there.

Thanks, I'll give all that some thought.

>>>  	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
>>>  	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
>>>  	ASSERT(args->minlen <= args->maxlen);
>>> @@ -3227,6 +3233,13 @@ xfs_alloc_vextent(
>>>  
>>>  	}
>>>  	xfs_perag_put(args->pag);
>>> +	if (!args->agbp && args->alignment > 1 && args->alignfail) {
>>> +		xfs_warn_once(args->mp,
>>> +"Failed %s allocation due to %u-block alignment constraint",
>>> +			XFS_RMAP_NON_INODE_OWNER(args->oinfo.oi_owner) ?
>>> +			  "metadata" : "data",
>>> +			args->alignment);
>>> +	}
> 
> Perhaps this should be ratelimited vs. printed once? I suppose there's
> not much value in continuing to print it once an fs is in this inode
> -ENOSPC state, but the tradeoff is that if the user clears the state and
> maybe runs into it again sometime later without a restart, they might
> not see the message and think it's something else. (What about hitting
> the same issue across multiple mounts, btw?). I suppose the ideal
> behavior would be to print once and never again until an inode chunk has
> been successfully allocated (or the system reset)..?

Yeah, I wasn't sure about this being a one-shot.

(Actually, it crossed my mind that maybe we could make the _once variant
reference something in the xfs_mount, so a one-shot warning would printk
once per mp, per mount session?)

Thanks,
-Eric

