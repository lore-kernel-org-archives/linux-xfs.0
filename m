Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 467437F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 18:54:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23C878F8035
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 16:54:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qhLKlnQnvVtNNAVd for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 16:54:26 -0700 (PDT)
Date: Fri, 6 Sep 2013 09:54:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: move buf_ops externs to a xfs_format.h
Message-ID: <20130905235412.GN12779@dastard>
References: <1378382015-16026-1-git-send-email-david@fromorbit.com>
	<1378382015-16026-2-git-send-email-david@fromorbit.com>
	<20130905190407.GA603@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130905190407.GA603@infradead.org>
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
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 12:04:07PM -0700, Christoph Hellwig wrote:
> On Thu, Sep 05, 2013 at 09:53:33PM +1000, Dave Chinner wrote:
> > All of the buffer operations structures are needed to be exported
> > for xfs_db, so move them all to a common location rather than
> > spreading them all over the place. They are verifying the on-disk
> > format, so xfs_format.h is as good a place as any.
> > 
> > Don't move the dir2 buffer verifiers - they are already shared in a
> > "central" place for all the dir2 and moving them just requires
> > adding more include files...
> 
> Please only keep the actual format in the _format.h headers and use
> a different shared header for incore bits that can be shared.

Fair enough - I thought about that, but then realised we don't
really have any "global" shared header files that fit this purpose.
The only two really are xfs_fs.h - which is used for ioctl interface
definitions - and xfs_types.h which is used for type definitions,
not structure instances...

So I'm not really sure where we'd put something like this without
creating a new header file, and I don't really want to do that,
either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
