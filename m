Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54899 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754900AbeDWRYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:24:08 -0400
Date: Mon, 23 Apr 2018 19:25:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/13] xfs: fetch dquots directly during quotacheck
Message-ID: <20180423172531.GF834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440959026.29601.18114675159046762818.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440959026.29601.18114675159046762818.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:30AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Quotacheck only runs during mount, which means that there are no other
> processes in the system that could be doing chown or chproj.  Therefore
> there's no potential for racing to attach dquots to the inode so we can
> drop all the ILOCK and race detection bits from quotacheck.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, one thing I've wondered for a while is if there is any point in
keeping the dquot pointers in the inode at all.  With the radix tree
the dquots should be a few indirections and thus very few cache lines
away at any point in time, while saving us all the setup overhead, as
well as shrinking the inode.
