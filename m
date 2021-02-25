Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D00C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A2664EF1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhBYING (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhBYINE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:13:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39800C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Eno0kAd4gJRLSBxmLJneVtCn7wFzqe9K5jp8CmLUSY=; b=CW/pniJLQWwy2gs4nXSAMMGZlE
        ySfejRYIndsq+TR16b0ncWvSYVU0h1rsEMhzhK6UkQYyLRVryPt7FWeRgc7SPuhlHIKKCt6X9+Gmr
        MlqxYhhsCR8kwmNxKB6LoIhiwTsfvbIekae0jSdQeDhoI2kmXAz48JZakX7JBDbQBRHaf1cNOqCkR
        N2kUhPswaA0iJiSHvpte7eXVtBT8JxVWfR6p+BLnxsuFDJtRJQFKYOkp4Img9enEfp50q696sKzGO
        ZhTD8lmNA34JjsPxO9eiDP/NzfKTyT5cs/7oWxNEFiHrPGX8sMwI0Z+YZY2eKPii2h1yO0+oqJtOx
        hWE9LkgQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBkQ-00AS3I-59; Thu, 25 Feb 2021 08:11:54 +0000
Date:   Thu, 25 Feb 2021 08:11:46 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs_db: report the needsrepair flag in check and
 version commands
Message-ID: <20210225081146.GJ2483198@infradead.org>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404923555.425352.13688646688421406378.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404923555.425352.13688646688421406378.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 22, 2021 at 07:00:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the version and check commands to report the presence of the
> NEEDSREPAIR flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
