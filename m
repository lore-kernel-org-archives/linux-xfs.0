Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE84C71133
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Aug 2023 04:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjHYEEl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 00:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjHYEEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 00:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED671FCE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 21:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0964662F8C
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 04:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0FFC433C8;
        Fri, 25 Aug 2023 04:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692936258;
        bh=BX1faoj9uxdqeSH24mJzyZNYYfqJRpfdqGbIwTYaEHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=geyrhC9VVmMOhOIV21m6qGDpvqFIFuKWxl9m8N8lMAtcRInswqPnP/HpHZLDW1u1r
         TsY5orPWWj1efaUXnTYzNqCmo+2/W28po3LozdvsreC12MhDGc9golBcDJJq1JcY+H
         u4hPLV1RMbDbss3i2DCtl+0Brg/c5X4bLWO2Bfg/npsipuFWEbiE0H1DZ83BgY8pqT
         J3YHH6FnUfwIjGiwK0m+aOvy9bmw0ZT8bLVLb20Ng864xlETwcgpz02QitC73oUEgL
         YGBPd0tahwr5EHqHeYwiGfz/xkEScZn5jNVw7S9wV1VVKH+84Gz5ErCW3OxLVIdmtX
         axVds+kEpvBfQ==
Date:   Thu, 24 Aug 2023 21:04:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: don't allow log recovery when unknown rocompat
 bits are set
Message-ID: <20230825040417.GF17912@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
 <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
 <ZOf+7PqbeHj1Qs3y@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOf+7PqbeHj1Qs3y@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 25, 2023 at 11:07:56AM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2023 at 04:21:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Don't allow log recovery to proceed on a readonly mount if the primary
> > superblock advertises unknown rocompat bits.  We used to allow this, but
> > due to a misunderstanding between Dave and Darrick back in 2016, we
> > cannot do that anymore.  The XFS_SB_FEAT_RO_COMPAT_RMAPBT feature (4.8)
> > protects RUI log items, and the REFLINK feature (4.9) protects CUI/BUI
> > log items, which is why we can't allow older kernels to recover them.
> 
> Ok, this would work for kernels that don't know waht the
> REFLINK/RMAP features are, but upstream kernels will never fail to
> recover these items because these are known ROCOMPAT bits.
> 
> The reason this problem exists is that we've accidentally
> conflated RO_COMPAT with LOG_INCOMPAT. If RUI/CUI/BUI creation had
> of set a log incompat bit whenever they are used (similar to the
> new ATTRI stuff setting log incompat bits), then older kernels
> would not have allow log recovery even if the reflink/rmap RO_COMPAT
> features were set and they didn't understand them.
> 
> However, we can't do that on current kernels because then older
> kernels that understand reflink/rmap just fine would see an unknown
> log incompat bit and refuse to replay the log. So it comes back to
> how we handle unknown ROCOMPAT flags on older kernels, not current
> upstream kernels.
> 
> i.e. this patch needs to be backported to kernels that don't know
> anything about RMAP/REFLINK to be useful to anyone. i.e. kernels
> older than 4.9 that don't know what rmap/reflink are.  I suspect
> that there are very few supported kernels that old that this might
> get backported to.
> 
> Hence I wonder if this change is necessary at all.  If we can
> guarantee that anything adding a new log item type to the journal
> sets a LOG_INCOMPAT flag, then we don't need to change the RO_COMPAT
> handling in current kernels to avoid log recovery at all - the
> existing LOG_INCOMPAT flag handling will do that for us....
> 
> Yes, we can have a new feature that is RO_COMPAT + LOG_INCOMPAT; the
> reflink and rmap features should have been defined this way as
> that's where we went wrong. It's too late to set LOG_INCOMPAT for
> them, and so the only way to fix old supported kernels is to prevent
> log recovery when unknown RO_COMPAT bits are set.
> 
> Hence I don't see this solution as necessary for any kernel recent
> enough to support rmap/reflink, nor do I see it necessary to protect
> against making the same mistake about RO_COMPAT features in the
> future. Everyone now knows that a log format change requires
> LOG_INCOMPAT, not RO_COMPAT, so we should not be making that mistake
> again.....
> 
> Thoughts?

Hmm.  The most annoying thing about LOG_INCOMPAT features is that
turning them on requires a synchronous write to the primary sb along
with a transaction to log the sb that is immediately forced to disk.
Every time the log cleans itself it clears the LOG_INCOMPAT features,
and then we have to do that /again/.

Parent pointers, since they require log intent items to guarantee the
dirent and pptr update, cycle the logged xattr LOG_INCOMPAT feature on
and off repeatedly.  A couple of weeks ago I decided to elide all that
LOG_INCOMPAT cycling if parent pointers are enabled, and fstests runtime
went from 4.9 hours back down to 4.4.  (Parent pointers, for whatever
reason, got an INCOMPAT feature bit so it's ok).  I was a little
surprised that xfs_log_clean ran that much, but there we go.

A different way to solve the cycling problem could be to start a timer
after the last caller drops l_incompat_xattrs and only clear the feature
bit after 5 minutes of idleness or unmount, instead of the next time the
log cleans itself.

Alternately, we drop this patch and declare an INCOMPAT_RMAPREFLINKV2
feature that wraps up all the other broken bits that we've found since
2016 (overly large log reservations, incorrect units in xattr block
reservation calculations, etc.)

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
