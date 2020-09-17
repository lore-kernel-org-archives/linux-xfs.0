Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27927C2BBD1
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2A1221E7
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oJL/78Nb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgIQIMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgIQIBn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:01:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94736C06178A;
        Thu, 17 Sep 2020 01:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gDU3FRu6mJJhLIzWCv31W3VWw3wDaF6OukOwPQbM6xw=; b=oJL/78NbW/HIVUPiCyTkXnm7hU
        BPw0dSU1CfM6FtWuN4VL4f7SQudSIh2pv+PFhx6YmfNyXJBeBCGWuFv17VgMsxK+vBlYkPnPRpzgk
        EmkhieP+7FoXdjpTKu/LTVeCaQ2q+hfrozoh0cjxnRrTI1PzrSaJvvbXtT1PMzxf/XKirFADVyuTl
        NZCcUgT7GVyXzDuFHcBpODJnyWUAsq2A3YsDfnx6KsElHoFX30UYx18MAjrDHEn2gQWX4CMuG4RQo
        oDBoKUwbOw1vkxVDKFd14BMdpD/uQ5TOnpoT/HS1YH7CZVQWGDXiYZhXRWhrn8Q9GD43ApCKYXC8p
        HPAO40zw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIor5-0007kh-LY; Thu, 17 Sep 2020 08:01:23 +0000
Date:   Thu, 17 Sep 2020 09:01:23 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 23/24] generic/204: sync before scrub hits EIO
Message-ID: <20200917080123.GS26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013432161.2923511.669329888874845585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013432161.2923511.669329888874845585.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:45:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Let's see if we can prevent fs corruption warnings by flushing dirty
> data to disk before the test ends.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
