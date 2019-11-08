Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD63FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28F092178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfKHGue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:50:34 -0500
Received: from verein.lst.de ([213.95.11.211]:33141 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfKHGue (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 01:50:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AB16968BE1; Fri,  8 Nov 2019 07:50:32 +0100 (CET)
Date:   Fri, 8 Nov 2019 07:50:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove XFS_IOC_FSSETDM and
 XFS_IOC_FSSETDM_BY_HANDLE
Message-ID: <20191108065032.GA30861@lst.de>
References: <20191108052303.15052-1-hch@lst.de> <20191108064801.GM6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108064801.GM6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 10:48:01PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 08, 2019 at 06:23:03AM +0100, Christoph Hellwig wrote:
> > Thes ioctls set DMAPI specific flags in the on-disk inode, but there is
> > no way to actually ever query those flags.  The only known user is
> > xfsrestore with the -D option, which is documented to be only useful
> > inside a DMAPI enviroment, which isn't supported by upstream XFS.
> 
> Hmm, shouldn't we deprecate this at least for one or two releases?
> 
> Even if it's functionally pointless...

It sets a value we can't even retreive.  Not sure what the deprecation
would help with.
