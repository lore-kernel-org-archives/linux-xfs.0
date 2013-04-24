Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D2C0729DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 17:58:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B09FB8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 15:58:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qXmGOoEleIBuPdvj for <xfs@oss.sgi.com>;
	Wed, 24 Apr 2013 15:58:38 -0700 (PDT)
Date: Thu, 25 Apr 2013 08:58:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: introduce CONFIG_XFS_WARN
Message-ID: <20130424225821.GV10481@dastard>
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com> <20130423210226.GN10481@dastard>
	<20130424085546.GQ10481@dastard>
	<1366828792.3762.32405.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366828792.3762.32405.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Wed, Apr 24, 2013 at 01:39:52PM -0500, Chandra Seetharaman wrote:
> Hi Dave,
> 
> Since this solution is for production environment, would it be valuable
> to have a sysctl variable to allow enabling/disabling XFS_WARN, as
> opposed to needing to recompile the module afresh ?

The idea is that distros enable it on the debug kernel packages
rather than using CONFIG_XFS_DEBUG=y. Hence if someone has a
problem, they just install the debug kernel and they get all this
additional checking.

There are roughly 1700 ASSERT statements in the XFS code, so
compiling them in unconditionally is a lot of extra code. Adding a
sysctl to make them conditional adds as many branches into the code
than in 99.99999% of calls are never going to evaluate as true. The
convenience of a sysctl is more than outweighed by the additional
overhead for the majortiy of people that don't need to diagnose
problems on their system.

Hence I don't think the overhead of unconditionally compiling in
ASSERT checks is worth while for the majority of users, especially
as most distros ship a debug kernel for exactly this purpose....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
