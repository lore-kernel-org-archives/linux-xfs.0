Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DEB7E728CA
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 17:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjI2R3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 13:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjI2R3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 13:29:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C241B0;
        Fri, 29 Sep 2023 10:27:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1BFC433C8;
        Fri, 29 Sep 2023 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696008437;
        bh=35N55BDhmAWN17ijS2nNlMHKq/WXJG+pPd+OBo72eDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtKNUS8vr2Pzpm02rW9RE0e1nk+wxR+UmTGF9WQZmkQrd4MVlgFlysSes2206J8PY
         6vPlpD4LtRi8whNzWyqs+we6q8q5rCFkGkdCImCz36mq5b0dzxLPV33jdzEwcNdsMi
         OgDfbXcKWe4i49sJMCzweA6Rw08foRASYZZfxQ4Knt/ZyR8LTUrpVkyRTY8oIL037F
         wbWxyoEi4xR5pbnI01s47hjwKNEhqycV1cGioN8VexNN88pIMfG8imz+tI4dSOPITA
         ZLxC2nVw/vizuOEBBzDwAlX8Xc4IowTTTJqgpB8qOamkpGZEWhGJDztb7UWhYveJ0L
         X5OraSErdOSQw==
Date:   Fri, 29 Sep 2023 10:27:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/270: update commit id for _fixed_by tag.
Message-ID: <20230929172716.GA21283@frogsfrogsfrogs>
References: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
 <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
 <20230929052259.7umlz236g3o4su6r@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230929052259.7umlz236g3o4su6r@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 29, 2023 at 01:22:59PM +0800, Zorro Lang wrote:
> On Mon, Sep 25, 2023 at 02:42:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Update the commit id in the _fixed_by tag now that we've merged the
> > kernel fix.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/270 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/xfs/270 b/tests/xfs/270
> > index 7d4e1f6a87..4e4f767dc1 100755
> > --- a/tests/xfs/270
> > +++ b/tests/xfs/270
> > @@ -17,7 +17,7 @@ _begin_fstest auto quick mount
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > -_fixed_by_kernel_commit xxxxxxxxxxxx \
> > +_fixed_by_kernel_commit 74ad4693b647 \
> >  	"xfs: fix log recovery when unknown rocompat bits are set"
> 
> This patch is good to me, but we have more xfs cases have fixed commit which
> have been merged:
> 
> $ grep -rsni xxxxxxxx tests/xfs|grep _fixed
> tests/xfs/600:23:_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> tests/xfs/557:21:_fixed_by_kernel_commit XXXXXXXXXXXX \
> tests/xfs/270:20:_fixed_by_kernel_commit xxxxxxxxxxxx \
> 
> xfs/600: cfa2df68b7ce xfs: fix an agbno overflow in __xfs_getfsmap_datadev
> xfs/557: 817644fa4525 xfs: get root inode correctly at bulkstat
> 
> Do you want to fix them in one patch, or you hope to merge this
> patch at first?

Eh, I'll just resubmit with all three.

--D

> Thanks,
> Zorro
> 
> 
> >  # skip fs check because superblock contains unknown ro-compat features
> >  _require_scratch_nocheck
> > 
> 
