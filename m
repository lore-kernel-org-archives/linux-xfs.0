Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54868 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755492AbeDWRMD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:12:03 -0400
Date: Mon, 23 Apr 2018 19:13:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/13] xfs: refactor XFS_QMOPT_DQNEXT out of existence
Message-ID: <20180423171326.GA834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440955861.29601.18309284922689232857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440955861.29601.18309284922689232857.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:05:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's only one caller of DQNEXT and its semantics can be moved into a
> separate function, so create the function and get rid of the flag.

Is there any good reason to keep the xfs_qm_scall_getquota{,next} helpers
instead of simplify factoring them into their only caller?

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
