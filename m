Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2OLpkCr036218 for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 16:51:47 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E5252741BF
	for <xfs@oss.sgi.com>; Wed, 24 Mar 2010 14:53:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	L2NVAFHRuKPpyAb6 for <xfs@oss.sgi.com>;
	Wed, 24 Mar 2010 14:53:26 -0700 (PDT)
Date: Thu, 25 Mar 2010 08:53:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: add fs name to kthreads
Message-ID: <20100324215324.GB7671@dastard>
References: <alpine.LSU.2.01.1003062033100.16438@obet.zrqbmnf.qr>
	<20100308012824.GH28189@discord.disaster>
	<alpine.LSU.2.01.1003181510240.30506@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1003181510240.30506@obet.zrqbmnf.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Thu, Mar 18, 2010 at 03:13:10PM +0100, Jan Engelhardt wrote:
> 
> On Monday 2010-03-08 02:28, Dave Chinner wrote:
> >
> >Looks ok, but a couple of things. First, it would be good if you
> >supplied a reason/justification for the patch so the commit message
> >will tell us why this change was made.
> >
> >Please keep the same indent style as the rest of the functions. i.e
> 
> >>  xfsaild_start(
> >> -	struct xfs_ail	*ailp)
> >> +	struct xfs_ail	*ailp,
> >> +	const char *fsname)
> >>  {
> >>  	ailp->xa_target = 0;
> >> -	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
> >> +	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s", fsname);
> >
> >No need to pass the name into this function. It can be retrieved
> >from ailp->xa_mount->m_fsname.
> 
> I think I've got that now.
> 
> N.B.: The xfslogd/N threads are obvious (percpu workqueue, or
> whatever the tech is currently called), but at one time in the
> past it struck me that I had lots of xfsbufd/aild/syncd without
> the /n suffix.

Looks good now, I'll queue it up with all the other pending changes
I have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
