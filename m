Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC401C48BE8
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 16:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95896611CC
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 16:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229466AbhFRQHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 12:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbhFRQHt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 12:07:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A54613B4;
        Fri, 18 Jun 2021 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624032339;
        bh=MZ7D8fDKLlgS09qaeBwrihn7mKX9MOnzLIbWDE/oS0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptj/l6MqwdJX4rdUR5SPZ2e0Ga2XwA/IcEzdtkejzG64peWmGWdplQvOqEmFUfqhp
         Sg/QRmJRklg9zUoV7Ji4uh2CpNLpxgdE6KqL8tUFEf1vFY//vJDzIQ9yxIY8X2VSgN
         HQwcXaRtFo+g3BkWxesXL3sivOwWFIH7tvRRWbG0gYqFsFDc/imlzXTag8rEBErvjV
         PBPAY124p4eHGmt4ZzGqdGeX9MCUX84a6vYGo0QwA0oam+hgkBf3vEuYgiNP3gcona
         oire9xjfKNeR3sQrS2Uwgm2ifbFWD0CiMQWPn96uNP/M1oKIoI8krWT1gGbhVXHrSC
         nIJ0YYVCGMnwg==
Date:   Fri, 18 Jun 2021 09:05:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <20210618160539.GF158209@locust>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773604.3427063.17701184250204042441.stgit@locust>
 <YMsDmxk6nKehJP0q@infradead.org>
 <20210617161041.GM158209@locust>
 <YMymlgzxg4IYHPyi@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMymlgzxg4IYHPyi@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 02:58:46PM +0100, Christoph Hellwig wrote:
> On Thu, Jun 17, 2021 at 09:10:41AM -0700, Darrick J. Wong wrote:
> > Um, we /do/ log the error already; a full shutdown report looks like:
> > 
> > XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> > 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
> > XFS (sda): Corruption of in-memory data detected.  Shutting down
> > 	filesystem
> 
> Yeah, it's pretty verbose.
> 
> > Or are you saying that we should combine them into a single message?
> > 
> > XFS (sda): Corruption of in-memory data detected at xlog_write+0x10
> > 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> > 
> > XFS (sda): Log I/O error detected at xlog_write+0x10
> > 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> > 
> > XFS (sda): I/O error detected at xlog_write+0x10
> > 	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.
> > 
> > etc?
> 
> I think that reads much nicer.  So if we cause some churn in this area
> we might as well go with that.

Ok, I'll prepare a new patch to consolidate all that.

--D
