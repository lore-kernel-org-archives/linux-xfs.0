Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84ECCD68F9
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Oct 2023 07:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442670AbjJJH7v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442695AbjJJH7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 03:59:50 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D83B4
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 00:59:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6337768B05; Tue, 10 Oct 2023 09:59:45 +0200 (CEST)
Date:   Tue, 10 Oct 2023 09:59:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: handle nimaps=0 from xfs_bmapi_write in
 xfs_alloc_file_space
Message-ID: <20231010075945.GA9884@lst.de>
References: <20231009103020.230639-1-hch@lst.de> <20231009103020.230639-2-hch@lst.de> <20231009162756.GB21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009162756.GB21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2023 at 09:27:56AM -0700, Darrick J. Wong wrote:
> > +		/*
> > +		 * If xfs_bmapi_write finds a delalloc extent at the requested
> > +		 * range, it tries to convert the entire delalloc extent to a
> > +		 * real allocation.
> > +		 * But if the allocator then can't find an AG with enough space
> > +		 * to at least cover the start block of the requested range,
> 
> Hmm.  Given that you said this was done in the context of delalloc on
> the realtime volume, I don't think there are AGs in play here?  Unless
> the AG actually ran out of space allocating a bmbt block?

Well, really rt group as it was using your rt group patches.  Just
using AG as the more generalized case here.

> My hunch here is that free space on the rt volume is fragmented, but
> there were still enough free rtextents to create a large delalloc
> reservation.  Conversion of the reservation to an unwritten extent
> managed to map one free rtextent into the file, but not enough to
> convert the file mapping all the way to @startoffset_fsb.  Hence the
> bmapi_write call succeeds, but returns @nmaps == 0.

Yes.

> If that's true, I suggest changing the second sentence of the comment to
> read:
> 
> "If the allocator cannot find a single free extent large enough to
> cover the start block of the requested range, xfs_bmapi_write will
> return 0 but leave *nimaps set to 0."

That's probably better indeed.  I'll wait a bit for more comment
and will resend with that update.
