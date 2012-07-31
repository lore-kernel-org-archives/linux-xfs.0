Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V88jiI159295 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 03:08:45 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id A87uSR5vGF6EPJBI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 01:08:44 -0700 (PDT)
Message-ID: <50179282.9000300@oracle.com>
Date: Tue, 31 Jul 2012 16:08:34 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 4/4]xfs: xfs_seek_hole() refinements with lookup hole
	offset from page cache.
References: <50110636.2010602@oracle.com> <20120731001322.GN2877@dastard>
In-Reply-To: <20120731001322.GN2877@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7782120384210952446=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============7782120384210952446==
Content-Type: multipart/alternative;
 boundary="------------060608010604070609050903"

This is a multi-part message in MIME format.
--------------060608010604070609050903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 07/31/12 08:13, Dave Chinner wrote:
> On Thu, Jul 26, 2012 at 04:56:22PM +0800, Jeff Liu wrote:
>> Search possbile hole offset for given range from page cache for unwritten and delayed-allocation extents.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>>
>> ---
>>   fs/xfs/xfs_file.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++------
>>   1 files changed, 80 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 15acd4d..1b83549 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1296,9 +1296,9 @@ xfs_seek_hole(
>>   	struct xfs_inode	*ip = XFS_I(inode);
>>   	struct xfs_mount	*mp = ip->i_mount;
>>   	loff_t			uninitialized_var(offset);
>> -	loff_t			holeoff;
>>   	xfs_fsize_t		isize;
>>   	xfs_fileoff_t		fsbno;
>> +	xfs_filblks_t		end;
>>   	uint			lock;
>>   	int			error;
>>   
>> @@ -1314,20 +1314,90 @@ xfs_seek_hole(
>>   	}
>>   
>>   	fsbno = XFS_B_TO_FSBT(mp, start);
>> -	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
>> -	if (error)
>> -		goto out_unlock;
>> +	end = XFS_B_TO_FSB(mp, isize);
>> +
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>> +
>> +		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
>> +				       XFS_BMAPI_ENTIRE);
>> +		if (error)
>> +			goto out_unlock;
>> +
>> +		/* No extents at given offset, must be beyond EOF */
>> +		if (nmap == 0) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
>>   
>> -	holeoff = XFS_FSB_TO_B(mp, fsbno);
>> -	if (holeoff <= start)
>>   		offset = start;
>> -	else {
>> +		/* Landed in a hole, return */
>> +		if (map[0].br_startblock == HOLESTARTBLOCK)
>> +			break;
>> +		else {
>> +			/*
>> +			 * Landed in an unwritten extent, try to lookup page
>> +			 * cache to find holes.
>> +			 */
> Laned in a data extent is more correct here.
>
>> +			if (map[0].br_state == XFS_EXT_UNWRITTEN ||
>> +			    isnullstartblock(map[0].br_startblock)) {
>> +				/* Probing page cache start from offset */
>> +				if (xfs_find_get_desired_pgoff(inode, &map[0],
>> +							HOLE_OFF, &offset))
>> +					break;
>> +			}
> Same logic changes as previous patch:
>
> 		if (map[0].br_startblock == HOLESTARTBLOCK)
> 			break;
> 		else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
> 			ASSERT(!isnullstartblock(map[0].br_startblock));
>
> 			/* Probing page cache start from offset */
> 			if (xfs_find_get_desired_pgoff(inode, &map[0],
> 						HOLE_OFF, &offset))
> 				break;
> 		} else {
> 			.....
>
>>   		/*
>> -		 * xfs_bmap_first_unused() could return a value bigger than
>> -		 * isize if there are no more holes past the supplied offset.
>> +		 * Both mappings contains data, proceed to the next round of
>> +		 * search if the current reading offset not beyond or hit EOF.
>>   		 */
>> -		offset = min_t(loff_t, holeoff, isize);
>> +		fsbno = map[1].br_startoff + map[1].br_blockcount;
>> +		start = XFS_FSB_TO_B(mp, fsbno);
>> +		if (start >= isize) {
>> +			offset = isize;
>> +			break;
>> +		}
> And that check can move to the start of the loop, too.
Thanks for a comprehensive review, I'll fix them according to your comments.

Thanks,
-Jeff
//
>
> Cheers,
>
> Dave.


--------------060608010604070609050903
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <div class="moz-cite-prefix">On 07/31/12 08:13, Dave Chinner wrote:<br>
    </div>
    <blockquote cite="mid:20120731001322.GN2877@dastard" type="cite">
      <pre wrap="">On Thu, Jul 26, 2012 at 04:56:22PM +0800, Jeff Liu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Search possbile hole offset for given range from page cache for unwritten and delayed-allocation extents.

Signed-off-by: Jie Liu <a class="moz-txt-link-rfc2396E" href="mailto:jeff.liu@oracle.com">&lt;jeff.liu@oracle.com&gt;</a>
Reviewed-by: Mark Tinguely <a class="moz-txt-link-rfc2396E" href="mailto:tinguely@sgi.com">&lt;tinguely@sgi.com&gt;</a>
Reviewed-by: Christoph Hellwig <a class="moz-txt-link-rfc2396E" href="mailto:hch@lst.de">&lt;hch@lst.de&gt;</a>
Reviewed-by: Dave Chinner <a class="moz-txt-link-rfc2396E" href="mailto:dchinner@redhat.com">&lt;dchinner@redhat.com&gt;</a>

---
 fs/xfs/xfs_file.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 15acd4d..1b83549 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1296,9 +1296,9 @@ xfs_seek_hole(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip-&gt;i_mount;
 	loff_t			uninitialized_var(offset);
-	loff_t			holeoff;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		end;
 	uint			lock;
 	int			error;
 
@@ -1314,20 +1314,90 @@ xfs_seek_hole(
 	}
 
 	fsbno = XFS_B_TO_FSBT(mp, start);
-	error = xfs_bmap_first_unused(NULL, ip, 1, &amp;fsbno, XFS_DATA_FORK);
-	if (error)
-		goto out_unlock;
+	end = XFS_B_TO_FSB(mp, isize);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+
+		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &amp;nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
+			error = ENXIO;
+			goto out_unlock;
+		}
 
-	holeoff = XFS_FSB_TO_B(mp, fsbno);
-	if (holeoff &lt;= start)
 		offset = start;
-	else {
+		/* Landed in a hole, return */
+		if (map[0].br_startblock == HOLESTARTBLOCK)
+			break;
+		else {
+			/*
+			 * Landed in an unwritten extent, try to lookup page
+			 * cache to find holes.
+			 */
</pre>
      </blockquote>
      <pre wrap="">
Laned in a data extent is more correct here.

</pre>
      <blockquote type="cite">
        <pre wrap="">+			if (map[0].br_state == XFS_EXT_UNWRITTEN ||
+			    isnullstartblock(map[0].br_startblock)) {
+				/* Probing page cache start from offset */
+				if (xfs_find_get_desired_pgoff(inode, &amp;map[0],
+							HOLE_OFF, &amp;offset))
+					break;
+			}
</pre>
      </blockquote>
      <pre wrap="">
Same logic changes as previous patch:

		if (map[0].br_startblock == HOLESTARTBLOCK)
			break;
		else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
			ASSERT(!isnullstartblock(map[0].br_startblock));

			/* Probing page cache start from offset */
			if (xfs_find_get_desired_pgoff(inode, &amp;map[0],
						HOLE_OFF, &amp;offset))
				break;
		} else {
			.....

</pre>
      <blockquote type="cite">
        <pre wrap=""> 		/*
-		 * xfs_bmap_first_unused() could return a value bigger than
-		 * isize if there are no more holes past the supplied offset.
+		 * Both mappings contains data, proceed to the next round of
+		 * search if the current reading offset not beyond or hit EOF.
 		 */
-		offset = min_t(loff_t, holeoff, isize);
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start &gt;= isize) {
+			offset = isize;
+			break;
+		}
</pre>
      </blockquote>
      <pre wrap="">
And that check can move to the start of the loop, too.</pre>
    </blockquote>
    Thanks for a comprehensive review, I'll fix them according to your
    comments.<br>
    <br>
    Thanks,<br>
    -Jeff<br>
    <span class="st"><em></em></span>
    <blockquote cite="mid:20120731001322.GN2877@dastard" type="cite">
      <pre wrap="">

Cheers,

Dave.
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------060608010604070609050903--


--===============7782120384210952446==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7782120384210952446==--
