Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45257 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753420AbdH2QOR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 12:14:17 -0400
Date: Tue, 29 Aug 2017 18:14:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: consolidate the various page fault handlers
Message-ID: <20170829161416.GA2145@lst.de>
References: <20170828063659.21045-1-hch@lst.de> <20170828063659.21045-3-hch@lst.de> <20170828170340.GC4757@magnolia> <20170829003452.GL4757@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829003452.GL4757@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, jack@suse.cz

On Mon, Aug 28, 2017 at 05:34:52PM -0700, Darrick J. Wong wrote:
> This patch causes generic/413 to get stuck somehow on my qemu vms that
> have fake pmem.  Not sure what's going on since previously it spat out:

that jst shows that pfn_mkwrite should not have been included in
the consolidation because that part was simply incorrect.  But it
seems like the pfn case doesn't show up with real nvdimms as long
as page backing is enabled.

I'll resend without the pfn changes.
