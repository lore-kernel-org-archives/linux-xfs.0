Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F97BEB64D7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 03:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjFZD4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 23:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjFZD4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Jun 2023 23:56:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D38C1B1;
        Sun, 25 Jun 2023 20:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MSWMWCd0byTrNHbSK/N1bhf0LnYGkMThKJt+8R8h11A=; b=U9Solak43lH5neqs+YjeuS0nWQ
        xFg2kNqaF26r7swdIf8Uf6Mou2or9DVmFgjaH3YmhK5Qs4XpDIM1SGKKGK+G45/1dAuiHNzYZDIGH
        F/tTCGM+t/TSkHzvsP1bAH/NZ2X/EECqiwI77j18/fbhOkrd4OL4VM0WBxsVslLzGgNHND7HP356s
        m9p9uwD+mHcehKT1Vk9XDicvYNvh69ig1BOQOQtmCzOEdhygjhQCQWt8VMp/Tzjjlpu6YDMuM9wtN
        ODJwjIt6XOfmNJBBNspQpfFUlRI/HlvHcnBO5jePecRZP5m0TAUZzo9blS/nHx6fkWS41J+SmD9ep
        D3UQrNAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qDdJ7-001IpL-NT; Mon, 26 Jun 2023 03:54:29 +0000
Date:   Mon, 26 Jun 2023 04:54:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Lu Hongfei <luhongfei@vivo.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        opensource.kernel@vivo.com
Subject: Re: [PATCH] fs: iomap: replace the ternary conditional operator with
 max_t()
Message-ID: <ZJkL9TRyIfcnUjIt@casper.infradead.org>
References: <20230626022212.30297-1-luhongfei@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626022212.30297-1-luhongfei@vivo.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 26, 2023 at 10:22:12AM +0800, Lu Hongfei wrote:
> It would be better to replace the traditional ternary conditional
> operator with max_t() in iomap_iter

No it wouldn't.

There are two possible meanings for iter->processed.  Either we
processed a positive number of bytes, or it's an errno.  max_t()
doesn't express that.  Your patch adds confusion, not reduces it.
