Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467FBC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 20:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D11622C7D
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 20:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgLDUg0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 15:36:26 -0500
Received: from sandeen.net ([63.231.237.45]:40152 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgLDUg0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 15:36:26 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 59BD17906;
        Fri,  4 Dec 2020 14:35:25 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679384513.447856.3675245763779550446.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <d54542e0-728f-52b4-3762-c9353fcae8de@sandeen.net>
Date:   Fri, 4 Dec 2020 14:35:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160679384513.447856.3675245763779550446.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/30/20 9:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A couple of the superblock validation checks apply only to the kernel,
> so move them to xfs_mount.c before we start changing sb_inprogress.
> This also reduces the diff between kernel and userspace libxfs.

My only complaint is that "xfs_sb_validate_mount" isn't really descriptive
at all, and nobody reading the code or comments will know why we've chosen
to move just these two checks out of the common validator...

What does "compatible with this mount" mean?

Maybe just fess up in the comment, and say "these checks are different 
for kernel vs. userspace so we keep them over here" - and as for the
function name, *shrug* not sure I have anything better...

-Eric

