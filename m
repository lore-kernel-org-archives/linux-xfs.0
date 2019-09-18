Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E6BC4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61BA208C0
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 17:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfIRRZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 13:25:49 -0400
Received: from verein.lst.de ([213.95.11.211]:34748 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729838AbfIRRZt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 13:25:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F16BA68B05; Wed, 18 Sep 2019 19:25:45 +0200 (CEST)
Date:   Wed, 18 Sep 2019 19:25:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/19] xfs: remove xfs_reflink_dirty_extents
Message-ID: <20190918172545.GA19884@lst.de>
References: <20190909182722.16783-1-hch@lst.de> <20190909182722.16783-10-hch@lst.de> <20190918171733.GA2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918171733.GA2229799@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:17:33AM -0700, Darrick J. Wong wrote:
> >  /*
> >   * Pre-COW all shared blocks within a given byte range of a file and turn off
> >   * the reflink flag if we unshare all of the file's blocks.
> > + *
> > + * Let iomap iterate all extents to see which are shared and not unwritten or
> > + * delalloc and read them into the page cache, dirty them, fsync them back out,
> > + * and then we can update the inode flag.  What happens if we run out of
> > + * memory? :)
> 
> I don't know, what /does/ happen? :)
> 
> It /should/ be fine, right?  Writeback will start pushing the dirty
> cache pages to disk, and since writeback only takes the ILOCK, it should
> be able to perform the COW even while the unshare process sits on the
> IOLOCK/MMAPLOCK.  True, the unshare process and writeback will both be
> contending on the ILOCK, but that shouldn't be a problem...
> 
> ...unless I'm missing something?  It sure does look nice to drain all
> this other code out.

No idea.  This is your old code just moved down to this function.  But
yes, the comment looks rather confusing and maybe we should just remove
it.
