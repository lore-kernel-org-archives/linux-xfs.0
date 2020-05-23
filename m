Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811BBC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5919820757
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 11:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PMMSEYHa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730372AbgEWLgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 07:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgEWLgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 07:36:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89202C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=PMMSEYHav+3nvFV8Lj/8ISsrgY
        6U4xpTgIag5sBSzWKIUqJsOKLYyNO7ZYzGHXdhxtjVBViZSenZytWXL1Kpvc//pkwFzPN4BjCEBSK
        hxA076bv6YVMkULrZMwZua/yFXm6OpOerFNCLm9rZL34H2JFyr5PoogUd3f3BXj4KggWCs15sSBv+
        9YzAAlwam2kmMXa7amrZOy9TsCxdSJWQfFYewBtGvNdQhOItpZ1iiMPd07JAv2tN7PgSd/aoK9n1k
        hMsgHx/5WYIiveN6v3POkeWz6M6ZgaVytQ4e6LuaSDQ1RfQca1AO93jEpp71qPJr+epZn4jJ/af/u
        2M0oJujw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcSRc-0006Do-EL; Sat, 23 May 2020 11:36:00 +0000
Date:   Sat, 23 May 2020 04:36:00 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/24] xfs: remove xfs_inobp_check()
Message-ID: <20200523113600.GC1421@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-25-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-25-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
