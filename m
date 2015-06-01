Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEB817F5A
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 16:21:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A841AC002
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 14:21:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8Qb3ET8LqgVWV8yU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 14:21:23 -0700 (PDT)
Date: Mon, 1 Jun 2015 17:21:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5 00/18] xfs: sparse inode chunks
Message-ID: <20150601212120.GA17384@bfoster.bfoster>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
	<20150219191034.GA5750@bfoster.bfoster>
	<20150601001230.GG24666@dastard>
	<20150601125638.GB62578@bfoster.bfoster>
	<20150601204703.GI24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150601204703.GI24666@dastard>
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

On Tue, Jun 02, 2015 at 06:47:03AM +1000, Dave Chinner wrote:
> On Mon, Jun 01, 2015 at 08:56:39AM -0400, Brian Foster wrote:
> > On Mon, Jun 01, 2015 at 10:12:30AM +1000, Dave Chinner wrote:
> > > On Thu, Feb 19, 2015 at 02:10:34PM -0500, Brian Foster wrote:
> > > - kernel code seems to be regression from when not using sparse
> > >   inodes
> > 
> > What regression are you referring to?
> 
> Doh! typo there. s/from/free/
> 

Ah, that sounds better. ;)

> > > - inode allocation speed does not seem to be impacted by sparse
> > >   inode allocation - running my fsmark tests on a debug kernel show
> > >   no performance differential, even though sparse inode chunks
> > >   should be created in that case.
> > > - it smoke tests through xfstests ok
> > 
> > I haven't really run into much for issues so far save for a problem
> > discovered with the DEBUG mode code from my recent large block size
> > testing. I have a patch for that lying around I need to post...
> > 
> > > I haven't really looked through the userspace code in any detail,
> > > so I can't really comment on that side of things yet. The kernel
> > > code looks good, there doesn't appear to be any regressions and the
> > > new functionailty works so far. Hence I think I'm going to merge
> > > the kernel code in the 4.2 cycle, and we can work on getting
> > > userspace into the current dev tree for people to test and use the
> > > new code....
> > > 
> > 
> > Sounds good, thanks. The userspace bits have only been posted for
> > testing purposes to this point to avoid the churn from active review of
> > the core code. Since that is now merged, I'll get the latest mechanism
> > ported over to userspace, incorporate some of the fixes noted above and
> > get something posted hopefully soon.
> 
> Can you port it to the current dev branch (libxfs-4.1-update)? That
> way will be much easier for you, and me when it comes to merging..
> 

Yeah, it's been based on the 4.1 update branch for the last tarball or
two that have been posted, which eliminated the need for the
dependencies I was carrying along with it beforehand.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
