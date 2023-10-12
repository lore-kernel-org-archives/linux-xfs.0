Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37F3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 06:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347050AbjJLGTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 02:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377349AbjJLGTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 02:19:21 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59D0C9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 23:19:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A470A6732D; Thu, 12 Oct 2023 08:19:16 +0200 (CEST)
Date:   Thu, 12 Oct 2023 08:19:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 6/8] xfs: use accessor functions for bitmap words
Message-ID: <20231012061916.GA3667@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721721.1773834.17403646854103787383.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:07:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create get and set functions for rtbitmap words so that we can redefine
> the ondisk format with a specific endianness.  Note that this requires
> the definition of a distinct type for ondisk rtbitmap words so that the
> compiler can perform proper typechecking as we go back and forth.
> 
> In the upcoming rtgroups feature, we're going to fix the problem that
> rtwords are written in host endian order, which means we'll need the
> distinct rtword/rtword_raw types.

I've been looking over this and I have to say I kinda hate the
abstraction level.

Having to deal with both the union xfs_rtword_ondisk, and the
normal in-memory rtword just feels cumbersome.

I'd go for an API that gets/sets the values based on [bp, word] indices
instead.  That would also need helpers for logging the buffer ranges
based on indices, which seems helpful for the code quality anyway.

I don't really want to burden that on you and would offer to do that
work myself after we work before this merged.

