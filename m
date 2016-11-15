Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56565 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941560AbcKOKRN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:17:13 -0500
Date: Tue, 15 Nov 2016 02:17:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/16] libxfs: refactor btree crc verifier
Message-ID: <20161115101712.GF1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451684.26713.17449721738475726138.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830451684.26713.17449721738475726138.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:08:36PM -0700, Darrick J. Wong wrote:
> In a65d8d293b ("libxfs: validate metadata LSNs against log on v5
> superblocks") the hascrc check was modified to use the helper mp
> variable in the kernel.  This was left out of the xfsprogs patch, so
> change it here too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
