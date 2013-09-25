Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF05E7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 02:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7E9118F804C
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 00:37:27 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id y1ACAYcVE08tDNGd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 00:37:26 -0700 (PDT)
Message-ID: <524292E3.4010902@oracle.com>
Date: Wed, 25 Sep 2013 15:38:11 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix the extent count when allocating an new
	indirection array entry
References: <523DAF67.9070206@oracle.com> <20130923002448.GL12541@dastard>
In-Reply-To: <20130923002448.GL12541@dastard>
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

On 09/23/2013 08:24 AM, Dave Chinner wrote:

> On Sat, Sep 21, 2013 at 10:38:31PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> At xfs_iext_add(), if extent(s) are being appended to the last
>> page in the indirection array and the new extent(s) don't fit
>> in the page, the number of extents(erp->er_extcount) in a new
>> allocated entry should be the minimum value between count and
>> XFS_LINEAR_EXTS, instead of count.
> 
> Definitely looks like a bug, but what are the symptoms of it and how
> did you find the problem? Is there any test case that demonstrates a
> problem with the er_extcount being set incorrectly here?

Sorry for the too late response, I found this problem while reading the code.
However, I can not figure out a test case to break the kernel until now. :(

> 
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_inode_fork.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
>> index 02f1083..dfb4226 100644
>> --- a/fs/xfs/xfs_inode_fork.c
>> +++ b/fs/xfs/xfs_inode_fork.c
>> @@ -1035,11 +1035,11 @@ xfs_iext_add(
>>  
>>  			while (count) {
>>  				erp = xfs_iext_irec_new(ifp, erp_idx);
>> -				erp->er_extcount = count;
>> -				count -= MIN(count, (int)XFS_LINEAR_EXTS);
>> -				if (count) {
>> +				erp->er_extcount = MIN(count,
>> +						       (int)XFS_LINEAR_EXTS);
>> +				count -= erp->er_extcount;
> 
> count is declared as an int, whereas XFS_LINEAR_EXTS probably ends
> up with a type of uint because of a cast in the macro. because we
> are decrementing to zero, the count can be declared as a uint, too,
> and the cast in the MIN() can go away. Indeed, MIN() should be
> converted to min() seeing as we are touching the code here, and if
> you want to retain the current types, the min_t() is appropriate,
> not min(x, (some cast)y)....

Ok, will fix it.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
