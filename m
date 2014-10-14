Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 204D37F3F
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 06:38:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE64BAC010
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2014 04:38:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id V8s4tbrPXzJCKhlg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Oct 2014 04:38:08 -0700 (PDT)
Date: Tue, 14 Oct 2014 07:37:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4] xfs: rework zero range to prevent invalid i_size
	updates
Message-ID: <20141014113758.GA64776@bfoster.bfoster>
References: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
	<20141014001806.GG5267@dastard> <20141014005058.GH5267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141014005058.GH5267@dastard>
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

On Tue, Oct 14, 2014 at 11:50:58AM +1100, Dave Chinner wrote:
> On Tue, Oct 14, 2014 at 11:18:06AM +1100, Dave Chinner wrote:
> > I'm running 3.17 + for-next + a handful of local patches, but this
> > is the only patch that modifies anything in this area. I'll remove
> > all the other patches I have just to check....
> 
> When this is the only patch on top of 3.17+for-next it still
> triggers.
> 

Interesting, I didn't catch this. I do reproduce with v4 and v3. Note
that this is the assert for having at least 1 indirect block
reservation, so it's a separate problem (not a stale delalloc problem):

http://oss.sgi.com/archives/xfs/2014-09/msg00337.html

What looks like is going on here is this patch regresses current
for-next due to our previous zero range workaround to flush on zero
range.  This was originally reproducible on tot, the zero range flush
quiets it down by forcing delalloc conversion, and this patch
reintroduces it simply by eliminating the flush.

I've just recently got back to fixing that problem. I have a couple
patches that need more testing, but I'll try to get them posted for
review today.

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
