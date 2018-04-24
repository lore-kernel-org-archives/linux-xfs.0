Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757854AbeDXNHv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:07:51 -0400
Date: Tue, 24 Apr 2018 09:07:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/13] xfs: replace XFS_QMOPT_DQALLOC with
 XFS_DQGET_{ALLOC, EXISTS}
Message-ID: <20180424130748.GB50204@bfoster.bfoster>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440962542.29601.4228199041127085137.stgit@magnolia>
 <20180423173341.GJ834@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423173341.GJ834@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 07:33:41PM +0200, Christoph Hellwig wrote:
> On Sun, Apr 22, 2018 at 08:07:05AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
> > _dqget family of functions cares about is DQALLOC.  Therefore, change
> > the name to make it clear that it's only a dqget flag.  Since these are
> > modes and no longer bit flags, define a XFS_DQGET_EXISTS flag and
> > convert all the callers.
> 
> I'm almost tempted to just have a 'bool alloc' argument instead.

I agree. I'm not a big fan of defining the 'exists' semantic for the
no-flags case. To me, it reads as a behavior modifier until/unless you
catch the fact that it's defined to zero. An alloc param should
self-document the behavior nicely, imo.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
