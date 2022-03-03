Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C2AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Mar 2022 00:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiCCAi4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiCCAiz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Mar 2022 19:38:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559D9BF5F
        for <linux-xfs@vger.kernel.org>; Wed,  2 Mar 2022 16:38:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07F4BB822BC
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 00:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992CAC004E1;
        Thu,  3 Mar 2022 00:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646267888;
        bh=1AotVhlgZW37ZOcPzuNfjD7MKdyQQr3XHIMrC9CQfcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVfSbYMXpPTvqe9XgdsBRDNet44VPBsQvGT361bCRDOjD5pTTJ+nAGAyDAgxvM04e
         3He29l/1+ft90Hf/moBf5CIPAWFw+1n7lNQkRgP8zO5mNwzfNd/Qlkwd+I1spdZSsU
         IQ0jFP6AF6BqPkDnkti9vl6n44K6aiAOaWp/4JcTeXNAyj26X7VRj4S0ui8pvPvFux
         zOwHshss3R9z0xYlhY67ZNwYud05yHCb1QSeLN+tcJvCh5S6GP183erNiDFVqO648o
         Xpwrvd86OnfYRUyGveVpyFIcyClqH0fqzpeADcHljnJ5gAfrSon+oqLe9vdS+ao7mS
         N3VyGnzily+ew==
Date:   Wed, 2 Mar 2022 16:38:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: Quota warning woes (was: [PATCH 25/26] xfs: actually bump
 warning counts when we send warnings)
Message-ID: <20220303003808.GM117732@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
 <159477799812.3263162.13957383827318048593.stgit@magnolia>
 <01d6be65-f65c-790e-73fb-9529a94673eb@sandeen.net>
 <199a3e85-9ee5-1354-e652-ff3d501bd395@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <199a3e85-9ee5-1354-e652-ff3d501bd395@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 02, 2022 at 12:19:21PM -0600, Eric Sandeen wrote:
> On 3/1/22 1:31 PM, Eric Sandeen wrote:
> > On 7/14/20 8:53 PM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Currently, xfs quotas have the ability to send netlink warnings when a
> >> user exceeds the limits.  They also have all the support code necessary
> >> to convert softlimit warnings into failures if the number of warnings
> >> exceeds a limit set by the administrator.  Unfortunately, we never
> >> actually increase the warning counter, so this never actually happens.
> >> Make it so we actually do something useful with the warning counts.
> >>
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Sooo I got a bug report that this essentially breaks the timer for
> > soft quota, because we now (and quite rapidly) hit the default
> > 5-warning limit well before we hit any reasonable timer that may
> > have been set, and disallow more space usage.
> > 
> > And those warnings rack up in somewhat unexpected (to me, anyway)
> > ways. With a default max warning count of 5, I go over soft quota
> > exactly once, touch/create 2 more empty inodes, and I'm done:
> 
> Looking at this some more, I think it was never clear when the warnings
> should get incremented. An old IRIX document[1] says:
> 
> "With soft limits, whenever a user logs in with a usage greater than his
> soft limit, he or she will be warned (via/bin/login(1))."
> 
> Which seems to indicate that perhaps the warning was intended to be
> once per login, not once per allocation attempt. Also ...
> 
> Ancient XFS code had a "xfs_qm_dqwarn()" function which incremented the
> warning count, but it never had any callers until the day it was removed
> in 2005, so it's not at all clear what the warning frequency was supposed
> to be or what should trigger it, from the code archives.
> 
> Hence, my modest proposal would be to just remove the warning limits
> infrastructure altogether. It's never worked, nobody has ever asked for it
> (?), and its intent is not clear. My only hesitation is that Darrick added
> the warning increment, so perhaps he knows of a current use case that
> matters?

None specifically, but it's a feature, albeit a poorly documented and
previously broken one.  VFS quotas don't seem to have any warning
limits, so I suppose there's not a lot of precedent to go on.

That said -- I don't how gutting a feature (especially since it's now
been *working* for a year and a half) is the solution here.  If you
think the default warning limit is too low, then perhaps we should
increase it.  If you don't like that a single user operation can bump
the warning counter multiple times, then propose adding a flag to the
dqtrx structure so that we only bump the warning counter *once* per
transaction.  "It's never worked" is not true -- this fix was added for
5.9, and it's now shipped in two LTS kernels.

On the other hand, if you think this feature is totally worthless and it
should go away, there's a deprecation process for that.

--D

> 
> thanks,
> -Eric
> 
> [1] https://irix7.com/techpubs/007-0603-100.pdf
