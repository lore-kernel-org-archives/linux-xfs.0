Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5130C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 23:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E61208B3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 23:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgINXlW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 19:41:22 -0400
Received: from sandeen.net ([63.231.237.45]:34370 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINXlV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 19:41:21 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 37AB017DF0;
        Mon, 14 Sep 2020 18:40:37 -0500 (CDT)
To:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Zdenek Kabelac <zkabelac@redhat.com>
References: <f06e8b9a-d5c8-f91f-8637-0b9f625d9d48@redhat.com>
 <20200914221201.GW12131@dread.disaster.area>
 <48fb5c2a-8db0-3a57-2b0f-0f5f35864e53@redhat.com>
 <20200914233339.GX12131@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] mkfs.xfs: fix ASSERT on too-small device with stripe
 geometry
Message-ID: <26735336-2fe0-d118-1c85-5b0201246b3c@sandeen.net>
Date:   Mon, 14 Sep 2020 18:41:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914233339.GX12131@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 6:33 PM, Dave Chinner wrote:
> On Mon, Sep 14, 2020 at 05:29:17PM -0500, Eric Sandeen wrote:
>> On 9/14/20 5:12 PM, Dave Chinner wrote:
>>> On Mon, Sep 14, 2020 at 01:26:01PM -0500, Eric Sandeen wrote:
>>>> When a too-small device is created with stripe geometry, we hit an
>>>> assert in align_ag_geometry():
>>>>
>>>> # truncate --size=10444800 testfile
>>>> # mkfs.xfs -dsu=65536,sw=1 testfile 
>>>> mkfs.xfs: xfs_mkfs.c:2834: align_ag_geometry: Assertion `cfg->agcount != 0' failed.
>>>>
>>>> This is because align_ag_geometry() finds that the size of the last
>>>> (only) AG is too small, and attempts to trim it off.  Obviously 0
>>>> AGs is invalid, and we hit the ASSERT.
>>>>
>>>> Fix this by skipping the last-ag-trim if there is only one AG, and
>>>> add a new test to validate_ag_geometry() which offers a very specific,
>>>> clear warning if the device (in dblocks) is smaller than the minimum
>>>> allowed AG size.
>>>>
>>>> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
>>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>
>>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>>> index a687f385..da8c5986 100644
>>>> --- a/mkfs/xfs_mkfs.c
>>>> +++ b/mkfs/xfs_mkfs.c
>>>> @@ -1038,6 +1038,15 @@ validate_ag_geometry(
>>>>  	uint64_t	agsize,
>>>>  	uint64_t	agcount)
>>>>  {
>>>> +	/* Is this device simply too small? */
>>>> +	if (dblocks < XFS_AG_MIN_BLOCKS(blocklog)) {
>>>> +		fprintf(stderr,
>>>> +	_("device (%lld blocks) too small, need at least %lld blocks\n"),
>>>> +			(long long)dblocks,
>>>> +			(long long)XFS_AG_MIN_BLOCKS(blocklog));
>>>> +		usage();
>>>> +	}
>>>
>>> Ummm, shouldn't this be caught two checks later down by this:
>>>
>>> 	if (agsize > dblocks) {
>>>                fprintf(stderr,
>>>         _("agsize (%lld blocks) too big, data area is %lld blocks\n"),
>>>                         (long long)agsize, (long long)dblocks);
>>>                         usage();
>>>         }
>>
>> No, because we hit an ASSERT before we ever called this validation
>> function.
> 
> Huh, we're supposed to have already validated the data device size
> is larger than the minimum supported before we try to align the Ag
> sizes to the data dev geometry.
> 
>> The error this is trying to fix is essentially: Do not attempt to
>> trim off the last/only AG in the filesystem.
> 
> But trimming *should never happen* for single AG filesystems. If
> we've got dblocks < minimum AG size for a single AG filesystem and
> we are only discovering that when we are doing AG alignment mods,
> then we've -failed to bounds check dblocks correctly-. We should
> have errored out long before we get to aligning AG geometry.....
> 
> Yup, ok, see validate_datadev(), where we do minimum data subvolume
> size checks:
> 
>         if (cfg->dblocks < XFS_MIN_DATA_BLOCKS) {
>                 fprintf(stderr,
> _("size %lld of data subvolume is too small, minimum %d blocks\n"),
>                         (long long)cfg->dblocks, XFS_MIN_DATA_BLOCKS);
>                 usage();
>         }
> 
> .... and there's the bug:
> 
> #define XFS_MIN_DATA_BLOCKS     100


ew.  Ok, I had missed this, yuk.  Thanks, I'll resend.

Thanks,
-Eric

> 
> That's wrong and that's the bug here: minimum data device
> size is 1 whole AG, which means that this should be:
> 
> #define XFS_MIN_DATA_BLOCKS(cfg)	XFS_AG_MIN_BLOCKS((cfg)->blocklog)
> 
> Cheers,
> 
> Dave.
> 
