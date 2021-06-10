Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A3AC48BD1
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD9D613BC
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 08:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFJIqc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 04:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJIqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 04:46:32 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AAAC061574;
        Thu, 10 Jun 2021 01:44:20 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z26so1024281pfj.5;
        Thu, 10 Jun 2021 01:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=lVsvKiiR7CxPrj5T7GKiZgcGE780r8EQFR9Wnscdrh8=;
        b=F68Otecm9ecMAMQaK7J3XDPjrjoQVtHFe11iGnimWiyKl0vAV4bGKikrlTfPGxBR/p
         hcLqSOxFwrwR3Nj2cCjHXbBI4b6sa4kIku/jPJBzelF727WTs3AEMFyN53AbqF+HaALy
         gy9pzt6fAYpZxi6YyDF8TwpcENjicCJKDRe2lzIBaVsnhC54Z9b3f3h7ChKAUtIkpNrj
         sPBEESh95diMN9vJaVYplKQXt2Ufbu0lgYALYdimSzwjYFbj4kmNa4OLIIr/+BmbAhP1
         Ue6Xq0mqSOu1LOz5lEOkokHnU3+hJP+Bz+dgfUAmiZ+zX60aQrU9qYxSMc3Z3o9jufWI
         lBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=lVsvKiiR7CxPrj5T7GKiZgcGE780r8EQFR9Wnscdrh8=;
        b=tyD/GkYTyWpiWud4+6885A3iysXXj0J8paq57SoU0/u3lPOAqKM8qQG5Wu+7YDIASi
         /oXYsuBObw22Co1xTQuYMKnMqyf+w63QwOrRC0oa0R5CSHQTF3SZ1fLWz31MmGKkazDt
         QPrOp6xQqLTvKj39DLhiPruZRNe06diqnixU9ZGogMBDu+Xw4hv8AhkKt1gq5HxsU+KH
         wLrOCIfHVMkdaac2Ba4jqp6cS0tlO+wA8WwyDcdczMmEh2FAcUua5cJjsIwCmmPKLcWk
         fm5Fh7crXmiKrlMDudkkB6IU1620MniV5XCAjIFuF45bP0ZtvqbKaZ4rE2r9e8i8JY7R
         9Ocw==
X-Gm-Message-State: AOAM5314+hpZqWFAv/O1cDiOWon53LIIB6jddhKUeFL6abWd50tzNlgA
        CPbzeKDDrA5sdSuv8TzpEAk=
X-Google-Smtp-Source: ABdhPJwcIPjZGC7tuqr0zBxM8csanMZV5+yNt6ITjdIPG3s/Qm3kSrzcJ+KBLDEkKU/Std8+2wEllQ==
X-Received: by 2002:a63:d403:: with SMTP id a3mr3962421pgh.175.1623314659893;
        Thu, 10 Jun 2021 01:44:19 -0700 (PDT)
Received: from garuda ([122.171.171.192])
        by smtp.gmail.com with ESMTPSA id d15sm1762151pfd.35.2021.06.10.01.44.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Jun 2021 01:44:19 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317278412.653489.8220326541398463657.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 04/13] fstests: add tool migrate group membership data to test files
In-reply-to: <162317278412.653489.8220326541398463657.stgit@locust>
Date:   Thu, 10 Jun 2021 14:14:16 +0530
Message-ID: <87v96mp0rj.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Create a tool to migrate the mapping of tests <-> groups out of the
> group file and into the individual test file as a _begin_fstest
> call.  In the next patches we'll rewrite all the test files and auto
> generate the group files from the tests.
>

