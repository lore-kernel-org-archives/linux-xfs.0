Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36557C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FAE9601FE
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 17:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhHSRG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhHSRG4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Aug 2021 13:06:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2B6D601FE;
        Thu, 19 Aug 2021 17:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629392779;
        bh=u16KIjFMUTY6xm3/9JqbaSQe3n++1xdsK/v/C0+vHgI=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=cne7r3Uqs2XBWPMjZSuUXBaCc6XWBKRQIvn2G96QnlUbMIRY4RRBmvTkfaNEESAnZ
         len7UuD1Hs+1695X/7M8X50fYkaRq627O+sPgnYRUC33CiRtSm66J56+K5lhw0CF/0
         rCZYjaQqFGOircK/HE3RKQS9nUD6FnSD2TuXUmUmp72Ta6jLonbDKshTJKDMiucklH
         FWLFqPNBJ01KK73zfgQxo9+jOoTHj+Dg72kEEc/BfH25lGTNuO/hJFrISNn/D6QYJY
         1brYLam80lb/hqc/yQx1eVyCldcBBuExX9XL44vGemdcji1/+5fLZrK2tHbjVZ7kI3
         cXhY0lOM3U4DQ==
Date:   Thu, 19 Aug 2021 10:06:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 16/15] xfs: start documenting common units and tags
 used in tracepoints
Message-ID: <20210819170619.GT12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <20210819030728.GN12640@magnolia>
 <20210819034647.GR12640@magnolia>
 <20210819132717.cacejau2jtaqme5h@omega.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819132717.cacejau2jtaqme5h@omega.lan>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 19, 2021 at 03:27:17PM +0200, Carlos Maiolino wrote:
> On Wed, Aug 18, 2021 at 08:46:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Because there are a lot of tracepoints that express numeric data with
> > an associated unit and tag, document what they are to help everyone else
> > keep these thigns straight.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2: update unit names, say that we want hex, and put related tag names together
> > ---
> ...
> > + * daddr: physical block number in 512b blocks
> > + * daddrcount: number of blocks in a physical extent, in 512b blocks
> 
> Shouldn't this be bbcount?

Yep, and the 'blockcount' above should be 'fsbcount' too.

Thanks for the reviews, everyone!

--D

> 
> Other than that, it looks good:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> -- 
> Carlos
> 
