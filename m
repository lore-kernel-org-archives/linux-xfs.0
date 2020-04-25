Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC17C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0625F206A2
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 18:28:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PYjXqUww"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDYS2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYS2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 14:28:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C1AC09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 11:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lIDfbuzeSsYxM76QTu+PhO9ujggL0BM/0aB1O+dBSMs=; b=PYjXqUww3nvX/17Rnj9H2+LxBY
        REF3GICOoSSYulEshTrg36N9sObqmt9evbemzTxB4K8od16GZ5zRBfOS9fF9rpgIeZK1ULnbhJ0rT
        hcoEjREdMbxo4PCS0qo/sQQzdRnZbp2xHXVBSR7Pesmz+26DTBJsppD0SvwG5dP5jsAx7OKB2n4X/
        wxUWASCZ0ThR7S5yudETpAROUaj5EqJ5AKyU4c66lTtBJg//ZisB4r5JnxyWnbPqqu6cIwZNvzDZw
        A1ACFKPnYcLnDTuwHU7f7e7bjuibxvqqP8BqGRLKMd6r5kOxq7RuXvLg+cfDm/OsTtilfW4c9wRx9
        eQwHVnyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSPXq-0005Rs-93; Sat, 25 Apr 2020 18:28:54 +0000
Date:   Sat, 25 Apr 2020 11:28:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/19] xfs: refactor RUI log item recovery dispatch
Message-ID: <20200425182854.GF16698@infradead.org>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752123963.2140829.11785185891630195018.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752123963.2140829.11785185891630195018.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:07:19PM -0700, Darrick J. Wong wrote:
> +const struct xlog_recover_intent_type xlog_recover_rmap_type = {
> +	.recover_intent		= xlog_recover_rui,
> +	.recover_done		= xlog_recover_rud,
> +	.process_intent		= xlog_recover_process_rui,
> +	.cancel_intent		= xlog_recover_cancel_rui,

Can you make sure your method instance names are always
someprefix_actual_method_name?  That makes life so much easier when
looking for all instances.
