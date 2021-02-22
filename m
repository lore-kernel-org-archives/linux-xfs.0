Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5B8C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB5C64DB1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 19:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhBVT0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 14:26:32 -0500
Received: from sandeen.net ([63.231.237.45]:56920 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232954AbhBVTX6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 14:23:58 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F02E4324E5E;
        Mon, 22 Feb 2021 13:23:00 -0600 (CST)
To:     Dave Chinner <david@fromorbit.com>,
        Steve Langasek <steve.langasek@canonical.com>
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
References: <20210220121610.3982-1-bastiangermann@fishpost.de>
 <20210220121610.3982-4-bastiangermann@fishpost.de>
 <20210221041139.GL4662@dread.disaster.area>
 <840CCF3D-7A20-4E35-BA9C-DEC9C05EE70A@canonical.com>
 <20210221220443.GO4662@dread.disaster.area>
 <20210222001639.GA1737229@homer.dodds.net>
 <20210222024425.GP4662@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/4] debian: Regenerate config.guess using debhelper
Message-ID: <957b9913-bcdb-b64c-4c33-6493a91b3838@sandeen.net>
Date:   Mon, 22 Feb 2021 13:23:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222024425.GP4662@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/21/21 8:44 PM, Dave Chinner wrote:
> On Sun, Feb 21, 2021 at 04:16:39PM -0800, Steve Langasek wrote:
>> On Mon, Feb 22, 2021 at 09:04:43AM +1100, Dave Chinner wrote:
>>
>>>> This upstream release ended up with an older version of config.guess in
>>>> the tarball.  Specifically, it was too old to recognize RISC-V as an
>>>> architecture.
>>
>>> So was the RISC-V architecture added to the ubuntu build between the
>>> uploads of the previous version of xfsprogs and xfsprogs-5.10.0? Or
>>> is this an actual regression where the maintainer signed tarball had
>>> RISC-V support in it and now it doesn't?
>>
>> This is a regression.  The previous tarball (5.6.0) had a newer config.guess
>> that recognized RISC-V, the newer one (5.10.0) had an older config.guess.
> 
> Ok.
> 
> Eric, did you change the machine you did the release build from?

I don't recall doing so, but I must have. I guess I remember this coming up
a while ago and maybe I failed to change process in a sticky way.  :/

But - if my local toolchain can cause a regression in a major distro, it seems
like this patch to regenerate is the obvious path forward, to control
the distro-specific build, and not be subject to my personal toolchain whims.

Is that not best practice? (I honestly don't know.)

-Eric
