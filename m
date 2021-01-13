Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095BBC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 20:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB51222DFA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 20:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbhAMUmD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 15:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbhAMUmD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jan 2021 15:42:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF8322DD3;
        Wed, 13 Jan 2021 20:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610570482;
        bh=StOCoZfM/9ZtFGcHdooCBWjGjl9Tbk0Oh+2BrxjFnuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3YaEMg9lJsoTVY1+d16B3qahln3DRBTiwSo5aJRiu+U9uJ98pgWiBq7JtA4HyMcl
         2NKC+Wv/BVnBcwi0+rckq9J+Dc0bwzn1uDyazC50/31vbhAODytnWOreB1gNBAgPke
         i3+HUvgFs2J7y0WmvNC2Bt/vYlfdXdTwr+3CSKw28Vm1pBTHBRavtGO5iE4+BFwZ4z
         MWWZV2naK+sIkJD1He/u1qlyBrfiPesTbo8c30QNznqBSllWehqzH+JPPCtzGa2d+6
         Qhod5gkpwY1FqhqsCVQkNmjpFVVsvvx+bSSohHeKLXiAgZgV8qe9ES3Uak0T5lwt4G
         kW7E0yQ6dPUqA==
Date:   Wed, 13 Jan 2021 12:41:22 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: only walk the incore inode tree once per
 blockgc scan
Message-ID: <20210113204122.GS1164246@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040742666.1582286.3910636058356753098.stgit@magnolia>
 <X/8MeHhdwKLf3TCb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/8MeHhdwKLf3TCb@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 13, 2021 at 04:06:32PM +0100, Christoph Hellwig wrote:
> On Mon, Jan 11, 2021 at 03:23:46PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Perform background block preallocation gc scans more efficiently by
> > walking the incore inode tree once.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Looks good.  If you could find a way to avoid the forward declarations
> I'd be even more happy :)

They went away as a part of the massive rework stemming from Dave's
"simple" review comment in the previous series about moving the ENOSPC
retry loops into the quota reservation functions.

Granted, the double series has ballooned from 13 to 28 patches as I had
to clean up even more quota code... :(

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
