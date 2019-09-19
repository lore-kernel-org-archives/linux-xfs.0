Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4016C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 12:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ECE721D79
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 12:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390283AbfISM0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 08:26:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389301AbfISM0F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 08:26:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0873308404E;
        Thu, 19 Sep 2019 12:26:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A877460606;
        Thu, 19 Sep 2019 12:26:03 +0000 (UTC)
Date:   Thu, 19 Sep 2019 08:26:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: test the deadlock between the AGI and AGF
 with RENAME_WHITEOUT
Message-ID: <20190919122601.GD33863@bfoster>
References: <db6c5d87-5a47-75bd-4d24-a135e6bcd783@gmail.com>
 <20190918135947.GD29377@bfoster>
 <8941c9b8-1589-4e1f-c20b-7d128225d7f6@gmail.com>
 <20190919104750.GA33863@bfoster>
 <66aaa045-791d-6b5b-8bcb-20e96a814cad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66aaa045-791d-6b5b-8bcb-20e96a814cad@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 19 Sep 2019 12:26:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 08:14:10PM +0800, kaixuxia wrote:
> 
> 
> On 2019/9/19 18:47, Brian Foster wrote:
> > On Thu, Sep 19, 2019 at 05:08:04PM +0800, kaixuxia wrote:
> >>
> >>
> >> On 2019/9/18 21:59, Brian Foster wrote:
> >>> On Wed, Sep 18, 2019 at 07:49:22PM +0800, kaixuxia wrote:
> >>>> There is ABBA deadlock bug between the AGI and AGF when performing
> >>>> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> >>>> sure the rename() call works well.
> >>>>
> >>>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> >>>> ---
> >>>
> >>> FYI, for some reason your patch series isn't threaded on the mailing
> >>> list. I thought git send-email did this by default. Assuming you're not
> >>> explicitly using --no-thread, you might have to use the --thread option
> >>> so this gets posted as a proper series.
> >>>
> >> Yeah, thanks!
> >>>>  tests/xfs/512     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  tests/xfs/512.out |  2 ++
> >>>>  tests/xfs/group   |  1 +
> >>>>  3 files changed, 99 insertions(+)
> >>>>  create mode 100755 tests/xfs/512
> >>>>  create mode 100644 tests/xfs/512.out
> >>>>
> >>>> diff --git a/tests/xfs/512 b/tests/xfs/512
> >>>> new file mode 100755
> >>>> index 0000000..a2089f0
> >>>> --- /dev/null
> >>>> +++ b/tests/xfs/512
> >>>> @@ -0,0 +1,96 @@
> >>>> +#! /bin/bash
> >>>> +# SPDX-License-Identifier: GPL-2.0
> >>>> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> >>>> +#
> >>>> +# FS QA Test 512
> >>>> +#
> >>>> +# Test the ABBA deadlock case between the AGI and AGF When performing
> >>>> +# rename operation with RENAME_WHITEOUT flag.
> >>>> +#
> >>>> +seq=`basename $0`
> >>>> +seqres=$RESULT_DIR/$seq
> >>>> +echo "QA output created by $seq"
> >>>> +
> >>>> +here=`pwd`
> >>>> +tmp=/tmp/$$
> >>>> +status=1	# failure is the default!
> >>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >>>> +
> >>>> +_cleanup()
> >>>> +{
> >>>> +	cd /
> >>>> +	rm -f $tmp.*
> >>>> +}
> >>>> +
> >>>> +# get standard environment, filters and checks
> >>>> +. ./common/rc
> >>>> +. ./common/filter
> >>>> +. ./common/renameat2
> >>>> +
> >>>> +rm -f $seqres.full
> >>>> +
> >>>> +# real QA test starts here
> >>>> +_supported_fs xfs
> >>>> +_supported_os Linux
> >>>> +# single AG will cause default xfs_repair to fail. This test need a
> >>>> +# single AG fs, so ignore the check.
> >>>> +_require_scratch_nocheck
> >>>> +_requires_renameat2 whiteout
> >>>> +
> >>>> +filter_enospc() {
> >>>> +	sed -e '/^.*No space left on device.*/d'
> >>>> +}
> >>>> +
> >>>> +create_file()
> >>>> +{
> >>>> +	local target_dir=$1
> >>>> +	local files_count=$2
> >>>> +
> >>>> +	for i in $(seq 1 $files_count); do
> >>>> +		echo > $target_dir/f$i >/dev/null 2>&1 | filter_enospc
> >>>> +	done
> >>>> +}
> >>>> +
> >>>> +rename_whiteout()
> >>>> +{
> >>>> +	local target_dir=$1
> >>>> +	local files_count=$2
> >>>> +
> >>>> +	# a long filename could increase the possibility that target_dp
> >>>> +	# allocate new blocks(acquire the AGF lock) to store the filename
> >>>> +	longnamepre=`$PERL_PROG -e 'print "a"x200;'`
> >>>> +
> >>>> +	# now try to do rename with RENAME_WHITEOUT flag
> >>>> +	for i in $(seq 1 $files_count); do
> >>>> +		src/renameat2 -w $SCRATCH_MNT/f$i $target_dir/$longnamepre$i >/dev/null 2>&1
> >>>> +	done
> >>>> +}
> >>>> +
> >>>> +_scratch_mkfs_xfs -d agcount=1 >> $seqres.full 2>&1 ||
> >>>> +	_fail "mkfs failed"
> >>>
> >>> This appears to be the only XFS specific bit. Could it be
> >>> conditionalized using FSTYP such that this test could go under
> >>> tests/generic?
> >>>
> >> OK, I'll move this test to tests/generic by using FSTYP.
> >>
> >>>> +_scratch_mount
> >>>> +
> >>>> +# set the rename and create file counts
> >>>> +file_count=50000
> >>>> +
> >>>> +# create the necessary directory for create and rename operations
> >>>> +createdir=$SCRATCH_MNT/createdir
> >>>> +mkdir $createdir
> >>>> +renamedir=$SCRATCH_MNT/renamedir
> >>>> +mkdir $renamedir
> >>>> +
> >>>> +# create many small files for the rename with RENAME_WHITEOUT
> >>>> +create_file $SCRATCH_MNT $file_count
> >>>> +
> >>>> +# try to create files at the same time to hit the deadlock
> >>>> +rename_whiteout $renamedir $file_count &
> >>>> +create_file $createdir $file_count &
> >>>> +
> >>>
> >>> When I ran this test I noticed that the rename_whiteout task completed
> >>> renaming the 50k files before the create_file task created even 30k of
> >>> the 50k files. There's no risk of deadlock once one of these tasks
> >>> completes, right? If so, that seems like something that could be fixed
> >>> up.
> >>>
> >>> Beyond that though, the test itself ran for almost 19 minutes on a vm
> >>> with the deadlock fix. That seems like overkill to me for a test that's
> >>> so narrowly focused on a particular bug that it's unlikely to fail in
> >>> the future. If we can't find a way to get this down to a reasonable time
> >>> while still reproducing the deadlock, I'm kind of wondering if there's a
> >>> better approach to get more rename coverage from existing tests. For
> >>> example, could we add this support to fsstress and see if any of the
> >>> existing stress tests might trigger the original problem? Even if we
> >>> needed to add a new rename/create focused fsstress test, that might at
> >>> least be general enough to provide broader coverage.
> >>>
> >> Yeah, rename_whiteout task run faster than create_file task, so maybe
> >> we can set two different files counts for them to reduce the test run
> >> time. This test ran for 380s on my vm with the fixed kernel, but we
> >> still need to find a way to reduce the run time, like the 19 minutes
> >> case. Actually, in most cases, the deadlock happened when the
> >> rename_whiteout task completed renaming hundreds of files. 50000
> >> is set just because this test take 380s on my vm which is acceptable
> >> and the reproduce possibility is near 100%. So maybe we can choose a
> >> proper files count to make the test runs faster. Of course, I'll
> >> also try to use fsstresss and the TIME_FACTOR if they can help to
> >> reduce the run time.
> >>  
> > 
> > I think using different file counts as such is too unpredictable across
> > different test environments. If we end up with something like the
> > current test, I'd rather see explicit logic in the test to terminate the
> > workload thread when the rename thread completes. This probably would
> > have knocked 2-3 minutes off the slow runtime I reported above.
> > 
> > That aside, I think the fsstress approach is preferable because there is
> > at least potential to avoid the need for a new test. The relevant
> > questions to me are:
> > 
> > 1.) If you add renameat2 support to fsstress, do any of the existing
> > fsstress tests reproduce the original problem?
> 
> Not sure about this, need to do research whether there are existing
> fsstress tests can reproduce the problem.	

