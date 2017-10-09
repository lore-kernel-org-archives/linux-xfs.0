Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45394 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750930AbdJIH2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 03:28:22 -0400
Date: Mon, 9 Oct 2017 09:28:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: add a new test for racing AIO COW writes V2
Message-ID: <20171009072820.GA30228@lst.de>
References: <20171003143802.GA3964@lst.de> <20171004061616.GA20222@lst.de> <20171009071833.GE10593@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009071833.GE10593@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 03:18:33PM +0800, Eryu Guan wrote:
> On Wed, Oct 04, 2017 at 08:16:16AM +0200, Christoph Hellwig wrote:
> > This can be used to trigger an assert in the current XFS code because it
> > can't handle the case where there are COW extents on a file, but none
> > at or below the range converted by the AIO completion handler.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I fixed several minor issues on commit (see inline comments).
> 
> I haven't reproduced the assert failure yet on my test vm, but as the
> commit log in v1 patch, it's not 100% reproducible, maybe I'm just lucky
> (or not lucky :)

Hmm, I only got 1 non-reproduce out of about 100 runs.  Maybe your
device is too fast, as this was in a VM.
