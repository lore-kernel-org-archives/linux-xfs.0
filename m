Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F48DECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 06:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2EB20B7C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 06:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C9FuX4qv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfJIGbp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 02:31:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfJIGbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 02:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8EvJWeGlkis4V2qIrGZdCq8ITBADZ0WXtWxnOLtuFGc=; b=C9FuX4qvjvy4ms/l5dezaCgWE
        D90I0HKSpMbtznxYLCsHSjqrHs2J/MkxPIYVYyX6kwEf0OrcwIbT/Sx1DH6pVAnrXYSnK0FmCR3j7
        Z4petnP2+b93gL/dw8bLlqDNEVkEO7Q0utY6Q4Htm0fOEcHQcIKmB5jRi0BROdB87VX1wplpBEiLB
        epblpnpy35u27Tokbyn1wtomolNlbxxZltrtlhQwOQP6cd8kbnrCQpslH9Uo8A6rPPh26ZyPjT9pf
        a8p0zyqwI7Hed+GDLTLw6QaNwS9mX2s3omcgw/10Yf5nZl7LTpjteApAupK6H4Qgcx2tqT/QMkyDC
        U35ZF3mVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI5Vg-0002v9-Dc; Wed, 09 Oct 2019 06:31:44 +0000
Date:   Tue, 8 Oct 2019 23:31:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        darrick.wong@oracle.com, linux-kernel@vger.kernel.org,
        rgoldwyn@suse.de, gujx@cn.fujitsu.com, david@fromorbit.com,
        qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20191009063144.GA4300@infradead.org>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, I just had a chat with Dan last week on this.  And he pointed out
that while this series deals with the read/write path issues of 
reflink on DAX it doesn't deal with the mmap side issue that
page->mapping and page->index can point back to exactly one file.

I think we want a few xfstests that reflink a file and then use the
different links using mmap, as that should blow up pretty reliably.
