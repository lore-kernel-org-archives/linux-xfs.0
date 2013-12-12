Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB94129DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:46:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 798378F8065
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:46:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hUBkzjjMXnHcJvPP for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 12:46:27 -0800 (PST)
Date: Fri, 13 Dec 2013 07:46:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] repair: per AG locks contend for cachelines
Message-ID: <20131212204623.GY10988@dastard>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-3-git-send-email-david@fromorbit.com>
	<52AA0773.1000506@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52AA0773.1000506@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 01:58:59PM -0500, Brian Foster wrote:
> On 12/12/2013 02:22 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The per-ag locks used to protect per-ag block lists are located in a tightly
> > packed array. That means that they share cachelines, so separate them out inot
> > separate 64 byte regions in the array.
> > 
> > pahole confirms the padding is correctly applied:
> > 
> > struct aglock {
> >         pthread_mutex_t            lock;                 /*     0    40 */
> > 
> >         /* size: 64, cachelines: 1, members: 1 */
> >         /* padding: 24 */
> > };
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Out of curiosity, any data on this one?

There's a small improvement but it's within the margins of error. At
higher levels of concurrency it will make a bigger difference, but
right now we can't get to a thread per AG (where the contention
would really show) because of other scalability limitations

e.g. mmap_sem contention becomes a limiting factor at 20-25 threads
because of page faults occurring on hash cache lookups (read lock)
occurring in parallel with memory allocation (libc mprotect calls
take a write lock). So more scalability will come from a CPU cache
friendlier cache index - I'm tempted to drop in per-AG rb trees and
see where that leads (now where would I have got that idea?)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
