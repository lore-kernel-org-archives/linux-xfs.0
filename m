Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784D7C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 06:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22797207BC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 06:30:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u81TTUfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJEGaD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgJEGaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 02:30:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50936C0613CE
        for <linux-xfs@vger.kernel.org>; Sun,  4 Oct 2020 23:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eFWltcAp+QaOXxYeHnIPP5/9ZSIWzVX7NYl4dP4MX8g=; b=u81TTUfEfykmh5Pz8IZPX4iC+y
        hv976Uv4lRpVt7y9S2heCAbn87regMTUwVClGzGkjklAd16KKyy8faYILet21u7iZtD8H+Sb1Mcz2
        qf1atLN/qsFck0H91LEU7Byp7nI7vyu2KxV/qMr0P0oCbMjJkrFNB8dDkGpfCUU8YBbFPX2O7BBjh
        kJAwZrDTslLDRQZ9Y5Yxso0ByysoWujPN3ZFR4Uy4CgALtcBG0otk2zZtMYwg8SLfhsnIcjxGj4yB
        +uu0iqv+ia1xtQcWDUxHmY5oGj6V+ZWk0I2QRXsCvXMBQso1cIPY2rQ8wAwhlJWOiS6Q+KXooPOb/
        tPXvXIrA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPK0X-0001HI-O5; Mon, 05 Oct 2020 06:30:01 +0000
Date:   Mon, 5 Oct 2020 07:30:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: streamline xfs_getfsmap performance
Message-ID: <20201005063001.GA4302@infradead.org>
References: <160161415855.1967459.13623226657245838117.stgit@magnolia>
 <160161417069.1967459.11222290374186255598.stgit@magnolia>
 <20201002071505.GB32516@infradead.org>
 <20201002175808.GZ49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002175808.GZ49547@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 02, 2020 at 10:58:08AM -0700, Darrick J. Wong wrote:
> On my 2TB /home partition, the runtime to retrieve 6.4 million fsmap
> records drops from 107s to 85s.

Please add these sorts of numbers to the commit log..
