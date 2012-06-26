Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5Q6jXhD063995 for <xfs@oss.sgi.com>; Tue, 26 Jun 2012 01:45:33 -0500
Message-ID: <4FE95A6D.2090807@oracle.com>
Date: Tue, 26 Jun 2012 14:45:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: probe data buffer from page cache for unwritten
	extents
References: <4FE85C7B.3010909@oracle.com> <20120626023800.GE19223@dastard>
In-Reply-To: <20120626023800.GE19223@dastard>
Reply-To: jeff.liu@oracle.com
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Hi Mark and Dave,

Thanks for both of your comments.
On 06/26/2012 10:38 AM, Dave Chinner wrote:

> On Mon, Jun 25, 2012 at 08:41:31PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> Using the start offset rather than map->br_startoff to calculate the starting page index could
>> get more accurate data offset in page cache probe routine.
>> With this refinement, the old max_t() could be able to remove too. 
> ....
>> +			}
>> +			/*
>> +			 * xfs_bmapi_read() can handle repeated hole regions,
>> +			 * hence it should not return two extents both are
>> +			 * holes.  If the 2nd extent is unwritten, there must
>> +			 * have data buffer resides in page cache.
>> +			 */
>> +			BUG();
> 
> That's wrong. A hole can be up to 32bits in length. When the hole is
> longer than that, you'll get two extents that are holes. Try working
> with sparse files that have holes in the order of a 100TB in them...

I recalled we have verified that xfs_bmapi_read() can handle repeated
hole extents since the extent length in memory is 64bits which is
defined at:
struct xfs_bmbt_irec {
....
xfs_filblks_t   br_blockcount;
};

I can reproduce that issue with Mark's test case, simply by creating a
file with xfs_io -F -f -c "truncate 200M" -c "falloc $((50 << 20)) 50m"
-c "falloc $((100 << 20) 50m" -c "pwrite $((150 << 20)) 50m"

So the file mapping is:
 0-50m          50m-100m                100m-150m       150m-200m
[hole | unwritten_without_data | unwritten_without_data | data]

Current code logic will hit BUG() as the first unwritten extent has no
data buffer.

I have to do xfs_bmap_read() in a loop as before.

> 
> Also, as I've said before - BUG() does not belong in filesystem code
> that can return an error. Shut the filesystem down with an in-memory
> corruption error and maybe put an ASSERT(0) there so debug kernels
> trip over it. However, no filesystem "can not happen" logic error is
> a reason to panic a production machine.

Thanks for this teaching again.


Regards,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
