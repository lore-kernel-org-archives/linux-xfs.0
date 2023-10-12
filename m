Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF81DCDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbjJLIaW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjJLIaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 04:30:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAA291;
        Thu, 12 Oct 2023 01:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e/PqS2/FH4KPfr+Ihregc6ai1uT6XMuM3rBK9vGlRSg=; b=37dmUQPZ4bLNtlA/TAn4yaxTNU
        Kda8BDHBSfrXGmif9qdJR2IT9ktKlW6N4gxtCwFJSqubSDlnmU/oPrAifQpozxZVzE2LIip31sfoN
        labrHClIjNk6LABdUiIyDjCPZ/k81Ze4ODtOQKR9CM08EQrJ3u3AL8z7iwgU2R+Z6veF2Hej4VUFG
        Q7AgGQr0V9/p4UPW9sXfuYer31/7CSQHWOQ0FoROwi/Irb62JwG9/4ol5NyULULn2lJQ+ihc3kqRC
        +76joTQzi8xTUsPVuzsXTc13o5xmbOtgatsPVXNI5hg60JubwjOPG7fysKk10d7qU+LhWUgfpZKko
        ta3NoTZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qqr5F-000BSE-1c;
        Thu, 12 Oct 2023 08:30:17 +0000
Date:   Thu, 12 Oct 2023 01:30:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <ZSeumZZmBTnHF7ot@infradead.org>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
 <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169687551395.3948976.8425812597156927952.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Unlike the commit log, the changes look good to me.
