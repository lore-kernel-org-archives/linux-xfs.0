Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51394 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752153AbeEKHCH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 03:02:07 -0400
Date: Fri, 11 May 2018 09:05:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/14] xfs: rename on-disk dquot counter zap functions
Message-ID: <20180511070552.GA8774@lst.de>
References: <152596612549.27525.9876256551560849585.stgit@magnolia> <152596621328.27525.8570053354806323352.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152596621328.27525.8570053354806323352.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

On Thu, May 10, 2018 at 08:30:13AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function 'xfs_qm_dqiterate' doesn't iterate dquots at all, it
> iterates all dquot blocks of a quota inode and clears the counters.
> Therefore, change the name to something more descriptive so that we can
> introduce a real dquot iterator later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
