Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7F9829DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 19:21:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65104AC002
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 17:21:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nqXzoZGMVt7gTtup for <xfs@oss.sgi.com>;
	Wed, 24 Apr 2013 17:21:19 -0700 (PDT)
Message-ID: <517876FD.1000508@sandeen.net>
Date: Wed, 24 Apr 2013 19:21:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs: introduce CONFIG_XFS_WARN
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com> <20130423210226.GN10481@dastard>
	<20130424085546.GQ10481@dastard>
	<1366828792.3762.32405.camel@chandra-dt.ibm.com>
	<20130424225821.GV10481@dastard>
In-Reply-To: <20130424225821.GV10481@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On 4/24/13 5:58 PM, Dave Chinner wrote:
> On Wed, Apr 24, 2013 at 01:39:52PM -0500, Chandra Seetharaman wrote:
>> Hi Dave,
>>
>> Since this solution is for production environment, would it be valuable
>> to have a sysctl variable to allow enabling/disabling XFS_WARN, as
>> opposed to needing to recompile the module afresh ?
> 
> The idea is that distros enable it on the debug kernel packages
> rather than using CONFIG_XFS_DEBUG=y. Hence if someone has a
> problem, they just install the debug kernel and they get all this
> additional checking.
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

I agree.  kernel-debug, or whatever your distro does similarly,
is the right use for this code.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
