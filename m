Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BBDC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E46A2224A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P5ntdU3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgJOIez (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbgJOIez (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:34:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA49C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d/HDs1RU68oD067stxjZfdOSiG6rVhI3+Gt0Ys2/a9Y=; b=P5ntdU3bRhaOWcZ+zg9TmfFwbD
        QIOnth2MZS0wpl5grZXCVff3fGnq/80HCAb1sbId6CL+WtgJDX9l52YBXgObc2dtM2DqhiIW1DV1G
        yQkd/5EdSnNbdq7ibevTqPAfG1Wo9yTXRWRpnclNoDTdBwWZDk4tDLORux+CzPb9jZ+Fbyu8j8gus
        VfikvIPBHphthbIR/M2GhMS8372bY9ZVT+/WTDaR7IahR51jZ9UUlE/ZwmFeVmtgfz+3pB5BhePMS
        z8TOjuIUQwWetuhx6Cy4kfHKFCT5HmUMvfLj+9Lq+ChhNC8pqwSp+tk8DV+KFG3MAQIptMRaHTxqu
        dAgwjy3g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyir-0001ht-Ri; Thu, 15 Oct 2020 08:34:53 +0000
Date:   Thu, 15 Oct 2020 09:34:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 02/11] xfs: Check for extent overflow when trivally
 adding a new extent
Message-ID: <20201015083453.GB5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-3-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 02:59:29PM +0530, Chandan Babu R wrote:
> When adding a new data extent (without modifying an inode's existing
> extents) the extent count increases only by 1. This commit checks for
> extent count overflow in such cases.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

I still don't think XFS_IEXT_ADD_NOSPLIT_CNT is a good idea, but it
seems like that is the minority opinion.  The rest looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
