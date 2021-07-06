Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF6BC07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 14:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95ED619BE
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 14:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhGFOqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 10:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbhGFOqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jul 2021 10:46:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B622C0613AC;
        Tue,  6 Jul 2021 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YWMgMiz0NSkHLipT1VEThA/f8vA9y3xyiRXKfliC2FQ=; b=eEJjo64t1w7GzXpO1lD11M1r9W
        WPXSlO2KDH2Ib31wkN3RlL5OYWPdWaCfIEcbv6aUwwRwvyz3FloDabCdqH6JxLfsWDuFdBY2ZJc4T
        hXdxbvTiMvizZLyP71NAio0S8il8w1mNBOlxBsHPoT5TAuwyQjopHfQWCbqve7XkVrIhvnumyY1g5
        BClgKyBxQBK582tIev0TvyGSblgulZfmIf5irTzOU4rsWtOKhEf9aQL/+JiM9FwECdCMXdRV+JaIJ
        HJE5Qykdn8CIfeRDVmEbysxhW8fE/Gurc3ZJ47TEUDi6YORm/yzPsQ8jPTanei8ivUNU4In0eZWDT
        RPiEPZMw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0lVI-00BRAt-Cl; Tue, 06 Jul 2021 13:52:50 +0000
Date:   Tue, 6 Jul 2021 14:52:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v3] fs: forbid invalid project ID
Message-ID: <YORgMAtpCBdc59cN@infradead.org>
References: <20210702140243.3615-1-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702140243.3615-1-wangshilong1991@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 1e2204fa9963..d7edc92df473 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -806,6 +806,8 @@ static int fileattr_set_prepare(struct inode *inode,
>  	if (err)
>  		return err;
>  
> +	if (!projid_valid(make_kprojid(&init_user_ns, fa->fsx_projid)))
> +		return -EINVAL;
>  	/*

And empty line before the comment would be nice for readability.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
