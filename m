Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49760 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbeJCVnE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 17:43:04 -0400
Date: Wed, 3 Oct 2018 16:54:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/8] xfs: remove suport for filesystems without
 unwritten extent flag
Message-ID: <20181003145419.GA5248@lst.de>
References: <20181002174207.25275-1-hch@lst.de> <20181002174207.25275-3-hch@lst.de> <20181003145205.GE19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003145205.GE19324@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 07:52:05AM -0700, Darrick J. Wong wrote:
> Will there be a migration tool in xfsprogs to help administrators roll
> their filesystems forward?  Generally we don't seem to support enabling
> new features on old filesystems (ala ext4) though maybe we should for a
> very small and controlled set of porting operations?

I wasn't planning to unless needed, mostly because I don't really think
we'll see such file systems in the wild.  They'd be very broken if
you are using the current code on them already.
