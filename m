Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44D4C7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDKEv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjDKEv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:51:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A479A1981
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=U51ZPUC1JxkshcJFt48Pnjy4le
        Qww/lZEeuFVAUEHPrNa43pMGsPC0rIhwe7BdzhqaVPtXU0UIcTYGdFmCDZyFyXvPvkxFwqb0XCBee
        8wnIBUxXOKqbktSIamZXIrSAiRJ918sO/Y8Qu9/VKPxde1YI8IzR+JMTLDR5cOB7Z1yieYgJeOKyR
        4szSK8yvz4UiJdA6XQom0iSf4nOa+PSxplwNzs1muS4aDnJD8yYpvBCjKY0YlJAVaDPq3+V92wdly
        ZtiXAxw+iaYhGMRt9xpG2Pes4OP/iMbpNfRFP8GzJ8XZef+O7IkMuaXpzI49sxRBOTpHvDpYDjVVA
        JWifPJrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm5yy-00GPhZ-1e;
        Tue, 11 Apr 2023 04:51:52 +0000
Date:   Mon, 10 Apr 2023 21:51:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/4] xfs: use the directory name hash function for dir
 scrubbing
Message-ID: <ZDTnaBqLnW09O4eF@infradead.org>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
 <168073939050.1648023.15263963125718682690.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073939050.1648023.15263963125718682690.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
