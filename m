Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39222 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934232AbdDST3X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 15:29:23 -0400
Subject: Re: [PATCH] xfs: remove use of do_div with 32-bit dividend in quota
 debug code
References: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
 <20170417185959.GA5193@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <615e5f75-282f-affc-fe3b-e6410dedaccf@sandeen.net>
Date: Wed, 19 Apr 2017 14:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <20170417185959.GA5193@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 4/17/17 1:59 PM, Darrick J. Wong wrote:
> On Sat, Apr 15, 2017 at 09:46:09AM -0500, Eric Sandeen wrote:
>> The kbuild test robot caught this; in debug code we have another
>> caller of do_div with a 32-bit dividend (j) which is caught now
>> that we are using the kernel-supplied do_div.
>>
>> None of the values used here are 64-bit; just use simple division.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index b669b12..dedeb7f 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -851,8 +851,7 @@ struct xfs_qm_isolate {
>>  	 * started afresh by xfs_qm_quotacheck.
>>  	 */
>>  #ifdef DEBUG
>> -	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
>> -	do_div(j, sizeof(xfs_dqblk_t));
>> +	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) / sizeof(xfs_dqblk_t);
> 
> Uh...
> 
> #define XFS_FSB_TO_B(mp,fsbno)   ((xfs_fsize_t)(fsbno) << (mp)->m_sb.sb_blocklog)
> typedef    __int64_t       xfs_fsize_t;    /* bytes in a file */

Assigned to "int j", riiiiight.  hohum.
 
> So the macro resolves to a 64-bit value, which is then fed directly into
> an integer division, which breaks the i386 build with the usual __divdi3
> complaint.

sandeen--

> --D
> 
>>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>>  #endif
>>  	dqb = bp->b_addr;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
