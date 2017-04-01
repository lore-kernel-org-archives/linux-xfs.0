Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39964 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdDARW7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Apr 2017 13:22:59 -0400
Date: Sat, 1 Apr 2017 19:22:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/26] xfs: reject all unaligned direct writes to
        reflinked files
Message-ID: <20170401172257.GA13973@lst.de>
References: <20170401063512.25313-1-hch@lst.de> <20170401063512.25313-13-hch@lst.de> <20170401172108.GA10203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170401172108.GA10203@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>

On Sat, Apr 01, 2017 at 07:21:08PM +0200, Greg KH wrote:
> Any specific reason you don't want this one in 4.9 as well?

It won't quite apply as-is due to major changes in the direct I/O
code.  it would be good to have, but need a slightly different approach.
I'll see if I'll have something ready for the next round of stable
updates.
