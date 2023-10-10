Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F9FCD68F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Oct 2023 07:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442352AbjJJHBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 03:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442267AbjJJHBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 03:01:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4CF99;
        Tue, 10 Oct 2023 00:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bI/vJl5ULJZr3ilKxFJWstI+fkyfacC5qyu4Nha56e8=; b=hZyC1bZ33GltcX7CCa2ZSkJWi+
        Rv0Rtm4poGcty1nCCUjPMItWznXW9OAM/CRkuZ+AezB2KzLFqn5/eOTe2z3u+Vkq1eLfXq8AeG8JW
        SjLCTQV0wQJMR/vVKeX7y1xzzIhS44Uu7XRey217WHgrnWpwiQhU/zCwTleY43Zvt1WVTYRbGZRzJ
        49WpyDQFt9xFfEr1yzZ93JEk6i4j16SpnlX8tH6mZ6AkCRv8ROX9xKYDMBIrRg2CnY/Z4obgw/LWV
        nJWZCHVUplR9m8EeA3JW/yT513gvgv05gUZGzDT1xUaUhrf9XLgcCMzGJCW7MCK8scc2OEI3bAe1B
        spzshVVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qq6kH-00Cf4m-1r;
        Tue, 10 Oct 2023 07:01:33 +0000
Date:   Tue, 10 Oct 2023 00:01:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/178: don't fail when SCRATCH_DEV contains random
 xfs superblocks
Message-ID: <ZST2zRvtMrU0KlkN@infradead.org>
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

On Mon, Oct 09, 2023 at 11:18:33AM -0700, Darrick J. Wong wrote:
> The storage advertises SCSI UNMAP support, but it is of the variety
> where the UNMAP command returns immediately but takes its time to unmap
> in the background.  Subsequent rereads are allowed to return stale
> contents, per DISCARD semantics.
> 
> When the fstests cloud is not busy, the old contents disappear in a few
> seconds.  However, at peak utilization, there are ~75 VMs running, and
> the storage backend can take several minutes to commit these background
> requests.

Umm, that is not valid behavior fo SCSI UNMAP or any other command
that Linux discard maps to.  All of them can do one of the two options
on a per-block basis:

 - return the unmap pattern (usually but not always 0) for any read
   following the unmap/trim/discard
 - always return the previous pattern until it is overwritten or
   discarded again

Changing the pattern some time after unmap is a grave bug, and we need
to blacklist the device.

