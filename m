Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6AAC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 17:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKURGU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 12:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiKURGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 12:06:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3714C902B
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 09:06:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5033061330
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 17:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF58DC4347C;
        Mon, 21 Nov 2022 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669050366;
        bh=rtRTNIcld02VXgKfMy3vwGL7aMLcbsbn5PRfFfdtUK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BDs3UCH8Ms7SpGg3eT6Gw9sIqwsta2tYB4R+KOcsSX5E5F80DUjwodlHMsJJrusvT
         j1pY/hGrIdUjQmgon6atl23SUdJOaJtKJLP4OSmmT7/LLvHevSIa+oLaR8ZpTifUz8
         cbNqI66tza6yJkCZPsOWR1SqrRn+xKfPukDpZVnVQSYRZ5e7b+7FGSMBQVEYfSyxYg
         QAYm/iSDMpuWHRElvrE+7rUlM0FX2CB+doeZ4QpD5UOEIgu0xvslV/86rhCAkggHDR
         jcIwnj0S5QUb5rynjj2UOaTCuB+zZP0HOID4X3XfCZkkq0Rzg6TBBw5RjdmA0WL/0u
         D8+puKFmyi75A==
Date:   Mon, 21 Nov 2022 09:06:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/7] xfsprogs: random fixes for 6.0
Message-ID: <Y3uv/mL79tbW/uir@magnolia>
References: <3bbCi5OklUNOpVog9KVqiGD2TPkUD4x6PJjtZuKJCzP-QYMXvnqh7kZB8Vnp2BnxW6jn-dlyN7DIFoDTnryqNw==@protonmail.internalid>
 <166795950005.3761353.14062544433865007925.stgit@magnolia>
 <20221118144615.o6l7v6cgehirk2n2@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118144615.o6l7v6cgehirk2n2@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 03:46:15PM +0100, Carlos Maiolino wrote:
> On Tue, Nov 08, 2022 at 06:05:00PM -0800, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is a rollup of all the random fixes I've collected for xfsprogs
> > 6.0.  At this point it's just an assorted collection, no particular
> > theme.  Many of them are leftovers from the last posting.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.0
> > ---
> >  db/btblock.c             |    2 +
> >  db/namei.c               |    2 +
> >  db/write.c               |    4 +-
> >  io/pread.c               |    2 +
> >  libfrog/linux.c          |    1 +
> >  libxfs/libxfs_api_defs.h |    2 +
> >  libxfs/libxfs_io.h       |    1 +
> >  libxfs/libxfs_priv.h     |    2 +
> >  libxfs/rdwr.c            |    8 +++++
> >  libxfs/util.c            |    1 +
> >  mkfs/xfs_mkfs.c          |    2 +
> >  repair/phase2.c          |    8 +++++
> >  repair/phase6.c          |    9 +++++
> >  repair/protos.h          |    1 +
> >  repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
> >  scrub/inodes.c           |    2 +
> >  16 files changed, 105 insertions(+), 19 deletions(-)
> > 
> 
> The whole series looks good. Will test
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Thank you!

--D

> -- 
> Carlos Maiolino
