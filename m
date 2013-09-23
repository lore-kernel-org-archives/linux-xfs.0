Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D5327CBF
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 23:56:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80707304043
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 21:56:14 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DR1yCNesSaQ1EQE2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 21:56:13 -0700 (PDT)
Message-ID: <523FCA18.1000204@oracle.com>
Date: Mon, 23 Sep 2013 12:56:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_iext_destroy() by freeing extent
	indirection array directly
References: <523C5E92.8000406@oracle.com> <20130923003617.GM12541@dastard>
In-Reply-To: <20130923003617.GM12541@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/23/2013 08:36 AM, Dave Chinner wrote:

> On Fri, Sep 20, 2013 at 10:41:22PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> To free the incore file extents stores at the indirection array, we
>> call the common routine xfs_iext_irec_remove() to remove a record
>> from the array one at a time in reverse order, which will resize an
>> extent indirection array repeatedly according to the array size.
>>
>> This is not often the case to make a file with thousands extent records
>> stores at an indirection array, but above operation is inefficient and
>> could result in memory fragments.
> 
> Yes, it may be inefficient, but I don't see that it's a contributor
> to memory fragmentation as the reallocated buffer is freed shortly
> after it has been allocated as the array shrinks. Do you have any
> evidence to suggest that such behaviour is actually fragmenting
> memory? If so, is the any test case that reproduces this problem?

Ah, yes, it should not cause memory fragmentation.

The benefits is that this change could save alloc/free buffers depending
on the number of extents records are stored at indirection array.

> 
> How did you test the change?

I only test this change with a simple case for creating a sparse file
with 8192 extents, which was shown as following,

xfs_io -f -c "truncate 10g" /xfs/testme

for i in $(seq 0 1 8191); do
	offset=$(($i * $((1 << 20))))
	xfs_io -c "pwrite $offset 1k" /xfs/testme
done

> 
>> This patch refine xfs_iext_destroy() by freeing the extent records from
>> the indirection array directly in this case.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
> 
> FWIW, it is best to title a resend as [PATCH x/y, V2], and here tell
> us what changed between posts such as:
> 
> V2:
> - fixed typo in original posting

Ok. :)

Thanks,
-Jeff

> 
>>  fs/xfs/xfs_inode_fork.c |    7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
>> index 02f1083..ba70f98 100644
>> --- a/fs/xfs/xfs_inode_fork.c
>> +++ b/fs/xfs/xfs_inode_fork.c
>> @@ -1525,9 +1525,12 @@ xfs_iext_destroy(
>>  		int	nlists;
>>  
>>  		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
>> -		for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
>> -			xfs_iext_irec_remove(ifp, erp_idx);
>> +		for (erp_idx = 0; erp_idx < nlists; erp_idx++) {
>> +			xfs_ext_irec_t	*erp = &ifp->if_u1.if_ext_irec[erp_idx];
>> +			if (erp->er_extbuf)
>> +				kmem_free(erp->er_extbuf);
>>  		}
>> +		kmem_free(ifp->if_u1.if_ext_irec);
> 
> 
> The code looks correct...
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
