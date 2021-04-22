Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDE7C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEA1361403
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343897AbhDVAUT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343886AbhDVAUS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 20:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E4C61450;
        Thu, 22 Apr 2021 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619050785;
        bh=TQL3gVitPCOMp3nJ9V2enDG0OMNl4IBiFbGFTELNENc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R4gqIvlC+W/BzwgkWi6zqRyURsBlkV9EceBL4rTS1rza7Jzy6px/m921/qvyhP/Hx
         Hu8e2R+a773Zzrw8bQ3gfBUtSm41H1qwZSXxROxtl7dntw0a5knQ56+fA75ZKcxckC
         5elKeLeddxyBnA/2wO/B6IOfNRZeQWCsm9vskXhSb0nxBu/+l6jxW6LapBoNvX1ehc
         /4VIUNwRJJVVvAjPmudvoS1Ortoafij+4XiOFvjZYes5qG6duqo0fghs9KS6Zxj9u/
         CJXpSky3LsNv0K9a29gKY/DX+imzZpeSW0OqswsUPNibn6JAC0tIUw6mvDzSMfVC13
         SFfNBru8QGq3g==
Date:   Wed, 21 Apr 2021 17:19:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 2/7] xfs: clean up the EFI and EFD log format handling
Message-ID: <20210422001943.GV3122264@magnolia>
References: <20210419082804.2076124-1-hch@lst.de>
 <20210419082804.2076124-3-hch@lst.de>
 <20210420170529.GH3122264@magnolia>
 <20210421055541.GA28961@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421055541.GA28961@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 07:55:41AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 20, 2021 at 10:05:29AM -0700, Darrick J. Wong wrote:
> > Hmm... so the behavior change here is that 32-bit kernels will start
> > logging 16-byte xfs_extent structures (like 64-bit kernels)?
> 
> Yes.
> 
> > I see that
> > xfs_extent_32 was added for 2.6.18; won't this break recovery on
> > everything from before that?
> 
> Where everything is a 32-bit kernel that doesn't align properly, yes.
> 
> > Granted, 2.6.17 came out 15 years ago and the last 2.6.16 LTS kernel was
> > released in 2008 so maybe we don't care, but this would seem to be a
> > breaking change, right?  This seems like a reasonable change for all V5
> > filesystems (since that format emerged well after 2.6.18), but not so
> > good for V4.
> 
> Err, why?

Log recovery on those old kernels will choke on the 16-bit xfs_extent
records, because they only know how to interpret a 12-bit xfs_extent.
In 2.6.17, xlog_recover_do_efi_trans did this:

	efi_formatp = (xfs_efi_log_format_t *)item->ri_buf[0].i_addr;
	ASSERT(item->ri_buf[0].i_len ==
	       (sizeof(xfs_efi_log_format_t) +
		((efi_formatp->efi_nextents - 1) * sizeof(xfs_extent_t))));

The ASSERT will trigger on the size being wrong due to the padding
error, but on non-DEBUG kernels that won't interrupt log recovery, so we
proceed on to this:

	memcpy((char *)&(efip->efi_format), (char *)efi_formatp,
	      sizeof(xfs_efi_log_format_t) +
	      ((efi_formatp->efi_nextents - 1) * sizeof(xfs_extent_t)));

In this particular case, we fail to copy the all of the bytes from the
recovered EFI into the new incore EFI log item.  If there is more than 1
extent, the fields in the (N+1)th incore extent won't line up with the
fields that were written to disk, which means we'll replay garbage.

--D
