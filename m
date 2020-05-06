Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC297C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB2320A8B
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hOo6o+le"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgEFPfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEFPfp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:35:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CC7C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Byrh+uwjwDOvlZSGBth3NFSzFitIcWi9ai6XuaTri4M=; b=hOo6o+leq557cJSWUG8PMi4pHa
        y+lciHX+k05hFMVE16XYf4yOPPIsOBt/nf8uuyvL//Lwe09JXvX8OtgFwlzJqS+mejlY2onRv4TQ8
        CV6cyOpY69DgbUvg6THLpQLU9xYJcO5NWqtCqk4Ds+ttR8WmIQln1h1ejwhTYv8xv0b7bl93B9NR0
        RrQ+0+J6c2o04aHvefejSNf8upviuR6XHDx1skv/UwWgOHshiPgdF3rI85S+tu6lpmFG5z5sElmO1
        /TodTtdUEDcZ8F8O1pvhUXuus6bePBVWjnYe33r/mYnUkunUNF9ap3aXBTmydsiQH+REWcMQA1Zkx
        pTqTQGLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWM5J-0001Yb-9Z; Wed, 06 May 2020 15:35:45 +0000
Date:   Wed, 6 May 2020 08:35:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/28] xfs: move log recovery buffer cancellation code to
 xfs_buf_item_recover.c
Message-ID: <20200506153545.GC27850@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864119836.182683.2865492755380039236.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864119836.182683.2865492755380039236.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:13:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the helpers that handle incore buffer cancellation records to
> xfs_buf_item_recover.c since they're not directly related to the main
> log recovery machinery.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
