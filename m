Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51895 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbdCAPHn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:07:43 -0500
Date: Wed, 1 Mar 2017 16:07:09 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] failure atomic writes for file systems and block devices
Message-ID: <20170301150709.GD12248@lst.de>
References: <20170228145737.19016-1-hch@lst.de> <e4bc2911-99ee-0049-a11d-3944c1770cff@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4bc2911-99ee-0049-a11d-3944c1770cff@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Feb 28, 2017 at 03:48:16PM -0500, Chris Mason wrote:
> One thing that isn't clear to me is how we're dealing with boundary bio 
> mappings, which will get submitted by submit_page_section()
>
> sdio->boundary = buffer_boundary(map_bh);

The old dio code is not supported at all by this code at the moment.
We'll either need the new block dev direct I/O code on block
devices (and limit to BIO_MAX_PAGES, this is a bug in this patchset
if people ever have devices with > 1MB atomic write support.  And thanks
to NVMe the failure case is silent, sigh..), or we need file system support
for out of place writes.

>
> In btrfs I'd just chain things together and do the extent pointer swap 
> afterwards, but I didn't follow the XFS code well enough to see how its 
> handled there.  But either way it feels like an error prone surprise 
> waiting for later, and one gap we really want to get right in the FS 
> support is O_ATOMIC across a fragmented extent.
>
> If I'm reading the XFS patches right, the code always cows for atomic.

It doesn't really COW - it uses the COW infrastructure to write out of
place and then commit it into the file later.  Because of that we don't
really care about things like boundary blocks (which XFS never used in
that form anyway) - data is written first, the cache is flushed and then
we swap around the extent pointers.

> Are 
> you planning on adding an optimization to use atomic support in the device 
> to skip COW when possible?

We could do that fairly easily for files that have a contiguous mapping
for the atomic write I/O.  But at this point I have a lot more trust in
the fs code than the devices, especially due to the silent failure mode.
