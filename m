Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68DEC4724C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A6721655
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:27:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aQSACwu3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgEFP1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730368AbgEFP1j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:27:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653A8C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1xR9KQ/l5jCkWWKw/2t47q07wPrIci1rJDzQ/hp8+2k=; b=aQSACwu3vPbjoLBPcd+tjUVCZf
        Az5awGo9weUDYj0z6obP/klwPL4gKsZc261oQC7vAn7ywsDD66Fziavs9IGXGTY4pIDJwWWdHLfny
        8yDF8/bI4M8bTPdgy3+sqNx2xX0yNyoywOQZ2TbJpYUjqPv7YvWdpCJL0DkfsaOrQokACRu4EL8FE
        KhZGxrP2SqB+z+wNhypSpTf9stbGO6/yFVMUPV+b6/5I6HwOpmx6LMQ1yTqplQhU5FXTbaabtZTRj
        Bb1zUYX/0jfp+TyBsXnUi2XYuJNHhGn0SspUwKqv/hNQvjsT376jxpKUaD6TuTdf/KPc/SHTifoeG
        OMBF1FJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLxT-0000vZ-9D; Wed, 06 May 2020 15:27:39 +0000
Date:   Wed, 6 May 2020 08:27:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/28] xfs: report iunlink recovery failure upwards
Message-ID: <20200506152739.GY7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864116132.182683.16387605365627894770.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864116132.182683.16387605365627894770.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we fail to recover unlinked inodes due to corruption or whatnot, we
> should report this upwards and fail the mount instead of continuing on
> like nothing's wrong.  Eventually the user will trip over the busted
> AGI anyway.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
