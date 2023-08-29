Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA4BC71153
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 03:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjH2DKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 23:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjH2DKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2023 23:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E6110A
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 974326160D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 03:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3331C433C7;
        Tue, 29 Aug 2023 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693278613;
        bh=eZU23QYhl7dTlIufH3rNRD0ddRaSEezakJfY6QVdpOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0P6+nR8lnRtTLMONY6bDjw481tBA+4I6HigHyxp9CnU2tXb5LphVKEET1ODS89S1
         SVcWFvnkzRste7eZy0rHdQB/hLHHS8A9tN9UUoQbLTPZ/1J3fROzCDqOKUrBrO+m3b
         cN+tFgMGpQX2l21B/XT6vMpHnOMKvzNNpa/2tKuQfPL+60+9Q7EXuo4PcpOuzY8ebg
         Bv2pXL/GeTAbkAQKKtnlVVHjIu8TPzPCX+u0hWbEqCceOQXrEExuB0REOU9etlTXtf
         Qqraw2AX5rdbEVktEAy2V/HFsCzOKGxEh9IJ55lgouhpbzaUBW/rwFYYigbbIol3jV
         nCa5x3+QUxrLQ==
Date:   Mon, 28 Aug 2023 20:10:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/3] xfs: don't allow log recovery when unknown rocompat
 bits are set
Message-ID: <20230829031012.GC28186@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
 <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
 <ZOf+7PqbeHj1Qs3y@dread.disaster.area>
 <20230825040417.GF17912@frogsfrogsfrogs>
 <20230828190822.GB28186@frogsfrogsfrogs>
 <ZO0WA2EwtEa5n0bC@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO0WA2EwtEa5n0bC@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 07:47:47AM +1000, Dave Chinner wrote:
> On Mon, Aug 28, 2023 at 12:08:22PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 24, 2023 at 09:04:17PM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 25, 2023 at 11:07:56AM +1000, Dave Chinner wrote:
> > > > On Thu, Aug 24, 2023 at 04:21:46PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Don't allow log recovery to proceed on a readonly mount if the primary
> > > > > superblock advertises unknown rocompat bits.  We used to allow this, but
> > > > > due to a misunderstanding between Dave and Darrick back in 2016, we
> > > > > cannot do that anymore.  The XFS_SB_FEAT_RO_COMPAT_RMAPBT feature (4.8)
> > > > > protects RUI log items, and the REFLINK feature (4.9) protects CUI/BUI
> > > > > log items, which is why we can't allow older kernels to recover them.
> > > > 
> > > > Ok, this would work for kernels that don't know waht the
> > > > REFLINK/RMAP features are, but upstream kernels will never fail to
> > > > recover these items because these are known ROCOMPAT bits.
> > > > 
> > > > The reason this problem exists is that we've accidentally
> > > > conflated RO_COMPAT with LOG_INCOMPAT. If RUI/CUI/BUI creation had
> > > > of set a log incompat bit whenever they are used (similar to the
> > > > new ATTRI stuff setting log incompat bits), then older kernels
> > > > would not have allow log recovery even if the reflink/rmap RO_COMPAT
> > > > features were set and they didn't understand them.
> > > > 
> > > > However, we can't do that on current kernels because then older
> > > > kernels that understand reflink/rmap just fine would see an unknown
> > > > log incompat bit and refuse to replay the log. So it comes back to
> > > > how we handle unknown ROCOMPAT flags on older kernels, not current
> > > > upstream kernels.
> > > > 
> > > > i.e. this patch needs to be backported to kernels that don't know
> > > > anything about RMAP/REFLINK to be useful to anyone. i.e. kernels
> > > > older than 4.9 that don't know what rmap/reflink are.  I suspect
> > > > that there are very few supported kernels that old that this might
> > > > get backported to.
> > 
> > Seeing as the oldest LTS kernel now is 4.14, I agree with you, let's
> > just forget this whole patch and try to remember not to hide LOG
> > INCOMPAT features behind RO COMPAT flags again. :)
> > 
> > If we do that, then all we need to do is change xfs_validate_sb_write
> > not to complain about unknown rocompat features if the xfs is readonly,
> > and remove all the code that temporarily clears the readonly state
> > around the log mount calls.
> > 
> > Log recovery then goes back to supporting recovery even in the presence
> > of unknown rocompat bits, and patch 3 becomes unnecessary...
> 
> *nod*
> 
> > ...though this below is still true.
> > 
> > > Hmm.  The most annoying thing about LOG_INCOMPAT features is that
> > > turning them on requires a synchronous write to the primary sb along
> > > with a transaction to log the sb that is immediately forced to disk.
> > > Every time the log cleans itself it clears the LOG_INCOMPAT features,
> > > and then we have to do that /again/.
> > > 
> > > Parent pointers, since they require log intent items to guarantee the
> > > dirent and pptr update, cycle the logged xattr LOG_INCOMPAT feature on
> > > and off repeatedly.  A couple of weeks ago I decided to elide all that
> > > LOG_INCOMPAT cycling if parent pointers are enabled, and fstests runtime
> > > went from 4.9 hours back down to 4.4.  (Parent pointers, for whatever
> > > reason, got an INCOMPAT feature bit so it's ok).  I was a little
> > > surprised that xfs_log_clean ran that much, but there we go.
> 
> Sure, but that's only a problem for operations that are a pure
> log format change. With parent pointers, we have an INCOMPAT bit
> because we have a new attr filter bit that older kernels will flag
> as corruption, and that means we don't need a log incompat bit for
> the attr logging. IOWs, if xfs_has_parent_pointers() is true, then
> we don't need to set the ATTRI log incompat bit, ever, because the
> parent pointer incompat feature bit implies ATTRI log items are in use and all
> kernels that understand the PP incompat bit also understand the
> ATTRI log items....

Aha, that's why parent pointers got an INCOMPAT flag, thanks for the
reminder.

> > > A different way to solve the cycling problem could be to start a timer
> > > after the last caller drops l_incompat_xattrs and only clear the feature
> > > bit after 5 minutes of idleness or unmount, instead of the next time the
> > > log cleans itself.
> 
> Well, we only clear it from the xfs_log_worker() if the log needs
> covering, so the AIL and iclogs need to be empty before the worker
> will clear the incompat bit. That's on a 30s timer already, so
> perhaps all we need to do is extend the log covering timeout if
> there are incompat log flags set....

Well for non-pptr LARP I don't care since it's a debugging flag, but I
suppose for swapext we might want to consider something like that.
Though I think I might want to preserve the "30 seconds until log
commits" default behavior and not crank that up to 5 minutes.

> > > Alternately, we drop this patch and declare an INCOMPAT_RMAPREFLINKV2
> > > feature that wraps up all the other broken bits that we've found since
> > > 2016 (overly large log reservations, incorrect units in xattr block
> > > reservation calculations, etc.)
> 
> It's tempting, but let's try to put that off until we really need
> to....

Ok.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
