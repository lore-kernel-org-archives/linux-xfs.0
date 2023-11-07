Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF892C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbjKGIjx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjKGIjx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:39:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C4BBD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WATABF8mpnVwkhg50BBiGTAHpo
        3bOMKPKMPT0ODdIm9fw4B+64bdoMvoTGf63iQ1ouQ7ZpkB9ndMEA3NMkwGAgS9BU1tQ68yLJUr98E
        AMm8LW9wM7VICMi30RPKxHvDvLStXLjX/KdqbxVD5pzmrzV7sHWV+qWjaciDvak6SeCCOrIV4n1qu
        Co0/2og5IUVYi743d5uNL3s/vMK/cWqJW3307bhdXQUTUwLBt1i6crx1JoT6HyyET7p+w1y5IY7xm
        RV7G1xXQHPX2EplSlZoIKBI2R5/7wXwY+rBipIdBf0kKqo69niLOaz3w6Cb3iUktKPXIL5Gn6/TM4
        Wjhe8cVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0Hck-000q45-2C;
        Tue, 07 Nov 2023 08:39:50 +0000
Date:   Tue, 7 Nov 2023 00:39:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_scrub_all: fix argument passing when invoking
 xfs_scrub manually
Message-ID: <ZUn31jRt81DlTjYj@infradead.org>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
 <168506074189.3745941.864125085157099570.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506074189.3745941.864125085157099570.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
