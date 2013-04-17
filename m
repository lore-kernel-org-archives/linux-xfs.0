Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 370A97F50
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 13:33:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A63B7AC008
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 11:33:03 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id kj9aIKM5JaBAiee7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 11:33:02 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 17 Apr 2013 12:33:01 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 8340E1FF0039
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:27:56 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3HIWusA123356 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:32:56 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3HIWuRq019231
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:32:56 -0600
Subject: Re: [PATCH] xfstests: replace xfs_check with xfs_repair -n
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <516EE8A1.9070703@sandeen.net>
References: <1366216695.3762.32325.camel@chandra-dt.ibm.com>
	<516ED4A0.9040706@sandeen.net>
	<1366221810.3762.32341.camel@chandra-dt.ibm.com>
	<516EE8A1.9070703@sandeen.net>
Date: Wed, 17 Apr 2013 13:32:48 -0500
Message-ID: <1366223568.3762.32343.camel@chandra-dt.ibm.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, 2013-04-17 at 11:23 -0700, Eric Sandeen wrote:
> On 4/17/13 11:03 AM, Chandra Seetharaman wrote:
> > Hi Eric,
> > 
> > Thanks for the quick feedback.
> > 
> > On Wed, 2013-04-17 at 09:58 -0700, Eric Sandeen wrote:
> >> On 4/17/13 9:38 AM, Chandra Seetharaman wrote:
> >>> Replace the usage of "xfs_check" with "xfs_repair -n" as xfs_check
> >>> is planned to be depracated.
> >>
> >> Hm, I thought the plan was to keep xfs_check around for xfstests
> > 
> > I didn't think the plan was to keep xfs_check, may be I misunderstood.
> > My understanding was that we wanted to deprecate xfs_check, but first we
> > have to make xfstests not use xfs_check.
> > 
> >> use, for now; as Dave said in the earlier thread:
> >>
> >>> xfstests also still needs to run xfs_check. That means we also need
> >>> either an override flag an make $XFS_CHECK_PROG have it set
> >>> appropriately or add an internal xfs_db wrapper that runs the
> >>> xfs_check functionality appropriately. The second is probably the
> >>> better option...
> >>
> >> but that's not what this patch does...
> > 
> > The usages of xfs_check in xfstests looked simple and straight forward.
> > Besides, I thought we should do what we suggest our users to do :),
> > hence replaced xfs_check with "xfs_repair -n".
> 
> Dave or others can chime in too, but I think we still want xfs_check
> (xfs_db) as a verifier against xfs_repair.
> 
> > Does this patch break something or technically incorrect ?
> 
> We used to explicitly run both xfs_repair and xfs_check to get two
> distinct verification passes; the patch removes part of that, so I'd
> say yes, it does "break" things a little.
> 
> > Do you think I should instead use 
> >     xfs_db -F -i -p xfs_check -c "check" <dev>
> 
> Right, if the xfs_check script itself is going away, I think we still
> want to invoke "xfs_check" behavior one way or another in xfstests to
> keep current xfs verification levels for now.

It is clear now. will make appropriate changes and resubmit.

> 
> Thanks,
> -Eric
> 
> > Please advise.
> 
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
