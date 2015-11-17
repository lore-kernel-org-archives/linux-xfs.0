Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD6E77F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:23:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F58E304032
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:22:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id weXGLmBBNcU5YsPz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 07:22:54 -0800 (PST)
Date: Tue, 17 Nov 2015 07:22:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: clone ioctl return values
Message-ID: <20151117152251.GA5392@infradead.org>
References: <20151116120431.GA2860@infradead.org>
	<20151117002822.GA32467@birch.djwong.org>
	<20151117105433.GA18093@infradead.org>
	<20151117135745.GF17545@ret.masoncoding.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117135745.GF17545@ret.masoncoding.com>
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
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Nov 17, 2015 at 08:57:45AM -0500, Chris Mason wrote:
> > > Errrgh, the golden output of this test reflects the changes to the input
> > > checking in Anna/Peng's copy_file_range/clone_file_range patches.
> > > 
> > > So, I guess the question is, should I reset the golden output to whatever
> > > btrfs spits out before that patchset, and we'll consider the alterations
> > > to be bugs/regressions/whatever that ought to be fixed in their patches?
> > 
> > Some bits in btrfs don't seem kosher.  But it would be good to
> > explicitly send patches for btrfs to adopt to what might make more
> > sense, and then follow it in the other implementations.
> 
> Btrfs does check for directories, but we should really be checking for
> regular files too.  In the end, we only copy extents that would
> correspond with regular files, so we're sneaking by.

Yes, I saw that.  So so far I'd suggest something like the following
for btrfs:

 - return EBADFD for missing read/wite permissions
 - return EINVAL for wrong non-directory file types as the
   source fd

And then make the test case and other implementations match this.

Does this sound like a plan?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
