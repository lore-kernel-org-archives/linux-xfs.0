Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F86CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 06:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjJQGBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 02:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbjJQGBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 02:01:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C221A2;
        Mon, 16 Oct 2023 23:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4bEHl2/EkI0ra4f4Wh8/YbcmlifE4mAAH5TzvuP3FPs=; b=rZpBase/H9lCbb7wClp5H+3hqK
        svNmCn/GuNUzHIhElX68yOPUxts5EB4vtiYchsy7PJR04VNYXr0DAIipgVNwWx/rejJ1oFW/KQ513
        e3gFgJNVzQhDJ4irHVzV/0JS+kPq+EEy1L16Bs++d02yXGM01EwFP4nCoMBMYEtkPJ9gAWn5tVfEO
        88RRvfVfLR8xICaUHj+7V+9YVphPsmLAOi5NPTGcM9MwCqqaoT78WBhHofPSYnX12zCHbWlKfoaap
        ECpWX8e+7ksNEFGamQMrVHIL3XUA8v5hr9umGTlA8p4WnUh6/lHW3kvEusLg2vYKgLKZEWQssGSnr
        mBcAjUEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsd8h-00BLVN-28;
        Tue, 17 Oct 2023 06:01:11 +0000
Date:   Mon, 16 Oct 2023 23:01:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Andrey Albershteyn <aalbersh@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, david@fromorbit.com, dchinner@redhat.com
Subject: Re: [PATCH v3 07/28] fsverity: always use bitmap to track verified
 status
Message-ID: <ZS4jJ/3VxSoEVYxl@infradead.org>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-8-aalbersh@redhat.com>
 <20231011031543.GB1185@sol.localdomain>
 <q75t2etmyq2zjskkquikatp4yg7k2yoyt4oab4grhlg7yu4wyi@6eax4ysvavyk>
 <20231012072746.GA2100@sol.localdomain>
 <20231013031209.GS21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013031209.GS21298@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 08:12:09PM -0700, Darrick J. Wong wrote:
> I frankly have been asking myself why /this/ patchset adds so much extra
> code and flags and whatnot to XFS and fs/verity.  From what I can tell,
> the xfs buffer cache has been extended to allocate double the memory so
> that xattr contents can be shadowed.  getxattr for merkle tree contents
> then pins the buffer, shadows the contents, and hands both back to the
> caller (aka xfs_read_merkle_tree_block).   The shadow memory is then
> handed to fs/verity to do its magic; following that, fsverity releases
> the reference and we can eventually drop the xfs_buf reference.
> 
> But this seems way overcomplicated to me.  ->read_merkle_tree_page hands
> us a pgoff_t and a suggestion for page readahead, and wants us to return
> an uptodate locked page, right?

It does.  That beeing said I really much prefer the block based
interface from Andrey.  It is a lot cleaner and without weird page
cache internals, although it can still be implemented very nicely
by file systems that store the tree in the page cache.

> The only thing I can't quite figure out is how to get memory reclaim to
> scan the extra address_space when it wants to try to reclaim pages.
> That part ext4 and f2fs got for free because they stuffed the merkle
> tree in the posteof space.

Except for th magic swapper_spaces, and address_space without an
inode is not a thing, so you need to allocate an extra inode anyway,
which is what reclaim works on.

