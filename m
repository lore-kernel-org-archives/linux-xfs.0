Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D20A87F3F
	for <xfs@oss.sgi.com>; Sat,  7 Jun 2014 21:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6673FAC006
	for <xfs@oss.sgi.com>; Sat,  7 Jun 2014 19:57:40 -0700 (PDT)
Received: from mail-yk0-f172.google.com (mail-yk0-f172.google.com
	[209.85.160.172]) by cuda.sgi.com with ESMTP id
	yyL9jOz3Q0y5Tcek (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Jun 2014 19:57:37 -0700 (PDT)
Received: by mail-yk0-f172.google.com with SMTP id 79so1603369ykr.31
	for <xfs@oss.sgi.com>; Sat, 07 Jun 2014 19:57:36 -0700 (PDT)
Message-ID: <5393D11E.2090906@gmail.com>
Date: Sat, 07 Jun 2014 22:57:34 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
	rwsem_is_locked
References: <5390D7E1.7060606@gatech.edu> <5391FFFD.1060901@gatech.edu>
	<53920446.7060505@gatech.edu> <20140607001819.GE4453@dastard>
	<53926406.4020200@gmail.com> <53926DC1.4050304@gmail.com>
	<1402108770.25112.5.camel@joe-AO725>
	<20140607234411.GA9508@dastard>
In-Reply-To: <20140607234411.GA9508@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Joe Perches <joe@perches.com>
Cc: peterz@infradead.org, Pranith Kumar <pranith@gatech.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mingo@redhat.com, davidlohr@hp.com, tim.c.chen@linux.intel.com

On 06/07/2014 07:44 PM, Dave Chinner wrote:
> On Fri, Jun 06, 2014 at 07:39:30PM -0700, Joe Perches wrote:
>> On Fri, 2014-06-06 at 21:41 -0400, Pranith Kumar wrote:
>>> On 06/06/2014 08:59 PM, Pranith Kumar wrote:
>>>> On 06/06/2014 08:18 PM, Dave Chinner wrote:
>>>>> If you are going to change the return type to bool, then you should
>>>>> also remove the manual "!!" conversions to a boolean return and let
>>>>> the compiler do it in the most optimal way.
>> simpler still would be just removing the !! completely.
>> I presume in no case would it make an actual difference
>> in emitted code.
>>
>> ie:
>> 			return ip->i_lock.mr_writer;
> 
> Yup, that's exactly what I meant. Casting to a bool type does all
> the work of squashing all non-zero values to 1...
> 

change return type if xfs_isilocked() to bool to follow rwsem_is_locked()

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 fs/xfs/xfs_inode.c | 8 ++++----
 fs/xfs/xfs_inode.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a6115fe..c02ac49 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -285,25 +285,25 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+bool
 xfs_isilocked(
 	xfs_inode_t		*ip,
 	uint			lock_flags)
 {
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
 		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
+			return ip->i_lock.mr_writer;
 		return rwsem_is_locked(&ip->i_lock.mr_lock);
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
 		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !!ip->i_iolock.mr_writer;
+			return ip->i_iolock.mr_writer;
 		return rwsem_is_locked(&ip->i_iolock.mr_lock);
 	}
 
 	ASSERT(0);
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index f72bffa..efebed6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -346,7 +346,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
