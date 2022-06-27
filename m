Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6049EC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 03:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiF0Dq4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 23:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiF0Dqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 23:46:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C2E272C
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 20:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C24A7611AB
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 03:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DC2C341CA;
        Mon, 27 Jun 2022 03:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656301613;
        bh=wtcH5OfjEo/MtR0nQ5qdC9+P32VwhSjHhPdFd6moWho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FKvLSdlQnFU2BqNxfodTlZusSxp/JdhU+ZMIF4okvz0WwtlMsjm+NdlakOz67DAP4
         V5KFJxEIee+XCRbX6by1zFOzxkxilj9FOdaGW3h4DayWQwIzJdLbSHboEvsez1FhZE
         8NK0umpOxYtlwp/M2IY4kivJknKBNSX5+jNtgQHHoAbF4jbbrkZ3j8X6a5EdSzEDW9
         ZwDVh2Qx0IX4l8ibujhgL4yt6gw+leVBVtMDYWqxCQXpX3GE8ach42OdA8Z2qeIsDv
         GzU/9MIQM/Txo2/cs8dIT+6H5rIsHkCQMirIVfozvWBcBZ387tZPHygNATV53qx5i3
         oi3alXhPC2KkQ==
Date:   Sun, 26 Jun 2022 20:46:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: don't hold xattr leaf buffers across
 transaction rolls
Message-ID: <YrkoLNBbF4KEJIah@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628103862.4040423.16112028158389764844.stgit@magnolia>
 <20220627012355.GA227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627012355.GA227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 11:23:55AM +1000, Dave Chinner wrote:
> On Sun, Jun 26, 2022 at 03:03:58PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've established (again!) that empty xattr leaf buffers are
> > ok, we no longer need to bhold them to transactions when we're creating
> > new leaf blocks.  Get rid of the entire mechanism, which should simplify
> > the xattr code quite a bit.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Why?

The original justification for using bhold here was to prevent the AIL
from trying to write the empty leaf block into the fs during the brief
time that we release the buffer lock.  The reason for /that/ was to
prevent recovery from tripping over the empty ondisk block.

The bhold didn't totally solve that problem (hence removing the !count
check entirely 3 years later) but it /has/ made things sufficiently more
complicated that the resident expert (allison) and two maintainers (you
and I) tripped over the bheld leaf buffer handling...

> This code isn't there for correctness - it's just a way of
> avoiding needing to look up and lock the buffer immediately after we
> just created it and had a reference to it. This is a valid use of 
> xfs_trans_bhold(), so I'm not convinced that removing it makes the
> code better. Simpler, yes, but not necessarily better.

...so while I agree that this is a valid use of bhold, I also see that
the three people you'd most expect to wield the extra complexity have
not done it well, and decided to simplify the buffer usage back to a
more common use case in xfs.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
