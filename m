Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D13C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2F5761445
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhDUQ1J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:27:09 -0400
Received: from sandeen.net ([63.231.237.45]:52518 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhDUQ1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 12:27:08 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A88D24872FC;
        Wed, 21 Apr 2021 11:25:19 -0500 (CDT)
Subject: Re: [PATCH] repair: fix an uninitialized variable issue
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210421144135.3188137-1-hsiangkao@redhat.com>
 <20210421155327.GR3122264@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d18fbee5-3c81-f841-6421-4c9a8554cdfb@sandeen.net>
Date:   Wed, 21 Apr 2021 11:26:34 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421155327.GR3122264@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/21/21 10:53 AM, Darrick J. Wong wrote:
> On Wed, Apr 21, 2021 at 10:41:35PM +0800, Gao Xiang wrote:
>> An uninitialized variable issue reported by Coverity, it seems
> 
> Minor nit: we often include the coverity id for things it finds.
> Links to a semi-private corporate bug tracker aren't necessarily
> generally useful, but I guess they did find a legit bug so we could
> throw them one crumb.
> 
>> the following for-loop can be exited in advance with isblock == 1,
>> and bp is still uninitialized.
>>
>> In case of that, initialize bp as NULL in advance to avoid this.
>>
>> Fixes: 1f7c7553489c ("repair: don't duplicate names in phase 6")
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Either way, it's not worth holding up this patch, so:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks Darrick and Gao. Easy enough for me to add the coverity ID on commit.

-Eric
