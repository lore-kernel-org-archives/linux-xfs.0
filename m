Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D4A67F50
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 17:58:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0660830407F
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:58:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D4I61WOfVllCa1mk for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 15:58:19 -0700 (PDT)
Message-ID: <53487383.6040001@draigBrady.com>
Date: Fri, 11 Apr 2014 23:58:11 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: Strange hole creation behavior
References: <534822D7.7090803@draigBrady.com>
	<20140411204338.GA38024@bfoster.bfoster>
In-Reply-To: <20140411204338.GA38024@bfoster.bfoster>
Content-Type: multipart/mixed; boundary="------------050606000501010005080301"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Coreutils <coreutils@gnu.org>, =?UTF-8?B?T25kxZllaiBWYcWhw61r?= <ovasik@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------050606000501010005080301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/11/2014 09:43 PM, Brian Foster wrote:
> On Fri, Apr 11, 2014 at 06:13:59PM +0100, Pádraig Brady wrote:
>> So this coreutils test is failing on XFS:
>> http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=blob;f=tests/dd/sparse.sh;h=06efc7017
>> Specifically the last hole check on line 66.
>>
>> In summary what's happening is that a write(1MiB), lseek(1MiB), write(1MiB)
>> creates only a 64KiB hole. Is that expected?
>>
> 
> This is expected behavior due to speculative preallocation. An FAQ with
> regard to this behavior is pending, but see here for reference:
> 
> http://oss.sgi.com/archives/xfs/2014-04/msg00083.html
> 
> In that particular write(1MB), lseek(+1MB), write(1MB) workload, each
> write is preallocating some extra space beyond the current EOF. The seek
> then moves past that space, but the space doesn't go away. The
> subsequent writes will extend EOF. The previously preallocated space now
> resides in the middle of the file and can't be trimmed away when the
> file is closed.
> 
>> Now a 1MiB hole is supported using truncate:
>>   dd if=/dev/urandom of=file.in bs=1M count=1 iflag=fullblock
>>   truncate -s+1M file.in
>>   dd if=/dev/urandom of=file.in bs=1M count=1 iflag=fullblock conv=notrunc oflag=append
>>   $ du -k file.in
>>   2048  file.in
>>
> 
> This works simply because it is broken into multiple commands. When the
> first dd exits, the excess space is trimmed off (the file descriptor is
> closed). The subsequent truncate extends the file size without any
> extra space getting caught between the old and new EOF.
> 
> You can confirm this by using the 'allocsize=4k' mount option to the XFS
> mount. If you wanted something more generic for the purpose of testing
> the coreutils functionality, you could also set the size of file.out in
> advance. E.g., with preallocation in effect:
> 
> # dd if=file.in of=file.out bs=1M conv=sparse
> # xfs_bmap -v file.out 
> file.out:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..3967]:       9773944..9777911  1 (9080..13047)     3968
>    1: [3968..4095]:    hole                                   128
>    2: [4096..6143]:    9778040..9780087  1 (13176..15223)    2048
> 
> ... and then prevent preallocation by ensuring writes do not extend the
> file:
> 
> # rm -f file.out 
> # truncate --size=3M file.out
> # dd if=file.in of=file.out bs=1M conv=sparse,notrunc
> # xfs_bmap -v file.out 
> file.out:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
>    0: [0..2047]:       9773944..9775991  1 (9080..11127)     2048
>    1: [2048..4095]:    hole                                  2048
>    2: [4096..6143]:    9778040..9780087  1 (13176..15223)    2048
> 
> Hope that helps.

Excellent info thanks.
With that I can adjust the test so it passes (patch attached).

So for reference this means that cp can no longer recreate holes
<= 1MiB from source to dest (with the default XFS allocation size):

$ cp --sparse=always file.in cp.out
$ xfs_bmap -v !$
xfs_bmap -v cp.out
cp.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..3967]:       219104..223071    0 (219104..223071)  3968
   1: [3968..4095]:    hole                                   128
   2: [4096..6143]:    225720..227767    0 (225720..227767)  2048

$ xfs_bmap -v file.out
file.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       229816..231863    0 (229816..231863)  2048
   1: [2048..4095]:    hole                                  2048
   2: [4096..6143]:    233912..235959    0 (233912..235959)  2048

