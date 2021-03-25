Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AD8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8229F61A1A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 08:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCYIlc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:41:32 -0400
Received: from verein.lst.de ([213.95.11.211]:40191 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhCYIlS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 04:41:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D19B968CF0; Thu, 25 Mar 2021 09:41:16 +0100 (CET)
Date:   Thu, 25 Mar 2021 09:41:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/18] xfs: move the di_cowextsize field to struct
 xfs_inode
Message-ID: <20210325084113.GC28146@lst.de>
References: <20210324142129.1011766-1-hch@lst.de> <20210324142129.1011766-12-hch@lst.de> <20210324183130.GJ22100@magnolia> <20210324183349.GM22100@magnolia> <20210324184224.GT22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324184224.GT22100@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 11:42:24AM -0700, Darrick J. Wong wrote:
> > > /me wonders if you wouldn't mind converting these open coded shifts to
> > > XFS_FSB_TO_B and XFS_B_TO_FSBT as a new patch at the end of this series?
> > 
> > Heh, you did already, ignore this question. :)
> 
> ...and now I go for a record /third/ reply to ask if you wouldn't mind
> adding a patch to do the XFS_B_TO_FSBT conversion on xfs_ioctl_setattr?

Sure, I can add a patch for that.
