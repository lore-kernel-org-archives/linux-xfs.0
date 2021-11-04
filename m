Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B318C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC4D61073
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhKDCdA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:33:00 -0400
Received: from sandeen.net ([63.231.237.45]:55216 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229676AbhKDCdA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 22:33:00 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 64DBA78D1;
        Wed,  3 Nov 2021 21:28:43 -0500 (CDT)
Message-ID: <61845517-12db-0583-a33d-499eae2c9069@sandeen.net>
Date:   Wed, 3 Nov 2021 21:30:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new
 V4 filesystems
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752777.350433.15312061958254066456.stgit@magnolia>
 <20211104022550.GQ24307@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20211104022550.GQ24307@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/3/21 9:25 PM, Darrick J. Wong wrote:
> On Wed, Sep 15, 2021 at 04:12:07PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> The V4 filesystem format is deprecated in the upstream Linux kernel.  In
>> September 2025 it will be turned off by default in the kernel and five
>> years after that, support will be removed entirely.  Warn people
>> formatting new filesystems with the old format, particularly since V4 is
>> not the default.
> 
> Friendly ping?  I don't see this in for-next, but OTOH there hasn't been
> a release either... ;)

Not forgotten - I'm just very behind. Ran it through regression tests and just
wanted to fix up the dumb header file mistake before pushing out -rc1.

-Eric

> --D
> 
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>   mkfs/xfs_mkfs.c |    9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 53904677..b8c11ce9 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
>>   		}
>>   
>>   	} else {	/* !crcs_enabled */
>> +		/*
>> +		 * The V4 filesystem format is deprecated in the upstream Linux
>> +		 * kernel.  In September 2025 it will be turned off by default
>> +		 * in the kernel and in September 2030 support will be removed
>> +		 * entirely.
>> +		 */
>> +		fprintf(stdout,
>> +_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
>> +
>>   		/*
>>   		 * The kernel doesn't support crc=0,finobt=1 filesystems.
>>   		 * If crcs are not enabled and the user has not explicitly
>>
> 
