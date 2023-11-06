Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF43FC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 06:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjKFG7r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 01:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjKFG7r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 01:59:47 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D08A112
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 22:59:44 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 383F46732D; Mon,  6 Nov 2023 07:59:40 +0100 (CET)
Date:   Mon, 6 Nov 2023 07:59:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] db: fix unsigned char related warnings
Message-ID: <20231106065939.GA16884@lst.de>
References: <20231103160210.548636-1-hch@lst.de> <20231103203813.GG1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231103203813.GG1205143@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 03, 2023 at 01:38:13PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 03, 2023 at 05:02:10PM +0100, Christoph Hellwig wrote:
> > Clean up the code in hash.c to use the normal char type for all
> > high-level code, only casting to uint8_t when calling into low-level
> > code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> The problem is deeper than just this, but we gotta start somewhere...

Is it that much bigger?

Beѕides the usual problem of casts hiding bugs I think we are fine,
but please double check:

 - the lowlevel xfs directory entry hashing code assumes unsigned
   chars, because of that we long compiled with -funsigned-char just
   for XFS, which got obsoleted by the kernel doing it entirely
   after we've switched all the low-level code to use unsigned
   char.
 - given that traditional unix pathnames are just NULL terminate
   by arrays and the 7-bit CI code doesn't even look at the
   high bit we really don't care about signed vs unsigned except
   for the usual C pitfall when casting or shiftting

So as long as all the low-level code uses unsigned char we should
be fine.
