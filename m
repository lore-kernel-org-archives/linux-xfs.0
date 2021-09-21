Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4812CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5A76115A
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 08:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhIUIwA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhIUIwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 04:52:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B270C061574
        for <linux-xfs@vger.kernel.org>; Tue, 21 Sep 2021 01:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ci3ggYigIUOwULfLWAJaDmJUHSyQGq6r6osAAx/Cqjg=; b=b3uF0GbmLVzjXiyXa6bpSVGtrI
        BFPK6ukNx6CagEdSPjrQyspxlReeHMSCe+oRETgQaOFIIn5IiwD5huHGskfCYlZjmJ7usXNLwxdp6
        vbbL+K1295pZIdoxTHwAY9J/Ao+cvytPucyiJOqzXIgAZQwytw/leQAkYBFWM4jF6xHPmkck309N5
        o4cIZOjlt2iUJvwd7e+Ox2xiyccjvtZWC7sdL4UWT6p2TaBC15XR6OA0fJCPkwVd+G0rAaorUZlh8
        ybjd7PdRsdMG2kTrEA08Al7ZxbayyEyj1ld4fn2hzs25jkrldGl5W/4DBZENGZSb1Fnso0nMXNT9n
        6378ryvA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSbTG-003eLO-Ld; Tue, 21 Sep 2021 08:49:55 +0000
Date:   Tue, 21 Sep 2021 09:49:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: support dynamic btree cursor heights
Message-ID: <YUmcqkH9aOCBNjzx@infradead.org>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
 <163192858823.416199.17720760425094444911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163192858823.416199.17720760425094444911.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 06:29:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split out the btree level information into a separate struct and put it
> at the end of the cursor structure as a VLA.  The realtime rmap btree
> (which is rooted in an inode) will require the ability to support many
> more levels than a per-AG btree cursor, which means that we're going to
> create two btree cursor caches to conserve memory for the more common
> case.

This adds a whole bunch of > 80 char lines, and xfs_btree_cur_sizeof
should use struct_size().

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
