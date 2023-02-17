Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE023C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Feb 2023 15:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBQPFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Feb 2023 10:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjBQPEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2023 10:04:51 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35069187
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 07:04:23 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pT2Gn-0006OJ-UM; Fri, 17 Feb 2023 16:03:29 +0100
Message-ID: <941dd795-1224-a4c8-b53a-6c6b4f21ca5c@leemhuis.info>
Date:   Fri, 17 Feb 2023 16:03:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Content-Language: en-US, de-DE
To:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, djwong@kernel.org,
        dchinner@redhat.com
Cc:     linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <e5004868-4a03-93e5-5077-e7ed0e533996@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1676646263;2306c76e;
X-HE-SMSGID: 1pT2Gn-0006OJ-UM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 17.02.23 12:15, shrikanth hegde wrote:
> We are observing panic on boot upon loading the latest stable tree(v6.2-rc4) in 
> one of our systems. System fails to come up. System was booting well 
> with v5.17, v5.19 kernel. We started seeing this issue when loading v6.0 kernel.
> 
> [...]
> 
> we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821 
> as the bad commit.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced 04755d2e5821
#regzbot title xfs: system fails to boot up due to Internal error
xfs_trans_cancel
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
