Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35E477F73
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 17:02:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 15E058F806F
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:02:14 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	awkMkeVlkYNFGCpm for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 15:02:11 -0800 (PST)
Date: Fri, 20 Feb 2015 10:01:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/18] xfs: sparse inode chunks
Message-ID: <20150219230150.GZ12722@dastard>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
	<20150219191034.GA5750@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219191034.GA5750@bfoster.bfoster>
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

On Thu, Feb 19, 2015 at 02:10:34PM -0500, Brian Foster wrote:
> On Thu, Feb 19, 2015 at 01:13:25PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v5 of sparse inode chunks. The only real change here is to
> > convert the allocmask helpers back to using the XFS bitmap helpers
> > rather than the generic bitmap code. This eliminates the need for the
> > endian-conversion hack and extra helper to export a generic bitmap to a
> > native type. The former users of the generic bitmap itself have been
> > converted to use the native 64-bit value appropriately.
> > 
> > The XFS bitmap code is actually not in userspace either so neither of
> > these implementations backport cleanly to userspace. As it is, I've not
> > included the sparse alloc/free code in my xfsprogs branch as this code
> > currently isn't needed. Nothing in userspace that I've seen requires the
> > ability to do a sparse inode allocation or free. I suspect if it is
> > needed in the future, we can more easily sync the XFS bitmap helpers to
> > userspace than the generic Linux bitmap code.
> > 
> > Thoughts, reviews, flames appreciated...
> > 
> 
> Attached is a tarball of a set of xfsprogs patches to aid in testing
> this patchset. I'm posting as a tarball because the core patches (e.g.,
> the kernel patches) are obviously still in flux. The tarball includes
> the following:
> 
> - general dependency backports
> - core infrastructure backports (i.e., applicable patches from this v5
>   sparse inode set)
> - xfsprogs work for sparse inode support

You should probably base it on the libxfs-3.19-update branch rather
than backport random patches into the current branch. This is what
I'm basing the current rmap-btree work I'm doing on, and having the
same libxfs structure on both sides makes it way easier to keep both
sides up to date....

Give me a couple of hours and I'll push out the latest updates to
that the branch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
