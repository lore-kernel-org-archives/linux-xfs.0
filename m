Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD79C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85B764EBA
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBIJM7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhBIJKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:10:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C35C06178A
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3LcDqhMSYqRj+PdYrgEz7OBf9v8HCc4h8D6/p9c+NKg=; b=eKf48L2tucv/Wvmrdbp9/fdGOV
        H+TFAAUIt4nTe0X1WkBrf6ibtUoK7nrewp+z0ODT0qxY+E2ny5usbodI6nc6KNnfE89/CjFsy8QLi
        Yyu+/bceufiRhziBpD0ApdgNFl+zdCx97cJYVEq9yd0Rany9cQByY1+dHKhK8V3NUgFkfLBZJlk8f
        PLYdsGti3bMnNY4NRDsj58GSVfCs/TEzKJfSY3IdMyfOhkfT+udLv7TO5Cx4Zrt/4joEUYxJLbWEL
        OJ29BRgNIseKMzxmquRgf/V6DcLdLKL7o/zKpNQnxGSXP+gjhQy3QihKNKks/g2jBLiJiJolHLdyr
        jmUF+p+Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P1h-007D6S-04; Tue, 09 Feb 2021 09:09:41 +0000
Date:   Tue, 9 Feb 2021 09:09:40 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 03/10] xfs_db: support the needsrepair feature flag in
 the version command
Message-ID: <20210209090940.GC1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284382116.3057868.4021834592988203500.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284382116.3057868.4021834592988203500.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the xfs_db version command about the 'needsrepair' flag, which can
> be used to force the system administrator to repair the filesystem with
> xfs_repair.

In the "version" command?
