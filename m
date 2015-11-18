Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 345567F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 21:02:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B791DAC005
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 19:02:20 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id npWPCJPgZSGU3s1o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 19:02:15 -0800 (PST)
Date: Tue, 17 Nov 2015 19:01:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: clone ioctl return values
Message-ID: <20151118030117.GA26143@birch.djwong.org>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
	<20151117105433.GA18093@infradead.org>
	<20151117135745.GF17545@ret.masoncoding.com>
	<20151117152251.GA5392@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117152251.GA5392@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>, xfs@oss.sgi.com

On Tue, Nov 17, 2015 at 07:22:52AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 17, 2015 at 08:57:45AM -0500, Chris Mason wrote:
> > > > Errrgh, the golden output of this test reflects the changes to the input
> > > > checking in Anna/Peng's copy_file_range/clone_file_range patches.
> > > > 
> > > > So, I guess the question is, should I reset the golden output to whatever
> > > > btrfs spits out before that patchset, and we'll consider the alterations
> > > > to be bugs/regressions/whatever that ought to be fixed in their patches?
> > > 
> > > Some bits in btrfs don't seem kosher.  But it would be good to
> > > explicitly send patches for btrfs to adopt to what might make more
> > > sense, and then follow it in the other implementations.
> > 
> > Btrfs does check for directories, but we should really be checking for
> > regular files too.  In the end, we only copy extents that would
> > correspond with regular files, so we're sneaking by.
> 
> Yes, I saw that.  So so far I'd suggest something like the following
> for btrfs:
> 
>  - return EBADFD for missing read/wite permissions

Current btrfs returns EINVAL if the file isn't open for writing or is
append-only.  I think EBADF captures the situation here better and
it's what Anna is pushing for copy_file_range.  We can make the
change, but generic/157 will fail on old kernels if we do this.

I don't have a problem with 157 failing on old kernels; we can
backport the change to them, or note that ioctls are murky anyway.

>  - return EINVAL for wrong non-directory file types as the
>    source fd
> And then make the test case and other implementations match this.
> 
> Does this sound like a plan?

Yes.

One other thing I noticed -- prior to Anna's patchset, trying to
invoke the reflink ioctl with a device, pipe, or socket as the
destination could return a variety of error codes (-ENOTTY, -EINVAL,
-ENOIOCTLCMD, etc.) which has all been replaced with -EOPNOTSUPP.
That seems like a reasonable direction to take the test case.

Does this seem like a reasonable addition to the plan?

Should invalid inputs to the dedupe ioctl return the same error codes
as the same invalid inputs to the reflink ioctl?  I've been working on
patches to hoist EXTENT_SAME to the VFS.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
