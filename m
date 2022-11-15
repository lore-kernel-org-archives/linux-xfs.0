Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890AAC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 03:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiKODbO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiKODbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 22:31:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE7EBC33
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC660614FD
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 03:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C95C433C1;
        Tue, 15 Nov 2022 03:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668483072;
        bh=MaVE4EMFZt7Mos+YX/E4KYs+0luJaA311UrOa1kV7UI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhnAe0hF22Vf+Y4iZMwS+FALEkNmAQanfJMOn/9veZaRV5yjVfSM5mp1j8LiFRXH3
         up7aXPziNJD5+1ZNfY3kpAHedHJUDnfnHLrg0UwVaALfhuAMAs7xBWQv4IW7saYbOm
         XjNW0ci94p5A0QPJNkpk1VE/DPpY6xBZB/1Lb81j9sVomA4Kw468uZOTkwiVZI6qM/
         ojD4NIJ745dKe9D/zm1D7WrW5QObHC3kr2D7kuEuB9hnJulLtIBySie5Tgck1US4QH
         w8hxwF4vJC29BqrBtG4FbUbaD9yWlGgcMeEarR72dFbxwfYV6jiNKC1mlYdS/bNIsI
         CpjT8dq2E8nOA==
Date:   Mon, 14 Nov 2022 19:31:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: check inode core when scrubbing metadata files
Message-ID: <Y3MH/0RVdjj2HJ1k@magnolia>
References: <166473482605.1084588.1965700384229898125.stgit@magnolia>
 <166473482636.1084588.10974246607672500827.stgit@magnolia>
 <20221115025854.GV3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115025854.GV3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 15, 2022 at 01:58:54PM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:20:26AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Metadata files (e.g. realtime bitmaps and quota files) do not show up in
> > the bulkstat output, which means that scrub-by-handle does not work;
> > they can only be checked through a specific scrub type.  Therefore, each
> > scrub type calls xchk_metadata_inode_forks to check the metadata for
> > whatever's in the file.
> > 
> > Unfortunately, that function doesn't actually check the inode record
> > itself.  Refactor the function a bit to make that happen.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/common.c |   40 ++++++++++++++++++++++++++++++++++------
> >  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> Looks reasonable. Will there be more metadata inode types to scrub
> in future?

For the realtime modernisation project, I am planning to shard the rt
volume into allocation groups and give each rtgroup its own rmap and
refcount btree.

> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks for the review!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
