Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A05C41513
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 15:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjG0PXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 11:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjG0PXj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 11:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B929B1FF5;
        Thu, 27 Jul 2023 08:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E83661EB0;
        Thu, 27 Jul 2023 15:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9381EC433C8;
        Thu, 27 Jul 2023 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690471417;
        bh=h1mjcZkF8Kn64rI/aXMOg4eE10oHqARNNDVsrd2ZPVE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tSGMSSYNC6bu58v+1Z+Z4VmqW2Lbv2FxbZqano3K2U66IRhWmxC9GGgqAwarvvzPo
         WzO582zyByn9ZuGZryDc3rBgJi5Pcu62R3Jk5xQP/ulherZC+anRiETJ5gUwSTrRGU
         3WnCOEDOxuxB7XsN2gjTvR7FLpcfxmbehPhHN6uPNFPJqGyPqG0mlGeRH0dwIC8hM0
         l0C/7K0uSwmU1AcESjyz3CaEOFtWncqYBpD0OwZr17TU586Ku2uiWGYgvU6B2gdrRZ
         Z0Xh5eDnXMsZj9Hw9Rzqs2hfoHuGy2jnPuW501Hedgwd8pHVXprO03xvUwYuzQxuRH
         HCbTcXFCzlypQ==
Date:   Thu, 27 Jul 2023 08:23:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs/122: adjust test for flexarray conversions in 6.5
Message-ID: <20230727152336.GJ11340@frogsfrogsfrogs>
References: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
 <169033662042.3222297.14047592154027443561.stgit@frogsfrogsfrogs>
 <20230727135744.nhmwpv7dxt5nvshd@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727135744.nhmwpv7dxt5nvshd@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 09:57:44PM +0800, Zorro Lang wrote:
> On Tue, Jul 25, 2023 at 06:57:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Adjust the output of this test to handle the conversion of flexarray
> > declaration conversions in 6.5.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Looks like it's about a49bbce58ea9 ("xfs: convert flex-array declarations
> in xfs attr leaf blocks"). If you don't mind, I'd like to mention it in commit
> log when I merge it :) This patch looks good to me,

Please do mention it.  I wasn't sure if I should do that or a _fixed_by
tag, since technically there's no breakage in the xfs code itself...

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks,
> Zorro
> 
> >  tests/xfs/122 |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/tests/xfs/122 b/tests/xfs/122
> > index e616f1987d..ba927c77c4 100755
> > --- a/tests/xfs/122
> > +++ b/tests/xfs/122
> > @@ -26,13 +26,21 @@ _wants_kernel_commit 03a7485cd701 \
> >  _type_size_filter()
> >  {
> >  	# lazy SB adds __be32 agf_btreeblks - pv960372
> > +	# flexarray conversion of the attr structures in Linux 6.5 changed
> > +	# the sizeof output
> >  	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" == "0" ]; then
> >  		perl -ne '
> >  s/sizeof\( xfs_agf_t \) = 60/sizeof( xfs_agf_t ) = <SIZE>/;
> > +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> > +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> > +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
> >  		print;'
> >  	else
> >  		perl -ne '
> >  s/sizeof\( xfs_agf_t \) = 64/sizeof( xfs_agf_t ) = <SIZE>/;
> > +s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
> > +s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
> > +s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
> >  		print;'
> >  	fi
> >  }
> > 
> 
