Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25791C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D905E64E43
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 17:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhBCRnA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:43:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45161 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbhBCRm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 12:42:59 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l7MAR-0006wL-To; Wed, 03 Feb 2021 17:42:16 +0000
Date:   Wed, 3 Feb 2021 18:42:15 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove the possibly unused mp variable in
 xfs_file_compat_ioctl
Message-ID: <20210203174215.c3htzz3rqva26hgz@wittgenstein>
References: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
 <20210203173009.462205-1-christian.brauner@ubuntu.com>
 <20210203173835.GY7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210203173835.GY7193@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 09:38:35AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 03, 2021 at 06:30:10PM +0100, Christian Brauner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > The mp variable in xfs_file_compat_ioctl is only used when
> > BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
> > dereference in a few places.
> > 
> > Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > As mentioned in the thread, I'd take this on top of Christoph's patch if
> > people are ok with this:
> > https://git.kernel.org/brauner/h/idmapped_mounts
> 
> I don't mind taking this via the xfs tree, unless merging through the
> idmapped mounts series is easier/causes less rebase mess?

It's caused by Christoph's xfs conversion patch as he's changing the one
place where "mp" was passed outside the BROKEN_X86_ALIGNMENT ifdef to a
struct file as arg. So I'd just apply it on top of that if you don't
mind. Would make it easier for Stephen Rothwell too as he's dealing with
all the merge conflicts. :)

> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Tyvm!
Christian
