Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BB5F29E15
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 18:34:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABEE4AC002
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 16:34:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	L7bxkNGCjixNnIdZ for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 16:34:31 -0700 (PDT)
Date: Thu, 9 May 2013 09:34:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: quota not supported on realtime filesystems
Message-ID: <20130508233428.GK24635@dastard>
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
	<1367993066-9313-3-git-send-email-david@fromorbit.com>
	<518A6325.3030809@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518A6325.3030809@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 08, 2013 at 09:37:25AM -0500, Eric Sandeen wrote:
> On 5/8/13 1:04 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Realtime XFS filesystems do not support quotas, so quota tests
> > always fail on such filesystems. Add a check to _require_quota to
> > detect this situation and notrun the quota tests...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> (PS why is USE_EXTERNAL a thing?  if it's set, shouldn't it be used?)

Because if you have rtdev/logdev defined in your config, you can
choose whether to test them or not without having to modify the
config file. Very handy, really.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
