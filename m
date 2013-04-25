Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03FE429DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 09:08:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86D0CAC006
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 07:08:07 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id Uj3WIzduCZELk4Ip (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 07:08:06 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 25 Apr 2013 08:08:05 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id C1DF219D806A
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:07:54 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3PE7osu113612 for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:07:53 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3PEAg3c028458
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:10:42 -0600
Subject: Re: [PATCH V2] xfs: introduce CONFIG_XFS_WARN
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130424225821.GV10481@dastard>
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com> <20130423210226.GN10481@dastard>
	<20130424085546.GQ10481@dastard>
	<1366828792.3762.32405.camel@chandra-dt.ibm.com>
	<20130424225821.GV10481@dastard>
Date: Thu, 25 Apr 2013 09:07:49 -0500
Message-ID: <1366898869.3762.32410.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, 2013-04-25 at 08:58 +1000, Dave Chinner wrote:
> On Wed, Apr 24, 2013 at 01:39:52PM -0500, Chandra Seetharaman wrote:
> > Hi Dave,
> > 
> > Since this solution is for production environment, would it be valuable
> > to have a sysctl variable to allow enabling/disabling XFS_WARN, as
> > opposed to needing to recompile the module afresh ?
> 
> The idea is that distros enable it on the debug kernel packages
> rather than using CONFIG_XFS_DEBUG=y. Hence if someone has a
> problem, they just install the debug kernel and they get all this
> additional checking.

Thanks for the clarification.

I was thinking that CONFIG_XFS_DEBUG would be enabled in the distro's
debug kernel and this new option is in addition to that. Hence, my
question.

So, with this new config option, CONFIG_XFS_DEBUG will only be used in
development environment, correct ?

> 
> There are roughly 1700 ASSERT statements in the XFS code, so
> compiling them in unconditionally is a lot of extra code. Adding a
> sysctl to make them conditional adds as many branches into the code
> than in 99.99999% of calls are never going to evaluate as true. The
> convenience of a sysctl is more than outweighed by the additional
> overhead for the majortiy of people that don't need to diagnose
> problems on their system.
> 
> Hence I don't think the overhead of unconditionally compiling in
> ASSERT checks is worth while for the majority of users, especially
> as most distros ship a debug kernel for exactly this purpose....
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
