Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALE1UwO050024 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 08:01:30 -0600
Message-Id: <20121121135210.840563563@sgi.com>
Date: Wed, 21 Nov 2012 07:51:24 -0600
From: rjohnston@sgi.com
Subject: [PATCH] xfstests: fix to build src/realpath and the correct the
	existence of target devices
References: <20121121135123.092349449@sgi.com>
Content-Disposition: inline;
	filename=xfstests-fix-to-build-src-realpath-and-the-correct-the-existence-of-target-devices.patch
	target devices
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, Eric Sandeen <sandeen@sandeen.net>

Hi Rich, Eric

(2012/10/27 1:46), Rich Johnston wrote:
> On 06/08/2010 03:03 PM, Eric Sandeen wrote:
>> If you try running xfstests on lvm volumes which are symlinks,
>> it'll fail to run several tests because our _require_scratch
>> framework ultimately uses lstat not stat, and does not think
>> the lvm device (which is usually a symlink to a dm-X device)
>> is a block device.  Sigh.
>>
>> Last try at this - just resolve any symlinked devicenames
>> into their realpath(3) in common.config.
>>
>> This actually seems to work.
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>
>> ---
>>
>>
>> diff --git a/common.config b/common.config
>> index 926846b..e5b2483 100644
>> --- a/common.config
>> +++ b/common.config
> 
> Looks good
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> Eric,
> 
> This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, master branch, commit ID d5ea873f.

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Commit d5ea873f is not the same as the the following original Eric's patch.

http://oss.sgi.com/archives/xfs/2010-06/msg00080.html

It does not modify src/Makefile and realpath is never compiled.

In addition, `[ -L $TEST_DEV ]' and `[ -L $SCRATCH_DEV ]' always returns 0
if $TEST_DEV or $SCRATCH_DEV are not defined.

Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
common.config |    4 ++--
 common.config |    4 ++--
 src/Makefile  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/common.config
===================================================================
--- a/common.config
+++ b/common.config
@@ -221,11 +221,11 @@ else
 fi
 
 # Scripts just don't deal well with symlinked devices
-if [ -L $TEST_DEV ]; then
+if [ -L "$TEST_DEV" ]; then
         TEST_DEV=`src/realpath $TEST_DEV`
 fi
 
-if [ -L $SCRATCH_DEV ]; then
+if [ -L "$SCRATCH_DEV" ]; then
         SCRATCH_DEV=`src/realpath $SCRATCH_DEV`
 fi
 
Index: b/src/Makefile
===================================================================
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,7 +11,7 @@ TARGETS = dirstress fill fill2 getpagesi
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
-	t_mmap_writev
+	t_mmap_writev realpath
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
