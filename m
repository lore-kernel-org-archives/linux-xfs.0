Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CD0CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjJLFCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbjJLFCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:02:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1836B8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:02:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 74D386732D; Thu, 12 Oct 2023 07:02:36 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:02:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 6/7] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
Message-ID: <20231012050235.GH1637@lst.de>
References: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs> <169704720818.1773388.15441286922872459723.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720818.1773388.15441286922872459723.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:04:08AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This helper function validates that a range of *blocks* in the
> realtime section is completely contained within the realtime section.
> It does /not/ validate ranges of *rtextents*.  Rename the function to
> avoid suggesting that it does, and change the type of the @len parameter
> since xfs_rtblock_t is a position unit, not a length unit.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
