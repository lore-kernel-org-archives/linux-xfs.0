Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E201C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 14:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7292120781
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 14:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391145AbgFXOKX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 10:10:23 -0400
Received: from verein.lst.de ([213.95.11.211]:44477 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388395AbgFXOKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jun 2020 10:10:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 20EAB68B02; Wed, 24 Jun 2020 16:10:20 +0200 (CEST)
Date:   Wed, 24 Jun 2020 16:10:19 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: move the di_flags2 field to struct xfs_inode
Message-ID: <20200624141019.GA13932@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-13-hch@lst.de> <83835142.PHEsXu1aPz@garuda> <113775697.lumUs5xBWa@garuda> <20200624072537.GC18609@lst.de> <20200624140325.GI7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624140325.GI7606@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 07:03:25AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 24, 2020 at 09:25:37AM +0200, Christoph Hellwig wrote:
> > On Mon, Jun 22, 2020 at 06:53:23PM +0530, Chandan Babu R wrote:
> > > On Monday 22 June 2020 6:21:37 PM IST Chandan Babu R wrote:
> > > > On Saturday 20 June 2020 12:40:59 PM IST Christoph Hellwig wrote:
> > > > > In preparation of removing the historic icinode struct, move the flags2
> > > > > field into the containing xfs_inode structure.
> > > > >
> > > > 
> > > > The changes look good to me.
> > > > 
> > > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > 
> > > The commit "fs/xfs: Update xfs_ioctl_setattr_dax_invalidate()"
> > > (e4f9ba20d3b8c2b86ec71f326882e1a3c4e47953) adds the function
> > > xfs_ioctl_setattr_prepare_dax() which refers to xfs_icdinode->di_flags2. A
> > > rebase should solve this issue.
> > 
> > That doesn't exist in xfs/for-next yet.  Darrick, do you want me to
> > rebase on top of Linus' tree?
> 
> Sure?  I haven't really started working on 5.8 fixes branches yet,
> but I'll fast-forward for-next up to 5.8-rc1.

I can also wait a bit.  Note that we're at -rc2 and half-way to rc3 :)

