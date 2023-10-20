Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F27ECDB474
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 06:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346657AbjJTGJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 02:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbjJTGJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 02:09:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E414D45
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 23:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J8NzwfDF9zZ8kSJhl6foWd/MCoojQJJuO9boqm1V3fs=; b=3AcGEVYk0Xo+uSGSL4e9ktq0c9
        Jl5C8h4lXuKSJqt2WfNe3qfvxGLg5nCmsf48AK1to+ZwYDn/sNyS9ZhsKX2H7FVhHBxf/Nr+AfFC+
        wuBa/BKYXP6z4gzf4TEOg8xS150apI7a++4MQ2d5IApAi52GlkPW5BJBc6YuNQ8RL7VPX96ijnjgq
        gtCNaO8n9debLv9dp9yUYXp6MkODWYurjbmy2WNGZ76JwsZwQAtNKcL98m4BTfcDjpxhcKMeR+Ad4
        Mq3WdiEc0Ock4e/W4XIWistBukiatISkCL2gyOa9vBN5PC2HqcN52Z69KGfCx0vz0vadkY0ZvjE0+
        xhYV4Xfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtihh-001Ira-0r;
        Fri, 20 Oct 2023 06:09:49 +0000
Date:   Thu, 19 Oct 2023 23:09:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test reads racing with slow reflink
 operations
Message-ID: <ZTIZrT7ZcWQHypEG@infradead.org>
References: <20231019200913.GO3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019200913.GO3195650@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 01:09:13PM -0700, Darrick J. Wong wrote:
> permit reads, since the source file contents do  not change.  This is a

duplicate white space before "not"

> +#ifndef FICLONE
> +# define FICLONE	_IOW(0x94, 9, int)
> +#endif

Can't we assume system headers with FICLONE by now?

> +# real QA test starts here
> +_require_scratch_reflink

This needs a _require_scratch before the _require_scratch_reflink.

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
