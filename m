Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C98C7EE23
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Jun 2023 17:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjFDR41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jun 2023 13:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjFDR40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jun 2023 13:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE40BC
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 10:56:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E0560AD9
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 17:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74857C433EF;
        Sun,  4 Jun 2023 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685901384;
        bh=IjfMbSM2CrF0Tk2F0QhJ0gsC3mIOc1Z05TV2jcmIggU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=PkV5QSKqXYjh3aQmg1gi2JysvSdEQ4ka9f5mQu5C6L4prRUJtF2BEyYhiEihedWHz
         QRyH6Xb3TxRYnYXzQnhhpbYGd6Z8v7sqJNQlB2pqAbu0n6MZVza1zJa3F7VbcxCTjg
         9wM9gd3dJt8R99HV6Q6Calf5FP7KBUVfz2ccfx6O9rBGK8NwDvJ/cvlmF+51X39x5J
         VnzQrMUFrI2h+LhCGUqlZzoMnsLVWprnGoG+tW7smsKYCj/TgzEJTzBjmnbm9ZrQqW
         Gs7e1E4qOMKIADWxh59dQ2tQHnbm5KuLb8UHomz2pidyo0pMGUIfUxZ3b/9Rq6lSCe
         vDw4kElroUykg==
Date:   Sun, 4 Jun 2023 10:56:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHSET 0/7] xfs: fix ranged queries and integer overflows in
 GETFSMAP
Message-ID: <20230604175623.GB72241@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ping?  Even if it's too late for 6.5, can we at least get this bug fix
series reviewed?

--D

On Thu, May 25, 2023 at 05:28:08PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> As part of merging the parent pointers patchset into my development
> branch, I noticed a few problems with the GETFSMAP implementation for
> XFS.  The biggest problem is that ranged queries don't work properly if
> the query interval is exactly within a single record.  It turns out that
> I didn't implement the record filtering quite right -- for the first
> call into the btree code, we want to find any rmap that overlaps with
> the range specified, but for subsequent calls, we only want rmaps that
> come after the low key of the query.  This can be fixed by tweaking the
> filtering logic and pushing the key handling into the individual backend
> implementations.
> 
> The second problem I noticed is that there are integer overflows in the
> rtbitmap and external log handlers.  This is the result of a poor
> decision on my part to use the incore rmap records for storing the query
> ranges; this only works for the rmap code, which is smart enough to
> iterate AGs.  This breaks down spectacularly if someone tries to query
> high block offsets in either the rt volume or the log device.  I fixed
> that by introducing a second filtering implementation based entirely on
> daddrs.
> 
> The third problem was minor by comparison -- the rt volume cannot ever
> use rtblocks beyond the end of the last rtextent, so it makes no sense
> for GETFSMAP to try to query those areas.
> 
> Having done that, add a few more patches to clean up some messes.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=getfsmap-fixes
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |   10 --
>  fs/xfs/libxfs/xfs_refcount.c |   13 +-
>  fs/xfs/libxfs/xfs_rmap.c     |   10 --
>  fs/xfs/xfs_fsmap.c           |  261 ++++++++++++++++++++++--------------------
>  fs/xfs/xfs_trace.h           |   25 ++++
>  5 files changed, 177 insertions(+), 142 deletions(-)
> 
