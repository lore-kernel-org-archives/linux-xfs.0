Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D753C4724C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D1A206DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 15:29:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WfJCjaZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgEFP3k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 11:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbgEFP3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 11:29:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5A0C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 08:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l/UBN4Yos6oJP6QGDdZaWdCBbYHWs76nOfXXUKXfm3w=; b=WfJCjaZFi05ZdVkGjmx75Kt+v5
        lZOeKvGBx76kaXgO4hMr3uLAvXYSr3ZeXC48X+qcpRxrEoJYXzw4VJ6u2gnFdtr2e9PnLPxkyf56y
        lg1eHAAqsbxEwGbXoDKxZ7ZvuZ4TWzBi6woUGiLPFkBBuQORhPVMUX1GaW2F2+vp4nhbJnEJNJTwG
        jq5QczGce07MwXxyfZVxzFDF0MS94qHHfiouDXZsPO2HX9+T0aF4g0q41IboHVTsN9IfDH/YTSuvW
        cw3cm2UAb9vr985nxhKAnt8AIlgNAF5TmZcyxMZnl3nB7NIJx4nlpHvr5UXINlYAWswhVjumMa9CS
        fP6pOF2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWLzP-0001vi-EW; Wed, 06 May 2020 15:29:39 +0000
Date:   Wed, 6 May 2020 08:29:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/28] xfs: refactor releasing finished intents during
 log recovery
Message-ID: <20200506152939.GZ7864@infradead.org>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864116741.182683.12547831138234795563.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158864116741.182683.12547831138234795563.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 04, 2020 at 06:12:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded AIL item walking with a proper helper when we're
> trying to release an intent item that has been finished.

The changelog should probably mention the addition of the new iop_match
method.  

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
