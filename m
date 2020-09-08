Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72F6C2D0A7
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 718F32087D
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pys5xW7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732117AbgIHT0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731049AbgIHQAE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:00:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DF4C0A3BFB
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v0oOq/BgEza2TzxnE+CUqmkgzLYIVPwroGdksDyuuxI=; b=pys5xW7pmZqvmmWrzOCWOzM0Wh
        jr6H4d+brLU+7SP6itWtV1wYw7rN1JgOGuNSGR3mUTVVPRBUddyLhDvvFfRqUenH3CWSnv/YwVqDO
        DIu4Q33XGrxWatyTT8ykSixF94xJqE2ylxkoSOt0Wcox5tY14DrzZz+vGAAirjWgvyXYN2ovZkjJ/
        NuPaIvbx4x1zG0OkUBN8dMnOq9e6NvkkKlDVqcwdnXvUdyZ/bch6x9hzM/Kx2Zzr6JjhZkDZ6+G6F
        l/Bt8cLn6G7F0u3lFXokcmP/1GkShK8VyqgACwodGWRUrCdFHqy6+4SP93q5KXX/RPbd/HIq1M9bn
        AiOgPgKw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf2d-0003A0-0b; Tue, 08 Sep 2020 14:56:31 +0000
Date:   Tue, 8 Sep 2020 15:56:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: don't propagate RTINHERIT -> REALTIME when
 there is no rtdev
Message-ID: <20200908145614.GL6039@infradead.org>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
 <159950166858.582172.16284988680675778406.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950166858.582172.16284988680675778406.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 11:01:08AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While running generic/042 with -drtinherit=1 set in MKFS_OPTIONS, I
> observed that the kernel will gladly set the realtime flag on any file
> created on the loopback filesystem even though that filesystem doesn't
> actually have a realtime device attached.  This leads to verifier
> failures and doesn't make any sense, so be smarter about this.

Looks good, but add an overly long line.  Which just suggested that
the whole flag inheritance really needs to be split into a helper..


