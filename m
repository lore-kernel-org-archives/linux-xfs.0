Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF39C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 20:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F8A23444
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 20:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbhAGUCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 15:02:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727217AbhAGUCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 15:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610049666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2eOfzULcdrTxCo4nANV55TwLfymr2Rma6fcG0jFvjEc=;
        b=agGuIRPtqTOIMffgm5252/hEN3XpsYy7GmBYnwB7ViRbX/iiCwrNfLHvPJtfARUfOg3ki+
        rWxtQiP4cBzuy4J3/ohRIi0ywIcbp8ZGWOuLc6xaVtsv1iaorGAY0qss3fnRw5gUbHO2C4
        qJPU0Y8+gC6rfiMY7Ai3JKzlD4oFhbw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-2sfKpzj3P6iAryTzwoAKhg-1; Thu, 07 Jan 2021 15:01:04 -0500
X-MC-Unique: 2sfKpzj3P6iAryTzwoAKhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0B695F9C5;
        Thu,  7 Jan 2021 20:01:03 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8377E60BF1;
        Thu,  7 Jan 2021 20:01:03 +0000 (UTC)
Date:   Thu, 7 Jan 2021 15:01:01 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: don't reset log idle state on covering
 checkpoints
Message-ID: <20210107200101.GC845369@bfoster>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-6-bfoster@redhat.com>
 <20210107193050.GG6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107193050.GG6918@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 11:30:50AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 06, 2021 at 12:41:23PM -0500, Brian Foster wrote:
> > Now that log covering occurs on quiesce, we'd like to reuse the
> > underlying superblock sync for final superblock updates. This
> > includes things like lazy superblock counter updates, log feature
> > incompat bits in the future, etc. One quirk to this approach is that
> > once the log is in the IDLE (i.e. already covered) state, any
> > subsequent log write resets the state back to NEED. This means that
> > a final superblock sync to an already covered log requires two more
> > sb syncs to return the log back to IDLE again.
> > 
> > For example, if a lazy superblock enabled filesystem is mount cycled
> > without any modifications, the unmount path syncs the superblock
> > once and writes an unmount record. With the desired log quiesce
> > covering behavior, we sync the superblock three times at unmount
> > time: once for the lazy superblock counter update and twice more to
> > cover the log. By contrast, if the log is active or only partially
> > covered at unmount time, a final superblock sync would doubly serve
> > as the one or two remaining syncs required to cover the log.
> > 
> > This duplicate covering sequence is unnecessary because the
> > filesystem remains consistent if a crash occurs at any point. The
> > superblock will either be recovered in the event of a crash or
> > written back before the log is quiesced and potentially cleaned with
> > an unmount record.
> > 
> > Update the log covering state machine to remain in the IDLE state if
> > additional covering checkpoints pass through the log. This
> > facilitates final superblock updates (such as lazy superblock
> > counters) via a single sb sync without losing covered status. This
> > provides some consistency with the active and partially covered
> > cases and also avoids harmless, but spurious checkpoints when
> > quiescing the log.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> I /think/ the premise of this is ok.
> 
> I found myself wondering if xlog_state_activate_iclog could mistake an
> iclog containing 5 log ops from a real update for an iclog containing
> just the dummy transaction, since a synchronous inode mtime update
> transaction can also produce an iclog with 5 ops.  I /think/ that
> doesn't matter because xlog_covered_state only cares about the value of
> iclogs_changed if the log worker previously set the log state to DONE or
> DONE2, and iclogs_changed won't be 1 here if there were multiple dirty
> iclogs or if the sole dirty iclog contains more than just the dummy.
> 

That is my understanding. I had similar questions when first passing
through the covering code and realizing the detection of the covering
commit was sort of implicit in and of itself (hence the additional state
checking and iclogs_changed logic). I think the bigger picture with
regard to this series was that it doesn't really matter because nothing
else is happening during quiesce, but I might revisit that from the
background covering perspective now that I have a better handle on how
the covering mechanism works...

Brian

> If I got that right,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_log.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f7b23044723d..9b8564f280b7 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2597,12 +2597,15 @@ xlog_covered_state(
> >  	int			iclogs_changed)
> >  {
> >  	/*
> > -	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> > -	 * are done writing the dummy record.  If we are done with the second
> > -	 * dummy recored (DONE2), then we go to IDLE.
> > +	 * We go to NEED for any non-covering writes. We go to NEED2 if we just
> > +	 * wrote the first covering record (DONE). We go to IDLE if we just
> > +	 * wrote the second covering record (DONE2) and remain in IDLE until a
> > +	 * non-covering write occurs.
> >  	 */
> >  	switch (prev_state) {
> >  	case XLOG_STATE_COVER_IDLE:
> > +		if (iclogs_changed == 1)
> > +			return XLOG_STATE_COVER_IDLE;
> >  	case XLOG_STATE_COVER_NEED:
> >  	case XLOG_STATE_COVER_NEED2:
> >  		break;
> > -- 
> > 2.26.2
> > 
> 

