Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59098 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdDLGA2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Apr 2017 02:00:28 -0400
Date: Wed, 12 Apr 2017 08:00:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: remove xfs_bmap_remap_alloc
Message-ID: <20170412060026.GB20204@lst.de>
References: <20170411111011.9437-1-hch@lst.de> <20170411111011.9437-6-hch@lst.de> <20170411230246.GG8502@birch.djwong.org> <20170412053839.GA19900@lst.de> <20170412055535.GI8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412055535.GI8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> Looks like _bmapi_remap needs to be able to _iread_extents() if the
> data fork hasn't been loaded during log recovery.

Yeah, probably.  I'll respin once more with that included.
