Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2430CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Dec 2022 06:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLHG3h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Dec 2022 01:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiLHG3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2022 01:29:36 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EE4D108;
        Wed,  7 Dec 2022 22:29:34 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=3;SR=0;TI=SMTPD_---0VWp5umR_1670480971;
Received: from 30.97.56.240(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWp5umR_1670480971)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 14:29:32 +0800
Message-ID: <09be45f9-bbb1-24e0-bf23-7a327062c469@linux.alibaba.com>
Date:   Thu, 8 Dec 2022 14:29:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] common/populate: Ensure that S_IFDIR.FMT_BTREE is in
 btree format
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org
References: <20221201081208.40147-1-hsiangkao@linux.alibaba.com>
 <Y4jNzE5YJ3wFtsaz@magnolia> <Y4lhi+5nJNl0diaj@B-P7TQMD6M-0146.local>
 <20221206233417.GF2703033@dread.disaster.area>
 <Y4/2ZUIm2MKs6UID@B-P7TQMD6M-0146.local>
 <20221207214831.GI2703033@dread.disaster.area>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221207214831.GI2703033@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/12/8 05:48, Dave Chinner wrote:
> On Wed, Dec 07, 2022 at 10:11:49AM +0800, Gao Xiang wrote:
>> On Wed, Dec 07, 2022 at 10:34:17AM +1100, Dave Chinner wrote:
>>> On Fri, Dec 02, 2022 at 10:23:07AM +0800, Gao Xiang wrote:
>>>>>> +			[ "$nexts" -gt "$(((isize - 176) / 16))" ] && break
>>>>>
>>>>> Only need to calculate this once if you declare this at the top:
>>>>>
>>>>> 	# We need enough extents to guarantee that the data fork is in
>>>>> 	# btree format.  Cycling the mount to use xfs_db is too slow, so
>>>>> 	# watch for when the extent count exceeds the space after the
>>>>> 	# inode core.
>>>>> 	local max_nextents="$(((isize - 176) / 16))"
>>>>>
>>>>> and then you can do:
>>>>>
>>>>> 			[[ $nexts -gt $max_nextents ]] && break
>>>>>
>>>>> Also not a fan of hardcoding 176 around fstests, but I don't know how
>>>>> we'd detect that at all.
>>>>>
>>>>> # Number of bytes reserved for only the inode record, excluding the
>>>>> # immediate fork areas.
>>>>> _xfs_inode_core_bytes()
>>>>> {
>>>>> 	echo 176
>>>>> }
>>>>>
>>>>> I guess?  Or extract it from tests/xfs/122.out?
>>>>
>>>> Thanks for your comments.
>>>>
>>>> I guess hard-coded 176 in _xfs_inode_core_bytes() is fine for now
>>>> (It seems a bit weird to extract a number from a test expected result..)
>>>
>>> Which is wrong when testing a v4 filesystem - in that case the inode
>>> core size is 96 bytes and so max extents may be larger on v4
>>> filesystems than v5 filesystems....
>>
>> Do we really care v4 fs for now since it's deprecated?...
> 
> Yes, there are still lots of v4 filesystems in production
> environments. There shouldn't be many new ones, but there is a long
> tail of existing storage containing v4 filesystems that we must not
> break.
> 
> We have to support v4 filesystems for another few years yet, hence
> we still need solid test coverage on them to ensure we don't
> accidentally break something that is going to bite users before they
> migrate to newer filesystems....
> 
>> Darrick once also 
>> suggested using (isize / 16) but it seems it could take unnecessary time to
>> prepare.. Or we could just use (isize - 96) / 16 to keep v4 work.
> 
> It's taken me longer to write this email than it does to write the
> code to make it work properly. e.g.:
> 
> 	xfs_info $scratch | sed -ne 's/.*crc=\([01]\).*/\1/p'
> 
> And now we have 0 = v4, 1 = v5, and it's trivial to return the
> correct inode size.
> 
> You can even do this trivially with grep:
> 
> 	xfs_info $scratch | grep -wq "crc=1"
> 	if [ $? -eq 0 ]; then
> 		echo 176
> 	else
> 		echo 96
> 	fi
> 
> and now the return value tells us if we have a v4 or v5 filesystem.
> 
> -Dave.

Hi, David

I have written new versions, please see:
https://lore.kernel.org/fstests/20221207093147.1634425-1-ZiyangZhang@linux.alibaba.com/

Regards,
Zhang
