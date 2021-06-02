Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF26C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7506761026
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhFBAek (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:34:40 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:53521 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhFBAek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 20:34:40 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 466096961B;
        Wed,  2 Jun 2021 10:32:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loEoV-007uPw-H3; Wed, 02 Jun 2021 10:32:51 +1000
Date:   Wed, 2 Jun 2021 10:32:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
Message-ID: <20210602003251.GH664593@dread.disaster.area>
References: <20210420230652.GA70650@embeddedor>
 <20210420233850.GQ3122264@magnolia>
 <62895e8c-800d-fa7b-15f6-480179d552be@embeddedor.com>
 <bcae9d46-644c-d6f6-3df5-e8f7c50a673d@embeddedor.com>
 <20210526211624.GB202121@locust>
 <202105271358.22E0E2BFD@keescook>
 <20210528003454.GN2402049@locust>
 <202105280915.9117D7C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105280915.9117D7C@keescook>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=a3pdOmBBwOh8kAAHZ5sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 28, 2021 at 09:48:39AM -0700, Kees Cook wrote:
> On Thu, May 27, 2021 at 05:34:54PM -0700, Darrick J. Wong wrote:
> > The choices are bad, so **turn it off** in fs/xfs/Makefile and don't go
> > making us clutter up shared library code that will then have to be
> > ported to userspace.
> 
> Ah! So the concern you have is with portable code shared outside of
> the kernel? This came up also with the ACPICA code (which is regularly
> imported into the kernel tree), and they just included their own macro
> directly[1].
> 
> Would you prefer something like that, which would be XFS-specific? I'm
> just trying to find a way to avoid losing fall-through coverage
> in XFS. (Especially since distros are slowly moving toward enabling
> -Wimplicit-fallthrough by default since it's a long-standing weakness
> in the C language, and has been hiding real bugs for years.)
> 
> It seems like the options here could be:
> 1) Use an XFS-specific macro like ACPICA does, so that the out-of-tree
>    userspace code can share it (more typing, keep coverage).
> 2) Add -Wno-implicit-fallthrough to fs/xfs/Makefile (easy, lose coverage).
> 
> For 1), which portions are shared between xfsprogs and the kernel? Only
> libxfs/ and scrub/? How does the below patch look? I could prepare similar
> for all of xfsprogs, or do this only for xfsprogs and leave the stuff
> outside of libxfs/ and scrube/ using the kernel's "fallthrough" macro?
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 782fdd08f759..ade529ddb60b 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -184,4 +184,14 @@ struct xfs_ino_geometry {
>  
>  };
>  
> +/* Programmatically mark implicit fallthroughs for GCC and Clang. */
> +#ifndef __has_attribute
> +#define __has_attribute(x) 0
> +#endif
> +#if __has_attribute(__fallthrough__)
> +#define XFS_FALLTHROUGH __attribute__((__fallthrough__))
> +#else
> +#define XFS_FALLTHROUGH do { } while (0)
> +#endif

No. This is Obviously Stupid.

Did you listen to what Darrick just said? Wasn't it "Don't go making
us clutter up shared library code..."?

If we're complaining that replacing obvious comments demonstrating
intent with weird macros is not in our best interest, then replacing
the comments with an eye-bleeding, one off, XFS specific macro
doesn't address the objections being raised.

I don't even know why you are continuing trying to convince us to
take the changes - Darrick has already given you guys the option of
going straight to Linus with them. If you do that then we'll just
have to deal with the undefined macro fallout that results in
userspace.

Please just stop wasting more of our time on this.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
