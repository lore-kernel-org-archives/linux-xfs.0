Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50655 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751150AbeFUIha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 04:37:30 -0400
Date: Thu, 21 Jun 2018 10:46:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180621084646.GA5764@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-24-hch@lst.de> <20180619165211.GD2806@bfoster> <20180620075655.GA2668@lst.de> <20180620143252.GE3241@bfoster> <20180620160803.GA4838@magnolia> <20180620181259.GD4493@bfoster> <20180620190230.GB4838@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620190230.GB4838@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 20, 2018 at 12:02:30PM -0700, Darrick J. Wong wrote:
> I managed to cut the testcase down to a nine-line fsx script and so
> turned it into a fstests regression case.  It seems to reproduce 100% on
> scsi disks and doesn't at all on pmem.
> 
> Note that changing the second to last line of the fsxops script to call
> punch_hole instead of zero_range triggers it too.
> 
> I've also narrowed it down to something going wrong w.r.t. handling the
> page cache somewhere under xfs_free_file_space.

So far this doesn't reproduce for me with or without the iomap code.
But I've only run it a few times in a VM on my laptop.
