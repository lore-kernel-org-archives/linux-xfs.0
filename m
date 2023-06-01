Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D299C77B7A
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 15:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbjFAPMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjFAPMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 11:12:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F51D123
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 08:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SW2oE0BZvruBgLWTU0qaGDlwsMnfMLCyLbCwzdAXOB8=; b=1CVtoXVlCWDzqbXryMireRk2lr
        4Z7w7aRcCqulnh2fCGiqp1Zk57bVTFD6zolzZIbYNEMSRjXkW4fvOljh8Qgx1m2KM+qpSnUAY6HE6
        dnHRMY2L9yENg7inZkgnB5FVXRd0ZgZTE3CW/GZgxR9uy15e2XsethtHFEv533Hh3r0NML/QbQjay
        rkGswfA4Hqc6vtBtV3oFmww3VG/+SCUoT04BKSrUZ6D1ao15XbLBhgqCNLCc4F5gs4KJ8bNi83TuQ
        nceGcscVQVP1ESBZg37nAmyv7e8ovi/KHMSWdNPw4amKGx7ZdrlJzSxfo/IO8xx44PK9FhJXCE95b
        SsesIsGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q4jyv-003z2K-0V;
        Thu, 01 Jun 2023 15:12:53 +0000
Date:   Thu, 1 Jun 2023 08:12:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix AGF vs inode cluster buffer deadlock
Message-ID: <ZHi1da1WjTirLQT/@infradead.org>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[apparently your gmail server decided my previous reply was spam, so
 I'm not sure this reaches you]

This looks good minus the left over trace_printk statements.

Reviewed-by: Christoph Hellwig <hch@lst.de>
