Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SNYWGp028080 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:34:32 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61B8E11B8D49
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 16:38:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zxQ06yF03QeWIxJK for <xfs@oss.sgi.com>;
	Thu, 28 Apr 2011 16:38:04 -0700 (PDT)
Date: Fri, 29 Apr 2011 09:37:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110428233751.GR12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
	<alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Apr 28, 2011 at 10:30:47AM -0700, Christian Kujau wrote:
> Hi David,
> 
> sorry for the late response:
> 
> On Wed, 27 Apr 2011 at 20:28, Dave Chinner wrote:
> > hmmmm. Speaking of which - have you changed any of the XFS tunables
> > in /proc/sys/fs/xfs/ on your machine (specifically
> > xfssyncd_centisecs)?
> 
> No, I did not change anything underneath /proc/sys/fs/xfs.
>  
> > Not easy because there are tree-wide changes that need to be
> > preserved (e.g. block layer plugging changes) while others around it
> > would need to be reverted....
> 
> Yeah, I noticed. I wanted to do something like this:
> 
>   $ for c in `git log --pretty=oneline --no-merges v2.6.38..v2.6.39-rc2 fs/xfs | awk '{print $1}'`; do
>        git revert $c
>     done
> 
> ...but this broke on the 1st or 2nd commit because of unresolved changes.
> 
> Now I'm in the middle of another bisect attempt, trying to reproduce but 
> Im getting (probably totally unrelated) warnings here:

Did you read the email that pointed to CONFIG_TINY_RCU as the
ptotential source of the problem? Can you change to CONFIG_TREE_RCU
and see if the problem goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
