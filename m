Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91C2CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 06:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbjJLG0m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 02:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377538AbjJLG0Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 02:26:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20CED8
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 23:26:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 625D96732D; Thu, 12 Oct 2023 08:26:20 +0200 (CEST)
Date:   Thu, 12 Oct 2023 08:26:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 8/8] xfs: use accessor functions for summary info words
Message-ID: <20231012062619.GC3667@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721750.1773834.4264847386675407220.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721750.1773834.4264847386675407220.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:08:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create get and set functions for rtsummary words so that we can redefine
> the ondisk format with a specific endianness.  Note that this requires
> the definition of a distinct type for ondisk summary info words so that
> the compiler can perform proper typechecking.

Same comment as for the bitmap access, including the same offer.

