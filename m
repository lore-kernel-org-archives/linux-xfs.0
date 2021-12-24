Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13370C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Dec 2021 07:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351681AbhLXHEr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241206AbhLXHEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Dec 2021 02:04:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39100C061401
        for <linux-xfs@vger.kernel.org>; Thu, 23 Dec 2021 23:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=bw4kHfMZ1e3y13wREtWhO0jfPS
        PB4KO0cUyWLuoRYA1Cosm2t8NTbOPK7WVBFs6eNQrmRiS/ifAGYWBtCsOzjwC4Kov1Trf3ZRkB4Jw
        apRYPpXgnIqrl/GQXwoMAiMaWfuvil3aUwABqBoxbOVSvlXatpCTbg0N7/OvhlmZjOtHxF7fkNG32
        Z1f32ctamy/hVA5I8yubLo51IamNUKtd0254lEjm2kOlHSSaYSOe5OFz2aNxy0CbwGoqlV2bLoLmp
        YE39K2295wh8Wq+MDckbgfQJgUgv8wOdgKgnNCTLsTeyNi+uVBbFAzl14xaV0cTnm0qt5spL+6J91
        IbSSAigg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0edB-00DpUH-Sy; Fri, 24 Dec 2021 07:04:45 +0000
Date:   Thu, 23 Dec 2021 23:04:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] mkfs: add configuration files for the last few
 LTS kernels
Message-ID: <YcVxDd0qVpwVzmqI@infradead.org>
References: <20211218001616.GB27676@magnolia>
 <20211218002051.GU27664@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218002051.GU27664@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
