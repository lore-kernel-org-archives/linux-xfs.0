Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B1B87F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 13:21:30 -0500 (CDT)
Subject: [PATCH V2] xfsrestore: fix 2GB directory dump limitation for
	multi-stream
From: Rich Johnston <rjohnston@sgi.com>
Message-Id: <20150902182126.AB280607C89BB@gulag1.americas.sgi.com>
Date: Wed,  2 Sep 2015 13:21:26 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In reply to: <20150902132117.GC23587@bfoster.bfoster>
References: <20150827185445.6E13960EDE2F0@gulag1.americas.sgi.com>

On 09/02/2015 08:21 AM, Brian Foster wrote:
> On Thu, Aug 27, 2015 at 01:54:45PM -0500, Rich Johnston wrote:
>>
>> The drive_simple restore path has a 2GB directory limit. Instead of
>> ASSERTing if nreadneeded64 is greater than INTGENMAX (2GB), add a loop
>> to handle it.
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>> ---
> 
> I'm not a huge fan of all the spaces used in this code (around the
> braces and whatnot). It is consistent with the rest of the code but I'd
> probably get away from that as code is modified.
> 
> That aside, the change seems fine to me:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
...

Thanks for the review Brian and I agree with you about the spaces.
I was just matching the current style. I have removed them. 

********************* Begin Patch*******************************
The drive_simple restore path has a 2GB directory limit. Instead of
ASSERTing if nreadneeded64 is greater than INTGENMAX (2GB), add a loop
to handle it.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
Changelog:
V2 remove extra spaces around braces

 common/drive_simple.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: b/common/drive_simple.c
===================================================================
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -765,18 +765,20 @@ do_seek_mark( drive_t *drivep, drive_mar
 	/* use read_buf util func to eat up difference
 	 */
 	nreadneeded64 = mark - strmoff;
-	ASSERT( nreadneeded64 <= INTGENMAX );
-	nreadneeded = ( intgen_t )nreadneeded64;
-	nread = read_buf( 0,
-			  ( size_t )nreadneeded,
-			  ( void * )drivep,
-			  ( rfp_t )drivep->d_opsp->do_read,
-			  ( rrbfp_t )drivep->d_opsp->do_return_read_buf,
-			  &rval );
-	if  ( rval ) {
-		return rval;
+	while (nreadneeded64 > 0) {
+		if (nreadneeded64 > INTGENMAX)
+			nreadneeded = INTGENMAX;
+		else
+			nreadneeded = (intgen_t)nreadneeded64;
+		nread = read_buf(0, nreadneeded, drivep,
+				  (rfp_t)drivep->d_opsp->do_read,
+				(rrbfp_t)drivep->d_opsp->do_return_read_buf,
+				  &rval );
+		if  (rval) {
+			return rval;
+		}
+		nreadneeded64 -= nread;
 	}
-	ASSERT( nread == nreadneeded );
 
 	/* verify we are on the mark
 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
