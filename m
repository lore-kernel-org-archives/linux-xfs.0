Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53385 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755268AbcIOFOW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Sep 2016 01:14:22 -0400
Date: Thu, 15 Sep 2016 07:14:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/12] xfs: use iomap to implement DAX
Message-ID: <20160915051420.GF6188@lst.de>
References: <1473847291-18913-1-git-send-email-hch@lst.de> <1473847291-18913-11-git-send-email-hch@lst.de> <20160914173247.GC30852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160914173247.GC30852@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

On Wed, Sep 14, 2016 at 11:32:47AM -0600, Ross Zwisler wrote:
> I think this should be xfs_setfilesize(ip, pos, ret)?  'count' and 'ret' are
> the same in non-error cases, but in error cases where iomap_dax_rw() does some
> work and then encounters an error, 'ret' could be smaller.  In error cases
> like this using 'ret' instead of 'count' will also keep the value we use in
> i_size_write() equal to what we write via xfs_setfilesize() because
> iocb->ki_pos == pos+ret, not pos+count.

True.  Now with DAX where we can actuall get short writes that
should be fixed.  I spent too much time with the direct I/O code where
this would not happen.
