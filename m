Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44201 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdKFIrW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Nov 2017 03:47:22 -0500
Date: Mon, 6 Nov 2017 09:47:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/21] xfs: simplify xfs_reflink_convert_cow
Message-ID: <20171106084720.GA29915@lst.de>
References: <20171103144539.2187-1-hch@lst.de> <20171103144539.2187-15-hch@lst.de> <20171103165507.GO4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103165507.GO4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

> >  	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
> > -	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }
> > +	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
> > +	{ XFS_BMAPI_CONVERT_ONLY, "XFS_BMAPI_CONVERT_ONLY" }
> 
> "CONVERT_ONLY" to be consistent with the other flag strings?
> I can fix this on the way in.

Please do.  If I have to respin it either I'll also fix it up.
