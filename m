Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A72C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C17B2075D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 08:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jmy/9vIa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgGNICc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 04:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgGNICa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 04:02:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2318C061755
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2020 01:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dOep25eypm/LbmmkHebtVDdf4NfFn/MqG0GosIHRH8s=; b=Jmy/9vIakdSgwRj8j6rO2Gud8O
        OPf6YLbw0TGWbG4xtwdiwWem13APs4czBgjsdtCGvltPVbEFknT0P7lEvM5dkHixkhbxfZpNJWP0H
        edJCDkk9bR3WiBaZ+kZFNbpYLaTvL8hYqTq/5KbdZ0GnvoPsyDw1RIgoMnKLGdqkqu92+uOm8hz39
        HTri4U6PE/ghYJRQxq+72FRBoFebn/GGQDoPyWxgqd+5ANRitemBmIWTub8XIeqbHI/GzkvhJWNr7
        XgBcunCzvOW4zGQ2TUg9tHrIZSrKdoz7UT/gw2lcgl6duy8huTmdsiRBuc3uwCG9sJd5ACgg855Qt
        Ug0lfhWQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvFtU-000748-7A; Tue, 14 Jul 2020 08:02:28 +0000
Date:   Tue, 14 Jul 2020 09:02:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs: refactor xfs_trans_apply_dquot_deltas
Message-ID: <20200714080228.GH19883@infradead.org>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
 <159469043599.2914673.915627794419668814.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159469043599.2914673.915627794419668814.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 06:33:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the code that adjusts the incore quota reservation count
> adjustments into a separate function, both to reduce the level of
> indentation and also to reduce the amount of open-coded logic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
