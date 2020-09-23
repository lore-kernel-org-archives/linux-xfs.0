Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED70C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00213206A5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 07:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NjdNP9cY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWHFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 03:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIWHFq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 03:05:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A0EC061755
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 00:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+4/MCDsw7IwIC03S0J3BVRIA4eFR8FC6TtOmFgeno10=; b=NjdNP9cYRG66ubjUCWq/DNtG3Q
        DqIC/NhbI2qmK0R7CJGV1sb4yrwRlxrtzDXy6cBwDL8t/I4/FQg7Ngj4xz7K7WwLerzkZtiTkkThO
        93WqGmn1hm0isrgWjZwhvZDeGPaxljBYAYpLH42PINRH9TdWUUw0jK0s/o8O8L2vdIBNVjuZijpP0
        Wa6Z/AEpdF/WqKMes12YELDOgNur6uoDhgiZt30h05brHNei+NkgaM2wIAoooX+fBlS1kOWOKHJGG
        nYthOF8dV6d8FvUuaOP1ha7AZ6ApQSUrrDclj7jQVikitS4emZmFzOtgjNlf2Z38uf/rNX3P6z48V
        ClFvctZA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kKyqV-0007SG-RO; Wed, 23 Sep 2020 07:05:43 +0000
Date:   Wed, 23 Sep 2020 08:05:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200923070543.GC25798@infradead.org>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922034249.20549-1-hsiangkao@aol.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> tree"), there is no m_peraglock anymore, so it's hard to understand
> the described situation since per-ag is no longer an array and no
> need to reallocate, call xfs_filestream_flush() in growfs.
> 
> In addition, the race condition for shrink feature is quite confusing
> to me currently as well. Get rid of it instead.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Yes, this is all very outdated with the removal of the realloced
ag array:

Reviewed-by: Christoph Hellwig <hch@lst.de>
