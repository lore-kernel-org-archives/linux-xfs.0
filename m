Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7113E95A8E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 10:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbjJIKj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 06:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345957AbjJIKjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 06:39:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFC9AB
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 03:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EaO+BqA5hjw+lPs8th5fG4tJdggaQUQn2y4y0/hLMx8=; b=AukToB/MPaJG204pH89nsy5Ins
        A4NzmWN1dIXLs+TJh2HytMDqk6QVOTCOhLV5297xG8igLK50/4+ami3mmAQ7bpfOm4+SknkWnbIcn
        tk3yzJTkdWataw5vWQ/t/zzU7mB8FDHO54cSMlLq+I4klT3jIrUYnL7CEw9RBw4I6pB0ie5jp65y4
        aiKd6RPW7c0q797LKcm7hyx2c04BtNNLYxo0Vw8rURZ86GOc26bL69u9cL7UTIjxeWDx5+APLYcOV
        qQKEUi4smG57mhfacRR/kTjpxodmpVyUtI0ujR+3TtOkFhXbmACC2tWR1qSD7vwAdO8VgjwsApaii
        bmWGfyJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qpnfX-00AHsA-1P;
        Mon, 09 Oct 2023 10:39:23 +0000
Date:   Mon, 9 Oct 2023 03:39:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        kernel-team@fb.com, Prashant Nema <pnema@fb.com>
Subject: Re: [PATCH v2 6/6] xfs: don't look for end of extent further than
 necessary in xfs_rtallocate_extent_near()
Message-ID: <ZSPYW9mOy/PA34xD@infradead.org>
References: <cover.1693950248.git.osandov@osandov.com>
 <44220273fdbc442e963bed1cfaa4707957b49326.1693950248.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44220273fdbc442e963bed1cfaa4707957b49326.1693950248.git.osandov@osandov.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 02:51:57PM -0700, Omar Sandoval wrote:
> +				if (maxlog == 0)
> +					maxblocks = 0;
> +				else if (maxlog < mp->m_blkbit_log)
> +					maxblocks = 1;
> +				else
> +					maxblocks = 2 << (maxlog - mp->m_blkbit_log);

Overly long line here (can be fixed when applying I guess).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
