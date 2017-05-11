Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53728 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755137AbdEKMML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 08:12:11 -0400
Date: Thu, 11 May 2017 05:12:06 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: BMAPX shouldn't barf on inline-format directories
Message-ID: <20170511121206.GB8659@infradead.org>
References: <20170510182325.GC5639@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510182325.GC5639@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>

On Wed, May 10, 2017 at 11:23:25AM -0700, Darrick J. Wong wrote:
> When we're fulfilling a BMAPX request, jump out early if the data fork
> is in local format.  This prevents us from hitting a debugging check in
> bmapi_read and barfing errors back to userspace.  The on-disk extent
> count check later isn't sufficient for IF_DELALLOC mode because da
> extents are in memory and not on disk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
