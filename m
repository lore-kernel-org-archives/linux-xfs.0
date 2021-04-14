Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D16C43462
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D258613C4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 06:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349145AbhDNGOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Apr 2021 02:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349118AbhDNGOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:14:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBAEC061574;
        Tue, 13 Apr 2021 23:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VVZ+iCzr4N5iM2LWrwiOoh9jC62W7AB3N3Vg31AVxv4=; b=px4caLrhOBSSHnLneI0gHtZpp0
        ZCR5Lu7sc66sl2Tid9jqmZcQf0LP+98GjYc42296ITmyJnJ/7WcfJ3sJbGmBRR4nNcTdAH0/HKjfa
        LiLqwrUX0+YDCwaWuVT1ksUNHN7QhT4NXz9wttP8zdIWtZxaJH5L+CbD8nAit0xqKvcFgYwZV7y3e
        GZPe+ocX1nJnf4s1XzyHz/KdqFKiz0RFXJuIB8B04FT0v+GZ5NejyP5gJl9XfnvgnMi9onpghiXXU
        MtA89Wd2LNajKvw9J8JlWDOAYa9uOUF6Msxu4Ov3VJJnqetpjymXK+JOqLwuxhKH1y83RLJhtEye6
        8lXx91OQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYmZ-006jAg-Od; Wed, 14 Apr 2021 06:13:56 +0000
Date:   Wed, 14 Apr 2021 07:13:47 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/9] generic/563: selectively remove the io cgroup
 controller
Message-ID: <20210414061347.GD1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836228218.2754991.5899063640535008629.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836228218.2754991.5899063640535008629.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:04:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a system configuration tool such as systemd sets up the io cgroup
> controller for its own purposes, it's possible that the last line of
> this test will not be able to remove the io controller from the system
> configuration.  This causes the test to fail even though the inability
> to tear down systemd should not be considered (in this case) a failure.
> 
> Change this test to set the "io" component of subtree control back to
> whatever it was when the test started.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
