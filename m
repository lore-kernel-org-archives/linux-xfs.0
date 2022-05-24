Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD1BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 08:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiEXIPK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 04:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiEXIPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 04:15:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617BB77F02
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 01:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=33G14vKhuEow6y+YlHbMEEeCIP
        C3wheUrQrPxWrANhsPSy8tbP9eS0MAuqODMLn7EIJ5L/IN0owuI9YYJwAfZqL5pDg23dEGwvy16Fl
        kj9LhBsX3T944SNKFLI8it6d9YVWsNbn7widrpf8/LWHRToHq+V0JkwsHOrkWkA0UO4+76/wW6ovD
        M/Q6wRl/c4Le1AVF6+AFKeFaMER7eBH0qk2/qREK/97llsx8/YBIRKbdIGhUfrFDJAOdMrkKRRoCT
        Ns3MHhGmxcR0P4x+auGMpCBegYvJJZAjwCpAhIPFuTUJz53DzJ+EA1SYs0TX58xNr7wTjdcPrVdgo
        a9maPbsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntPh4-007DZ0-10; Tue, 24 May 2022 08:15:06 +0000
Date:   Tue, 24 May 2022 01:15:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: assert in xfs_btree_del_cursor should take into
 account error
Message-ID: <YoyUCq8VJUDSgPHG@infradead.org>
References: <20220524022158.1849458-1-david@fromorbit.com>
 <20220524022158.1849458-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524022158.1849458-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
