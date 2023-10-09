Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4BEE95A91
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345755AbjJIKiY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345916AbjJIKiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:38:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D7999
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cal90MN6wlRIY1Pa2+OdjHITxu
        4kCNksJBrPHHLd6YPGN8p6p+ub8OECkKcqNG5sDNgGY0MLar4cLhaa/3Qg0EzSpFM/XBX2G4ja+uu
        Fkx2noZZTkrOmxXp7SojjtNxSPnbgA8cnEnD7cvkYKL5ZrW10fNGleXqOC8qylmyDIRiH2kvpokzh
        waj+7quEc4O+8Pw4lVOp1F94m6etdouHp4HyrItGb7fFBeRM8gBBIlH8w29+R26Mk7ci06sUrlk62
        RiBqYbLi3OARB14Y84ODp8Exjuw2aeNOsUrhYD5hDmoFS37boR7GTfkmDnBrQ2vbeM6rl87otQGzW
        eLFjdsjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpneY-00AH4r-0F;
        Mon, 09 Oct 2023 10:38:22 +0000
Date:   Mon, 9 Oct 2023 03:38:22 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 5/6] xfs: don't try redundant allocations in
 xfs_rtallocate_extent_near()
Message-ID: <ZSPYHvJfN48eDuPX@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <86972d508f56b562e1e2dc728a5b22209b56eba6.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86972d508f56b562e1e2dc728a5b22209b56eba6.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
