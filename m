Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1ADC433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 17:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD5B6124B
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 17:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhDERzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDERzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 13:55:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F13DC061756
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 10:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PNbSgodj9i2PDZEX5NwpECtsgFKTrzsdpcywTxdlYbc=; b=khyBlikTCswb0Te2SMw/MKJoqD
        t2hcS6SxyMdCWFacPRqj3xDFT+YDGQXyk60IJCGMWgN18K3k6VXf0cRB3aLNj00qF78poCv57A6XY
        UCkM0JQTZUPlPHI4+MvtVzNgeawnG2oKGbjXORsGzjS4rB7FkRLeOAoA3e2R5BJFKB68NWtjoAXIj
        T3msO49Q0ItHIdelQfi1cYMUhDcgZU7TGkQfMBGsHwBIdB6WyJNYQ0AOy3HKUV6h4jun+nTxXjfBB
        3qtOPZHU6xJ++779tsQeSJR41GCbrREp+bfnNpoVcTLWn7+FcCxyAmfgCLELmsilTQNQ0nsDZ/xgw
        sTtTpCAA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTTRl-00BhdF-G6; Mon, 05 Apr 2021 17:55:34 +0000
Date:   Mon, 5 Apr 2021 18:55:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: drop unused ioend private merge and setfilesize
 code
Message-ID: <20210405175533.GA2788042@infradead.org>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-4-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:02AM -0400, Brian Foster wrote:
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
> -		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> +		iomap_ioend_try_merge(ioend, &tmp, NULL);

The merge_private argument to iomap_ioend_try_merge and the io_private
field in struct ioend can go way now as well.

Otherwise the whole series looks good to me from a very cursory look.
