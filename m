Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7484BC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 13:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523A72070B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 13:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VbFSRvbu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgDTN65 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:58:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42441 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726006AbgDTN64 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 09:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jwuQisKY0pqEstv1HvYuJUHmC1gnguzDZdRVUtddmrQ=;
        b=VbFSRvbu+lyY+8H8Eedr1XJK56OgeRsyknYtb25jlQM89N8WlwxTFsl3rYHHSJd4irS2Iv
        T5Flm+3Q3r8DoQbSubbMymKk+ftgjG2eiE615C13bBSaYHqBy892L391xL/hNnCCXcVBB7
        wTNubO58EGbn5Z9yMTbvQVLqUjx44MM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-Dry8DNbHNgieRpri8j_cBg-1; Mon, 20 Apr 2020 09:58:54 -0400
X-MC-Unique: Dry8DNbHNgieRpri8j_cBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12E1DDBA7;
        Mon, 20 Apr 2020 13:58:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABF6539C;
        Mon, 20 Apr 2020 13:58:52 +0000 (UTC)
Date:   Mon, 20 Apr 2020 09:58:50 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: factor out buffer I/O failure simulation code
Message-ID: <20200420135850.GB27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-3-bfoster@redhat.com>
 <20200420024840.GE9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420024840.GE9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 12:48:40PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:49AM -0400, Brian Foster wrote:
> > We use the same buffer I/O failure simulation code in a few
> > different places. It's not much code, but it's not necessarily
> > self-explanatory. Factor it into a helper and document it in one
> > place.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c      | 23 +++++++++++++++++++----
> >  fs/xfs/xfs_buf.h      |  1 +
> >  fs/xfs/xfs_buf_item.c | 22 +++-------------------
> >  fs/xfs/xfs_inode.c    |  7 +------
> >  4 files changed, 24 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 9ec3eaf1c618..93942d8e35dd 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1248,6 +1248,24 @@ xfs_buf_ioerror_alert(
> >  			-bp->b_error);
> >  }
> >  
> > +/*
> > +  * To simulate an I/O failure, the buffer must be locked and held with at least
> 
> Whitespace.
> 

Fixed.

> > + * three references. The LRU reference is dropped by the stale call. The buf
> > + * item reference is dropped via ioend processing. The third reference is owned
> > + * by the caller and is dropped on I/O completion if the buffer is XBF_ASYNC.
> > + */
> > +void
> > +xfs_buf_iofail(
> > +	struct xfs_buf	*bp,
> > +	int		flags)
> > +{
> > +	bp->b_flags |= flags;
> > +	bp->b_flags &= ~XBF_DONE;
> > +	xfs_buf_stale(bp);
> > +	xfs_buf_ioerror(bp, -EIO);
> > +	xfs_buf_ioend(bp);
> > +}
> 
> This function is an IO completion function. Can we call it
> xfs_buf_ioend_fail(), please, to indicate that it both fails and
> completes the IO in progress?
> 

Works for me..

Brian

> 
> Otherwise ok.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

