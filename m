Return-Path: <SRS0=MzXO=6F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF98C54FC9
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 12:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A1920753
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Apr 2020 12:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dPxSlylM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgDUMNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:13:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24886 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbgDUMNp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 08:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587471224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yD+7LUyprLBP5e6/RnCtp8POY50Ir6hgPcKB6WuRZMo=;
        b=dPxSlylMy1KXOwhbvB1CAfcTFX/cBuzYbA1t+RWYPmiVhwhoxWUoUXRHMAZdLVRAxK3sTH
        VcuxV50FmM9tIshO4GrBa1HdMg35pyzlBXiVjXW1wtSYYiYxlEU2psnWHqFQ90Ncsju2+n
        WDMKbHA6FUUxRVd4l1YMMHel3bztwhQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-dTKEt61FOFmIvC8o2aIYag-1; Tue, 21 Apr 2020 08:13:40 -0400
X-MC-Unique: dTKEt61FOFmIvC8o2aIYag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F03F0DBA5;
        Tue, 21 Apr 2020 12:13:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93EE85C1B2;
        Tue, 21 Apr 2020 12:13:39 +0000 (UTC)
Date:   Tue, 21 Apr 2020 08:13:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error
 warning
Message-ID: <20200421121337.GA31715@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-6-bfoster@redhat.com>
 <20200420031959.GH9800@dread.disaster.area>
 <20200420140205.GE27516@bfoster>
 <20200420222332.GP9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420222332.GP9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 08:23:32AM +1000, Dave Chinner wrote:
> On Mon, Apr 20, 2020 at 10:02:05AM -0400, Brian Foster wrote:
> > On Mon, Apr 20, 2020 at 01:19:59PM +1000, Dave Chinner wrote:
> > > On Fri, Apr 17, 2020 at 11:08:52AM -0400, Brian Foster wrote:
> > > > At unmount time, XFS emits a warning for every in-core buffer that
> > > > might have undergone a write error. In practice this behavior is
> > > > probably reasonable given that the filesystem is likely short lived
> > > > once I/O errors begin to occur consistently. Under certain test or
> > > > otherwise expected error conditions, this can spam the logs and slow
> > > > down the unmount. Ratelimit the warning to prevent this problem
> > > > while still informing the user that errors have occurred.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_buf.c | 7 +++----
> > > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index 93942d8e35dd..5120fed06075 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
> > > >  			bp = list_first_entry(&dispose, struct xfs_buf, b_lru);
> > > >  			list_del_init(&bp->b_lru);
> > > >  			if (bp->b_flags & XBF_WRITE_FAIL) {
> > > > -				xfs_alert(btp->bt_mount,
> > > > -"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > > > +				xfs_alert_ratelimited(btp->bt_mount,
> > > > +"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\n"
> > > > +"Please run xfs_repair to determine the extent of the problem.",
> > > >  					(long long)bp->b_bn);
> > > 
> > > Hmmmm. I was under the impression that multiple line log messages
> > > were frowned upon because they prevent every output line in the log
> > > being tagged correctly. That's where KERN_CONT came from (i.e. it's
> > > a continuation of a previous log message), but we don't use that
> > > with the XFS logging and hence multi-line log messages are split
> > > into multiple logging calls.
> > > 
> > 
> > I debated combining these into a single line for that exact reason for
> > about a second and then just went with this because I didn't think it
> > mattered that much.
> 
> It doesn't matter to us, but it does matter to those people who want
> their log entries correctly tagged for their classification
> engines...
> 

Makes sense, though I am a bit curious whether it would be categorized
correctly even when fixed up, or whether something like a single long
line would be preferred over two. *shrug*

> > > IOWs, this might be better handled just using a static ratelimit
> > > variable here....
> > > 
> > > Actually, we already have one for xfs_buf_item_push() to limit
> > > warnings about retrying XBF_WRITE_FAIL buffers:
> > > 
> > > static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
> > > 
> > > Perhaps we should be using the same ratelimit variable here....
> > > 
> > 
> > IIRC that was static in another file, but we can centralize (and perhaps
> > generalize..) it somewhere if that is preferred..
> 
> I think it makes sense to have all the buffer write fail
> messages ratelimited under the same variable - once it starts
> spewing messages, we should limit them all the same way...
> 

Yeah. I actually ended up sticking the ratelimit in the buftarg as it
comes off a bit cleaner than a global and I don't think there's much of
a practical difference in having a per-target limit.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

