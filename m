Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53209 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfHFFaf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Aug 2019 01:30:35 -0400
Date: Tue, 6 Aug 2019 07:30:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/15] gfs2: use iomap for buffered I/O in ordered and
 writeback mode
Message-ID: <20190806053031.GD13409@lst.de>
References: <20190701215439.19162-1-hch@lst.de> <20190701215439.19162-16-hch@lst.de> <CAHc6FU4wtDwLv_TU6xydtO2h8P8jE1ddPjVqs8=NDFFDNEpiLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4wtDwLv_TU6xydtO2h8P8jE1ddPjVqs8=NDFFDNEpiLA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>

On Mon, Aug 05, 2019 at 02:27:21PM +0200, Andreas Gruenbacher wrote:
> Christoph,
> 
> thanks again for this patch and the rest of the patch queue. There's
> one minor bug here (see below). With that and the gfs2_walk_metadata
> fix I've just posted to cluster-devel, this is now all working nicely.

Skipping through the full quote this was a missing set_page_dirty,
right?  Looks fine to me and sorry for messing this up.
