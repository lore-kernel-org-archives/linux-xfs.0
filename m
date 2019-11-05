Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1F5CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6C02080F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:45:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DEuOTuIh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfKEApp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:45:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729735AbfKEApo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:45:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1RNmAi9QNyPnMvsl1Zlsr4AwhWsHv6FtD3aJXPkJU4E=; b=DEuOTuIhUV1gU5rnO1EY1BaO3
        ZzEvenEraNy+fx6Fl6Ezh6LOSo6FQvcNUaO3qZBlX9F/2a16mTBWLoVIq5tRVv2So0npo61wzBYrG
        IialBlSjbcVbCoYlECSrv+8LLbaOvWf7P8ilQBacyFQ+GQkF+DCS4B5aVNZ3iJTMmmZhgRy5s/uxp
        y7HWpzvdv8ejZgGP97Bm9a3lffAMOUZgRaCjZoD8OCOhiU8oIYRTi+DwXAVtYVcG9HSNxOGolYPGg
        o38k06c3lw7C84Rha+lXCOeRlla7RCollsy+u7OKgjG4sH2j172q0zxf2dM+xod5IKcuVr1nR97zM
        2gGZv0RzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRmye-0007ZW-MI; Tue, 05 Nov 2019 00:45:44 +0000
Date:   Mon, 4 Nov 2019 16:45:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: make the assertion message functions take a
 mount parameter
Message-ID: <20191105004544.GC22247@infradead.org>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281986300.4151907.2698280321479729910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281986300.4151907.2698280321479729910.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  void
> -asswarn(char *expr, char *file, int line)
> +asswarn(struct xfs_mount *mp, char *expr, char *file, int line)
>  {
> -	xfs_warn(NULL, "Assertion failed: %s, file: %s, line: %d",
> +	xfs_warn(mp, "Assertion failed: %s, file: %s, line: %d",
>  		expr, file, line);
>  	WARN_ON(1);
>  }
>  
>  void
> -assfail(char *expr, char *file, int line)
> +assfail(struct xfs_mount *mp, char *expr, char *file, int line)

Might be worth to change it to our usual prototype style while you're
at it.

> -extern void assfail(char *expr, char *f, int l);
> -extern void asswarn(char *expr, char *f, int l);
> +extern void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
> +extern void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);

And drop the pointless externs?

Otherwise this looks sane to me.
