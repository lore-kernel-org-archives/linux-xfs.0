Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F9AC77B61
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 17:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDXRpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 13:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXRpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 13:45:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A58E9
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 10:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C44B161DB1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 17:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23745C433EF;
        Mon, 24 Apr 2023 17:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682358332;
        bh=7opfxS5qLChjhqSFEN6nsDKPFl7x1uDAnD/GpRstSdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkY6TW7madmFk2+I4oFvQRPJok/64fWFEe9svH2G9nCYH4wbIs7nmsEwunWR8A6wy
         UTOKFF7C2yUhE7sF9C1wrkk0xCC6iCFZvWCfWaxL++JFMIwyWkTQrL7ymMLbmrXWfk
         7Y3DFKgXNmftxc0z76cNSEvkc3mHzylAWwPE0zsi/VeGAQY7Cr6fv/C3ye9OwAgSgu
         Rmq+gWUoUixd0LrpVCK0setRVI6W+FFro+lgQZpKa4c8HsdqyqZO3Tu69dAVIBJDGr
         BovFkz+ChEreUkh3N3YOsOZSEYalrzHua78J3FAbmTWIKJUypJFa6Z8QKWljl47Aaa
         ScbP6Z7jnQYtw==
Date:   Mon, 24 Apr 2023 10:45:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsdump: for-next updated to c3a72aa
Message-ID: <20230424174531.GP360889@frogsfrogsfrogs>
References: <20230424104756.naou6t6uig4wt6wj@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424104756.naou6t6uig4wt6wj@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 24, 2023 at 12:47:56PM +0200, Carlos Maiolino wrote:
> Hello.
> 
> The xfsdump for-next branch, located at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/?h=for-next
> 
> Has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed on
> the list and not included in this update, please let me know.

Why does for-next diverge from master?

$ git log --oneline master | head -n15
acb8083 xfsdump: Release 3.1.12
aaaa57f xfsrestore: untangle inventory unpacking logic
7b843fd xfsdump: fix on-media inventory stream packing
6503407 xfsrestore: fix on-media inventory stream unpacking
06dd184 xfsrestore: fix on-media inventory media unpacking
8b6bbcf xfsdump: Release 3.1.11

$ git log --oneline for-next | head -n15
c3a72aa xfsrestore: fix rootdir due to xfsdump bulkstat misuse
aaaa57f xfsrestore: untangle inventory unpacking logic
7b843fd xfsdump: fix on-media inventory stream packing
6503407 xfsrestore: fix on-media inventory stream unpacking
06dd184 xfsrestore: fix on-media inventory media unpacking
8b6bbcf xfsdump: Release 3.1.11

aaaa57f -> c3a72aa (for-next)
   \-----> acb8083 (master)

--D

> 
> The new head of the for-next branch is commit:
> 
> c3a72aabb22bb3a79ed0f09762e6d81c0cbdadd6
> 
> 1 new commits:
> 
> Gao Xiang (1):
>       [c3a72aa] xfsrestore: fix rootdir due to xfsdump bulkstat misuse
> 
> Code Diffstat:
> 
>  common/main.c         |  1 +
>  man/man8/xfsrestore.8 | 14 ++++++++++
>  restore/content.c     |  7 +++++
>  restore/getopt.h      |  4 +--
>  restore/tree.c        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  restore/tree.h        |  2 ++
>  6 files changed, 94 insertions(+), 6 deletions(-)
> 
> -- 
> Carlos Maiolino
