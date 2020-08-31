Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF48CC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B021320767
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 16:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iC9TSfxc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgHaQET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgHaQER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:04:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D432C061573
        for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2020 09:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Xvi4poopImK+4JRjBDqEuqJe/BvjTLzSoLxwdjpLAM=; b=iC9TSfxcxHxaZo/sr1u9lEYSmf
        UxiopEbU1XTYJFSTA2nd/dJUa/Bg7Fm+aT37QfuL3QQ2RmxiqQZTSfljpETMMik3VctQkRlw8RCt5
        DJjwcrToe1tkn7fW6WWYHGToq5i6KySLG29EZupR3xyc5ktwZ9GVQof9FFMgkril4t86RPVlNNkWP
        49wgt/LzJzNi079Qz1IE8b+WTOg2G7RZHrA9YDvyzkFI1tzWFDSh0rggI49lUsFyaO/uCQ+OtC7Nj
        7QauGAQQLUX4XH83lejL/Gs0OQkRnMp14gH2mdWbghWACgzi4J4UKkjwgCpXYAzl7g8OXxbPxJRNV
        9WukrhpQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCmI2-0001xt-WE; Mon, 31 Aug 2020 16:04:15 +0000
Date:   Mon, 31 Aug 2020 17:04:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: redefine xfs_ictimestamp_t
Message-ID: <20200831160414.GB7091@infradead.org>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405305.3608006.13513560786992998269.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885405305.3608006.13513560786992998269.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redefine xfs_ictimestamp_t as a uint64_t typedef in preparation for the
> bigtime functionality.  Preserve the legacy structure format so that we
> can let the compiler take care of the masking and shifting.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good modulo the comment on the last patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>
