Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7MuXw4257876 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 16:56:33 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	swf9ovRF7XKCwwCo for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 14:58:58 -0800 (PST)
Date: Sat, 8 Dec 2012 09:58:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsdump INTERRUPT issue
Message-ID: <20121207225855.GM27172@dastard>
References: <CCE505AA.B05B7%jellis@dhnet.us>
	<50BFF726.6090006@hardwarefreak.com>
	<68036B67-6AE6-4056-89F5-9549B4E476FD@dhnet.us>
	<50C00583.6000804@hardwarefreak.com>
	<6F909666-9DFE-43F1-973D-170B892F9C5B@gmail.com>
	<50C0657D.5050903@hardwarefreak.com>
	<20121207101620.GK27172@dastard>
	<50C259F9.2050406@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C259F9.2050406@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 07, 2012 at 03:04:57PM -0600, Stan Hoeppner wrote:
> On 12/7/2012 4:16 AM, Dave Chinner wrote:
> > On Thu, Dec 06, 2012 at 03:29:33AM -0600, Stan Hoeppner wrote:
> >> On 12/5/2012 9:01 PM, Jeffrey Ellis wrote:
> >> BTW, if your goal in all of this is simply copying all the directories
> >> and files from one disk to another disk, you could have used "cp -a" and
> >> been done already.  It takes longer to execute than xfsdump/xfsrestore,
> >> but given you've been at this for many days now, "cp -a" would have
> >> already completed--long ago.
> > 
> > Unfortunately, using cp or rsync is not possible because the
> > filesystem has a real-time device attached to it. It's basically a
> > ~10GB data device and a ~500GB real-time device. I'd say it's from a
> > DVR or something like that, and that Jeffrey is trying to put
> > a bigger disk in the DVR....
> 
> Ah, yes.  I didn't catch the RT volume.
> 
> Incidentally, since the real-time feature has never been fully supported
> under Linux, why are DVR manufacturers even using it?  Without GRIO and
> the XBOW ASIC the real-time volume is pretty much useless isn't it?

The realtime volume actually has nothing to do with "real-time" at
all. What it has is a deterministic allocator (bitmap rather than
tree based) which is what you need for real-time applications (i.e.
bound worst case performance). It got called the "real-time device"
because of the applications it was used for, not because there is
anything "real-time" about it.  IOWs, you don't need special
hardware to take advantage of the properties of the allocator.

DVR manufacturers have decided to use it for 3 reasons:

	1. Folklore says you need a RT device for
	   concurrent streaming workloads
	2. It's supported upstream
	3. It makes it hard for windows users to replace the
	   harddisk in the DVR by themselves (true).

#3 is the case we are seeing here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
