Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7159EC34049
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 484F42464E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 17:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DaIrrC4W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBRRrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:47:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbgBRRrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 12:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582048032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uDz3Ys0z+l2bfNqiuxQ3DtN7PuLGy0qvvSR8HP9C2R4=;
        b=DaIrrC4WbahBRy4HYDmfETW17c+H5q9rnw6bMZU98VQsRJCQ4OZ4Yk09V0mUn/c4Jrc0h4
        TkVBXCcTc8MMEHEoRZDh1RXECb1TOZSPo8wM70d+8lpf592Mq/vR8NJQe5SSuDUrOqN/3m
        zJkNgPCEG+KvfOoRKow+i10LeRhj0+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-3YHHkONkOJGijgne8pZ7RA-1; Tue, 18 Feb 2020 12:47:11 -0500
X-MC-Unique: 3YHHkONkOJGijgne8pZ7RA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 376BF801E66;
        Tue, 18 Feb 2020 17:47:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF2D790F55;
        Tue, 18 Feb 2020 17:47:09 +0000 (UTC)
Date:   Tue, 18 Feb 2020 12:47:08 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: fix iclog release error check race with shutdown
Message-ID: <20200218174708.GB14734@bfoster>
References: <20200214181528.24046-1-bfoster@redhat.com>
 <20200217133314.GA31012@infradead.org>
 <20200217152915.GA6633@bfoster>
 <20200218155313.GA4772@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218155313.GA4772@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 07:53:13AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 17, 2020 at 10:29:15AM -0500, Brian Foster wrote:
> > On Mon, Feb 17, 2020 at 05:33:14AM -0800, Christoph Hellwig wrote:
> > > On Fri, Feb 14, 2020 at 01:15:28PM -0500, Brian Foster wrote:
> > > > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > > > l_icloglock held"), xlog_state_release_iclog() always performed a
> > > > locked check of the iclog error state before proceeding into the
> > > > sync state processing code. As of this commit, part of
> > > > xlog_state_release_iclog() was open-coded into
> > > > xfs_log_release_iclog() and as a result the locked error state check
> > > > was lost.
> > > > 
> > > > The lockless check still exists, but this doesn't account for the
> > > > possibility of a race with a shutdown being performed by another
> > > > task causing the iclog state to change while the original task waits
> > > > on ->l_icloglock. This has reproduced very rarely via generic/475
> > > > and manifests as an assert failure in __xlog_state_release_iclog()
> > > > due to an unexpected iclog state.
> > > > 
> > > > Restore the locked error state check in xlog_state_release_iclog()
> > > > to ensure that an iclog state update via shutdown doesn't race with
> > > > the iclog release state processing code.
> > > > 
> > > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_log.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > > index f6006d94a581..f38fc492a14d 100644
> > > > --- a/fs/xfs/xfs_log.c
> > > > +++ b/fs/xfs/xfs_log.c
> > > > @@ -611,6 +611,10 @@ xfs_log_release_iclog(
> > > >  	}
> > > >  
> > > >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > > > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > > > +			spin_unlock(&log->l_icloglock);
> > > > +			return -EIO;
> > > > +		}
> > > 
> > > So the check just above also shuts the file system down.  Any reason to
> > > do that in one case and not the other?
> > > 
> > 
> > The initial check (with the shutdown) was originally associated with the
> > return from xlog_state_release_iclog(). That covers both state checks,
> > as they were both originally within that function. My impression was
> > there isn't a need to shutdown in the second check because the only way
> > the iclog state changes to IOERROR across that lock cycle is due to a
> > shutdown already in progress.
> 
> The original code did the force shutdown for both cases.  So unless we
> have a good reason to do it differently I'd just add a goto label and
> merge the two cases to restore the old behavior.
> 

Ok. I'm not sure I see the point, but it's harmless and I can make
Eric's fix as well so I'll post a v2..

Brian

