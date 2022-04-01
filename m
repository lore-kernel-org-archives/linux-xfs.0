Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660E9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 12:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbiDAMHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiDAMHb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:07:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C1141D8F
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=q3RcPYKeHz6+fh1I1FwAG6VL1L
        VDKrpLHj+JMqUctPITGwoP4wli8EG3cn/iUmAUmNu80YXhW5brD7drVDWGjs51cVJa3vhgfo10xhn
        lVNcOWDav4/Sb72fI3t2+av+RzOq5JJSJS77cWTCrH2AS1HMipZQYXY0Tagjn1NVdO67OOplMaFHK
        b5tfBIgJZ6TAbzZZMienM1kB3TKq/cs9yRqL8n1i92/9KvyfthTGQlISfMWCcTcV6MklBWO/d40Ig
        nzEhBgO5cbRyCUyJsn2Ii7QDg/JAqtDHBlHCoeON9Pzr8X3Sea6tetgkabiSlGATrQqhKIGn7L1Qz
        bOQb5IaA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naG2A-005YZZ-Ae; Fri, 01 Apr 2022 12:05:42 +0000
Date:   Fri, 1 Apr 2022 05:05:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: shutdown during log recovery needs to mark the
 log shutdown
Message-ID: <YkbqlpYULP09XJ8h@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-8-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
