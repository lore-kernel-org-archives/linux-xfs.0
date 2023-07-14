Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0D7EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbjGNOvD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbjGNOvD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:51:03 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767562690
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:51:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3EADC67373; Fri, 14 Jul 2023 16:50:59 +0200 (CEST)
Date:   Fri, 14 Jul 2023 16:50:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        keescook@chromium.org, david@fromorbit.com
Subject: Re: [PATCH 3/3] xfs: convert flex-array declarations in xfs attr
 shortform objects
Message-ID: <20230714145059.GB3628@lst.de>
References: <168934590524.3368057.8686152348214871657.stgit@frogsfrogsfrogs> <168934592239.3368057.13821438121542148084.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168934592239.3368057.13821438121542148084.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No one ever does a sizeof here, so this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
