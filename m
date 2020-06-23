Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CC2C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8386820780
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MsZFxbRX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbgFWRQB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:16:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728916AbgFWRQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 13:16:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592932558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L7YTMHwGFM/8UvyaH+thFi3hyeOfENr0NBI+YuGKZ+A=;
        b=MsZFxbRXquIfiQufYAIRvRCd12tde9JzpKcWk0Utvrsl5UhhK4c9pEMkrDY0shmWEa9+vh
        6FI1k+0+MDoH7IE/vXTQEEZ4x9kfry2SCjp67V7zHYfsJLcx4pzLXA7piuQDpI6OXX5LKj
        uXydnxnaZh2OhxhRP0cSYRSdfB6bXNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-xRLCioPfNZa9dY69Fgn0qg-1; Tue, 23 Jun 2020 13:15:57 -0400
X-MC-Unique: xRLCioPfNZa9dY69Fgn0qg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15CB7107ACCD;
        Tue, 23 Jun 2020 17:15:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80DDE5DD63;
        Tue, 23 Jun 2020 17:15:53 +0000 (UTC)
Date:   Tue, 23 Jun 2020 13:15:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200623171551.GB56510@bfoster>
References: <20200623035010.GF7606@magnolia>
 <20200623121031.GB55038@bfoster>
 <20200623152350.GE7625@magnolia>
 <20200623164934.GA56510@bfoster>
 <20200623170054.GF7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623170054.GF7625@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 10:00:54AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 23, 2020 at 12:49:34PM -0400, Brian Foster wrote:
> > On Tue, Jun 23, 2020 at 08:23:50AM -0700, Darrick J. Wong wrote:
> > > On Tue, Jun 23, 2020 at 08:10:31AM -0400, Brian Foster wrote:
> > > > On Mon, Jun 22, 2020 at 08:50:10PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > The data fork scrubber calls filemap_write_and_wait to flush dirty pages
> > > > > and delalloc reservations out to disk prior to checking the data fork's
> > > > > extent mappings.  Unfortunately, this means that scrub can consume the
> > > > > EIO/ENOSPC errors that would otherwise have stayed around in the address
> > > > > space until (we hope) the writer application calls fsync to persist data
> > > > > and collect errors.  The end result is that programs that wrote to a
> > > > > file might never see the error code and proceed as if nothing were
> > > > > wrong.
> > > > > 
> > > > > xfs_scrub is not in a position to notify file writers about the
> > > > > writeback failure, and it's only here to check metadata, not file
> > > > > contents.  Therefore, if writeback fails, we should stuff the error code
> > > > > back into the address space so that an fsync by the writer application
> > > > > can pick that up.
> > > > > 
> > > > > Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
> > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > ---
> > > > > v2: explain why it's ok to keep going even if writeback fails
> > > > > ---
> > > > >  fs/xfs/scrub/bmap.c |   19 ++++++++++++++++++-
> > > > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > > index 7badd6dfe544..0d7062b7068b 100644
> > > > > --- a/fs/xfs/scrub/bmap.c
> > > > > +++ b/fs/xfs/scrub/bmap.c
> > > > > @@ -47,7 +47,24 @@ xchk_setup_inode_bmap(
> > > > >  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> > > > >  		inode_dio_wait(VFS_I(sc->ip));
> > > > >  		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> > > > > -		if (error)
> > > > > +		if (error == -ENOSPC || error == -EIO) {
> > > > > +			/*
> > > > > +			 * If writeback hits EIO or ENOSPC, reflect it back
> > > > > +			 * into the address space mapping so that a writer
> > > > > +			 * program calling fsync to look for errors will still
> > > > > +			 * capture the error.
> > > > > +			 *
> > > > > +			 * However, we continue into the extent mapping checks
> > > > > +			 * because write failures do not necessarily imply
> > > > > +			 * anything about the correctness of the file metadata.
> > > > > +			 * The metadata and the file data could be on
> > > > > +			 * completely separate devices; a media failure might
> > > > > +			 * only affect a subset of the disk, etc.  We properly
> > > > > +			 * account for delalloc extents, so leaving them in
> > > > > +			 * memory is fine.
> > > > > +			 */
> > > > > +			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
> > > > 
> > > > I think the more appropriate thing to do is open code the data write and
> > > > wait and use the variants of the latter that don't consume address space
> > > > errors in the first place (i.e. filemap_fdatawait_keep_errors()). Then
> > > > we wouldn't need the special error handling branch or perhaps the first
> > > > part of the comment. Hm?
> > > 
> > > Yes, it's certainly possible.  I don't want to go opencoding more vfs
> > > methods (like some e4 filesystems do) so I'll propose that as a second
> > > patch for 5.9.
> > > 
> > 
> > What's the point of fixing it twice when the generic code already
> > exports the appropriate helpers? filemap_fdatawrite() and
> > filemap_fdatawait_keep_errors() are used fairly commonly afaict. That
> > seems much more straightforward to me than misusing a convenience helper
> > and trying to undo the undesirable effects after the fact.
> 
> Blergh.  Apparently my eyes suck at telling fdatawait from fdatawrite
> and I got all twisted around.  Now I realize that I think you were
> asking why I didn't simply call:
> 
> filemap_flush()
> filemap_fdatawait_keep_errors()
> 
> one after the other?  And yes, that's way better than throwing error
> codes back into the mapping.  I'll do that, thanks.
> 

Yeah basically, though I was looking more at filemap_fdatawrite() simply
because it's analogous to the write component of
filemap_write_and_wait(). It looks like the only difference with
filemap_flush() is it uses WB_SYNC_NONE instead of WB_SYNC_ALL. Perhaps
either one is fine from here..

> > > On second thought, I wonder if I should just drop the flush entirely?
> > > It's not a huge burden to skip past the delalloc reservations.
> > > 
> > > Hmmm.  Any preferences?
> > > 
> > 
> > The context for the above is not clear to me. If the purpose is to check
> > on-disk metadata, shouldn't we flush the in-core content first? It would seem
> > a little strange to me for one file check to behave differently from
> > another if the only difference between the two is that some or more of a
> > file had been written back, but maybe I'm missing details..
> 
> Originally it was because the bmap scrubber didn't handle delalloc
> extents, but that was changed long ago.  Nowadays it only exists as a
> precautionary "try to push everything to disk" tactic.
> 

Ok. When you mention "skip past the delalloc reservations" above that
implies to me we'd skip some processing/validation bits. If that's not
the case then perhaps it doesn't matter as much...

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > +		} else if (error)
> > > > >  			goto out;
> > > > >  	}
> > > > >  
> > > > > 
> > > > 
> > > 
> > 
> 

