Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F09C4BA14
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3376024688
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 15:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBZPHJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 10:07:09 -0500
Received: from verein.lst.de ([213.95.11.211]:49280 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgBZPHJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Feb 2020 10:07:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC09E68CEE; Wed, 26 Feb 2020 16:07:06 +0100 (CET)
Date:   Wed, 26 Feb 2020 16:07:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/30] xfs: pass an initialized xfs_da_args structure
 to xfs_attr_set
Message-ID: <20200226150706.GA19599@lst.de>
References: <20200225231012.735245-1-hch@lst.de> <20200225231012.735245-11-hch@lst.de> <20200226002109.GS10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226002109.GS10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 11:21:09AM +1100, Dave Chinner wrote:
> >  		/* subtract away the unused acl entries */
> > -		len -= sizeof(struct xfs_acl_entry) *
> > +		args.valuelen -= sizeof(struct xfs_acl_entry) *
> >  			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
> 
> why do we allocate a maximally sized buffer for the attribute data
> (64kB for v5 filesystems) when we already know the size of the
> data we are about to format into it? Why isn't this just:
> 
> 	if (acl) {
> 		args.valuelen = sizeof(struct xfs_acl_entry) * acl->a_count;
> 		args.value = kmem_zalloc_large(args.valuelen, 0);
> 		if (!args.value)
> 			return -ENOMEM;
> 
> 		xfs_acl_to_disk(args.value, acl); 
> 	}

We need to also account for the size of the acl header, and have the
XFS_ACL_SIZE macro to do so. But with that it makes sense, and I've
added a patch to do so to the end of the series.
