Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF97C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC28D61431
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhGIG0v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhGIG0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 02:26:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA18FC0613DD
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jul 2021 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j1eFbGwHwxj9dmlZKy3W3iVEqP2Rfk1stYkjyN/A0dY=; b=i69Nz7OrLq6AlW1adIUK+bk8ru
        aRin+7qXGV6tEfcvZG3SXhfwK231IdIxfgnzcgWNt05A9tOu50ZlUTG3j5wJ3voXEpY0kiZRcaoGS
        uJKjffwz2L9Es0ieteOZ9+hzNsYO3gm5euQli9raFSfyYf1jZhdCpDBl774F6Bpal4a/3b8kgLXva
        gTiUuS3+tBlUQYPhVHqifSl/StQkPyYbesoid2+bY9LkuL9wYpzkl78iByFAApSFHgXTjl+t4Z4XD
        SkRsII5Ak35HPjOqP50T6K8MJOPcoOLTXTy0H69GALAxS9k18pZR+1BzAiUm58cAxNarBGD/+zQlr
        i1mFtUZA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1jvW-00EDc8-GG; Fri, 09 Jul 2021 06:23:59 +0000
Date:   Fri, 9 Jul 2021 07:23:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: correct the narrative around misaligned
 rtinherit/extszinherit dirs
Message-ID: <YOfrerDowDeQ3u3g@infradead.org>
References: <20210709041152.GN11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709041152.GN11588@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:11:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While auditing the realtime growfs code, I realized that the GROWFSRT
> ioctl (and by extension xfs_growfs) has always allowed sysadmins to
> change the realtime extent size when adding a realtime section to the
> filesystem.  Since we also have always allowed sysadmins to set
> RTINHERIT and EXTSZINHERIT on directories even if there is no realtime
> device, this invalidates the premise laid out in the comments added in
> commit 603f000b15f2.
> 
> In other words, this is not a case of inadequate metadata validation.
> This is a case of nearly forgotten (and apparently untested) but
> supported functionality.  Update the comments to reflect what we've
> learned, and remove the log message about correcting the misalignment.
> 
> Fixes: 603f000b15f2 ("xfs: validate extsz hints against rt extent size when rtinherit is set")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
