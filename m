Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4C8C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78222075B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ub19lEQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgJOIeR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgJOIeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:34:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F52C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ub19lEQX9e+G5fIHLyMWp8NnOi
        v3DU2/QDRFMruq8Om0AcQvXZJV34z73FHlBRFDJqBWw6bLW34kokLC5TaEg+lLBuTKKtB+o4WwC3s
        R10UxTJtYS/AspI9XAAro7ZI3QpEQB7YyYFRtZk4eKG/Yz0j2QXweJlwK+2HAz0efQ+mfUjn7cQp7
        eqY/8768vGsmzoM3/9d9430brLf6xefdwLebRf0nU5pAfK6OjRdIKurgnMZRBRjuBTlSTWyoBIxzj
        yUAUJEJrzFIYFIyu/ym6+R5TvS7d4n2F9Xc5bmIt2k35SKPMK4jpH/+0Pkb2NWwEm6IRAiL7hyFOp
        figMtSng==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyiF-0001g2-Gv; Thu, 15 Oct 2020 08:34:15 +0000
Date:   Thu, 15 Oct 2020 09:34:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 01/11] xfs: Add helper for checking per-inode extent
 count overflow
Message-ID: <20201015083415.GA5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-2-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