Right, but this will require some work to fsstress to add renameat2
support. To Eryu's earlier point, however, that is probably a useful
patch regardless of what approach we take below.

> > 
> > 2.) If not, can fsstress reproduce the problem using customized
> > parameters (i.e., limited to rename and creates)? If so, we may still
> > need a separate test, but it would be trivial in that it just invokes
> > fsstress with particular flags for a period of time.
> > 
> > 3.) If not, then we need to find a way for this test to run quicker. At
> > this point, I'm curious how long it takes for this test to reproduce the
> > problem (on a broken kernel) on average once the setup portion
> > completes. More than a minute or two, for example, or tens of minutes..
> > etc.?
> > 
> About five minutes with 50000 files count on a broken kernel to reproduce
> the deadlock on my vm, and the most time is preparing 50000 empty files for
> the rename operation.
> 

Ok, so how much time is that outside of the file creation part? You
could add some timestamps to the test to figure that out if necessary.
How many files were renamed before the deadlock occurred?

Brian

> A example for deadlock happened when renaming 2729 files.
> call trace: 
> root  31829  ... D+ ... /renamedir/aaaaaaaaaaaaaaaaaaa...aaaaaaaaaaaaaaa2729
> # cat /proc/31829/stack 
> [<0>] xfs_buf_lock+0x34/0xf0 [xfs]
> [<0>] xfs_buf_find+0x215/0x6c0 [xfs]
> [<0>] xfs_buf_get_map+0x37/0x230 [xfs]
> [<0>] xfs_buf_read_map+0x29/0x190 [xfs]
> [<0>] xfs_trans_read_buf_map+0x13d/0x520 [xfs]
> [<0>] xfs_read_agi+0xa8/0x160 [xfs]
> [<0>] xfs_iunlink_remove+0x6f/0x2a0 [xfs]
> [<0>] xfs_rename+0x57a/0xae0 [xfs]
> [<0>] xfs_vn_rename+0xe4/0x150 [xfs]
> [<0>] vfs_rename+0x1f4/0x7b0
> [<0>] do_renameat2+0x431/0x4c0
> [<0>] __x64_sys_renameat2+0x20/0x30
> [<0>] do_syscall_64+0x49/0x120
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> > Brian
> > 
> >>> Alternatively, what if this test ran a create/rename workload (on a
> >>> smaller fileset) for a fixed time of a minute or two and then exited? I
> >>> think it would be a reasonable compromise if the test still reproduced
> >>> on some smaller frequency, it's just not clear to me how effective such
> >>> a test would be without actually trying it. Maybe Eryu has additional
> >>> thoughts..
> >>>
> >>> Brian
> >>>
> >>>> +wait
> >>>> +echo Silence is golden
> >>>> +
> >>>> +# Failure comes in the form of a deadlock.
> >>>> +
> >>>> +# success, all done
> >>>> +status=0
> >>>> +exit
> >>>> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> >>>> new file mode 100644
> >>>> index 0000000..0aabdef
> >>>> --- /dev/null
> >>>> +++ b/tests/xfs/512.out
> >>>> @@ -0,0 +1,2 @@
> >>>> +QA output created by 512
> >>>> +Silence is golden
> >>>> diff --git a/tests/xfs/group b/tests/xfs/group
> >>>> index a7ad300..ed250d6 100644
> >>>> --- a/tests/xfs/group
> >>>> +++ b/tests/xfs/group
> >>>> @@ -509,3 +509,4 @@
> >>>>  509 auto ioctl
> >>>>  510 auto ioctl quick
> >>>>  511 auto quick quota
> >>>> +512 auto rename
> >>>> -- 
> >>>> 1.8.3.1
> >>>>
> >>>> -- 
> >>>> kaixuxia
> >>
> >> -- 
> >> kaixuxia
> 
> -- 
> kaixuxia
