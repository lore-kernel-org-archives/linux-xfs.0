Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207C3C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D678A64DF3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhBYHl1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhBYHlE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 02:41:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F3CC06178A
        for <linux-xfs@vger.kernel.org>; Wed, 24 Feb 2021 23:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i8WS4HiX3JiHYGI0uA0cFoiRZyCVo7dsNYAuaDby9C4=; b=ln5yLxHLQqCEx3FtF5fHxyZhbL
        NI+rBsNV8lgOKT4uFLpPE/TTq108Vnps7Ts4D/fSPmwBYaifLMf2Oa256A73eLcN2511GT1KP/86O
        PxfIHAaqinUZLIaqBeFnGnnBQ+LLXI2EQAzYGK9AdUF45oxzopjOURq5SMi5DtiIPJqEikO8Rd5Vx
        XvYTSRFpOn4QZ2B6UmxASWG8LD2ip/uHD+vGREFWUEroIxTLJC+gan6GxHM/ZPEUJTa2uI103PjIL
        uCuNaIoo/zjwEgGfQU9wgVoOFOSzCH7KYSV+/XiP/zvR2iHuysNhJdbeWLUYxIMxTBpCsGj5n0nEP
        RSlbyzXA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBFd-00AQB7-IH; Thu, 25 Feb 2021 07:40:02 +0000
Date:   Thu, 25 Feb 2021 07:39:57 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH 1/5] man: mark all deprecated V4 format options
Message-ID: <20210225073957.GD2483198@infradead.org>
References: <161319522350.423010.5768275226481994478.stgit@magnolia>
 <161319522904.423010.55854460196587153.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161319522904.423010.55854460196587153.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 12, 2021 at 09:47:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update the manual pages for the most popular tools to note which options
> are only useful with the V4 XFS format, and that the V4 format is
> deprecated and will be removed no later than September 2030.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
