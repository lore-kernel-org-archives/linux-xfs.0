Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 685817F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:52:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24A26304066
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 15:52:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	lykMh2Zm4qHUnwZD for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 15:52:37 -0800 (PST)
Date: Tue, 5 Jan 2016 10:51:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/76] libxfs: pack the agfl header structure so
	XFS_AGFL_SIZE is correct
Message-ID: <20160104235125.GG19802@dastard>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085655.12713.60317.stgit@birch.djwong.org>
	<20160103121525.GB28429@infradead.org>
	<20160104221218.GB28330@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104221218.GB28330@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 02:12:18PM -0800, Darrick J. Wong wrote:
> On Sun, Jan 03, 2016 at 04:15:25AM -0800, Christoph Hellwig wrote:
> > On Sat, Dec 19, 2015 at 12:56:55AM -0800, Darrick J. Wong wrote:
> > > Because struct xfs_agfl is 36 bytes long and has a 64-bit integer
> > > inside it, gcc will quietly round the structure size up to the nearest
> > > 64 bits -- in this case, 40 bytes.  This results in the XFS_AGFL_SIZE
> > > macro returning incorrect results for v5 filesystems on 64-bit
> > > machines (118 items instead of 119).  As a result, a 32-bit xfs_repair
> > > will see garbage in AGFL item 119 and complain.
> > > 
> > > Therefore, tell gcc not to pad the structure so that the AGFL size
> > > calculation is correct.
> > 
> > Do you have a testcase for this?
> 
> Not much aside from:
> 
> 0. Build kernel/xfsprogs with RFCv4 patches on a 64bit machine.
> 1. Build kernel/xfsprogs with RFCv4 patches on a 32bit machine.
> 2. Format a XFS with reflink and rmap on a 64-bit machine, so that the AGFL
>    size is maximized.
> 3. Mount FS and create a reflinked file.
> 4. Unmount and xfs_repair with the 32-bit build.
> 
> I guess we could create a program that compares all the known sizeof(struct
> xfs_disk_object) values against known good values and stuff that into the
> xfsprogs build process.

There's an xfstest for that: xfs/122. It notruns on my systems since
the big xfsprogs build/header rework, and I haven't found the time
to work out what it needs to run again. Also, I don't think it
covers the AGFL structure, because that it relatively new and the
test doesn't check any of the v5 specific structures....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
