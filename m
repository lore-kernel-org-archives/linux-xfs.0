Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA31pb5O227214 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 20:51:37 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	3QFTmKh1jsx8FoeZ for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 18:53:29 -0700 (PDT)
Date: Sat, 3 Nov 2012 12:53:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: status of userspace release
Message-ID: <20121103015326.GE29378@dastard>
References: <20121025151501.GV1377@sgi.com> <20121102055102.GY29378@dastard>
	<20121102185923.GG9783@sgi.com> <20121102230334.GA29378@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102230334.GA29378@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 03, 2012 at 10:03:34AM +1100, Dave Chinner wrote:
> On Fri, Nov 02, 2012 at 01:59:23PM -0500, Ben Myers wrote:
> > The TODO list for userspace release currently stands at:
> > 
> > 1) fix the header checksum failures... which is resolved
> > 2) fix a futex hang in 059
> > 3) fix the golden output changes related to multistream support in xfsdump
> >    and --largefs
> 
> Well, understand them first, then fix ;)

Because it is a bug in the dump filter that the largefs patchset
introduces. I've fixed this, and the problem goes away. You can take
this off your list ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
