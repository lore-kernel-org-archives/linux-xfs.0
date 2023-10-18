Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA28CDB47E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Oct 2023 06:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjJRGIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Oct 2023 02:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjJRGIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 02:08:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC61F9
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=45B/cH94pJjyHnZNvDBzXoMf9oKgPsz2A0NO9w12KqM=; b=fY6Ka0EPmCFwEh1OJLhTRyOVzf
        crlOqmEYnlbmj5gMADpK6egedKXcqazKBPi5NjultQwh1YTGNnTGfB1lh+l+1Y8UritFHBtJTvpQe
        jYMvzjH2zoJm1kYdSHmcWqNUgrh5zHQom7cjHoFoU1hJ+y30ZIPJZ9yDMgXcdMxj9U3lJd0ghs6tP
        gIW6x6nETN3pgDUSoqTWLDge5woTNcEHQc5LJ/YM56r+qQV94nW6RJmzQLeYw5WlZZerhZYeExr0r
        x/T56sHxRQpXVk+JAP4yTh3KyQOPvkRuC/PnPJ7KVccqkKqef7eBtq86FMlvElmYPdWhHMBIKVgdQ
        JTP7rg3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qszj4-00DsMu-2I;
        Wed, 18 Oct 2023 06:08:14 +0000
Date:   Tue, 17 Oct 2023 23:08:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZS92TizgnKHdBtDb@infradead.org>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017201208.18127-1-catherine.hoang@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 17, 2023 at 01:12:08PM -0700, Catherine Hoang wrote:
> One of our VM cluster management products needs to snapshot KVM image
> files so that they can be restored in case of failure. Snapshotting is
> done by redirecting VM disk writes to a sidecar file and using reflink
> on the disk image, specifically the FICLONE ioctl as used by
> "cp --reflink". Reflink locks the source and destination files while it
> operates, which means that reads from the main vm disk image are blocked,
> causing the vm to stall. When an image file is heavily fragmented, the
> copy process could take several minutes. Some of the vm image files have
> 50-100 million extent records, and duplicating that much metadata locks
> the file for 30 minutes or more. Having activities suspended for such
> a long time in a cluster node could result in node eviction.
> 
> Clone operations and read IO do not change any data in the source file,
> so they should be able to run concurrently. Demote the exclusive locks
> taken by FICLONE to shared locks to allow reads while cloning. While a
> clone is in progress, writes will take the IOLOCK_EXCL, so they block
> until the clone completes.

Sorry for being pesky, but do you have some rough numbers on how
much this actually with the above workload?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
