Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F365C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3083664E3D
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 21:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhBLVaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:30:01 -0500
Received: from sandeen.net ([63.231.237.45]:47230 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231335AbhBLV36 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 16:29:58 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6699215D6E;
        Fri, 12 Feb 2021 15:29:09 -0600 (CST)
To:     Markus Mayer <mmayer@broadcom.com>,
        Linux XFS <linux-xfs@vger.kernel.org>
References: <20210212204849.1556406-1-mmayer@broadcom.com>
 <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
Message-ID: <36f95877-ad2d-a392-cacd-0a128d08fb44@sandeen.net>
Date:   Fri, 12 Feb 2021 15:29:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAGt4E5tbyHpDEPtEGK8SYoB4w4srAfHpiBADkR+PpkQyguiLPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/12/21 2:51 PM, Markus Mayer wrote:
>> To prevent issues when the ".o" extension appears in a directory path,
>> ensure that the ".o" -> ".lo" substitution is only performed for the
>> final file extension.
> 
> If the subject should be "[PATCH] xfsprogs: ...", please let me know.

Nah, that's fine, I noticed it.

So did you have a path component that had ".o" in it that got substituted?
Is that what the bugfix is?

Thanks,
-Eric

> Regards,
> -Markus
> 
