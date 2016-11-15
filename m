Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58544 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966031AbcKOKTV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:19:21 -0500
Date: Tue, 15 Nov 2016 02:19:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] libxfs: clean up _dir2_data_freescan
Message-ID: <20161115101915.GJ1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830454147.26713.11280885080763890502.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830454147.26713.11280885080763890502.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:09:01PM -0700, Darrick J. Wong wrote:
> Refactor the implementations of xfs_dir2_data_freescan into a
> routine that takes the raw directory block parameters and
> a second function that figures out the raw parameters from the
> directory inode.  This enables us to use the exact same code
> for both userspace and the kernel, since repair knows exactly
> which directory block geometry parameters it needs.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
