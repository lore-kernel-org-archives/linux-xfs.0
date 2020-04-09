Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8CBC2BA2B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 12:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 174B720A8B
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 12:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDIMla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 08:41:30 -0400
Received: from verein.lst.de ([213.95.11.211]:46544 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgDIMla (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Apr 2020 08:41:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 213DF68C4E; Thu,  9 Apr 2020 14:41:28 +0200 (CEST)
Date:   Thu, 9 Apr 2020 14:41:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V6 6/8] fs/xfs: Combine xfs_diflags_to_linux() and
 xfs_diflags_to_iflags()
Message-ID: <20200409124127.GB18171@lst.de>
References: <20200407182958.568475-1-ira.weiny@intel.com> <20200407182958.568475-7-ira.weiny@intel.com> <20200408020827.GI24067@dread.disaster.area> <20200408170923.GC569068@iweiny-DESK2.sc.intel.com> <20200408210236.GK24067@dread.disaster.area> <CAPcyv4gLvMSA9BypvWbYtv3xsK8o4+db3kvxBozUGAjr_sDDFQ@mail.gmail.com> <20200408235836.GQ24067@dread.disaster.area> <20200409002203.GE664132@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409002203.GE664132@iweiny-DESK2.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 05:22:03PM -0700, Ira Weiny wrote:
> > You mean something like XFS_IDONTCACHE?
> > 
> > i.e. the functionality already exists in XFS to selectively evict an
> > inode from cache when the last reference to it is dropped rather
> > than let it go to the LRUs and hang around in memory.
> > 
> > That flag can be set when changing the on disk DAX flag, and we can
> > tweak how it works so new cache hits don't clear it (as happens
> > now). Hence the only thing that can prevent eviction are active
> > references.
> > 
> > That means we'll still need to stop the application and drop_caches,
> > because we need to close all the files and purge the dentries that
> > hold references to the inode before it can be evicted.
> 
> That sounds like a great idea...
> 
> Jan?  Christoph?

Sounds ok.  Note that we could also pretty trivially lift
XFS_IDONTCACHE to the VFS if we need to apply the same scheme to
ext4.
