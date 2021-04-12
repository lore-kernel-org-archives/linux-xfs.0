Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819EAC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52A646128E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 15:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhDLPs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239633AbhDLPs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Apr 2021 11:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796BD61246;
        Mon, 12 Apr 2021 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618242489;
        bh=8vRE2sT1b6eDattSfR7ri5RJ2qCaH8JeKxz5WPXcorU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pnSJay4zP25POtLTscvF2z5mWetO++/0dMpHer+DMUKEUVwLkOsg9fAeauFaOWt+o
         9ZijoYP72WrFmWFWd+9i7OY8W4gnkqWJ+ym8y46O1HtNI/cqJAq1lTa8/nx7prTSTD
         UEZRNVvKvX0ZF1qQe0UStduK5A9dx2opS5KESYQKPc1C8/g2Gu7AsmL7TZbi4S84Pq
         l4XKVJHE/iC8j+8nMDA4/HHdwCFx0MYQRh/ROFPM54W6yQgpUl3YJr3/Qg4o6WCH9r
         /uvaXow8wvo6R64UVeoxH80ng7tM0v0D+20L/tlEEZd4MUp6SbHtenpLNqSVLTBY0n
         AfJ3bJSnM63mg==
Date:   Mon, 12 Apr 2021 08:48:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4][next] xfs: Replace one-element arrays with
 flexible-array members
Message-ID: <20210412154808.GA1670408@magnolia>
References: <20210412135611.GA183224@embeddedor>
 <20210412152906.GA1075717@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412152906.GA1075717@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 04:29:06PM +0100, Christoph Hellwig wrote:
> > Below are the results of running xfstests for "all" with the following
> > configuration in local.config:
> 
> ...
> 
> > Other tests might need to be run in order to verify everything is working
> > as expected. For such tests, the intervention of the maintainers might be
> > needed.
> 
> This is a little weird for a commit log.  If you want to show results
> this would be something that goes into a cover letter.

Agreed, please don't post fstests output in the commit message.

> > +/*
> > + * Calculates the size of structure xfs_efi_log_format followed by an
> > + * array of n number of efi_extents elements.
> > + */
> > +static inline size_t
> > +sizeof_efi_log_format(size_t n)
> > +{
> > +	return struct_size((struct xfs_efi_log_format *)0, efi_extents, n);
> 
> These helpers are completely silly.  Just keep the existing open code
> version using sizeof with the one-off removed.

A couple of revisions ago I specifically asked Gustavo to create these
'silly' sizeof helpers to clean up...

> > -					(sizeof(struct xfs_efd_log_item) +
> > -					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
> > -					sizeof(struct xfs_extent)),
> > -					0, 0, NULL);
> > +					 struct_size((struct xfs_efd_log_item *)0,
> > +					 efd_format.efd_extents,
> > +					 XFS_EFD_MAX_FAST_EXTENTS),

...these even uglier multiline statements.  I was also going to ask for
these kmem cache users to get cleaned up.  I'd much rather look at:

	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
				sizeof_xfs_efi(XFS_EFI_MAX_FAST_EXTENTS), 0);
	if (!xfs_efi_zone)
		goto the_drop_zone;

even if it means another static inline.

--D

> > +					 0, 0, NULL);
> >  	if (!xfs_efd_zone)
> >  		goto out_destroy_buf_item_zone;
> >  
> >  	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
> > -					 (sizeof(struct xfs_efi_log_item) +
> > -					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
> > -					 sizeof(struct xfs_extent)),
> > +					 struct_size((struct xfs_efi_log_item *)0,
> > +					 efi_format.efi_extents,
> > +					 XFS_EFI_MAX_FAST_EXTENTS),
> 
> Same here.  And this obsfucated version also adds completely pointless
> overly long lines while making the code unreadable.
