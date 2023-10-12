Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B4ECDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 17:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347346AbjJLRk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbjJLRk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 13:40:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3511FC9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:40:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA295C433C7;
        Thu, 12 Oct 2023 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697132425;
        bh=VwdbO8v1cxrDqOUrcCAOaFW9M8KpvXmbEXzoAAukSCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MU6zOodvqjwQhJ3wFiVnzhpKKZz65c1DdZ+Cayt41tdfhP8fzamSVbfwyiDy8M9wF
         ovOwIqGvAPPoPFXiLnG2HFrupsPXeTZqz51D09rA2I5zEs068R3IdEEGIFlJUDyRAY
         ahnCeoLboBpBkM167RL4N1x+C95FLH7k8SDEf3xTxB1FxJv2/+iHYaoYQ3knYvpwju
         WpXLdgQevaW2TzCB+x50Vzd8Ph20sZ+ZE69svHOnitleD6uDImHmJHH13zGOmpINdD
         e0y5C6CgsD01gkYzjBZ076TIvvbXWXzOb9aK5fzvLxkCDXDWGaAtieN740XRWLCwCg
         UjzTtuVwAATbA==
Date:   Thu, 12 Oct 2023 10:40:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 2/7] xfs: create a helper to compute leftovers of
 realtime extents
Message-ID: <20231012174025.GH21298@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721209.1773611.10988808692731283385.stgit@frogsfrogsfrogs>
 <20231012051140.GB2184@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012051140.GB2184@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:11:40AM +0200, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > index 3e07e7c6a5d53..29f1aa290ce6d 100644
> > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > @@ -14,6 +14,7 @@
> >  #include "xfs_trans.h"
> >  #include "xfs_trans_priv.h"
> >  #include "xfs_inode_item.h"
> > +#include "xfs_rtbitmap.h"
> >  
> >  #include <linux/iversion.h>
> >  
> 
> This seems to just have slipped in here?

Oops, good catch.  I'll remove that.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
