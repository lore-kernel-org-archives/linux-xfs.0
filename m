Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EFFC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD07B206CB
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DUG0drFP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfLXMWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:22:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfLXMWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:22:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i48kqgKtZn/UVqBazzAH3I4HORtynvVpI7Zra64gYNI=; b=DUG0drFP1NZsMqppit3IHNUs8
        DH+DQmmhrrQNBcQtdRAy77YA4BwvCOsSqJvHIwRMEZLsksMnW8DgeZpQTu+Zmv7+YiyM/F8QpFUss
        lIwvm0lliNcMZnZZFbRzeSEoczr42F6Inq/FKOW/Vy/qufAjVLU87WNjpMWdY2biaNN4HbXLtx/7N
        pmoIzT/xVhQOZkl8+PznVnAUrG63H0Q0yoVKhW4r/I/Ik9x8b6+0RSLNrzXkov+AKwOyAexG+foaf
        QM51Ph4PB1uRjVqGDlY6Pb75xfzwriisIOxTZmnGJ5Fjl18oe/JhHDyqdM6yV+YMn4RF5PyrzGkx0
        TySY2hBlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjDC-0005RU-MX; Tue, 24 Dec 2019 12:22:54 +0000
Date:   Tue, 24 Dec 2019 04:22:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 07/14] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20191224122254.GE18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-8-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:06PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add.
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_leaf_addname that we can use.  This will help
> to reduce repetitive code later when we introduce
> delayed attributes.

I have a hard time relating the subject to what is happening here,
maybe because the patch does too many things at once.  One thing
is plitting a xfs_attr_leaf_try_add from xfs_attr_leaf_addname, which
seems pretty sensible, but then it also moves code from
xfs_attr_node_addname into the only caller.  That probably should be
a separate patch with a proper description.
