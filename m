Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CD9C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93E262075D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WtsLlF7G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgGNIBb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:01:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBD5C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O7gV+l+tPaAykD5HJtfVF95iuq0VWNji0B1sKXJsQec=; b=WtsLlF7GEyvpOol5gVLm1T5xj7
        E3MxByj5CxLYMoXRV+B8AE36Vebrn0BIrM2ylyP+CvnBHxcVObJNEARZjMw5GzAo9Wkr+83HHC6wr
        QQPMcmEJlgm07zxBU4u/ZoEi6s/7QWNkn7QJ9DtwL874SQDUlrKf8dxDouce3e9GY0z+xh2/evZiK
        w3R4DR86t76SFwkFE13i4Gtkr41VG415p9dP5hXYWBCdf2IaVb9ksTEMAFA3Y2Po8zSQdpbH/1DXr
        bIEuKDfH4SfX6XZ1u5zzGH85vdOhHSvWBDfObFS27JIb1EkITfcDllhcucm/A+FaS9cJsJI65+XTb
        Hs6Ntu0g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFsW-00071e-VD; Tue, 14 Jul 2020 08:01:29 +0000
Date:   Tue, 14 Jul 2020 09:01:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs: refactor quota exceeded test
Message-ID: <20200714080128.GF19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469041620.2914673.13835099039036173215.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469041620.2914673.13835099039036173215.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:33:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the open-coded test for whether or not we're over quota.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
