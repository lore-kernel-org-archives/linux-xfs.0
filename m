Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbeJKVHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 17:07:46 -0400
Date: Thu, 11 Oct 2018 06:40:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/25] vfs: vfs_clone_file_prep_inodes should return
 EINVAL for a clone from beyond EOF
Message-ID: <20181011134029.GB23424@infradead.org>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115041.5546.14464512857556875980.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923115041.5546.14464512857556875980.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 09:12:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> vfs_clone_file_prep_inodes cannot return 0 if it is asked to remap from
> a zero byte file because that's what btrfs does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Maybe it would be a good time to switch btrfs to use
vfs_clone_file_prep_inodes so that we don't have any discrepancies?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
