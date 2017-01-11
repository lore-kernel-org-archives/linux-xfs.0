Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34131 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936380AbdAKIiU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:38:20 -0500
Date: Wed, 11 Jan 2017 09:38:18 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 3/6] xfs: add missing include dependencies to
        xfs_dir2.h
Message-ID: <20170111083818.GA6744@lst.de>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com> <1484123050-11064-4-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484123050-11064-4-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 10:24:07AM +0200, Amir Goldstein wrote:
> xfs_dir2.h dereferences some data types in inline functions
> and fails to include those type definitions, e.g.:
> xfs_dir2_data_aoff_t, struct xfs_da_geometry.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

I'd normally fold this into the patch that actually exposes the
dependency.  But except for that it looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
