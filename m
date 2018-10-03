Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44378 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbeJCUwt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 16:52:49 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5F783B56
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 09:04:12 -0500 (CDT)
Subject: Re: [PATCH 2/2] xfs: Add new constant to mark start of xqmstat
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-3-cmaiolino@redhat.com>
 <eacf197c-98d7-4507-a40f-cf32d49bb5eb@sandeen.net>
 <20181003140054.5kjzhfuit35zldkl@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b7b5bab1-5c6f-2bd8-2953-b6a7f95f4717@sandeen.net>
Date: Wed, 3 Oct 2018 09:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <20181003140054.5kjzhfuit35zldkl@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org



On 10/3/18 9:00 AM, Carlos Maiolino wrote:
> On Wed, Oct 03, 2018 at 07:51:43AM -0500, Eric Sandeen wrote:
>> On 10/3/18 7:35 AM, Carlos Maiolino wrote:
>>> xqmstat information under __xfsstats is used directly by the
>>> /proc/fs/xfs/xqmstat show method, which makes use of struct offsets to
>>> print out the values.
>>>
>>> Currently, the function is setup to start printing values from the offset of
>>> the last marker before xqmstat, so, an update to __xfsstats structure
>>> may also require an update of xqmstat_proc_show() function.
>>>
>>> By adding a new constant, we concentrate any updates do __xfsstats
>>> structure fields locally to the file xfs_stats.h, reducing the
>>> likelyhood of future bugs if an update to xqmstat_proc_show is
>>> forgotten as have happened before.
>>
>> did 
>>
>> BUILD_BUG_ON(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t)) != XFSSTAT_START_XQMSTAT);
>>
>> and/or
>>
>> #define XFSSTAT_START_XQMSTAT	(offsetof(struct __xfsstats, xs_qm_dqreclaims)/sizeof(uint32_t))
> 
> Yup, it worked, although, it still doesn't really close the possibility for
> mistakes here, the first field may change for example and we may end up in the
> same situation.
> 
> I think only the 2nd option (defining START via offsetof), doesn't differ much
> from the approach in the patch, and, using the 1st option (BUILD_BUG_ON), will
> require an update to xqmstat_proc_show() if by any reason we change the quota
> values, so, I thought the simpler version as the patch would suffice and be a
> bit less confusing. But well, feel free to disagree, it's my opinion only and
> not written on stone :P

I'd argue that the first field of xqmstats changing not possible, because
this is essentially a userspacce API.  If we're going to change the format
of xqmstats, we should only add to the end of it.

The thing about using offsetof() is that we'll never have to update the START
define again, even if we add more records to the larger stats structure.

But we can see what others think as well.

-Eric
