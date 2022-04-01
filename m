Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25625C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 12:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiDAMDE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbiDAMDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:03:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73758269A7A
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ltL3TEiqXRwdP3HmezOXuaLbCENSDn67BofwjbQK8Sc=; b=Pee0U/OTlT2z1S9ISOAgBWQum5
        z8d0H6MLvtR7O2+k4GfuH+RDjhc9VHuURH79jSyTam9ZNzvlSf44+PHavbvhZvvTX6CGVPqM1RSiu
        aWMgDkLWSVGdFZvkDU99j/GVPqVn1AoeC1JFsquRzWJNZGJnmYyjQncesExAPIRGtrQdo6Owu04EV
        4f+FYjivzVituROftS0Z/lAMaLy/u0wENfD3jc+rm7sh8WQ1ZRn4lBV4DXNL33HUEgIDSk8sJKjYk
        HHXPd3Qgv7Yzj2Bp5x5A1sJaSRictTbUww9Ckj5bx6OubjygIZHjiXvU6OOhVEW1Hqs4thTtN+I1D
        CrXphKfA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naFxq-005S3a-2a; Fri, 01 Apr 2022 12:01:14 +0000
Date:   Fri, 1 Apr 2022 05:01:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: log shutdown triggers should only shut down the
 log
Message-ID: <YkbpigVBgtcn3YkX@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
>  		xfs_alert(log->l_mp, "log I/O error %d", error);
> -		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> +		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);

The SHUTDOWN_LOG_IO_ERROR as an API to xlog_force_shutdown looks
really weird now.  It s only used to do the xfs_log_force at the
very beginning of the function.  I'd suggest to drop the argument
and just do that manually in the two callers that do not have
SHUTDOWN_LOG_IO_ERROR set unconditionally.  (This is a perfectly
fine follow on patch, though).

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
