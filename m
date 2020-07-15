Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC948C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58D52065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:47:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ohh4IN9j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgGORr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGORr6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:47:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5D3C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rZcaOUY9uGGXcfRUAp7oXAt6antcpXFVWRy2VVxNyBs=; b=Ohh4IN9jqsGPE+uDDKJWZvw3G4
        wGEJgWkA/5Ro/avZm8GHmcONpHOo+WlcqPt/96+WN3Io7fUe7i0cA3Grz7eaHYIQwqDRbt3Dg3X8Z
        FrOaijGIUmxkcOqvS7vqljHMg6NxPjrutxk0ddf/Itl1JH4YfMOk+VBANmbT5QxqZ/TL8UPiGam0u
        TaO1VCrNSICJiVT5KRwgTzh3wMJjjKMF+Tv/BfcY6Qvfn5wmMHrxUjFVoqaYgQjXgh7Nfux3y/79I
        BIqUFj9nmpznBoBZEqUpVqDfKwO6d6pydcM7CAKyd8txZMPi5fbHwhsJC8rIUkZIIUtpDxhgNYnWA
        ZOxs4PTw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlVb-0003bo-5x; Wed, 15 Jul 2020 17:47:55 +0000
Date:   Wed, 15 Jul 2020 18:47:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: fix clearing of quota CHKD flags
Message-ID: <20200715174755.GE11239@infradead.org>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
 <159476317959.3156699.12804674592240361133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476317959.3156699.12804674592240361133.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> XFS_ALL_QUOTA_CHKD, being a OR of [UGP]QUOTA_CHKD, is a bitset of the
> possible *incore* quota checked flags.  This means that it cannot be
> used in a comparison with the *ondisk* quota checked flags because V4
> filesystems set OQUOTA_CHKD, not the [GU]QUOTA_CHKD flags (which are V5
> flags).
> 
> If you have a V4 filesystem with user quotas disabled but either group
> or project quotas enabled, xfs_repair will /not/ claim that the quota
> info will be regenerated on the next mount like it does in any other
> situation.  This is because the ondisk qflags field has OQUOTA_CHKD set
> but repair fails to notice.
> 
> Worse, if you have a V4 filesystem with user and group quotas enabled
> and mild corruption, repair will claim that the quota info will be
> regenerated.  If you then mount the fs with only group quotas enabled,
> quotacheck will not run to correct the data because repair failed to
> clear OQUOTA_CHKD properly.
> 
> These are fairly benign and unlikely scenarios, but when we add
> quotacheck capabilities to xfs_repair, it will complain about the
> incorrect quota counts, which causes regressions in xfs/278.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
