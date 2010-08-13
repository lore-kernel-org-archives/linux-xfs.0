Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DNFv8a104326
	for <linux-xfs@oss.sgi.com>; Fri, 13 Aug 2010 18:15:57 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DABF41B2DDF6
	for <linux-xfs@oss.sgi.com>; Fri, 13 Aug 2010 16:16:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	Tdy75fkwlCQjBMkG for <linux-xfs@oss.sgi.com>;
	Fri, 13 Aug 2010 16:16:22 -0700 (PDT)
Date: Sat, 14 Aug 2010 09:16:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: simpler _xfs_dic2xflags() ?
Message-ID: <20100813231619.GG10429@dastard>
References: <1281738591.5897.17.camel@segv.aura.of.mankind>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1281738591.5897.17.camel@segv.aura.of.mankind>
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
To: utz lehmann <xfs2@s2y4n2c.de>
Cc: linux-xfs <linux-xfs@oss.sgi.com>

On Sat, Aug 14, 2010 at 12:29:51AM +0200, utz lehmann wrote:
> Hello
> 
> I just found following function in xfs_inode.c:
> 
> STATIC uint
> _xfs_dic2xflags(
> 	__uint16_t		di_flags)
> {
> 	uint			flags = 0;
> 
> 	if (di_flags & XFS_DIFLAG_ANY) {
> 		if (di_flags & XFS_DIFLAG_REALTIME)
> 			flags |= XFS_XFLAG_REALTIME;
> 		if (di_flags & XFS_DIFLAG_PREALLOC)
> 			flags |= XFS_XFLAG_PREALLOC;
> 		if (di_flags & XFS_DIFLAG_IMMUTABLE)
> 			flags |= XFS_XFLAG_IMMUTABLE;
> 		if (di_flags & XFS_DIFLAG_APPEND)
> 			flags |= XFS_XFLAG_APPEND;
> 		if (di_flags & XFS_DIFLAG_SYNC)
> 			flags |= XFS_XFLAG_SYNC;
> 		if (di_flags & XFS_DIFLAG_NOATIME)
> 			flags |= XFS_XFLAG_NOATIME;
> 		if (di_flags & XFS_DIFLAG_NODUMP)
> 			flags |= XFS_XFLAG_NODUMP;
> 		if (di_flags & XFS_DIFLAG_RTINHERIT)
> 			flags |= XFS_XFLAG_RTINHERIT;
> 		if (di_flags & XFS_DIFLAG_PROJINHERIT)
> 			flags |= XFS_XFLAG_PROJINHERIT;
> 		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
> 			flags |= XFS_XFLAG_NOSYMLINKS;
> 		if (di_flags & XFS_DIFLAG_EXTSIZE)
> 			flags |= XFS_XFLAG_EXTSIZE;
> 		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
> 			flags |= XFS_XFLAG_EXTSZINHERIT;
> 		if (di_flags & XFS_DIFLAG_NODEFRAG)
> 			flags |= XFS_XFLAG_NODEFRAG;
> 		if (di_flags & XFS_DIFLAG_FILESTREAM)
> 			flags |= XFS_XFLAG_FILESTREAM;
> 	}
> 
> 	return flags;
> }
> 
> Can't the whole function be replaced by something like this?
> 
> flags = di_flags & MASK;
> 
> The corresponding XFS_DIFLAGS and XFS_XFLAGS have the same values.

Sure they have the same value right now, but remember that
XFS_XFLAG_* values are part of userspace ABI and the XFS_DIFLAG_*
define to the on-disk format values.

We keep a logical separation of the two as there is no guarantee
they will remain the same over time. Indeed, there are XFS_XFLAGS_*
values that have no equivalent XFS_DIFLAG_ value. Further, we are
out of space for new flags in the inode flags field and hence any
new on-disk flags will be in a different format to the current on
disk values and hence we'd break any masking based optimisation if
we change them...

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
