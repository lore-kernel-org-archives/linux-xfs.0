Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35131 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdJXHyQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 03:54:16 -0400
Date: Tue, 24 Oct 2017 09:54:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: remove xfs_bmbt_validate_extent
Message-ID: <20171024075415.GA14823@lst.de>
References: <20171023063017.11520-1-hch@lst.de> <20171023063017.11520-3-hch@lst.de> <20171023154119.GC5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023154119.GC5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> By removing this, I think we no longer report corruption if we encounter
> 'unwritten' attr fork extents, which (AFAIK) aren't allowed.

True.  Oh well, skip this patch for now if you apply the rest, and
I'll have to do some gymnastics to keep it.
