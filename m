Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BD9C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbiDXF05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiDXF04 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:26:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B047B2BB15
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=jsSxg42gSf2ek+8QuMNCiLtk9k
        W2155qrc9fnlNCQoT27YrHBQLKy3VXMx4LrSPLpzfcguvUUtz2fKS1Rg3YHYfviGsMJ/9oouNbrZs
        8MW9tXg9sLLLBXLbYj7B9bn50S08gt0/Pj+zGxJ1UTxyKh8hxKIUO6WjVdDVWHgRf1ojzWUAuIKOS
        Jdfv3lqNxRUwkvSH/Om8P6pEM1xPkU96aCGlqr6rqifabNn1tng3H+raYi0sJCC9V7NxmtY5LFC6s
        2XYGm5FQkXl3c/3tj1v9fpowi9DqqD3zzZjxaSc3kv+ZzPXjwuw3Rhf3KjFFoXR5zOEtwXItap815
        6FngWMJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUix-005pDw-VD; Sun, 24 Apr 2022 05:23:55 +0000
Date:   Sat, 23 Apr 2022 22:23:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix soft lockup via spinning in filestream ag
 selection loop
Message-ID: <YmTe611Zqquo55tu@infradead.org>
References: <20220422141226.1831426-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422141226.1831426-1-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
