Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 293F87CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 20:58:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCB888F80C4
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 18:58:48 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id f5jTz73qC4CiOCm5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 18:58:46 -0700 (PDT)
Date: Thu, 2 Jun 2016 18:58:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160603015832.GA5758@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160602225415.GP12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > I've had some vocal user requests to allow enabling reflinks at run time,
> > which happens to be a mostly trivial feature.  The only caveat is that we
> > need a large enough log size to support the reflink requirements, but for
> > typical large file systems that's not an issue.
> 
> Hmmm - how does this interact with all the rmap code? I was not
> planning on enabling reflink without rmap and vice versa simply
> because it makes the validation and testing matrix vastly more
> complex. Indeed, having reflink turned on after a filesystem has
> aged for some time (i.e. from unknown initial conditions) makes
> validation especially tricky....

Well...

It's not strictly impossible, but there will be some problems running
repair and remounting.

The patchset doesn't actually check that we satisfy the minimum log
space requirement, which will result in xfs refusing to mount.  As
Christoph says, this is only an issue on small FSes, but nevertheless,
we shouldn't trap the user like that.

Second, mkfs lays out all the AG btree roots at the start of the AG
before finding an aligned inode block for the root inode.  xfs_repair
feeds the same algorithm from the on-disk feature fields to check that
s_rootino is sane, and gets very unhappy if it doesn't find the root
inode at the computed location.  Adding the two btree root blocks is
enough to shift the root inode from 96 to 128.  This all can be fixed,
but it /was/ convenient not to have to support weirdo upgraded XFSes
like ext4. :)

Furthermore, if you turn on reflink, you should enable the per-AG
reservations so we don't crash the FS by running out of space when it
needs a block for the refcountbt.

--D

> 
> Darrick?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
