Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7756AC63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 202DF22249
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GHoxh1aP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKNKpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgKNKpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:45:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AF4C0613D1;
        Sat, 14 Nov 2020 02:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bIEkJnhOXOrzANiM35XglsOn2cFl610GknSfc/dVVyg=; b=GHoxh1aPPHN6xAN6a3uaIFcAvw
        9Es4w5kYbIDigEFO+nERCwzlelDzGeE9slFvtQOANKL6a9RupA4z/SyRwwUFNkRpmO+iGaaVqq7ti
        TcY9mm/IVQTvV8wltAG/SYbahlsUywjTIi11WRKePlNkRqU0oz0zTCliayoUcQl7XI6e8FfWPljl/
        Vn623EahKvUKLS1CxJ6qTzSvjAS3GRvZdCqtZRLeq+GhRffcq5zUxqO+Fy0Suky1RnG40tsuG3eoe
        97vppTq0Mvgz9310krXFl2JG+5Rb3CdVveCtufnr69Y/ohLX4gdbIBmRrfSC0L08bYYsrE/d9n+sc
        oSvOtqRA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdt40-0003HC-6O; Sat, 14 Nov 2020 10:45:48 +0000
Date:   Sat, 14 Nov 2020 10:45:48 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] fsstress: remove attr_remove
Message-ID: <20201114104548.GF11074@infradead.org>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505549612.1389938.4557085048629140407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505549612.1389938.4557085048629140407.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:44:56PM -0800, Darrick J. Wong wrote:
> -	e = attr_remove_path(&f, aname, ATTR_DONTFOLLOW) < 0 ? errno : 0;
> +	e = attr_remove_path(&f, aname) < 0 ? errno : 0;
>  	check_cwd();
>  	if (v)
>  		printf("%d/%d: attr_remove %s %s %d\n",

Same comment as for the last one, otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
