Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54941 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbeDWRcS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:32:18 -0400
Date: Mon, 23 Apr 2018 19:33:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/13] xfs: replace XFS_QMOPT_DQALLOC with
        XFS_DQGET_{ALLOC, EXISTS}
Message-ID: <20180423173341.GJ834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440962542.29601.4228199041127085137.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440962542.29601.4228199041127085137.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:07:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
> _dqget family of functions cares about is DQALLOC.  Therefore, change
> the name to make it clear that it's only a dqget flag.  Since these are
> modes and no longer bit flags, define a XFS_DQGET_EXISTS flag and
> convert all the callers.

I'm almost tempted to just have a 'bool alloc' argument instead.
