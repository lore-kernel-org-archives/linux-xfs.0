Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090F5C4361B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Dec 2020 14:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1D022518
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Dec 2020 14:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgLOO5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 09:57:23 -0500
Received: from sandeen.net ([63.231.237.45]:38386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbgLOO5X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Dec 2020 09:57:23 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0B6B14CDD41;
        Tue, 15 Dec 2020 08:55:47 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
References: <20201208181027.GB1943235@magnolia>
 <20201208191913.GB1685621@bfoster> <20201209032624.GH1943235@magnolia>
 <20201209041950.GY3913616@dread.disaster.area>
 <20201209155211.GB1860561@bfoster> <20201209170428.GC1860561@bfoster>
 <20201209205132.GA3913616@dread.disaster.area>
 <20201210142358.GB1912831@bfoster>
 <20201210215004.GC3913616@dread.disaster.area>
 <20201211133901.GA2032335@bfoster> <20201211233507.GP1943235@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC[RAP] PATCH] xfs: allow setting and clearing of log incompat
 feature flags
Message-ID: <eeab4862-e41f-d32c-24a7-4de336ca0c3c@sandeen.net>
Date:   Tue, 15 Dec 2020 08:56:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211233507.GP1943235@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/11/20 5:35 PM, Darrick J. Wong wrote:
>>> Finally, no, we can't have a truly empty log while the filesystem is
>>> mounted because log transaction records must not be empty. Further,
>>> we can only bring the log down to an "empty but not quite clean"
>>> state while mounted, because if the log is actually marked clean and
>>> we crash then log recovery will not run and so we will not clean up
>>> files that were open-but-unlinked when the system crashed.

> Whatever happened to Eric's patchset to make us process unlinked inodes
> at mount time so that freeze images wouldn't require recovery?

It suffered a fate typical of my patches.  You observed an issue in a test,
Dave did some brief triage, and I haven't gotten back to it.

I'd still like to do that if we can, the requirement to run recovery and/or
use xfs-specific mount options to get a snapshot mounted is still a weird wart.
Pretty sure I've seen at least one user who thought we completely failed
to generate consistent snapshots because "the log was dirty" and
"I had to run repair."

So it'd still be nice to get rid of that behavior IMHO.

-Eric
