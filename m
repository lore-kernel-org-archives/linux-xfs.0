Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2DD37CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 02:10:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 67D728F8033
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 00:10:10 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id LSjjIjUspQRz5sDG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 00:10:06 -0700 (PDT)
Date: Wed, 8 Jun 2016 09:10:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160608071003.GA24663@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard>
	<20160603015832.GA5758@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160603015832.GA5758@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jun 02, 2016 at 06:58:33PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> > On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > > I've had some vocal user requests to allow enabling reflinks at run time,
> > > which happens to be a mostly trivial feature.  The only caveat is that we
> > > need a large enough log size to support the reflink requirements, but for
> > > typical large file systems that's not an issue.
> > 
> > Hmmm - how does this interact with all the rmap code? I was not
> > planning on enabling reflink without rmap and vice versa simply
> > because it makes the validation and testing matrix vastly more
> > complex. Indeed, having reflink turned on after a filesystem has
> > aged for some time (i.e. from unknown initial conditions) makes
> > validation especially tricky....
> 
> Well...
> 
> It's not strictly impossible, but there will be some problems running
> repair and remounting.
> 
> The patchset doesn't actually check that we satisfy the minimum log
> space requirement, which will result in xfs refusing to mount.  As
> Christoph says, this is only an issue on small FSes, but nevertheless,
> we shouldn't trap the user like that.

xfs_log_mount always verified the required log size.

> Second, mkfs lays out all the AG btree roots at the start of the AG
> before finding an aligned inode block for the root inode.  xfs_repair
> feeds the same algorithm from the on-disk feature fields to check that
> s_rootino is sane, and gets very unhappy if it doesn't find the root
> inode at the computed location.  Adding the two btree root blocks is
> enough to shift the root inode from 96 to 128.  This all can be fixed,
> but it /was/ convenient not to have to support weirdo upgraded XFSes
> like ext4. :)

Yes, that algorithm might be unhappy, but I don't think it's overly
smart to rely on it either.

> Furthermore, if you turn on reflink, you should enable the per-AG
> reservations so we don't crash the FS by running out of space when it
> needs a block for the refcountbt.

xfs_refcountbt_calc_reserves is switched to use xfs_mp_hasreflink,
so it will do the right thing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
