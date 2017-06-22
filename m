Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17851 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdFVHLS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 03:11:18 -0400
Date: Thu, 22 Jun 2017 00:09:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Message-ID: <20170622070958.GG3787@birch.djwong.org>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170620052214.GA3787@birch.djwong.org>
 <20170620154255.GA2536@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620154255.GA2536@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 20, 2017 at 09:42:55AM -0600, Ross Zwisler wrote:
> On Mon, Jun 19, 2017 at 10:22:14PM -0700, Darrick J. Wong wrote:
> <>
> > Fourth, the VFS entry points for things like read, write, truncate,
> > utimes, fallocate, etc. all just bail out if S_IOMAP_FROZEN is set on a
> > file, so that the block map cannot be modified.  mmap is still allowed,
> > as we've discussed.  /Maybe/ we can allow fallocate to extend a file
> > with zeroed extents (it will be slow) as I've heard murmurs about
> > wanting to be able to extend a file, maybe not.
> 
> Read and write should still be allowed, right?

<shrug> I had thought the usage model was pretty slanted towards mmap,
but it's not a big deal to turn read/writes into glorified memcpy,
provided we reject the io request if it goes past EOF.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
