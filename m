Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE2BC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08CB0208DB
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fn6vSw+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHVHPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgHVHPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:15:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14E0C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wFs8HD9jBmxQ2C4r9l6a0Sca332kxWwcTtyjyeA/EDk=; b=Fn6vSw+N+hTTRs9fi2VzWZSOdy
        yCHkpu+Cli0/H8e2G1xE4+MF2VUn7RM9YWt5CImrJaQWieHNH+/OBCc2jF3Vmz9UoAnFgNeQCSkcO
        k7xI3xWNidPKP4AqkmSTBeY5lRkayp2piuobXZhiZuKncRGdg4eCaX6ua0YvO6irGxiDgzuLLL8Hl
        ss1Ae2Vf2FHSO6YhLoeC2W6C2IjDod/ZRki2+SHf/EgioaUneUPYN3CDHjKSMVem59NgEB/pXutQK
        3THgeu3+53Rf/gFssbXV6EOfAwIJ0CeOechgDt/E35KYR7KRZwJMdTVzkGfRokNFi/ePufg1kQfaC
        z26995Kw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9NkO-0000hp-1H; Sat, 22 Aug 2020 07:15:28 +0000
Date:   Sat, 22 Aug 2020 08:15:27 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 04/11] xfs: remove xfs_timestamp_t
Message-ID: <20200822071527.GD1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797591321.965217.7549298717995336302.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797591321.965217.7549298717995336302.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Kill this old typedef.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
