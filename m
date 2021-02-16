Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C74C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 19:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E795A64E79
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Feb 2021 19:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhBPTJc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Feb 2021 14:09:32 -0500
Received: from sandeen.net ([63.231.237.45]:38692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231254AbhBPTJ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Feb 2021 14:09:29 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6144E4872E4;
        Tue, 16 Feb 2021 13:08:41 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, nathans@redhat.com
References: <20200930063532.142256-1-david@fromorbit.com>
 <20200930063532.142256-2-david@fromorbit.com>
 <20200930142527.GJ49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs: stats expose padding value at end of qm line
Message-ID: <302e5516-6890-70c5-b190-df6ca5b849ff@sandeen.net>
Date:   Tue, 16 Feb 2021 13:08:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20200930142527.GJ49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 9:25 AM, Darrick J. Wong wrote:
> On Wed, Sep 30, 2020 at 04:35:31PM +1000, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> There are 8 quota stats exposed, but:
>>
>> $ grep qm /proc/fs/xfs/stat
>> qm 0 0 0 1889 308893 0 0 0 0
>> $
>>
>> There are 9 values exposed. Code inspection reveals that the struct
>> xfsstats has a hole in the structure where the values change from 32
>> bit counters to 64 bit counters. pahole output:
>>
>> ....
>> uint32_t                   xs_qm_dquot;          /*   748     4 */
>> uint32_t                   xs_qm_dquot_unused;   /*   752     4 */
>>
>> /* XXX 4 bytes hole, try to pack */
>>
>> uint64_t                   xs_xstrat_bytes;      /*   760     8 */
> 
> Any chance we could use BUILD_BUG_ON(offsetof(xs_xstrat_bytes) % 8 == 0)
> to catch this kind of thing on 64-bit machines in the future?  Or maybe
> we shift the u64 values to the start of the structure to avoid padding
> holes?

Hmm seems like another case of "add more nice things?" killed off the
bugfix.

> Also, does 32-bit XFS have this 9th value?

on my pi it does ;)

# grep qm /proc/fs/xfs/stat
qm 0 0 0 0 0 0 0 0 0


> --D
> 
>> ....
>>
>> Fix this by defining an "end of 32 bit variables" variable that
>> we then use to define the end of the quota line. This will then
>> ensure that we print the correct number of values regardless of
>> structure layout.
>>
>> However, ABI requirements for userspace parsers mean we cannot
>> remove the output that results from this hole, so we also need to
>> explicitly define this unused value until such time that we actually
>> add a new stat that makes the output meaningful.
>>
>> And now we have a defined end of 32bit variables, update the  stats
>> union to be sized to match all the 32 bit variables correctly.
>>
>> Output with this patch:
>>
>> $ grep qm /proc/fs/xfs/stat
>> qm 0 0 0 326 1802 0 6 3 0
>> $
>>
>> Reported-by: Nathan Scott <nathans@redhat.com>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/xfs_stats.c |  2 +-
>>  fs/xfs/xfs_stats.h | 15 +++++++++++++--
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
>> index f70f1255220b..3409b273f00a 100644
>> --- a/fs/xfs/xfs_stats.c
>> +++ b/fs/xfs/xfs_stats.c
>> @@ -51,7 +51,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>>  		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
>>  		{ "refcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
>>  		/* we print both series of quota information together */
>> -		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
>> +		{ "qm",			xfsstats_offset(xs_end_of_32bit_counts)},
>>  	};
>>  
>>  	/* Loop over all stats groups */
>> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
>> index 34d704f703d2..861acf84cb3c 100644
>> --- a/fs/xfs/xfs_stats.h
>> +++ b/fs/xfs/xfs_stats.h
>> @@ -133,6 +133,17 @@ struct __xfsstats {
>>  	uint32_t		xs_qm_dqwants;
>>  	uint32_t		xs_qm_dquot;
>>  	uint32_t		xs_qm_dquot_unused;
>> +	uint32_t		xs_qm_zero_until_next_stat_is_added;
>> +
>> +/*
>> + * Define the end of 32 bit counters as a 32 bit variable so that we don't
>> + * end up exposing an implicit structure padding hole due to the next counters
>> + * being 64bit values. If the number of coutners is odd, this fills the hole. If
>> + * the number of coutners is even the hole is after this variable and the stats
>> + * line will terminate printing at this offset and not print the hole.
>> + */
>> +	uint32_t		xs_end_of_32bit_counts;
>> +
>>  /* Extra precision counters */
>>  	uint64_t		xs_xstrat_bytes;
>>  	uint64_t		xs_write_bytes;
>> @@ -143,8 +154,8 @@ struct __xfsstats {
>>  
>>  struct xfsstats {
>>  	union {
>> -		struct __xfsstats	s;
>> -		uint32_t		a[xfsstats_offset(xs_qm_dquot)];
>> +		struct __xfsstats s;
>> +		uint32_t	a[xfsstats_offset(xs_end_of_32bit_counts)];
>>  	};
>>  };
>>  
>> -- 
>> 2.28.0
>>
> 
