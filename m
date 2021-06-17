Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E33C49361
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F926120A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhFQQNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhFQQMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 12:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48E2861426;
        Thu, 17 Jun 2021 16:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623946242;
        bh=bVNxXuhhSfLpOWUzmKOD9K8IMXNfnnj1PbFSNd81SN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQQy9HPeoFbOfYpT7KsY54PbqRV87jkVpqcQduM9Gw7+51JDpVnJMhgzoqxuF9gj6
         Z/Vo3+3cru8H/0kH8BHEfAkTi9eMOaJoBuVkPXdlJZ3HcsdmubsKCkG7fNSCjsHfPp
         N93oJkVcwhh8o+5HAl+ObGRL7pUxMDiR6YzAz6qoK8WGx4mEigTfz/EwcK4BfxcWK5
         QROFwse/mJecOTA8IsYxHzfCpoJ5l1HWo89alf16UCIBk1D5II5pQl6xgOoGyF3CjJ
         60a2dszWHd4YBBHqd8KQoI5UvrVEuRlfsVdv1YMcFGeZSzSCyk0HPIyMyw3+NvikVB
         43jq1gBzrgrBg==
Date:   Thu, 17 Jun 2021 09:10:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: print name of function causing fs shutdown
 instead of hex pointer
Message-ID: <20210617161041.GM158209@locust>
References: <162388772484.3427063.6225456710511333443.stgit@locust>
 <162388773604.3427063.17701184250204042441.stgit@locust>
 <YMsDmxk6nKehJP0q@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMsDmxk6nKehJP0q@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 09:11:07AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 16, 2021 at 04:55:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In xfs_do_force_shutdown, print the symbolic name of the function that
> > called us to shut down the filesystem instead of a raw hex pointer.
> > This makes debugging a lot easier:
> > 
> > XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> > 	fs/xfs/xfs_log.c. Return address = ffffffffa038bc38
> > 
> > becomes:
> > 
> > XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
> > 	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
> 
> Symbolic names looks very useful here.  But can we take a step back
> to make this whole printk much more useful, something like:
> 
> XFS (sda): Forced shutdown (log I/O error) at fs/xfs/xfs_trans.c:385 (xfs_trans_mod_sb+0x25).
> 
> That is print the reason as a string, and mke the whole thing less
> verbose and more readable.

Um, we /do/ log the error already; a full shutdown report looks like:

XFS (sda): xfs_do_force_shutdown(0x2) called from line 2440 of file
	fs/xfs/xfs_log.c. Return address = xfs_trans_mod_sb+0x25
XFS (sda): Corruption of in-memory data detected.  Shutting down
	filesystem

Or are you saying that we should combine them into a single message?

XFS (sda): Corruption of in-memory data detected at xlog_write+0x10
	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.

XFS (sda): Log I/O error detected at xlog_write+0x10
	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.

XFS (sda): I/O error detected at xlog_write+0x10
	(fs/xfs/xfs_log.c:2440).  Shutting down filesystem.

etc?

--D
