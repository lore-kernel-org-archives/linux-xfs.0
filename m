Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5424C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDKE7x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjDKE7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:59:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98E62D60
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dwtaSXIldGVSinK7SJyQx18iih
        k/faqVqkaLlUrTe3w2+i6PxPMXQgKPoH0CfXT5jC4y7rOJ1/knr7yNF67YEnQAxhH/kZAyBTErLYo
        zlyHmhs7itt8kj+WRe0IkU6aX7/9YG+uIj10VFl8ycfAM/2PyS8MAbgQJ3xJg1PuditAnJJJh2UTj
        Y3YbyCAkcIDl9lVbhN4ctAN8rM9rprQwmNFYjLDcff6CYvwT3gNIkM/DKDixot/7O9WhEwJCOIHC9
        U8Lrw07de5S91v0N81+MLXsod+iH7vzj2FuLnJMlaNUxMgHRoig0M6ya3nAK8Bj0SDlZi9TtqUu/b
        +aR7WEmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm66a-00GQRu-2T;
        Tue, 11 Apr 2023 04:59:44 +0000
Date:   Mon, 10 Apr 2023 21:59:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/2] libfrog: move crc32c selftest buffer into a separate
 file
Message-ID: <ZDTpQBGg9PwngRhP@infradead.org>
References: <168073967113.1654766.1707855494706927672.stgit@frogsfrogsfrogs>
 <168073967676.1654766.11209657711850717788.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073967676.1654766.11209657711850717788.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
