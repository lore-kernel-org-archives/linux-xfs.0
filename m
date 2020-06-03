Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DA4C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AF020679
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 14:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QZ4U2yks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgFCO6W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 10:58:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbgFCO6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 10:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VlIzA4Vjqtn1GvMO5f/8KoUNX3wbaUdKx3FXF2wlqeg=;
        b=QZ4U2yks8Sb1ymJ0I5rRvX0cGAt5R5QcbRGz7+gdSXHXcePfOciglCYiziLIXWWLr48IVM
        pKcC5UE8ldU52fdRVNFW7gpG/+1GJTfkiwByd8t6o/YVH0+NvdgIL/ND2fYMelsGni4XNP
        dFxRD796FbeXHUlJB1Of1n+pjx41RKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-qndFLPFUOTirJTIz11kTpA-1; Wed, 03 Jun 2020 10:58:17 -0400
X-MC-Unique: qndFLPFUOTirJTIz11kTpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3BF9115D;
        Wed,  3 Jun 2020 14:58:16 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C169323;
        Wed,  3 Jun 2020 14:58:15 +0000 (UTC)
Date:   Wed, 3 Jun 2020 10:58:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/30] xfs: call xfs_buf_iodone directly
Message-ID: <20200603145813.GB12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-8-david@fromorbit.com>
 <20200602164742.GG7967@bfoster>
 <20200602213809.GG2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602213809.GG2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 07:38:09AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 12:47:42PM -0400, Brian Foster wrote:
> > On Tue, Jun 02, 2020 at 07:42:28AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > All unmarked dirty buffers should be in the AIL and have log items
> > > attached to them. Hence when they are written, we will run a
> > > callback to remove the item from the AIL if appropriate. Now that
> > > we've handled inode and dquot buffers, all remaining calls are to
> > > xfs_buf_iodone() and so we can hard code this rather than use an
> > > indirect call.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/xfs/xfs_buf.c       | 24 ++++++++----------------
> > >  fs/xfs/xfs_buf.h       |  6 +-----
> > >  fs/xfs/xfs_buf_item.c  | 40 ++++++++++------------------------------
> > >  fs/xfs/xfs_buf_item.h  |  4 ++--
> > >  fs/xfs/xfs_trans_buf.c | 13 +++----------
> > >  5 files changed, 24 insertions(+), 63 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 0a69de674af9d..d7695b638e994 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > ...
> > > @@ -1226,14 +1225,7 @@ xfs_buf_ioend(
> > >  		xfs_buf_dquot_iodone(bp);
> > >  		return;
> > >  	}
> > > -
> > > -	if (bp->b_iodone) {
> > > -		(*(bp->b_iodone))(bp);
> > > -		return;
> > > -	}
> > > -
> > > -out_finish:
> > > -	xfs_buf_ioend_finish(bp);
> > > +	xfs_buf_iodone(bp);
> > 
> > The way this function ends up would probably look nicer as an if/else
> > chain rather than a sequence of internal return statements.
> 
> I've kinda avoided refactoring these early patches because they
> cascade into non-trivial conflicts with later patches in the series.
> I've spent too much time chasing bugs introduced in the later
> patches because of conflict resolution not being quite right. Hence
> I want to leave cleanup and refactoring to a series after this whole
> line of development is complete and the problems are solved.
> 
> > BTW, is there a longer term need to have three separate iodone functions
> > here that do the same thing?
> 
> The inode iodone function changes almost immediately. I did it this
> way so that the process of changing the inode buffer completion
> functionality did not, in any way, impact on other types of buffers.
> We need to go through the same process with dquot buffers, and then
> once that is done, we can look to refactor all this into a more
> integrated solution that largely sits in xfs_buf.c.
> 

Seems reasonable enough to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

