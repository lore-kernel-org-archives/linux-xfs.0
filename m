Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D6697F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 01:27:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C901304048
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 23:27:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nEoUQDXlNIguAg6W (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 23:27:44 -0700 (PDT)
Message-ID: <514AA856.8040107@oracle.com>
Date: Thu, 21 Mar 2013 14:27:34 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: get new buffer for secondary superblocks from the
	first new AG
References: <514A88C3.2030204@oracle.com> <20130321054428.GN17758@dastard>
In-Reply-To: <20130321054428.GN17758@dastard>
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

On 03/21/2013 01:44 PM, Dave Chinner wrote:
> On Thu, Mar 21, 2013 at 12:12:51PM +0800, Jeff Liu wrote:
>> In growfs operation, the unused parts of superblocks in the latest old AG are
>> zero filled, hence we can safely read the secondary superblock buffer of it
>> rather than getting a new buffer for it again.
> 
> From the code:
> 
> 	oagcount = mp->m_sb.sb_agcount;
> 
> And because the AG indexes are zero numbered, the index of the
> last original AGs is (oagcount - 1). Hence we shoul donly be reading
> from the AG headers if the current AG index is less than oagcount.
> 
>> This is a small refinement for commits 1375cb65.
>>
>> Cc: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_fsops.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
>> index 94eaeed..7d435dd 100644
>> --- a/fs/xfs/xfs_fsops.c
>> +++ b/fs/xfs/xfs_fsops.c
>> @@ -449,7 +449,7 @@ xfs_growfs_data_private(
>>  		 * disk as the contents of the new area we are growing into is
>>  		 * completely unknown.
>>  		 */
>> -		if (agno < oagcount) {
>> +		if (agno <= oagcount) {
> 
> With this change, when agno == oagcount we are one AG beyond the
> original filesystem size and so if we read that space, we are
> reading uninitialised data.
> 
> AFAICT, the current code is correct...
Oops, I made a stupid mistake.  The index of the
last original AGs is (oagcount - 1) rather than oagcount...

Sorry for the noise!

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
