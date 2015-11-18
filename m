Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1693C7F37
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 09:11:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9F23304032
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 07:11:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OAnVIemO7r1iFLbU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2015 07:11:46 -0800 (PST)
Date: Wed, 18 Nov 2015 07:11:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clone ioctl return values
Message-ID: <20151118151145.GA5365@infradead.org>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
	<20151117105433.GA18093@infradead.org>
	<20151117135745.GF17545@ret.masoncoding.com>
	<20151117152251.GA5392@infradead.org>
	<20151118030117.GA26143@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151118030117.GA26143@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <clm@fb.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 17, 2015 at 07:01:17PM -0800, Darrick J. Wong wrote:
> Current btrfs returns EINVAL if the file isn't open for writing or is
> append-only.  I think EBADF captures the situation here better and
> it's what Anna is pushing for copy_file_range.  We can make the
> change, but generic/157 will fail on old kernels if we do this.

As the old errno was rather wrong compared to similar syscalls I'd
say don't worry about this.

> One other thing I noticed -- prior to Anna's patchset, trying to
> invoke the reflink ioctl with a device, pipe, or socket as the
> destination could return a variety of error codes (-ENOTTY, -EINVAL,
> -ENOIOCTLCMD, etc.) which has all been replaced with -EOPNOTSUPP.
> That seems like a reasonable direction to take the test case.
> 
> Does this seem like a reasonable addition to the plan?

-ENOIOCTLCMD should never reach userspace, this is a clear bug.
-EINVAL also seems wrong, but ENOTTY is perfectly valid for an
ioctl based implementation.  So I'd say we should allow
ENOTTY or -EOPNOTSUPP in the test case by using filters, and ensure
btrfs and nfs only return those in 4.4 and maybe with backports to
stable.

> Should invalid inputs to the dedupe ioctl return the same error codes
> as the same invalid inputs to the reflink ioctl?  I've been working on
> patches to hoist EXTENT_SAME to the VFS.

I think so.  EXTENT_SAME is so similar to clone that it should almost be
a flag for it in the low level API.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