The code looks to be logically correct.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tools/convert-group |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100755 tools/convert-group
>
>
> diff --git a/tools/convert-group b/tools/convert-group
> new file mode 100755
> index 00000000..42a99fe5
> --- /dev/null
> +++ b/tools/convert-group
> @@ -0,0 +1,131 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +
> +# Move group tags from the groups file into the test files themselves.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +	echo "Usage: $0 test_dir [test_dirs...]"
> +	exit 1
> +fi
> +
> +obliterate_group_file() {
> +	sed -e 's/^#.*$//g' < group | while read test groups; do
> +		if [ -z "$test" ]; then
> +			continue;
> +		elif [ ! -e "$test" ]; then
> +			echo "Ignoring unknown test file \"$test\"."
> +			continue
> +		fi
> +
> +		# Replace all the open-coded test preparation code with a
> +		# single call to _begin_fstest.
> +		sed -e '/^seqres=\$RESULT_DIR\/\$seq$/d' \
> +		    -e '/^seqres=\"\$RESULT_DIR\/\$seq\"$/d' \
> +		    -e '/^echo "QA output created by \$seq"$/d' \
> +		    -e '/^here=`pwd`$/d' \
> +		    -e '/^here=\$(pwd)$/d' \
> +		    -e '/^here=\$PWD$/d' \
> +		    -e '/^here=\"`pwd`\"$/d' \
> +		    -e '/^tmp=\/tmp\/\$\$$/d' \
> +		    -e '/^status=1.*failure.*is.*the.*default/d' \
> +		    -e '/^status=1.*FAILure.*is.*the.*default/d' \
> +		    -e '/^status=1.*success.*is.*the.*default/d' \
> +		    -e '/^status=1.*default.*failure/d' \
> +		    -e '/^echo.*QA output created by.*seq/d' \
> +		    -e '/^# remove previous \$seqres.full before test/d' \
> +		    -e '/^rm -f \$seqres.full/d' \
> +		    -e 's|^# get standard environment, filters and checks|# Import common functions.|g' \
> +		    -e '/^\. \.\/common\/rc/d' \
> +		    -e '/^\. common\/rc/d' \
> +		    -e 's|^seq=.*$|. ./common/preamble\n_begin_fstest '"$groups"'|g' \
> +		    -i "$test"
> +
> +		# Replace the open-coded trap calls that register cleanup code
> +		# with a call to _register_cleanup.
> +		#
> +		# For tests that registered empty-string cleanups or open-coded
> +		# calls to remove $tmp files, remove the _register_cleanup
> +		# calls entirely because the default _cleanup does that for us.
> +		#
> +		# For tests that now have a _register_cleanup call for the
> +		# _cleanup function, remove the explicit call because
> +		# _begin_fstest already registers that for us.
> +		#
> +		# For tests that override _cleanup, insert a comment noting
> +		# that it is overriding the default, to match the ./new
> +		# template.
> +		sed -e 's|^trap "exit \\\$status" 0 1 2 3 15|_register_cleanup ""|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap '"'"'\(.*\)[[:space:]]*; exit \$status'"'"' 0 1 2 3 15|_register_cleanup "\1"|g' \
> +		    -e 's|^trap "\(.*\)[[:space:]]*; exit \\\$status" 0 1 2 3 7 15|_register_cleanup "\1" BUS|g' \
> +		    -e 's|^_register_cleanup "[[:space:]]*\([^[:space:]]*\)[[:space:]]*"|_register_cleanup "\1"|g' \
> +		    -e '/^_register_cleanup ""$/d' \
> +		    -e '/^_register_cleanup "rm -f \$tmp.*"$/d' \
> +		    -e '/^_register_cleanup "_cleanup"$/d' \
> +		    -e 's|^_cleanup()|# Override the default cleanup function.\n_cleanup()|g' \
> +		    -i "$test"
> +
> +		# If the test doesn't import any common functionality,
> +		# get rid of the pointless comment.
> +		if ! grep -q '^\. .*common' "$test"; then
> +			sed -e '/^# Import common functions.$/d' -i "$test"
> +		fi
> +
> +		# Replace the "status=1" lines that don't have the usual
> +		# "failure is the default" message if there's no other code
> +		# between _begin_fstest and status=1.
> +		if grep -q '^status=1$' "$test"; then
> +			awk '
> +BEGIN {
> +	saw_groupinfo = 0;
> +}
> +{
> +	if ($0 ~ /^_begin_fstest/) {
> +		saw_groupinfo = 1;
> +		printf("%s\n", $0);
> +	} else if ($0 ~ /^status=1$/) {
> +		if (saw_groupinfo == 0) {
> +			printf("%s\n", $0);
> +		}
> +	} else if ($0 == "") {
> +		printf("\n");
> +	} else {
> +		saw_groupinfo = 0;
> +		printf("%s\n", $0);
> +	}
> +}
> +' < "$test" > "$test.new"
> +			cat "$test.new" > "$test"
> +			rm -f "$test.new"
> +		fi
> +
> +		# Collapse sequences of blank lines to a single blank line.
> +		awk '
> +BEGIN {
> +	saw_blank = 0;
> +}
> +{
> +	if ($0 ~ /^$/) {
> +		if (saw_blank == 0) {
> +			printf("\n");
> +			saw_blank = 1;
> +		}
> +	} else {
> +		printf("%s\n", $0);
> +		saw_blank = 0;
> +	}
> +}
> +' < "$test" > "$test.new"
> +		cat "$test.new" > "$test"
> +		rm -f "$test.new"
> +	done
> +}
> +
> +curr_dir="$PWD"
> +for tdir in "$@"; do
> +	cd "tests/$tdir"
> +	obliterate_group_file
> +	cd "$curr_dir"
> +done


-- 
chandan
