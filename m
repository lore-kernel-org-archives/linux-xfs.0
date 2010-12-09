Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB91ba4l156647 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 19:37:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAD231D6DF3
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 17:34:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	7T2GCNU8rJJDw4ar for <xfs@oss.sgi.com>;
	Wed, 08 Dec 2010 17:34:39 -0800 (PST)
Date: Thu, 9 Dec 2010 12:34:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs tuning for a 830 GB partition (mkfs.xfs options)
Message-ID: <20101209013413.GA7105@dastard>
References: <AANLkTimkZB20eqywSPvwh00gcXWcr4_Eqm5u40P6RqaJ@mail.gmail.com>
	<20101209010531.GE32766@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101209010531.GE32766@dastard>
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
To: Abel Coto <whitewolf573@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 09, 2010 at 12:05:31PM +1100, Dave Chinner wrote:
> On Wed, Dec 08, 2010 at 08:32:28PM +0100, Abel Coto wrote:
> > I want to create a 830 GB partition, to mount as /home in my Centos 5.4
> > workstation.
> > 
> > Actually i have /home not mounted ,so i would have to create the new
> > partition in the lvm,format it and use rsync to copy /home directory to it.
> > 
> > for a 830 GB partition that i will use to save my data in general and also
> > 3d / CG projects and renders once finished them what agcount value should be
> > used. I have read that mkfs default option creates 1 allocation group each
> > 4G , so i understand that for a 830 GB partition agcount should be 208.
> > 
> > It is this correct ?
> 
> No, you've read something that is at least 5 years out of date. Just
> use the defaults - they are already optimised for best performance
> in most circumstances.

Seeing as I say this so often:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
