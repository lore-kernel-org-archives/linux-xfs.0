Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C11BC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0456C20722
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:01:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OeWIKyoy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDTOBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:01:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25457 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDTOBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bC9AaZL0Aw8hLrhvX/WosSdnOGfxMAv3zHUBa4ElZYU=;
        b=OeWIKyoybEECuMkPUasqGsrlhkCBh2arDFP/ajn1KqYhVTxVR8uTwHay5t/0ntONfNNybG
        582YEvzdZsnmEWOlUkFQB2oBV9Bsori8TvEnGf7CyELKrpoH1BEZvQwvGlMhq3/+SrIGgi
        l7rydcl+6VzzUBtAgTjoeGqmZAttMgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-EoewnivrMrKIxs7o_QQpog-1; Mon, 20 Apr 2020 10:01:02 -0400
X-MC-Unique: EoewnivrMrKIxs7o_QQpog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8BE5149C3;
        Mon, 20 Apr 2020 14:01:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59492A1059;
        Mon, 20 Apr 2020 14:01:01 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:00:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: always attach iflush_done and simplify error
 handling
Message-ID: <20200420140059.GD27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-4-bfoster@redhat.com>
 <20200420030852.GF9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420030852.GF9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 01:08:52PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:50AM -0400, Brian Foster wrote:
> > The inode flush code has several layers of error handling between
> > the inode and cluster flushing code. If the inode flush fails before
> > acquiring the backing buffer, the inode flush is aborted. If the
> > cluster flush fails, the current inode flush is aborted and the
> > cluster buffer is failed to handle the initial inode and any others
> > that might have been attached before the error.
> > 
> > Since xfs_iflush() is the only caller of xfs_iflush_cluser(), the
> 
> xfs_iflush_cluster()
> 

Fixed.

> > error handling between the two can be condensed in the top-level
> > function. If we update xfs_iflush_int() to attach the item
> > completion handler to the buffer first, any errors that occur after
> > the first call to xfs_iflush_int() can be handled with a buffer
> > I/O failure.
> > 
> > Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
> > and consolidate with the existing error handling. This also replaces
> > the need to release the buffer because failing the buffer with
> > XBF_ASYNC drops the current reference.
> 
> Yeah, that makes sense. I've lifted the cluster flush error handling
> into the callers, even though xfs_iflush() has gone away.
> 
> However...
> 
> > @@ -3798,6 +3765,13 @@ xfs_iflush_int(
> >  	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> >  	ASSERT(iip != NULL && iip->ili_fields != 0);
> >  
> > +	/*
> > +	 * Attach the inode item callback to the buffer. Whether the flush
> > +	 * succeeds or not, buffer I/O completion processing is now required to
> > +	 * remove the inode from the AIL and release the flush lock.
> > +	 */
> > +	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
> > +
> >  	/* set *dip = inode's place in the buffer */
> >  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
> 
> ...I'm not convinced this is a valid thing to do at this point. The
> inode item has not been set up yet with the correct state that is
> associated with the flushing of the inode (e.g. lsn, last_flags,
> etc) and so this kinda leaves a landmine in the item IO completion
> processing in that failure cannot rely on any of the inode log item
> state to make condition decisions.
> 

It is a bit ugly. I moved it just because it seemed like it could
facilitate enough simplification to be worthwhile. It's debatable
whether what ultimately fell out of that is worthwhile, of course. TBH,
I find the whole I/O approach to the error sequence rather rickety, even
though it's currently necessary, so I'm sympathetic to the argument of
not risking the common code path in service to the uncommon error path.

We could consider other tweaks like making flush imminent and leaving
the error checks at the end of the function (with documentation to
explain that we're shutting down, etc.), but I'd have to think about
that some more. It could be best just to leave this code as is if you
anticipate it going away relatively soon. This whole series was just
intended to be quick hit cleanups anyways...

Brian

> While it's technically not wrong, it just makes me uneasy, as in
> future the flush abort code will have to be careful about using
> inode state in making decisions, and there's not comments in the
> abort code to indicate that the state may be invalid...
> 
> /me has chased several subtle issues through this code recently...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

