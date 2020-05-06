Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1900C38A2A
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A96020746
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 14:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OL3NtMB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgEFO7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 10:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbgEFO7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 10:59:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9690C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 07:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zwxmZGMJ8ykV0xBLn+lDpUIS1ftrZAJI76NNvftOJCg=; b=OL3NtMB+m1uaVVoEgm2KSPWc1/
        3WSx1Ti5dQ3474B3e0VpVnEUI3I7yqdgo86gBrSL0NVBiL5vgZxCP3hQriY42GSl/gDP29CTVIC8j
        eMOO1MO4zkNr0+QrZ2gUN+txeT5qtJeG5rtsvZF62a88xEPdCKaF3ZsNKdzmag39NroLIDpDOlN7l
        Rgdt6cH/87G78NZp1fzccePg9GKpIDmA4gULSuDiPUOEX/M/1klFvFS8kP62+qRBLtHEGf+G8fnuF
        P32XV+nr/IE8HbV4p+Xsaxx1KVY5KvJUsaBDA76PDGHKzp3mfskIZYtIp9gZ3w9kxjACI/deopnqc
        3v5zUKJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLW8-0005UI-IQ; Wed, 06 May 2020 14:59:24 +0000
Date:   Wed, 6 May 2020 07:59:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/28] xfs: convert xfs_log_recover_item_t to struct
 xfs_log_recover_item
Message-ID: <20200506145924.GD7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864103888.182683.1949900429505759832.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864103888.182683.1949900429505759832.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:10:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove the old typedefs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
