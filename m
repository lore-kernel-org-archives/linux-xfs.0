Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573C5C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 08:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiKBI6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 04:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiKBI6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 04:58:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93565286F2;
        Wed,  2 Nov 2022 01:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tGQOZaOUhyiWD3fMwAgU0vgxkeBkDIeOotVV2G5Kocs=; b=IMLNTj6Tbti4KAjxNIhTLOMc8P
        pdAHIuUgPOEZXL7VPFtQW0sQKRlh5xFerbL3hyggg/MowdSVQQQb/yepKs4VyppfqSfXEADXLd87q
        W9vuUBcJH5Ipluq4gT0yMjHnTo33cmfOoX4IEAS5RrOxqvI4K3EwmVnLhqWeyVlKzuJmjO5u27b8i
        HJpEg+GEFQ1mMAOPdS1pwWP8hwEHx/KCwg3DxGfWqcc1AHZHsvxThmwtyF4RF+ETkW5Nfl9+TxI2t
        50iTvd6zKOuvkYFT1EGp7SLdGDqkD7Waqwi3wFJWkeh7J7fjzPK+0lOJ0sbjQPCQzAWHmrbzOJ1Zt
        sA90f5Ow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oq9ZO-009Hp0-9S; Wed, 02 Nov 2022 08:57:58 +0000
Date:   Wed, 2 Nov 2022 01:57:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Aravinda Herle <araherle@in.ibm.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC 2/2] iomap: Support subpage size dirty tracking to improve
 write performance
Message-ID: <Y2IxFlfLwPtloYc+@infradead.org>
References: <cover.1666928993.git.ritesh.list@gmail.com>
 <886076cfa6f547d22765c522177d33cf621013d2.1666928993.git.ritesh.list@gmail.com>
 <20221028210422.GC3600936@dread.disaster.area>
 <Y19EXLfn8APg3adO@casper.infradead.org>
 <20221031070853.GL3600936@dread.disaster.area>
 <Y1+jBDLHovtsXbyF@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1+jBDLHovtsXbyF@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2022 at 10:27:16AM +0000, Matthew Wilcox wrote:
> > Byte range granularity is probably overkill for block based
> > filesystems - all we need is a couple of extra bits per block to be
> > stored in the mapping tree alongside the folio....
> 
> I think it's overkill for network filesystems too.  By sending a
> sector-misaligned write to the server, you force the server to do a R-M-W
> before it commits the write to storage.  Assuming that the file has fallen
> out of the server's cache, and a sufficiently busy server probably doesn't
> have the memory capacity for the working set of all of its clients.

That really depends on your server.  For NFS there's definitively
servers that can deal with unaligned writes fairly well because they
just log the data in non volatile memory.  That being said I'm not sure
it really is worth to optimize the Linux pagecache for that particular
use case.

> Anyway, Dave's plan for dirty tracking (as I understand the current
> iteration) is to not store it linked from folio->private at all, but to
> store it in a per-file tree of writes.  Then we wouldn't walk the page
> cache looking for dirty folios, but walk the tree of writes choosing
> which ones to write back and delete from the tree.  I don't know how
> this will perform in practice, but it'll be generic enough to work for
> any filesystem.

Yes, this would be generic.  But having multiple tracking trees might
not be super optimal - it always reminds me of the btrfs I/O code that
is lost in a maze of trees and performs rather suboptimal.
