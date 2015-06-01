Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE74D7F55
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 07:56:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F533304043
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 05:56:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yX8IC6ZANEFqCCie (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 05:56:41 -0700 (PDT)
Date: Mon, 1 Jun 2015 08:56:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5 00/18] xfs: sparse inode chunks
Message-ID: <20150601125638.GB62578@bfoster.bfoster>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
	<20150219191034.GA5750@bfoster.bfoster>
	<20150601001230.GG24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150601001230.GG24666@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 01, 2015 at 10:12:30AM +1000, Dave Chinner wrote:
> On Thu, Feb 19, 2015 at 02:10:34PM -0500, Brian Foster wrote:
> > On Thu, Feb 19, 2015 at 01:13:25PM -0500, Brian Foster wrote:
> > > Hi all,
> > > 
> > > Here's v5 of sparse inode chunks. The only real change here is to
> > > convert the allocmask helpers back to using the XFS bitmap helpers
> > > rather than the generic bitmap code. This eliminates the need for the
> > > endian-conversion hack and extra helper to export a generic bitmap to a
> > > native type. The former users of the generic bitmap itself have been
> > > converted to use the native 64-bit value appropriately.
> > > 
> > > The XFS bitmap code is actually not in userspace either so neither of
> > > these implementations backport cleanly to userspace. As it is, I've not
> > > included the sparse alloc/free code in my xfsprogs branch as this code
> > > currently isn't needed. Nothing in userspace that I've seen requires the
> > > ability to do a sparse inode allocation or free. I suspect if it is
> > > needed in the future, we can more easily sync the XFS bitmap helpers to
> > > userspace than the generic Linux bitmap code.
> > > 
> > > Thoughts, reviews, flames appreciated...
> > > 
> > 
> > Attached is a tarball of a set of xfsprogs patches to aid in testing
> > this patchset. I'm posting as a tarball because the core patches (e.g.,
> > the kernel patches) are obviously still in flux. The tarball includes
> > the following:
> > 
> > - general dependency backports
> > - core infrastructure backports (i.e., applicable patches from this v5
> >   sparse inode set)
> > - xfsprogs work for sparse inode support
> > 
> > The latter bits include support for mkfs, xfs_info, xfs_db and
> > xfs_repair, the fundamentals of all of which should work. Use the '-i
> > spalign' mkfs option to format a sparse inode enabled fs. E.g.:
> > 
> > 	mkfs.xfs -m crc=1,finobt=1 -i spalign <dev>
> > 
> > Note that metadump is not yet supported. Failures from the associated
> > xfstests, etc. are expected. I'm not aware of anything else that is
> > missing support or otherwise broken, so any feedback along those lines
> > is appreciated.
> 
> Notes:
> 
> - mkfs output doesn't indicate that sparse inodes are configured.
> - mkfs cli option of "-i sparse=[0|1]" makes more sense than
>   "spalign"
> - "SPARSE_INODES" missing from xfs_db version output

Ok...

> - kernel code seems to be regression from when not using sparse
>   inodes

What regression are you referring to?

> - inode allocation speed does not seem to be impacted by sparse
>   inode allocation - running my fsmark tests on a debug kernel show
>   no performance differential, even though sparse inode chunks
>   should be created in that case.
> - it smoke tests through xfstests ok
> 

I haven't really run into much for issues so far save for a problem
discovered with the DEBUG mode code from my recent large block size
testing. I have a patch for that lying around I need to post...

> I haven't really looked through the userspace code in any detail,
> so I can't really comment on that side of things yet. The kernel
> code looks good, there doesn't appear to be any regressions and the
> new functionailty works so far. Hence I think I'm going to merge
> the kernel code in the 4.2 cycle, and we can work on getting
> userspace into the current dev tree for people to test and use the
> new code....
> 

Sounds good, thanks. The userspace bits have only been posted for
testing purposes to this point to avoid the churn from active review of
the core code. Since that is now merged, I'll get the latest mechanism
ported over to userspace, incorporate some of the fixes noted above and
get something posted hopefully soon.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
