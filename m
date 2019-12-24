Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E852C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0C1F2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLXL4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:56:38 -0500
Received: from verein.lst.de ([213.95.11.211]:59142 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfLXL4i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Dec 2019 06:56:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4F4F568B20; Tue, 24 Dec 2019 12:56:36 +0100 (CET)
Date:   Tue, 24 Dec 2019 12:56:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 02/33] xfs: reject invalid flags combinations in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20191224115636.GB30689@lst.de>
References: <20191212105433.1692-1-hch@lst.de> <20191212105433.1692-3-hch@lst.de> <20191218212952.GE7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218212952.GE7489@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 01:29:52PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 12, 2019 at 11:54:02AM +0100, Christoph Hellwig wrote:
> > While the flags field in the ABI and the on-disk format allows for
> > multiple namespace flags, that is a logically invalid combination that
> > scrub complains about.  Reject it at the ioctl level, as all other
> > interface already get this right at higher levels.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks ok I think.  We never have attrs in two namespaces at once...
> assuming that "attr_multi(3)" is the right manpage for all this?

Yes, that is the man page for the interface.
