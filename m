Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51400 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbeEKHCo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 03:02:44 -0400
Date: Fri, 11 May 2018 09:06:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/14] xfs: refactor dquot iteration
Message-ID: <20180511070629.GB8774@lst.de>
References: <152596612549.27525.9876256551560849585.stgit@magnolia> <152596621951.27525.17666000748368171910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152596621951.27525.17666000748368171910.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

On Thu, May 10, 2018 at 08:30:19AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper function to iterate all the dquots of a given type in
> the system, and refactor the dquot scrub to use it.  This will get more
> use in the quota repair code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
