Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E7C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C52F214DB
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZdVXsMM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfKHHPI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:15:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52212 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfKHHPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=otspEInLLOj2fQTG4MHEa2YmaTgb6sHSiM4GcZ7Rb7o=; b=ZdVXsMM7GAQHgu4NLA7jrh7Hy
        oe9cql6m9mn2DhR2l+4wGgjwBL5Qm8g7RGQYYlWnqABDfrhh5JHN3qAmOZdHhL49ozXgbICn+7hOC
        eAOU/VbVnJTEU9jL6/bHULk7y9Gl9yEHMHTBFD89m/SR/tDYwBMyZnbZ6uunF8OGPoDKVbeeJeynF
        y+TLwLSoYj8du6sfCm8rKy67G2254JSFylHabNLupYbbVYlh5TKgDlE+vCX1ekRavM++CanIoAbyi
        +9/slyPYZDT4uXbDB9m6LbyrkiVbAzrC+6YkqzilquRGpsFEZFyw/NBijJi8L4wLZT2WdDGiynPfW
        it6Vf9okw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyU7-0002uk-Lc; Fri, 08 Nov 2019 07:15:07 +0000
Date:   Thu, 7 Nov 2019 23:15:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs: refactor "does this fork map blocks" predicate
Message-ID: <20191108071507.GC31526@infradead.org>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319671485.834699.9969042485447944797.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319671485.834699.9969042485447944797.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:05:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the open-coded checks for whether or not an inode fork maps
> blocks with a macro that will implant the code for us.  This helps us
> declutter the bmap code a bit.
> 
> Note that I had to use a macro instead of a static inline function
> because of C header dependency problems between xfs_inode.h and
> xfs_inode_fork.h.
> 
> Conversion was performed with the following Coccinelle script:

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
