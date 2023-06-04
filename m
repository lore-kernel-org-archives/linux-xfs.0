Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE1BC7EE23
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 20:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjFDULG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 16:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFDULF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 16:11:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C19BD;
        Sun,  4 Jun 2023 13:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cHvwEbHpV0ENbEmj7nDYZdUf2MVBQt9jV3D26Rj+Kvg=; b=NlVQuo06VvWJjIp+shYMwyFfUw
        QD6UgGjM/3lY/ha1r4S/tBUiw/gPn+rcbQjpPN0M+Xbz/wwOmvCi6kw3hy26EdKvGb+LKBFJmmCRq
        v75g95FQ5jgli4ue7NOTDFl2ryjPtEsH+0ip/P7y6dQz6vBBGzsj8k2d4GerAMB8A8jWC7L/r7CNg
        7XuhWX1vgQMnMwYDuijJ+s6vDbw7tNjJeQFVjdb6OnPkBog66IIkjxhPOASa/i1N0LFDiYLONhGnx
        iyzL3f7dcL9X/lortEqkHRtv1IDanuj0QhaH/Qwc9ky6CxyWrS+FZGs/kKoeFM3rHfWvxrgpJn+Gp
        Ar1ilprA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q5u3z-00BJI4-GM; Sun, 04 Jun 2023 20:10:55 +0000
Date:   Sun, 4 Jun 2023 21:10:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/7] doc: Correct the description of ->release_folio
Message-ID: <ZHzvzzvoQGmIaO6n@casper.infradead.org>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-3-willy@infradead.org>
 <20230604175548.GA72241@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604175548.GA72241@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 04, 2023 at 10:55:48AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 02, 2023 at 11:24:39PM +0100, Matthew Wilcox (Oracle) wrote:
> > -->release_folio() is called when the kernel is about to try to drop the
> > -buffers from the folio in preparation for freeing it.  It returns false to
> > -indicate that the buffers are (or may be) freeable.  If ->release_folio is
> > -NULL, the kernel assumes that the fs has no private interest in the buffers.
> > +->release_folio() is called when the MM wants to make a change to the
> > +folio that would invalidate the filesystem's private data.  For example,
> > +it may be about to be removed from the address_space or split.  The folio
> > +is locked and not under writeback.  It may be dirty.  The gfp parameter is
> > +not usually used for allocation, but rather to indicate what the filesystem
> > +may do to attempt to free the private data.  The filesystem may
> > +return false to indicate that the folio's private data cannot be freed.
> > +If it returns true, it should have already removed the private data from
> > +the folio.  If a filesystem does not provide a ->release_folio method,
> > +the kernel will call try_to_free_buffers().
> 
> the MM?  Since you changed that above... :)
> 
> With that nit fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Well, is it the MM?  At this point, the decision is made by
filemap_release_folio(), which is the VFS, in my opinion ;-)

But I'm happy to use "the MM".  Or "the pagecache".
