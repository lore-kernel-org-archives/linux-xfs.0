Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF989C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A602120656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a5nGqgwI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgBUOmt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:42:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42478 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUOmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j7qwGAMWr1/yZd94tmzugSMo6LanV21zUXOdk1vLHaU=; b=a5nGqgwIEkB8739/O+/KAmXAy0
        tidvIFuU1PbrXFpr+Yw943iLDogglexXHTsouLDypQZg6xpK72BkgQ2arIhVRD6qUo3xQvC0ODPww
        Vy6i6B7IjO9pqfuZq+gATNJpwZ0JGfovhq7rheROrrnYtfOs1dw6IBWv8VRpGBEqJ7qJfTQTbPev3
        1bwzp4uVNBeKYeY18mZsKgUNta93pT1SYX5tGNjCK4Hn0UuCc0E6sIgtnNFXp8ECKxk1R2CuByu/9
        yreSBL6KSi6q/AG2iF5UBKk+QcD0hSc4k3mdwCBseR1DXV5D6S9XGyOz+Y3RsRjk1NNp8M1MzTn3c
        2+PEJ/qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59Vv-0005lt-TW; Fri, 21 Feb 2020 14:42:47 +0000
Date:   Fri, 21 Feb 2020 06:42:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/18] libxfs: clean up readbuf flags
Message-ID: <20200221144247.GA15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216296035.602314.7876331402312462299.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216296035.602314.7876331402312462299.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:42:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a separate namespace for libxfs_readbuf() flags so that it's a
> little more obvious when we're trying to use the "read or die" logic.

Can we just kill this damn flag instead?  Life would be much simpler
if the exit simply moved to the caller.  It also kills the exit call
in a library anti-pattern (although of course due to being conditional
it isn't as bad as the real antipattern from the X11 libraries..)
