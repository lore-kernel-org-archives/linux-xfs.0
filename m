Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F6EC7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 14:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbjFBO3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jun 2023 10:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbjFBO3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 10:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EB7E53;
        Fri,  2 Jun 2023 07:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79BCD650B6;
        Fri,  2 Jun 2023 14:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44C8C433EF;
        Fri,  2 Jun 2023 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685716140;
        bh=ES8txbIpagFzONut7b9zDqG32fUYuXf0LLE1yj28c6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=huJ1t26v/bmYDIIW2KYAlMgqoUPoMiTi4AXB3m2CYW7RFCOXu3zo7rWT1KdT8CIEb
         fYg5I8v2h2HYLrrqW+ED0lKu9tF57NCZcUM1BqvI9mfkQRky+SPD9jvmyHL/gypHD8
         xcb/NPKuc8Z1HxQT/eHDIWsyYQvonRBk7DFrdffbRT2hXSPZWH9EAXczka4i9ScluU
         bPw6BtIR6Yk/qpwiA9D6uuAjuD/vrGRVYWjqAD7ZwMXFU6L33SPV8sruwwmLn+6ukw
         UOeV/cRZS3/tQOylEfJSXvQpKhnGv0+H2rTcnbXjlhrWQEVsVq/vgfDhbe3o/JKN0O
         2Riv1VPnjdOZA==
Date:   Fri, 2 Jun 2023 07:29:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs/018: disable parent pointers for this test
Message-ID: <20230602142900.GC16891@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
 <168506060929.3732476.6482579916222371853.stgit@frogsfrogsfrogs>
 <20230526200134.cnhlqop277ntyyah@zlang-mailbox>
 <20230602010645.GB16891@frogsfrogsfrogs>
 <20230602102744.3wxbayhfwknvnqbm@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602102744.3wxbayhfwknvnqbm@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2023 at 06:27:44PM +0800, Zorro Lang wrote:
> On Thu, Jun 01, 2023 at 06:06:45PM -0700, Darrick J. Wong wrote:
> > On Sat, May 27, 2023 at 04:01:34AM +0800, Zorro Lang wrote:
> > > On Thu, May 25, 2023 at 07:03:39PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This test depends heavily on the xattr formats created for new files.
> > > > Parent pointers break those assumptions, so force parent pointers off.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/018 |    7 ++++++-
> > > >  tests/xfs/191 |    7 ++++++-
> > > >  tests/xfs/288 |    7 ++++++-
> > > >  3 files changed, 18 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/018 b/tests/xfs/018
> > > > index 1ef51a2e61..34b6e91579 100755
> > > > --- a/tests/xfs/018
> > > > +++ b/tests/xfs/018
> > > > @@ -100,7 +100,12 @@ attr32l="X$attr32k"
> > > >  attr64k="$attr32k$attr32k"
> > > >  
> > > >  echo "*** mkfs"
> > > > -_scratch_mkfs >/dev/null
> > > > +
> > > > +# Parent pointers change the xattr formats sufficiently to break this test.
> > > > +# Disable parent pointers if mkfs supports it.
> > > > +mkfs_args=()
> > > > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> > > 
> > > Maybe we need a _require_no_xfs_parent() ?
> > 
> > We still want to run the test, we just don't want parent pointer
> > xattrs muddying up the golden output.
> 
> But if there's a specified MKFS_OPTIONS="... -n parent=1", this change will cause
> the whole test fails, right?

Ahaha, thank you for pointing that out.  Yes, this should change
parent=X to parent=0 if it's specified, or add parent=0 if not.

--D

> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +_scratch_mkfs "${mkfs_args[@]}" >/dev/null
> > > >  
> > > >  blk_sz=$(_scratch_xfs_get_sb_field blocksize)
> > > >  err_inj_attr_sz=$(( blk_sz / 3 - 50 ))
> > > > diff --git a/tests/xfs/191 b/tests/xfs/191
> > > > index 7a02f1be21..0a6c20dad7 100755
> > > > --- a/tests/xfs/191
> > > > +++ b/tests/xfs/191
> > > > @@ -33,7 +33,12 @@ _fixed_by_kernel_commit 7be3bd8856fb "xfs: empty xattr leaf header blocks are no
> > > >  _fixed_by_kernel_commit e87021a2bc10 "xfs: use larger in-core attr firstused field and detect overflow"
> > > >  _fixed_by_git_commit xfsprogs f50d3462c654 "xfs_repair: ignore empty xattr leaf blocks"
> > > >  
> > > > -_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > > +# Parent pointers change the xattr formats sufficiently to break this test.
> > > > +# Disable parent pointers if mkfs supports it.
> > > > +mkfs_args=()
> > > > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> > > > +
> > > > +_scratch_mkfs_xfs "${mkfs_args[@]}" | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > >  cat $tmp.mkfs >> $seqres.full
> > > >  source $tmp.mkfs
> > > >  _scratch_mount
> > > > diff --git a/tests/xfs/288 b/tests/xfs/288
> > > > index aa664a266e..6bfc9ac0c8 100755
> > > > --- a/tests/xfs/288
> > > > +++ b/tests/xfs/288
> > > > @@ -19,8 +19,13 @@ _supported_fs xfs
> > > >  _require_scratch
> > > >  _require_attrs
> > > >  
> > > > +# Parent pointers change the xattr formats sufficiently to break this test.
> > > > +# Disable parent pointers if mkfs supports it.
> > > > +mkfs_args=()
> > > > +$MKFS_XFS_PROG 2>&1 | grep -q parent=0 && mkfs_args+=(-n parent=0)
> > > > +
> > > >  # get block size ($dbsize) from the mkfs output
> > > > -_scratch_mkfs_xfs 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > > > +_scratch_mkfs_xfs "${mkfs_args[@]}" 2>/dev/null | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > > >  . $tmp.mkfs
> > > >  
> > > >  _scratch_mount
> > > > 
> > > 
> > 
> 
