Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751923AbeEGPGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 11:06:45 -0400
Date: Mon, 7 May 2018 08:06:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] xfs: add missing rmap error return
Message-ID: <20180507150644.GB22414@infradead.org>
References: <152537075334.16676.10600900179473864298.stgit@magnolia>
 <152537076596.16676.8860720933298336661.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152537076596.16676.8860720933298336661.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 11:06:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_rmap_lookup_le_range can return errors, so we need to check for
> them and bail out.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
