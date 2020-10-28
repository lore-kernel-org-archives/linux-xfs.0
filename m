Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D2DC61DD8
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74CC224743
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TauC7qvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgJ1VwR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:17 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgJ1VwN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yJltgTfY17Q+bTnZPM75DmijuSX6aYA/BnmjHzotbfQ=; b=TauC7qvz79b536eG4THG2E47Dn
        Izf3xJ+aoPB3ICDxXqbxxgeEtyD1hTW0AuIrC6ifcGJuswhsYkVfGbL6bbUcxGUTU0xhhppCaVOiQ
        BCoUdogXS+Bs+LLzFNv51HyCaIEZ+o336VoUhBNmuykURrIUUPEy3e7asFqwrNR/zrutTM1r4xs5/
        sdOz1D0NDrQaLfIYl4eeoYc1Cg0TuWg/4PFUr7nskzRI6fjJHRVU7neYDOkjIKflmcDRlvDyCmIJG
        ik1O2+jw58I3wlxZcn5s3QHi/6thlXz+YJaiWBH4RXnHo2IhhMpoLupyt/5RnGSPiIK1646TwZbIe
        h5ChavEQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg5x-0000nz-Qy; Wed, 28 Oct 2020 07:42:09 +0000
Date:   Wed, 28 Oct 2020 07:42:09 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/9] various: replace _get_block_size with
 _get_file_block_size when needed
Message-ID: <20201028074209.GD2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382531634.1202316.310897007206501013.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382531634.1202316.310897007206501013.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:01:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The _get_file_block_size helper was added so that tests could find out
> the size of a fundamental unit of allocation for a given file, which is
> necessary for certain fallocate and clonerange tests.
> 
> On certain filesystem configurations (ocfs2 with clusters, xfs with a
> large rt extent size), this is /not/ the same as the filesystem block
> size, and these tests will fail.  Fix them to use the correct helper.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
