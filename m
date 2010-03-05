Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o25NP0Qp030782 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 17:25:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D248313FE347
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 15:26:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	krIx15d0sTu18YA7 for <xfs@oss.sgi.com>;
	Fri, 05 Mar 2010 15:26:27 -0800 (PST)
Date: Sat, 6 Mar 2010 10:26:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: Increase the default size of the reserved
	blocks pool
Message-ID: <20100305232624.GA28189@discord.disaster>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-4-git-send-email-david@fromorbit.com>
	<1267803953.2478.13.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267803953.2478.13.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 05, 2010 at 09:45:53AM -0600, Alex Elder wrote:
> On Thu, 2010-03-04 at 12:46 +1100, Dave Chinner wrote:
> > The current default size of the reserved blocks pool is easy to deplete
> > with certain workloads, in particular workloads that do lots of concurrent
> > delayed allocation extent conversions.  If enough transactions are running
> > in parallel and the entire pool is consumed then subsequent calls to
> > xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
> > warning so we know if this starts happening again.
> > 
> > This is an updated version of an old patch from Lachlan McIlroy.
> 
> Looks good.  The comment and code rearrangements are an
> improvement.
> 
> I have also reviewed the other two patches in the series
> (including the updated patch 2) and they too look good.
> 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
>          So is it got to be fromorbit or redhat?
>          (You used both in this series.)

What each individual patch says.

It depends on the history of the patch to what the sign-off I'll use
on it. This one I pulled from a patch series I had locally that
hadn't been touched for months (i.e. not new work). I simply updated
it for the recent resblks changes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
