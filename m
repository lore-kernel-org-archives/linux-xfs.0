Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C52C4363C
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 15:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566F72074B
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 15:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbgJBPPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 11:15:20 -0400
Received: from sandeen.net ([63.231.237.45]:39030 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPPU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 11:15:20 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 573542ACC;
        Fri,  2 Oct 2020 10:14:29 -0500 (CDT)
To:     Ian Kent <raven@themaw.net>, xfs <linux-xfs@vger.kernel.org>
References: <160151439137.66595.8436234885474855194.stgit@mickey.themaw.net>
 <974aaec3-17e4-ecc0-2220-f34ce19348c8@sandeen.net>
 <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: ignore autofs mount table entries
Message-ID: <bb1c53a5-5f96-e1cb-502d-e8e4c1e2a9f3@sandeen.net>
Date:   Fri, 2 Oct 2020 10:15:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <200b30f514e30ecaebb754efb8a8ea5cb4d38fd3.camel@themaw.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/1/20 9:27 PM, Ian Kent wrote:
>> I'm mostly ok with just always and forever filtering out anything
>> that matches
>> "autofs" but if it's unnecessary (like the first case I think?) it
>> may lead
>> to confusion for future code readers.
> I've got feedback from Darrick too, so let me think about what should
> be done.
> 
> What I want out of this is that autofs mounts don't get triggered when
> I start autofs for testing when xfs is the default (root) file system.
> If it isn't the default file system this behaviour mostly doesn't
> happen.

Yep I'm totally on board with that plan in general, thanks.

I wouldn't worry about refactoring in service of the goal, I just wanted
to be sure that we were being strategic/surgical about the changes.

Thanks,
-Eric

> My basic test setup has a couple of hundred direct autofs mounts in
> two or three maps and they all get mounted when starting autofs.
> 
> I'm surprised we haven't had complaints about it TBH but people might
> not have noticed it since they expire away if they don't actually
> get used.
> 
> Ian
> 
