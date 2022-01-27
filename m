Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF52C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 00:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiA0A4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 19:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbiA0A4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 19:56:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4061C06161C;
        Wed, 26 Jan 2022 16:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E687461B72;
        Thu, 27 Jan 2022 00:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0395DC340E3;
        Thu, 27 Jan 2022 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643244960;
        bh=o6SQFrjPvU3lHDjxzH5JGb2UXQ8yL7+L0Dv3Y35W2tQ=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=LpVssbkz580I4G5nIuobrQFyvEIIC3IBUjOOb802j0mz+tDEXn3JxBDTZEfTrJZ6t
         qvO123i6VXufEhIRAAzRraa/OI5DX5YVpbBg23VuLxSO6DNJzrdSsDW7kaHiW4+jdW
         xBA2icRrDYV2C09ExxUh1RVZPKiEbOQOiT413wPL+ZXR05wbmx0AZ5Hpjt7QtgR6Qq
         xmmVl8unD/dA91XMc7tF9KcZGSvYiniJRz/EZOZqSVGWE9F+NZcpTOI1eazlILyqJO
         J2HdsNPHRFVdxdD2JEEfvngGjZFSvicONuWygYmUOIi0bX7U/EilStRAQHKk5R7GgW
         1o4viUWlAWibQ==
Date:   Wed, 26 Jan 2022 16:55:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic: test suid/sgid behavior with reflink and
 dedupe
Message-ID: <20220127005556.GC13540@magnolia>
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
 <164316310910.2594527.6072232851001636761.stgit@magnolia>
 <20220126055641.wnyawz3ooeqnwefi@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126055641.wnyawz3ooeqnwefi@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 01:56:41PM +0800, Zorro Lang wrote:
> On Tue, Jan 25, 2022 at 06:11:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that we drop the setuid and setgid bits any time reflink or
> > dedupe change the file contents.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/950     |  108 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/950.out |   49 ++++++++++++++++++++
> >  tests/generic/951     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/951.out |   49 ++++++++++++++++++++
> >  tests/generic/952     |   71 +++++++++++++++++++++++++++++
> >  tests/generic/952.out |   13 +++++
> >  6 files changed, 408 insertions(+)
> >  create mode 100755 tests/generic/950
> >  create mode 100644 tests/generic/950.out
> >  create mode 100755 tests/generic/951
> >  create mode 100644 tests/generic/951.out
> >  create mode 100755 tests/generic/952
> >  create mode 100644 tests/generic/952.out
> > 
> > 
> > diff --git a/tests/generic/950 b/tests/generic/950
> > new file mode 100755
> > index 00000000..84f1d1f0
> > --- /dev/null
> > +++ b/tests/generic/950
> > @@ -0,0 +1,108 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 950
> > +#
> > +# Functional test for dropping suid and sgid bits as part of a reflink.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone quick
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_user
> > +_require_scratch_reflink
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> 
> Is this a Darrick's secret helper ? :)

Oops, yes.  Will resend.

There's a big old patchset in djwong-dev that teaches all the reflink
tests to _notrun if the file allocation unit is not congruent (i.e. an
integer multiple or factor) with the operation sizes used in the test.

I should probably move that up in the branch, but with Lunar New Year
starting next week there probably isn't much point... ;)

--D

