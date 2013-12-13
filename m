Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CAA087F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 20:44:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF9D48F8039
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 18:44:30 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id w4zgOI5FTI78Eklp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 18:44:06 -0800 (PST)
Message-ID: <52AA7470.4070103@oracle.com>
Date: Fri, 13 Dec 2013 10:44:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/8] xfs: get rid of XFS_IALLOC_BLOCKS macros
References: <52A967E9.7070508@oracle.com> <20131212220953.GF10988@dastard>
In-Reply-To: <20131212220953.GF10988@dastard>
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

On 12/13 2013 06:09, Dave Chinner wrote:
> On Thu, Dec 12, 2013 at 03:38:17PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Get rid of XFS_IALLOC_BLOCKS() marcos, use mp->m_ialloc_blks directly.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ....
>> @@ -1228,9 +1228,9 @@ xfs_difree(
>>  			goto error0;
>>  		}
>>  
>> -		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
>> -				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
>> -				XFS_IALLOC_BLOCKS(mp), flist, mp);
>> +		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
>> +				  XFS_INO_TO_AGBNO(mp, rec.ir_startino)),
>> +				  mp->m_ialloc_blks, flist, mp);
>>  	} else {
>>  		*delete = 0;
>>  
> 
> git-am fails to apply this hunk, but I'm not sure why. I updated it
> manually, the resulting patch looks identical.
Oh, I found the reason that because I failed to pull Ben's recent commits
while producing this patch set, i.e,
[ xfs: fix calculation of freed inode cluster blocks ]

So below is a quick fix.

Thanks,
-Jeff


From: Jie Liu <jeff.liu@oracle.com>

Get rid of XFS_IALLOC_BLOCKS() marcos, use mp->m_ialloc_blks directly.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_ialloc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 3ac5eb6..eacc59c 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -333,7 +333,7 @@ xfs_ialloc_ag_alloc(
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
 		return XFS_ERROR(ENOSPC);
-	args.minlen = args.maxlen = XFS_IALLOC_BLOCKS(args.mp);
+	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
 	 * chunk of inodes.  If the filesystem is striped, this will fill
@@ -343,7 +343,7 @@ xfs_ialloc_ag_alloc(
 	newino = be32_to_cpu(agi->agi_newino);
 	agno = be32_to_cpu(agi->agi_seqno);
 	args.agbno = XFS_AGINO_TO_AGBNO(args.mp, newino) +
-			XFS_IALLOC_BLOCKS(args.mp);
+		     args.mp->m_ialloc_blks;
 	if (likely(newino != NULLAGINO &&
 		  (args.agbno < be32_to_cpu(agi->agi_length)))) {
 		args.fsbno = XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
@@ -585,7 +585,7 @@ xfs_ialloc_ag_select(
 		 * Is there enough free space for the file plus a block of
 		 * inodes? (if we need to allocate some)?
 		 */
-		ineed = XFS_IALLOC_BLOCKS(mp);
+		ineed = mp->m_ialloc_blks;
 		longest = pag->pagf_longest;
 		if (!longest)
 			longest = pag->pagf_flcount > 0;
@@ -1228,9 +1228,9 @@ xfs_difree(
 			goto error0;
 		}
 
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
-				agno, XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
-				XFS_IALLOC_BLOCKS(mp), flist, mp);
+		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp, agno,
+				  XFS_AGINO_TO_AGBNO(mp, rec.ir_startino)),
+				  mp->m_ialloc_blks, flist, mp);
 	} else {
 		*delete = 0;
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
