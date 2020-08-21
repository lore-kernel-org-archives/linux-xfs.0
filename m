Return-Path: <SRS0=59Ki=B7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C1EC433E3
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 15:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7F1207BB
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Aug 2020 15:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgHUPrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:47:14 -0400
Received: from sandeen.net ([63.231.237.45]:50036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727866AbgHUPrN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Aug 2020 11:47:13 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A63942540;
        Fri, 21 Aug 2020 10:47:08 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs_db: short circuit type_f if type is unchanged
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <8b1ab1c4-64f6-5410-bf40-30776dae4dd5@redhat.com>
 <784ed247-0467-093b-1113-ff80a1289cbd@redhat.com>
 <20200821144603.GL6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <38e1bdc0-dd34-0c4a-1e8a-41c217a7cf62@sandeen.net>
Date:   Fri, 21 Aug 2020 10:46:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200821144603.GL6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/21/20 9:46 AM, Darrick J. Wong wrote:
> On Thu, Aug 20, 2020 at 07:05:37PM -0500, Eric Sandeen wrote:
>> There's no reason to go through the type change code if the
>> type has not been changed.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/type.c b/db/type.c
>> index 3cb1e868..572ac6d6 100644
>> --- a/db/type.c
>> +++ b/db/type.c
>> @@ -216,6 +216,8 @@ type_f(
>>  		tt = findtyp(argv[1]);
>>  		if (tt == NULL) {
>>  			dbprintf(_("no such type %s\n"), argv[1]);
>> +		} else if (iocur_top->typ == tt) {
>> +			return 0;
> 
> Doesn't this mean that verifier errors won't be printed if the user asks
> to set the type to the current type?  e.g.
> 
> xfs_db> agf 0
> xfs_db> addr bnoroot
> xfs_db> fuzz -d level random
> Allowing fuzz of corrupted data with good CRC
> level = 59679
> xfs_db> type bnobt
> Metadata corruption detected at 0x5586779a7b18, xfs_bnobt block 0x8/0x1000
> xfs_db> type bnobt
> Metadata corruption detected at 0x5586779a7b18, xfs_bnobt block 0x8/0x1000

Oh, ok, I hadn't thought about how we could change the buffer after the
fact, I was thinking "nothing should change"

Honestly this isn't critical, it was a trivially backportable fix for the weird
inode thing that Zorro fixed earlier, but with that in place it's not really
necessary.

I could go either way here too.  If we want to rerun verifiers by resetting
the type, that's fine.

-Eric

> <shrug> OTOH, db doesn't consistently have that behavior either --
> inodes only behave like that for crc errors, so maybe this is fine.
> 
> Eh whatever, it's the debugging tool, you should be paying attention
> anyways.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>>  		} else {
>>  			if (iocur_top->typ == NULL)
>>  				dbprintf(_("no current object\n"));
>>
> 
