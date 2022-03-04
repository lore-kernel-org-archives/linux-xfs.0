Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E061C4332F
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 00:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiCDAbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 19:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbiCDAbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 19:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E68BE0E;
        Thu,  3 Mar 2022 16:30:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 630F361780;
        Fri,  4 Mar 2022 00:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C080CC004E1;
        Fri,  4 Mar 2022 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646353854;
        bh=MmbVPlcq/5EmG1m2iY/Ihh5BV6E2cVAYzSYrE4u/6mw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YCINIwkQB8QhWw5k1qy1m6KumiljGPE6gsk+XQVZAEMbkxLM9aCSbI+0zQA4l0W/1
         cS4oI/7RAERj3evH/9uN+6JUKZZu/7X4rFd9Bm8dahySjeyU57yivfOnUH0A4klGDv
         q+iKD2AGa+FVFoOq2UifNXg2odMO1hy1bOriRYHtI9FUBNyxcxFLS0M/dFeM/xAOcf
         ONxTnb0f4A7zUtMuxxqk5DYwlzIpPDRo9H8tSnEAlYwf2bGZvfFe/7/gtWFCm3eulX
         Cmo13zONZUdi9R8dG2ZltbuGw8iAxc+Z9yAYB5xXZhezzIJ82htGXCkBRKZKTT9evr
         ZibqP7+lrELAg==
Date:   Thu, 3 Mar 2022 16:30:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        john.haxby@oracle.com
Subject: Re: [PATCH RESEND] xfs: don't generate selinux audit messages for
 capability testing
Message-ID: <20220304003054.GA1479066@magnolia>
References: <20220301025052.GF117732@magnolia>
 <e97b6ef6-dc48-c49b-a98e-6d404dc79a59@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e97b6ef6-dc48-c49b-a98e-6d404dc79a59@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 03, 2022 at 11:21:00AM -0600, Eric Sandeen wrote:
> On 2/28/22 8:50 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There are a few places where we test the current process' capability set
> > to decide if we're going to be more or less generous with resource
> > acquisition for a system call.  If the process doesn't have the
> > capability, we can continue the call, albeit in a degraded mode.
> > 
> > These are /not/ the actual security decisions, so it's not proper to use
> > capable(), which (in certain selinux setups) causes audit messages to
> > get logged.  Switch them to has_capability_noaudit.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Cc: Dave Chinner <david@fromorbit.com>
> 
> Thanks Darrick. This looks technically correct to me as well.
> 
> You might want to add a:
> 
> Fixes: 7317a03df703f ("xfs: refactor inode ownership change transaction/inode/quota allocation idiom")
> 
> because I /think/ that's the commit that moved the capable() checks out
> from under quota tests, and made the problem more visible.
> 
> And maybe:
> 
> Fixes: ea9a46e1c4925 ("xfs: only return detailed fsmap info if the caller has CAP_SYS_ADMIN")
> 
> as well?
> 
> It's not strictly fixing the former; AFAICT the problem existed when quota was
> enabled already, so I'll leave all that to your discretion.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thank you.

--D

> Thanks,
> -Eric
