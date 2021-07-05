Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F60C07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA6F61946
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 15:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhGEPYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 11:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbhGEPYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:24:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63975C061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 08:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ee+Ti5ZlG3IZgqmvPfYo0QiTpQZ2DQ3r45mKqth0FrE=; b=mUwqM4Fx56xp5X4Q3ucfLDEoSd
        pBQOOg/nAeSr/11aoAC8iCUc/7/Nrj+Dpkr0eFknFu80lpvt+oT41/zv332w5M7TVKD4bh/8Jl0bw
        7BuI8LdyDDj9vtx9QCfVxwqe7gB0X/SOu7Sn7TsRNAxhcCwS+O8OqIzGQVWfI/vn1uvSixHctiEFv
        70QKKv2x6b15RWBFQ4xThMdchJUUVUbzV+FdUx9rXtlBlYAbSqAlYKvTEl/0YbI75cskbdvUJFcto
        Gn7pyF+iol2INDa9mVrxPFVqFPz9mV+pIV2Coh9pYgHCxg6NYZ84mSgqtXtrOKuVQw0qdsdHaeneN
        6M331RVQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0QPI-00AM4W-P1; Mon, 05 Jul 2021 15:21:19 +0000
Date:   Mon, 5 Jul 2021 16:21:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_io: only print the header once when dumping
 fsmap in csv format
Message-ID: <YOMjaCYB3SgriazS@infradead.org>
References: <162528108960.38807.10502298775223215201.stgit@locust>
 <162528109507.38807.485600723669552708.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528109507.38807.485600723669552708.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Only print the column names once when we're dumping fsmap information in
> csv format.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
