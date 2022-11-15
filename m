Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51815C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 08:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiKOInx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 03:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKOInp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 03:43:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A4D5F9A;
        Tue, 15 Nov 2022 00:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ElXZRhGP3GQflFU1XjOBU4jVMW39dMHXe/t4ltdVZVg=; b=Fgwh612BHfQstmzzl2mPqObJS7
        RxBuLPKPlMKD38PkN2yUtLNhre3avUb3c0fA+8eoXIMT3p3mWtkPGeYiO+LKPTnRHVoSC46sKn4Xc
        JO/UtCcNyg1Tuzyq6mvQ0cfXmvp4jQjhN2A6/5QvAJ230lLlPQEh80/PQeu5Fa/V7d+2864uOtbg+
        QDxQugNjx/4kVEDqmogpcDXhkmCrmG1O4/aIRcrHhcKBZ0gpTdlLKO8u1Vt2xZ+km3ssKQQxlTlce
        OIpPgbFUk5iu6joO95tb47+aegwrGTbBevxz5sijZIPXgF1KuMn7FSSXBP6M1gcvw6Wk0xiTkOok3
        qyqwiWjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ourXj-0090ME-C5; Tue, 15 Nov 2022 08:43:43 +0000
Date:   Tue, 15 Nov 2022 00:43:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 5/9] xfs: buffered write failure should not truncate the
 page cache
Message-ID: <Y3NRP3s5FLoAtYDP@infradead.org>
References: <20221115013043.360610-1-david@fromorbit.com>
 <20221115013043.360610-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115013043.360610-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +static int
> +xfs_buffered_write_delalloc_scan(

As pointed out last time, this is generic iomap (or in fact filemap.c,
but maybe start small) logic, so move it there and just pass
xfs_buffered_write_delalloc_punch as a callback.
