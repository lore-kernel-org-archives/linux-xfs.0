Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14BOexe206533 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 05:24:40 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id LSVEq4GLJDerCvpo for
	<xfs@oss.sgi.com>; Sat, 04 Feb 2012 03:24:39 -0800 (PST)
Date: Sat, 4 Feb 2012 11:24:36 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120204112436.GA3167@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120203115434.GA649@nsrc.org> <4F2C38BE.2010002@hardwarefreak.com>
	<20120203221015.GA2675@nsrc.org> <4F2D016C.9020406@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2D016C.9020406@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Feb 04, 2012 at 03:59:08AM -0600, Stan Hoeppner wrote:
> Will you be using mdraid or hardware RAID across those 24 spindles?

Gluster is the front-runner at the moment. Each file sits on a single
spindle, and there is a separate filesystem per spindle, so I think the
parallel processing will work much better this way. This does mean double
the disks to get data replication though.

I did some testing of RAID6 mdraid (12 disks with with 1MB stripe size) and
it sucked.  However I need to re-test it now that I know about inode64.
We do have a requirement for archival storage and that might use RAID6.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
