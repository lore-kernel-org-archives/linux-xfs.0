Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4D567F5A
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 15:47:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 841448F8037
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 13:47:25 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VU9CM27uXL57Qabl for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 13:47:06 -0700 (PDT)
Date: Tue, 2 Jun 2015 06:47:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 00/18] xfs: sparse inode chunks
Message-ID: <20150601204703.GI24666@dastard>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
	<20150219191034.GA5750@bfoster.bfoster>
	<20150601001230.GG24666@dastard>
	<20150601125638.GB62578@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150601125638.GB62578@bfoster.bfoster>
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

On Mon, Jun 01, 2015 at 08:56:39AM -0400, Brian Foster wrote:
> On Mon, Jun 01, 2015 at 10:12:30AM +1000, Dave Chinner wrote:
> > On Thu, Feb 19, 2015 at 02:10:34PM -0500, Brian Foster wrote:
> > - kernel code seems to be regression from when not using sparse
> >   inodes
> 
> What regression are you referring to?

Doh! typo there. s/from/free/

> > - inode allocation speed does not seem to be impacted by sparse
> >   inode allocation - running my fsmark tests on a debug kernel show
> >   no performance differential, even though sparse inode chunks
> >   should be created in that case.
> > - it smoke tests through xfstests ok
> 
> I haven't really run into much for issues so far save for a problem
> discovered with the DEBUG mode code from my recent large block size
> testing. I have a patch for that lying around I need to post...
> 
> > I haven't really looked through the userspace code in any detail,
> > so I can't really comment on that side of things yet. The kernel
> > code looks good, there doesn't appear to be any regressions and the
> > new functionailty works so far. Hence I think I'm going to merge
> > the kernel code in the 4.2 cycle, and we can work on getting
> > userspace into the current dev tree for people to test and use the
> > new code....
> > 
> 
> Sounds good, thanks. The userspace bits have only been posted for
> testing purposes to this point to avoid the churn from active review of
> the core code. Since that is now merged, I'll get the latest mechanism
> ported over to userspace, incorporate some of the fixes noted above and
> get something posted hopefully soon.

Can you port it to the current dev branch (libxfs-4.1-update)? That
way will be much easier for you, and me when it comes to merging..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
