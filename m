Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042F8C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 18:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D29EC63483
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 18:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242674AbhKOS6K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:58:10 -0500
Received: from sandeen.net ([63.231.237.45]:51562 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243201AbhKOS4L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Nov 2021 13:56:11 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6AE84F8ACC;
        Mon, 15 Nov 2021 12:53:02 -0600 (CST)
Message-ID: <b78f727a-b106-04e7-c578-fc483f874885@sandeen.net>
Date:   Mon, 15 Nov 2021 12:53:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
References: <20211114224339.20246-1-bage@debian.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 0/4] xfsprogs debian updates
In-Reply-To: <20211114224339.20246-1-bage@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/14/21 4:43 PM, Bastian Germann wrote:
> Hi,
> 
> As my Debian package changes were not included with the rc1,
> I resend them with modifications and a new patch by Boian Bonev
> that fixes the current RC build issue in Debian.

Sorry about that, and thanks for the resend.  Thank you for watching
out for the rc1.  I see Darrick is reviewing them, and I trust him
to assess Debian changes, so I'll pull them in when they're reviewed.

Thanks!
-Eric

> I ask you to apply them asap so that I can upload a fixed version.
> 
> Thanks,
> Bastian
> 
> Changelog:
>   v2: - Collect Review tags
>       - Rebase 1st patch on the liburcu-dev addition
>       - Drop debian/changelog changes from 2nd patch
>       - Drop Multi-Arch patch (did not receive feedback in 1.5 months)
>       - Add FTBFS fixing patch by Boian Bonev
>       - Add patch with changelog entry
> 
> Bastian Germann (3):
>    debian: Update Uploaders list
>    debian: Pass --build and --host to configure
>    debian: Add changelog entry for 5.14.0-rc1-1
> 
> Boian Bonev (1):
>    debian: Fix FTBFS
> 
>   debian/changelog | 15 +++++++++++++++
>   debian/control   |  2 +-
>   debian/rules     | 10 ++++++++--
>   3 files changed, 24 insertions(+), 3 deletions(-)
> 
