Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A7EC4167B
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Dec 2022 18:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiLVSit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Dec 2022 13:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbiLVSiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2022 13:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37521D320;
        Thu, 22 Dec 2022 10:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2549A61CEF;
        Thu, 22 Dec 2022 18:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E0EC433D2;
        Thu, 22 Dec 2022 18:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671734324;
        bh=+I0RJGn943uUpdjCptbK3wTmBwDrcMLyvzssPOj+nMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oiXN9yz14nPuEt3VT3e8oQauQB0ANCEO33l/ri+Qm61v7n9fBbMckYCZyCs7jS9Jr
         VweJ+xUpXAUVwlosMA7qLUm8eowy5G3vxSeM0STc2HIgYMZoehQJCw6QWeuwgi+iD5
         3UNRO086KbSyl8RTE+JxtaQjB9ZhobBn0FbtDnwBdO1EhyCCmRxSW8u5YgbNr9YIWw
         QjsXkjOGEv3S1FV5z8EuYyd8U+lljQcFoUakPUvuAi5ugsIeqkvIM0fSNoWp6kIFeW
         pdwT7G9RmLMPQcdIUZmWniQ/AxJCtLcvvERH0tDQfbfvHsF51tGqdlNN5OTDAtUw3b
         pJ05SJvLfRc+w==
Date:   Thu, 22 Dec 2022 10:38:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <Y6SkM9VPnDB+ens0@magnolia>
References: <167158209640.235360.13061162358544554094.stgit@magnolia>
 <167158210207.235360.12388823078640206103.stgit@magnolia>
 <20221222071900.dngksnsq374c5cdj@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222071900.dngksnsq374c5cdj@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 22, 2022 at 03:19:00PM +0800, Zorro Lang wrote:
> On Tue, Dec 20, 2022 at 04:21:42PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Adjust this test since made EFI/EFD log item format structs proper flex
> > arrays instead of array[1].
> > 
> > This adjustment was made to the kernel source tree as part of a project
> > to make the use of flex arrays more consistent throughout the kernel.
> > Converting array[1] and array[0] to array[] also avoids bugs in various
> > compiler ports that mishandle the array size computation.  Prior to the
> > introduction of xfs_ondisk.h, these miscomputations resulted in kernels
> > that would silently write out filesystem structures that would then not
> > be recognized by more mainstream systems (e.g.  x86).
> > 
> > OFC nearly all those reports about buggy compilers are for tiny
> > architectures that XFS doesn't work well on anyways, so in practice it
> > hasn't created any user problems (AFAIK).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> This version looks good to me, thanks for all these detailed information!
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> >  common/rc         |   15 +++++++++++++++
> >  tests/xfs/122     |    5 +++++
> >  tests/xfs/122.out |    8 ++++----
> >  3 files changed, 24 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 8060c03b7d..67bd74dc89 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -1502,6 +1502,21 @@ _fixed_by_kernel_commit()
> >  	_fixed_by_git_commit kernel $*
> >  }
> >  
> 
> I'd like to give some comments to the new _wants_* helpers when I merge
> it (don't need send a new version again: ), to help others know the
> different usage of _wants_* and _fixed_by_*. How about below comment:
> 
> # Compare with _fixed_by_* helpers, this helper is used for un-regression
> # test case, e.g. xfs/122. Or a case would like to mention a git commit
> # which is not a bug fix (maybe a default behavior/format change). Then
> # use this helpers.

How about:

"For test cases that are not regression tests, e.g. functional tests or
maintainer tests, this helper suggests git commits that should be
applied to source trees to avoid test failures."

--D

> 
> > +_wants_git_commit()
> > +{
> > +	local pkg=$1
> > +	shift
> > +
> > +	echo "This test wants $pkg fix:" >> $seqres.hints
> > +	echo "      $*" >> $seqres.hints
> > +	echo >> $seqres.hints
> > +}
> > +
> 
> # Refer to _wants_git_commit
> 
> Feel free to make it better :)
> 
> Thanks,
> Zorro
> 
> > +_wants_kernel_commit()
> > +{
> > +	_wants_git_commit kernel $*
> > +}
> > +
> >  _check_if_dev_already_mounted()
> >  {
> >  	local dev=$1
> > diff --git a/tests/xfs/122 b/tests/xfs/122
> > index 91083d6036..e616f1987d 100755
> > --- a/tests/xfs/122
> > +++ b/tests/xfs/122
> > @@ -17,6 +17,11 @@ _begin_fstest other auto quick clone realtime
> >  _supported_fs xfs
> >  _require_command "$INDENT_PROG" indent
> >  
> > +# Starting in Linux 6.1, the EFI log formats were adjusted away from using
> > +# single-element arrays as flex arrays.
> > +_wants_kernel_commit 03a7485cd701 \
> > +	"xfs: fix memcpy fortify errors in EFI log format copying"
> > +
> >  # filter out known changes to xfs type sizes
> >  _type_size_filter()
> >  {
> > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > index a56cbee84f..95e53c5081 100644
> > --- a/tests/xfs/122.out
> > +++ b/tests/xfs/122.out
> > @@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
> >  sizeof(xfs_dq_logformat_t) = 24
> >  sizeof(xfs_dqblk_t) = 136
> >  sizeof(xfs_dsb_t) = 264
> > -sizeof(xfs_efd_log_format_32_t) = 28
> > -sizeof(xfs_efd_log_format_64_t) = 32
> > -sizeof(xfs_efi_log_format_32_t) = 28
> > -sizeof(xfs_efi_log_format_64_t) = 32
> > +sizeof(xfs_efd_log_format_32_t) = 16
> > +sizeof(xfs_efd_log_format_64_t) = 16
> > +sizeof(xfs_efi_log_format_32_t) = 16
> > +sizeof(xfs_efi_log_format_64_t) = 16
> >  sizeof(xfs_error_injection_t) = 8
> >  sizeof(xfs_exntfmt_t) = 4
> >  sizeof(xfs_exntst_t) = 4
> > 
> 
