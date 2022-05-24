Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC24C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 08:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiEXIPj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 04:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiEXIPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 04:15:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09EB77F02
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=z4CrjHvidQcQMzw3QYZqxrwMNJ
        pf8/QcE6C7Sf+luk60QlgeiRpgheu1E7JpgC2T8ml3of36TQXNCZqQHaZ8wHZSHNG3IIyWId/+Cqk
        qwl6+teFMzGS58POA6WZu15lQIyoicWZpszSihWlekApolGXJ6NxCcUT9JcjgnwHX2bGjVuVP9YI1
        KxlFacL9FU/pI1uMkPBpDGSY3/+cLH+HbOiH61Veb5r5RlowMJwpiBlrh/8ueQjSgzqlIGh9lgrxA
        /FqGqdPKv7jSkCJlfl+/hHGntvYhfuAVs2yFWpYJJxpBnDLw2XeiFVN+KIrxxQ//lfAqaCv9Z8A0e
        Wh3rgrZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntPhZ-007Dan-H0; Tue, 24 May 2022 08:15:37 +0000
Date:   Tue, 24 May 2022 01:15:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Subject: Re: [PATCH 1/2] xfs: purge dquots after inode walk fails during
 quotacheck
Message-ID: <YoyUKacGjH8nhEZ5@infradead.org>
References: <165337056527.993079.1232300816023906959.stgit@magnolia>
 <165337057096.993079.8431457282038063934.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337057096.993079.8431457282038063934.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
