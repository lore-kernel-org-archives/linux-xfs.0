Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284CDC636CD
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Jan 2023 22:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjA3WZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Jan 2023 17:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA3WZb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2023 17:25:31 -0500
X-Greylist: delayed 328 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 14:25:30 PST
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0AC7125B8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jan 2023 14:25:30 -0800 (PST)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C841F490F;
        Mon, 30 Jan 2023 16:18:56 -0600 (CST)
Message-ID: <25c4d75a-ef1a-c8a5-6c9c-0549ebd0edc2@sandeen.net>
Date:   Mon, 30 Jan 2023 16:20:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20230126052910.588098-1-ddouwsma@redhat.com>
 <Y9P7X6GnLA/iJuIa@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfs: allow setting full range of panic tags
In-Reply-To: <Y9P7X6GnLA/iJuIa@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/27/23 10:27 AM, Darrick J. Wong wrote:
> On Thu, Jan 26, 2023 at 04:29:10PM +1100, Donald Douwsma wrote:
>> xfs will not allow combining other panic masks with
>> XFS_PTAG_VERIFIER_ERROR.
>>
>>  sysctl fs.xfs.panic_mask=511
>>  sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>>  fs.xfs.panic_mask = 511
>>
>> Update to the maximum value that can be set to allow the full range of
>> masks.
>>
>> Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")

whoops :)

I wonder ...

>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

...

> The ptag values are a bitmask, not a continuous integer range, so the
> name should have "MASK" in it, e.g.
> 
> #define			XFS_PTAG_MASK	(XFS_PTAG_IFLUSH | \
> 					 XFS_PTAG_LOGRES | \
> 					...
> 
> and follow the customary style where the macro definition lines are
> indented from the name.
> 
> Otherwise this looks fine.
> 
> --D
> 
>> +#define		XFS_MAX_PTAG ( \
>> +			XFS_PTAG_IFLUSH | \
>> +			XFS_PTAG_LOGRES | \
>> +			XFS_PTAG_AILDELETE | \
>> +			XFS_PTAG_ERROR_REPORT | \
>> +			XFS_PTAG_SHUTDOWN_CORRUPT | \
>> +			XFS_PTAG_SHUTDOWN_IOERROR | \
>> +			XFS_PTAG_SHUTDOWN_LOGERROR | \
>> +			XFS_PTAG_FSBLOCK_ZERO | \
>> +			XFS_PTAG_VERIFIER_ERROR)
>> +

...

>> +	.panic_mask	= {	0,		0,		XFS_MAX_PTAG},
>>  	.error_level	= {	0,		3,		11	},
>>  	.syncd_timer	= {	1*100,		30*100,		7200*100},
>>  	.stats_clear	= {	0,		0,		1	},

Do we really gain anything by carefully crafting the max bit that can be set here?
Nothing stops someone from forgetting to update XFS_MAX_PTAG (or whatever it
may be named) in the future, and I think nothing bad happens if you try to turn
on a PTAG that doesn't exist. Should we just set it to LONG_MAX and be done with
it?

(I guess it's maybe nice to tell the user that they're out of range, but it is
a debug knob after all. Just a thought, I'm ot super picky about this.)

-Eric
