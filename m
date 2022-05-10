Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D566EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiEJJkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238994AbiEJJkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:40:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384A2140C1
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4GbzTAMdWtaVD4OIKsh+Y7xO3q
        mIQqLK9ZIoh/kb0ENAM0oBho8mqAWgUDQDewLQg7kzwaIcDL+2qSL4FGw8gyJ3QsJmsVZN02+rwf7
        9OIHOqwjLIuwSQtlCzTZR7AxH+14uuuSj7EtFhONI0ft6M68YZ9ZlipaKDnvjrTZ9D+5Ef0P2CqA7
        EmvxAFurOMD6Yc0CKZg2dsxIs2DHDgERiLdf19ktpz+2cvgwsLepssfvBf5b+BucO7FpmSljmw0Zr
        91qJqb0XXU/v9AsqVKkBzyYcT6vEFdz82IXux2eJWvzlrPlNJeydbnNpU0A5UwwyEwPNrcHAXDfVX
        Fme6OnCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMHr-000sA0-3H; Tue, 10 May 2022 09:36:11 +0000
Date:   Tue, 10 May 2022 02:36:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] debian: refactor common options
Message-ID: <YnoyC2DF9vZtBopT@infradead.org>
References: <165176661877.246788.7113237793899538040.stgit@magnolia>
 <165176662449.246788.9880873924749991016.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176662449.246788.9880873924749991016.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
