Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE876C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Mar 2022 17:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiCCRVt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 12:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiCCRVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 12:21:48 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AED9D198D27
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 09:21:02 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8E1E7323C1F;
        Thu,  3 Mar 2022 11:19:58 -0600 (CST)
Message-ID: <e97b6ef6-dc48-c49b-a98e-6d404dc79a59@sandeen.net>
Date:   Thu, 3 Mar 2022 11:21:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        john.haxby@oracle.com
References: <20220301025052.GF117732@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH RESEND] xfs: don't generate selinux audit messages for
 capability testing
In-Reply-To: <20220301025052.GF117732@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/28/22 8:50 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There are a few places where we test the current process' capability set
> to decide if we're going to be more or less generous with resource
> acquisition for a system call.  If the process doesn't have the
> capability, we can continue the call, albeit in a degraded mode.
> 
> These are /not/ the actual security decisions, so it's not proper to use
> capable(), which (in certain selinux setups) causes audit messages to
> get logged.  Switch them to has_capability_noaudit.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>

Thanks Darrick. This looks technically correct to me as well.

You might want to add a:

Fixes: 7317a03df703f ("xfs: refactor inode ownership change transaction/inode/quota allocation idiom")

because I /think/ that's the commit that moved the capable() checks out
from under quota tests, and made the problem more visible.

And maybe:

Fixes: ea9a46e1c4925 ("xfs: only return detailed fsmap info if the caller has CAP_SYS_ADMIN")

as well?

It's not strictly fixing the former; AFAICT the problem existed when quota was
enabled already, so I'll leave all that to your discretion.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric
