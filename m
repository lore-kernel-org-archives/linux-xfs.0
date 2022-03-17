Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100EBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 15:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbiCQPLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 11:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiCQPLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 11:11:54 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D509B204CA8
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 08:10:36 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2781C4CDD57;
        Thu, 17 Mar 2022 10:09:12 -0500 (CDT)
Message-ID: <94893219-b969-c7d4-4b4e-0952ef54d575@sandeen.net>
Date:   Thu, 17 Mar 2022 10:10:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] xfs: make quota default to no warning limit at all
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Catherine Hoang <catherine.hoang@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
References: <20220314180914.GN8224@magnolia>
 <fe974dac-bd1d-f3e7-6bd7-bc3f3cb56dd1@sandeen.net>
 <20220317022219.GX3927073@dread.disaster.area>
 <20220317025330.GY8224@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220317025330.GY8224@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/16/22 9:53 PM, Darrick J. Wong wrote:
> On Thu, Mar 17, 2022 at 01:22:19PM +1100, Dave Chinner wrote:
>> On Wed, Mar 16, 2022 at 12:41:08PM -0500, Eric Sandeen wrote:
>>> On 3/14/22 1:09 PM, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <djwong@kernel.org>
>>>>
>>>> Historically, the quota warning counter was never incremented on a
>>>> softlimit violation, and hence was never enforced.  Now that the counter
>>>> works, the default of 5 warnings is getting enforced, which is a
>>>> breakage that people aren't used to.  In the interest of not introducing
>>>> new fail to things that used to work, make the default warning limit of
>>>> zero, and make zero mean there is no limit.
>>>>
>>>> Sorta-fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings")
>>>> Reported-by: Eric Sandeen <sandeen@sandeen.net>
>>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Darrick and I talked about this offline a bit yesterday, and I think
>>> we reached an understanding/agreement on this .... 
>>>
>>> While this patch will solve the problem of low warning thresholds
>>> rendering timer thresholds useless, I'm still of the opinion that
>>> this is not a feature to fix, but an inadvertent/broken behavior to
>>> remove.
>>>
>>> The concept of a warning limit in xfs quota has been documented as
>>> unimplemented for about 20+ years. Digging through ancient IRIX docs,
>>> the intent may have been to warn once per login session
>>> (which would make more sense with the current limit of 5.) However,
>>> nothing can be found in code archives to indicate that the warning
>>> counter was ever bumped by anything (until the semi-recent change in
>>> Linux.)
>>>
>>> This feature is still documented as unimplemented in the xfs_quota
>>> man page.
>>>
>>> And although there are skeletal functions to manipulate warning limits
>>> in xfs_quota, they cannot be disabled, and the interface differs from
>>> timer limits, so is barely usable.
>>>
>>> There is no concept of a "warning limit" in non-xfs quota tools, either.
>>>
>>> There is no documentation on what constitutes a warning event, or when
>>> it should be incremented.
>>>
>>> tl;dr: While the warning counter bump has been upstream for some time
>>> now, I think we can argue that that does not constitute a feature that
>>> needs fixing or careful deprecation; TBH it looks more like a bug that
>>> should be fixed by removing the increment altogether.
>>>
>>> And then I think we can agree that if warning limits hae been documented
>>> as unimplemented for 20+ years, we can also just remove any other code
>>> that is related to this unimplemented feature.
>>
>> Sounds fine to me. THe less untested, undefined legacy code with
>> custom user APIs we have to carry around the better. Remove it all
>> before someone starts poking at it with a sharp stick and finds a
>> zany zero-day....
> 
> LOLYUP.
> 
> Hey Catherine, are you interested in /removing/ the quota warning limit
> code from XFS?  Note: just the limits, not the actually issuance of
> quota warnings (xfs_quota_warn) nor the warning counter itself.
> 
> I think a good place to start would be to remove the 'warn' field from
> struct xfs_quota_limits, and then remove code as necessary to fix all
> the compilation errors.  I think you can leave the actual warning
> counter itself (struct xfs_dquot_res.warnings) since it (roughly) tracks
> how many times we've sent a warning over netlink to ... wherever they
> go.

I think we also discussed a separate patch to simply remove the counter bump,
which is easily backportable to distros and stable kernels?

thanks,
-Eric
