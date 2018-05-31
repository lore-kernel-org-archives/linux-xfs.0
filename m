Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36639 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753882AbeEaG4m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 02:56:42 -0400
Date: Thu, 31 May 2018 09:03:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/18] xfs: don't look at buffer heads in
        xfs_add_to_ioend
Message-ID: <20180531070307.GA32051@lst.de>
References: <20180530100013.31358-1-hch@lst.de> <20180530100013.31358-14-hch@lst.de> <20180530175529.GQ837@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530175529.GQ837@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 10:55:29AM -0700, Darrick J. Wong wrote:
> > +	sector = xfs_fsb_to_db(ip, wpc->imap.br_startblock) +
> > +		((offset - XFS_FSB_TO_B(mp, wpc->imap.br_startoff)) >> 9);
> 
> " >> SECTOR_SHIFT" here?  If so, I can fix this on its way in.

The >> 9 that until very recently was used everywhere makes it nicely
fit on two lines.  But the fixup is ok with me, too.
