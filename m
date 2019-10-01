Return-Path: <SRS0=aFxQ=X2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E58C388F3
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C82B215EA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Oct 2019 06:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfJAG0K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 02:26:10 -0400
Received: from verein.lst.de ([213.95.11.211]:42661 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfJAG0K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Oct 2019 02:26:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2EC1168B20; Tue,  1 Oct 2019 08:26:07 +0200 (CEST)
Date:   Tue, 1 Oct 2019 08:26:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/19] xfs: fill out the srcmap in iomap_begin
Message-ID: <20191001062605.GA3596@lst.de>
References: <20190909182722.16783-1-hch@lst.de> <20190909182722.16783-13-hch@lst.de> <20190918175228.GE2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918175228.GE2229799@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:52:28AM -0700, Darrick J. Wong wrote:
> TBH I've been wondering for a while now if it would make more sense to
> do this in iomap_apply (and the open-coded versions in dax.c):
> 
> 	struct iomap srcmap = { .type = IOMAP_HOLE };
> 
> in the iomap_apply function (and change the "if (!srcmap.type)" checks
> to "if (srcmap.type != IOMAP_HOLE)").  That would get rid of the weird
> situation where iomap.h doesn't define an iomap type name corresponding
> to 0 but clearly it has some special meaning because the iomap code
> changes behavior based on that.
> 
> It also strikes me as weird that for the @imap parameter, type == 0
> would be considered a coding error but for @srcmap, we use type == 0 to
> mean "no mapping" but we don't do that for @srcmap.type == IOMAP_HOLE.
> 
> I mention that because, if some ->iomap_begin function returns
> IOMAP_HOLE then iomap_apply will pass the (hole) srcmap as the second
> parameter to the ->actor function.  When that happens, iomap_write_begin
> call will try to fill in the rest of the page from @srcmap (which is
> hole), not the @iomap (which might not be a hole) which seems wrong.

I've renumber IOMAP_HOLE and initialized all the maps to it, that seems
like a nice improvement.

> As for this function, if we made the above change, then the conditional
> becomes unneccessary -- we know this is a COW write, so we call
> xfs_bmbt_to_iomap on both mappings and exit.  No need for special
> casing.

OTOH I can't really agree to this.  We now do pointless extra work
for a common case, which also seems a little confusing.  It also goes
again the future direction where at least for some cases I want to
avoid the imap lookup entirely if we don't need it.
