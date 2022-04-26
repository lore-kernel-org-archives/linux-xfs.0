Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF165C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 05:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbiDZFQQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 01:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiDZFQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 01:16:15 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 40BB61291C0
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 22:13:09 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 91E11170B67;
        Tue, 26 Apr 2022 00:12:46 -0500 (CDT)
Message-ID: <62a78e66-9af5-fcb2-3362-f75a652807cf@sandeen.net>
Date:   Tue, 26 Apr 2022 00:13:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
        david@fromorbit.com
References: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
 <20220426021235.GQ17025@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: revert "xfs: actually bump warning counts when we
 send warnings"
In-Reply-To: <20220426021235.GQ17025@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/25/22 9:12 PM, Darrick J. Wong wrote:
> On Mon, Apr 25, 2022 at 08:33:38PM -0500, Eric Sandeen wrote:
>> This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.
>>
>> XFS quota has had the concept of a "quota warning limit" since
>> the earliest Irix implementation, but a mechanism for incrementing
>> the warning counter was never implemented, as documented in the
>> xfs_quota(8) man page. We do know from the historical archive that
>> it was never incremented at runtime during quota reservation
>> operations.
>>
>> With this commit, the warning counter quickly increments for every
>> allocation attempt after the user has crossed a quote soft
>> limit threshold, and this in turn transitions the user to hard
>> quota failures, rendering soft quota thresholds and timers useless.
>> This was reported as a regression by users.
>>
>> Because the intended behavior of this warning counter has never been
>> understood or documented, and the result of this change is a regression
>> in soft quota functionality, revert this commit to make soft quota
>> limits and timers operable again.
>>
>> Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Assuming you're also going to send a patch to nuke xfs/144 is on its
> way...

Sure thing :)
