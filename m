Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54974C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 01:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjFBBGt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 21:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbjFBBGs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 21:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A93128;
        Thu,  1 Jun 2023 18:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D89648E4;
        Fri,  2 Jun 2023 01:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEADC433D2;
        Fri,  2 Jun 2023 01:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685668006;
        bh=R6hu5sSe9uIICVjhrJAkig4BGtWlisQGvp77OL63ZLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n1RGNj8zNwsINoo9B0+o2JOierG3+nNEmGApm0yXcqqtuEQ+HYZKetlRRiKaQd55F
         QrW0R4zxla0vYibAYfP/rAOHGb7bXoVlvIq23PnxH8TzA+B6Br8V5P19eoozaYSRQe
         wiNcOOI0ytFELWBNCe4O6QXljVN67pYxRgpRCv6x4VtLj82mgjjoj2pgxYrypfkxYQ
         2W5oMfu5TVn3wNFwB8RFFdiCtAG1rcStnvzgcL2JcWyDjz1uObBriM+j0Hgj2vJjA5
         NcYX3ZBGCZ+JqIGbQxzNGFDa7bWB3+eD9/+wLyVCN7qnfGNBMXzfiLUW4QxhCOQ3yo
         LMBz1JdZqmj2w==
Date:   Thu, 1 Jun 2023 18:06:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs/018: disable parent pointers for this test
Message-ID: <20230602010645.GB16891@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
 <168506060929.3732476.6482579916222371853.stgit@frogsfrogsfrogs>
 <20230526200134.cnhlqop277ntyyah@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526200134.cnhlqop277ntyyah@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 27, 2023 at 04:01:34AM +0800, Zorro Lang wrote:
> On Thu, May 25, 2023 at 07:03:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This test depends heavily on the xattr formats created for new files.
> > Parent pointers break those assumptions, so force parent pointers off.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/018 |    7 ++++++-
> >  tests/xfs/191 |    7 ++++++-
> >  tests/xfs/288 |    7 ++++++-
> >  3 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/018 b/tests/xfs/018
> > index 1ef51a2e61..34b6e91579 100755
> > --- a/tests/xfs/018
> > +++ b/tests/xfs/018
> > @@ -100,7 +100,12 @@ attr32l="X$attr32k"
> >  attr64k="$attr32k$attr32k"
> >  
> >  echo "*** mkfs"
> > -_scratch_mkfs >/dev/null
> > +
> > +# Parent pointers change the xattr formats sufficiently to break this test.
> > +# Disable parent pointers if mkfs supports it.
> > +mkfs_args=()
> > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> 
> Maybe we need a _require_no_xfs_parent() ?

We still want to run the test, we just don't want parent pointer
xattrs muddying up the golden output.

--D

> Thanks,
> Zorro
> 
> > +_scratch_mkfs "${mkfs_args[@]}" >/dev/null
> >  
> >  blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> >  err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
> > diff --git a/tests/xfs/191 b/tests/xfs/191
> > index 7a02f1be21..0a6c20dad7 100755
> > --- a/tests/xfs/191
> > +++ b/tests/xfs/191
> > @@ -33,7 +33,12 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
> >  _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
> >  _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
> >  
> > -_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > +# Parent pointers change the xattr formats sufficiently to break this test.
> > +# Disable parent pointers if mkfs supports it.
> > +mkfs_args=()
> > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> > +
> > +_scratch_mkfs_xfs "${mkfs_args[@]}" | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> >  cat $tmp.mkfs >> $seqres.full
> >  source $tmp.mkfs
> >  _scratch_mount
> > diff --git a/tests/xfs/288 b/tests/xfs/288
> > index aa664a266e..6bfc9ac0c8 100755
> > --- a/tests/xfs/288
> > +++ b/tests/xfs/288
> > @@ -19,8 +19,13 @@ _supported_fs xfs
> >  _require_scratch
> >  _require_attrs
> >  
> > +# Parent pointers change the xattr formats sufficiently to break this test.
> > +# Disable parent pointers if mkfs supports it.
> > +mkfs_args=()
> > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> > +
> >  # get block size ($dbsize) from the mkfs output
> > -_scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > +_scratch_mkfs_xfs "${mkfs_args[@]}" 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> >  . $tmp.mkfs
> >  
> >  _scratch_mount
> > 
> 
