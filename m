Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94421ECE58E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 07:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F28021920
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 07:03:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KlGt3Z/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfJIHDy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 03:03:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48916 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJIHDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 03:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rwfL8oNHkRnTGyY2lKOFYK8nXi0lp9j+ggd3u7/w19Y=; b=KlGt3Z/lYhiAQFywHhMrCseGO
        rbUUIQEoTHn/zIujobsJ75c4a+yRAIjgAyirVquxIzga5aMrgUj+DcsPyTGJcB1bh+gItDUAn2b1m
        Icqo7Te6VC2FN9JYjGy8Z+Rs3qiBPkEraHFL75SfB42zp3Xssn/9xRGYylTffD/0Vj7OGqqPG6TJE
        p/XzBLCsBTNSoA4Y+HqG4LFbR7jN6owYa8g86OtBlp41CvR67j4csKHAJVEacThy94h34LTcNMYWD
        0kNvVy8evkX4X/0f5hmcM4qhAbSCxMvmPTXVIVWLoxXQnRM7fgq6DQzIxFi1AklBScnP12hnrqC13
        0sWo/0oNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iI60n-0006u3-Lu; Wed, 09 Oct 2019 07:03:53 +0000
Date:   Wed, 9 Oct 2019 00:03:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] populate: punch files after writing to fragment free
 space properly
Message-ID: <20191009070353.GB24658@infradead.org>
References: <157049658503.2397321.13914737091290093511.stgit@magnolia>
 <157049660991.2397321.6295105033631507023.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157049660991.2397321.6295105033631507023.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 06:03:29PM -0700, Darrick J. Wong wrote:
> To fix this, we need to force the filesystem to allocate all blocks
> before freeing any blocks.  Split the creation of swiss-cheese files
> into two parts: (a) writing data to the file to force allocation, and
> (b) punching the holes to fragment free space.  It's a little hokey for
> helpers to be modifying variables in the caller's scope, but there's not
> really a better way to do that in bash.

Why can't we just split the operations into creating a large contigous
file and then fragment them?


create_large_file foo
create_large_file bar
create_large_file baz

fragment_large_file foo
fragment_large_file bar
fragment_large_file baz

