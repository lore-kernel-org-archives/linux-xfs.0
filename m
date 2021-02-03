Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F77BC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAED764F91
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 18:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhBCSSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 13:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhBCSR4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 13:17:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4088964DE1;
        Wed,  3 Feb 2021 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612376235;
        bh=3PZWrawlCui7Hs06Vvx9o/4uusP+QuYWvNi+tFsbHIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TDQ5L/FnQGlwuyMjSCyMOZqQf4IcVuvjpnTCJxfjavJCnDKLHpLa9vFCXJgU/nI1n
         frcdiKU3Ha4nmAq6w6EiNfCRPgY+99FPECLIC7ac6Wi9lUBdb3TI4xl0pnx93Hv5MF
         zthIFJTMQs3hx4Dq3Vk7/irJu4xPHBP9iQYdCNJ83sykL5rhALGxyczYTfh7jA3gRt
         35i0P81iDQ+QxHjb/5KYPikTpniNP11Ex07Cu7/GvL+9cIYtfw1WUhtc7CW+5snCr4
         0rzt00gS/UA/tzVPekwlScpOaaGH2Oyp8Z+CoKW2LvA6Vj9hBwoa9+FMa7rV40mqxl
         15Xqicc8ftReA==
Date:   Wed, 3 Feb 2021 10:17:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH -next] xfs: remove the possibly unused mp variable in
 xfs_file_compat_ioctl
Message-ID: <20210203181714.GB7193@magnolia>
References: <https://lore.kernel.org/linux-xfs/20210203171633.GX7193@magnolia>
 <20210203173009.462205-1-christian.brauner@ubuntu.com>
 <20210203173835.GY7193@magnolia>
 <20210203174215.c3htzz3rqva26hgz@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203174215.c3htzz3rqva26hgz@wittgenstein>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 06:42:15PM +0100, Christian Brauner wrote:
> On Wed, Feb 03, 2021 at 09:38:35AM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 03, 2021 at 06:30:10PM +0100, Christian Brauner wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > The mp variable in xfs_file_compat_ioctl is only used when
> > > BROKEN_X86_ALIGNMENT is define.  Remove it and just open code the
> > > dereference in a few places.
> > > 
> > > Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > > As mentioned in the thread, I'd take this on top of Christoph's patch if
> > > people are ok with this:
> > > https://git.kernel.org/brauner/h/idmapped_mounts
> > 
> > I don't mind taking this via the xfs tree, unless merging through the
> > idmapped mounts series is easier/causes less rebase mess?
> 
> It's caused by Christoph's xfs conversion patch as he's changing the one
> place where "mp" was passed outside the BROKEN_X86_ALIGNMENT ifdef to a
> struct file as arg. So I'd just apply it on top of that if you don't
> mind. Would make it easier for Stephen Rothwell too as he's dealing with
> all the merge conflicts. :)

Works for me; I'm 100% ok with it going through your tree. :)

--D

> 
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Tyvm!
> Christian
