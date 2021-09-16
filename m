Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14131C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E341061185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 07:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhIPH3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbhIPH3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 03:29:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5463C061574
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 00:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Am8aBAbOIdBie3yiWB5qw9OLHCU2PUk6T7WuQqNOARk=; b=H9j5+l7R2kRv9NUU8I2tIurL2d
        7Z1YnFW6QT4Mw3LSAnUniZCzjiS+Ti/YMXtRnBbizYJ/8lCmgZ+Bw6VRn9eVPl/fw9gtsRlf8Rhdz
        GZbhqT+fGl/bVY0DE/5avJ12nNh5iqsYd3gTH5yxbUzfFbHCOs4SobUjR1KzgCFxvGLTr0SaRoXPd
        RzpAebaNeYPTECM3ONuJaQFs6uYqjlWy0Rsh3ZEatASo12KjtfrY0r9jU2F2NhNnGoSkK09F9blRH
        Cv7S6ZYkmQaIyRbFcIuz3F33KU4Cx5di+flp+ygzXmlEC6nE/Mawmed57mIb/0HSH+T7Cfw3CxUln
        dlTtaCSQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQln8-00GPsV-DT; Thu, 16 Sep 2021 07:26:57 +0000
Date:   Thu, 16 Sep 2021 08:26:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/61] libfrog: move topology.[ch] to libxfs
Message-ID: <YULxsixYbjW2hgfn@infradead.org>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174720579.350433.12686413907945599656.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174720579.350433.12686413907945599656.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 04:06:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The topology code depends on a few libxfs structures and is only needed
> by mkfs and xfs_repair.  Move this code to libxfs to reduce the size of
> libfrog and to avoid build failures caused by "xfs: move perag structure
> and setup to libxfs/xfs_ag.[ch]".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
