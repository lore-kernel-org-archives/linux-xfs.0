Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5078DC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jan 2021 01:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1996920723
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Jan 2021 01:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbhAQBJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 20:09:47 -0500
Received: from sandeen.net ([63.231.237.45]:55890 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbhAQBJr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Jan 2021 20:09:47 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7D8D8483534;
        Sat, 16 Jan 2021 19:07:24 -0600 (CST)
Subject: Re: [PATCH v2 0/6] debian: xfsprogs package clean-up
To:     Bastian Germann <bastiangermann@fishpost.de>,
        linux-xfs@vger.kernel.org, Nathan Scott <nathans@redhat.com>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <efbffecf-9dcd-79fd-4fe6-8f0e67d307c0@sandeen.net>
Date:   Sat, 16 Jan 2021 19:09:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/16/21 3:23 AM, Bastian Germann wrote:
> Apply some minor changes to the xfsprogs debian packages, including
> missing copyright notices that are required by Debian Policy.
> 
> v2:
>   resend with Reviewed-by annotations applied, Nathan actually sent:
>   "Signed-off-by: Nathan Scott <nathans@debian.org>"

Heya Nate - please confirm that this was your intent.

-Eric

> 
> Bastian Germann (6):
>   debian: cryptographically verify upstream tarball
>   debian: remove dependency on essential util-linux
>   debian: remove "Priority: extra"
>   debian: use Package-Type over its predecessor
>   debian: add missing copyright info
>   debian: new changelog entry
> 
>  debian/changelog                |  11 ++++
>  debian/control                  |   5 +-
>  debian/copyright                | 111 ++++++++++++++++++++++++++++----
>  debian/upstream/signing-key.asc |  63 ++++++++++++++++++
>  debian/watch                    |   2 +-
>  5 files changed, 175 insertions(+), 17 deletions(-)
>  create mode 100644 debian/upstream/signing-key.asc
> 
