Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3239AE732E7
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 16:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjI1QU4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjI1QU4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 12:20:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19479199
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 09:20:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C70C433C7;
        Thu, 28 Sep 2023 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695918053;
        bh=b8KrCK0soT7X2GAuI5kG6h0cUleOYImq7T8FFAo8dDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WQW+wqWouOGXss62UTQNcFimygb7b/vRWrl4U6dEdCCxNus1A48Dq+Y3W4KSrsAWe
         Zq9kI5k6ugqUhTRV1yUtgoABtZwp0q9Vod9FBt6N4c7oUq740H4u0FIpA1vdutB7GF
         Gh7/sxrzlEGmokHruiOE0SxnBD2fkOujhNUnvDIE=
Date:   Thu, 28 Sep 2023 09:20:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Chandan Babu R <chandanbabu@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-Id: <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
In-Reply-To: <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
        <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
        <20230926145519.GE11439@frogsfrogsfrogs>
        <ZROC8hEabAGS7orb@dread.disaster.area>
        <20230927014632.GE11456@frogsfrogsfrogs>
        <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
        <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
        <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
        <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
        <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
        <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:

> But please pick the following patch[1] as well, which fixes failures of 
> xfs55[0-2] cases.
> 
> [1] 
> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com

I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
are watching.

But

a) I'm not subscribed to linux-xfs and

b) the changelog fails to describe the userspace-visible effects of
   the bug, so I (and others) are unable to determine which kernel
   versions should be patched.

Please update that changelog and resend?
