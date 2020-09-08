Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11F9C43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624F02080C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 16:56:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MJxW+S8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbgIHQWv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731816AbgIHQWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:22:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729EC08EAD1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u1sk0L4KrMQ9sbpwqg8FgmTKj10rEKicA3EmfVGsREM=; b=MJxW+S8NVxfapiBn1NYI4J+UcI
        SVG6+BdxydPPg0yk6cTcYEk2TsYyLZFdfGPVPlnn/HLOOD61XHoNyqDPlzSdjAfCDAi+RijgM5DXK
        lGgeCkh4ATKy6HGrFEP9TdLXESNzgyhyvoVcBZtb5JNGGjC34uun764cAB5Nm/nlMJQUv9/E//ADR
        q+/I0D2QzJRy5H56nV9Ej/ZtfpsrJY03iNqJ6FyqPXM0C5j3oYq1MaNQbUubtFGbo+ANnM4qYTTeJ
        dvf6LgMBcfVY4Ixft9ph/F9cWt/pEgGzfVHXOgpGnuNSVJ+64uDEvFkFKjFwZxXqtyVgtPyUD6Akw
        kmZMNr7A==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFejt-00022z-RI; Tue, 08 Sep 2020 14:36:59 +0000
Date:   Tue, 8 Sep 2020 15:36:53 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] mkfs.xfs: tweak wording of external log device size
 complaint
Message-ID: <20200908143653.GC6039@infradead.org>
References: <159950108982.567664.1544351129609122663.stgit@magnolia>
 <159950110270.567664.7772913999736955021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950110270.567664.7772913999736955021.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:51:42AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the external log device is too small to satisfy minimum requirements,
> mkfs will complain about "external log device 512 too small...".  That
> doesn't make any sense, so add a few missing words to clarify what we're
> talking about:
> 
> "external log device size 512 blocks too small..."

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
