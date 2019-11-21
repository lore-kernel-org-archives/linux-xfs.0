Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AC9C432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 23:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06B920637
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 23:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKUXSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 18:18:42 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47468 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbfKUXSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 18:18:42 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5DB347E9DFB;
        Fri, 22 Nov 2019 10:18:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iXvig-0005oN-4C; Fri, 22 Nov 2019 10:18:38 +1100
Date:   Fri, 22 Nov 2019 10:18:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191121231838.GH4614@dread.disaster.area>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121214445.282160-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=XaLMxmfL3zZD--x-jN0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 21, 2019 at 10:44:44PM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---

This is mixing an explanation about why the change is being made
and what was considered when making decisions about the change.

e.g. my first questions on looking at the patch were:

	- why do we need to break up the discards into 2GB chunks?
	- why 2GB?
	- why not use libblkid to query the maximum discard size
	  and use that as the step size instead?
	- is there any performance impact from breaking up large
	  discards that might be optimised by the kernel into many
	  overlapping async operations into small, synchronous
	  discards?

i.e. the reviewer can read what the patch does, but that deosn't
explain why the patch does this. Hence it's a good idea to explain
the problem being solved or the feature requirements that have lead
to the changes in the patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
