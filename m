Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5D5C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35C3A207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 08:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XSLDu6sd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgELIQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 04:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbgELIQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 04:16:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C93FC061A0C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 01:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p3Tqn5sVoChP1HSpcXP/243L3ZfFMpgGksyes+a0isc=; b=XSLDu6sdi6bsclV83p4/47FQ86
        U3O+fc2qR3RM2qeIaD9oC/KsiGcv6YFVZ2VnJhqNTONOrcMnk1GZVPqEFnIY94wk9lyM9qe+vIZka
        RSX/RD6p/uwPPgk9XwZIHz6tXsmb7LSJNLDJIw6wjki4DCty9wSohWP10/Dbo5Y0Lf0zu9VjS6nPd
        xnto+d5EziQ/Xnc5vfh+OmGin6G9RnqKNqAnvWEIHC+x4Lj0MFF/frIXHRdchl8FS2YqbynXbRC6G
        C/JNUutCMJNnEDnyvtdLIPyFEMkd3kBlpGrxYloOv7lu9RvV9ccqLgYheTATYai5UxG0XbhHzZE1B
        +kJBhRSg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYQ5A-00057v-A1; Tue, 12 May 2020 08:16:08 +0000
Date:   Tue, 12 May 2020 01:16:08 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512081608.GB7689@infradead.org>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512025949.1807131-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> Concurrent rm of same 50 million inodes:
> 
> 		unpatched	patched
> machine A:	8m30s		3m09s
> machine B:	4m02s		4m51s

This actually is a significant slow down on machine B, which
might be the more common one.  Can you find out how that happens
and if we can mitigate it?
