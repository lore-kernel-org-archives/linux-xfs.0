Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EF3C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45DA32166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDdWxbGT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgEALYQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:24:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33608 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728581AbgEALYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588332255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Eg+EMIM140SvxhEuf+dua2l8Q0ig4YAzlaUkT43AuUU=;
        b=GDdWxbGTbbWJudLuoLUi3hx0EXuvtmwHW4hUjUGKeBk2kofDVEtTW89w0gka67+7PGJht8
        fVQqvgIdp3JtPF3gO77ak6Mh5XQwbiUEl10KhwObiHziGm3YhSaz10hYw3GWwoaLtoEkOn
        g3J75LvyyqPVdXFLk7QyS2ffoby3koY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-rALAmVe0P-m_LV0sxTIKzw-1; Fri, 01 May 2020 07:24:12 -0400
X-MC-Unique: rALAmVe0P-m_LV0sxTIKzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 372BF1800D42;
        Fri,  1 May 2020 11:24:11 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C184360C47;
        Fri,  1 May 2020 11:24:10 +0000 (UTC)
Date:   Fri, 1 May 2020 07:24:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 07/17] xfs: ratelimit unmount time per-buffer I/O
 error alert
Message-ID: <20200501112408.GB40250@bfoster>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-8-bfoster@redhat.com>
 <20200430220743.GJ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430220743.GJ2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 08:07:43AM +1000, Dave Chinner wrote:
> On Wed, Apr 29, 2020 at 01:21:43PM -0400, Brian Foster wrote:
> > At unmount time, XFS emits an alert for every in-core buffer that
> > might have undergone a write error. In practice this behavior is
> > probably reasonable given that the filesystem is likely short lived
> > once I/O errors begin to occur consistently. Under certain test or
> > otherwise expected error conditions, this can spam the logs and slow
> > down the unmount.
> > 
> > Now that we have a ratelimit mechanism specifically for buffer
> > alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
> > Also lift the final repair message out of the loop so it always
> > prints and assert that the metadata error handling code has shut
> > down the fs.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 594d5e1df6f8..8f0f605de579 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
...
> > @@ -1685,17 +1686,23 @@ xfs_wait_buftarg(
> >  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
> >  			list_del_init(&bp->b_lru);
> >  			if (bp->b_flags & XBF_WRITE_FAIL) {
> > -				xfs_alert(btp->bt_mount,
> > +				write_fail = true;
> > +				xfs_buf_alert_ratelimited(bp,
> > +					"XFS: Corruption Alert",
> >  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> >  					(long long)bp->b_bn);
> > -				xfs_alert(btp->bt_mount,
> > -"Please run xfs_repair to determine the extent of the problem.");
> >  			}
> >  			xfs_buf_rele(bp);
> >  		}
> >  		if (loop++ != 0)
> >  			delay(100);
> >  	}
> > +
> > +	if (write_fail) {
> > +		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));
> 
> I think this is incorrect. A metadata write that is set to retry
> forever and is failing because of a bad sector or some other
> persistent device error will not shut down the filesystem, but still
> be reported here as a failure. Hence we can easily get here without
> a filesystem shutdown having occurred...
> 

I'm confused by your comment because I don't see how we get here to free
a dirty buffer without the filesystem already shut down. AFAICT we're
going to spin (in freeze or unmount) until all outstanding buffers are
written back or converted to permanent errors, which shuts down the fs.
Hm?

Note that I don't object to turning this into a direct
xfs_force_shutdown() call as a fallback, if that's what you're asking
for (which isn't totally clear to me either). Obviously my assumption is
that we're already shut down anyways, but I'd like to get on the same
page here first...

Brian

> Cheers,
> 
> Dave.
> 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

