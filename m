Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BKmZKA111870 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 14:48:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4A621D255E3
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 12:50:46 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	lqBSyMaEFoynOQke for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 12:50:46 -0800 (PST)
Date: Wed, 12 Jan 2011 07:50:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add simple splice test
Message-ID: <20110111205042.GK28803@dastard>
References: <1294702344-15035-1-git-send-email-david@fromorbit.com>
	<20110111173845.GC24025@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110111173845.GC24025@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jan 11, 2011 at 12:38:45PM -0500, Christoph Hellwig wrote:
> > +echo "Feel the serenity."
> > +
> > +SRC=$TEST_DIR/$seq.src
> > +DST=$TEST_DIR/$seq.dst
> > +
> > +$XFS_IO_PROG -f -c "pwrite -S 0xa5a55a5a 0 32768k" -c fsync $SRC > /dev/null 2>&1
> > +$XFS_IO_PROG -f -c "sendfile -i $SRC 0 32768k" -c fsync $DST > /dev/null 2>&1
> > +
> > +diff $SRC $DST
> 
> I think this should removfe the two files to make sure the test is
> reproducible and doesn't overwrite an existing file during the second
> run.

It removes them in the cleanup function.

> Also I'd recomment not to redirect the output to /dev/null but use
> our normal xfs_io filters and make the output part of the golden output.

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
