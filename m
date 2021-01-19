Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6A7C43142
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6037723119
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbhASRa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:30:27 -0500
Received: from sandeen.net ([63.231.237.45]:55212 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389934AbhASRIk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 12:08:40 -0500
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id EBFB633221F;
        Tue, 19 Jan 2021 11:06:06 -0600 (CST)
To:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
Message-ID: <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
Date:   Tue, 19 Jan 2021 11:07:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/21 9:02 AM, Bastian Germann wrote:
> Am 18.01.21 um 22:33 schrieb Eric Sandeen:
>> On 1/16/21 3:23 AM, Bastian Germann wrote:
>>> Apply some minor changes to the xfsprogs debian packages, including
>>> missing copyright notices that are required by Debian Policy.
>>>
>>> v2:
>>>    resend with Reviewed-by annotations applied, Nathan actually sent:
>>>    "Signed-off-by: Nathan Scott <nathans@debian.org>"
>>
>> I've pushed these, plus Nathan's patch to add you to Uploaders
> 
> Thanks! It would be great to have a 5.10.0 version available in Debian bullseye. Currently, it has 5.6.0. The freeze is in three weeks, so to give the package time to migrate it should be uploaded in January.

It's not clear to me who you're asking to do this, but I'm
afraid it's not my role (or my ability). :)

-Eric
