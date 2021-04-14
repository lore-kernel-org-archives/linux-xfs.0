Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EB8C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22DA611C9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhDNGKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbhDNGKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:10:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E40C061574
        for <linux-xfs@vger.kernel.org>; Tue, 13 Apr 2021 23:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Kze5Jkb0M56ex2P3cPmNvv0IP71E+ReG5XC4knVo2o=; b=W6jm9jtezU5MC54CaLciGJM5BL
        CIabNovRMKIK/k3tSJCZDHwcCRV8Zu3xcDXw73sXH2532F2DYcnbpowCgAgHLq9F7wnP/X6eTC/E2
        bdhVhvqTGhO9+oKFpr0wINLTXpTFegsT72OSD2nhNKG1fzuKyJwWXOpWtuyNV9fNPE6azpzFbatZm
        /VAyv9X9Sbn8I46xtjOvYHLB9FJ+L3E1Di7wmFJehsKim7DjfQCTAQ+sO1QIQXjIxENYclOPN+ro5
        gI6fLsJXqEN4GRQWE+DTkHVBKeUSbfQ4XNJ0/ykeQK/jRXYdpgcwfwV3PqNKJ4PGMPnE7vpHo9Zs8
        k8gG6yJQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYj2-006iy9-8E; Wed, 14 Apr 2021 06:10:08 +0000
Date:   Wed, 14 Apr 2021 07:10:08 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] libfrog: report inobtcount in geometry
Message-ID: <20210414061008.GA1602505@infradead.org>
References: <161834764606.2607077.6884775882008256887.stgit@magnolia>
 <161834765317.2607077.766491854638241008.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161834765317.2607077.766491854638241008.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 02:00:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Report the inode btree counter feature in fs feature reports.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
