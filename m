Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF5BC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD3613C4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349189AbhDNGSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbhDNGSn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:18:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F1CC061574;
        Tue, 13 Apr 2021 23:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kQfun2g5Z4Wq8DzNNyZuKC4eZCZZZDhWNK9o1a8ngYE=; b=rTFPhWdz5w5QBRTR9NGK8Ow9tP
        41xK/Y5wh6dC08Cptyfz1xaxY/aCsycEFSEmw3D4ZotalYVTjxHVmzfgu22CnLe+wyWubHwLvA/A8
        pBtVNzI+YGPKwZLZTS2iCzZ67DsNtmBHFcpyT2DWeOo14O2A+OyB7hzQtEJzskOBvF8B3mYNuLEX1
        VkxTGJVJRx1pdcs00l3bkWP/c24Yky8Eg+CMWCORvhdHBLXufQAWFBdfzRJzcvjsIVqX+CaX9OJ1I
        o83jQkGLXuSrHJJSp3ycjl6dm6fdLfvvjNKyrEIm3ngvm/h8cOpy7Pn7vaAb3NGNPVwppyvSrV3Nl
        Ljy7Wmgw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYqx-006jX6-1p; Wed, 14 Apr 2021 06:18:19 +0000
Date:   Wed, 14 Apr 2021 07:18:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 6/9] misc: replace more open-coded _scratch_xfs_db calls
Message-ID: <20210414061819.GH1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230786.2754991.7641118311374470635.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836230786.2754991.7641118311374470635.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:05:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace the last remaining open-coded calls to xfs_db for the scratch
> device with calls to _scratch_xfs_db.  This fixes these tests when
> external logs are enabled.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
