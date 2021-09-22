Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E346FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 22:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF056103C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 22:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbhIVWKF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 18:10:05 -0400
Received: from sandeen.net ([63.231.237.45]:35698 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238248AbhIVWJq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Sep 2021 18:09:46 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 03E7214A18;
        Wed, 22 Sep 2021 17:07:51 -0500 (CDT)
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 0/5] xfsprogs: generic serialisation primitives
Message-ID: <63f66d22-8730-6b68-44a6-eda1182a8551@sandeen.net>
Date:   Wed, 22 Sep 2021 17:08:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210916014649.1835564-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/15/21 8:46 PM, Dave Chinner wrote:
> Hi Darrick,
> 
> This is where I think we should be going with spinlocks, atomics,
> and other primitives that the shared libxfs code depends on in the
> kernel...
> 
> -Dave.

So is the proposal that we aim to merge this prior to the 5.14 resync?

Or is this just a demonstration of future things to come ;)

I'm ok with pulling it in now, especially if it helps future work and
avoids pointless mockup reshuffling ...

-Eric
