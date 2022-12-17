Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36DAC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 08:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiLQIOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 03:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQIOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 03:14:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6EBC2D;
        Sat, 17 Dec 2022 00:14:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4FAC6066F;
        Sat, 17 Dec 2022 08:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89B2C433D2;
        Sat, 17 Dec 2022 08:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671264851;
        bh=1ATQl2ntAs+2c7Wq6fPGI/jbOo4x9GvtecNV20KZ1Vc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R2KIeAY/+qBGJPDh8I64+lL8hfYNl6oAYtfOdYbcf48s24N5S7FlOJBgIWm84TYJu
         HiQeMB0BBWq+ptxEc0rid8DolSCVxuLtG1E+yu2aMVviem3Y4PB+pffEQOGhYHZE6w
         KQCopN7c5nWWDPilILRLZOvKmcSzaNQynfmgPJ3cqCpoNjiCfmPJCQguKJCyuzMq3S
         70ciW7BAQHbOoxP3SN47ZdDZ49tifsy6a9POEiEH7+71d4hY2IDCr0yZXA31p7CT4/
         3UpOnqsHovWEmN7szM4GXcuOluiK68hIaoSRSsglcE7hwI5+h4czByoModOTbhrhtq
         B+bls8JWso8PA==
Date:   Sat, 17 Dec 2022 00:14:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after
 flex array conversion
Message-ID: <Y516UhlSugONPpVp@magnolia>
References: <167096073708.1750519.5668846655153278713.stgit@magnolia>
 <167096074260.1750519.311637326793150150.stgit@magnolia>
 <20221214184047.k3iaxggotcli4423@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214184047.k3iaxggotcli4423@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 15, 2022 at 02:40:47AM +0800, Zorro Lang wrote:
> On Tue, Dec 13, 2022 at 11:45:42AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Adjust this test since made EFI/EFD log item format structs proper flex
> > arrays instead of array[1].
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> So we let this case fail on all older system/kernel? Is the kernel patch
> recommended to be merged on downstream kernel?

Yes, since there are certain buggy compilers that mishandle the array
size computation.  Prior to the introduction of xfs_ondisk.h, they were
silently writing out filesystem structures that would not be recognized
by more mainstream systems (e.g. x86).

OFC nearly all those reports about buggy compilers are for tiny
architectures that XFS doesn't work well on anyways, so in practice it
hasn't created any user problems (AFAIK).

--D

> Thanks,
> Zorro
> 
> >  tests/xfs/122.out |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > 
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
