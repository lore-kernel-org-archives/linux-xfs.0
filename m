Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbeCUQmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 12:42:39 -0400
Date: Wed, 21 Mar 2018 09:41:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Change URL for the project in xfs.txt
Message-ID: <20180321164129.GA4818@magnolia>
References: <20180302133013.9744-1-standby24x7@gmail.com>
 <20180302172401.GT19312@magnolia>
 <20180302215731.GT30854@dastard>
 <27d9f522-fa75-6766-3ca6-79f99522e861@sandeen.net>
 <20180302224310.GV30854@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302224310.GV30854@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Masanari Iida <standby24x7@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org

On Sat, Mar 03, 2018 at 09:43:10AM +1100, Dave Chinner wrote:
> On Fri, Mar 02, 2018 at 04:08:24PM -0600, Eric Sandeen wrote:
> > 
> > 
> > On 3/2/18 3:57 PM, Dave Chinner wrote:
> > > On Fri, Mar 02, 2018 at 09:24:01AM -0800, Darrick J. Wong wrote:
> > >> On Fri, Mar 02, 2018 at 10:30:13PM +0900, Masanari Iida wrote:
> > >>> The oss.sgi.com doesn't exist any more.
> > >>> Change it to current project URL, https://xfs.wiki.kernel.org/
> > >>>
> > >>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> > >>> ---
> > >>>  Documentation/filesystems/xfs.txt | 2 +-
> > >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> > >>> index 3b9b5c149f32..4d9ff0a7f8e1 100644
> > >>> --- a/Documentation/filesystems/xfs.txt
> > >>> +++ b/Documentation/filesystems/xfs.txt
> > >>> @@ -9,7 +9,7 @@ variable block sizes, is extent based, and makes extensive use of
> > >>>  Btrees (directories, extents, free space) to aid both performance
> > >>>  and scalability.
> > >>>  
> > >>> -Refer to the documentation at http://oss.sgi.com/projects/xfs/
> > >>> +Refer to the documentation at https://xfs.wiki.kernel.org/
> > > 
> > > Did I miss a memo?
> > 
> > About which part, the loss of oss.sgi or the addition of the kernel.org wiki?
> > 
> > The kernel.org wiki is pretty bare though.  OTOH xfs.org is a bit less
> > official.  We really need to resolve this issue.
> 
> Moving everything to kernel.org wiki. As I mentioned on IRC, I'd
> much prefer we move away from wiki's to something we can edit
> locally, review via email, has proper revision control and a
> "publish" mechanism that pushes built documentation out to the
> public website.

Makes sense, it's sort of annoying to have to build the pdfs from
documentation repo and kup them to k.org manually.  In the meantime I'd
rather have a scribble-me-elmo wiki over a dead url.

Also afaik the only people who actually have write access to that wiki
are Luis, Eric, and me, so hopefully we won't have to deal with
vandalism in the interim.

I wonder if we could just make the existing dokiwiki use
xfs-documentation.git as its backend and control the publishing that
way...?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
