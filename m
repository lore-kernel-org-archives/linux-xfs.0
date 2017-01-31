Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41344 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbdAaNtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2017 08:49:24 -0500
Date: Tue, 31 Jan 2017 05:29:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: fail _dir_open when readahead fails
Message-ID: <20170131132957.GB17386@infradead.org>
References: <148582218411.12293.806854574193653038.stgit@birch.djwong.org>
 <148582219640.12293.12536546233357325085.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148582219640.12293.12536546233357325085.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

There is an xfs missing in the subject, I think..

On Mon, Jan 30, 2017 at 04:23:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we open a directory, we try to readahead block 0 of the directory
> on the assumption that we're going to need it soon.  If the bmbt is
> corrupt, the directory will never be usable and the readahead fails
> immediately, so we might as well prevent the directory from being opened
> at all.  This prevents a subsequent read or modify operation from
> hitting it and taking the fs offline.

I think this looks fine, but the patch description is a bit odd -
we don't actually check for failures for the actual read-ahead, just
for the block mapping, which I guess is what you need anyway.

So with a slight update to the patch descriptions:

Reviewed-by: Christoph Hellwig <hch@lst.de>
