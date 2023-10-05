Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550B1E9270A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjJEOcS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbjJEOaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:30:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C71AD3F
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 02:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=rm75mMMkhimgA6RdV2Jh9lEIXL
        DWCTW0iwMyovsZ5bwCLU3FdrOy2vZSvdePZbmMikw9gHg1KilY76Vl/eMgdedxn2e1vMj6LX8peiq
        /eM9d7tmPvGGdOUiZDq3SDFhCVorfQSum7+DXrtuA6bytO+tgewGTKdyaM/uWSyy5E+B2L+9rxhH8
        dhfc/rSf4AxWLuko0vABDBfJPNtJvO7uRlaXoPaep1uAl6eW+fDSZ3Ibo+ExMMOsh3kCED74bQZ9Z
        3ZNPmhswe0O1GYGLWAoUhurR7nstGaz+RxgAVgG1hF9DfZ0MjedOKKCW/uM5Qg3TSf0E4UuroaVXp
        MR1++V9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qoKsv-001mqR-0Y;
        Thu, 05 Oct 2023 09:43:09 +0000
Date:   Thu, 5 Oct 2023 02:43:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 2/9] xfs: contiguous EOF allocation across AGs
Message-ID: <ZR6FLVKwiGI9ALm2@infradead.org>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-3-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

