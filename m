Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD9C47F50
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 23:44:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA34A8F8039
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 21:44:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zgmBbOvtXDO6nXZ4 for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 21:44:55 -0700 (PDT)
Date: Tue, 23 Jul 2013 14:44:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
Message-ID: <20130723044450.GG19986@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<51EB80DB.80602@gmail.com> <20130722233240.GC19986@dastard>
	<51EDFA5A.7070402@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EDFA5A.7070402@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 22, 2013 at 11:36:58PM -0400, Michael L. Semon wrote:
> On 07/22/2013 07:32 PM, Dave Chinner wrote:
> > On Sun, Jul 21, 2013 at 02:34:03AM -0400, Michael L. Semon wrote:
> >> On 07/19/2013 02:44 AM, Dave Chinner wrote:
> >>
> >>> Comments, thoughts, flames?
> >>
> >> I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
> >> kernel, but the xfstests look like a disaster by going that way.  
> > 
> > We'll, if you don't have all the filtering patches that I posted a
> > while back it'll make quite a mess with all the experimental
> > warnings mkfs and repair emit, and the xfs_db tests that modify
> > filesystem structures will all also fail...
> 
> I've been slacking on xfstests updates.  The problem may exist 
> between keyboard and chair, though:  I was trying to copy a merged 
> xfsprogs from one PC to another, then build everything from `make 
> distclean` after deleting /usr/include/xfs.  Something must have 
> gone wrong...won't be the first time...
> 
> > I'll repost them later today...
> 
> I'll take this patchset home and see if any of them were not 
> committed to the xfsprogs git:
> 
> http://oss.sgi.com/archives/xfs/2013-06/msg00217.html
> 
> Is this the correct patchset?

Yeah, that's it, thugh I have a more recent version of it locally...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
