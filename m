Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33063 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966530AbcKOKXD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:23:03 -0500
Date: Tue, 15 Nov 2016 02:23:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/10] libxfs: synchronize dinode_verify with userspace
Message-ID: <20161115102302.GR1607@infradead.org>
References: <147830459629.27129.4541676333173489075.stgit@birch.djwong.org>
 <147830460861.27129.18192591373798647305.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830460861.27129.18192591373798647305.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:10:08PM -0700, Darrick J. Wong wrote:
> The userspace version of _dinode_verify takes a raw inode number
> instead of an inode itself.  Since neither version actually needs
> the inode, port the changes to the kernel.  This will also reduce
> the libxfs diff noise.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
