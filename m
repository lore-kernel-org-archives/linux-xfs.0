Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EC4C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 21:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354829AbiEFVwr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 17:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348985AbiEFVwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 17:52:46 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 461366EC63;
        Fri,  6 May 2022 14:49:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5731053457F;
        Sat,  7 May 2022 07:49:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nn5op-008rkP-Te; Sat, 07 May 2022 07:48:59 +1000
Date:   Sat, 7 May 2022 07:48:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/larp: Make test failures debuggable
Message-ID: <20220506214859.GJ1949718@dread.disaster.area>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
 <20220506075141.GH1949718@dread.disaster.area>
 <20220506161442.GP27195@magnolia>
 <20220506164051.pjccaapyytnt4iic@zlang-mailbox>
 <736E0977-3DF2-4100-AD8D-3EC6B67E44A1@oracle.com>
 <20220506200212.tw6lg5h6q2d2t6lr@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220506200212.tw6lg5h6q2d2t6lr@zlang-mailbox>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=627597cd
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=IkcTkHD0fZMA:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=mnkUWAPmhk_07LRUc_4A:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 07, 2022 at 04:02:12AM +0800, Zorro Lang wrote:
> On Fri, May 06, 2022 at 06:08:08PM +0000, Catherine Hoang wrote:
> > > On May 6, 2022, at 9:40 AM, Zorro Lang <zlang@redhat.com> wrote:
> > > 
> > > On Fri, May 06, 2022 at 09:14:42AM -0700, Darrick J. Wong wrote:
> > >> On Fri, May 06, 2022 at 05:51:41PM +1000, Dave Chinner wrote:
> > >>> From: Dave Chinner <dchinner@redhat.com>
> > >>> 
> > >>> Md5sum output for attributes created combined program output and
> > >>> attribute values. This adds variable path names to the md5sum, so
> > >>> there's no way to tell if the md5sum is actually correct for the
> > >>> given attribute value that is returned as it's not constant from
> > >>> test to test. Hence we can't actually say that the output is correct
> > >>> because we can't reproduce exactly what we are hashing easily.
> > >>> 
> > >>> Indeed, the last attr test in series (node w/ replace) had an
> > >>> invalid md5sum. The attr value being produced after recovery was
> > >>> correct, but the md5sum output match was failing. Golden output
> > >>> appears to be wrong.
> > >>> 
> > >>> Fix this issue by seperately dumping all the attributes on the inode
> > >>> via a list operation to indicate their size, then dump the value of
> > >>> the test attribute directly to md5sum. This means the md5sum for
> > >>> the attributes using the same fixed values are all identical, so
> > >>> it's easy to tell if the md5sum for a given test is correct. We also
> > >>> check that all attributes that should be present after recovery are
> > >>> still there (e.g. checks recovery didn't trash innocent bystanders).
> > >>> 
> > >>> Further, the attribute replace tests replace an attribute with an
> > >>> identical value, hence there is no way to tell if recovery has
> > >>> resulted in the original being left behind or the new attribute
> > >>> being fully recovered because both have the same name and value.
> > >>> When replacing the attribute value, use a different sized value so
> > >>> it is trivial to determine that we've recovered the new attribute
> > >>> value correctly.
> > >>> 
> > >>> Also, the test runs on the scratch device - there is no need to
> > >>> remove the testdir in _cleanup. Doing so prevents post-mortem
> > >>> failure analysis because it burns the dead, broken corpse to ash and
> > >>> leaves no way of to determine cause of death.
> > >>> 
> > >>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > >>> ---
> > >>> 
> > >>> Hi Catherine,
> > >>> 
> > >>> These are all the mods I needed to make to be able to understand the
> > >>> test failures I was getting as I debugged the new LARP recovery
> > >>> algorithm I've written.  You'll need to massage the test number in
> > >>> this patch to apply it on top of your patch.
> > >>> 
> > >>> I haven't added any new test cases yet, nor have I done anything to
> > >>> manage the larp sysfs knob, but we'll need to do those in the near
> > >>> future.
> > >>> 
> > >>> Zorro, can you consider merging this test in the near future?  We're
> > >>> right at the point of merging the upstream kernel code and so really
> > >>> need to start growing the test coverage of this feature, and this
> > >>> test should simply not-run on kernels that don't have the feature
> > >>> enabled....
> > >>> 
> > >>> Cheers,
> > >>> 
> > >>> Dave.
> > >>> ---
> > >>> 
> > >>> tests/xfs/600     |  20 +++++-----
> > >>> tests/xfs/600.out | 109 ++++++++++++++++++++++++++++++++++++------------------
> > >>> 2 files changed, 85 insertions(+), 44 deletions(-)
> > >>> 
> > >>> diff --git a/tests/xfs/600 b/tests/xfs/600
> > >>> index 252cdf27..84704646 100755
> > >>> --- a/tests/xfs/600
> > >>> +++ b/tests/xfs/600
> > >>> @@ -16,7 +16,7 @@ _begin_fstest auto quick attr
> > >>> 
> > >>> _cleanup()
> > >>> {
> > >>> -	rm -rf $tmp.* $testdir
> > >>> +	rm -rf $tmp.*
> > >>> 	test -w /sys/fs/xfs/debug/larp && \
> > >>> 		echo 0 > /sys/fs/xfs/debug/larp
> > >> 
> > >> Blergh, this ^^^^^^^^^ is going to need fixing too.

Yes, I did point that out.

> > >> 
> > >> Please save the old value, then write it back in the _cleanup function.
> > > 
> > > Ok, I'm going to do that when I merge it,

No, please don't. I don't want random changes added to the test on
commit right now as I'm still actively working on it. I've said
twice now that this needs fixing (3 if you count this mention) and
that the test coverage also needs improving. If someone is still
working on the tests, then why make more work for everyone by making
unnecessary, unreviewed changes on commit?

> > > if Catherine wouldn't like to do
> > > more changes in a V8 patch. If this case still need more changes, please tell
> > > me in time, and then it might have to wait the fstests release after next, if
> > > too late.
> > > 
> > > Thanks,
> > > Zorro
> > 
> > Based on Dave’s feedback, it looks like the patch will need a few more
> > changes before it’s ready.

That doesn't mean it can't be merged. It is a pain for mulitple
people to collaborate on a test that isn't merged because the test
number is not set in stone and chosing numbers always conflicts with
other tests under development. Getting the test merged early makes
knocking all the problems out of the test (and the code it is
testing!) much, much easier.

> Great, that would be really helpful if you'd like to rebase this patch to fstests
> for-next branch. And how about combine Dave's patch with your patch? I don't think
> it's worth merging two seperated patches for one signle new case. What does Dave think?
> 
> I just merged below two patchset[1] into xfs-5.18-fixes-1, then tried to test this case
> (with you and Dave's patch). But it always failed as [2].

You built a broken kernel as it has none of the dependencies and bug
fixes that had already been committed to for-next for the new
functionality to work correctly. I posted a V3 patchset last night
and a published a git branch with all the kernel changes that you
can use for testing if you want.

> Please make sure it works
> as expected with those kernel patches still reviewing,

I did - the failures you see are expected from what you were
testing. i.e. the test ran just fine, the kernel code you were
running is buggy and you didn't update xfsprogs so logprint
supported the new log types, hence the test (correctly) reported
failures.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
