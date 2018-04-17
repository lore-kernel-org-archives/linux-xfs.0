Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbeDQRu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 13:50:57 -0400
Date: Tue, 17 Apr 2018 10:50:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ioctl FIBMAP for dax gone in v4.17-rc1
Message-ID: <20180417175007.GB5210@magnolia>
References: <20180417144059.nwbbynhgq3k3i63q@XZHOUW.usersys.redhat.com>
 <20180417161056.GA24257@infradead.org>
 <CAPcyv4i05nP=wmOMwKFbdwqBrYXpcPBCmR4g2b4w8vOZaCBEnQ@mail.gmail.com>
 <20180417165756.GC24738@magnolia>
 <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BE1492A6-DF52-428C-A3CE-E91F0ACC0ADA@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, Xiong Zhou <xzhou@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 11:40:00AM -0600, Andreas Dilger wrote:
> On Apr 17, 2018, at 10:57 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Tue, Apr 17, 2018 at 09:53:47AM -0700, Dan Williams wrote:
> >> On Tue, Apr 17, 2018 at 9:10 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >>> On Tue, Apr 17, 2018 at 10:40:59PM +0800, Xiong Zhou wrote:
> >>>> We got these in v4.17-rc1:
> >>>> 6e2608d xfs, dax: introduce xfs_dax_aops
> >>>> fb094c9 ext2, dax: introduce ext2_dax_aops
> >>>> 5f0663b ext4, dax: introduce ext4_dax_aops
> >>>> 
> >>>> And we don't have ->bmap call in these aops, which may lead
> >>>> to the ioctl call failure.
> >>>> 
> >>>> Do we have any plan of adding/supporting it ?
> >>>> 
> >>>> xfstests generic/223 covers this issue. If we are not going
> >>>> to support this call for dax, we need to fix the testcase.
> >>> 
> >>> Not supporting ->bmap is a good thing as it is hightly dangerous.
> >> 
> >> I take this to mean "don't fix, it is another casualty of dax being
> >> experimental and it won't be coming back". I can get on board with
> >> that.
> >> 
> >> Otherwise, I was about to send a series adding bmap to {xfs,ext2,ext4}_dax_ops.
> > 
> > Frankly I'd rather see the swapfile code learn how to iomap and then we
> > can get rid of bmap in xfs entirely.
> 
> Is anyone still using LILO to boot?  It needed FIBMAP support to map the
> kernel image for booting.  I don't know if Grub needs FIBMAP support for
> the early boot stages or not (it has minimal filesystem support in the
> later stages), but it would be a shame if it wasn't possible to boot an
> all-NVRAM system as a result of a missing ->bmap() method.  Alternately,
> convince the Grub folks to use FIEMAP if that is available...

grub2 usually uses its own fs drivers (for better or for worse) to read
the fs.  The blockchaining mode tries FIEMAP and falls back to FIBMAP if
not available.

syslinux does FIEMAP w/ FIBMAP fallback.

lilo & elilo still use FIBMAP only, but lilo hasn't seen a release since
2015 and elilo 2013.  I prefer not to add FIBMAP support in XFS-DAX for
the singular case of booting off pmem via lilo.

(Sorry Dave...)

--D

> 
> Cheers, Andreas
> 
> 
> 
> 
> 


