Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51700 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeEGPGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 11:06:32 -0400
Date: Mon, 7 May 2018 08:06:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] xfs: bmap debugging should never panic the system
Message-ID: <20180507150631.GA22414@infradead.org>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537075974.16676.4678069099698404803.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537075974.16676.4678069099698404803.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:05:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't panic() the system if the bmap records are garbage, just call
> ASSERT which gives us the same backtrace but enables developers to
> control if the system goes down or not.  This makes debugging with
> generic/388 much easier because it won't reboot the machine midway
> through a run just because btree_read_bufl returns EIO when the fs has
> already shut down.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
