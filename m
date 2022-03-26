Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7033C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Mar 2022 18:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiCZSI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Mar 2022 14:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCZSI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Mar 2022 14:08:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963A116CE75;
        Sat, 26 Mar 2022 11:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8DACCE0A55;
        Sat, 26 Mar 2022 18:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB85AC340ED;
        Sat, 26 Mar 2022 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648318037;
        bh=daVFnRUKLZ2VN1dYcEoEwwj/IvRE9Hqgls8Y4VdG57Y=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=cSDtUxoIhGNYzo/cZ4vKKGbA96rJCHV17Uf6He9Bn8NC8h1X7NdVutmlQBrao214f
         fIsuA32kki2NB0woRc9rOL+WKoUJwAmN5gt4zj/r7Vs/dguSNbkaXOJdm/OUPqD82Q
         mTGv7+K6BJp7ha7HX/Hw7a3VJ56sMuNh9BrjpL2v0RZ7SevWicqnN2Nvaw0sfh5P6H
         rFs8N2E5V8QhGP42oazEl39ZifBRGjcitTsrybbn/t94PDwhijpPlUbD1As/4aRNYL
         bc+qOb6NuCj4ApuISk49VuynglKwoixRV35dTF5X3ycS1h6N1APJYhjKYAHoKzShJA
         Lv0loj4cAO0zQ==
Date:   Sat, 26 Mar 2022 11:07:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic: ensure we drop suid after fallocate
Message-ID: <20220326180716.GT8200@magnolia>
References: <20220323030657.5al7wlxsvjzybbg3@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323030657.5al7wlxsvjzybbg3@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 11:06:57AM +0800, Zorro Lang wrote:
> On Tue, Mar 15, 2022 at 08:30:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > fallocate changes file contents, so make sure that we drop privileges
> > and file capabilities after each fallocate operation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/834     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/834.out |   33 +++++++++++++
> >  tests/generic/835     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/835.out |   33 +++++++++++++
> >  tests/generic/836     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/836.out |   33 +++++++++++++
> >  tests/generic/837     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/837.out |   33 +++++++++++++
> >  tests/generic/838     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/838.out |   33 +++++++++++++
> >  tests/generic/839     |   79 ++++++++++++++++++++++++++++++
> >  tests/generic/839.out |   13 +++++
> >  12 files changed, 902 insertions(+)
> >  create mode 100755 tests/generic/834
> >  create mode 100644 tests/generic/834.out
> >  create mode 100755 tests/generic/835
> >  create mode 100644 tests/generic/835.out
> >  create mode 100755 tests/generic/836
> >  create mode 100644 tests/generic/836.out
> >  create mode 100755 tests/generic/837
> >  create mode 100644 tests/generic/837.out
> >  create mode 100755 tests/generic/838
> >  create mode 100644 tests/generic/838.out
> >  create mode 100755 tests/generic/839
> >  create mode 100755 tests/generic/839.out
> > 
> > 
> > diff --git a/tests/generic/834 b/tests/generic/834
> > new file mode 100755
> > index 00000000..27552221
> > --- /dev/null
> > +++ b/tests/generic/834
> > @@ -0,0 +1,129 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 834
> > +#
> > +# Functional test for dropping suid and sgid bits as part of a fallocate.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone quick
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.* $junk_dir
> > +}
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
> > +_require_test
> > +verb=falloc
> > +_require_xfs_io_command $verb
> > +
> > +_require_congruent_file_oplen $TEST_DIR 65536
>       ^^
> 
> Is it a Darrick's unpublic secret weapon:)

Not really, the latest djwong development branches are always at
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/

(But yes, the _require_congruent_file_oplen helper prevents us from
running fallocate tests when the selected operation size isn't congruent
with the configured blocksize (e.g. blksz=65536 when the rt extent size
is 28k)

> > +
> > +junk_dir=$TEST_DIR/$seq
> > +junk_file=$junk_dir/a
> > +mkdir -p $junk_dir/
> > +chmod a+rw $junk_dir/
> > +
> 
> [snip] ...
> 
> > diff --git a/tests/generic/839 b/tests/generic/839
> > new file mode 100755
> > index 00000000..a1e23916
> > --- /dev/null
> > +++ b/tests/generic/839
> > @@ -0,0 +1,79 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 839
> > +#
> > +# Functional test for dropping capability bits as part of an fallocate.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto fiexchange swapext quick
>                         ^^         ^^
> 
> I think we don't have these two group names currently, this will cause failure.
> You can register them if you need :)

Oops.  Yeah, I'll fix these things before I resubmit.  Thanks for
pointing that out. :(

--D

> 
> Thanks,
> Zorro
> 
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.* $junk_dir
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_user
> > +_require_command "$GETCAP_PROG" getcap
> > +_require_command "$SETCAP_PROG" setcap
> > +_require_xfs_io_command falloc
> > +_require_test
> > +
> > +_require_congruent_file_oplen $TEST_DIR 65536
> > +
> > +junk_dir=$TEST_DIR/$seq
> > +junk_file=$junk_dir/a
> > +mkdir -p $junk_dir/
> > +chmod a+rw $junk_dir/
> > +
> > +setup_testfile() {
> > +	rm -f $junk_file
> > +	touch $junk_file
> > +	chmod a+rwx $junk_file
> > +	$SETCAP_PROG cap_setgid,cap_setuid+ep $junk_file
> > +	sync
> > +}
> > +
> > +commit_and_check() {
> > +	local user="$1"
> > +
> > +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> > +	_getcap -v $junk_file | _filter_test_dir
> > +
> > +	local cmd="$XFS_IO_PROG -c 'falloc 0 64k' $junk_file"
> > +	if [ -n "$user" ]; then
> > +		su - "$user" -c "$cmd" >> $seqres.full
> > +	else
> > +		$SHELL -c "$cmd" >> $seqres.full
> > +	fi
> > +
> > +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> > +	_getcap -v $junk_file | _filter_test_dir
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
> > diff --git a/tests/generic/839.out b/tests/generic/839.out
> > new file mode 100755
> > index 00000000..f571cd26
> > --- /dev/null
> > +++ b/tests/generic/839.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 839
> > +Test 1 - qa_user
> > +777 -rwxrwxrwx TEST_DIR/839/a
> > +TEST_DIR/839/a cap_setgid,cap_setuid=ep
> > +777 -rwxrwxrwx TEST_DIR/839/a
> > +TEST_DIR/839/a
> > +
> > +Test 2 - root
> > +777 -rwxrwxrwx TEST_DIR/839/a
> > +TEST_DIR/839/a cap_setgid,cap_setuid=ep
> > +777 -rwxrwxrwx TEST_DIR/839/a
> > +TEST_DIR/839/a
> > +
> > 
> 
