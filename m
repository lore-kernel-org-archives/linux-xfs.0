Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 330E97F37
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 03:36:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F9CC8F8033
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 01:36:42 -0800 (PST)
Message-ID: <5103A399.3040802@oracle.com>
Date: Sat, 26 Jan 2013 17:36:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 02/13] xfs: make use of xfs_calc_buf_res() in
	xfs_trans.c
References: <5101168E.7080801@oracle.com> <5101AA17.7090706@sgi.com>
	<51022401.2040703@oracle.com> <5102DB0B.6010906@sgi.com>
In-Reply-To: <5102DB0B.6010906@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 01/26/2013 03:20 AM, Mark Tinguely wrote:
> On 01/25/13 00:19, Jeff Liu wrote:
>> On 01/25/2013 05:39 AM, Mark Tinguely wrote:
>>>>  On 01/24/13 05:10, Jeff Liu wrote:
>>>>>>  Refine the existing reservations routines with xfs_calc_buf_res() in xfs_trans.c.
>>>>>>
>>>>>>  Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>>>>  ---
>>>>>>     fs/xfs/xfs_trans.c |  238 ++++++++++++++++++++++++----------------------------
>>>>>>     1 file changed, 111 insertions(+), 127 deletions(-)
>>>>>>
>>>>>>     /*
>>>>>>  @@ -148,18 +145,18 @@ xfs_calc_itruncate_reservation(
>>>>>>     	struct xfs_mount	*mp)
>>>>>>     {
>>>>>>     	return XFS_DQUOT_LOGRES(mp) +
>>>>>>  -		MAX((mp->m_sb.sb_inodesize +
>>>>>>  -		     XFS_FSB_TO_B(mp, XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1) +
>>>>>>  -		     128 * (2 + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK))),
>>>>>>  -		    (4 * mp->m_sb.sb_sectsize +
>>>>>>  -		     4 * mp->m_sb.sb_sectsize +
>>>>>>  -		     mp->m_sb.sb_sectsize +
>>>>>>  -		     XFS_ALLOCFREE_LOG_RES(mp, 4) +
>>>>>>  -		     128 * (9 + XFS_ALLOCFREE_LOG_COUNT(mp, 4)) +
>>>>>>  -		     128 * 5 +
>>>>>>  -		     XFS_ALLOCFREE_LOG_RES(mp, 1) +
>>>>>>  -		     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
>>>>>>  -			    XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
>>>>>>  +		MAX((xfs_calc_buf_res(1, mp->m_sb.sb_inodesize) +
>>>>>>  +		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1,
>>>>>>  +				      XFS_FSB_TO_B(mp, 1))),
>>>>>>  +		    (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
>>>>>>  +		     xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 4),
>>>>>>  +				      XFS_FSB_TO_B(mp, 1)) +
>>>>>>  +		    xfs_calc_buf_res(5, 0) +
>>>>>>  +		    xfs_calc_buf_res(XFS_ALLOCFREE_LOG_COUNT(mp, 1),
>>>>>>  +				     XFS_FSB_TO_B(mp, 1)) +
>>>>>>  +		    xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
>>>>>>  +				     mp->m_in_maxlevels,
>>>>>>  +				     XFS_FSB_TO_B(mp, 0))));
>>>>  					^^^^
>>>>  	I see the (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevel)
>>>>            headers in the original code, but I still don't see data.
>> XFS_FSB_TO_B(mp, 0) == 0, so it only calculates the headers out without the data part.
>>
>> But maybe it's better to replace XFS_FSB_TO_B(mp, 0) with 0 directly.
>>
> 
> 
> I did verify all the routines in the patch are the same as before. They 
> test the same too. I must have had a bad test file before - 
> XFS_FSB_TO_B(mp, 0) is obviously 0. I would prefer 0 rather than 
> XFS_FSB_TO_B(mp, 0).
> 
> Looks like the user space bits need to be refactored:
> 	http://oss.sgi.com/archives/xfs/2012-12/msg00108.html
> 	http://oss.sgi.com/archives/xfs/2012-12/msg00109.html
Sure, I'll post the user part later.

Thanks,
-Jeff
> 
> 
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
