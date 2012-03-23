Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NDYZOq186467 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 08:34:35 -0500
Message-ID: <4F6C7BE7.3060100@sgi.com>
Date: Fri, 23 Mar 2012 08:34:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120322151548.GS7762@sgi.com> <20120322210723.GC5091@dastard>
In-Reply-To: <20120322210723.GC5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 03/22/12 16:07, Dave Chinner wrote:
> On Thu, Mar 22, 2012 at 10:15:48AM -0500, Ben Myers wrote:
>> On Thu, Mar 22, 2012 at 04:15:08PM +1100, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Because the mount process can run a quotacheck and consume lots of
>>> inodes, we need to be able to run periodic inode reclaim during the
>>> mount process. This will prevent running the system out of memory
>>> during quota checks.
>>>
>>> This essentially reverts 2bcf6e97, but that is safe to do now that
>>> the quota sync code that was causing problems during long quotacheck
>>> executions is now gone.
>>
>> Dave, I've held off on #s 3 and 4 because they appear to be racy.  Being
>
> What race?
>
> Cheers,
>
> Dave


2 of the sync workers use iterators
  xfs_inode_ag_iterator()
   xfs_perag_get()
    radix_tree_lookup(&mp->m_perag_tree, agno)

The race I was worried about was in xfs_mount() to initialize the
mp->m_perag_lock, and the radix tree initialization:
  INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC)).

There is a lock and 2 or 3 unbuffered I/O are performed in xfs_mountfs()
before the mp->m_perag_tree is initialized.

I was also looking at the xfs_perag_t being allocated in mountfs() and 
being deallocated in umountfs(), but it turns out that is not important, 
xfs_perag_get() will return NULL if these have not been allocated yet or 
have been removed for the required ag.

Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
