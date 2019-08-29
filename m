Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFCAC3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6B5D2189D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 09:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sq3nLx5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfH2JdF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 05:33:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2JdF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 05:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uKzcXmrG67Ksc1p8hrvnsl/IOxcGDuMvNW+a7L7SI6k=; b=Sq3nLx5EThr/0hW994465sAdf
        6B6e0RKCSBzpvxwVn3op9WB3tiRG7GF9xd8PP67eWFWbIxzx13Ep1ip8F6RAvZSWiYJd2b40Q3igr
        AtjfLfxXySWOS7w92FWrlJ2toniidFbADc0JTBMF/vQYL8SKEi7sPsVN7bVhSUCpLRa6E6UPaEC3n
        Ni8o9Bvz3mcW+KE2SMSVRQC3XwIYDECgMhPei84pkzYL156DHfaWMh1i9oIs+QPwMs4bEQcaskIrL
        7v3jSoyATIA0Drl+xdMCkPgQlAlFKF6xvcPeL7tV4DCNQdtBZvfIipe+RW5FgsWq6qX+2wgLHGBp3
        hDSft8KYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3Gnh-0007Oq-7X; Thu, 29 Aug 2019 09:33:05 +0000
Date:   Thu, 29 Aug 2019 02:33:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829093305.GA28388@infradead.org>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
 <20190829082501.GA18614@infradead.org>
 <20190829093117.GS1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829093117.GS1119@dread.disaster.area>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 07:31:17PM +1000, Dave Chinner wrote:
> On Thu, Aug 29, 2019 at 01:25:01AM -0700, Christoph Hellwig wrote:
> > Actually, another comment:
> > 
> > > +		/* Scan the free entry array for a large enough free space. */
> > > +		do {
> > > +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> > 
> > This could be changed to:
> > 
> > 			if (bests[findex] != cpu_to_be16(NULLDATAOFF) &&
> > 
> > which might lead to slightly better code generation.
> 
> I don't think it will make any difference because the very next
> comparison in the if() statement needs the cpu order bests[findex]
> value because its a >= check. Hence we have to calculate it anyway,
> and the compiler should be smart enough to only evaluate it once...

Yeah, makes sense.
