Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C186C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Mar 2022 18:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiCBSUK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Mar 2022 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiCBSUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Mar 2022 13:20:08 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD1AB23BCE
        for <linux-xfs@vger.kernel.org>; Wed,  2 Mar 2022 10:19:23 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 424764CDD56;
        Wed,  2 Mar 2022 12:18:21 -0600 (CST)
Message-ID: <199a3e85-9ee5-1354-e652-ff3d501bd395@sandeen.net>
Date:   Wed, 2 Mar 2022 12:19:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
From:   Eric Sandeen <sandeen@sandeen.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
 <159477799812.3263162.13957383827318048593.stgit@magnolia>
 <01d6be65-f65c-790e-73fb-9529a94673eb@sandeen.net>
Subject: Re: Quota warning woes (was: [PATCH 25/26] xfs: actually bump warning
 counts when we send warnings)
In-Reply-To: <01d6be65-f65c-790e-73fb-9529a94673eb@sandeen.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/1/22 1:31 PM, Eric Sandeen wrote:
> On 7/14/20 8:53 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Currently, xfs quotas have the ability to send netlink warnings when a
>> user exceeds the limits.  They also have all the support code necessary
>> to convert softlimit warnings into failures if the number of warnings
>> exceeds a limit set by the administrator.  Unfortunately, we never
>> actually increase the warning counter, so this never actually happens.
>> Make it so we actually do something useful with the warning counts.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Sooo I got a bug report that this essentially breaks the timer for
> soft quota, because we now (and quite rapidly) hit the default
> 5-warning limit well before we hit any reasonable timer that may
> have been set, and disallow more space usage.
> 
> And those warnings rack up in somewhat unexpected (to me, anyway)
> ways. With a default max warning count of 5, I go over soft quota
> exactly once, touch/create 2 more empty inodes, and I'm done:

Looking at this some more, I think it was never clear when the warnings
should get incremented. An old IRIX document[1] says:

"With soft limits, whenever a user logs in with a usage greater than his
soft limit, he or she will be warned (via/bin/login(1))."

Which seems to indicate that perhaps the warning was intended to be
once per login, not once per allocation attempt. Also ...

Ancient XFS code had a "xfs_qm_dqwarn()" function which incremented the
warning count, but it never had any callers until the day it was removed
in 2005, so it's not at all clear what the warning frequency was supposed
to be or what should trigger it, from the code archives.

Hence, my modest proposal would be to just remove the warning limits
infrastructure altogether. It's never worked, nobody has ever asked for it
(?), and its intent is not clear. My only hesitation is that Darrick added
the warning increment, so perhaps he knows of a current use case that
matters?

thanks,
-Eric

[1] https://irix7.com/techpubs/007-0603-100.pdf
