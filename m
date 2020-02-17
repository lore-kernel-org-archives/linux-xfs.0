Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375F8C34025
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 15:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F591215A4
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 15:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U7Emyu0v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgBQP3X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 10:29:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42237 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgBQP3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 10:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581953361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M7YPBoftl+XwjQmdH2YxrXVDhJrTFOB2uKr+2QLscuo=;
        b=U7Emyu0v1RiqHDEe0e2qFF8qpm6DIcM+4KLJV7QiDBX5Dlv++z+1NOEgJ3AWeAH1nq1zlT
        rnPK7AuSBi+xrYFgs09I0EXPI1TB2JRJlyPLXVMZ73q1E2UYUMeRw5jksL0a29gAbju/7y
        6cFemdViAOACIJng9iQNahd5OoP48zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-KHX7aqpwPrmgljQB8HEN7w-1; Mon, 17 Feb 2020 10:29:19 -0500
X-MC-Unique: KHX7aqpwPrmgljQB8HEN7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22993800D55;
        Mon, 17 Feb 2020 15:29:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A54F787B2F;
        Mon, 17 Feb 2020 15:29:17 +0000 (UTC)
Date:   Mon, 17 Feb 2020 10:29:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: fix iclog release error check race with shutdown
Message-ID: <20200217152915.GA6633@bfoster>
References: <20200214181528.24046-1-bfoster@redhat.com>
 <20200217133314.GA31012@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217133314.GA31012@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 05:33:14AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 14, 2020 at 01:15:28PM -0500, Brian Foster wrote:
> > Prior to commit df732b29c8 ("xfs: call xlog_state_release_iclog with
> > l_icloglock held"), xlog_state_release_iclog() always performed a
> > locked check of the iclog error state before proceeding into the
> > sync state processing code. As of this commit, part of
> > xlog_state_release_iclog() was open-coded into
> > xfs_log_release_iclog() and as a result the locked error state check
> > was lost.
> > 
> > The lockless check still exists, but this doesn't account for the
> > possibility of a race with a shutdown being performed by another
> > task causing the iclog state to change while the original task waits
> > on ->l_icloglock. This has reproduced very rarely via generic/475
> > and manifests as an assert failure in __xlog_state_release_iclog()
> > due to an unexpected iclog state.
> > 
> > Restore the locked error state check in xlog_state_release_iclog()
> > to ensure that an iclog state update via shutdown doesn't race with
> > the iclog release state processing code.
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f6006d94a581..f38fc492a14d 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -611,6 +611,10 @@ xfs_log_release_iclog(
> >  	}
> >  
> >  	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> > +		if (iclog->ic_state == XLOG_STATE_IOERROR) {
> > +			spin_unlock(&log->l_icloglock);
> > +			return -EIO;
> > +		}
> 
> So the check just above also shuts the file system down.  Any reason to
> do that in one case and not the other?
> 

The initial check (with the shutdown) was originally associated with the
return from xlog_state_release_iclog(). That covers both state checks,
as they were both originally within that function. My impression was
there isn't a need to shutdown in the second check because the only way
the iclog state changes to IOERROR across that lock cycle is due to a
shutdown already in progress.

Brian

