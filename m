Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46683C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 20:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA75F2078B
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 20:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgI1UHL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 16:07:11 -0400
Received: from sandeen.net ([63.231.237.45]:37642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgI1UHL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 16:07:11 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0DA17616653;
        Mon, 28 Sep 2020 15:06:27 -0500 (CDT)
To:     Pavel Reichl <preichl@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <144faa13-75be-4742-11cf-81cf30ae71b8@redhat.com>
 <13fecca0-4391-d6b0-7ae4-7260a4386eb8@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsdump: rename worker threads
Message-ID: <582df092-ad79-67c0-bcd1-87d58f45805e@sandeen.net>
Date:   Mon, 28 Sep 2020 15:07:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <13fecca0-4391-d6b0-7ae4-7260a4386eb8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/28/20 2:41 PM, Pavel Reichl wrote:
> Hi,
> 
> patch looks good to me, it applies and xfsdump builds fine.
> 
> However, could I ask about the directory change below?
> 
>>  	immediate mode rewind, etc. is enabled.  Setting this bit
>>  	will disable immediate mode rewind on the drive, independent
>> -	of the setting of tpsc_immediate_rewind (in master.d/tpsc) */
>> +	of the setting of tpsc_immediate_rewind (in the tpsc sysgen file) */
> 
> Who makes and removes the master.d directory, that was not part of the patch, right?

It's an IRIX leftover - I just described it rather than listing
an actual OS path.  You're right that it's slightly different from
the exact patch description but it's for the same purpose, though in
this case I'm really just trying to make a certain script shut up ;)

Thanks,
-Eric

> Thanks.
> 
> Reviewed-by: Pavel Reichl <preichl@redhat.com>
> 
