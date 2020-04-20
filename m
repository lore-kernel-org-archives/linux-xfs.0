Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F363FC54FCB
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D8320B1F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDaXMjzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgDTOCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:02:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726700AbgDTOCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bu6WJzNonasIuc5PSVFPAqDEa90rtVyFMJTVBpiTDFM=;
        b=eDaXMjzQ5Dhe2Im1l3xrfU278ssvMH6FN4OvZo7Ui2WSDA1aBlxthGEyv5pkZVulxdp7QK
        1fH0Qh6mucKmJKp5dqAUgGlVVloClwCbd7m7m5FW6xV6BFO0vn0PiAPdX9mB3hdSsLC5xD
        tttJa6k/FvA+MyFvUsNhRFAAm4SDJpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-5idWMBMYPHWwbbj1kMOTzQ-1; Mon, 20 Apr 2020 10:02:09 -0400
X-MC-Unique: 5idWMBMYPHWwbbj1kMOTzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 417F41B18BCC;
        Mon, 20 Apr 2020 14:02:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5D9E5DA76;
        Mon, 20 Apr 2020 14:02:07 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:02:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error
 warning
Message-ID: <20200420140205.GE27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-6-bfoster@redhat.com>
 <20200420031959.GH9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420031959.GH9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 01:19:59PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:52AM -0400, Brian Foster wrote:
> > At unmount time, XFS emits a warning for every in-core buffer that
> > might have undergone a write error. In practice this behavior is
> > probably reasonable given that the filesystem is likely short lived
> > once I/O errors begin to occur consistently. Under certain test or
> > otherwise expected error conditions, this can spam the logs and slow
> > down the unmount. Ratelimit the warning to prevent this problem
> > while still informing the user that errors have occurred.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 93942d8e35dd..5120fed06075 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
> >  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
> >  			list_del_init(&bp->b_lru);
> >  			if (bp->b_flags & XBF_WRITE_FAIL) {
> > -				xfs_alert(btp->bt_mount,
> > -"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > +				xfs_alert_ratelimited(btp->bt_mount,
> > +"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\n"
> > +"Please run xfs_repair to determine the extent of the problem.",
> >  					(long long)bp->b_bn);
> 
> Hmmmm. I was under the impression that multiple line log messages
> were frowned upon because they prevent every output line in the log
> being tagged correctly. That's where KERN_CONT came from (i.e. it's
> a continuation of a previous log message), but we don't use that
> with the XFS logging and hence multi-line log messages are split
> into multiple logging calls.
> 

I debated combining these into a single line for that exact reason for
about a second and then just went with this because I didn't think it
mattered that much.

> IOWs, this might be better handled just using a static ratelimit
> variable here....
> 
> Actually, we already have one for xfs_buf_item_push() to limit
> warnings about retrying XBF_WRITE_FAIL buffers:
> 
> static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
> 
> Perhaps we should be using the same ratelimit variable here....
> 

IIRC that was static in another file, but we can centralize (and perhaps
generalize..) it somewhere if that is preferred..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

