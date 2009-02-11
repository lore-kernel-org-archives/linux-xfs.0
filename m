Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1B9QYll120792 for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 03:26:35 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A2F351917722
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2009 01:25:56 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	pR3gl1zVhb7Kbmea for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2009 01:25:56 -0800 (PST)
Date: Wed, 11 Feb 2009 20:20:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Don't reset di_format in xfs_ifree()
Message-ID: <20090211092020.GR8830@disturbed>
References: <49921B3E.8040406@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49921B3E.8040406@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 11, 2009 at 11:26:38AM +1100, Lachlan McIlroy wrote:
> I hit a panic while flushing a reclaimed inode that is fairly
> reproducible under load.
>
> In xfs_iflush_fork() we're led to believe that there are extents
> on this inode but there aren't any.  Actually the inode was a
> directory.  I added some debugging to xfs_ifree() and found
> that di_format was XFS_DINODE_FMT_LOCAL and got reset to
> XFS_DINODE_FMT_EXTENTS and this has confused the code in
> xfs_iflush_fork().

Wow. I wonder why we've never seen this before - it's not a new
problem AFAICT.

A freed inode is supposed to have both forks in extent format
with zero extents - it means the fork is empty. Changing it
to local format means that it is not in the expected state
for a subsequent create.

I think the problem may be that the size of the fork has not been
reset to zero, not that format has been changed. If it was in local
format, the truncates prior to freeing would not have done anything
and the size of the data/attr fork would still be non-zero.  Hence
if the fork is then changed to extent format, xfs_iextents_copy()
will be triggered from xfs_iflush_fork() and you'd see something
like the confusion you are seeing.

Hence I think we should be ensuring the fork size is set to zero for
both the attr/data fork when the format is changed, not removing
the change of type....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
