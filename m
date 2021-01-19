Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9609C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906C923104
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbhASWCq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:02:46 -0500
Received: from sandeen.net ([63.231.237.45]:40060 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbhASWBH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 17:01:07 -0500
Received: from liberator.local (unknown [10.0.1.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E290611707;
        Tue, 19 Jan 2021 15:58:33 -0600 (CST)
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     nathans@redhat.com, Bastian Germann <bastiangermann@fishpost.de>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
 <49ecc92b-6f67-5938-af41-209a0e303e8e@sandeen.net>
 <522af0f2-8485-148f-1ec2-96576925f88e@fishpost.de>
 <e96dc035-ba4b-1a50-bc2d-fba2d3e552d8@sandeen.net>
 <3a1bd0e4-a4b2-5822-ed1a-d9a443b8ace7@fishpost.de>
 <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <645e0191-1abb-b6e8-7802-45fd289b72a1@sandeen.net>
Date:   Tue, 19 Jan 2021 16:00:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAFMei7MbBu9zfoXfE9+mTo1TtMzov-DEPWj6KPfw7Aa_PMnU4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/19/21 3:26 PM, Nathan Scott wrote:
> Hey all,
> 
> On Wed, Jan 20, 2021 at 4:16 AM Bastian Germann
> <bastiangermann@fishpost.de> wrote:
>> [...]
>> Nathan uploaded most of the versions, so I guess he can upload.
>> The Debian package is "team maintained" though with this list address as
>> recorded maintainer.
>>
> 
> You should have the necessary permissions to do uploads since
> yesterday Bastian - is that not the case?
> 
> BTW Eric, not directly related but I think the -rc versions being
> added to the debian/changelog can lead to some confusion - I *think*
> dpkg finds that version suffix to be more recent than the actual
> release version string (seems odd, but that seemed to be the behaviour
> I observed recently).  Could the release script(s) skip adding -rc
> versions to debian/changelog?

Er, I got yelled at (in the nicest possible way of course) for
/omitting/ -rc versions from the changelog, IIRC.

Tell me more about how upstream should be maintaining distro-specific
metadata?  :/

-Eric
