Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0EDC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 20:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B425922A83
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 20:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbgLDUIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 15:08:31 -0500
Received: from sandeen.net ([63.231.237.45]:38872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgLDUIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Dec 2020 15:08:30 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id E61F8335020;
        Fri,  4 Dec 2020 14:07:29 -0600 (CST)
To:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385127.447856.3129099457617444604.stgit@magnolia>
 <20201201161812.GD1205666@bfoster>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <2a5ce5a2-9df4-5c19-13d3-f0a16d8030ba@sandeen.net>
Date:   Fri, 4 Dec 2020 14:07:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201201161812.GD1205666@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/1/20 10:18 AM, Brian Foster wrote:
> On Mon, Nov 30, 2020 at 07:37:31PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Define an incompat feature flag to indicate that the filesystem needs to
>> be repaired.  While libxfs will recognize this feature, the kernel will
>> refuse to mount if the feature flag is set, and only xfs_repair will be
>> able to clear the flag.  The goal here is to force the admin to run
>> xfs_repair to completion after upgrading the filesystem, or if we
>> otherwise detect anomalies.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
> IIUC, we're using an incompat bit to intentionally ensure the filesystem
> cannot mount, even on kernels that predate this particular "needs
> repair" feature. The only difference is that an older kernel would
> complain about an unknown feature and return a different error code.
> Right?
> 
> That seems reasonable, but out of curiousity is there a need/reason for
> using an incompat bit over an ro_compat bit?

I'm a fan of a straight-up incompat, because we don't really know what
format changes in the future might require this flag to be set; nothing
guarantees that future changes will be ro-compat-safe, right?

-Eric
