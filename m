Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DEDCDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbjJLFAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343508AbjJLFAA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:00:00 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E4490
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 21:59:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 633516732D; Thu, 12 Oct 2023 06:59:55 +0200 (CEST)
Date:   Thu, 12 Oct 2023 06:59:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 1/7] xfs: make sure maxlen is still congruent with prod
 when rounding down
Message-ID: <20231012045954.GD1637@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720745.1773388.12417746971476890450.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720745.1773388.12417746971476890450.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:02:50AM -0700, Darrick J. Wong wrote:
> Fix the problem by reducing maxlen by any misalignment with prod.  While
> we're at it, split the assertions into two so that we can tell which
> value had the bad alignment.

Yay, I always hate it when I trigger these compund asserts..

>  		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
> +		maxlen -= maxlen % prod;

>  	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
> +	maxlen -= maxlen % prod;

Not sure if that's bikeshedding, but this almost asks for a little
helper with a comment.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
