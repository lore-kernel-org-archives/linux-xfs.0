Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C808C43381
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 20:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B66B64EDF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 20:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBJUUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 15:20:06 -0500
Received: from sandeen.net ([63.231.237.45]:45056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhBJUUA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 15:20:00 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 61C1D15D9D;
        Wed, 10 Feb 2021 14:19:15 -0600 (CST)
Subject: Re: [PATCH 07/10] xfs_repair: set NEEDSREPAIR when we deliberately
 corrupt directories
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384405.3057868.8114203697655713495.stgit@magnolia>
 <20210209172059.GE14273@bfoster> <20210209183542.GW7193@magnolia>
 <20210209191422.GL14273@bfoster> <20210209194317.GY7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e585830c-d5d3-d9fd-1bfb-e9bfde255797@sandeen.net>
Date:   Wed, 10 Feb 2021 14:19:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209194317.GY7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/9/21 1:43 PM, Darrick J. Wong wrote:
> On Tue, Feb 09, 2021 at 02:14:22PM -0500, Brian Foster wrote:
>> On Tue, Feb 09, 2021 at 10:35:42AM -0800, Darrick J. Wong wrote:
>>> On Tue, Feb 09, 2021 at 12:20:59PM -0500, Brian Foster wrote:
>>>> On Mon, Feb 08, 2021 at 08:10:44PM -0800, Darrick J. Wong wrote:
>>>>> From: Darrick J. Wong <djwong@kernel.org>
>>>>>
>>>>> There are a few places in xfs_repair's directory checking code where we
>>>>> deliberately corrupt a directory entry as a sentinel to trigger a
>>>>> correction in later repair phase.  In the mean time, the filesystem is
>>>>> inconsistent, so set the needsrepair flag to force a re-run of repair if
>>>>> the system goes down.
>>>>>
>>>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>>>> ---
>>>>
>>>> Hmm.. this seems orthogonal to the rest of the series. I'm sure we can
>>>> come up with various additional uses for the bit, but it seems a little
>>>> odd to me that repair might set it in some cases after a crash but not
>>>> others (if the filesystem happens to already be corrupt, for example).
>>>
>>> <nod> Another option I thought of is to add a hook to the buffer cache
>>> so that the first time anyone tries to bwrite a buffer (either directly
>>> or via a delwri list or normal buffer cache writeback) we'll also set
>>> needsrepair on the ondisk primary super.  That would protect us against
>>> other scenarios like crashing after writing a new AGF but before writing
>>> the new AGI, where the fs is left in an indeterminate state.
>>>
>>
>> Yeah, that _seems_ more appropriate to me. It's not immediately clear to
>> me what the implementation should look like, but in general behavior
>> that sets needsrepair on first modification and clears it as a final
>> step sounds more practical. Then the behavior can be easily explained as
>> "once repair starts on an fs, it must be completed before it is allowed
>> to mount." I do think this should be lifted off for a followon series so
>> we can make progress on the feature upgrade bits without growing more
>> requirements and complexity..
> 
> Oh, definitely. I'll withdraw this patch for now in the interests of
> getting everything else going for Eric. :)

Noted, I'll drop this one for now, thanks.

-Eric
