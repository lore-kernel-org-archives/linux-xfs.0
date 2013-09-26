Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3A937F51
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 23:11:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73388AC004
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 21:11:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1o3kPOVsGIugCNy6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 21:11:31 -0700 (PDT)
Message-ID: <5243B420.2010307@oracle.com>
Date: Thu, 26 Sep 2013 12:12:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 RESEND] xfs: fix dead loop at xfs_vm_writepage() on
	32bit machine
References: <52429A6C.3050908@oracle.com> <20130925213224.GG26872@dastard>
In-Reply-To: <20130925213224.GG26872@dastard>
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

On 09/26/2013 05:32 AM, Dave Chinner wrote:

> On Wed, Sep 25, 2013 at 04:10:20PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Write a file with an offset greater than 16TB on 32-bit system and
>> then trigger page write-back via sync(1) as below will cause the
>> task hang in a little while:
> 
> [snip]
> 
>> This patch just fixed both issues.
>>
>> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>> v2: don't reset the s_max_bytes to MAX_LFS_FILESIZE, instead, revise the page offset
>>     check up strategy to avoid the potential overflow.
>> v1: http://oss.sgi.com/archives/xfs/2013-07/msg00154.html
>>
>>  fs/xfs/xfs_aops.c |   11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 41a6950..6059d00 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -969,7 +969,9 @@ xfs_vm_writepage(
>>  	offset = i_size_read(inode);
>>  	end_index = offset >> PAGE_CACHE_SHIFT;
>>  	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
>> -	if (page->index >= end_index) {
>> +	if (page->index < end_index)
>> +		end_offset = (xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT;
>> +	else {
>>  		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
> 
> The logic here is already difficult to understand, and the fact that
> the code that has 32 bit overflow issues is not obvious . Can you
> add a comment noting the overflow issue being handled here?
> 
>>  
>>  		/*
>> @@ -978,7 +980,8 @@ xfs_vm_writepage(
>>  		 * page so that reclaim stops reclaiming it. Otherwise
>>  		 * xfs_vm_releasepage() is called on it and gets confused.
>>  		 */
>> -		if (page->index >= end_index + 1 || offset_into_page == 0)
>> +		if (page->index > end_index ||
>> +		    (page->index == end_index && offset_into_page == 0))
>>  			goto redirty;
> 
> And again here? 
> 
> That means in future we will be aware of the problem when reading
> the code...

Fair enough, will post a new version at a latter time.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
