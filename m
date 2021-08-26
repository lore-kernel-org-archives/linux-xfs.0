Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15574C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 08:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0ED361076
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 08:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbhHZIha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 04:37:30 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:43155 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229652AbhHZIh3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 04:37:29 -0400
Received: from [192.168.0.3] (ip5f5aeb42.dynamic.kabel-deutschland.de [95.90.235.66])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EA42C61E30B9C
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 10:36:41 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: =?UTF-8?B?eHNfaWdfYXR0ZW1wdHMg4omgIHhzX2lnX2ZvdW5kICsgeHNfaWdfbWlz?=
 =?UTF-8?Q?sed?=
To:     linux-xfs@vger.kernel.org
Message-ID: <e9072acd-2daa-96da-f1f2-bca7870d6b55@molgen.mpg.de>
Date:   Thu, 26 Aug 2021 10:36:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear Linux folks,


In the internal statistics [1] the attempts to look up an inode in the 
inode cache (`xs_ig_attempts`) is a little bigger (35) than the sum of 
found and missed entries minus duplicates (`xfs.inode_ops.ig_dup`): 
651067226 = 651067191 + 35 > 651067191 = 259143798 + 391923706 - 313.

     $ grep ^ig /sys/fs/xfs/sdc/stats/stats # hardware RAID
     ig 651067226 259143798 75 391923706 313 391196609 8760483

For the software RAID device there is no difference: 794085909 = 
293058663 + 501027325 - 79.

     $ grep ^ig /sys/fs/xfs/md0/stats/stats
     ig 794085909 293058663 18555 501027325 79 500997366 320679

Is the first difference expected?


Kind regards,

Paul


[1]: https://xfs.org/index.php/Runtime_Stats#ig
