Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFE9C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 20:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 151BE64EE6
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 20:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhBJU1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 15:27:53 -0500
Received: from sandeen.net ([63.231.237.45]:45370 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233391AbhBJU0n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 15:26:43 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 419314A1341;
        Wed, 10 Feb 2021 14:26:01 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
 <20210209172121.GF14273@bfoster> <20210209181001.GT7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
Message-ID: <24586e59-4c91-81e3-5c45-daede5691562@sandeen.net>
Date:   Wed, 10 Feb 2021 14:26:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209181001.GT7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/9/21 12:10 PM, Darrick J. Wong wrote:
> On Tue, Feb 09, 2021 at 12:21:21PM -0500, Brian Foster wrote:
>> On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
>>> program start and (presumably) clear it by the end of the run.  This
>>> code isn't terribly useful to users; it's mainly here so that fstests
>>> can exercise the functionality.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> ---
>>>  repair/globals.c    |    2 ++
>>>  repair/globals.h    |    2 ++
>>>  repair/phase1.c     |   23 +++++++++++++++++++++++
>>>  repair/xfs_repair.c |    9 +++++++++
>>>  4 files changed, 36 insertions(+)
>>>
>>>
>> ...
>>> diff --git a/repair/phase1.c b/repair/phase1.c
>>> index 00b98584..b26d25f8 100644
>>> --- a/repair/phase1.c
>>> +++ b/repair/phase1.c
>>> @@ -30,6 +30,26 @@ alloc_ag_buf(int size)
>>>  	return(bp);
>>>  }
>>>  
>>> +static void
>>> +set_needsrepair(
>>> +	struct xfs_sb	*sb)
>>> +{
>>> +	if (!xfs_sb_version_hascrc(sb)) {
>>> +		printf(
>>> +	_("needsrepair flag only supported on V5 filesystems.\n"));
>>> +		exit(0);
>>> +	}
>>> +
>>> +	if (xfs_sb_version_needsrepair(sb)) {
>>> +		printf(_("Filesystem already marked as needing repair.\n"));
>>> +		return;
>>> +	}
>>
>> Any reason this doesn't exit the repair like the lazy counter logic
>> does? Otherwise seems fine:
> 
> No particular reason.  Will fix for consistency's sake.

I can swap the return; for an exit(0); on my end if you like and note it
in the commit log.

-Eric
