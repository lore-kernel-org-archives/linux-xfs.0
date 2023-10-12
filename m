Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1278CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 18:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379624AbjJLSTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 14:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379577AbjJLSTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 14:19:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC74CA9
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 11:19:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60613C433C8;
        Thu, 12 Oct 2023 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697134749;
        bh=KTITqoJAf5F+NL9SYC3iC6i9qcZZA1HOC4oTSlSPsbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdLDmMAvG6Do1KQ1vVJIGdCIlxHgdTnNVnrwZSiCvZQ7Ll7h3ux19rbegdY5t0kX/
         W7vGz92Sj/3v5DvrehPGt4PDxGywWldfQ20ZUqGNsuCvQ0ukIjRFVaD52jBujDd7aw
         DRrgws7zq6gT2HUkdgvWcz37SBmzFDNDEXyvXHfylMw4jFwvDP34qE9cHVSdIzA3ta
         STBj+u1lRE/rGc3vePLJxHq5TfP0XtwP83nYZov3gO2pvPwfQYJu3nKWAEhC0lYhZi
         R8t9FzR6QvOo8Derl/EH0h/J7CSsT0z8LY5uREfoivU9HQpGGDa4oRw5f0O/sOMYpM
         BGOchUN6Lgf5g==
Date:   Thu, 12 Oct 2023 11:19:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 7/7] xfs: use shifting and masking when converting rt
 extents, if possible
Message-ID: <20231012181908.GK21298@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721284.1773611.1915589661676489.stgit@frogsfrogsfrogs>
 <20231012052511.GF2184@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231012052511.GF2184@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:25:11AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:06:14AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Avoid the costs of integer division (32-bit and 64-bit) if the realtime
> > extent size is a power of two.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Do you have any data on how common non-power of two rtext sizes are?
> Might it be worth to add unlikely annotations?

I don't really know about the historical uses.  There might be old
filesystems out there with a non-power-of-2 raid stripe size that are
set up for full stripe allocations for speed.

We (oracle) are interested in using rt for PMD allocations on pmem/cxl
devices and atomic writes on scsi/nvme devices.  Both of those cases
will only ever use powers of 2.

I'll add some if-test annotations and we'll see if anyone notices. ;)

--D

> > @@ -11,6 +11,9 @@ xfs_rtx_to_rtb(
> >  	struct xfs_mount	*mp,
> >  	xfs_rtxnum_t		rtx)
> >  {
> > +	if (mp->m_rtxblklog >= 0)
> > +		return rtx << mp->m_rtxblklog;
> > +
> >  	return rtx * mp->m_sb.sb_rextsize;
> 
> i.e.
> 
> 	if (unlikely(mp->m_rtxblklog == ‐1))
> 	  	return rtx * mp->m_sb.sb_rextsize;
> 	return rtx << mp->m_rtxblklog;
> 
