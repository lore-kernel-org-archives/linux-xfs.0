Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3BFD07F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 06:56:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB984AC007
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 04:56:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rvy3tyBjyiXo6fvb for
	<xfs@oss.sgi.com>; Thu, 24 Apr 2014 04:56:34 -0700 (PDT)
Date: Thu, 24 Apr 2014 07:30:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5 00/11] xfs: introduce the free inode btree
Message-ID: <20140424113025.GC51140@bfoster.bfoster>
References: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
	<20140414094632.GC31578@dastard> <20140424055101.GD15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140424055101.GD15995@dastard>
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

On Thu, Apr 24, 2014 at 03:51:01PM +1000, Dave Chinner wrote:
> On Mon, Apr 14, 2014 at 07:46:32PM +1000, Dave Chinner wrote:
> > On Thu, Apr 10, 2014 at 12:08:25PM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This is a minor rebase of the finobt series on the latest for-next
> > > branch. The previous version (v4) is here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2014-02/msg00763.html
> > > 
> > > The most recent series with review feedback is v3:
> > > 
> > > http://oss.sgi.com/archives/xfs/2014-02/msg00121.html
> > > 
> > > Brian
> > 
> > I've just had a look at this series, and I haven't found anything to
> > complain about apart from a couple of stray whitespaces that I
> > fixed. I'm going to run it through some finobt=0 test runs until i
> > get a chance to look at the userspace patches. If I don't notice
> > anything in the next couple of days, I'll merge the topic branch
> > into the main tree....
> 
> All looks pretty good. I can fix the one little problem I noticed
> myself, and so I think this is ready for merging. The userspace
> stuff isn't directly necessary right away - that won't get merged
> until 3.2 is released, but I don't see that as a problem for merging
> the kernel code...
> 

Ok, thanks. At this point then I'll plan to keep the first 10 or 11 or
so patches of the userspace series (that are based on these) equivalent.
If any fixes creep in before that happens to be merged, those can just
get appended to the series.

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
