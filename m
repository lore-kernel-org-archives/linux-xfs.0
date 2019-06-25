Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33341 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfFYKB2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 06:01:28 -0400
Date: Tue, 25 Jun 2019 12:00:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
Message-ID: <20190625100057.GD1462@lst.de>
References: <20190624134315.21307-1-hch@lst.de> <20190624134315.21307-3-hch@lst.de> <20190624162215.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624162215.GS5387@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Mon, Jun 24, 2019 at 09:22:15AM -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
> > Link every newly allocated writeback bio to cgroup pointed to by the
> > writeback control structure, and charge every byte written back to it.
> > 
> > Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
> 
> Was this tested by running shared/011?  Or did it involve other checks?

I verified it with shared/011 and local frobbing.  Stefan can chime
in on what testing he did.
