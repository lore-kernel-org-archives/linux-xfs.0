Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24F107F37
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 17:09:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15BD78F8050
	for <xfs@oss.sgi.com>; Wed,  6 May 2015 15:09:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6R4lrULLEhl1ufU1 for <xfs@oss.sgi.com>;
	Wed, 06 May 2015 15:09:43 -0700 (PDT)
Date: Thu, 7 May 2015 08:09:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 00/18] xfs: sparse inode chunks
Message-ID: <20150506220941.GG4327@dastard>
References: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
	<20150506141953.GA21159@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150506141953.GA21159@bfoster.bfoster>
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

On Wed, May 06, 2015 at 10:19:55AM -0400, Brian Foster wrote:
> On Mon, Mar 02, 2015 at 08:27:50AM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's a v6 of sparse inode chunks. This fixes a bug on large block size
> > filesystems where an inode chunk was being incorrectly freed. The
> > problem was that patch 2 changed the previously implicit behavior of
> > never freeing an inode chunk on filesystems where the block size is
> > large enough for multiple chunks (e.g., bsize=64k, isize<=512). Patch 2
> > has been fixed to preserve original behavior.
> > 
> > There have also been some minor fixups throughout associated with a
> > rebase to the latest for-next. This includes killing some old sb logging
> > bits and passing mp to XFS_WANT_CORRUPTED_GOTO().
> > 
> > Brian
> > 
> 
> Attached is an xfsprogs tarball corresponding to this release. This
> version is based on the libxfs-3.19-update xfsprogs branch. It includes
> a few dependency backports on top of that branch, relevant backports
> from the kernel series and various bits of userspace support.
> xfs_metadump support has been added since the previous drop. mkfs
> instructions remain the same as before, described here:
> 
> 	http://oss.sgi.com/archives/xfs/2015-02/msg00386.html

Ok, I'm just rebasing the libxfs-3.19-update branch right now so
I can update it to 4.1-rc1, so we'll see how applying this goes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