$ cp file.out cp.out
$ xfs_bmap -v cp.out
cp.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..3967]:       250296..254263    0 (250296..254263)  3968
   1: [3968..4095]:    hole                                   128
   2: [4096..6143]:    254392..256439    0 (254392..256439)  2048

Though if we bump up the hole size the representation is better:

$ dd if=/dev/urandom of=bigfile.in bs=1M count=1 iflag=fullblock
$ truncate -s+10M bigfile.in
$ dd if=/dev/urandom of=bigfile.in bs=1M count=1 iflag=fullblock conv=notrunc oflag=append

$ xfs_bmap -v bigfile.in
bigfile.in:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       231864..233911    0 (231864..233911)  2048
   1: [2048..22527]:   hole                                 20480
   2: [22528..24575]:  256440..258487    0 (256440..258487)  2048

$ cp bigfile.in bigfile.out
$ xfs_bmap -v bigfile.out
bigfile.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..3967]:       260408..264375    0 (260408..264375)  3968
   1: [3968..22527]:   hole                                 18560
   2: [22528..24575]:  264376..266423    0 (264376..266423)  2048

We could I suppose use FALLOC_FL_PUNCH_HOLE where available
to cater for this case. I'll see whether this is worth adding.
That can be used after the fact anyway:

$ fallocate --dig-holes bigfile.out
$ xfs_bmap -v bigfile.out
bigfile.out:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..2047]:       260408..262455    0 (260408..262455)  2048
   1: [2048..22527]:   hole                                 20480
   2: [22528..24575]:  264376..266423    0 (264376..266423)  2048

thanks,
Pádraig.

--------------050606000501010005080301
Content-Type: text/x-patch;
 name="dd-sparse-xfs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dd-sparse-xfs.patch"

>From 7c03fe2c9f498bad7e40d29f2eb4573d23e102d0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
Date: Fri, 11 Apr 2014 23:44:13 +0100
Subject: [PATCH] tests: fix false dd conv=sparse failure on newer XFS

* tests/dd/sparse.sh: When testing that a hole is created,
use an existing sparse destination file, so that we're
not write extending the file size, and thus avoiding
speculative preallocation which can result in smaller
holes than requested.
Workaround suggested by Brian Foster
---
 THANKS.in          |    1 +
 tests/dd/sparse.sh |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/THANKS.in b/THANKS.in
index e7298ef..a92540a 100644
--- a/THANKS.in
+++ b/THANKS.in
@@ -95,6 +95,7 @@ Bjorn Helgaas                       helgaas@rsn.hp.com
 Bob McCracken                       kerouac@ravenet.com
 Branden Robinson                    branden@necrotic.deadbeast.net
 Brendan O'Dea                       bod@compusol.com.au
+Brian Foster                        bfoster@redhat.com
 Brian Kimball                       bfk@footbag.org
 Brian M. Carlson                    sandals@crustytoothpaste.ath.cx
 Brian Silverman                     bsilverman@conceptxdesign.com
diff --git a/tests/dd/sparse.sh b/tests/dd/sparse.sh
index 06efc70..a7e90d2 100755
--- a/tests/dd/sparse.sh
+++ b/tests/dd/sparse.sh
@@ -61,8 +61,15 @@ if test $(kb_alloc file.in) -gt 3000; then
   dd if=file.in of=file.out bs=2M conv=sparse
   test 2500 -lt $(kb_alloc file.out) || fail=1
 
+  # Note we recreate a sparse file first to avoid
+  # speculative preallocation seen in XFS, where a write() that
+  # extends a file can preallocate some extra space that
+  # a subsequent seek will not convert to a hole.
+  rm -f file.out
+  truncate --size=3M file.out
+
   # Ensure that this 1MiB string of NULs *is* converted to a hole.
-  dd if=file.in of=file.out bs=1M conv=sparse
+  dd if=file.in of=file.out bs=1M conv=sparse,notrunc
   test $(kb_alloc file.out) -lt 2500 || fail=1
 
 fi
-- 
1.7.7.6


--------------050606000501010005080301
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------050606000501010005080301--
