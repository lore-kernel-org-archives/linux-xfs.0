Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EF8C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7934E64FA7
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhCKMzG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhCKMyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 07:54:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC06C061574;
        Thu, 11 Mar 2021 04:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=waonfuqDjv6ZLOdd0HuSg3S4ZgUb+QjUP5NKyfRi0PU=; b=p/tHQGoKVXrmJlu+VX55T3a1YK
        9eKRTwu+HnoyjsdC3m3rTrfVaJ1wPeRLT3Z1UglF9POBhZu4HJRulJJpuaCwSM8Kk7EnOZCpq+aL6
        WABLbM+Mk1zU+deOnrMVbN1l5+XmgSETc6kY+YAjW92bzdxGJYJTmZ0qZadJTOnuWRW1LcypkmZ6i
        jx5/vKJqPvg1Nmv30oghEgTb4SnXrn5E1UzIE2bvr3BW8Obs4Ruu5SjUwURO1rMfhO1W64uFbGIcG
        m7QPAoOto4msHrnWp5QfyY7qZUORg7DQ54u7vQXLgRTUktPpE16kgeblRJ9MxooxKSGcAvIVAMS31
        e6ONCmmA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKKpX-007KF1-CB; Thu, 11 Mar 2021 12:54:24 +0000
Date:   Thu, 11 Mar 2021 12:54:19 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] fsstress: get rid of attr_list
Message-ID: <20210311125419.GB1742851@infradead.org>
References: <161526476928.1212985.15718497220408703599.stgit@magnolia>
 <161526477474.1212985.14857729520784229723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526477474.1212985.14857729520784229723.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  int
>  attr_list_path(pathname_t *name,
>  	       char *buffer,
> +	       const int buffersize)
>  {
>  	char		buf[NAME_MAX + 1];
>  	pathname_t	newname;
>  	int		rval;
>  
> +	rval = llistxattr(name->path, buffer, buffersize);
>  	if (rval >= 0 || errno != ENAMETOOLONG)
>  		return rval;
>  	separate_pathname(name, buf, &newname);
>  	if (chdir(buf) == 0) {
> +		rval = attr_list_path(&newname, buffer, buffersize);

Shouldn't this just call llistxattr directly instead of recursing
into attr_list_path?

That whole separate_pathname business looks weird, but that is for
another time..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
