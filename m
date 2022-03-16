Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5711C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 02:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbiCPCBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 22:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiCPCBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 22:01:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF65C865
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 19:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9791361617
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A2C340E8;
        Wed, 16 Mar 2022 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647396020;
        bh=NcEy90AwWHQdv660ECeyP+7l/H/ICKHdIQ09CyWv+Ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GKg7McL5MP9bqmQbUbQO9yBrGrLOisDLbn2oQAl2HhXfFZ019GcpY1zVa3FDXguGj
         M9shlNJmDCCYOjb+soitupu7Sr7Q41JfK2RybctFcxonzSnBejh+0DVK1QQ+Zc0tsU
         F08vANUO5755gpOkqo+1DWU2BvpOzJDKwLLWRglL7TmZI7FmPoXlX7d6jr6lsLE3yn
         WXRmseI6pB7epMAmk253xyu7Kyi0h9ZUjKEHyNC92SSqdIwOM3U1HzOEpKNs+2aWEC
         lGvZWazuaC1hAP1VRJ9yurCTBZ/Z4PiRGEQl3bW7Z8S5WUhusN/1fFluB6vJSRHe8H
         sPxdb7MJeioDQ==
Date:   Tue, 15 Mar 2022 19:00:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
Message-ID: <20220316020019.GT8224@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
 <20220315193624.GH8241@magnolia>
 <20220315214745.GM3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315214745.GM3927073@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 08:47:45AM +1100, Dave Chinner wrote:
> On Tue, Mar 15, 2022 at 12:36:24PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 15, 2022 at 05:42:38PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When the AIL tries to flush the CIL, it relies on the CIL push
> > > ending up on stable storage without having to wait for and
> > > manipulate iclog state directly. However, if there is already a
> > > pending CIL push when the AIL tries to flush the CIL, it won't set
> > > the cil->xc_push_commit_stable flag and so the CIL push will not
> > > actively flush the commit record iclog.
> > > 
> > > generic/530 when run on a single CPU test VM can trigger this fairly
> > > reliably. This test exercises unlinked inode recovery, and can
> > > result in inodes being pinned in memory by ongoing modifications to
> > > the inode cluster buffer to record unlinked list modifications. As a
> > > result, the first inode unlinked in a buffer can pin the tail of the
> > > log whilst the inode cluster buffer is pinned by the current
> > > checkpoint that has been pushed but isn't on stable storage because
> > > because the cil->xc_push_commit_stable was not set. This results in
> > > the log/AIL effectively deadlocking until something triggers the
> > > commit record iclog to be pushed to stable storage (i.e. the
> > > periodic log worker calling xfs_log_force()).
> > > 
> > > The fix is two-fold - first we should always set the
> > > cil->xc_push_commit_stable when xlog_cil_flush() is called,
> > > regardless of whether there is already a pending push or not.
> > > 
> > > Second, if the CIL is empty, we should trigger an iclog flush to
> > > ensure that the iclogs of the last checkpoint have actually been
> > > submitted to disk as that checkpoint may not have been run under
> > > stable completion constraints.
> > 
> > Can it ever be the case that the CIL is not empty but the last
> > checkpoint wasn't committed to disk?
> 
> Yes. But xlog_cil_push_now() will capture that, queue it and mark
> it as xc_push_commit_stable. 
> 
> Remember that the push_now() code updates the push seq/stable
> state under down_read(ctx lock) + spin_lock(push lock) context. The
> push seq/stable state is cleared by the push worker under
> down_write(ctx lock) + spin_lock(push lock) conditions when it
> atomically swaps in the new empty CIL context. Hence the push worker
> will always see the stable flag if it has been set for that push
> sequence.
> 
> > Let's say someone else
> > commits a transaction after the worker samples xc_push_commit_stable?
> 
> If we race with commits between the xlog_cil_push_now(log, seq,
> true) and the CIL list_empty check in xlog_cil_flush(), there are
> two posibilities:
> 
> 1. the CIL push worker hasn't run and atomically switched in a new
> CIL context.
> 2. the CIL push worker has run and switched contexts
> 
> In the first case, the commit will end up in the same context that
> xlog_cil_flush() pushed, and it will be stable. That will result in
> an empty CIL after the CIL push worker runs, but the racing commit
> will be stable as per the xc_push_commit_stable flag. This can also
> lead to the CIL being empty by the time the list_empty check is done
> (because pre-empt), in which case the log force will be a no-op
> because none of the iclogs need flushing.
> 
> > IOWs, why does a not-empty CIL mean that the last checkpoint is on disk?
> 
> In the second case, the CIL push triggered by xlog_cil_push_now()
> will be stable because xc_push_commit_stable says it must be, and
> the racing commit will end up in the new CIL context and the CIL
> won't be empty. We don't need a log force in this case because the
> previous sequence that was flushed with stable semantics as required.
> 
> In the case of AIL pushing, we don't actually care about racing CIL
> commits because we are trying to get pinned AIL items unpinned so we
> can move the tail of the log forwards. If those pinned items are
> relogged by racing transactions, then the next call to
> xlog_cil_flush() from the AIL will get them unpinned and that will
> move them forward in the log, anyway.

Ok, that's kinda what I was thinking, but wasn't sure there wasn't some
other weird subtlety that I hadn't figured out.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


--D

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
