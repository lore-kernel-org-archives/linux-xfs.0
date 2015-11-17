Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6197F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 12:43:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 822E58F8035
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 10:43:21 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id 2Kp85vMFm2iqruGd
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Nov 2015 10:43:20 -0800 (PST)
Date: Tue, 17 Nov 2015 13:42:28 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: clone ioctl return values
Message-ID: <20151117184228.GG17545@ret.masoncoding.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

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

Why not -EPERM?  I don't have strong feelings about picking errnos, as
long as we're consistent, I'm not worried.

>  - return EINVAL for wrong non-directory file types as the
>    source fd

Ack.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
