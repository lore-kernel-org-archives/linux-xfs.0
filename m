Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E87777F37
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 19:12:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8647BAC001
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 17:12:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AucoxMLpf0pl27ei for <xfs@oss.sgi.com>;
	Sun, 31 May 2015 17:12:33 -0700 (PDT)
Date: Mon, 1 Jun 2015 10:12:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/18] xfs: sparse inode chunks
Message-ID: <20150601001230.GG24666@dastard>
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
> 
> The latter bits include support for mkfs, xfs_info, xfs_db and
> xfs_repair, the fundamentals of all of which should work. Use the '-i
> spalign' mkfs option to format a sparse inode enabled fs. E.g.:
> 
> 	mkfs.xfs -m crc=1,finobt=1 -i spalign <dev>
> 
> Note that metadump is not yet supported. Failures from the associated
> xfstests, etc. are expected. I'm not aware of anything else that is
> missing support or otherwise broken, so any feedback along those lines
> is appreciated.

Notes:

- mkfs output doesn't indicate that sparse inodes are configured.
- mkfs cli option of "-i sparse=[0|1]" makes more sense than
  "spalign"
- "SPARSE_INODES" missing from xfs_db version output
- kernel code seems to be regression from when not using sparse
  inodes
- inode allocation speed does not seem to be impacted by sparse
  inode allocation - running my fsmark tests on a debug kernel show
  no performance differential, even though sparse inode chunks
  should be created in that case.
- it smoke tests through xfstests ok

I haven't really looked through the userspace code in any detail,
so I can't really comment on that side of things yet. The kernel
code looks good, there doesn't appear to be any regressions and the
new functionailty works so far. Hence I think I'm going to merge
the kernel code in the 4.2 cycle, and we can work on getting
userspace into the current dev tree for people to test and use the
new code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
