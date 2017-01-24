Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58120 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdAXUKJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 15:10:09 -0500
Date: Tue, 24 Jan 2017 21:10:03 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: go straight to real allocations for direct
        I/O COW writes
Message-ID: <20170124201003.GA1491@lst.de>
References: <20161207194634.GE23106@bfoster.bfoster> <20170124083732.GA17818@lst.de> <20170124135044.GA60234@bfoster.bfoster> <20170124135937.GA25885@lst.de> <20170124150222.GD60234@bfoster.bfoster> <20170124150959.GA27705@lst.de> <20170124161719.GE60234@bfoster.bfoster> <20170124162156.GA29361@lst.de> <20170124174318.GH60234@bfoster.bfoster> <20170124200855.GA1385@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124200855.GA1385@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Jan 24, 2017 at 09:08:55PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 12:43:18PM -0500, Brian Foster wrote:
> > Hmm, that's not what I'm seeing (not that it really matters, but I'm
> > curious if I'm missing something):
> 
> Yeah, I can reproduce this on mainline.  Turns out the it was done

s/can/can't/, sorry.  It's getting late for the day.
