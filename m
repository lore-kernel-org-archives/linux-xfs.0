Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7619BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 17:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbjJaRPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 13:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbjJaRPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 13:15:04 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A356F7
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 10:15:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6409667373; Tue, 31 Oct 2023 18:14:59 +0100 (CET)
Date:   Tue, 31 Oct 2023 18:14:59 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH, realtime-rmap branch] xfs: lock the RT bitmap inode in
 xfs_efi_item_recover
Message-ID: <20231031171459.GB31580@lst.de>
References: <20231031095038.1559309-1-hch@lst.de> <20231031165330.GC1041814@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031165330.GC1041814@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 09:53:30AM -0700, Darrick J. Wong wrote:
> >  		if (!requeue_only) {
> >  			xfs_extent_free_get_group(mp, &fake);
> > +			if (xfs_efi_is_realtime(&fake))
> > +				xfs_rtbitmap_lock(tp, mp);
> 
> Curious, I thought that patch "xfs: support logging EFIs for realtime
> extents" already locked the rt bitmap?

> So that by the time we get to this part of the loop, the rtbitmap will
> be locked already?

Yes.  Indeed that problem was caused by my hacked tree.  Feel free to
discard this message.
