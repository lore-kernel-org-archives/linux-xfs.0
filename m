Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B09C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F6264F66
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhBBUYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:24:40 -0500
Received: from sandeen.net ([63.231.237.45]:36796 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233153AbhBBUWl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 15:22:41 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6C37D4C153D;
        Tue,  2 Feb 2021 14:19:52 -0600 (CST)
Subject: Re: [PATCH V1.1] xfsprogs: xfs_fsr: Limit the scope of cmp()
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
References: <eec86b5f-7a4c-c6e6-e8a0-1e4e9a7e042e@sandeen.net>
 <20210126044222.2676922-1-chandanrlinux@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9ae36cba-6be2-d6ca-f75c-0a25944ab232@sandeen.net>
Date:   Tue, 2 Feb 2021 14:21:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210126044222.2676922-1-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/25/21 10:42 PM, Chandan Babu R wrote:
> cmp() function is being referred to from within fsr/xfs_fsr.c. Hence
> this commit limits its scope to the current file.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


