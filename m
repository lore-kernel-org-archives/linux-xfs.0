Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55259 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750841AbdAXOtj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 09:49:39 -0500
Date: Tue, 24 Jan 2017 15:49:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124144937.GA27261@lst.de>
References: <1485194742-23185-1-git-send-email-hch@lst.de> <20170124140649.GC60234@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124140649.GC60234@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 09:06:49AM -0500, Brian Foster wrote:
> Darrick called out in the previous version that this requires traversal
> of the entire tree at mount time. Do you have any test results on what
> kind of worst case mount delays we could be looking at here?

Even with pretty horribly fragmented file systems I've not seen
major delays.  But I don't have a setup with a lot of actual disks
but mostly SSDs these days, so this might not statistically significant.
