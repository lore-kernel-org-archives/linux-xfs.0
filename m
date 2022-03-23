Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD77FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 03:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiCWDIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 23:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiCWDIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 23:08:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76FE370877
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 20:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648004825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PRLIGhRIzRWp0EW+2x2uQlxVZBsyaMC4COEjifcFBXI=;
        b=hh62ozpgurvN/iaKgc3+DhCbZ8IYvvBBnOrBrDvQ4ktorPJ4JSLeVwjgTzL/y0L00ZNpe0
        2uy2NwqKF1RfA3W0bc3VlxIGIY7R1/xwODVgbdWJ/Fed+OC22loTL3DVCJd2jKw1pjB7vD
        2xZshONrD1lB1RE/xgIfgw7oES8VTHs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-UqXNROspMC6mtt8pGo1fHg-1; Tue, 22 Mar 2022 23:07:04 -0400
X-MC-Unique: UqXNROspMC6mtt8pGo1fHg-1
Received: by mail-pj1-f69.google.com with SMTP id n17-20020a17090ac69100b001c77ebd900fso326904pjt.8
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 20:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=PRLIGhRIzRWp0EW+2x2uQlxVZBsyaMC4COEjifcFBXI=;
        b=NEZQ9IKbOzYWK/u7TiPfBfYWwjcArIwlNZeKK2HmkJZ9QI4UYri/cfwgOWagcR/g4v
         Ue8R7GmvmXi20jmJG41xTFzOPLEiqXtdsB+O6EeBCI362YK0iP3rZYeY0TSrK6wDuZp9
         9pQvGQRpsU/VnUvwsaxrr2mg5JTsYdx9gcqkrHNHccud8hxIkcHxnKptjbnoxBd2jtjm
         Sp8AMcHGfadqrQ4SYlTlabGf6aLB6OuGRPbFWu8yLanAX98YZuK5asmXGYTI2TgvN5CS
         puZvEOVqDiuiPeF7WVqdKmjemxqNMFf+AXpzAA4gz17nHLcTD6D+mG0avp4uSGnPviMW
         dkXw==
X-Gm-Message-State: AOAM533VtLavs9bCIXi27RtctEZnWVshgQHz2P8vpombPo6echFiTa9W
        vMzdTizRbZBaNqbkWaim8fSPW6O3w0gDgTMUeczCogMmkBjmPQEqFcAb8VBemdGOOAH5PdPasqh
        E+LIRICZYp+g2vbSW0x1x
X-Received: by 2002:a17:90b:4d88:b0:1c7:3d39:34c5 with SMTP id oj8-20020a17090b4d8800b001c73d3934c5mr8833944pjb.20.1648004822876;
        Tue, 22 Mar 2022 20:07:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbeyLyr5cugwEv0XS5E5bn0B/ngiBFkFTaVRzJjJ8wlyzFH3nFl8XRXTyG7xoDtsdb05KLKw==
X-Received: by 2002:a17:90b:4d88:b0:1c7:3d39:34c5 with SMTP id oj8-20020a17090b4d8800b001c73d3934c5mr8833929pjb.20.1648004822553;
        Tue, 22 Mar 2022 20:07:02 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id pj9-20020a17090b4f4900b001c744034e7csm4359658pjb.2.2022.03.22.20.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 20:07:01 -0700 (PDT)
Date:   Wed, 23 Mar 2022 11:06:57 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic: ensure we drop suid after fallocate
Message-ID: <20220323030657.5al7wlxsvjzybbg3@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164740142940.3371809.12686819717405148022.stgit@magnolia>
 <164740144051.3371809.17116490105069526891.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164740144051.3371809.17116490105069526891.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 08:30:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> fallocate changes file contents, so make sure that we drop privileges
> and file capabilities after each fallocate operation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/834     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/834.out |   33 +++++++++++++
>  tests/generic/835     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/835.out |   33 +++++++++++++
>  tests/generic/836     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/836.out |   33 +++++++++++++
>  tests/generic/837     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/837.out |   33 +++++++++++++
>  tests/generic/838     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/838.out |   33 +++++++++++++
>  tests/generic/839     |   79 ++++++++++++++++++++++++++++++
>  tests/generic/839.out |   13 +++++
>  12 files changed, 902 insertions(+)
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
> index 00000000..27552221
> --- /dev/null
> +++ b/tests/generic/834
> @@ -0,0 +1,129 @@
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
> +_require_user
> +_require_test
> +verb=falloc
> +_require_xfs_io_command $verb
> +
> +_require_congruent_file_oplen $TEST_DIR 65536
      ^^

Is it a Darrick's unpublic secret weapon:)

> +
> +junk_dir=$TEST_DIR/$seq
> +junk_file=$junk_dir/a
> +mkdir -p $junk_dir/
> +chmod a+rw $junk_dir/
> +

[snip] ...

> diff --git a/tests/generic/839 b/tests/generic/839
> new file mode 100755
> index 00000000..a1e23916
> --- /dev/null
> +++ b/tests/generic/839
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 839
> +#
> +# Functional test for dropping capability bits as part of an fallocate.
> +#
> +. ./common/preamble
> +_begin_fstest auto fiexchange swapext quick
                        ^^         ^^

I think we don't have these two group names currently, this will cause failure.
You can register them if you need :)

Thanks,
Zorro

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
> +_require_congruent_file_oplen $TEST_DIR 65536
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

