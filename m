Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733F5C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 12:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjDLMKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 08:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjDLMKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 08:10:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E704619A
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2023 05:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5xQgDDarGjtF6Jbs9F4sDcJgLkHQI+rhSzQ7ZLbzbyM=; b=Ug6ZeEv2OkZNgKUF2d7uxa7OT7
        b3GRWEUl67Is2IpdzKzrT92Qq4JRo0aFqxGa4DFZzIFWjNQlEEJdX6YNky9OMj8jqLIGS0cAWXGjt
        9fITuDoHtlXYMhlySPHa0REtssiFIvYAM00hhuUOe8lcT8vQeeMfwGiqPq4Hg4LimWVdSoQQC9gui
        s7M6rNKGOIUyasZ9UrjF0b+4rvX9Yw/kw73QeOs0eeREubyKUCjc+YJMMfOuk2QYBwE5oa3xSWwxm
        HqTTaYSoWgVv4vG3OrwBHU9RJxjf55tbGixKZTXG1eJ8bjE+8w0V4QRDl9N/J3tR/AJqbnKglOlXH
        tLqEO3pw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmZIS-0032bm-08;
        Wed, 12 Apr 2023 12:09:56 +0000
Date:   Wed, 12 Apr 2023 05:09:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <ZDaflBeCxSMx/kJd@infradead.org>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
 <ZDTpBtMlSsxRJjRh@infradead.org>
 <20230411153546.GH360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411153546.GH360889@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 08:35:46AM -0700, Darrick J. Wong wrote:
> > obsfucate some names this really seems horribly ugly.  I could
> > come up with ideas to fix some of that, but they'd be fairly invasive.
> 
> Given that it's rol7 and xoring, I'd love it if someone came up with a
> gentler obfuscate_name() that at least tried to generate obfuscated
> names that weren't full of control characters and other junk that make
> ls output horrible.
> 
> Buuuut doing that requires a deep understanding of how the math works.
> I think I've almost grokked it, but applied math has never been my
> specialty.  Mark Adler's crc spoof looked promising if we ever follow
> through on Dave's suggestion to change the dahash to crc32c, but that's
> a whole different discussion.

Agreed on all counts.

> > Is there any reason we need to support obsfucatation for ascii-ci,
> > or could we just say we require "-o" to metadump ascii-ci file systems
> > and not deal with this at all given that it never actually worked?
> 
> That would be simpler for metadump, yes.
> 
> I'm going to introduce a followup series that adds a new xfs_db command
> to generate obfuscated filenames/attrs to exercise the dabtree hash
> collision resolution code.  I should probably do that now, since I
> already sent xfs/861 that uses it.
> 
> It wouldn't be the end of the world if hashcoll didn't work on asciici
> filesystems, but that /would/ be a testing gap.

Do we really care about that testing gap for a feature you just
deprecated and which has been pretty broken all this time?
