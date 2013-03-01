Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FE807FD3
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 14:23:29 -0600 (CST)
Message-ID: <51310E40.7070008@sgi.com>
Date: Fri, 1 Mar 2013 14:23:28 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/10] xfstests: Stress tests improments v5
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

Committed patches 1-3 and 5-8.

Waiting for responses back on patches 4, 9, and 10.

Thanks
--Rich

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> 1   add fio requirement V2
> 2   add configurable load factors
> 3   hardcode fops for determinable fsstests runs
> 4   fsstress add replace file operation
> 5   allow fsstress to use load factor where appropriate
> 6   move run_check to common.rc
> 7   add  fallocate/truncate vs AIO/DIO stress test
> 8   add  fallocate/punch_hole vs AIO/DIO stress test
> 9   add defragmentation stress tests for ext4
> 10  add disk failure simulation test
>


commit 892125a53aac8e82dec99fe4e824c39513d4a17a
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:13 2013 +0000

     xfstest: add fallocate/punch_hole vs AIO/DIO stress test

     Run random AIO/DIO activity (fio's job:direct_aio_raicer)
     random fallocate activity(fio's job:falloc_raicer)
     and random punch_hole activity(punch_hole_raicer) on a common
     file in parallel. If a race exists, old dio request may rewrite
     punched block after it was allocated to another file, we will
     catch that by verifier fio's job: "aio-dio-verifier".

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit 0f88dc26abf55cee39ede490da08ed0d2960cdb2
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:12 2013 +0000

     xfstest: add fallocate/truncate vs AIO/DIO stress test

     Run DIO, fallocate and truncate threads on a common file in parallel.
     If a race exists, the old dio request may rewrite blocks after it was
     allocated to another file, we will catch that by verifying blocks 
content.

     this patch known to catch deadlock for ext4
     http://lists.openwall.net/linux-ext4/2012/09/06/3

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit bb949015a8d3fcf4a5c105b1edd74f27b848a806
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:11 2013 +0000

     xfstest: move run_check to common.rc

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     Move run_check to common.rc.
commit b84aade2f49f309c44e6c0b029586c9dcb7b1c22
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:10 2013 +0000

     xfstest: allow fsstress to use load factor where appropriate

     1) Add _scale_fsstress_args function which transform arguments 
according
        to load factors
     2) Let all non deterministic fsstress tests to use scaled arguments

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit d14981fa536ac0106dbe9b3d5088a5a50be49f55
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:08 2013 +0000

     xfstests: hardcode fops for determinable fsstests runs

     106,107 and 117 are frozen tests which use known seed, it is
     reasonable to explicitly hardcode file operations in order to avoid
     implicit changes caused by future changes in fsstress.

     NOTE: options generated like follows: fsstress -S c $ORIG_ARGS

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit 66a98478e3cffecfbd62d3a124b626ddda447c57
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:07 2013 +0000

     xfstest: add configurable load factors

     Most stress test has probable behavior, the longer test run the
     larger corner cases will be cover. It is reasonable to allow
     user to provide some sort of system load factor.
     This patch introduce two global variables
     LOAD_FACTOR: Usually means factor number of running tasks
     TIME_FACTOR: Usually means factor of run time, or number of operations
     If not specified both variables defined to 1, so original behavior
     preserved.
     TODO: Change all stress tests to use this variables

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

commit b3db6021fc2df4e99c9e098612446f4c86e70766
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Wed Feb 20 10:42:06 2013 +0000

     xfstests: add fio requirement V2

     FIO is very flexible io generator, I would call it IO swiss knife.
     Currently we have tons of hardcoded application which reproduces
     some predefined scenario. This approach has obvious disadvantages
     1) Lack of flexibility: one written it is hard to modify it in future
     2) Code base is large, many routines written again and again

     At the same time add new fio based test, just add simple INI file.
     This greatly simplifies code review. I do believe that some day we will
     replace most of hardcoded io binaries with fio.

     One who is planning to run $FIO_PROG should first check that system
     contains appropriate version which is able to handle jobfile
     for example:  _require_fio 286-job.fio

     Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
