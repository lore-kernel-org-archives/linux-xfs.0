Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FBAC28CF5
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 05:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiAZF4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 00:56:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48935 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233890AbiAZF4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 00:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643176609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bj2S/JJ6eyENiz0rf8wZV8ezKcHdL+x37eQu9Oxk7W8=;
        b=cxRV1r3afJpkfe41O3YYThAc8xOVad4rTX/+Xd8ae4fv7HSavbIZ+vuSfuAk+xCduI1gQ1
        4/dw3wzSl/RUJXud5ivGAL8JQETkBry3kd7AatmtlZzyIZRUFggSYlcLQX0oWRcv9NKAme
        Y6zjZSJ/cWkaL/jH31GvZZhLOquf0fc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-pHnyK6_8PVm-5Q8fZQHXYA-1; Wed, 26 Jan 2022 00:56:47 -0500
X-MC-Unique: pHnyK6_8PVm-5Q8fZQHXYA-1
Received: by mail-pg1-f200.google.com with SMTP id 127-20020a630585000000b0035de5e88314so6102657pgf.2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jan 2022 21:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=bj2S/JJ6eyENiz0rf8wZV8ezKcHdL+x37eQu9Oxk7W8=;
        b=U/y/PL0a4Bgsu5k6iRodzsUoMYftVGTZHLpUgaQEUniOekJQsvy3MVnBzY+M1G1gjz
         MVTwmCTsT3iduIQmM+dX+JjDSolgGLjHjuT0DI1iyg0q1bBM4QpHjy6Wdtilq3vsoys8
         vIGTgFZh5fP5SGcOVBct/yIHKxQRdYCfnuB62RpSx+whm0SyCbd7zXlyLOn+aT/400b2
         l2d9ypNQTFZQCsIBvdNFKEDo0R5tXuT27OoorpxX1Bm+x9bro22RtGg1MfiJx+nxaPVJ
         O4w1tInLb8/qcW/RHuAQ8xIECmfvcmmaiauEgxuUO9O9uVyHOjI4Bg0L2e9TGYgeDm47
         H1jw==
X-Gm-Message-State: AOAM532Y/EuMbeUjgznuZY077XI4BgD2N23OFz1kmACU2pfXeqO3PUeQ
        03m2+rrUDLXpK1YT8PY6cuKuARDIb8hEy8qThemqouBJLzOUxxP5MqWoT7WDg6vghiLsIs2MvIb
        3EBL5fKsWgbPgl575z7Mg
X-Received: by 2002:a05:6a00:ace:b0:4c5:35c:db8 with SMTP id c14-20020a056a000ace00b004c5035c0db8mr21494132pfl.51.1643176606596;
        Tue, 25 Jan 2022 21:56:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwlprFZ8L1bFGj2hIkYfs6Kvp8rHrIELZuEQp3SIigoO7EVIY97LOy/jVoECzQEHr2MynjgFw==
X-Received: by 2002:a05:6a00:ace:b0:4c5:35c:db8 with SMTP id c14-20020a056a000ace00b004c5035c0db8mr21494107pfl.51.1643176606181;
        Tue, 25 Jan 2022 21:56:46 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mh1sm2019756pjb.29.2022.01.25.21.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 21:56:45 -0800 (PST)
Date:   Wed, 26 Jan 2022 13:56:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic: test suid/sgid behavior with reflink and
 dedupe
Message-ID: <20220126055641.wnyawz3ooeqnwefi@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
 <164316310910.2594527.6072232851001636761.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164316310910.2594527.6072232851001636761.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 06:11:49PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that we drop the setuid and setgid bits any time reflink or
