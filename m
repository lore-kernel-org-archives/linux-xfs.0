Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDE3CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjJLFFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbjJLFFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:05:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD575C0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:05:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 75AC16732D; Thu, 12 Oct 2023 07:05:27 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:05:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCHSET RFC v1.0 0/7] xfs: clean up realtime type usage
Message-ID: <20231012050527.GJ1637@lst.de>
References: <20231011175711.GM21298@frogsfrogsfrogs> <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704720721.1773388.10798471315209727198.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:01:16AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
> places, and it's very confusing.  Clean up all the type usage so that an
> xfs_rtblock_t is always a block within the realtime volume, an
> xfs_fileoff_t is always a file offset within a realtime metadata file,
> and an xfs_rtxnumber_t is always a rt extent within the realtime volume.

Question as a follow up:  now that we have proper types for all
the RT-specific units, what's the point of even keeping xfs_rtblock_t
around vs always using xfs_fsblock_t or xfs_rfsblock_t?

