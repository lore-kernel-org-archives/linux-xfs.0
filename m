Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255F9C7EE24
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 13:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjFENMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 09:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjFENMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 09:12:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E41C13A;
        Mon,  5 Jun 2023 06:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YzWilUaQhEhnp6iHZKAZw13zyavby6fW898RFHgm4o4=; b=ow8ozcdWQ2BmlaPy5iMwWEDrSk
        BB5OVfFFttrQv9BHe0ds+YRLiGfjHos9C8xcalNDu41jl525WKqAikeojSQX7AaDnvq9wXI+escDs
        ftWnuxRoujqWiPK30UMr+DmRjAx/WOwL561JHPvqeBEOQXiLzzzNa4h3oGByu0mJcA+BiVtV9ZAsh
        T8/xzDylpYbUudM43QUjzY5P2zeLU2OOj0N7Kl6jkcaVWDJjeJR6DLcYFNpLdfyS0M7qlawyGdi/n
        Q1qTNZRucZ5X9dASOlhHbWZ0fav00s5HUMFwipvABc1X4CMNjk8lKn8b34RiPoiMhK+fZU9qje+vP
        KRgJ4pyw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q69zn-00C2bP-Bb; Mon, 05 Jun 2023 13:11:39 +0000
Date:   Mon, 5 Jun 2023 14:11:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/7] doc: Correct the description of ->release_folio
Message-ID: <ZH3fCy+J+oLDTTkf@casper.infradead.org>
References: <20230602222445.2284892-1-willy@infradead.org>
 <20230602222445.2284892-3-willy@infradead.org>
 <20230604175548.GA72241@frogsfrogsfrogs>
 <ZHzvzzvoQGmIaO6n@casper.infradead.org>
 <20230604203306.GB72267@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604203306.GB72267@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 04, 2023 at 01:33:06PM -0700, Darrick J. Wong wrote:
> On Sun, Jun 04, 2023 at 09:10:55PM +0100, Matthew Wilcox wrote:
> > On Sun, Jun 04, 2023 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > > On Fri, Jun 02, 2023 at 11:24:39PM +0100, Matthew Wilcox (Oracle) wrote:
> > > > -->release_folio() is called when the kernel is about to try to drop the
> > > > -buffers from the folio in preparation for freeing it.  It returns false to
> > > > -indicate that the buffers are (or may be) freeable.  If ->release_folio is
> > > > -NULL, the kernel assumes that the fs has no private interest in the buffers.
> > > > +->release_folio() is called when the MM wants to make a change to the
> > > > +folio that would invalidate the filesystem's private data.  For example,
> > > > +it may be about to be removed from the address_space or split.  The folio
> > > > +is locked and not under writeback.  It may be dirty.  The gfp parameter is
> > > > +not usually used for allocation, but rather to indicate what the filesystem
> > > > +may do to attempt to free the private data.  The filesystem may
> > > > +return false to indicate that the folio's private data cannot be freed.
> > > > +If it returns true, it should have already removed the private data from
> > > > +the folio.  If a filesystem does not provide a ->release_folio method,
> > > > +the kernel will call try_to_free_buffers().
> > > 
> > > the MM?  Since you changed that above... :)
> > > 
> > > With that nit fixed,
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Well, is it the MM?  At this point, the decision is made by
> > filemap_release_folio(), which is the VFS, in my opinion ;-)
> 
> It's in mm/filemap.c, which I think makes it squarely the pagecache/mm,
> not the vfs.

Changed this to:

If a filesystem does not provide a ->release_folio method,
the pagecache will assume that private data is buffer_heads and call
try_to_free_buffers().

