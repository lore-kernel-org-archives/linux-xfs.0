Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF0CC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiEJJno (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiEJJnm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:43:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6DE3123E
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6pCUSkhQfb9XN8kXHEfcYZn3N4oxKylkEA0GNPYtwvs=; b=0wHlP9/+EiT0zMPMcrXLS3v7LA
        lz3hJb460AIoaZnkcmKKw0k2Qs7t/nRBV4sUkKkc1mBDOkhKWukDKxTh3f+804YjOoPwKgDg7hFhK
        d18USmK2qFLu4T28KAekFbR2s8hybAaD9V3pQ5ZaMV2iABtplzYVcjDbiAqmuw/OPB55obyg9WT7e
        p0hQd3Zoh7mOsFYpDTYJd4BIjqmWDOVKRcqQrC5IBvJAB1U7utwfT9GKhK0mR3LJKdh2FSzGCviWY
        6M3aelo2ECMtbM3hUruxATgXFG+S0VSesz9mUauYplgQoRQv2attfz0+r0dZKbiE0NI2eT707vOCO
        OUEULXGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noML3-000tTM-71; Tue, 10 May 2022 09:39:29 +0000
Date:   Tue, 10 May 2022 02:39:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: warn about suspicious btree levels in AG
 headers
Message-ID: <Ynoy0QNrsEZZBfbI@infradead.org>
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
 <165176666532.246985.13522676978486453410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176666532.246985.13522676978486453410.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 09:04:25AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Warn about suspicious AG btree levels in the AGF and AGI.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
