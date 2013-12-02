Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5B92729DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 16:49:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6234AC00A
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:49:25 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	s7G7VYQ2YSUWCJbD for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 14:49:23 -0800 (PST)
Date: Tue, 3 Dec 2013 09:49:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/15] xfsprogs: use common code for multi-disk detection
Message-ID: <20131202224919.GY10988@dastard>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-2-git-send-email-david@fromorbit.com>
	<20131202104016.GA21394@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131202104016.GA21394@infradead.org>
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

On Mon, Dec 02, 2013 at 02:40:16AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:36PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Both xfs_repair and mkfs.xfs need to agree on what is a "multidisk:
> > configuration - mkfs for determining the AG count of the filesystem,
> > repair for determining how to automatically parallelise it's
> > execution. This requires a bunch of common defines that both mkfs
> > and reapir need to share.
> > 
> > In fact, most of the defines in xfs_mkfs.h could be shared with
> > other programs (i.e. all the defaults mkfs uses) and so it is
> > simplest to move xfs_mkfs.h to the shared include directory and add
> > the new defines to it directly.
> 
> I have to say I do not like making the mkfs header public at all.
> There's things like local prototypes in there that shouldn't be in
> include/, and the name is wrong, too.  include/xfs_geom.h maybe?

Yeah, I know it's a bit messy - I thought that as the series went on
all those prototypes would go away, but only some of them have. I
like the idea of xfs_geom.h, though, because that encapsulates what
we are trying to shared here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
