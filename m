Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6824E7F4E
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 19:34:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03D59AC002
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 17:34:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	e12PJIDKkoFZYy3W for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 17:33:58 -0700 (PDT)
Date: Tue, 16 Jun 2015 10:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/28] xfsprogs: sparse inode chunks
Message-ID: <20150616003344.GG20262@dastard>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 02, 2015 at 02:41:33PM -0400, Brian Foster wrote:
> Hi all,
> 
> Now that the sparse inode chunks feature is merged into the kernel tree
> for 4.2, here is the first official drop of userspace support. This
> series is based on the current libxfs-4.1-update branch.
> 
> Patches 1-10 are libxfs infrastructure and correspond to the similarly
> named kernel patches. The bits not relevant to userspace are dropped
> along with the bulk of the sparse inode chunk allocation logic from the
> kernel due to the combination of non-existent dependencies in userspace
> (e.g., xfs_bit.c) and the fact that this code isn't invoked from
> userspace.

Ok, so this is causing problems with merging other code into
userspace. What I'm trying to do is keepthe kernel fs/xfs/libxfs/
code as close to identical with the xfsprogs libxfs/ code so that
patches just port straight across. I came across this difference
because my rmap btree patches fail to apply cleanly to xfs_ialloc.c
and it's because of all this missing code in userspace.

Rather than wait another day or two for you to rework this, Brian,
I'm simply going to rework this series to pull all the kernel patches
across and make it compile in userspace so that I can pull all the
rmap btree stuff across without needing to rework bits and peices of
the patchset.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
