Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B20DCDB465
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 00:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjJQA4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 20:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjJQA4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 20:56:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072492
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 17:56:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B36C433C8;
        Tue, 17 Oct 2023 00:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697504176;
        bh=U5maKyle5xDfp6mhqi3P1Q5afL5itL8QxZj9k9EXSRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IesvNSAV7qUS0JKTFZPeza2xE5aqK8NXTCicyOQUZuuiciaGUm+V/WDXDToIvI8kM
         is1a49f1gTSCTWHRIcA3ZKb/YU+tsZsnjT434P8EXO3mK6z4rvFndL/PQ0u8K6CXKN
         fuCKHXAI+ZeqXJ0nibKcbHLIk/+TvS1Y3xcxqU/q5VADBZnCs5E8bTklDrPrtOaokX
         3/shQZlfMA+JkZWxzg0b8T/DUdC7ZhP+XuhI4xIFvPODjWvuHGbBYZMEbHzR5LroMH
         H4j0OBfvVAsTl/2yhZzMkGQHi5nfPwpccdE+RKj9JqC/nzwl9EI0YgXS79QCkGuPW/
         3OXFfx70nC+qQ==
Date:   Mon, 16 Oct 2023 17:56:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: only remap the written blocks in
 xfs_reflink_end_cow_extent
Message-ID: <20231017005615.GA11424@frogsfrogsfrogs>
References: <20231016152852.1021679-1-hch@lst.de>
 <20231016154827.GC11402@frogsfrogsfrogs>
 <20231016161019.GA8089@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016161019.GA8089@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2023 at 06:10:19PM +0200, Christoph Hellwig wrote:
> On Mon, Oct 16, 2023 at 08:48:27AM -0700, Darrick J. Wong wrote:
> > Hmm.  xfs_prepare_ioend converts unwritten cowfork extents to written
> > prior to submit_bio.  So I guess you'd have to trick writeback into
> > issuing totally separate bios for the single mapping.
> 
> Yes.  Hitting IOEND_BATCH_SIZE seems like the least difficult one
> to hit, but even that would require work.
> 
> > Then you'd have
> > to delay the bio for the higher offset part of the mapping while
> > allowing the bio for the lower part to complete, at which point it would
> > convey the entire mapping to the data fork.
> 
> Shouldn't really matter which side is faster.
> 
> > Then you'd have to convince
> > the kernel to reread the contents from disk.  I think that would be hard
> > since the folios for the incomplete writeback are still uptodate and
> > marked for writeback.  directio will block trying to flush and
> > invalidate the cache, and buffered io will read the pagecache.
> 
> I don't think on a live kernel it is possible.  But if one of the
> two bios completed before the other one, and power failed just inbetween.

Ooooh, yeah.  That could happen if the ioend metadata update gets
written to the log device and the system crashes before that other bio
even gets a chance to execute.

--D
