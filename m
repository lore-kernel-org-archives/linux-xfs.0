Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D02CDB474
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 16:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjJPQK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 12:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbjJPQKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 12:10:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B4F0
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 09:10:23 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 26EC768B05; Mon, 16 Oct 2023 18:10:20 +0200 (CEST)
Date:   Mon, 16 Oct 2023 18:10:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: only remap the written blocks in
 xfs_reflink_end_cow_extent
Message-ID: <20231016161019.GA8089@lst.de>
References: <20231016152852.1021679-1-hch@lst.de> <20231016154827.GC11402@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016154827.GC11402@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 08:48:27AM -0700, Darrick J. Wong wrote:
> Hmm.  xfs_prepare_ioend converts unwritten cowfork extents to written
> prior to submit_bio.  So I guess you'd have to trick writeback into
> issuing totally separate bios for the single mapping.

Yes.  Hitting IOEND_BATCH_SIZE seems like the least difficult one
to hit, but even that would require work.

> Then you'd have
> to delay the bio for the higher offset part of the mapping while
> allowing the bio for the lower part to complete, at which point it would
> convey the entire mapping to the data fork.

Shouldn't really matter which side is faster.

> Then you'd have to convince
> the kernel to reread the contents from disk.  I think that would be hard
> since the folios for the incomplete writeback are still uptodate and
> marked for writeback.  directio will block trying to flush and
> invalidate the cache, and buffered io will read the pagecache.

I don't think on a live kernel it is possible.  But if one of the
two bios completed before the other one, and power failed just inbetween.
