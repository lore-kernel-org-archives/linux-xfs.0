Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4760DC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbiDSSn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239142AbiDSSnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:43:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30551340F9
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650393668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eq9LUCVGnvzwmELgNFneEQzC6fi3MOg3In1rKdDZmHQ=;
        b=H76k+6oboYlKCjF2ev0QQjMrJ5aQ1vUogMqsWmJU1PjIjl31xpCeW9z6YS8wxgHlaop1dQ
        0fGDtlCf+ge3rriPv2fBRpAu5g9jDctHYM/V89O3ZlGfEGt0ZfrxulXan8xOPlXIF/B6wn
        5uEuVt+OvAxBnneIiPKK9aMAc+6a5WY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-aIXPDhdzMM-V25wgCC5Fog-1; Tue, 19 Apr 2022 14:41:06 -0400
X-MC-Unique: aIXPDhdzMM-V25wgCC5Fog-1
Received: by mail-qk1-f199.google.com with SMTP id x25-20020a05620a14b900b0069ec20bb022so2052761qkj.19
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=eq9LUCVGnvzwmELgNFneEQzC6fi3MOg3In1rKdDZmHQ=;
        b=Y5fGqm/On2TLxrXqmM5uWKRWNl1KQVzI6fop4yj7whU41CjHIwRaQhaQjq/A2BVfy3
         EU+2NdXMY/WgMUNYpfhlDFGgh1SywWLcJDi2U54P4tJnHCASsGPjWsD7PzpEWPJliVC3
         lKw46vgowIRf/h09PC9eWu4RGf2p9pGoSqRIVQkplhinNIEA0kCCXpGsUvqstPrXHnlN
         I6C/g7jq6End4aJzG6ElUgOKFQ+NKMzPBzkewzcJhaIVNqYgBsmnJbnW8r15QZoYeXNh
         c47VUhBvLbYTl+9eqSBVb6UpGi/12hsAeVDsGflJLqg9PjYXOvfHmtBjLhwKpg8w5DuA
         0ErA==
X-Gm-Message-State: AOAM531gSE7gWjsKJPILAbEE6AQqbsu/Lbf6sxOTj/6/+Sxtcht0d2br
        KczBihbJqbODb7x+Lf6SRAuZVNDUO0B0ZuZ8ninz3842SOpgtkro54swzZ7qB4MM/+aCRDAf1T8
        KRV+/nAgPtiJKBErLAdb9
X-Received: by 2002:a05:6214:d67:b0:446:fa7:113e with SMTP id 7-20020a0562140d6700b004460fa7113emr12654775qvs.116.1650393665287;
        Tue, 19 Apr 2022 11:41:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVQ4axcHWhe04XZnchBdewOvvz1MHLfhkvp6BaabdSmCNIzlv/OR5vQwWm1v2PlZguB234uw==
X-Received: by 2002:a05:6214:d67:b0:446:fa7:113e with SMTP id 7-20020a0562140d6700b004460fa7113emr12654736qvs.116.1650393664717;
        Tue, 19 Apr 2022 11:41:04 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21-20020a05620a409500b0069e88d91beesm379240qko.53.2022.04.19.11.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:41:04 -0700 (PDT)
Date:   Wed, 20 Apr 2022 02:40:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 2/2] generic: ensure we drop suid after fallocate
Message-ID: <20220419184057.mc4gkqbhdbmfsh57@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
References: <165038952992.1677711.6313258860719066297.stgit@magnolia>
 <165038954106.1677711.3709440583151047260.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165038954106.1677711.3709440583151047260.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 10:32:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> fallocate changes file contents, so make sure that we drop privileges
> and file capabilities after each fallocate operation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/834.out |   33 +++++++++++++
>  tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/835.out |   33 +++++++++++++
>  tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/836.out |   33 +++++++++++++
>  tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/837.out |   33 +++++++++++++
>  tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/838.out |   33 +++++++++++++
>  tests/generic/839     |   77 ++++++++++++++++++++++++++++++
>  tests/generic/839.out |   13 +++++
>  12 files changed, 890 insertions(+)
>  create mode 100755 tests/generic/834
>  create mode 100644 tests/generic/834.out
>  create mode 100755 tests/generic/835
>  create mode 100644 tests/generic/835.out
>  create mode 100755 tests/generic/836
>  create mode 100644 tests/generic/836.out
>  create mode 100755 tests/generic/837
>  create mode 100644 tests/generic/837.out
>  create mode 100755 tests/generic/838
>  create mode 100644 tests/generic/838.out
>  create mode 100755 tests/generic/839
>  create mode 100755 tests/generic/839.out
> 
> 
> diff --git a/tests/generic/834 b/tests/generic/834
> new file mode 100755
> index 00000000..9b0ff7e5
> --- /dev/null
> +++ b/tests/generic/834
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 834
> +#
> +# Functional test for dropping suid and sgid bits as part of a fallocate.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic

