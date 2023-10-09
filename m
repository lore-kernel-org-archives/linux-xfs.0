Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E2AE95A91
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbjJIKfL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345759AbjJIKfL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:35:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AE79D
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4jTzaKE+Y8u3yrOTTZlyPfpqXU
        8yuGa4BWhEEh6/WnTUCS4Pd3Q6s+R9kZBnBLbOJQyuPas5lOZHClONoF9o4nrjocElvgxR7fsQeJp
        yPEJi/Jxzd6/12kBmPpjGNb8cvMcH45gyTEPn+5wRRcd5JO1RrsFH9A8uatSmWoSbcbNa+L9ve+Ok
        put/P4vrqJbzlDegarE1RvhRjqI2Zx4rkaUaTA3JGddnGEPf4zDm84fweOjHtRFSesWJGjraml4ig
        pPT6gKo6VkSEaluXDuilGN3952nTiw2GHCnHtQsRJ+QAdzm5QANwfhYwxKY7kbYoo+iXpOdYxnIvg
        AJjhAZyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnbR-00AEqd-2n;
        Mon, 09 Oct 2023 10:35:09 +0000
Date:   Mon, 9 Oct 2023 03:35:09 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 2/6] xfs: invert the realtime summary cache
Message-ID: <ZSPXXVauJ1qrJ9a6@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <4fc64e22c4c8d21904114ef968058e9a73af7d20.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fc64e22c4c8d21904114ef968058e9a73af7d20.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
