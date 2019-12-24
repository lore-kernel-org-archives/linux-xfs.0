Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C424C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EABD206CB
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 12:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lgetvSGP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfLXMZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 07:25:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40266 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfLXMZy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9ExbLWnQAdfwdITo4h7o9/QRRmDkvM7YirGagBTb3CM=; b=lgetvSGPdaWV855QZSyHk5m1g
        +FRQ6m8StgbLGEH0k/UterCi9EsIG/YvHd/getfuZjoS+OvQXvyEv/3b1DG+q/34q6sgCBkdufXbZ
        cnZInmZUbs05AVGE4vTu4MvluBqBkVjZFxrZ4A0ZsbjfGMIEYt5VGA/Baq88gs6dH7nzHizqBZ9n4
        phf017MN6X+HjoOuohYzov47UmcDktxjyaway6/OmQoTVxSkzYOUbZ0X5HYcbldZfiEhIwEXnT63D
        TPDJudKzvowmBh6HTgqyrbqH6FlYvARvwktxmDnJCvijwGnQOGMFb4VKy6YHlZcatPXjXy8Wuu+6p
        IkjtKgORQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjG6-0006o7-AV; Tue, 24 Dec 2019 12:25:54 +0000
Date:   Tue, 24 Dec 2019 04:25:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 08/14] xfs: Factor up xfs_attr_try_sf_addname
Message-ID: <20191224122554.GF18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-9-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 11, 2019 at 09:15:07PM -0700, Allison Collins wrote:
> New delayed attribute routines cannot handle transactions. We
> can factor up the commit, but there is little left in this
> function other than some error handling and an ichgtime. So
> hoist all of xfs_attr_try_sf_addname up at this time.  We will
> remove all the commits in this set.

I really don't like this one.  xfs_attr_try_sf_addname is a nice
abstration, so merging it into the caller makes the code much harder
to understand.  If that is different after changes to the transaction
change it can be removed at that point, but merging all the different
attr formats into one big monster function is a bad idea.

Also Factor up still sounds very, very strange to me.  I would
have worded it as "merge xfs_attr_try_sf_addname into its only caller"
