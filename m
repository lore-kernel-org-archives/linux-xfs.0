Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CF2C00528
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 14:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjHGOGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 10:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbjHGOGj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 10:06:39 -0400
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Aug 2023 07:06:19 PDT
Received: from out-64.mta0.migadu.com (out-64.mta0.migadu.com [IPv6:2001:41d0:1004:224b::40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286201FE8
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 07:06:19 -0700 (PDT)
Message-ID: <cdbb886d-96b8-1cad-5853-eaef264a88e4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691416839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FureXkV41D/C+5hcQf6mQ9dUeOIFfTKiHx4hvPOuhkQ=;
        b=E/xYGGM0+cQhKXIvfXHfdSBcxKiQipv+hQODm9ENixFTkJfe4D+yUYC2Ddi1/Lr3l56VPE
        /jS8kVwBFmpSJ3COBivkJ/+aILAevWRJH9pN2PKnxWxh5+CMiH8WuHsOqMbpVat7n2WhBq
        gKZ6voASjEFWenvVh2+8uhagf9mzTdA=
Date:   Mon, 7 Aug 2023 22:00:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5.10 0/2] Fix xfs/179 for 5.10 stable
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, amir73il@gmail.com,
        dchinner@redhat.com, yangx.jy@fujitsu.com,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
References: <20230803093652.7119-1-guoqing.jiang@linux.dev>
 <20230804154757.GI11352@frogsfrogsfrogs>
 <5d44e45b-cb85-b878-f21d-d0b508c3b696@linux.dev>
 <2023080737-marathon-payday-cd03@gregkh>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <2023080737-marathon-payday-cd03@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/7/23 17:11, Greg KH wrote:
> On Mon, Aug 07, 2023 at 10:39:44AM +0800, Guoqing Jiang wrote:
>>
>> On 8/4/23 23:47, Darrick J. Wong wrote:
>>> On Thu, Aug 03, 2023 at 05:36:50PM +0800, Guoqing Jiang wrote:
>>>> Hi,
>>>>
>>>> With the two patches applied, xfs/179 can pass in 5.10.188. Otherwise I got
>>>>
>>>> [root@localhost xfstests]# ./check xfs/179
>>>> FSTYP         -- xfs (non-debug)
>>>> PLATFORM      -- Linux/x86_64 localhost 5.10.188-default #14 SMP Thu Aug 3 15:23:19 CST 2023
>>>> MKFS_OPTIONS  -- -f /dev/loop1
>>>> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/scratch
>>>>
>>>> xfs/179 1s ... [failed, exit status 1]- output mismatch (see /root/xfstests/results//xfs/179.out.bad)
>>>>       --- tests/xfs/179.out	2023-07-13 16:12:27.000000000 +0800
>>>>       +++ /root/xfstests/results//xfs/179.out.bad	2023-08-03 16:55:38.173787911 +0800
>>>>       @@ -8,3 +8,5 @@
>>>>        Check scratch fs
>>>>        Remove reflinked files
>>>>        Check scratch fs
>>>>       +xfs_repair fails
>>>>       +(see /root/xfstests/results//xfs/179.full for details)
>>>>       ...
>>>>       (Run 'diff -u /root/xfstests/tests/xfs/179.out /root/xfstests/results//xfs/179.out.bad'  to see the entire diff)
>>>>
>>>> HINT: You _MAY_ be missing kernel fix:
>>>>         b25d1984aa88 xfs: estimate post-merge refcounts correctly
>>>>
>>>> Ran: xfs/179
>>>> Failures: xfs/179
>>>> Failed 1 of 1 tests
>>>>
>>>> Please review if they are approriate for 5.10 stable.
>>> Seems fine to me, but ... there is no maintainer for 5.10; is your
>>> employer willing to support this LTS kernel?
>> Hi Darrick,
>>
>> Thanks for your review! I think Amir is the maintainer for 5.10 😉. I can
>> help
>> if needed since our kernel is heavily based on 5.10 stable. We also run
>> tests
>> against 5.10 stable, that is why I send fixes patches for it.
>>
>> Hi Greg,
>>
>> Could you consider add the two to your list? Thank you!
> Sorry, but as these would only be in th 5.10.y release, and not in any
> newer stable kernel, you would have a regression if you moved to a newer
> stable kernel branch, right?

Fair enough.

> Because of that, no, I can't take this, nor should you want me to, as
> you would have a regression if you upgraded, right?
>
> I'll be glad to do so if we have backports for all relevant stable
> kernels.
>

I found Ted had mentioned the two commits ([1]), so it probably make sense
to port them to 5.10 as well.

[1]. https://lore.kernel.org/linux-xfs/20230802031039.GC358316@mit.edu/

Thanks,
Guoqing