> dedupe change the file contents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/950     |  108 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/950.out |   49 ++++++++++++++++++++
>  tests/generic/951     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/951.out |   49 ++++++++++++++++++++
>  tests/generic/952     |   71 +++++++++++++++++++++++++++++
>  tests/generic/952.out |   13 +++++
>  6 files changed, 408 insertions(+)
>  create mode 100755 tests/generic/950
>  create mode 100644 tests/generic/950.out
>  create mode 100755 tests/generic/951
>  create mode 100644 tests/generic/951.out
>  create mode 100755 tests/generic/952
>  create mode 100644 tests/generic/952.out
> 
> 
> diff --git a/tests/generic/950 b/tests/generic/950
> new file mode 100755
> index 00000000..84f1d1f0
> --- /dev/null
> +++ b/tests/generic/950
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 950
> +#
> +# Functional test for dropping suid and sgid bits as part of a reflink.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
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
> +_require_scratch_reflink
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576

Is this a Darrick's secret helper ? :)

Thanks,
Zorro

> +chmod a+rw $SCRATCH_MNT/
> +
> +setup_testfile() {
> +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> +	chmod a+r $SCRATCH_MNT/b
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +
> +	md5sum $SCRATCH_MNT/a | _filter_scratch
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +
> +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	_scratch_cycle_mount
> +	md5sum $SCRATCH_MNT/a | _filter_scratch
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> +# sgid.
> +echo "Test 1 - qa_user, non-exec file"
> +setup_testfile
> +chmod a+rws $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> +echo "Test 2 - qa_user, group-exec file"
> +setup_testfile
> +chmod g+x,a+rws $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> +echo "Test 3 - qa_user, user-exec file"
> +setup_testfile
> +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> +echo "Test 4 - qa_user, all-exec file"
> +setup_testfile
> +chmod a+rwxs $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +echo "Test 5 - root, non-exec file"
> +setup_testfile
> +chmod a+rws $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +echo "Test 6 - root, group-exec file"
> +setup_testfile
> +chmod g+x,a+rws $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +echo "Test 7 - root, user-exec file"
> +setup_testfile
> +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +echo "Test 8 - root, all-exec file"
> +setup_testfile
> +chmod a+rwxs $SCRATCH_MNT/a
> +commit_and_check
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/950.out b/tests/generic/950.out
> new file mode 100644
> index 00000000..b42e4931
> --- /dev/null
> +++ b/tests/generic/950.out
> @@ -0,0 +1,49 @@
> +QA output created by 950
> +Test 1 - qa_user, non-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +2666 -rw-rwSrw- SCRATCH_MNT/a
> +
> +Test 2 - qa_user, group-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +676 -rw-rwxrw- SCRATCH_MNT/a
> +
> +Test 3 - qa_user, user-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +2766 -rwxrwSrw- SCRATCH_MNT/a
> +
> +Test 4 - qa_user, all-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +777 -rwxrwxrwx SCRATCH_MNT/a
> +
> +Test 5 - root, non-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +
> +Test 6 - root, group-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +
> +Test 7 - root, user-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +
> +Test 8 - root, all-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +
> diff --git a/tests/generic/951 b/tests/generic/951
> new file mode 100755
> index 00000000..99f67ab7
> --- /dev/null
> +++ b/tests/generic/951
> @@ -0,0 +1,118 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 951
> +#
> +# Functional test for dropping suid and sgid bits as part of a deduplication.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
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
> +_require_scratch_reflink
> +_require_xfs_io_command dedupe
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> +chmod a+rw $SCRATCH_MNT/
> +
> +setup_testfile() {
> +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
> +	chmod a+r $SCRATCH_MNT/b
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +
> +	md5sum $SCRATCH_MNT/a | _filter_scratch
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +
> +	local before_freesp=$(_get_available_space $SCRATCH_MNT)
> +
> +	local cmd="$XFS_IO_PROG -c 'dedupe $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	_scratch_cycle_mount
> +	md5sum $SCRATCH_MNT/a | _filter_scratch
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +
> +	local after_freesp=$(_get_available_space $SCRATCH_MNT)
> +
> +	echo "before: $before_freesp; after: $after_freesp" >> $seqres.full
> +	if [ $after_freesp -le $before_freesp ]; then
> +		echo "expected more free space after dedupe"
> +	fi
> +
> +	# Blank line in output
> +	echo
> +}
> +
> +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> +# sgid.
> +echo "Test 1 - qa_user, non-exec file"
> +setup_testfile
> +chmod a+rws $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> +echo "Test 2 - qa_user, group-exec file"
> +setup_testfile
> +chmod g+x,a+rws $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> +echo "Test 3 - qa_user, user-exec file"
> +setup_testfile
> +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> +echo "Test 4 - qa_user, all-exec file"
> +setup_testfile
> +chmod a+rwxs $SCRATCH_MNT/a
> +commit_and_check "$qa_user"
> +
> +# Commit to a non-exec file by root clears suid but leaves sgid.
> +echo "Test 5 - root, non-exec file"
> +setup_testfile
> +chmod a+rws $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a group-exec file by root clears suid and sgid.
> +echo "Test 6 - root, group-exec file"
> +setup_testfile
> +chmod g+x,a+rws $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a user-exec file by root clears suid but not sgid.
> +echo "Test 7 - root, user-exec file"
> +setup_testfile
> +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> +commit_and_check
> +
> +# Commit to a all-exec file by root clears suid and sgid.
> +echo "Test 8 - root, all-exec file"
> +setup_testfile
> +chmod a+rwxs $SCRATCH_MNT/a
> +commit_and_check
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/951.out b/tests/generic/951.out
> new file mode 100644
> index 00000000..f7099ea2
> --- /dev/null
> +++ b/tests/generic/951.out
> @@ -0,0 +1,49 @@
> +QA output created by 951
> +Test 1 - qa_user, non-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +
> +Test 2 - qa_user, group-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +
> +Test 3 - qa_user, user-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +
> +Test 4 - qa_user, all-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +
> +Test 5 - root, non-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6666 -rwSrwSrw- SCRATCH_MNT/a
> +
> +Test 6 - root, group-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6676 -rwSrwsrw- SCRATCH_MNT/a
> +
> +Test 7 - root, user-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6766 -rwsrwSrw- SCRATCH_MNT/a
> +
> +Test 8 - root, all-exec file
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> +6777 -rwsrwsrwx SCRATCH_MNT/a
> +
> diff --git a/tests/generic/952 b/tests/generic/952
> new file mode 100755
> index 00000000..470d73bd
> --- /dev/null
> +++ b/tests/generic/952
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 952
> +#
> +# Functional test for dropping suid and sgid capabilities as part of a reflink.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone quick
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
> +_require_command "$GETCAP_PROG" getcap
> +_require_command "$SETCAP_PROG" setcap
> +_require_scratch_reflink
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> +chmod a+rw $SCRATCH_MNT/
> +
> +setup_testfile() {
> +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> +	chmod a+rwx $SCRATCH_MNT/a $SCRATCH_MNT/b
> +	$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/a
> +	sync
> +}
> +
> +commit_and_check() {
> +	local user="$1"
> +
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
> +
> +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> +	if [ -n "$user" ]; then
> +		su - "$user" -c "$cmd" >> $seqres.full
> +	else
> +		$SHELL -c "$cmd" >> $seqres.full
> +	fi
> +
> +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
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
> diff --git a/tests/generic/952.out b/tests/generic/952.out
> new file mode 100644
> index 00000000..eac9e76a
> --- /dev/null
> +++ b/tests/generic/952.out
> @@ -0,0 +1,13 @@
> +QA output created by 952
> +Test 1 - qa_user
> +777 -rwxrwxrwx SCRATCH_MNT/a
> +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> +777 -rwxrwxrwx SCRATCH_MNT/a
> +SCRATCH_MNT/a
> +
> +Test 2 - root
> +777 -rwxrwxrwx SCRATCH_MNT/a
> +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> +777 -rwxrwxrwx SCRATCH_MNT/a
> +SCRATCH_MNT/a
> +
> 

