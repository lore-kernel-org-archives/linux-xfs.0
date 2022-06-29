Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B0ECCA47C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 07:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiF2HmJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiF2HmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 03:42:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0257E36B77;
        Wed, 29 Jun 2022 00:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=r7WsRDgofYFc1O1ruaM4kGDOQt
        fBRrB1gAlAwt0RDAr6zhhZZUFB5o/OPJ9E70v34LPjSVPHIUIQ8b4GL7QB2VOEHUHhG0URUQDk1UW
        vmTFgKNOnrZBLtVxfzeYdIHw0R856mb784GsXIMMRjP2hiQCX8mrd/OGrH/ZnnDw7E/0mn054ut0Z
        VGOYsEF6oX/L0QnvlNGOCPXX9cattN8MoOe+pS887BemK/jZt6REVB1lxBcOuOo+reWnicaks1DJv
        /lUYsGdb9wiImg0lC7JT/8cmyfz5OmfeR/E881t1Sm1el0YTxXhQfQSqSpxjU7EFdphAO0HLn2I4P
        Fm+RSd0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o6SKj-00AA8S-Hp; Wed, 29 Jun 2022 07:41:57 +0000
Date:   Wed, 29 Jun 2022 00:41:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/9] seek_sanity_test: fix allocation unit detection on
 XFS realtime
Message-ID: <YrwCRakBCIRCZ027@infradead.org>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768327.1045534.10420155448662856970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644768327.1045534.10420155448662856970.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
