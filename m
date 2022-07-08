Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8C4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Jul 2022 15:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbiGHPvC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 11:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiGHPvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 11:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F85967593
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 08:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFDBC613E9
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 15:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49039C341C0;
        Fri,  8 Jul 2022 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657295460;
        bh=8wc6aXFAg1cJIJUmlKMe4sNO6k1jvQleJDwswrN44P4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WlSxQf6/nhh6bomScduTekh9FAdHdccvJMW32NsH3eIK1d3QIuIjdJtrWviTjn/TK
         9vG+iR41ttAygXjQBgFTh/E1opOog0GrAkUZcZX+w+9aBIP4phGKlwFCaaxf2zP0e7
         uqjGxvcnoerGNaTsPlyZySf0hzi0uGCms8Ul75+gSNTmTegghMykusrcknbSiIoGsD
         fJPZs/C61XNLXg77mxPIDV3HM71V4dXGAiMf7GDBlNZ+/IdzAQ5skmsIQqaBNO5h9I
         pz2hI+wNQU5ACNBcwc287RzHbvOfSwUk3nOJr3b9c6i8eHVxRH8KRUJBfQX20jXk6z
         Bc350OSOlW9fw==
Date:   Fri, 8 Jul 2022 08:50:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.15 CANDIDATE 0/4] xfs stable candidates for 5.15.y
 (part 2)
Message-ID: <YshSY9sXGg9Ox1cM@magnolia>
References: <20220707223828.599185-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707223828.599185-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 03:38:24PM -0700, Leah Rumancik wrote:
> Hello again,
> 
> These are a subset of the patches from the v1 5.15 part 1 which are
> not applicable to 5.10.y. These patches were rebased and applied on top
> of the accepted part 1 patches. 100 runs of each test on mulitple configs
> were completed and no regressions found.
> 
> Additional testing:
> c8c568259772 "xfs: don't include bnobt blocks when reserving free block pool"
>     Observed the hang before the patches but not after

Yep, that's the correct outcome.

> 919edbadebe1 "xfs: drop async cache flushes from CIL commits."
>     Ran dbench as in the commit and confirmed performance improved
> 
> clients   before      after
> 1         220.493     260.359
> 8         732.807     1068.64
> 16        749.677     1293.06
> 32        737.9       1247.17
> 128       680.674     1077.0
> 512       602.674     884.48

Daaaaang. :)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D


> Thanks,
> Leah
> 
> 
> Darrick J. Wong (2):
>   xfs: only run COW extent recovery when there are no live extents
>   xfs: don't include bnobt blocks when reserving free block pool
> 
> Dave Chinner (2):
>   xfs: run callbacks before waking waiters in
>     xlog_state_shutdown_callbacks
>   xfs: drop async cache flushes from CIL commits.
> 
>  fs/xfs/xfs_bio_io.c      | 35 ------------------------
>  fs/xfs/xfs_fsops.c       |  2 +-
>  fs/xfs/xfs_linux.h       |  2 --
>  fs/xfs/xfs_log.c         | 58 +++++++++++++++++-----------------------
>  fs/xfs/xfs_log_cil.c     | 42 +++++++++--------------------
>  fs/xfs/xfs_log_priv.h    |  3 +--
>  fs/xfs/xfs_log_recover.c | 24 ++++++++++++++++-
>  fs/xfs/xfs_mount.c       | 12 +--------
>  fs/xfs/xfs_mount.h       | 15 +++++++++++
>  fs/xfs/xfs_reflink.c     |  5 +++-
>  fs/xfs/xfs_super.c       |  9 -------
>  11 files changed, 82 insertions(+), 125 deletions(-)
> 
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 
