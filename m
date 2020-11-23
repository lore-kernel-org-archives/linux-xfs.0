Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18579C2D0E4
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 20:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C2C20657
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Nov 2020 20:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgKWUO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:14:29 -0500
Received: from sandeen.net ([63.231.237.45]:35954 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgKWUO2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Nov 2020 15:14:28 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25059EDD;
        Mon, 23 Nov 2020 14:14:25 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375529676.881414.3983778876306819986.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/26] xfs_logprint: refactor timestamp printing
Message-ID: <3922d9ed-4ced-a92f-1b0c-749b44d79c1f@sandeen.net>
Date:   Mon, 23 Nov 2020 14:14:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <160375529676.881414.3983778876306819986.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 6:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce type-specific printing functions to xfs_logprint to print an
> xfs_timestamp instead of open-coding the timestamp decoding.  This is
> needed to stay ahead of changes that we're going to make to
> xfs_timestamp_t in the following patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  logprint/log_misc.c      |   18 ++++++++++++++++--
>  logprint/log_print_all.c |    3 +--
>  logprint/logprint.h      |    2 ++
>  3 files changed, 19 insertions(+), 4 deletions(-)
> 

Just for the record, I decided to not take this one; the helper function
with the somewhat vague "compact" arg at the callers doesnt' really seem
worth it, I just open-coded this at the 2 callsites when I did the merge.

Thanks,
-Eric
