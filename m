Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C3E8F29DFB
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 23:46:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A44A6304053
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 21:46:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id weyymTvAK5Vyi0ED (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 21:46:38 -0700 (PDT)
Message-ID: <520C5D46.2080401@oracle.com>
Date: Thu, 15 Aug 2013 12:47:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Simplify xfs_ail_min() with
	list_first_entry_or_null()
References: <520B3F8C.5020405@oracle.com> <20130814232553.GG6023@dastard>
In-Reply-To: <20130814232553.GG6023@dastard>
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

On 08/15/2013 07:25 AM, Dave Chinner wrote:

> On Wed, Aug 14, 2013 at 04:27:56PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> At xfs_ail_min(), we do check if the AIL list is empty or not before
>> returning the first item in it with list_empty() and list_first_entry().
>>
>> This can be simplified a bit with a new list operation routine that is
>> the list_first_entry_or_null() which has been introduced by:
>>
>> commit 6d7581e62f8be462440d7b22c6361f7c9fa4902b
>>     list: introduce list_first_entry_or_null
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_trans_ail.c |    5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
>> index 0eda725..e91d160 100644
>> --- a/fs/xfs/xfs_trans_ail.c
>> +++ b/fs/xfs/xfs_trans_ail.c
>> @@ -68,10 +68,7 @@ xfs_log_item_t *
>>  xfs_ail_min(
>>  	struct xfs_ail  *ailp)
>>  {
>> -	if (list_empty(&ailp->xa_ail))
>> -		return NULL;
>> -
>> -	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
>> +	return list_first_entry_or_null(&ailp->xa_ail, xfs_log_item_t, li_ail);
>>  }
> 
> At this point, it can become a static inline function in
> xfs_trans_priv.h. And while you are touching this, remove the
> typedef...

Ok, I'll take care of that.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
