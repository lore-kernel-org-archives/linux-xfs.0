Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 416927F47
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 09:44:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21821304048
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 07:44:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fU1BJbm2wRs9VZCD for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2015 07:44:50 -0800 (PST)
Message-ID: <54C903F1.30203@sandeen.net>
Date: Wed, 28 Jan 2015 09:44:49 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: maxpct option for small xfs filesystems
References: <54C667F3.8040303@oracle.com>
	<20150126223715.GA7621@dastard>	<54C7BB78.4060203@oracle.com>
	<54C7BD60.5000104@sandeen.net> <54C8BCEC.5050101@oracle.com>
In-Reply-To: <54C8BCEC.5050101@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 1/28/15 4:41 AM, Alexander Tsvetkov wrote:

...

>> and what does df -i say after remount?
> Nothing changed after remount:

Sorry, I misremembered the problem.  :(
 
...

>>
>> This is actually a problem with the lazy superblock counters I've run into before,
>> but haven't yet fixed.  This kind of workload is such that it never trips the
>> runtime rebalancing.
>>
>>> Looking into ncheck output there are 40512 pairs reported in the output each with own unique
>>> inode number. ncheck doesn't report inodes count by definition, but what does these
>>> 40512 reported inode numbers mean if only actually 640 inodes were allocated? From another hand
>>> each new file should have associated meta-data in the corresponding allocated inode structure, so for
>>> 40512 newly created files I expect the same count of allocated inodes, is it correct?
>> Recheck df -i after remount, I think you will see many more than 640.

> Do you mean that ncheck reports right number of allocated inodes instead of df -i? If counters are incorrect then the
> maxpct limit is not working as well, because there are much more of filesystem space allocated for inodes then defined limit 1%.
> 
> What is expected behaviour in this case when it's required for fs to allocate new inodes starting to exceed defined maxpct
> percentage? Which error is expected to be returned to user, enospc or probably just some warning?

There are a couple of things going on here.

XFS superblock counters are kept in per-cpu variables for scalability; at certain times these per-cpu counts are coalesced into a global counter based on various thresholds.  The thing about the inode counter is that it generally counts up, and it's the high thresholds that we care about (in order to determine if we've hit maxpct), but it's written as one of the low-threshold counters (as with free inodes / free space).

So in your test, you're rapidly running up the counter on a single cpu, and it's not getting coalesced into the main counter, which is where the imaxpct test happens.  So that's why you're able to exceed imaxpct.

The df -i (statfs) output is wrong because of a bug in xfs_fs_statfs.  For a filesystem like XFS which dynamically allocates and deallocates inodes, it's a little tricky to answer the question "how many inodes are available?"  It's limited by free space as well as by imaxpct. There's code in there which does this:

        if (mp->m_maxicount)
                statp->f_files = min_t(typeof(statp->f_files),
                                        statp->f_files,
                                        mp->m_maxicount);

so it will never report more than mp->m_maxicount, which is essentially the imaxpct limit, even if we've actually allocated more than that.

A simple fix for this is to recognize that imaxpct is something of a soft limit (it's not critical if we overrun by a few hundred or even thousand inodes), and if the superblock counter of allocated inodes (sbp->sb_icount) exceeds mp->m_maxicount due to such an overrun, we should report that (true) value instead.

I'm working on a couple of patches which should fix both issues.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
