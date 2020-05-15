Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28A7C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 12:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C532074D
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 12:00:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGeZ88r2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgEOMAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 08:00:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49919 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726062AbgEOMAf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 08:00:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589544033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zi7MQWUvR1hDgXwN1sV8tC5V38CNUw+lR+eXrdFfP3o=;
        b=FGeZ88r2pICHF1LlyYam4QHkHPu9I1bVj1fTw7wgZ6ieJu56AyfOyuKvv81oAbCbur0iHy
        prGYfOjkeQg5uAlNUGQ0nhBc3RTNVJAnZ1O048zkQXmSU3Py3gPj2bZtBU8utDutT8+vY/
        RJLe+weTKiHt+aqKVCVywb2I8A+gn5E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-zkPDTq12NlyKZqxb1JSBIQ-1; Fri, 15 May 2020 08:00:32 -0400
X-MC-Unique: zkPDTq12NlyKZqxb1JSBIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1449F1902EBA;
        Fri, 15 May 2020 12:00:31 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AD0D78B3A;
        Fri, 15 May 2020 12:00:30 +0000 (UTC)
Date:   Fri, 15 May 2020 08:00:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't fail verifier on empty attr3 leaf block
Message-ID: <20200515120028.GC54804@bfoster>
References: <20200513145343.45855-1-bfoster@redhat.com>
 <20200514205210.GJ6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514205210.GJ6714@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 01:52:10PM -0700, Darrick J. Wong wrote:
> On Wed, May 13, 2020 at 10:53:43AM -0400, Brian Foster wrote:
> > The attr fork can transition from shortform to leaf format while
> > empty if the first xattr doesn't fit in shortform. While this empty
> > leaf block state is intended to be transient, it is technically not
> > due to the transactional implementation of the xattr set operation.
> > 
> > We historically have a couple of bandaids to work around this
> > problem. The first is to hold the buffer after the format conversion
> > to prevent premature writeback of the empty leaf buffer and the
> > second is to bypass the xattr count check in the verifier during
> > recovery. The latter assumes that the xattr set is also in the log
> > and will be recovered into the buffer soon after the empty leaf
> > buffer is reconstructed. This is not guaranteed, however.
> > 
> > If the filesystem crashes after the format conversion but before the
> > xattr set that induced it, only the format conversion may exist in
> > the log. When recovered, this creates a latent corrupted state on
> > the inode as any subsequent attempts to read the buffer fail due to
> > verifier failure. This includes further attempts to set xattrs on
> > the inode or attempts to destroy the attr fork, which prevents the
> > inode from ever being removed from the unlinked list.
> > 
> > To avoid this condition, accept that an empty attr leaf block is a
> > valid state and remove the count check from the verifier. This means
> > that on rare occasions an attr fork might exist in an unexpected
> > state, but is otherwise consistent and functional. Note that we
> > retain the logic to avoid racing with metadata writeback to reduce
> > the window where this can occur.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v1:
> > - Remove the verifier check instead of warn.
> > rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/
> > 
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 863444e2dda7..6b94bb9de378 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -308,14 +308,6 @@ xfs_attr3_leaf_verify(
> >  	if (fa)
> >  		return fa;
> >  
> > -	/*
> > -	 * In recovery there is a transient state where count == 0 is valid
> > -	 * because we may have transitioned an empty shortform attr to a leaf
> > -	 * if the attr didn't fit in shortform.
> 
> /me wonders if it would be useful for future spelunkers to retain some
> sort of comment here that we once thought count==0 was bad but screwed
> it up enough that we now allow it?
> 
> Moreso that future me/fuzzrobot won't come along having forgotten
> everything and think "Oh, we need to validate hdr.count!" :P
> 

Fine by me. Something like the following perhaps?

"This verifier historically failed empty leaf buffers because we expect
the fork to be in another format. Empty attr fork format conversions are
possible during xattr set, however, and format conversion is not atomic
with the xattr set that triggers it. We cannot assume leaf blocks are
non-empty until that is addressed."

Brian

> --D
> 
> > -	 */
> > -	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
> > -		return __this_address;
> > -
> >  	/*
> >  	 * firstused is the block offset of the first name info structure.
> >  	 * Make sure it doesn't go off the block or crash into the header.
> > -- 
> > 2.21.1
> > 
> 

