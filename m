Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606CBC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Feb 2022 21:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiBDVrr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 16:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiBDVrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Feb 2022 16:47:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFEDC061714
        for <linux-xfs@vger.kernel.org>; Fri,  4 Feb 2022 13:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52117618B6
        for <linux-xfs@vger.kernel.org>; Fri,  4 Feb 2022 21:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA26C004E1;
        Fri,  4 Feb 2022 21:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644011265;
        bh=ksipMirGqHxf1hXp/vlkD8RMiVRzpKP5ryBed4gfKcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MGFuLUcr2ydUvbTH3HJDNMS7DR7UUhu5HF1Quj3WdYVZQAGUsDwkdIRtaDuA+gWcG
         T7sd0J4r8YmdQx5dzEgY4kwsNM2e6Nzel/8aetmV3pdWx5ZfttKt8dMTX5+hFm19E4
         BJUXc8ivOQx5Y+lfI96rGeyEZssPBRg7wCoyWc8iH8y7PBScts86XJilU40R/NbIPh
         XZNppeUbJ6yga+/+8Y+KWZ7wGXUsCE6EDMExjoNhevGVSzAwvrCcM16rVip9HSFPVi
         aYbNuHppbT4XMjGj9HMqcKZvMQt51gGL4vTrPN8kqjwEOojwPll13KpIT5AfP/gUiA
         PvKKO05E9eYcQ==
Date:   Fri, 4 Feb 2022 13:47:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 02/17] libxfs: shut down filesystem if we
 xfs_trans_cancel with deferred work items
Message-ID: <20220204214744.GD8338@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263810572.863810.13209521254816975203.stgit@magnolia>
 <40c947a4-db5c-db4d-b369-de7554f3a8a4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c947a4-db5c-db4d-b369-de7554f3a8a4@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 04, 2022 at 03:36:18PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While debugging some very strange rmap corruption reports in connection
> > with the online directory repair code.  I root-caused the error to the
> > following incorrect sequence:
> > 
> > <start repair transaction>
> > <expand directory, causing a deferred rmap to be queued>
> > <roll transaction>
> > <cancel transaction>
> > 
> > Obviously, we should have committed the transaction instead of
> > cancelling it.  Thinking more broadly, however, xfs_trans_cancel should
> > have warned us that we were throwing away work item that we already
> > committed to performing.  This is not correct, and we need to shut down
> > the filesystem.
> > 
> > Change xfs_trans_cancel to complain in the loudest manner if we're
> > cancelling any transaction with deferred work items attached.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> So this is basically:
> 
> Source kernel commit: 47a6df7cd3174b91c6c862eae0b8d4e13591df52
> 
> plus the actual shutting down / aborting part 
> 
> Seems ok; did you run into this in practice, in userspace?

Nope, I was merely porting it to userspace and decided the source was
different enough not to bother trying to libxfs-apply it.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > ---
> >  libxfs/trans.c |   19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > index fd2e6f9d..8c16cb8d 100644
> > --- a/libxfs/trans.c
> > +++ b/libxfs/trans.c
> > @@ -318,13 +318,30 @@ void
> >  libxfs_trans_cancel(
> >  	struct xfs_trans	*tp)
> >  {
> > +	bool			dirty;
> > +
> >  	trace_xfs_trans_cancel(tp, _RET_IP_);
> >  
> >  	if (tp == NULL)
> >  		return;
> > +	dirty = (tp->t_flags & XFS_TRANS_DIRTY);
> >  
> > -	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
> > +	/*
> > +	 * It's never valid to cancel a transaction with deferred ops attached,
> > +	 * because the transaction is effectively dirty.  Complain about this
> > +	 * loudly before freeing the in-memory defer items.
> > +	 */
> > +	if (!list_empty(&tp->t_dfops)) {
> > +		ASSERT(list_empty(&tp->t_dfops));
> > +		ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +		dirty = true;
> >  		xfs_defer_cancel(tp);
> > +	}
> > +
> > +	if (dirty) {
> > +		fprintf(stderr, _("Cancelling dirty transaction!\n"));
> > +		abort();
> > +	}
> >  
> >  	xfs_trans_free_items(tp);
> >  	xfs_trans_free(tp);
> > 
