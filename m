Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A064C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE372083B
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 13:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgFSNft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 09:35:49 -0400
Received: from verein.lst.de ([213.95.11.211]:53645 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbgFSNft (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 09:35:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3F8F568AFE; Fri, 19 Jun 2020 15:35:47 +0200 (CEST)
Date:   Fri, 19 Jun 2020 15:35:46 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: kill of struct xfs_icdinode
Message-ID: <20200619133546.GA27997@lst.de>
References: <20200524091757.128995-1-hch@lst.de> <20200601125635.GA2043@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601125635.GA2043@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 08:56:35AM -0400, Brian Foster wrote:
> On Sun, May 24, 2020 at 11:17:43AM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series finally remove struct xfs_icdinode, which contained
> > the leftovers of the on-disk inode in the in-core inode by moving
> > the fields into struct xfs_inode itself.
> > 
> 
> JFYI, this series doesn't apply to for-next..

It was based on for-next back when I did it, but it seems the quota
series from Eric was merged since then.
