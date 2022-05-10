Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68073C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 12:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbiEJMxg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 08:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiEJMxd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:53:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730341A4926
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vhW3+KI+voOXX2OSw2OZMPcirE3XRoXPh7eV6+CEG0A=; b=Oyig9NOD7cUHW+UcznTt9HyMN6
        dDck70yQEWXihSRM/+eMiw61Rf8s42ZN/TZYiFqeBmCX7rc2xaKX2GHgjLl+xlsOAmj+/WDlzoIZd
        sqG8mgwH5N/IhSzBgfXLWguJc/DQeypaxMXGempX1b7RkmgAfKPhlNAiAD1GOgv0yAFD3qZkMHHcP
        A9SfW01ZrynDoWZkfModTpPMZGT17LfFIotmnLABDdkwXMITO7/E1H/dzZfdbPlXJ142GYjfJBV/D
        0tU9H0OMrxSpZ+s2/U0Y8kUga+1J8XVsbjqf1Vwst7oT6gKhXsEOQgWfZ2N9oIKIOlUkgg74sj1w1
        J/f0y0+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPJ1-0020LR-Kk; Tue, 10 May 2022 12:49:35 +0000
Date:   Tue, 10 May 2022 05:49:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: whiteouts release intents that are not in the
 AIL
Message-ID: <YnpfX7AgvhriuPtZ@infradead.org>
References: <20220503221728.185449-1-david@fromorbit.com>
 <20220503221728.185449-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503221728.185449-10-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 04, 2022 at 08:17:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we release an intent that a whiteout applies to, it will not
> have been committed to the journal and so won't be in the AIL. Hence
> when we drop the last reference to the intent, we do not want to try
> to remove it from the AIL as that will trigger a filesystem
> shutdown. Hence make the removal of intents from the AIL conditional
> on them actually being in the AIL so we do the correct thing.
> 

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
