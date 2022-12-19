Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D39C4167B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Dec 2022 17:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiLSROz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 12:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiLSROy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 12:14:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D8B4;
        Mon, 19 Dec 2022 09:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86B1DB80E8F;
        Mon, 19 Dec 2022 17:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B8EC433EF;
        Mon, 19 Dec 2022 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671470091;
        bh=+WgBR5vCZiRaQVVt2ZASYxwYdrHFhKZDpUBol1eIVEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G74Sv0MrkV0M8+car7t729FxdhONKptaOolvw7vKGgdK4UaFB6BuIKMh44Cpbv8A7
         DTQ/7fjt/Mjcihch6VKe7v16vgMav58rsqEfgue/CmFP9uclzrAi2L5YQoHlape2Ym
         spsLEXyqCrjjY3iFSfE+gdwP7iaRtyf9/2eou4oKw/XJSa90mKNYIGzyqOBTlwp69E
         zS3vVkRQp9xdS3pIMeHVsan134tpD3bJt1TIOlE1MD0GyKIgHtrUS3/wfS0XDw5Me2
         tWkndsAXpljeWG2TFAkvOcy0LftLFR4HoQmhTctztDDjTx6mu/Q8Hy6hDLV0mnBQZj
         Dg0VIcAjoHxMA==
Date:   Mon, 19 Dec 2022 09:14:50 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <Y6CcCsKPZWb4LMnq@magnolia>
References: <167096073708.1750519.5668846655153278713.stgit@magnolia>
 <167096074260.1750519.311637326793150150.stgit@magnolia>
 <20221214184047.k3iaxggotcli4423@zlang-mailbox>
 <Y516UhlSugONPpVp@magnolia>
 <20221217100029.x4su3x5n3tlnuldi@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217100029.x4su3x5n3tlnuldi@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 17, 2022 at 06:00:29PM +0800, Zorro Lang wrote:
> On Sat, Dec 17, 2022 at 12:14:10AM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 15, 2022 at 02:40:47AM +0800, Zorro Lang wrote:
> > > On Tue, Dec 13, 2022 at 11:45:42AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Adjust this test since made EFI/EFD log item format structs proper flex
> > > > arrays instead of array[1].
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > So we let this case fail on all older system/kernel? Is the kernel patch
> > > recommended to be merged on downstream kernel?
> > 
> > Yes, since there are certain buggy compilers that mishandle the array
> > size computation.  Prior to the introduction of xfs_ondisk.h, they were
> > silently writing out filesystem structures that would not be recognized
> > by more mainstream systems (e.g. x86).
> > 
> > OFC nearly all those reports about buggy compilers are for tiny
> > architectures that XFS doesn't work well on anyways, so in practice it
> > hasn't created any user problems (AFAIK).
> 
> Thanks, may you provide this detailed explanation in commit log, and better
> to point out the kernel commits which is related with this testing change.

Will do.

> Due to this case isn't a case for a known issue, I think it might be no
> suitable to add _fixed_by_kernel_commit in this case, but how about giving
> more details in commit log.

Er.... xfs/122 isn't a regression test, so it's not testing previously
broken and now fixed code.  While I sense that a few peoples'
understanding of _fixed_by_kernel_commit might be constrained to "if
this test fails, check that your kernel/*fsprogs have commit XXXXX", I
myself have started `grep _fixed_by_kernel_commit' to find bug fixes and
their related regression tests to suggest backports.

...although I wonder if perhaps we should have a second set of
_by_commit helpers that encode "not a regression test, but you might
check such-and-such commit"?

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  tests/xfs/122.out |    8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> > > > index a56cbee84f..95e53c5081 100644
> > > > --- a/tests/xfs/122.out
> > > > +++ b/tests/xfs/122.out
> > > > @@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
> > > >  sizeof(xfs_dq_logformat_t) = 24
> > > >  sizeof(xfs_dqblk_t) = 136
> > > >  sizeof(xfs_dsb_t) = 264
> > > > -sizeof(xfs_efd_log_format_32_t) = 28
> > > > -sizeof(xfs_efd_log_format_64_t) = 32
> > > > -sizeof(xfs_efi_log_format_32_t) = 28
> > > > -sizeof(xfs_efi_log_format_64_t) = 32
> > > > +sizeof(xfs_efd_log_format_32_t) = 16
> > > > +sizeof(xfs_efd_log_format_64_t) = 16
> > > > +sizeof(xfs_efi_log_format_32_t) = 16
> > > > +sizeof(xfs_efi_log_format_64_t) = 16
> > > >  sizeof(xfs_error_injection_t) = 8
> > > >  sizeof(xfs_exntfmt_t) = 4
> > > >  sizeof(xfs_exntst_t) = 4
> > > > 
> > > 
> > 
> 
