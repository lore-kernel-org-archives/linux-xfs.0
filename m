Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF45CC35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 03:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB112072B
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 03:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jQfEPWti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgBEDso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 22:48:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55319 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727774AbgBEDso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 22:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580874523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xPrwzL3Fh3ckmw+yUpH4fMYo2RPDMrU87w1lXB4l3/Y=;
        b=jQfEPWtiBSGVrxRBXAbE83pAApsATHaocdv7C/6KrboodoX3zeAGMe+oSFtb5w937oIs43
        oZ5ATZpjRtcXoNOp/klA2qgk3Q5dCTcKIOPQo7jV0uzBdtRFEPyuodC1jxnJ4EVLv2NO5A
        w4xWU+i8IfX+B9wNVTE7wZAchm5kvHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-WFNG_bQaNWGe4KsVbDrxzg-1; Tue, 04 Feb 2020 22:48:40 -0500
X-MC-Unique: WFNG_bQaNWGe4KsVbDrxzg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47D9C8010F0;
        Wed,  5 Feb 2020 03:48:39 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B32E38575A;
        Wed,  5 Feb 2020 03:48:38 +0000 (UTC)
Date:   Wed, 5 Feb 2020 11:58:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in
 xfs_attr3_node_inactive
Message-ID: <20200205035830.GN14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org
References: <20200204070636.25572-1-zlang@redhat.com>
 <20200204213932.GM20628@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204213932.GM20628@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 08:39:32AM +1100, Dave Chinner wrote:
> On Tue, Feb 04, 2020 at 03:06:36PM +0800, Zorro Lang wrote:
> > This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> > gets 'child_bp' at there:
> >   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> >                             child_blkno,
> >                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> >                             &child_bp);
> >   if (error)
> >           return error;
> >   error = bp->b_error;
> > 
> > But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
> >   xfs_trans_brelse(*trans, bp);
> 
> ....
> > ---
> >  fs/xfs/xfs_attr_inactive.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index bbfa6ba84dcd..26230d150bf2 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
> >  				&child_bp);
> >  		if (error)
> >  			return error;
> > -		error = bp->b_error;
> > +		error = child_bp->b_error;
> >  		if (error) {
> >  			xfs_trans_brelse(*trans, child_bp);
> >  			return error;
> 
> Isn't this dead code now? i.e. any error that occurs on the buffer
> during a xfs_trans_get_buf() call is returned directly and so it's
> caught by the "if (error)" check. Hence this whole child_bp->b_error
> check can be removed, right?

Thanks, by looking into the xfs_trans_get_buf() code, I think you're right. Sorry
I didn't recognise that before.

But when should we check the bp->b_error? and when's it not necessary?
In other words, when XFS set the bp->b_error? Looks like it's set in some *verify*
functions and ioend time?

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

