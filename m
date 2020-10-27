Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61D5C4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83055207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hmtu7YZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829082AbgJ0Sr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 14:47:59 -0400
Received: from casper.infradead.org ([90.155.50.34]:53160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829059AbgJ0Srj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 14:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SSAr3pm/GoWYmN9wry5Kkk4PfLh3T9ECpxMpqi1Ju8I=; b=Hmtu7YZD0oYS7sV821KorscG8A
        ZSqLzrdV+Q5xiU7ffJ7yKCBEGny9YDjGGo2Kb/gSypYrYbqSqZGCrgByX45U8JciylZexb04cYiBQ
        1EwMoipOLAOCGo3Da8dWalMzx0bU4FZWP7kiqe1GSIZrYvyRYtHS5EzSrJ9g4I6K/ntnNh+CITVVD
        QnGFERhpzMAMrEViI/CFjMdltx2LtdSYZwHRh/xBUHcll70aN6t/ARitTX9GSq8LvdCjVQ/auUyx/
        wUET98jZjwJbvPTGY3ZYuC7FLzGBE0BqPbQOYtU1d1gqMuZ11aDe282hvvomgJ9QlWRCaDpUiwLlp
        ShEAuBdQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXTzw-0003ed-ON; Tue, 27 Oct 2020 18:47:08 +0000
Date:   Tue, 27 Oct 2020 18:47:08 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unused XFS_B_FSB_OFFSET macro
Message-ID: <20201027184708.GC12824@infradead.org>
References: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603169666-16106-1-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 20, 2020 at 12:54:26PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> There are no callers of the XFS_B_FSB_OFFSET macro, so remove it.

No callers in xfsprogs either.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
