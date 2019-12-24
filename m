Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0573DC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB042053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k++CGxNd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfLXMCs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:02:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60586 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfLXMCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BngKSJCPbP8knNxATxMgnaq1UH5OMXHWymEGrzsjAMU=; b=k++CGxNdrgT5hLb5Nyxm1Q0Bf
        G85vaMhJ1usNDzW7tmbi6ULZ/TLyDG+3WrICnO1/0E+2E7fEjji3oFvL8sqytaEsvZSu2EBYMYBsy
        5v/uKZIbpEaYzoWxPL9ezPmR8yZWV2lm53Uox7Jyxbx53C0RYQHdMHbAY+DYInhERccaDkbq+RD37
        MGiWO42hiX93WTj6ARdouaZjcDnNN88Qd2YeDxJ+Is0IbHlzldxuHlYsNsqG8X9S7xNQbtJLdbB7E
        zGwSEH8lPAHfYSfyEKACXKUcaqnj4dA6Rzd2x6JqZSZ6H/1zofcp4mXWZ7h/ZlvfHl2TZicQJJOmk
        ZjXu6l9nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijitk-0005oe-40; Tue, 24 Dec 2019 12:02:48 +0000
Date:   Tue, 24 Dec 2019 04:02:48 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 00/14] xfs: Delay Ready Attributes
Message-ID: <20191224120248.GA18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-1-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So as seen by the series I sent I think the existing interface to the
attr routines is pretty much garbage, and this series doesn't improve
it all that much (but at least doesn't make it worse).  Can you take
a look at my series to expose the da_args to the callers?  We could
still embedded the xfs_name into that on top if that really helps.
