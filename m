Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37066 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932428AbeFFKvv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Jun 2018 06:51:51 -0400
Date: Wed, 6 Jun 2018 12:59:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/6] fs: factor out a __generic_write_end helper
Message-ID: <20180606105906.GA11821@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <20180606104033.4947-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180606104033.4947-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

On Wed, Jun 06, 2018 at 12:40:28PM +0200, Christoph Hellwig wrote:
> Bits of the buffer.c based write_end implementations that don't know
> about buffer_heads and can be reused by other implementations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This actually already had two reviews:

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

That got lost through the detour via gfs2.
