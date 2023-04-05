Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DA4C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbjDEPnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239008AbjDEPnA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:43:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E41C7286
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TgTlO6JydZlLtqHhsGk+iw8gMPPfee5XahfGkMViD0M=; b=kSWcnYe5TrEoP2IQCA+adhr2i/
        GrnpbEejuE15yvQlXu5O7+uua3qQ9ujo1nGla+QAz5C+aAzV3CkT0LrgA3oZzy/UJ37RVlMbzimrg
        xeZ5PELDITpWZmDzn/54VC+KD0qi6uTWjaji2GWlJ+FYURkGjzrqqn0ClzleVZP6nu/3k//+RRYkQ
        RbeUJp8Ha86wYOcLNhMJvMcMV3/SIC8Z1I0qgrMYnBo0G2UDkMLHUlnfdxr2ZKfFj24LGB5pmjFJs
        Wr4n6vwjJF3pGvbVvYqHwVGIL/XKuY0ssghnp7Qvmf3zPRsZTSi7jeCQJWhr0HUu9mvRCJoo+pkBM
        rFmdKbkw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pk5HO-004uVd-20;
        Wed, 05 Apr 2023 15:42:34 +0000
Date:   Wed, 5 Apr 2023 08:42:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for
 ascii-ci dir hash computation
Message-ID: <ZC2W6jZ1LI12swSY@infradead.org>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <CAHk-=whe9kmyMojhse3cZ-zpHPfvGf_bA=PzNfuV0t+F5S1JxA@mail.gmail.com>
 <20230404183214.GG109974@frogsfrogsfrogs>
 <ZC0RaOeTFtCxFfhx@infradead.org>
 <20230405154022.GF303486@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405154022.GF303486@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 08:40:22AM -0700, Darrick J. Wong wrote:
> <shrug> Welllll... if someone presents a strong case for adopting the
> utf8 casefolding feature that f2fs and ext4 added some ways back, I
> could be persuaded to import that, bugs and all, into XFS.  However,
> given all the weird problems I've uncovered with "ascii"-ci, I'm going
> to be very hardnosed about adding test cases and making sure /all/ the
> tooling works properly.

You'll love this paper:

https://www.usenix.org/conference/fast23/presentation/basu
