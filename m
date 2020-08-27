Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD87C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F18C822B47
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 08:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eqwO8tTX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgH0ISu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0ISt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 04:18:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE65C061264
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 01:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rvkj8MqMuff/6pbcjH4O+rZ+VYQzIO7VN7aYIsIOf54=; b=eqwO8tTXNkMEHhsyLfVYB1lMDZ
        qrTFD3eR+mHbVvkQxCJjy9IUlxq0fGTCej/zSaeHCa+6Kd4KarcddIBcwP1pumaQmhzrYyb+omceX
        YVl8dGOyzL5yov7hbBYD5QdBaEJ9YFshs8mzxHDKlMY4Xr+AL8UAiXeODRhd4W24vIusg8woq53+7
        7hdJ8m0MseTNSTxfWtfuA7ADjMNfG+4H5zX9GWVxzbGv/Ubq0Y4usIEljZhVVFpFF/Apj3phtz7Gs
        /ZGa1o7nH5rF7TRfTGVXekTFrdHqDslMWMWK8vxur3EiIxcV2EryX9pMNnwfQSrOrrqn64D8dLDrp
        vEK90Q0g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBD7N-0002dv-Pb; Thu, 27 Aug 2020 08:18:45 +0000
Date:   Thu, 27 Aug 2020 09:18:45 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
Message-ID: <20200827081845.GA9746@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954327.2601708.9783406435973854389.stgit@magnolia>
 <20200827065114.GA17534@infradead.org>
 <CAOQ4uxiXNaboUgCs6A5zjfnMpmb8+=m+TaZ6fKj0-5sknie3Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiXNaboUgCs6A5zjfnMpmb8+=m+TaZ6fKj0-5sknie3Ag@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 11:17:34AM +0300, Amir Goldstein wrote:
> Looking at this my eyes pop out.
> I realize that maintaining on-disk format of the log is challenging,
> so if there is no other technical solution that will be easier for humans
> to review and maintain going forward, I will step back and let others
> review this code.
> 
> But it bears the question: do we have to support replaying on BE a
> log that was recorded on LE? Especially with so little BE machines
> around these days, this sounds like over design to me.
> Wouldn't it be better just to keep a bit in the log if it is LE or BE and refuse
> to replay it on the wrong architecture?

XFS has never supported replaying a BE log on LE machine or vice versa.
