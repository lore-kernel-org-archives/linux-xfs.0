Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A4C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 05:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbjKIFhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 00:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKIFhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 00:37:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032632699;
        Wed,  8 Nov 2023 21:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZjcC50Y+Auzx4opF6wit+qu5gh
        sMJRFgZe4gzfLjN0FRiqXYBM5ZTcty5dYCfLg6z/zAOvAbV8n6d8FTdyIMQC3cL/JxkekB6Aafwv5
        5z2w4aV9UR4b33HmhxZ7PJLHBwnBqN/8A0STpOOuWTsSAcaCoGt4PeJSsVZ0C6j4Y55FqXU5wRbNh
        Q6Jdkp4B/marhFTTWyf3BG84RKInC66b1hN0FGz+LEmlZHzMBu8cSV3tcMN6ePnfokGDh6YpYjwCv
        vBxOOY1gmQhCowPmps1GOgLH/ePy2/qybAdeMUWns9RxSfcPVldrcvvFF8pm/5jmp3qutBPU3j9X7
        +v1fU6NA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0xik-005Kg3-07;
        Thu, 09 Nov 2023 05:36:50 +0000
Date:   Wed, 8 Nov 2023 21:36:50 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, guan@eryu.me, david@fromorbit.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common: make helpers for ttyprintk usage
Message-ID: <ZUxv8qswCzGsSWEl@infradead.org>
References: <169947894813.203694.3337426306300447087.stgit@frogsfrogsfrogs>
 <169947895398.203694.7754932509810854745.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169947895398.203694.7754932509810854745.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
