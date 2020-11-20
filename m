Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F6DC5519F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 04:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D33C2236F
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 04:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKTEKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 23:10:33 -0500
Received: from sandeen.net ([63.231.237.45]:58362 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgKTEKd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Nov 2020 23:10:33 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6ADD3D70;
        Thu, 19 Nov 2020 22:10:04 -0600 (CST)
Subject: Re: [PATCH v2 5/9] xfs_db: add inobtcnt upgrade path
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     bfoster@redhat.com, linux-xfs@vger.kernel.org
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
 <20201116211351.GT9695@magnolia>
 <cd58a995-7146-abfc-f24e-76b57067cebb@sandeen.net>
 <20201120010521.GH9695@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <90f0f048-08b5-e37b-2a21-1d02764a3c8d@sandeen.net>
Date:   Thu, 19 Nov 2020 22:10:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201120010521.GH9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/19/20 7:05 PM, Darrick J. Wong wrote:
> On Wed, Nov 18, 2020 at 03:05:42PM -0600, Eric Sandeen wrote:

...

>> so this seems to have exposed a hole in how repair deals with unknown features
>> when the inprogress bit is set.
>>
>> And TBH scampering off to find backup superblocks to "repair" an inprogress
>> filesystem seems like ... not the right thing to do after a feature upgrade.
>>
>> I'm not sure what's better, but 
>>
>>> bad primary superblock - filesystem mkfs-in-progress bit set !!!
>>
>> seems ... unexpected for this purpose.
> 
> Yeah.  Dave suggested that I use an incompat flag for this, so I think
> I'll do that instead since inprogress is such a mess.

And I'll try to get to validating V5 features earlier in the repair cycle ...

-Eric
