Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4A0C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 08:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbiJRIa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiJRIaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 04:30:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10189AF96
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 01:30:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 46D0F33708;
        Tue, 18 Oct 2022 08:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666081808;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xT9SCFafqCqd5TBhMXJPHm+C4U+DY569wfKV8bnVNE=;
        b=pfnu2e1jYPVEmu+V455+xBKqRJVmMxDPDyo+rLV5AgrIusv6mU5KRmszcmyCLKlRueu8xf
        WjbxRcvA9uepNTYDlWtXoxCuH70SCAE1sDQE2Djx6e7amUkRwLfh4BIuH90IF+3tnUAtlt
        MmT+dwFJMlRYwbZuX4G8fgpAOpBmm6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666081808;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xT9SCFafqCqd5TBhMXJPHm+C4U+DY569wfKV8bnVNE=;
        b=BNdtoVwhYlCbm+FztMdk0XI1zDjLGXDSW0WJo4qOk6Sx2BkUmLi6w/7O7rGI1spKkXAM6P
        mIMmL//lARv6zqAQ==
Received: from g78 (unknown [10.100.228.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3BFC22C141;
        Tue, 18 Oct 2022 08:30:07 +0000 (UTC)
References: <20221004090810.9023-1-pvorel@suse.cz> <87sfjmmswf.fsf@suse.de>
 <Y01wmJ0ZT+G+N5IE@pevik>
User-agent: mu4e 1.6.10; emacs 28.1
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>, ltp@lists.linux.it,
        Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH 1/1] df01.sh: Use own fsfreeze implementation for XFS
Date:   Tue, 18 Oct 2022 09:19:28 +0100
Reply-To: rpalethorpe@suse.de
In-reply-to: <Y01wmJ0ZT+G+N5IE@pevik>
Message-ID: <87k04xmt4i.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Petr Vorel <pvorel@suse.cz> writes:

> Hi Richie,
>
>> Hello,
>
>> Petr Vorel <pvorel@suse.cz> writes:
>
>> > df01.sh started to fail on XFS on certain configuration since mkfs.xfs
>> > and kernel 5.19. Implement fsfreeze instead of introducing external
>> > dependency. NOTE: implementation could fail on other filesystems
>> > (EOPNOTSUPP on exfat, ntfs, vfat).
>
>> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
>> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
>> > ---
>> > Hi,
>
>> > FYI the background of this issue:
>> > https://lore.kernel.org/ltp/Yv5oaxsX6z2qxxF3@magnolia/
>> > https://lore.kernel.org/ltp/974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com/
>
>> > @LTP developers: not sure if the consensus is to avoid LTP API
>> > completely (even use it just with TST_NO_DEFAULT_MAIN), if required I
>
>> Why would that be the consensus? :-)
>
> $ ls testcases/lib/*.c |wc -l
> 19
>
> $ git grep -l TST_NO_DEFAULT_MAIN testcases/lib/*.c |wc -l
> 9
>
> => 10 tests not use tst_test.h at all.
> => none is *not* defining TST_NO_DEFAULT_MAIN (not a big surprise),
> but 2 of them (testcases/lib/tst_device.c, testcases/lib/tst_get_free_pids.c)
> implement workaround to force messages to be printed from the new library
> (tst_test.c).

Possibly the reason for this is that it's not clear whether some core
library functions will work as expected if we create an executable with
TST_NO_DEFAULT_MAIN.

However most stuff works fine.

>
> static struct tst_test test = {
> };
> tst_test = &test;
>
> My opinion also was based on Cyril's comments on nfs05_make_tree.c patch, but he
> probably meant to just use TST_NO_DEFAULT_MAIN instead of struct tst_test test:
> https://lore.kernel.org/ltp/YqxFo1iFzHatNRIl@yuki/

Certainly we shouldn't put a test struct in anything which is not a
test. Possibly we could create a util struct

>
>> > can rewrite to use it just to get SAFE_*() macros (like
>> > testcases/lib/tst_checkpoint.c) or even with tst_test workarounds
>> > (testcases/lib/tst_get_free_pids.c).
>
>> Yes, it should work fine with TST_NO_DEFAULT_MAIN
> Both versions IMHO work well, the question what we prefer more.
> Do you vote for rewriting?

Yes, avoiding the LTP library caused a number of problems in sparse-ltp
and the ltx prototype. Then I found linking in the LTP libs with
TST_NO_DEFAULT_MAIN to ltx and using tst_res(TBROK, ...) etc. worked
fine.

-- 
Thank you,
Richard.
