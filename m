Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C941EC05027
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Feb 2023 08:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjBNIQ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 03:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjBNIQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 03:16:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A503AAF
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2023 00:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qHLxKmPgeGKrU1P1l3A1Dv3Xak
        9FrzEVXodQHF8NoIUtUOQLntM5bWZoA1gURVg8bCS4ErF3nCi+kdslgd+PtPjwtrdUEnMGFEaj64A
        9DT6ptq5IYXgj5lkvMwJpxnD2tZMSn2DOvcK5xCiiwWlUzwkQJrBJEAo/gd/15xju/POkhiUKSylp
        HCxj5T1vSWUs+N0dFZF73lqEsWkswGY9K9nIAZNBsCCE4OyD2iQ9CTtWi84n95t8ffFZ+wVwAPcIN
        rJReH0w8MwcKtqKgbtjVTApuh1h0k+F60z5DDcqIBL7ImJIPryIwzQ1XiHEhWktG7DV9CB9F420Zl
        oVe4aZUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pRqUE-000VgE-U3; Tue, 14 Feb 2023 08:16:26 +0000
Date:   Tue, 14 Feb 2023 00:16:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arjun Shankar <arjun@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Remove several implicit function declarations
Message-ID: <Y+tDWgA582phoqoo@infradead.org>
References: <20230208094333.364705-1-arjun@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208094333.364705-1-arjun@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
