Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6555C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8800322AAC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgLISDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgLISDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 13:03:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A25C061793
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 10:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eKXhfNKp6n3IJKdeL37PyI+HZ+Ehuve7KAS09IfNpzQ=; b=E7TqAHJNvRZzx6iQIkYm5d6bki
        G+djtHWVM6qHf2pSB1SBORlZm2HrRih5G7PwZ/MpCD/8SspHSjuAG0+ovP5jGNxnzMyTBFMF28MDJ
        JdzJLKtkKLz/1iOV12gYZ3F2cGaMYBEoSxOUs220mDEZvKZRG0kKm4hY/H4y5JjFurarpA/vA+bFR
        BySAy23HBHyiqMvv9IH3QYP5x450I6lW0yKwDJF/6oJ9uM+jSu4ZLI0WhT31XXgr9RasAExTa5Baq
        tidTw1tsWIdK/qeABOQyI50Y0Vtn2ljLXrVGQAfmQiElBCH/wow2huBxQbmlCO7VC1xTbxNTBVp9Q
        5QJG5/Lw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3no-0007MX-QR; Wed, 09 Dec 2020 18:03:00 +0000
Date:   Wed, 9 Dec 2020 18:03:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: move kernel-specific superblock validation out
 of libxfs
Message-ID: <20201209180300.GA28047@infradead.org>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729616682.1606994.13360186718552701085.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729616682.1606994.13360186718552701085.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 06, 2020 at 03:09:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A couple of the superblock validation checks apply only to the kernel,
> so move them to xfs_fc_fill_super before we add the needsrepair "feature",
> which will prevent the kernel (but not xfsprogs) from mounting the
> filesystem.  This also reduces the diff between kernel and userspace
> libxfs.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
