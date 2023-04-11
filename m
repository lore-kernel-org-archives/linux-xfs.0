Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B90C77B70
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDKEw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDKEwZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:52:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02911981
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZQs5MBe/7M9PWyWD8oj3+gB7Js
        p9K9e4i5oxpMiyR/YMZPumUBunTXy6JpcH1SueoVvXP/8Fmll380fJh1HPxXbb3qWulyUlZR78/9i
        03ntndjKdj0KszPZltlw+d1AcDvkum+7/jEPZ8rizRaYV+RciT7p5u7qMnnuJ7nnzHA136TZ6n095
        SaiZJVcXeIhQbXN24AXQrrVyPyuPCc0ovLqI9bECkyyRhK/77KacroLdpkqrTodWBt5ceaI8HROGj
        HUX6gxDSqtS7DPVTcEgTqfVJ7pJU72LOS5B/LT3MOfpuQfZsgJKqS3uWZRqPbSRmQmnZbaCjI6Cx1
        YvPWufvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm5zQ-00GPjH-1i;
        Tue, 11 Apr 2023 04:52:20 +0000
Date:   Mon, 10 Apr 2023 21:52:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: deprecate the ascii-ci feature
Message-ID: <ZDTnhIGVKD7z82OL@infradead.org>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
 <168073939615.1648023.11626629628611950172.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073939615.1648023.11626629628611950172.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
