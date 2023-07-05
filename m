Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE61BEB64DD
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 15:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjGEPh2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjGEPh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 11:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C3E10F5;
        Wed,  5 Jul 2023 08:37:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E44B615E7;
        Wed,  5 Jul 2023 15:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DB5C433C7;
        Wed,  5 Jul 2023 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688571446;
        bh=4vRe34qbwgiSMWBmSz4YLNkGXlx3w1EToV2myxbaEes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=caLr+oOn2/dhzyppwvax926WYIfCPldNCnTDnYAVWMyXMumz6eei6PR5CPqd3HJUO
         goclwt4ydE7GQ0GEgTemdaqmH8aqWN4hQQER0/YWZsH9V2fino2xQHoZZOR+wgydoj
         LEqM9Q70uJd37sI0fyxMKQjZSON0kJqls4PgL/ogEcPsqp03DO0d6b2Clq6Noqp7ha
         IB/T+ffEzYfhwCXkkvq235n0SPcC8wzl6wVTA9Q34yTmXaHVdIkCxCD9GxNmxSCoS8
         KvVmUx9XYnCh0t0EgDqAtCono4uS95126GzpR9Vwk+5h+hI5EsKEDq9us+WO1sk6Yz
         7asjvtSUYl4ug==
Date:   Wed, 5 Jul 2023 08:37:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs/439: amend test to work with new log geometry
 validation
Message-ID: <20230705153725.GR11441@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
 <20230705063709.4grbfaznsddnxf4c@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705063709.4grbfaznsddnxf4c@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 05, 2023 at 02:37:09PM +0800, Zorro Lang wrote:
> On Mon, Jul 03, 2023 at 10:03:50AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > An upcoming patch moves more log validation checks to the superblock
> > verifier, so update this test as needed.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/439 |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/439 b/tests/xfs/439
> > index b7929493d1..8c69ece655 100755
> > --- a/tests/xfs/439
> > +++ b/tests/xfs/439
> > @@ -21,7 +21,9 @@ _begin_fstest auto quick fuzzers log
> >  _supported_fs xfs
> >  _require_scratch_nocheck
> >  # We corrupt XFS on purpose, and check if assert failures would crash system.
> > -_require_no_xfs_bug_on_assert
> > +# This used to be _require_no_xfs_bug_on_assert, but now we've fixed the sb
> > +# verifier to reject this before xfs_log_mount gets to it:
> > +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: journal geometry is not properly bounds checked"
> 
> This case is a regression test case for:
>   9c92ee2 ("xfs: validate sb_logsunit is a multiple of the fs blocksize")
> 
> So I think it's better to write this major commit at first, before recording the
> secondary one.

Ok.  I guess that's a result of this test predating _fixed_by.

Also I'll update this with the real kernel commit id, now that there is
one.

> >  
> >  rm -f "$seqres.full"
> >  
> > @@ -33,7 +35,7 @@ blksz=$(_scratch_xfs_get_sb_field blocksize)
> >  _scratch_xfs_set_sb_field logsunit $((blksz - 1)) >> $seqres.full 2>&1
> >  
> >  # Check if logsunit is set correctly
> > -lsunit=$(_scratch_xfs_get_sb_field logsunit)
> > +lsunit=$(_scratch_xfs_get_sb_field logsunit 2>/dev/null)
> 
> What kind of error should be ignored at here?

The same new logsunit validation code, when ported to userspace, causes
xfs_db to emit verifier complaints that disturb the golden output.

--D

> 
> >  [ $lsunit -ne $((blksz - 1)) ] && _notrun "failed to set sb_logsunit"
> >  
> >  # Mount and writing log may trigger a crash on buggy kernel
> > 
> 
