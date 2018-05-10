Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46970 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756732AbeEJIWY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 May 2018 04:22:24 -0400
Date: Thu, 10 May 2018 10:26:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/13] xfs: remove direct calls to _qm_dqread
Message-ID: <20180510082600.GA13114@lst.de>
References: <152506698177.21553.13500862866416804148.stgit@magnolia> <152506705098.21553.6894396720813018127.stgit@magnolia> <20180508000535.GZ11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508000535.GZ11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de, Dave Chinner <david@fromorbit.com>

On Mon, May 07, 2018 at 05:05:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The quota initialization code needs an "uncached" variant of _dqget to
> read in default quota limits and timers before the dquot cache is fully
> set up.  We've already split up _dqget into its component pieces so
> create a fourth variant to address this need, and make dqread internal
> to xfs_dquot.c again.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

But can you please resend the whole series?  I've lost track of all the
updates..
