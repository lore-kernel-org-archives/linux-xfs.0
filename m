Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACB7C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223C564E16
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBIJbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhBIJ3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:29:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5495AC061786
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XK14/rSuSwL4AMjBzbB/dqED5V+vcm/1ES6ddorKP8w=; b=QrWvJdVoOOMKxijNFUhkWgZnlM
        RJKNidPZD1ZrLjQjKMjxJM/qm02ZTOyKdM2tUJbcBQeqiFn46sEvD8gsgfzlpDCgzb6zcyC5qQYHe
        GncLOo4gdI+sXgjacSbZ65jtuss2mBRLMdLeCexXmukSemzNRbJoHNCStKIhud4SmTIsElP+EGruD
        itTXI9WdqkEUe0tVLesXi26yJ3vwiJVB6Dr/sa90ibk7vaPRPA+Xd5zlqZjXiC1i1no+uy31DGdkw
        j2hnB9Mf9Gh/OFhW56Kn7Pg6vX3yG+qRgbW4TRQqyOK0IY/vF8Tr39jMzISiTp+V0wshUArvUfpP2
        RWsBnlGg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9PKI-007EWu-6s; Tue, 09 Feb 2021 09:28:56 +0000
Date:   Tue, 9 Feb 2021 09:28:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 3/6] xfs_scrub: load and unload libicu properly
Message-ID: <20210209092854.GO1718132@infradead.org>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284389311.3058224.3454694766420244067.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284389311.3058224.3454694766420244067.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we actually load and unload libicu properly.  This isn't
> strictly required since the library can bootstrap itself, but unloading
> means fewer things for valgrind to complain about.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
