Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B5C47F37
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 17:35:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EF376AC01C
	for <xfs@oss.sgi.com>; Wed, 28 Aug 2013 15:34:57 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OF8bGKwEFpNBNPvD for <xfs@oss.sgi.com>;
	Wed, 28 Aug 2013 15:34:56 -0700 (PDT)
Date: Thu, 29 Aug 2013 08:34:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: check LSN ordering for v5 superblocks during
	recovery
Message-ID: <20130828223452.GQ12779@dastard>
References: <1377688967-6480-1-git-send-email-david@fromorbit.com>
	<1377688967-6480-3-git-send-email-david@fromorbit.com>
	<521E625A.2070109@sgi.com> <20130828210223.GO12779@dastard>
	<521E6680.80105@sgi.com> <20130828213126.GP12779@dastard>
	<521E6F09.9010004@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <521E6F09.9010004@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 28, 2013 at 04:43:37PM -0500, Mark Tinguely wrote:
> On 08/28/13 16:31, Dave Chinner wrote:
> >On Wed, Aug 28, 2013 at 04:07:12PM -0500, Mark Tinguely wrote:
> >>On 08/28/13 16:02, Dave Chinner wrote:
> >>>On Wed, Aug 28, 2013 at 03:49:30PM -0500, Mark Tinguely wrote:
> >>>>On 08/28/13 06:22, Dave Chinner wrote:
> >>>>>From: Dave Chinner<dchinner@redhat.com>
> >>>>
> >>>>Looks good. Nice to get into Linux 3.12 and possibly back to stable.
> >>>
> >>>Why stable? It's v5 only code, and everyon knows that is still in
> >>>the experimental stage....
> >>
> >>yep.
> >
> >That doesn't answer my question. You had to have some reason for
> >suggesting a possible stable backport for this code after reviewing
> >it, and I'm interested to know what it was...
> >
> >Cheers,
> >
> >Dave.
> 
> No thought that it would be nice to get it into Linux 3.12 and if
> Brian or anyone wants to review it, then it needs to be done soon.
> 
> my "yep" was a terse agreeing with your point.
> 
>   Yep, this problem has been around forever.
>   Yep, this problem was found/confirmed by your verifier.
>   Yep, this problem can only be fixed this way in superblock v5.
>   Yep, I had blinders on and was not thinking this to experimental code
>     so it does not matter to push it back.

Ok, all good then. :)

Thanks for explaining in more detail, Mark. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
