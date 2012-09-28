Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SKgpUX049897 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 15:42:51 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o0MDdGBedbx5fknn for
	<xfs@oss.sgi.com>; Fri, 28 Sep 2012 13:44:11 -0700 (PDT)
Message-ID: <50660BBA.2080500@redhat.com>
Date: Fri, 28 Sep 2012 16:42:34 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 8/8] xfs: add background scanning to clear EOFBLOCKS
	inodes
References: <1348767952-24229-1-git-send-email-bfoster@redhat.com>
	<1348767952-24229-9-git-send-email-bfoster@redhat.com>
	<20120928080009.GM25626@dastard>
In-Reply-To: <20120928080009.GM25626@dastard>
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
Cc: xfs@oss.sgi.com

On 09/28/2012 04:00 AM, Dave Chinner wrote:
> On Thu, Sep 27, 2012 at 01:45:52PM -0400, Brian Foster wrote:
>> Create a delayed_work to enable background scanning and freeing
>> of EOFBLOCKS inodes. The scanner kicks in once speculative
>> preallocation occurs and stops requeueing itself when no EOFBLOCKS
>> inodes exist.
>>
>> Scans are queued on the existing syncd workqueue and the interval
>> is based on the new eofb_timer tunable (default to 5m). The
>> background scanner performs unfiltered, best effort scans (which
>> skips inodes under lock contention or with a dirty cache mapping).
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_globals.c |    1 +
>>  fs/xfs/xfs_linux.h   |    1 +
>>  fs/xfs/xfs_mount.h   |    2 ++
>>  fs/xfs/xfs_sync.c    |   30 ++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_sysctl.c  |    9 +++++++++
>>  fs/xfs/xfs_sysctl.h  |    1 +
>>  6 files changed, 44 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
>> index 76e81cf..fda9a66 100644
>> --- a/fs/xfs/xfs_globals.c
>> +++ b/fs/xfs/xfs_globals.c
>> @@ -40,4 +40,5 @@ xfs_param_t xfs_params = {
>>  	.rotorstep	= {	1,		1,		255	},
>>  	.inherit_nodfrg	= {	0,		1,		1	},
>>  	.fstrm_timer	= {	1,		30*100,		3600*100},
>> +	.eofb_timer	= {	1*100,		300*100,	7200*100},
>>  };
>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
>> index 828662f..bbad99b 100644
>> --- a/fs/xfs/xfs_linux.h
>> +++ b/fs/xfs/xfs_linux.h
>> @@ -118,6 +118,7 @@
>>  #define xfs_rotorstep		xfs_params.rotorstep.val
>>  #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
>>  #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
>> +#define xfs_eofb_centisecs	xfs_params.eofb_timer.val
> 
> Let's not propagate that stupid "centiseconds" unit any further.
> Nobody uses it, and it was only introduced because jiffie was 10ms
> and there were 100 to a second so it was easy to convert in the
> code. I don't think there is any reason for needing sub-second
> granularity for this background function, so seconds shoul dbe just
> fine for it. If you think we nee dfiner granularity, milliseconds is
> the nex tunit to choose....
> 

I think seconds is fine. I chose 1s for a minimum, but even that is
pathological and really only useful for focused stress testing.

>>  
>>  #define current_cpu()		(raw_smp_processor_id())
>>  #define current_pid()		(current->pid)
>> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
>> index deee09e..bf5ecfa 100644
>> --- a/fs/xfs/xfs_mount.h
>> +++ b/fs/xfs/xfs_mount.h
>> @@ -199,6 +199,8 @@ typedef struct xfs_mount {
>>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>>  	struct delayed_work	m_sync_work;	/* background sync work */
>>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>> +	struct delayed_work	m_eofblocks_work; /* background eof blocks
>> +						     trimming */
>>  	struct work_struct	m_flush_work;	/* background inode flush */
>>  	__int64_t		m_update_flags;	/* sb flags we need to update
>>  						   on the next remount,rw */
>> diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
>> index c9e1c16..31f678a 100644
>> --- a/fs/xfs/xfs_sync.c
>> +++ b/fs/xfs/xfs_sync.c
>> @@ -532,6 +532,31 @@ xfs_flush_worker(
>>  	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
>>  }
>>  
>> +/*
>> + * Background scanning to trim post-EOF preallocated space. This is queued
>> + * based on the 'eofb_centisecs' tunable (5m by default).
>> + */
>> +STATIC void
>> +xfs_queue_eofblocks(
>> +	struct xfs_mount *mp)
>> +{
>> +	rcu_read_lock();
>> +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_EOFBLOCKS_TAG))
>> +		queue_delayed_work(xfs_syncd_wq, &mp->m_eofblocks_work,
>> +			msecs_to_jiffies(xfs_eofb_centisecs * 10));
>> +	rcu_read_unlock();
>> +}
> 
> This will all need reworking for the new xfs_icache.c and per-mount
> workqueue structuring. Fundamentally there is nothing wrong with
> what you've done, it's just been reworked...
> 
>> +	{
>> +		.procname	= "eofb_centisecs",
> 
> Ugh. Call it something users might understand. Say
> "background_prealloc_discard_period", or something similarly
> informative...
> 

Ok. Thanks for the review.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
