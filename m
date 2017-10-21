Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52338 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752854AbdJUINP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Oct 2017 04:13:15 -0400
Date: Sat, 21 Oct 2017 10:13:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/15] xfs: inline xfs_shift_file_space into callers
Message-ID: <20171021081314.GB21101@lst.de>
References: <20171019065942.18813-1-hch@lst.de> <20171019065942.18813-9-hch@lst.de> <20171021000720.GB4755@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171021000720.GB4755@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> > +	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> 
> So it took me a while of wondering "don't we have to have the
> MMAPLOCK_EXCL too?" before realizing that yes, the caller actually does
> grab that too.  I wonder if it's worth checking here, since you're
> asserting the lock status at all?

This just moves the previous code around..  I can send an incremental
patch if you want, though.
