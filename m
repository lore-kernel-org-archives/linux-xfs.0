Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E78C46467
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 18:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjASSjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 13:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjASSjg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 13:39:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3C88C922
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 10:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MbGu6Xrxo/r8SfzaC7TdjqOD8FEycXxjKHoBEOsn0vM=; b=qAvjPGD6xEQ6ndEjtyEeHDMShn
        K8o3YwhMIcJwXKZX9XMhKcWqzfJqK+PzIeP2MT4dZCBp5iSp6PyvOOPMI7IxOWCFAW1UqSJ3e3tmN
        GdMfXKRldMgEA8Y2I5BeJE2MDEGjOQVBbC9fnETEWhRO/1cFYrYaYCZpK0so/wK3/Nx17FFTAfRHp
        tE5X74/clPll9qaplbBDb8cn+wGH+R20uToKBs7PA0sad9dG4TJ1j9CFIaXewLNEjIq1WCvLLoRRY
        eu+M30Pn5mD6mqLPO2GnJp6hbks3Jo+IuLp8j47ecix+3kHh0fJph0u+VNiLHKVsDPPvxJhuu5ePt
        y1+Afqvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIZp0-006bKg-C1; Thu, 19 Jan 2023 18:39:34 +0000
Date:   Thu, 19 Jan 2023 10:39:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: recheck appropriateness of map_shared lock
Message-ID: <Y8mOZvGlkmkjUSvv@infradead.org>
References: <Y8ib6ls32e/pJezE@magnolia>
 <20230119051411.GJ360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119051411.GJ360264@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 04:14:11PM +1100, Dave Chinner wrote:
> If we hit this race condition, re-reading the extent list from disk
> isn't going to fix the corruption, so I don't see much point in
> papering over the problem just by changing the locking and failing
> to read in the extent list again and returning -EFSCORRUPTED to the
> operation.

Yep.

> So.... shouldn't we mark the inode as sick when we detect the extent
> list corruption issue? i.e. before destroying the iext tree, calling
> xfs_inode_mark_sick(XFS_SICK_INO_BMBTD) (or BMBTA, depending on the
> fork being read) so that there is a record of the BMBT being
> corrupt?

Yes.

> That would mean that this path simply becomes:
> 
> 	if (ip->i_sick & XFS_SICK_INO_BMBTD) {
> 		xfs_iunlock(ip, lock_mode);
> 		return -EFSCORRUPTED;
> 	}

This path being xfs_ilock_{data,attr}_map_shared?  These don't
return an error.  But if we make sure xfs_need_iread_extents
returns true for XFS_SICK_INO_BMBTD, xfs_iread_extents can
return -EFSCORRUPTED.
