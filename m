Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43320C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18B0B2076E
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 17:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8MW91QN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCXR3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 13:29:55 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47379 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXR3z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585070994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EdaUVSwo4XlP8NuVHtGZkjkvFl9qHK/bUCkBWnDBFTQ=;
        b=N8MW91QNYRm9ROZJI8n9/gMepK+9KIm8/ttewzVWn/7S1u7CJw0j8HYqmGtm1pidBwIP2w
        9uG5meGbH0W/xJPZsq6Ta76ZpMuous7juGbK6cRhTtoxELGWtMf5EX8+p8DUkFWV2BSh+s
        SK+pSU6eKvxQfustEc43bZWNxpyrGfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-tA46Cui_NWWlMWqnENyN7Q-1; Tue, 24 Mar 2020 13:29:52 -0400
X-MC-Unique: tA46Cui_NWWlMWqnENyN7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF09218A5500;
        Tue, 24 Mar 2020 17:29:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6584319C6A;
        Tue, 24 Mar 2020 17:29:51 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:29:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shutdown on failure to add page to log bio
Message-ID: <20200324172949.GB3148@bfoster>
References: <20200324165700.7575-1-bfoster@redhat.com>
 <20200324171859.GF29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324171859.GF29339@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 10:18:59AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 24, 2020 at 12:57:00PM -0400, Brian Foster wrote:
> > If the bio_add_page() call fails, we proceed to write out a
> > partially constructed log buffer. This corrupts the physical log
> > such that log recovery is not possible. Worse, persistent
> > occurrences of this error eventually lead to a BUG_ON() failure in
> > bio_split() as iclogs wrap the end of the physical log, which
> > triggers log recovery on subsequent mount.
> > 
> > Rather than warn about writing out a corrupted log buffer, shutdown
> > the fs as is done for any log I/O related error. This preserves the
> > consistency of the physical log such that log recovery succeeds on a
> > subsequent mount. Note that this was observed on a 64k page debug
> > kernel without upstream commit 59bb47985c1d ("mm, sl[aou]b:
> > guarantee natural alignment for kmalloc(power-of-two)"), which
> > demonstrated frequent iclog bio overflows due to unaligned (slab
> > allocated) iclog data buffers.
> 
> Fixes: tag?
> 

I suppose you could argue it fixes commit 79b54d9bfcdcd ("xfs: use bios
directly to write log buffers"), but I didn't include a tag because this
is not really fixing a reproducible bug. It's fixing up the error
handling based on a bad combination of patches in a distro kernel.
Perhaps I'm just not clear on when we do or don't want a fixes tag..?

Brian

> Otherwise, looks ok to me.
> 
> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 2a90a483c2d6..ebb6a5c95332 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1705,16 +1705,22 @@ xlog_bio_end_io(
> >  
> >  static void
> >  xlog_map_iclog_data(
> > -	struct bio		*bio,
> > -	void			*data,
> > +	struct xlog_in_core	*iclog,
> >  	size_t			count)
> >  {
> > +	struct xfs_mount	*mp = iclog->ic_log->l_mp;
> > +	struct bio		*bio = &iclog->ic_bio;
> > +	void			*data = iclog->ic_data;
> > +
> >  	do {
> >  		struct page	*page = kmem_to_page(data);
> >  		unsigned int	off = offset_in_page(data);
> >  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
> >  
> > -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> > +		if (bio_add_page(bio, page, len, off) != len) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
> > +			break;
> > +		}
> >  
> >  		data += len;
> >  		count -= len;
> > @@ -1762,7 +1768,7 @@ xlog_write_iclog(
> >  	if (need_flush)
> >  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> >  
> > -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
> > +	xlog_map_iclog_data(iclog, count);
> >  	if (is_vmalloc_addr(iclog->ic_data))
> >  		flush_kernel_vmap_range(iclog->ic_data, count);
> >  
> > -- 
> > 2.21.1
> > 
> 

