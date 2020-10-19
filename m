Return-Path: <SRS0=Yj0O=D2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BCFC433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDDCE22269
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Oct 2020 16:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IITfxn3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgJSQz0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:55:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730322AbgJSQz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 12:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603126525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6kYr/b57J6181d/iY9AgpTntDbMLLIa973PYgJvqrc=;
        b=IITfxn3n94u/g52v3OeobXsT7CG4LHgUqhM/ASi9Ioz84wwC56oqMO0gomGQxTiFuoMSPZ
        FWN3fTgVX3Oaczvq4TRmBRxThAlgUF8SK+JTVjdfLMcP8PK5LS6/jsQYgncP8fRK+24rTR
        18a2T8p425A++PMGugfI7CK6IMLzYms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-Q4Suqz6GOEKSakXVIHaPOg-1; Mon, 19 Oct 2020 12:55:22 -0400
X-MC-Unique: Q4Suqz6GOEKSakXVIHaPOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F6A41868403;
        Mon, 19 Oct 2020 16:55:21 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C1055C1A3;
        Mon, 19 Oct 2020 16:55:21 +0000 (UTC)
Date:   Mon, 19 Oct 2020 12:55:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: zero cached pages over unwritten extents on
 zero range
Message-ID: <20201019165519.GB1232435@bfoster>
References: <20201012140350.950064-1-bfoster@redhat.com>
 <20201012140350.950064-3-bfoster@redhat.com>
 <20201015094901.GC21420@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015094901.GC21420@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 10:49:01AM +0100, Christoph Hellwig wrote:
> > +iomap_zero_range_skip_uncached(struct inode *inode, loff_t *pos,
> > +		loff_t *count, loff_t *written)
> > +{
> > +	unsigned dirty_offset, bytes = 0;
> > +
> > +	dirty_offset = page_cache_seek_hole_data(inode, *pos, *count,
> > +				SEEK_DATA);
> > +	if (dirty_offset == -ENOENT)
> > +		bytes = *count;
> > +	else if (dirty_offset > *pos)
> > +		bytes = dirty_offset - *pos;
> > +
> > +	if (bytes) {
> > +		*pos += bytes;
> > +		*count -= bytes;
> > +		*written += bytes;
> > +	}
> 
> I find the calling conventions weird.  why not return bytes and
> keep the increments/decrements of the three variables in the caller?
> 

No particular reason. IIRC I had it both ways and just landed on this.
I'd change it, but as mentioned in the patch 1 thread I don't think this
patch is sufficient (with or without patch 1) anyways because the page
can also have been reclaimed before we get here.

Brian

