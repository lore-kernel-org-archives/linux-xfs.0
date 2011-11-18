Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIFeXuC172833 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 09:40:34 -0600
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A9DF261823
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 07:40:33 -0800 (PST)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id 4wdwtpKKqNtzH6Pu for
	<xfs@oss.sgi.com>; Fri, 18 Nov 2011 07:40:33 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 18 Nov 2011 08:40:32 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pAIFdMjp072960 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 08:39:23 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pAIFdJX2023284
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 08:39:21 -0700
Subject: Re: Debug of xfstest 234 hang
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111110221937.GA2386@dastard>
References: <1320959794.2201.15.camel@chandra-lucid.austin.ibm.com>
	<20111110221937.GA2386@dastard>
Date: Fri, 18 Nov 2011 09:39:11 -0600
Message-ID: <1321630751.2201.66.camel@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>, Alex Elder <aelder@sgi.com>

Hi Dave,

I found the problem that is causing this issue. The logic around the
threshold calculation works as expected.

I saw the problem even when there is lot of space left and
xlog_grant_push_ail() returns with free space available.

The problem is in the way the l_reserveq and l_writeq are handled.

When we wake the processes that are sleeping on l_reserveq and l_writeq
thru wake_up(), we do not remove them from the queue, we expect the
process to remove themselves from the list (and we drop the lock). But,
before the woken up process gets a chance to remove itself, some other
process p1 comes in, checks that the queue is not empty and puts itself
at the end of the queue. All the woken up processes remove themselves
from the queue and move on. Whereas, the process p1 just gets stuck in
the queue. Any new process that comes in gets back at the end of the
queue and all of them gets stuck.

The problem doesn't happen if there is lot of activities, which makes
some process calls xfs_log_move_tail() or push the ail (thru
xlog_grant_push_ail()). But, with no activity, all these processes are
never woken up.

IMO, the right solution is to remove the item from the list when we wake
them up. I tried the change and it works as expected.

Will send the patch to the list shortly.

Regards,

Chandra


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
