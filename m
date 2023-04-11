Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A6BC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDKEuz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDKEuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:50:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D478173E
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KtwR1sv4rH/NPJb+djqhP8HtoZ
        VpSPyAn3yYyu5w5jUCnGveb6+JfTa966LBgtkIR8s8ntxT3C00qpVnB0e8U4NBPgNk54zYpCv+J7K
        vAMHPk2JEuBPQD+DUst1I+BB1tGRF3mxYsD5hmeWGNO8E6Lr1vkDL9TKbqbueokh99tk/FnwvVEQo
        AKokxDLZ/bAGBfgpr0swxrkdEH7KHTBavEAd+gOVZK2ATPOMyqQTXLfgP+nmv3wOnN23wPxinrwhV
        HkFavPlJZaa8SbQ4NFcpi2Y1n2r55qZL5an0lgW0fbw479VTLONMyna7TTPNJqqTgBFrNSPprhKX2
        HkzC1dqw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm5xu-00GPc4-0p;
        Tue, 11 Apr 2023 04:50:46 +0000
Date:   Mon, 10 Apr 2023 21:50:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/4] xfs: test the ascii case-insensitive hash
Message-ID: <ZDTnJlVmlqPMBOrG@infradead.org>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
 <168073938491.1648023.8079382420379879602.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073938491.1648023.8079382420379879602.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
