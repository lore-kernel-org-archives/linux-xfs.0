Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21F8C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7102053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfLXL5S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:57:18 -0500
Received: from verein.lst.de ([213.95.11.211]:59147 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfLXL5S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Dec 2019 06:57:18 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 77C5468B20; Tue, 24 Dec 2019 12:57:15 +0100 (CET)
Date:   Tue, 24 Dec 2019 12:57:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 03/33] xfs: also remove cached ACLs when removing the
 underlying attr
Message-ID: <20191224115715.GC30689@lst.de>
References: <20191212105433.1692-1-hch@lst.de> <20191212105433.1692-4-hch@lst.de> <20191218213108.GF7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218213108.GF7489@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 01:31:08PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 12, 2019 at 11:54:03AM +0100, Christoph Hellwig wrote:
> > We should not just invalidate the ACL when setting the underlying
> > attribute, but also when removing it.  The ioctl interface gets that
> > right, but the normal xattr inteface skipped the xfs_forget_acl due
> > to an early return.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Shouldn't someone have a testcase for this?

adding Andreas, who wrote this code originally.
