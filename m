Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37514C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 07:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F42182133F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 07:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GYyS4384"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfJIHGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 03:06:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIHGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 03:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kVJObDfrF6kRhduS+37+i6aFLzdYt/OzvgIxW6PJnaM=; b=GYyS4384pMTEsrb4s7yuvfxwD
        gbAvH66nSViD6yRbC/cvvOaLBq3hnij0MUWq+sSMkdZ711DlKIb7RaPQd/PZt6u0m8WKpyqJRKaIZ
        WTqXN86Do7M6Mc0sAAYY7w428IXZ9eO2r/f91dnVOA1xTKP/7VM/tReeu0VoQiYg3LHYWjt43P+2Y
        NvSff1goFcTl7f4Ydzn/vRPapm3NiJTF8A9lLkxwsvnddQq0lSVxb2W+aC1+dWw++MCoptNYsdgN5
        klmexEyUDnEOOfcAnqmBNuydNyQjdKKaj50VeRbnVJ33uZ423TWmZoNcixnsMC/D8T2sUmEqsffiE
        T89MnTjSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI632-0008O9-Lt; Wed, 09 Oct 2019 07:06:12 +0000
Date:   Wed, 9 Oct 2019 00:06:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V2 00/26] mm, xfs: non-blocking inode reclaim
Message-ID: <20191009070612.GA26579@infradead.org>
References: <20191009032124.10541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009032124.10541-1-david@fromorbit.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 02:20:58PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of the RFC I originally posted here:

Do you happen to have a git tree to pull from as well?
