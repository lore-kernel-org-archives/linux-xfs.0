Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BECBC54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27829206D6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OFzyyjvX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgELIHs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 04:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbgELIHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 04:07:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C55C061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HhyYzRSRQDXinBVB3XoZ50+RfOzOjwYQ452/BXadzZY=; b=OFzyyjvXDXdtey8I8uD7hLI0nM
        x/RzbNVY/OYq4plqkbrXzspW11FNi8IIalKIOycYI+PXVNo25iJVMtkBiTUHbVM56bCQLxm1ObPWe
        YZ+eMAEDLGWkar1Yg2xQb6gWom/y8ZSFhwO+ZOB2/Q3oNOvlndTzyxAuCuPO9iseC/7Yza2pEX7Ma
        lcxyGYZMWD6qZMNVt2AHLp+sVMcuX6RZkEql0M51XXyHXlHfzZ9QT1rPlaDygSRr/lgW50a9deFPi
        wdQ1Yjc3cvHizpxtkMeXA4a18TjI8ff9fT8qoE3g93YN7paVRXh+6pXHTqyjWKjb5ZxvKorDzLVpt
        dC7Y/2Vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYPx2-0007E6-EK; Tue, 12 May 2020 08:07:44 +0000
Date:   Tue, 12 May 2020 01:07:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs_repair: convert to libxfs_verify_agbno
Message-ID: <20200512080744.GA26197@infradead.org>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904185435.982941.16817943726460132539.stgit@magnolia>
 <20200509171830.GC15381@infradead.org>
 <20200511162203.GZ6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511162203.GZ6714@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 09:22:03AM -0700, Darrick J. Wong wrote:
> Yes.  Each of those "bno != 0" checks occurs in the context of checking
> an AG header's pointer to a btree root.  The roots should never be zero
> if the corresponding feature is enabled, and we're careful to check the
> feature bits first.
> 
> AFAICT that bno != 0 check is actually there to cover a deficiency in
> the verify_agbno function, which is that it only checked that the
> supplied argument didn't go past the end of the AG and did not check
> that the pointer didn't point into the AG header block(s).
> 
> Checking for a nonzero value is also insufficient, since on a
> blocksize < sectorsize * 4 filesystem, the AGFL can end up in a nonzero
> agbno.  libxfs_verify_agbno covers all of these cases.
> 
> > Either way this should probably be documented in the changelog.
> 
> Ok, how about this for a commit message:
> 
> "Convert the homegrown verify_agbno callers to use the libxfs function,
> as needed.  In some places we drop the "bno != 0" checks because those
> conditionals are checking btree roots; btree roots should never be
> zero if the corresponding feature bit is set; and repair skips the if
> clause entirely if the feature bit is disabled.
> 
> "In effect, this strengthens repair to validate that AG btree pointers
> neither point to the AG headers nor point past the end of the AG."

With the additional explanation in the commit log:

Reviewed-by: Christoph Hellwig <hch@lst.de>
