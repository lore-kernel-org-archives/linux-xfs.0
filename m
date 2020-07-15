Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50FB5C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D8D20663
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:30:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zh8o9hTP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgGOSaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgGOSaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:30:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A8CC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cC/CaCO6/mVxmF1Jkoy24f1L7UX37QBoeXlJY5xiKAw=; b=Zh8o9hTPC9y59c/eCFyHERwe9Q
        bVpqxE4oe8ZWK3GMEnhBW2xgnkSqPXnD1vzqdm+iSy3xiRc3e46YRaa8gJjYRqEt9XdAXh2aHaX4p
        FVJdGU+WnvDbxBDMDDWCI/LF6n6mIV7QEb8g+HHzXSRgOMaa3Cj4FPRRBl2+tbL0Gd1WsZb83dyDp
        7uEs1apzdPDpDbkGICAd59dE33RY8UK8jpoiwgu71zWM/t+Bx5T2w5gEr8Son/viotOsYpsvuOvgw
        o9mgWZ5mdnTR5w14QWWlWvrwQPRZwTgU3V+ITZJ0BwIL9xtNFyVCjOPxNhCFAnR///+5+V6q2aAWY
        DvTwbXCg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmAK-0005b6-CD; Wed, 15 Jul 2020 18:30:00 +0000
Date:   Wed, 15 Jul 2020 19:30:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: skip mount time quotacheck if our
 quotacheck was ok
Message-ID: <20200715183000.GB20231@infradead.org>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
 <159476319479.3156699.12134117203484512536.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476319479.3156699.12134117203484512536.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we verified that the incore quota counts match the ondisk quota
> contents, we can leave the CHKD flags set so that the next mount doesn't
> have to repeat the quotacheck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
