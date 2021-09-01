Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6C2C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E73F61075
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 08:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241819AbhIAIyq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbhIAIyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 04:54:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E163DC061575;
        Wed,  1 Sep 2021 01:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/cXoaWb/ChTiG88//9G2K9gxmKcoju9iB//oZRx6ESs=; b=ixXepbANqmit+EF85aYviANDuY
        2+uZ8+YrF6iTKfOTrjjOObwTj+dabTpLTAB04+MBSI4qhimGj1z3q3pYRiQ6C61QgrLoIOAlNdpod
        XO4grGqETQNUuadGJ2y9th1g6xoOYlTrIPgffGcOHm4qGS9TgFoV7mWtcC6u/ERBajK3y+GOwzM18
        VQ9UcSSKFlTa880luiZ2funPTHnrupONwV3UgcmrJjeZulmNMwzX9TXFBnSkdyuYHQRrNkR8BbB0g
        JO2cQ3Emfkt6tJZKV8da/nKI2jtVYdrClGbUW7467CyuESJrylLNZ6bw1iXw6E7LGmb8dMh05NQMi
        UuayLlRw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLLzT-00241K-Uh; Wed, 01 Sep 2021 08:53:14 +0000
Date:   Wed, 1 Sep 2021 09:53:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] new: only allow documented test group names
Message-ID: <YS8/b76khJSpWvK8@infradead.org>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045517721.771564.12357505876401888990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045517721.771564.12357505876401888990.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:12:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we require all group names to be listed in doc/group-names.txt,
> we can use that (instead of running mkgroupfile) to check if the group
> name(s) supplied by the user actually exist.  This has the secondary
> effect of being a second nudge towards keeping the description of groups
> up to date.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