> Thanks,
> Zorro
> 
> > +chmod a+rw $SCRATCH_MNT/
> > +
> > +setup_testfile() {
> > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> > +	chmod a+r $SCRATCH_MNT/b
> > +	sync
> > +}
> > +
> > +commit_and_check() {
> > +	local user="$1"
> > +
> > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > +	if [ -n "$user" ]; then
> > +		su - "$user" -c "$cmd" >> $seqres.full
> > +	else
> > +		$SHELL -c "$cmd" >> $seqres.full
> > +	fi
> > +
> > +	_scratch_cycle_mount
> > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	# Blank line in output
> > +	echo
> > +}
> > +
> > +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> > +# sgid.
> > +echo "Test 1 - qa_user, non-exec file"
> > +setup_testfile
> > +chmod a+rws $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> > +echo "Test 2 - qa_user, group-exec file"
> > +setup_testfile
> > +chmod g+x,a+rws $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> > +echo "Test 3 - qa_user, user-exec file"
> > +setup_testfile
> > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> > +echo "Test 4 - qa_user, all-exec file"
> > +setup_testfile
> > +chmod a+rwxs $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a non-exec file by root clears suid but leaves sgid.
> > +echo "Test 5 - root, non-exec file"
> > +setup_testfile
> > +chmod a+rws $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a group-exec file by root clears suid and sgid.
> > +echo "Test 6 - root, group-exec file"
> > +setup_testfile
> > +chmod g+x,a+rws $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a user-exec file by root clears suid but not sgid.
> > +echo "Test 7 - root, user-exec file"
> > +setup_testfile
> > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a all-exec file by root clears suid and sgid.
> > +echo "Test 8 - root, all-exec file"
> > +setup_testfile
> > +chmod a+rwxs $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/950.out b/tests/generic/950.out
> > new file mode 100644
> > index 00000000..b42e4931
> > --- /dev/null
> > +++ b/tests/generic/950.out
> > @@ -0,0 +1,49 @@
> > +QA output created by 950
> > +Test 1 - qa_user, non-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +2666 -rw-rwSrw- SCRATCH_MNT/a
> > +
> > +Test 2 - qa_user, group-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +676 -rw-rwxrw- SCRATCH_MNT/a
> > +
> > +Test 3 - qa_user, user-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +2766 -rwxrwSrw- SCRATCH_MNT/a
> > +
> > +Test 4 - qa_user, all-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +777 -rwxrwxrwx SCRATCH_MNT/a
> > +
> > +Test 5 - root, non-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +
> > +Test 6 - root, group-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +
> > +Test 7 - root, user-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +
> > +Test 8 - root, all-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +
> > diff --git a/tests/generic/951 b/tests/generic/951
> > new file mode 100755
> > index 00000000..99f67ab7
> > --- /dev/null
> > +++ b/tests/generic/951
> > @@ -0,0 +1,118 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 951
> > +#
> > +# Functional test for dropping suid and sgid bits as part of a deduplication.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone quick
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_user
> > +_require_scratch_reflink
> > +_require_xfs_io_command dedupe
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > +chmod a+rw $SCRATCH_MNT/
> > +
> > +setup_testfile() {
> > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
> > +	chmod a+r $SCRATCH_MNT/b
> > +	sync
> > +}
> > +
> > +commit_and_check() {
> > +	local user="$1"
> > +
> > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	local before_freesp=$(_get_available_space $SCRATCH_MNT)
> > +
> > +	local cmd="$XFS_IO_PROG -c 'dedupe $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > +	if [ -n "$user" ]; then
> > +		su - "$user" -c "$cmd" >> $seqres.full
> > +	else
> > +		$SHELL -c "$cmd" >> $seqres.full
> > +	fi
> > +
> > +	_scratch_cycle_mount
> > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	local after_freesp=$(_get_available_space $SCRATCH_MNT)
> > +
> > +	echo "before: $before_freesp; after: $after_freesp" >> $seqres.full
> > +	if [ $after_freesp -le $before_freesp ]; then
> > +		echo "expected more free space after dedupe"
> > +	fi
> > +
> > +	# Blank line in output
> > +	echo
> > +}
> > +
> > +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> > +# sgid.
> > +echo "Test 1 - qa_user, non-exec file"
> > +setup_testfile
> > +chmod a+rws $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> > +echo "Test 2 - qa_user, group-exec file"
> > +setup_testfile
> > +chmod g+x,a+rws $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> > +echo "Test 3 - qa_user, user-exec file"
> > +setup_testfile
> > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> > +echo "Test 4 - qa_user, all-exec file"
> > +setup_testfile
> > +chmod a+rwxs $SCRATCH_MNT/a
> > +commit_and_check "$qa_user"
> > +
> > +# Commit to a non-exec file by root clears suid but leaves sgid.
> > +echo "Test 5 - root, non-exec file"
> > +setup_testfile
> > +chmod a+rws $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a group-exec file by root clears suid and sgid.
> > +echo "Test 6 - root, group-exec file"
> > +setup_testfile
> > +chmod g+x,a+rws $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a user-exec file by root clears suid but not sgid.
> > +echo "Test 7 - root, user-exec file"
> > +setup_testfile
> > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# Commit to a all-exec file by root clears suid and sgid.
> > +echo "Test 8 - root, all-exec file"
> > +setup_testfile
> > +chmod a+rwxs $SCRATCH_MNT/a
> > +commit_and_check
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/951.out b/tests/generic/951.out
> > new file mode 100644
> > index 00000000..f7099ea2
> > --- /dev/null
> > +++ b/tests/generic/951.out
> > @@ -0,0 +1,49 @@
> > +QA output created by 951
> > +Test 1 - qa_user, non-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +
> > +Test 2 - qa_user, group-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +
> > +Test 3 - qa_user, user-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +
> > +Test 4 - qa_user, all-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +
> > +Test 5 - root, non-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > +
> > +Test 6 - root, group-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > +
> > +Test 7 - root, user-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > +
> > +Test 8 - root, all-exec file
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > +
> > diff --git a/tests/generic/952 b/tests/generic/952
> > new file mode 100755
> > index 00000000..470d73bd
> > --- /dev/null
> > +++ b/tests/generic/952
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 952
> > +#
> > +# Functional test for dropping suid and sgid capabilities as part of a reflink.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone quick
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_user
> > +_require_command "$GETCAP_PROG" getcap
> > +_require_command "$SETCAP_PROG" setcap
> > +_require_scratch_reflink
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > +chmod a+rw $SCRATCH_MNT/
> > +
> > +setup_testfile() {
> > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> > +	chmod a+rwx $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +	$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/a
> > +	sync
> > +}
> > +
> > +commit_and_check() {
> > +	local user="$1"
> > +
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > +	if [ -n "$user" ]; then
> > +		su - "$user" -c "$cmd" >> $seqres.full
> > +	else
> > +		$SHELL -c "$cmd" >> $seqres.full
> > +	fi
> > +
> > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
> > +
> > +	# Blank line in output
> > +	echo
> > +}
> > +
> > +# Commit by an unprivileged user clears capability bits.
> > +echo "Test 1 - qa_user"
> > +setup_testfile
> > +commit_and_check "$qa_user"
> > +
> > +# Commit by root leaves capability bits.
> > +echo "Test 2 - root"
> > +setup_testfile
> > +commit_and_check
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/952.out b/tests/generic/952.out
> > new file mode 100644
> > index 00000000..eac9e76a
> > --- /dev/null
> > +++ b/tests/generic/952.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 952
> > +Test 1 - qa_user
> > +777 -rwxrwxrwx SCRATCH_MNT/a
> > +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> > +777 -rwxrwxrwx SCRATCH_MNT/a
> > +SCRATCH_MNT/a
> > +
> > +Test 2 - root
> > +777 -rwxrwxrwx SCRATCH_MNT/a
> > +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> > +777 -rwxrwxrwx SCRATCH_MNT/a
> > +SCRATCH_MNT/a
> > +
> > 
> 
