Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C732CDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 06:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346966AbjJTGGs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 02:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbjJTGGr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 02:06:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7120D57
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 23:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4oKucAi5fQX7IQ941fOusn//G5zdgdm8xyP5bVXvod4=; b=r7upKHfLFxfIMwyQNKrhLJXLFZ
        EEmtdQgNQhpMjRcCZAHbewnSzpo/DxpAXydIrU/CfjwovQkYXN+mFlDq2gO51EbtAdId2VoftfgEa
        zct7a/kG24RGv9Gh2LKxK+gBOFvG92K2eq4sqsf0r6SKzlSBDdKiWbw5CGghLuQtCHC5zOU04RW06
        sZ1tGJkhs75/38vOrF2k/kxwvNp9dzhoPQB0A4EIX22otFdQV1LQAwizqhInx9QIWiBrSBLmR11+m
        NYMue9AkZBxU2EVyPSZlHupLQVKXfwXY6Uyd55NA/HoW+zypm4qiFHRW+/2UYYBXy7E14UCL5keei
        tJIkKqiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtieh-001Ih8-01;
        Fri, 20 Oct 2023 06:06:43 +0000
Date:   Thu, 19 Oct 2023 23:06:42 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZTIY8jE9vK6A0FE3@infradead.org>
References: <20231017201208.18127-1-catherine.hoang@oracle.com>
 <ZS92TizgnKHdBtDb@infradead.org>
 <20231019200411.GN3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019200411.GN3195650@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2023 at 01:04:11PM -0700, Darrick J. Wong wrote:
> Well... the stupid answer is that I augmented generic/176 to try to race
> buffered and direct reads with cloning a million extents and print out
> when the racing reads completed.  On an unpatched kernel, the reads
> don't complete until the reflink does:

> So as you can see, reads from the reflink source file no longer
> experience a giant latency spike.  I also wrote an fstest to check this
> behavior; I'll attach it as a separate reply.

Nice.  I guess write latency doesn't really matter for this use
case?

