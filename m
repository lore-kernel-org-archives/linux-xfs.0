Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93052C2D0E4
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 02:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D4822263
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Nov 2020 02:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKPCfX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Nov 2020 21:35:23 -0500
Received: from sandeen.net ([63.231.237.45]:59698 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgKPCfX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Nov 2020 21:35:23 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 903FD7904;
        Sun, 15 Nov 2020 20:35:00 -0600 (CST)
Subject: Re: [PATCH 05/27] xfsprogs: get rid of ancient btree tracing
 fragments
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-6-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8af75c06-1ada-5db0-4fff-f9bf8ada974b@sandeen.net>
Date:   Sun, 15 Nov 2020 20:35:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201015072155.1631135-6-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/15/20 2:21 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are going to do any userspace tracing, it will be via the
> existing libxfs tracepoint hooks, not the ancient Irix tracing
> macros.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
