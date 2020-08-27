Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB27FC433E4
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE16120786
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o+93I13/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgH0GpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0Goz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 02:44:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12AC061264
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 23:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+WO6Fm+8Hyzl/L6d9uFSDDyOx3YD5o0eBKin6TusRtg=; b=o+93I13/+eqprTEDxVNXwMtQ09
        VJ/83Ry9ztrEBT67te8wfFMXwgVVt5hIR5yVuoLDwMBOyqF0zO4CseT6Uhuz4T0Uq6PshNGfiJl5G
        4so8JshqxCgDZ9EUe4b1dTq5JGWZumAA9MSwrVCYXxAL4itTzmiItWhZZirnsR0p8YcOZLHEUObR6
        Qrps0Jfnu/scPiz0GaFCC2kz00Gp69i2PE2uMbpNWOBHiAtX4+NSk9W4Gis/lopc0shbpR2MzQZDb
        89WPlKHaEsueesDyN7lIyOWesSYqebqsGEvG9PSuMXjPA7YUMv+A+XZNH3/bN/ppSdBjSUeHrBvWF
        Fhz7j93Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBeV-0004Jr-QF; Thu, 27 Aug 2020 06:44:51 +0000
Date:   Thu, 27 Aug 2020 07:44:51 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 04/11] xfs: refactor quota timestamp coding
Message-ID: <20200827064451.GE14944@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847952392.2601708.833795605203708912.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847952392.2601708.833795605203708912.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 03:05:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor quota timestamp encoding and decoding into helper functions so
> that we can add extra behavior in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
