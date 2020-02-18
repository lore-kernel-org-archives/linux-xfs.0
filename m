Return-Path: <SRS0=Vmdp=4G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FA2C34026
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 15:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDFF2464E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Feb 2020 15:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBRP2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 10:28:43 -0500
Received: from verein.lst.de ([213.95.11.211]:38728 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgBRP2n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:28:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 03AE168BE1; Tue, 18 Feb 2020 16:28:41 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:28:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 06/31] xfs: factor out a helper for a single
 XFS_IOC_ATTRMULTI_BY_HANDLE op
Message-ID: <20200218152840.GC21275@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-7-hch@lst.de> <20200217222809.GK10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217222809.GK10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 09:28:09AM +1100, Dave Chinner wrote:
> > +int
> > +xfs_ioc_attrmulti_one(
> > +	struct file		*parfilp,
> 
> Weird name for the file pointer. It's just a file pointer in this
> context, similar to...
> 
> > +	struct inode		*inode,
> 
> ... it just being an inode pointer in this context.

The naming is taken from the existing code.  I think it stands for
parent which isn't quite true, but I think it tries to to document the
point that the file pointer is not for the inode we are operating on,
but some random open file on the file system that the handle operation
execures on.

> 
> > +	uint32_t		opcode,
> > +	void __user		*uname,
> > +	void __user		*value,
> > +	uint32_t		*len,
> > +	uint32_t		flags)
> > +{
> > +	unsigned char		*name;
> > +	int			error;
> > +
> > +	if ((flags & ATTR_ROOT) && (flags & ATTR_SECURE))
> > +		return -EINVAL;
> > +	flags &= ~ATTR_KERNEL_FLAGS;
> 
> Ok, so this is a user ABI visible change - the old code would return
> to userspace with these flags cleared from ops[i].am_flags. Now that
> doesn't happen. I don't see this as a problem, but it needs to be
> documented in the commit message.

Well, the clearing was just added the current merge window, before that
userspace could pass and them and cause havoc..

> > +		/*FALLTHRU*/
> 
> All the recent code we've added uses:
> 
> 		/* fall through */
> 
> for this annotation - it's the most widely used variant in the
> XFS codebase, so it would be good to be consistent here...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
---end quoted text---
