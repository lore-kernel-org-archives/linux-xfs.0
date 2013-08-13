Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB83B7F74
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 13:34:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C47D4304032
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 11:34:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Nc27Rqytb9btqRTP for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 11:34:27 -0700 (PDT)
Message-ID: <520A7C31.2050802@sandeen.net>
Date: Tue, 13 Aug 2013 13:34:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: linux-next: Tree for Aug 13 (xfs)
References: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au>
	<520A6607.7060002@infradead.org>
In-Reply-To: <520A6607.7060002@infradead.org>
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
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 8/13/13 11:59 AM, Randy Dunlap wrote:
> On 08/13/13 01:28, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130812:
>>
> 
> on i386:
> 
> fs/built-in.o: In function `xfs_log_calc_minimum_size':
> (.text+0x1797a9): undefined reference to `__udivdi3'
> 
> 

See:

[PATCH] xfs: call roundup_64() to calculate the min_logblks

on the xfs list:

From: Jie Liu <jeff.liu@oracle.com>

Replace roundup() with roundup_64() as we calculate min_logblks
with 64-bit divisions.  Hence, call roundup() will cause the
following error while compiling a 32-bit kernel:

fs/built-in.o: In function `xfs_log_calc_minimum_size':
fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_rlimit.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index 6b17ef4..bbcec0b 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -136,10 +136,12 @@ xfs_log_calc_minimum_size(
 	 * Also, the log size should be a multiple of the log stripe unit, round
 	 * it up to lsunit boundary if lsunit is specified.
 	 */
-	if (lsunit)
-		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
-	else
+	if (lsunit) {
+		min_logblks = roundup_64(BTOBB(max_logres), lsunit) +
+			      2 * lsunit;
+	} else
 		min_logblks = BTOBB(max_logres) + 2 * BBSIZE;
 	min_logblks *= XFS_MIN_LOG_FACTOR;
+
 	return XFS_BB_TO_FSB(mp, min_logblks);
 }
-- 

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
