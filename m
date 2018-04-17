Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53636 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbeDQXfN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Apr 2018 19:35:13 -0400
Date: Tue, 17 Apr 2018 19:34:59 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417233459.GB23194@thunk.org>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
 <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
 <20180417175007.GB5210@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417175007.GB5210@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, Xiong Zhou <xzhou@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 10:50:07AM -0700, Darrick J. Wong wrote:
> syslinux does FIEMAP w/ FIBMAP fallback.
> 
> lilo & elilo still use FIBMAP only, but lilo hasn't seen a release since
> 2015 and elilo 2013.  I prefer not to add FIBMAP support in XFS-DAX for
> the singular case of booting off pmem via lilo.

It shouldn't be that hard to write a userspace emulation layer which
exports a FIBMAP-like functional interface but gets the information
from the kernel using the FIMAP ioctl....

					- Ted
