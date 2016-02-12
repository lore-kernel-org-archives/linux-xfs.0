Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 39C4E7CA5
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 09:22:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28B07304059
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 07:22:39 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id J81KswwP75XzckGl (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 07:22:36 -0800 (PST)
Date: Fri, 12 Feb 2016 10:22:31 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212152231.GA7928@thunk.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
	<20160211234037.2202.93885.stgit@birch.djwong.org>
	<20160212035253.GX14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160212035253.GX14668@dastard>
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
Cc: xfs@oss.sgi.com, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Feb 12, 2016 at 02:52:53PM +1100, Dave Chinner wrote:
> On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> > Check that we don't expose old disk contents when a directio write to
> > an unwritten extent fails due to IO errors.  This primarily affects
> > XFS and ext4.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> aiocp.c: In function 'main':
> aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
>  printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
>  ^
> 
> Followup patch is fine, I'll commit as is.

Dave, given that Darrick's patches is going to cause more
_scratch_mount occurences, how quickly do you plan to commit his
patchset?  Should I wait until he makes his change before I do the
s/_scratch_mount/_scratch_cycle_mount/ change?  Should I make that
change, and let you fix it up the commit?

Thanks,

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