Thanks for you'd like to accept this change :) If someone fs clearly says
they never support this behavior, we can deal with them later. Or they can
use Amir's later patch to exclude themselves from this case testing clearly.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +_require_user
> +_require_test
> +verb=falloc
> +_require_xfs_io_command $verb
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +	local command="$2"
> +	local start="$3"
> +	local end="$4"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +nr=0
> +# Commit to a non-exec file by an unprivileged user clears suid but
> +# leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but
> +# not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/834.out b/tests/generic/834.out
> new file mode 100644
> index 00000000..2226eea6
> --- /dev/null
> +++ b/tests/generic/834.out
> @@ -0,0 +1,33 @@
> +QA output created by 834
> +Test 1 - qa_user, non-exec file falloc
> +6666 -rwSrwSrw- TEST_DIR/834/a
> +666 -rw-rw-rw- TEST_DIR/834/a
> +
> +Test 2 - qa_user, group-exec file falloc
> +6676 -rwSrwsrw- TEST_DIR/834/a
> +676 -rw-rwxrw- TEST_DIR/834/a
> +
> +Test 3 - qa_user, user-exec file falloc
> +6766 -rwsrwSrw- TEST_DIR/834/a
> +766 -rwxrw-rw- TEST_DIR/834/a
> +
> +Test 4 - qa_user, all-exec file falloc
> +6777 -rwsrwsrwx TEST_DIR/834/a
> +777 -rwxrwxrwx TEST_DIR/834/a
> +
> +Test 5 - root, non-exec file falloc
> +6666 -rwSrwSrw- TEST_DIR/834/a
> +6666 -rwSrwSrw- TEST_DIR/834/a
> +
> +Test 6 - root, group-exec file falloc
> +6676 -rwSrwsrw- TEST_DIR/834/a
> +6676 -rwSrwsrw- TEST_DIR/834/a
> +
> +Test 7 - root, user-exec file falloc
> +6766 -rwsrwSrw- TEST_DIR/834/a
> +6766 -rwsrwSrw- TEST_DIR/834/a
> +
> +Test 8 - root, all-exec file falloc
> +6777 -rwsrwsrwx TEST_DIR/834/a
> +6777 -rwsrwsrwx TEST_DIR/834/a
> +
> diff --git a/tests/generic/835 b/tests/generic/835
> new file mode 100755
> index 00000000..0f67ce3b
> --- /dev/null
> +++ b/tests/generic/835
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 835
> +#
> +# Functional test for dropping suid and sgid bits as part of a fpunch.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_user
> +_require_test
> +verb=fpunch
> +_require_xfs_io_command $verb
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +	local command="$2"
> +	local start="$3"
> +	local end="$4"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +nr=0
> +# Commit to a non-exec file by an unprivileged user clears suid but
> +# leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but
> +# not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/835.out b/tests/generic/835.out
> new file mode 100644
> index 00000000..186d7da4
> --- /dev/null
> +++ b/tests/generic/835.out
> @@ -0,0 +1,33 @@
> +QA output created by 835
> +Test 1 - qa_user, non-exec file fpunch
> +6666 -rwSrwSrw- TEST_DIR/835/a
> +666 -rw-rw-rw- TEST_DIR/835/a
> +
> +Test 2 - qa_user, group-exec file fpunch
> +6676 -rwSrwsrw- TEST_DIR/835/a
> +676 -rw-rwxrw- TEST_DIR/835/a
> +
> +Test 3 - qa_user, user-exec file fpunch
> +6766 -rwsrwSrw- TEST_DIR/835/a
> +766 -rwxrw-rw- TEST_DIR/835/a
> +
> +Test 4 - qa_user, all-exec file fpunch
> +6777 -rwsrwsrwx TEST_DIR/835/a
> +777 -rwxrwxrwx TEST_DIR/835/a
> +
> +Test 5 - root, non-exec file fpunch
> +6666 -rwSrwSrw- TEST_DIR/835/a
> +6666 -rwSrwSrw- TEST_DIR/835/a
> +
> +Test 6 - root, group-exec file fpunch
> +6676 -rwSrwsrw- TEST_DIR/835/a
> +6676 -rwSrwsrw- TEST_DIR/835/a
> +
> +Test 7 - root, user-exec file fpunch
> +6766 -rwsrwSrw- TEST_DIR/835/a
> +6766 -rwsrwSrw- TEST_DIR/835/a
> +
> +Test 8 - root, all-exec file fpunch
> +6777 -rwsrwsrwx TEST_DIR/835/a
> +6777 -rwsrwsrwx TEST_DIR/835/a
> +
> diff --git a/tests/generic/836 b/tests/generic/836
> new file mode 100755
> index 00000000..c470cb1e
> --- /dev/null
> +++ b/tests/generic/836
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 836
> +#
> +# Functional test for dropping suid and sgid bits as part of a fzero.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_user
> +_require_test
> +verb=fzero
> +_require_xfs_io_command $verb
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +	local command="$2"
> +	local start="$3"
> +	local end="$4"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +nr=0
> +# Commit to a non-exec file by an unprivileged user clears suid but
> +# leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but
> +# not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/836.out b/tests/generic/836.out
> new file mode 100644
> index 00000000..9f9f5f12
> --- /dev/null
> +++ b/tests/generic/836.out
> @@ -0,0 +1,33 @@
> +QA output created by 836
> +Test 1 - qa_user, non-exec file fzero
> +6666 -rwSrwSrw- TEST_DIR/836/a
> +666 -rw-rw-rw- TEST_DIR/836/a
> +
> +Test 2 - qa_user, group-exec file fzero
> +6676 -rwSrwsrw- TEST_DIR/836/a
> +676 -rw-rwxrw- TEST_DIR/836/a
> +
> +Test 3 - qa_user, user-exec file fzero
> +6766 -rwsrwSrw- TEST_DIR/836/a
> +766 -rwxrw-rw- TEST_DIR/836/a
> +
> +Test 4 - qa_user, all-exec file fzero
> +6777 -rwsrwsrwx TEST_DIR/836/a
> +777 -rwxrwxrwx TEST_DIR/836/a
> +
> +Test 5 - root, non-exec file fzero
> +6666 -rwSrwSrw- TEST_DIR/836/a
> +6666 -rwSrwSrw- TEST_DIR/836/a
> +
> +Test 6 - root, group-exec file fzero
> +6676 -rwSrwsrw- TEST_DIR/836/a
> +6676 -rwSrwsrw- TEST_DIR/836/a
> +
> +Test 7 - root, user-exec file fzero
> +6766 -rwsrwSrw- TEST_DIR/836/a
> +6766 -rwsrwSrw- TEST_DIR/836/a
> +
> +Test 8 - root, all-exec file fzero
> +6777 -rwsrwsrwx TEST_DIR/836/a
> +6777 -rwsrwsrwx TEST_DIR/836/a
> +
> diff --git a/tests/generic/837 b/tests/generic/837
> new file mode 100755
> index 00000000..f9a49bb1
> --- /dev/null
> +++ b/tests/generic/837
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 837
> +#
> +# Functional test for dropping suid and sgid bits as part of a finsert.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_user
> +_require_test
> +verb=finsert
> +_require_xfs_io_command $verb
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +	local command="$2"
> +	local start="$3"
> +	local end="$4"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +nr=0
> +# Commit to a non-exec file by an unprivileged user clears suid but
> +# leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but
> +# not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/837.out b/tests/generic/837.out
> new file mode 100644
> index 00000000..686b806e
> --- /dev/null
> +++ b/tests/generic/837.out
> @@ -0,0 +1,33 @@
> +QA output created by 837
> +Test 1 - qa_user, non-exec file finsert
> +6666 -rwSrwSrw- TEST_DIR/837/a
> +666 -rw-rw-rw- TEST_DIR/837/a
> +
> +Test 2 - qa_user, group-exec file finsert
> +6676 -rwSrwsrw- TEST_DIR/837/a
> +676 -rw-rwxrw- TEST_DIR/837/a
> +
> +Test 3 - qa_user, user-exec file finsert
> +6766 -rwsrwSrw- TEST_DIR/837/a
> +766 -rwxrw-rw- TEST_DIR/837/a
> +
> +Test 4 - qa_user, all-exec file finsert
> +6777 -rwsrwsrwx TEST_DIR/837/a
> +777 -rwxrwxrwx TEST_DIR/837/a
> +
> +Test 5 - root, non-exec file finsert
> +6666 -rwSrwSrw- TEST_DIR/837/a
> +6666 -rwSrwSrw- TEST_DIR/837/a
> +
> +Test 6 - root, group-exec file finsert
> +6676 -rwSrwsrw- TEST_DIR/837/a
> +6676 -rwSrwsrw- TEST_DIR/837/a
> +
> +Test 7 - root, user-exec file finsert
> +6766 -rwsrwSrw- TEST_DIR/837/a
> +6766 -rwsrwSrw- TEST_DIR/837/a
> +
> +Test 8 - root, all-exec file finsert
> +6777 -rwsrwsrwx TEST_DIR/837/a
> +6777 -rwsrwsrwx TEST_DIR/837/a
> +
> diff --git a/tests/generic/838 b/tests/generic/838
> new file mode 100755
> index 00000000..55838a8b
> --- /dev/null
> +++ b/tests/generic/838
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 838
> +#
> +# Functional test for dropping suid and sgid bits as part of a fcollapse.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_user
> +_require_test
> +verb=fcollapse
> +_require_xfs_io_command $verb
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	_pwrite_byte 0x58 0 192k $junk_file >> $seqres.full
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +	local command="$2"
> +	local start="$3"
> +	local end="$4"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c '$command $start $end' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +nr=0
> +# Commit to a non-exec file by an unprivileged user clears suid but
> +# leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but
> +# not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and
> +# sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - qa_user, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "$qa_user" "$verb" 64k 64k
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, non-exec file $verb"
> +setup_testfile
> +chmod a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, group-exec file $verb"
> +setup_testfile
> +chmod g+x,a+rws $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, user-exec file $verb"
> +setup_testfile
> +chmod u+x,a+rws,g-x $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +nr=$((nr + 1))
> +echo "Test $nr - root, all-exec file $verb"
> +setup_testfile
> +chmod a+rwxs $junk_file
> +commit_and_check "" "$verb" 64k 64k
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/838.out b/tests/generic/838.out
> new file mode 100644
> index 00000000..cdc29f4b
> --- /dev/null
> +++ b/tests/generic/838.out
> @@ -0,0 +1,33 @@
> +QA output created by 838
> +Test 1 - qa_user, non-exec file fcollapse
> +6666 -rwSrwSrw- TEST_DIR/838/a
> +666 -rw-rw-rw- TEST_DIR/838/a
> +
> +Test 2 - qa_user, group-exec file fcollapse
> +6676 -rwSrwsrw- TEST_DIR/838/a
> +676 -rw-rwxrw- TEST_DIR/838/a
> +
> +Test 3 - qa_user, user-exec file fcollapse
> +6766 -rwsrwSrw- TEST_DIR/838/a
> +766 -rwxrw-rw- TEST_DIR/838/a
> +
> +Test 4 - qa_user, all-exec file fcollapse
> +6777 -rwsrwsrwx TEST_DIR/838/a
> +777 -rwxrwxrwx TEST_DIR/838/a
> +
> +Test 5 - root, non-exec file fcollapse
> +6666 -rwSrwSrw- TEST_DIR/838/a
> +6666 -rwSrwSrw- TEST_DIR/838/a
> +
> +Test 6 - root, group-exec file fcollapse
> +6676 -rwSrwsrw- TEST_DIR/838/a
> +6676 -rwSrwsrw- TEST_DIR/838/a
> +
> +Test 7 - root, user-exec file fcollapse
> +6766 -rwsrwSrw- TEST_DIR/838/a
> +6766 -rwsrwSrw- TEST_DIR/838/a
> +
> +Test 8 - root, all-exec file fcollapse
> +6777 -rwsrwsrwx TEST_DIR/838/a
> +6777 -rwsrwsrwx TEST_DIR/838/a
> +
> diff --git a/tests/generic/839 b/tests/generic/839
> new file mode 100755
> index 00000000..14a94352
> --- /dev/null
> +++ b/tests/generic/839
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 839
> +#
> +# Functional test for dropping capability bits as part of an fallocate.
> +#
> +. ./common/preamble
> +_begin_fstest auto prealloc quick
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $junk_dir
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_user
> +_require_command "$GETCAP_PROG" getcap
> +_require_command "$SETCAP_PROG" setcap
> +_require_xfs_io_command falloc
> +_require_test
> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +
> +setup_testfile() {
> +	rm -f $junk_file
> +	touch $junk_file
> +	chmod a+rwx $junk_file
> +	$SETCAP_PROG cap_setgid,cap_setuid+ep $junk_file
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +	_getcap -v $junk_file | _filter_test_dir
> +
> +	local cmd="$XFS_IO_PROG -c 'falloc 0 64k' $junk_file"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $junk_file | _filter_test_dir
> +	_getcap -v $junk_file | _filter_test_dir
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +# Commit by an unprivileged user clears capability bits.
> +echo "Test 1 - qa_user"
> +setup_testfile
> +commit_and_check "$qa_user"
> +
> +# Commit by root leaves capability bits.
> +echo "Test 2 - root"
> +setup_testfile
> +commit_and_check
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/839.out b/tests/generic/839.out
> new file mode 100755
> index 00000000..f571cd26
> --- /dev/null
> +++ b/tests/generic/839.out
> @@ -0,0 +1,13 @@
> +QA output created by 839
> +Test 1 - qa_user
> +777 -rwxrwxrwx TEST_DIR/839/a
> +TEST_DIR/839/a cap_setgid,cap_setuid=ep
> +777 -rwxrwxrwx TEST_DIR/839/a
> +TEST_DIR/839/a
> +
> +Test 2 - root
> +777 -rwxrwxrwx TEST_DIR/839/a
> +TEST_DIR/839/a cap_setgid,cap_setuid=ep
> +777 -rwxrwxrwx TEST_DIR/839/a
> +TEST_DIR/839/a
> +
> 

