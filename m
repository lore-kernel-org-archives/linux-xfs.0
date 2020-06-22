Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DDDC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2FB20738
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cU2pbC4K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgFVR4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:56:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39611 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730179AbgFVR4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 13:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592848573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySuDF4uW5IhgSc5+6f1wy6JDv5FU7nQ5DALwzLWqkuw=;
        b=cU2pbC4KjwvAZE+02Ub3USzB4d86Mi+d2eR3lwcYcCDsj4czSWAAnIdnilsT/nGjiD0aZi
        3lFxwwgMfC/bxqQIi2xu/qncBnDiyx30ghQDXmUlT/dAbkwzjmteFyOF0S9riry+ZxHPts
        eLhoMX0tU0jXIYcoWdSo8X4eRgDe/l8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-AWUGfKRlOj6DKO4q4ct8zA-1; Mon, 22 Jun 2020 13:56:09 -0400
X-MC-Unique: AWUGfKRlOj6DKO4q4ct8zA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F1718005AD;
        Mon, 22 Jun 2020 17:56:08 +0000 (UTC)
Received: from llong.remote.csb (ovpn-116-193.rdu2.redhat.com [10.10.116.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E8AD6FDD1;
        Mon, 22 Jun 2020 17:56:04 +0000 (UTC)
Subject: Re: [PATCH v4] xfs: Fix false positive lockdep warning with
 sb_internal & fs_reclaim
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>
References: <20200618171941.9475-1-longman@redhat.com>
 <20200618225810.GJ2005@dread.disaster.area>
 <20200618230405.GK2005@dread.disaster.area>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <14d9c969-3fbe-ed1f-6821-050fc2c6289e@redhat.com>
Date:   Mon, 22 Jun 2020 13:56:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200618230405.GK2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/18/20 7:04 PM, Dave Chinner wrote:
> On Fri, Jun 19, 2020 at 08:58:10AM +1000, Dave Chinner wrote:
>> On Thu, Jun 18, 2020 at 01:19:41PM -0400, Waiman Long wrote:
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 379cbff438bc..1b94b9bfa4d7 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -913,11 +913,33 @@ xfs_fs_freeze(
>>>   	struct super_block	*sb)
>>>   {
>>>   	struct xfs_mount	*mp = XFS_M(sb);
>>> +	unsigned long		pflags;
>>> +	int			ret;
>>>   
>>> +	/*
>>> +	 * A fs_reclaim pseudo lock is added to check for potential deadlock
>>> +	 * condition with fs reclaim. The following lockdep splat was hit
>>> +	 * occasionally. This is actually a false positive as the allocation
>>> +	 * is being done only after the frozen filesystem is no longer dirty.
>>> +	 * One way to avoid this splat is to add GFP_NOFS to the affected
>>> +	 * allocation calls. This is what PF_MEMALLOC_NOFS is for.
>>> +	 *
>>> +	 *       CPU0                    CPU1
>>> +	 *       ----                    ----
>>> +	 *  lock(sb_internal);
>>> +	 *                               lock(fs_reclaim);
>>> +	 *                               lock(sb_internal);
>>> +	 *  lock(fs_reclaim);
>>> +	 *
>>> +	 *  *** DEADLOCK ***
>>> +	 */
>> The lockdep splat is detailed in the commit message - it most
>> definitely does not need to be repeated in full here because:
>>
>> 	a) it doesn't explain why the splat occurring is, and
>> 	b) we most definitely don't care about how the lockdep check
>> 	   that triggered it is implemented.
> I should have added this:
>
> 	c) a lot of people don't understand what lockdep reports
> 	   are telling them is a problem.
>
> I get a lot of questions like "I saw this lockdep thing, but I can't
> work out what it actually means, so can you have a look at it
> Dave?". Hence I think directly quoting something people tend not to
> understand to explain the problem they didn't understand isn't the
> best approach to improving understanding of the problem...

OK, how about simplifying the comment to as follows:

        /*
          * Disable fs reclaim in memory allocation for fs freeze to avoid
          * causing a possible circular locking dependency lockdep splat
          * involving fs reclaim.
          */

Does that look good enough for you?

Cheers,
Longman

