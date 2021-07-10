Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D7AC07E95
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jul 2021 03:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267F5613D0
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jul 2021 03:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhGJEBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Jul 2021 00:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229452AbhGJEBQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 10 Jul 2021 00:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C6461242;
        Sat, 10 Jul 2021 03:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625889511;
        bh=a2ap6YqtCzSNC1BFzqUsH7gE/cFHVLYK+AMuns6Fhr0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4z7qOaqYf5I485D9B4JU9NwfCqTU+4PCJF9lh5a2D9Px8ouIGFIuoWYaNB7udMrM
         IgGb1LBSDj9Pm4cvhN9mnT+F5HI/iuM38cVSEn9vlQuNrL2QElHp1+E2HHU4FQQPVo
         /0I779lHOhT/llr2//3nZxX4wAdGS10Ns9MV9FH56TDY54JYHHN/Ixb9vP9EwDICbU
         FheshtElRXhfqivMU30qziyNnOGFZVXh2r0EiyhA5srVttqp9pJoRSUh27YIGY4t7f
         CoDYgL7jfflVlAG8CKmDul0Xv1fBe3z4wzLKFDSimbLwEcU4KX4ECLOapG/8bFfD8C
         xWMUfSjm1wQvg==
Date:   Fri, 9 Jul 2021 20:58:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't expose misaligned extszinherit hints to
 userspace
Message-ID: <20210710035831.GB11588@locust>
References: <20210709041209.GO11588@locust>
 <YOfrxV9p1Bhrs1jD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOfrxV9p1Bhrs1jD@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 09, 2021 at 07:25:09AM +0100, Christoph Hellwig wrote:
> On Thu, Jul 08, 2021 at 09:12:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Commit 603f000b15f2 changed xfs_ioctl_setattr_check_extsize to reject an
> > attempt to set an EXTSZINHERIT extent size hint on a directory with
> > RTINHERIT set if the hint isn't a multiple of the realtime extent size.
> > However, I have recently discovered that it is possible to change the
> > realtime extent size when adding a rt device to a filesystem, which
> > means that the existence of directories with misaligned inherited hints
> > is not an accident.
> > 
> > As a result, it's possible that someone could have set a valid hint and
> > added an rt volume with a different rt extent size, which invalidates
> > the ondisk hints.  After such a sequence, FSGETXATTR will report a
> > misaligned hint, which FSSETXATTR will trip over, causing confusion if
> > the user was doing the usual GET/SET sequence to change some other
> > attribute.  Change xfs_fill_fsxattr to omit the hint if it isn't aligned
> > properly.
> 
> Looks sensible, but maybe we need a pr_info_ratelimited to inform
> the user of this case?

Why?  Now that I've established that the system administrator is and
always has been allowed to invalidate the extent size hints when
realtime volumes are in play, I don't think we need to spam the kernel
log about the admin's strange choices.

The only reason I put that xfs_info_once thing in 603f00 is because I
mistakenly thought that the only way we could end up with a fs like that
was due to gaps in user input sanitization, i.e. fs isn't supposed to be
weird, but it is anyway.

--D
