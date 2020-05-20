Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4493C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A049207ED
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZtgmiUU9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgETGxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgETGxe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 02:53:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B00C061A0E
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 23:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tdbcOVyVGVryU4eqdnUtO0RWfakItEjX6aZK4usJaVs=; b=ZtgmiUU961ars/xqDQz4AuWsaK
        iUkT8BQDilF8j/yNtA74+MEkn2+J1gEuolKJdwEZnE9GGtBJ9toBnS1qWJFXanGpNZybDTJHUyLx1
        z5WhEMUKroEVxQkv5Rj/tIeOPFA+onX3kVjsepm+5Ux4xgBFVNppxkcBAXoJmoHaMlaCTxUzicZYw
        /wosrx6f5JfkNCMUse6nG1gHwLXBQdViXzQIx8Xbmh9mT+QyoGF9thz3i7iu0RfIvAk8dNmgqmGQ2
        Hmp+SB3Ar5GRS7ZERPM4dtZI7/u8MD5ND2RFywcTx/4XnneugFD7cynJtpb5WWhp+7/q1uT5DJLwa
        3G80M13g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbIbe-0007T6-Cq; Wed, 20 May 2020 06:53:34 +0000
Date:   Tue, 19 May 2020 23:53:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: gut error handling in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20200520065334.GA25811@infradead.org>
References: <20200519214840.2570159-1-david@fromorbit.com>
 <20200519214840.2570159-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519214840.2570159-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 07:48:39AM +1000, Dave Chinner wrote:
> +	/*
> +	 * Debug checks outside of the spinlock so they don't lock up the
> +	 * machine if they fail.
> +	 */
> +	ASSERT(&mp->m_sb.sb_frextents >= 0);
> +	ASSERT(&mp->m_sb.sb_dblocks >= 0);
> +	ASSERT(&mp->m_sb.sb_agcount >= 0);

To stick to the theme of broken error handling I don't think this
does what you think as this takes the address of each field, which
will aways be >= 0.  I like the idea of the patch, though.
