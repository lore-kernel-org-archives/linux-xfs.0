Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2BDC63697
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0952225E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 10:45:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CNqyX6YV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgKNKpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 05:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNKpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 05:45:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABE6C0613D1;
        Sat, 14 Nov 2020 02:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2ZigR8RNlByE/Cl/tepNqIUm6tjE1u0YorfBaG5L8B4=; b=CNqyX6YVcO4+L/teQAtTELvsIj
        BSbOiMETfo3CoYHpN4P/cFX1AmdNK21VJF/XoKnFWM7iIAPSe43BooC8CMMvwO0lCnt8SlJK4QODP
        xCRn+da4QuV8z1jO7TPuUYj5jz5kQB+DDXB/5nJrVHGos2N2G/sRgijb0YGVq/0t2nFOJp1CKo6FP
        EnH1NSZ4aigkPp141ec2IQigg2UiTVE6SAUjN2BxFS6It4oHKnVkera+1Xs7Pjx3XiSo1Ddhz6XSD
        7HFMs7Wtfb84fr8h/mbrBFT67ddLP1tDvDB8vUpf6KpgZYFx/9KnLa2PiRwv0DGS2dfhEAAvCvAfh
        WJEtfaew==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdt3P-0003F5-9V; Sat, 14 Nov 2020 10:45:11 +0000
Date:   Sat, 14 Nov 2020 10:45:11 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] fsstress: stop using attr_set
Message-ID: <20201114104511.GE11074@infradead.org>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505548994.1389938.10129281247073522665.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505548994.1389938.10129281247073522665.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:44:49PM -0800, Darrick J. Wong wrote:
>  	aval = malloc(len);
>  	memset(aval, nameseq & 0xff, len);
> -	e = attr_set_path(&f, aname, aval, len, ATTR_DONTFOLLOW) < 0 ?
> +	e = attr_set_path(&f, aname, aval, len) < 0 ?
>  		errno : 0;

Nipick, but I'd spell this out in a normal if while you touch it:

	if (attr_set_path(&f, aname, aval, len) < 0)
		e = errno;
	else	
		e = 0;

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
