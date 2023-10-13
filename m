Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107CBCDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Oct 2023 04:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjJMEZS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Oct 2023 00:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjJMEZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2023 00:25:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A28D6
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 21:25:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C8B6167373; Fri, 13 Oct 2023 06:25:13 +0200 (CEST)
Date:   Fri, 13 Oct 2023 06:25:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@osandov.com
Subject: Re: [PATCH 4/7] xfs: create helpers to convert rt block numbers to
 rt extent numbers
Message-ID: <20231013042513.GC5562@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721239.1773611.10087575278257926892.stgit@frogsfrogsfrogs> <20231012051713.GC2184@lst.de> <20231012175833.GI21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012175833.GI21298@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 10:58:33AM -0700, Darrick J. Wong wrote:
> <nod> I've decided to go with:

This looks good to me, thanks.

