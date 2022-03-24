Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C797C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 10:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbiCXKYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 06:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiCXKYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 06:24:20 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E343DDE2
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 03:22:48 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nXKcA-0000Hv-L6; Thu, 24 Mar 2022 11:22:46 +0100
Message-ID: <5d1a6abb-f2e7-55bb-a616-04890f3186f2@leemhuis.info>
Date:   Thu, 24 Mar 2022 11:22:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [Bug 215687] New: chown behavior on XFS is changed
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
References: <bug-215687-201763@https.bugzilla.kernel.org/>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        linux-xfs@vger.kernel.org, bugzilla-daemon@kernel.org
In-Reply-To: <bug-215687-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1648117368;6cf45b74;
X-HE-SMSGID: 1nXKcA-0000Hv-L6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

On 15.03.22 09:12, bugzilla-daemon@kernel.org wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=215687
> 
>            Summary: chown behavior on XFS is changed

Darrick, what's up with this bug reported more than ten days ago? It's a
a regression reported the reporter even bisected to a change of yours
(e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") --
see the ticket for details) – but nothing happened afaics. Did the
discussion about this continue somewhere else or did it fall through the
cracks?

Anyway: I'm adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced e014f37db1a2d109afa750042ac4d69cf3e3d88e
#regzbot title xfs: chown behavior changed
#regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215687
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

