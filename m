Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 24F407FB6
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 01:09:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 021248F808F
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 23:09:27 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 41JoU8fWc5D6O6G0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 23:09:26 -0700 (PDT)
Message-ID: <53DB2F08.2090703@oracle.com>
Date: Fri, 01 Aug 2014 14:09:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/10] xfs_ioc_bulkstat code refactoring and
	consolidation
References: <538D92B6.5050402@oracle.com> <20140729232748.GI26465@dastard>
	<53D9F67F.9060609@oracle.com>
In-Reply-To: <53D9F67F.9060609@oracle.com>
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


On 07/31/2014 15:55 PM, Jeff Liu wrote:
> Hi Dave,
> 
> On 07/30/2014 07:27 AM, Dave Chinner wrote:
>> On Tue, Jun 03, 2014 at 05:17:42PM +0800, Jeff Liu wrote:
>>> Hi folk,
>>>
>>> This is the revised patches for xfs_ioc_bulkstat consolidation and code
>>> refactoring. As per Christoph's comments, I'm not include the per AG
>>> inumber patch in this series given that I don't actually introduce the
>>> relevant inumbers interface now. Similar to that reason, I also dropped
>>> the per AG bulkstat patch, it would be included in parallel quota check
>>> series.
>>>
>>>
>>> v3->v2:
>>> - one major bug fix is at xfs_bulkstat_ag_ichunk() regarding the user buffer
>>>   pointer operations, it should be defined as a pointer-to-pointer since it
>>>   would be updated inside xfs_bulkstat_ag_ichunk().
>>>
>>> - separate xfs_inumber consolidate patch into two patches, the first one
>>>   fix the formater function return value and consolidate the codes, another
>>>   one does the actual logic changes for better error handling.
>>>
>>> - Add a separate patch to get rid of the redundant user buffer count
>>>   checks at xfs_bulkstat()
>>>
>>> - fixed agino calculation issue at xfs_bulkstat_grab_ichunk().
>>>
>>> v2: http://oss.sgi.com/archives/xfs/2014-04/msg00554.html
>>> v1: http://oss.sgi.com/archives/xfs/2013-12/msg00901.html
>>>
>>>
>>> Any comments are welcome!
>>
>> Hi Jeff, I ported this to the current dev tree based on the
>> xfs-libxfs-restructure branch, and I keep seeing fsstress failing
>> with memory corruption after random bulkstat ioctls. I see regular
>> failures with generic/013, generic/068, xfs/167 and the other
>> fstress tests also randomly fail. The typical failure is glibc
>> detected memory heap corruption on freeing the bulkstat structure
>> after the ioctl:
>>
>> generic/068 42s ...*** Error in `./ltp/fsstress': double free or corruption (!prev): 0x00007f0224000b70 ***
>> ======= Backtrace: =========
> 
> Sorry for my late response and thanks for help porting this patch series.
> 
> Now I can reproduce this issue frequently with generic/013, will try to fix
> it ASAP.

Hi Dave,

Could you please check the patch below for this issue?


From: Jie Liu <jeff.liu@oracle.com>
Subject: xfs: always updating acp elements at xfs_bulkstat_ag_ichunk

After processing the inodes in chunk, we should always updating the
last inode number and the left user buffer info no matter anything
wrong while formatting an inode to the user buffer. Otherwise, the
related info might be updated improperly at xfs_bulkstat() for the
next round of inode processing.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_itable.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 9959a05..f71be9c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -328,11 +328,9 @@ xfs_bulkstat_ag_ichunk(
 		lastino = ino;
 	}
 
-	if (!error) {
-		acp->ac_lastino = lastino;
-		acp->ac_ubleft = ubleft;
-		acp->ac_ubelem = ubelem;
-	}
+	acp->ac_lastino = lastino;
+	acp->ac_ubleft = ubleft;
+	acp->ac_ubelem = ubelem;
 
 	return error;
 }
-- 
1.8.3.2



Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
