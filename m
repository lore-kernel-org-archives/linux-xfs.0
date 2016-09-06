Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D544F7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 11:27:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37377AC001
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 09:27:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8ItrMkDF4jqBiRMG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 09:27:28 -0700 (PDT)
Date: Tue, 6 Sep 2016 09:26:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 67/71] xfs: fail ->bmap for reflink inodes
Message-ID: <20160906162651.GB16696@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
	<147216835350.867.14512964799631563964.stgit@birch.djwong.org>
	<20160906152948.GB9760@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160906152948.GB9760@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 06, 2016 at 08:29:48AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:39:13PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Have xfs_vm_bmap return zero for reflinked files.  This hack prevents
> > using a file with shared blocks as a swap file, because we don't want
> > to deal with CoW when we're (probably) low on memory.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > [darrick.wong@oracle.com: add a more descriptive changelog]
> 
> Which happens to be incorrect :)  The swap code uses ->bmap to build
> a logical to physical block map at swapon time (to avoid allocations
> or even just block mappings under memory pressure I suspect).  This
> means we'd get reliable data corruption when COWing a swap file.

Yeah, at the time I thought I was going to write out a clever resolution to the
conflict between swap and CoW by using swap_activate to punch and fallocate all
the shared extents and turn off the inode reflink flag which would then enable
me to drop this patch altogether, but then got busy and forgot all about it.
Clearly I didn't fix the changelog here either. :(

"Have xfs_vm_bmap return zero for reflinked files because the bmap-based
swap code requires static block mappings, which is incompatible with
copy on write."

> 
> > +	 * The swap code (ab-)uses ->bmap to get a block mapping and then
> > +	 * bypasse?? the file system for actual I/O.  We really can't allow
> 
> Also it seems like I introduced some weird character instead of an
> "s" here..

Will fix that while I'm at it.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
