Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8208129DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 16:44:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 700308F8035
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 14:44:08 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CqThAEPfdAsnnkdW for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 14:44:07 -0700 (PDT)
Date: Fri, 26 Apr 2013 07:44:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: introduce CONFIG_XFS_WARN
Message-ID: <20130425214405.GR30622@dastard>
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com> <20130423210226.GN10481@dastard>
	<20130424085546.GQ10481@dastard>
	<1366828792.3762.32405.camel@chandra-dt.ibm.com>
	<20130424225821.GV10481@dastard>
	<1366898869.3762.32410.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366898869.3762.32410.camel@chandra-dt.ibm.com>
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

On Thu, Apr 25, 2013 at 09:07:49AM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-04-25 at 08:58 +1000, Dave Chinner wrote:
> > On Wed, Apr 24, 2013 at 01:39:52PM -0500, Chandra Seetharaman wrote:
> > > Hi Dave,
> > > 
> > > Since this solution is for production environment, would it be valuable
> > > to have a sysctl variable to allow enabling/disabling XFS_WARN, as
> > > opposed to needing to recompile the module afresh ?
> > 
> > The idea is that distros enable it on the debug kernel packages
> > rather than using CONFIG_XFS_DEBUG=y. Hence if someone has a
> > problem, they just install the debug kernel and they get all this
> > additional checking.
> 
> Thanks for the clarification.
> 
> I was thinking that CONFIG_XFS_DEBUG would be enabled in the distro's
> debug kernel and this new option is in addition to that. Hence, my
> question.

If you are shipping a debug kernel with CONFIG_XFS_DEBUG, then you
don't want your customers running that debug kernel for very long.
CONFIG_XFS_DEBUG changes allocation algorithms to improve test
coverage and this causes accelerated filesystem aging....

CONFIG_XFS_WARN is designed to be used instead of CONFIG_XFS_DEBUG
in these situations - we get more verbose checking, but without the
down sides associated with all the algorithmic changes in
XFS_DEBUG...

> So, with this new config option, CONFIG_XFS_DEBUG will only be used in
> development environment, correct ?

That's what I has always been intended for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
