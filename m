Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D99C433E9
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 00:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2435F64D74
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 00:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhBLAVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 19:21:12 -0500
Received: from sandeen.net ([63.231.237.45]:42112 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhBLAVE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 19:21:04 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E36A33321E2;
        Thu, 11 Feb 2021 18:20:21 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
 <161308438691.3850286.3501696811159590596.stgit@magnolia>
 <2e135dfe-9be6-b5f9-7c06-a10e6e45e3da@sandeen.net>
 <20210212001731.GH7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/11] xfs_repair: allow setting the needsrepair flag
Message-ID: <66984b2d-58d5-856d-5f5c-b0a22fe4c34e@sandeen.net>
Date:   Thu, 11 Feb 2021 18:20:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212001731.GH7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/11/21 6:17 PM, Darrick J. Wong wrote:
> On Thu, Feb 11, 2021 at 05:29:05PM -0600, Eric Sandeen wrote:
>> On 2/11/21 4:59 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
>>> program start and (presumably) clear it by the end of the run.  This
>>> code isn't terribly useful to users; it's mainly here so that fstests
>>> can exercise the functionality.  We don't document this flag in the
>>> manual pages at all because repair clears needsrepair at exit, which
>>> means the knobs only exist for fstests to exercise the functionality.
>>>
>>> Note that we can't do any of these upgrades until we've at least done a
>>> preliminary scan of the primary super and the log.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>
>>
>> I'm still a little on the fence about the cmdline option for crashing
>> repair at a certain point from the POV that Brian kind of pointed out
>> that this doesn't exactly scale as we need more hooks.
> 
> (That's in the next patch.)

I. Am. Awesome.
 
...

> Probably yes, but ... uh I don't want this to drag on into building a
> generic error injection framework for userspace.
> 
> I would /really/ like to get inobtcount/bigtime tests into the kernel
> without a giant detour they have nearly zero test coverage from the
> wider community.

Yeah, I dont' want that either.

this (er, next patch) is s3kr1t and if we have something better later we
can change it.  I'll just merge stuff as-is and move forward.

-Eric
