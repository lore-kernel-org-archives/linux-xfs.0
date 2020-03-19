Return-Path: <SRS0=LwPM=5E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD315C4332D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 10:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9129220739
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Mar 2020 10:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NPdqfWZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCSKUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Mar 2020 06:20:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCSKUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 06:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ntJd7dUM0sZh65THRmkRhW0Z2X4v3bgEZxiGC8V87b0=; b=NPdqfWZQW7ok68F99nZSWB4EiC
        iwCmPSaRU9YsXGBoldjY8WpNe37PvEZaNdwkLE3rFLqoiUMNDjhE9jkFexjMOPz/qBKa2JNDLDFP8
        VCNf4Go22JyscS7ePxXqYnql/ku5lrMhaj+rksUXN32t5uX1cDb8pk9Y+j4S57mNTCoQu8p15MGm4
        tmvLubpFBME8Ch87n5HtF2Js/k4HiXz0WzM3tA1LPvQSUfaPtAZdH/LH5uMVg8tpX7UiAEAEC7BxR
        aWnrppdR6e34JZBtLBap/q0wWpU1vRGQZFswa+BDAOmBy0xEFQYnQY5lnkECNrJkFChlgqQDEGnwO
        zjla2clQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEsI2-0004IT-Ep; Thu, 19 Mar 2020 10:20:38 +0000
Date:   Thu, 19 Mar 2020 03:20:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 00/25] Change readahead API
Message-ID: <20200319102038.GE3590@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225214838.30017-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Any plans to resend this with the little nitpicks fixed?  I'd love to
get this series into 5.7..
