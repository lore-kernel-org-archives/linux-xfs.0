Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C733C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiDSSlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbiDSSll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E73DA53;
        Tue, 19 Apr 2022 11:38:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EB1CB81846;
        Tue, 19 Apr 2022 18:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB81C385A5;
        Tue, 19 Apr 2022 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650393535;
        bh=hkJLXM6vUfKLGMhy/j5YbcQLWB+0to5Q5WQoC3QC6Pw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=kPguTdNA23DznVKMfio5cTcr5fSMp0oCJ266pTOUdGhFMlB0tVKM15d/y5YT/mSjG
         gfMlrvZK1Qouk/rfaIhap86PrzehRHrxPSCLJodluslvyFb/ph9kLwPYE1reMJ6Tb3
         ruUh4oWRmpMkOLVJogxMy9BAz0yVkHuGBYqjKZwip6jtBzUfzIWAMFDAAwXYobwh9Z
         UEQi3qiLlVhqhbkcFWwoNrkaSxXXt8cgCJ67Cr//ngGoMaKiKxg+US+aADGGxPI4Ay
         gqlA75HJot5ucf3VO78BFUnfd7fWORi7l3uV3oejWOpHXB1tojznOTxv3f7C8eHsmU
         DiLBqLI0m59bA==
Date:   Tue, 19 Apr 2022 11:38:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs/019: fix golden output for files created in
 setgid dir
Message-ID: <20220419183855.GO17025@magnolia>
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
 <165038952072.1677615.13209407698123810165.stgit@magnolia>
 <20220419183347.hruyn5zimz6tcxd4@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419183347.hruyn5zimz6tcxd4@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 02:33:47AM +0800, Zorro Lang wrote:
> On Tue, Apr 19, 2022 at 10:32:00AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A recent change to xfs/019 exposed a long-standing bug in mkfs where
> > it would always set the gid of a new child created in a setgid directory
> > to match the gid parent directory instead of what's in the protofile.
> > 
> > Ignoring the user's directions is not the correct behavior, so update
> > this test to reflect that.  Also don't erase the $seqres.full file,
> > because that makes forensic analysis pointlessly difficult.
> > 
> > Cc: Catherine Hoang <catherine.hoang@oracle.com>
> > Fixes: 7834a740 ("xfs/019: extend protofile test")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> After merge this patch, xfs/019 fails on my system. So this test will cover
> a new bug of xfsprogs which hasn't been fixed? If so, this change is good to me.
> But we'd better to take a look at the patch you used to fix xfsprogs, and make
> sure it's reviewed.

Yep.  Already reviewed, just waiting for xfsprogs 5.15.1:

https://lore.kernel.org/linux-xfs/B28D1D24-2E23-4F60-AA50-C199392BBE4F@oracle.com/T/#u

--D

> 
> Thanks,
> Zorro
> 
> >  tests/xfs/019     |    3 +--
> >  tests/xfs/019.out |    2 +-
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/019 b/tests/xfs/019
> > index 535b7af1..790a6821 100755
> > --- a/tests/xfs/019
> > +++ b/tests/xfs/019
> > @@ -10,6 +10,7 @@
> >  _begin_fstest mkfs auto quick
> >  
> >  seqfull="$seqres.full"
> > +rm -f $seqfull
> >  # Import common functions.
> >  . ./common/filter
> >  
> > @@ -97,7 +98,6 @@ _verify_fs()
> >  	echo "*** create FS version $1"
> >  	VERSION="-n version=$1"
> >  
> > -	rm -f $seqfull
> >  	_scratch_unmount >/dev/null 2>&1
> >  
> >  	_full "mkfs"
> > @@ -131,6 +131,5 @@ _verify_fs()
> >  _verify_fs 2
> >  
> >  echo "*** done"
> > -rm $seqfull
> >  status=0
> >  exit
> > diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> > index 8584f593..9db157f9 100644
> > --- a/tests/xfs/019.out
> > +++ b/tests/xfs/019.out
> > @@ -61,7 +61,7 @@ Device: <DEVICE> Inode: <INODE> Links: 2
> >  
> >   File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> >   Size: 5 Filetype: Regular File
> > - Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> >  Device: <DEVICE> Inode: <INODE> Links: 1 
> >  
> >   File: "./pipe"
> > 
> 
