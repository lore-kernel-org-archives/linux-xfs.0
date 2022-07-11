Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9390C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 05:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiGKFZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 01:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKFZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 01:25:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F757183B2
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 22:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bFECVMyiTZfRocnQRiZrr3ZGQr9fuZUUdN4FjdUmWis=; b=ZbTzlU6Fp7an4MZATRD03DQLwv
        d6Bya2hIOiyNm1v1FMC9gZz+S83vGFyOS1d86mCM6NYvkojejDyLaISEEAo2S2mziJnV1LManJBJb
        at/r8nqEEB2RFwpJ4eldYBGF0WwtIngrCd5qXdXATVqQsJqnJ7blWj1q5UYzjv7HNs2di32mry32I
        jr5pkNVxMYItD5+CV2m9BfLlDAVUgrfXrF/VwPspDchBCHcJIC7LYcNZsrKZMHbdlXRI2B4byr/kv
        yzxkhf9pldbRRdQv//mi9wgop8DLIATgQQb+0wcOIzfRF/ROXg7NxWJ4d1P44nvSeblN1QKXNPjMl
        qhltsAHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oAlvU-00G72A-0L; Mon, 11 Jul 2022 05:25:44 +0000
Date:   Sun, 10 Jul 2022 22:25:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCHSET v2 0/5] xfs: make attr forks permanent
Message-ID: <Ysu0V1mQovrXQiEo@infradead.org>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165740691606.73293.12753862498202082021.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 09, 2022 at 03:48:36PM -0700, Darrick J. Wong wrote:
> Although the race condition itself can be fixed through clever use of a
> memory barrier, further consideration of the use cases of extended
> attributes shows that most files always have at least one attribute, so
> we might as well make them permanent.

I kinda hat increase the size of the inode even more, but there is no
arguing about keeping nasty rarely used code simple vs micro-optimizing
it.  Do you have numbers on hand on how many inodes we can cache in
an order 0 or 1 cache before and after this?
