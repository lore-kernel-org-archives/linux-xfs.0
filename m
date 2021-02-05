Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276ADC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBF264FB1
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhBETL5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 14:11:57 -0500
Received: from sandeen.net ([63.231.237.45]:34722 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhBETEJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Feb 2021 14:04:09 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1522E1911D;
        Fri,  5 Feb 2021 14:43:40 -0600 (CST)
To:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org
References: <20210205203405.1955-1-bastiangermann@fishpost.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 0/3] debian: minor fixes
Message-ID: <e0520f72-ac0e-7554-dd6a-980dab23d269@sandeen.net>
Date:   Fri, 5 Feb 2021 14:45:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205203405.1955-1-bastiangermann@fishpost.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/5/21 2:34 PM, Bastian Germann wrote:
> This series contains unrelated changes for the xfsprogs Debian package.
> 
> v2: Resend with Reviewed-bys applied.

FYI this is fine, but not necessary - I pull commits out of patchwork and
it magically adds any existing RVBs to each patch.

Thanks,
-Eric

> Bastian Germann (3):
>   debian: Drop unused dh-python from Build-Depends
>   debian: Only build for Linux
>   debian: Prevent installing duplicate changelog
> 
>  debian/changelog | 8 ++++++++
>  debian/control   | 8 ++++----
>  debian/rules     | 2 +-
>  3 files changed, 13 insertions(+), 5 deletions(-)
