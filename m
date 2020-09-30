Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6423AC4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1664720789
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgI3QAl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:00:41 -0400
Received: from sandeen.net ([63.231.237.45]:53870 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3QAl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Sep 2020 12:00:41 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 649CB14A11;
        Wed, 30 Sep 2020 10:59:53 -0500 (CDT)
Subject: Re: [PATCH] xfs_repair: be more helpful if rtdev is not specified for
 rt subvol
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
 <20200930155945.GM49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b620072-ecf6-549a-c9e0-1dfff7150b6a@sandeen.net>
Date:   Wed, 30 Sep 2020 11:00:40 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930155945.GM49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/30/20 10:59 AM, Darrick J. Wong wrote:
> On Wed, Sep 30, 2020 at 10:54:42AM -0500, Eric Sandeen wrote:
>> Today, if one tries to repair a filesystem with a realtime subvol but
>> forgets to specify the rtdev on the command line, the result sounds dire:
>>
>> Phase 1 - find and verify superblock...
>> xfs_repair: filesystem has a realtime subvolume
>> xfs_repair: realtime device init failed
>> xfs_repair: cannot repair this filesystem.  Sorry.
>>
>> We can be a bit more helpful, following the log device example:
>>
>> Phase 1 - find and verify superblock...
>> This filesystem has a realtime subvolume.  Specify rt device with the -r option.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/libxfs/init.c b/libxfs/init.c
>> index cb8967bc..65cc3d4c 100644
>> --- a/libxfs/init.c
>> +++ b/libxfs/init.c
>> @@ -429,9 +429,9 @@ rtmount_init(
>>  	if (sbp->sb_rblocks == 0)
>>  		return 0;
>>  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
>> -		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
>> -			progname);
>> -		return -1;
>> +		fprintf(stderr, _("This filesystem has a realtime subvolume.  "
>> +			   "Specify rt device with the -r option.\n"));
> 
> _("%s: realtime subvolume must be specified.\n")?

except if we were called by xfs_copy, it can't handle it at all.

I'll need to move this to repair-specific code.

> --D
> 
>> +		exit(1);
>>  	}
>>  	mp->m_rsumlevels = sbp->sb_rextslog + 1;
>>  	mp->m_rsumsize =
>>
> 
