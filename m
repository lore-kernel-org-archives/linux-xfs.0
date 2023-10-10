Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBCCCD8CAD
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Oct 2023 17:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjJJReI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 13:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjJJReH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2023 13:34:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E0597
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 10:34:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C41C433C8;
        Tue, 10 Oct 2023 17:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696959245;
        bh=A5K9DCZySlIfmpXqcnIxbjQHFLhCcEXL1QiGNAkSuhI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcspEF66C23abzC7wg3W4QRg/n5eIB40vuMo6oV9JB0Z6SxX1E2S6NqqshwUyQ1W4
         TyP+ZbG5ENAKJZgCPQ+ieLxl3tkDD8WThf7qu+hvtjdTNMltvGL9frW71UHatApGtF
         6joCGea+s6yeyEZ+4KRWRAPsfOk0U48jXo225Ze8JSXSJAy5tu8MoI7B/dmpfHvUDl
         bOHxhlpKd5ULjd/hFvlZ+ObHq0BMVLVRxE8uCL68KsvSBjV1fKgISQEt14REUl3Tzi
         6IwdaY7cE7ISXu3mqbVkjps4Ob3O929pnf2X60SC9eQCm2pu7CeZ8gvpS+M0q4WvEW
         HwT6GMVgEN1TQ==
Date:   Tue, 10 Oct 2023 10:34:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: process free extents to busy list in FIFO order
Message-ID: <20231010173404.GF21298@frogsfrogsfrogs>
References: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
 <169687595684.3969352.13337782664797983922.stgit@frogsfrogsfrogs>
 <ZST1oEZlh6/UAQwS@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZST1oEZlh6/UAQwS@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2023 at 11:56:32PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 09, 2023 at 11:25:56AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we're adding extents to the busy discard list, add them to the tail
> > of the list so that we get FIFO order.  For FITRIM commands, this means
> > that we send discard bios sorted in order from longest to shortest, like
> > we did before commit 89cfa899608fc.
> > 
> > For transactions that are freeing extents, this puts them in the
> > transaction's busy list in FIFO order as well, which shouldn't make any
> > noticeable difference.
> > 
> > Fixes: 89cfa899608fc ("xfs: reduce AGF hold times during fstrim operations")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Does this actually fix an observed issue, or just restor the previous
> behavior?

I don't /think/ there's a real issue here; it just looks funny that the
tracepoints are now ordered from higher to lower LBAs within arbitrarily
sized groups.

--D

> Eitherway the change make sense:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
