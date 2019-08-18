Return-Path: <SRS0=cq6/=WO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A36C3A589
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2A12173B
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Aug 2019 08:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IaErCsYH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHRIf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Aug 2019 04:35:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfHRIf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Aug 2019 04:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aTPSeMQEolWN0lSl3c97YhKKHz5+xJdDC01q14X9c6M=; b=IaErCsYHD7mfC3vjRB8V++1gF
        kdTO/4Jyazv1UNtiVER1B0Ru6YKXHih21pm0MzpgCD9S5Vk2i05PALd8ikmKtcoW4QEG8LX/CTMNK
        DCjXmG+z2L0U/DgDS/iqcVL5hqN4FvJKvPP2kMbvDaxTZ9KEm64tqN5alW1eulhTZGfc/+JAU0Ikh
        WwV9z0vdEpoxz/kQRslRd1fo659BxUFCYT1Wzc9bbLgmH1HSkY3aegbjfcHpdr5yqaQDX2K31nk4c
        jIXdjA2JwqFhj3Y2SY/JEmW1xkgPEjPx8421UonwVFKxvMIr41qDlrCCUjeS30XOk63sA30tzVWr9
        OCilMNAqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hzGfJ-0003Xp-4x; Sun, 18 Aug 2019 08:35:53 +0000
Date:   Sun, 18 Aug 2019 01:35:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190818083553.GA13583@infradead.org>
References: <20190816063547.1592-1-hch@lst.de>
 <20190816063547.1592-3-hch@lst.de>
 <20190817014218.GD752159@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817014218.GD752159@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 06:42:18PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 16, 2019 at 08:35:47AM +0200, Christoph Hellwig wrote:
> > For 31-bit s390 user space, we have to pass pointer arguments through
> > compat_ptr() in the compat_ioctl handler.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

So, what is the plan?  Do you think they are worth including for 5.3,
or do you want to pass them off to Arnd for his series that is targeted
at 5.4?
