Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F73C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 06:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbiE0GU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 02:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiE0GUZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 02:20:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEF566FAF
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 23:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eC2UPVf6mKQ+YCN7fGdoRa5r/N
        5nlyqog3uQw4xUUt7mMn/7Z9M+JGNUdq2U2itgXDU+WL8DuT4M5Nim6FtzZRVAHmzQ6ca2Z/4W7WE
        sKzC3gHuF2NSmkiJ+MW4OUgPmhXQW4wk3ZUCfuQK0xOxV52fUTL0bXFm7DomvqVyZHR4Gtihm8F0U
        wUNvr0+jhGqn0Ktq0bJE5Z6zRbI8qkl/GRzfK3c/Pq0AJOjf1AG5QPN1jpyJD/b9lrYOCAA5tWlWj
        egf2gEEmS+DMJhE4zaTy0PoU0OaZQF1Ld6OBRNytRFFBYFzLNL64QKN9JkdTCraHfxCckHKGdzrL0
        vVQxX2Hg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuTKg-00GkR3-GQ; Fri, 27 May 2022 06:20:22 +0000
Date:   Thu, 26 May 2022 23:20:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_copy: don't use cached buffer reads until after
 libxfs_mount
Message-ID: <YpBtpvRMxPYOnPI3@infradead.org>
References: <Yo027/k+vAYsUt4U@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo027/k+vAYsUt4U@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
