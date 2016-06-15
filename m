Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E99B7CA2
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 13:55:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EEAD6AC002
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 11:55:43 -0700 (PDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
	(mail-bl2on0146.outbound.protection.outlook.com
	[65.55.169.146]) by cuda.sgi.com with ESMTP id Fo4YBGNJm2jr3wgE
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2016 11:55:37 -0700 (PDT)
Message-ID: <5761A48F.1040304@hpe.com>
Date: Wed, 15 Jun 2016 14:55:11 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH-tip 6/6] xfs: Enable reader optimistic spinning for
	DAX inodes
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
	<1465927959-39719-7-git-send-email-Waiman.Long@hpe.com>
	<20160614230613.GB26977@dastard>
In-Reply-To: <20160614230613.GB26977@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

On 06/14/2016 07:06 PM, Dave Chinner wrote:
> On Tue, Jun 14, 2016 at 02:12:39PM -0400, Waiman Long wrote:
>> This patch enables reader optimistic spinning for inodes that are
>> under a DAX-based mount point.
>>
>> On a 4-socket Haswell machine running on a 4.7-rc1 tip-based kernel,
>> the fio test with multithreaded randrw and randwrite tests on the
>> same file on a XFS partition on top of a NVDIMM with DAX were run,
>> the aggregated bandwidths before and after the patch were as follows:
>>
>>    Test      BW before patch     BW after patch  % change
>>    ----      ---------------     --------------  --------
>>    randrw        1352 MB/s          2164 MB/s      +60%
>>    randwrite     1710 MB/s          2550 MB/s      +49%
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hpe.com>
>> ---
>>   fs/xfs/xfs_icache.c |    9 +++++++++
>>   1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index 99ee6ee..09f284f 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -71,6 +71,15 @@ xfs_inode_alloc(
>>
>>   	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
>>
>> +	/*
>> +	 * Enable reader spinning for DAX nount point
>> +	 */
>> +	if (mp->m_flags&  XFS_MOUNT_DAX) {
>> +		rwsem_set_rspin_threshold(&ip->i_iolock.mr_lock);
>> +		rwsem_set_rspin_threshold(&ip->i_mmaplock.mr_lock);
>> +		rwsem_set_rspin_threshold(&ip->i_lock.mr_lock);
>> +	}
> That's wrong. DAX is a per-inode flag, not a mount wide flag. This
> needs to be done once the inode has been fully initialised and
> IS_DAX(inode) can be run.
>
> Also, the benchmark doesn't show that all these locks are being
> tested by this benchmark. e.g. the i_mmaplock isn't involved in
> the benchmark's IO paths at all. It's only taken in page faults and
> truncate paths....
>
> I'd also like to see how much of the gain comes from the iolock vs
> the ilock, as the ilock is nested inside the iolock and so
> contention is much rarer....

This patch has now been superseded by a second one where changes to the 
xfs code is no longer needed. The new patch will enable reader spinning 
for all rwsem and dynamically disable it depending on past history.

> As it is, I'm *extremely* paranoid when it comes to changes to core
> locking like this. Performance is secondary to correctness, and we
> need much more than just a few benchmarks to verify there aren't
> locking bugs being introduced....

The core rwsem locking logic hasn't been changed. There are some minor 
changes, however, on what RWSEM_WAITING_BIAS value to use that requires 
more eyeballs to make sure that it hasn't introduced any new bug.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
