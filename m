Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A5ECDB465
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 05:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjJSFNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjJSFNU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 01:13:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C894A4
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 22:13:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7B26067373; Thu, 19 Oct 2023 07:13:16 +0200 (CEST)
Date:   Thu, 19 Oct 2023 07:13:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, osandov@osandov.com,
        hch@lst.de
Subject: Re: [PATCH 4/9] xfs: simplify rt bitmap/summary block accessor
 functions
Message-ID: <20231019051316.GC14079@lst.de>
References: <169767364977.4127997.1556211251650244714.stgit@frogsfrogsfrogs> <169767367256.4127997.17671935176137544426.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169767367256.4127997.17671935176137544426.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If you for some reason need to respin the series again it would be nice
to just add the strut xfs_rtalloc_args definition at the top of the header
from the beginning.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
