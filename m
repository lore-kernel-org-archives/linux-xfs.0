Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13BF929DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 17:30:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 810DBAC004
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 15:30:06 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id EBTCqEjXwz32YxrS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 15:30:05 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 25 Apr 2013 18:30:04 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 62F4CC90025
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 18:29:59 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3PMTxsw249822 for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 18:29:59 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r3PMTxmw024885 for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 18:29:59 -0400
Subject: Re: [PATCH V2] xfs: introduce CONFIG_XFS_WARN
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130425214405.GR30622@dastard>
References: <1366699138-24055-1-git-send-email-david@fromorbit.com>
	<5176833C.8070305@redhat.com> <20130423210226.GN10481@dastard>
	<20130424085546.GQ10481@dastard>
	<1366828792.3762.32405.camel@chandra-dt.ibm.com>
	<20130424225821.GV10481@dastard>
	<1366898869.3762.32410.camel@chandra-dt.ibm.com>
	<20130425214405.GR30622@dastard>
Date: Thu, 25 Apr 2013 17:29:58 -0500
Message-ID: <1366928998.4098.0.camel@chandra-dt.ibm.com>
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
Cc: XFS mailing list <xfs@oss.sgi.com>

Thanks Dave.

On Fri, 2013-04-26 at 07:44 +1000, Dave Chinner wrote:
> On Thu, Apr 25, 2013 at 09:07:49AM -0500, Chandra Seetharaman wrote:
> > On Thu, 2013-04-25 at 08:58 +1000, Dave Chinner wrote:
> > > On Wed, Apr 24, 2013 at 01:39:52PM -0500, Chandra Seetharaman wrote:
> > > > Hi Dave,
> > > > 
> > > > Since this solution is for production environment, would it be valuable
> > > > to have a sysctl variable to allow enabling/disabling XFS_WARN, as
> > > > opposed to needing to recompile the module afresh ?
> > > 
> > > The idea is that distros enable it on the debug kernel packages
> > > rather than using CONFIG_XFS_DEBUG=y. Hence if someone has a
> > > problem, they just install the debug kernel and they get all this
> > > additional checking.
> > 
> > Thanks for the clarification.
> > 
> > I was thinking that CONFIG_XFS_DEBUG would be enabled in the distro's
> > debug kernel and this new option is in addition to that. Hence, my
> > question.
> 
> If you are shipping a debug kernel with CONFIG_XFS_DEBUG, then you
> don't want your customers running that debug kernel for very long.
> CONFIG_XFS_DEBUG changes allocation algorithms to improve test
> coverage and this causes accelerated filesystem aging....
> 
> CONFIG_XFS_WARN is designed to be used instead of CONFIG_XFS_DEBUG
> in these situations - we get more verbose checking, but without the
> down sides associated with all the algorithmic changes in
> XFS_DEBUG...
> 
> > So, with this new config option, CONFIG_XFS_DEBUG will only be used in
> > development environment, correct ?
> 
> That's what I has always been intended for.
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
