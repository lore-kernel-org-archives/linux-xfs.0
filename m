Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 739287F54
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 21:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4564F8F804C
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 19:03:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kQN507D5cMGjXPoi for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 19:03:33 -0700 (PDT)
Date: Wed, 27 Mar 2013 13:03:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ASSERT failure] transaction reservations changes bad?
Message-ID: <20130327020331.GO6369@dastard>
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
	<513F0C07.1060000@oracle.com> <513F17F3.1010204@oracle.com>
	<20130312120545.GO21651@dastard> <51517506.1020906@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51517506.1020906@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 26, 2013 at 06:14:30PM +0800, Jeff Liu wrote:
> On 03/12/2013 08:05 PM, Dave Chinner wrote:
> > On Tue, Mar 12, 2013 at 07:56:35PM +0800, Jeff Liu wrote:
> >> More info, 3.7.0 is the oldest kernel on my environment, I ran into the
> >> same problem.
> > 
> > Thanks for following up so quickly, Jeff. So the problem is that a
> > new test is tripping over a bug that has been around for a while,
> > not that it is a new regression.
> > 
> > OK, so I'll expunge that from my testing for the moment as I don't
> > ahve time to dig in and find out what the cause is right now. If
> > anyone else wants to.... :)
> 
> I did some further tests to nail down this issue, just posting the analysis result here,
> it might be of some use when we revising it again.
> 
> The disk is formated with Dave's previous comments, i.e.
> mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/xxx
> 
> First of all, looks this bug stayed in hiding for years since I can reproduce it between upstream
> 3.0 to 3.9.0-rc3, the oldest kernel I have tried is 2.6.39 which has the same problem.

If you mount 2.6.39 with "-o nodelaylog", does the problem go away?

> IMHO, looks the major cause is related to the 'sunit' parameter,
> since it would affect the log space unit calculations by
> '2*log->l_mp->m_sb.sb_logsunit' at xlog_ticket_alloc().  However,
> we don't include this factor into consideration at mkfs or mount
> stage, should we take it into account?

That's what I suspected was the problem. i.e. that the log was too
small for the given configuration.

The question is this: how much space do we need to reserve. I'm
thinking a minimum of 4*lsu - 2*lsu for the existing CIL context, and
another 2*lsu for any queued ticket waiting for space to come
available.

I haven't thought a lot about it, though, and I have a little demon
sitting on my shoulder nagging me about specific thresholds whether
they need to play a part in this. e.g. no single transaction can be
larger than half the log; AIL push thresholds of 25% of log space;
background CIL commit threshold of 12.5% of the log...

So it's not immediately clear to me how much bigger the log needs to
be...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
