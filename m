Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC89FC64E8A
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 10:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84081221FB
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Dec 2020 10:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbgLBKXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Dec 2020 05:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgLBKXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Dec 2020 05:23:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FB7C0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  2 Dec 2020 02:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tRqXARqNaUOcZbo16V95DWbVtUYEyY6/JXUlJoBtZxU=; b=ruOg9/IxO7z+iU7iA12XBM8BC2
        5RKgmeSLaSKYzG3m+jKVyH+mFTv7tJtdVKeQjvGEU39G1FYwOAj3tAQagCbi3lWCDkqNyG1c1OMoe
        Beu2aQnnW7ob9+LvEEZqr2JKotRgabzVwfok8JeOmWw8vQnoFqFIlBddMGn6rjbWiLmeU0trmkWkz
        zwO7E2GYV0UcAdM89siRDj1vChw2evRYmEemVuu9WlI/ZxX6dLvaSxWsQir/6425DoWijghTSOEve
        uzAj/vHa3EuVc+l/P/mruqeRMJUIdN/RVTynmyvnK6c3Jfp/c/95KlS+bwzzJJwRDLgqjYXNVSvY3
        mKKlyqHg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkPHB-0005Wd-W2; Wed, 02 Dec 2020 10:22:22 +0000
Date:   Wed, 2 Dec 2020 10:22:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] xfs: do not allow reflinking inodes with the dax
 flag set
Message-ID: <20201202102221.GB19762@infradead.org>
References: <1d87a83e-ba03-b735-f19a-955a09bcdcf7@redhat.com>
 <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c41ba8-ecb7-5042-fa6c-dd8c9754b824@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 01:20:55PM -0600, Eric Sandeen wrote:
> Today, xfs_reflink_remap_prep() will reject inodes which are in the CPU
> direct access state, i.e. IS_DAX() is true.  However, it is possible to
> have inodes with the XFS_DIFLAG2_DAX set, but which are not activated as
> dax, due to the dax=never mount option, or due to the flag being set after
> the inode was loaded.
> 
> To avoid confusion and make the lack of dax+reflink crystal clear for the
> user, reject reflink requests for both IS_DAX and XFS_DIFLAG2_DAX inodes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> This is RFC because as Darrick says, it introduces a new failure mode for
> reflink. On the flip side, today the user can reflink a chattr +x'd file,
> but cannot chattr +x a reflinked file, which seems a best a bit asymmetrical
> and confusing... see xfs_ioctl_setattr_xflags()

This seems confusing.  IMHO for now we should just for non-dax access
to any reflink file even if XFS_DIFLAG2_DAX is set.  The only place
where we cannot do that is if a file has XFS_DIFLAG2_DAX set and is in
use and we want to reflink it.  Note that "in use" is kinda murky and
potentially racy.  So IMHO not allowing reflink when XFS_DIFLAG2_DAX
is set and dax=never is not set makes sense, but we should not go
further.
