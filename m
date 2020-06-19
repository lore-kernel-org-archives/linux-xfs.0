Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889B8C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67468208C7
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgFSNmo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 09:42:44 -0400
Received: from verein.lst.de ([213.95.11.211]:53678 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbgFSNmn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 09:42:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 844A568AFE; Fri, 19 Jun 2020 15:42:41 +0200 (CEST)
Date:   Fri, 19 Jun 2020 15:42:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/14] xfs: move the di_dmevmask field to struct
 xfs_inode
Message-ID: <20200619134241.GB27997@lst.de>
References: <20200524091757.128995-1-hch@lst.de> <20200524091757.128995-14-hch@lst.de> <20200603003656.GX8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603003656.GX8230@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 05:36:56PM -0700, Darrick J. Wong wrote:
> On Sun, May 24, 2020 at 11:17:56AM +0200, Christoph Hellwig wrote:
> > In preparation of removing the historic icinode struct, move the
> > dmevmask field into the containing xfs_inode structure.
> 
> Do we even use dmevmask or dmstate?  Why not just get rid of them and
> set them to zero ondisk?

"we" don't really use it, no.  But until recently we had an ioctl to
set it, and bulkstat can report it.  If we didn't have the fields in
xfs_inode we'd thus lose information when changing the inode.

OTOH once Daves series to always read the inode buffer when dirting
the inode is merged we could copy it straight from the buffer to the
log inode.  I'll volunteer to do that work once all the reuquired bit
are merged, but for now I'd just like to kill off the horrible icdinode
structure.
