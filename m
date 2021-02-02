Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA10DC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 07:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B83364EE2
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 07:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhBBHFj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 02:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhBBHFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 02:05:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D7C061573
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 23:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X+deC8gTM8ejnVdglhqXFnrcy/4bdgA5EFVS/hKVb8w=; b=DIklQPaCB4k+6NQ+FkHmGKNbZs
        De+hlNJjrS2J8Bjz9OrdhgQNhzQHOSpn9ZmHrIBoU+LICV5+QeRgw3D3Grm1oKZqmbxFK/qdig6AN
        WfNV/A0mV2ULvo3O1Rk67Xngx9oLBYzsuau9jB36Y8STW3jEzMZU1ClkVfuVcOhAkrn5xsFXYUiIS
        3+h9mGIOSmoyAL5L3jauHgk7cduRW8sx8SZpqOjKSXHKcsPWKZiL80MU7lRprHz3sn2FUl0KzY+qb
        auL0Bj3AKqbwdwquP8lTzD3a7h2vxbo05zn2omjJ/SwK5UlyCyOs85nycIouHbaOk1pZ8dtAACm/1
        rQEaqaPw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6pk1-00Epyq-IV; Tue, 02 Feb 2021 07:04:49 +0000
Date:   Tue, 2 Feb 2021 07:04:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 13/16] xfs: refactor inode ownership change
 transaction/inode/quota allocation idiom
Message-ID: <20210202070449.GB3535861@infradead.org>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223147171.491593.1153393231638526420.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223147171.491593.1153393231638526420.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:04:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For file ownership (uid, gid, prid) changes, create a new helper
> xfs_trans_alloc_ichange that allocates a transaction and reserves the
> appropriate amount of quota against that transction in preparation for a
> change of user, group, or project id.  Replace all the open-coded idioms
> with a single call to this helper so that we can contain the retry loops
> in the next patchset.
> 
> This changes the locking behavior for ichange transactions slightly.
> Since tr_ichange does not have a permanent reservation and cannot roll,
> we pass XFS_ILOCK_EXCL to ijoin so that the inode will be unlocked
> automatically at commit time.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
