Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A07C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 14:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjG0O6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 10:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjG0O6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 10:58:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A996E127
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 07:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690469866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5QvrHnjk4zCe43gGH6UDMoFcijBkGfubjj3j01pFs0U=;
        b=iXf2fIPaHsfZmStNzJr2FNOq8C4GOZFRLQAbjkSI5sBOrZL0GXRMgL/Jz3vY+rPJatb4/5
        tXQ4cdY+Exmjj4ZjGh0XD5MCWAyoWohXAa8s0M10lkIZgg7BHvYeXZWW2htBgJ7+zhGNrb
        iX8efGFBMw/gv3E0/1WscfUI1AInbSg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-aHQv1wYdPPirPCy4YqL7Xg-1; Thu, 27 Jul 2023 10:57:45 -0400
X-MC-Unique: aHQv1wYdPPirPCy4YqL7Xg-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6826902bc8dso1275215b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 07:57:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690469864; x=1691074664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5QvrHnjk4zCe43gGH6UDMoFcijBkGfubjj3j01pFs0U=;
        b=bni4wdqQQ68FEJK2GLCKgnOQzE1TikFi0JILMEqEWq9o5mGH7PhJdneJQFIZV+fmau
         08xAgdqLD1ziwuk8tEzyisAmi3YMQyKFOSIVZJXdYjmcV8nTBqokSRjCHpkrx2cVZCnz
         YkhQ54amBIxaXNqJsprg5F8pWVVa208zikH+oRAr7QopQ9Fjfgr7gvtmPHuthRUt7hKN
         hsbYC9Fc+gY59ZuK1T8+F0glMDF7lMdpJ0xQFN4fN+mnvq2HtZzukZliDfiABBwm4qkT
         yhdP11oKoTOE/8QVKIGoQoqciQ4wYKvMFxccsnc8BRTXqOh9dokpeNDYANQ+vi1xSmtx
         MMEw==
X-Gm-Message-State: ABy/qLaTcvHgtaw+Mw08tNmgOWsX+GwOgfQilGwHI+CpoH7QvbCrYFkv
        3zQGHGK+XsEO1OR6Et2zL45/kkIvXX8xrerFNyTO4lwwlXefeabuvucd5d4Sdrw+MjYK25jSDr1
        xdfhxR+Z1r3f/IiM53hC7
X-Received: by 2002:a05:6a20:1603:b0:133:17f1:6436 with SMTP id l3-20020a056a20160300b0013317f16436mr3730397pzj.19.1690469864548;
        Thu, 27 Jul 2023 07:57:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEo5XaVjRN7vWm5uxRnqCih/BBTs1A9ZrXeYgkoRWqNJUNg2B0ik6f/TbBKcOLBEouJ2k0Jiw==
X-Received: by 2002:a05:6a20:1603:b0:133:17f1:6436 with SMTP id l3-20020a056a20160300b0013317f16436mr3730371pzj.19.1690469864184;
        Thu, 27 Jul 2023 07:57:44 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g16-20020a62e310000000b00686be6e0f5csm1594633pfh.108.2023.07.27.07.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 07:57:43 -0700 (PDT)
Date:   Thu, 27 Jul 2023 22:57:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: generate gcov code coverage reports at the
 end of each section
Message-ID: <20230727145739.ym22aefkapzf5pwv@zlang-mailbox>
References: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
 <169033661141.3222210.14155623533196891003.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169033661141.3222210.14155623533196891003.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2023 at 06:56:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Support collecting kernel code coverage information as reported in
> debugfs.  At the start of each section, we reset the gcov counters;
> during the section wrapup, we'll collect the kernel gcov data.
> 
> If lcov is installed and the kernel source code is available, it will
> also generate a nice html report.  If a CLI web browser is available, it
> will also format the html report into text for easy grepping.
> 
> This requires the test runner to set REPORT_GCOV=1 explicitly and gcov
> to be enabled in the kernel.
> 
> Cc: tytso@mit.edu
> Cc: kent.overstreet@linux.dev
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This version looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  README      |    3 ++
>  check       |   18 ++++++++++++
>  common/gcov |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 108 insertions(+)
>  create mode 100644 common/gcov
> 
> 
> diff --git a/README b/README
> index d4ec73d10d..966ec48ed6 100644
> --- a/README
> +++ b/README
> @@ -249,6 +249,9 @@ Kernel/Modules related configuration:
>     to "forever" and we'll wait forever until the module is gone.
>   - Set KCONFIG_PATH to specify your preferred location of kernel config
>     file. The config is used by tests to check if kernel feature is enabled.
> + - Set REPORT_GCOV to a directory path to make lcov and genhtml generate
> +   html reports from any gcov code coverage data collected by the kernel.
> +   If REPORT_GCOV is set to 1, the report will be written to $REPORT_DIR/gcov/.
>  
>  Test control:
>   - Set LOAD_FACTOR to a nonzero positive integer to increase the amount of
> diff --git a/check b/check
> index c02e693642..9741be23c4 100755
> --- a/check
> +++ b/check
> @@ -451,6 +451,11 @@ _global_log() {
>  	fi
>  }
>  
> +if [ -n "$REPORT_GCOV" ]; then
> +	. ./common/gcov
> +	_gcov_check_report_gcov
> +fi
> +
>  _wrapup()
>  {
>  	seq="check"
> @@ -527,6 +532,18 @@ _wrapup()
>  					     "${#bad[*]}" "${#notrun[*]}" \
>  					     "$((sect_stop - sect_start))"
>  		fi
> +
> +		# Generate code coverage report
> +		if [ -n "$REPORT_GCOV" ]; then
> +			# don't trigger multiple times if caller hits ^C
> +			local gcov_report_dir="$REPORT_GCOV"
> +			test "$gcov_report_dir" = "1" && \
> +				gcov_report_dir="$REPORT_DIR/gcov"
> +			unset REPORT_GCOV
> +
> +			_gcov_generate_report "$gcov_report_dir"
> +		fi
> +
>  		needwrap=false
>  	fi
>  
> @@ -801,6 +818,7 @@ function run_section()
>  	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
>  	fi
>  	echo
> +	test -n "$REPORT_GCOV" && _gcov_reset
>  	needwrap=true
>  
>  	if [ ! -z "$SCRATCH_DEV" ]; then
> diff --git a/common/gcov b/common/gcov
> new file mode 100644
> index 0000000000..b7e3ed5a93
> --- /dev/null
> +++ b/common/gcov
> @@ -0,0 +1,87 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# Routines for capturing kernel code coverage reports
> +
> +GCOV_DIR=/sys/kernel/debug/gcov
> +
> +# Find the topmost directories of the .gcno directory hierarchy
> +__gcov_find_topdirs() {
> +	find "${GCOV_DIR}/" -name '*.gcno' -printf '%d|%h\n' | \
> +		sort -g -k 1 | \
> +		uniq | \
> +		$AWK_PROG -F '|' 'BEGIN { x = -1 } { if (x < 0) x = $1; if ($1 == x) printf("%s\n", $2);}'
> +}
> +
> +# Generate lcov html report from kernel gcov data if configured
> +_gcov_generate_report() {
> +	local output_dir="$1"
> +	test -n "${output_dir}" || return
> +
> +	# Kernel support built in?
> +	test -d "$GCOV_DIR" || return
> +
> +	readarray -t gcno_dirs < <(__gcov_find_topdirs)
> +	test "${#gcno_dirs[@]}" -gt 0 || return
> +
> +	mkdir -p "${output_dir}/raw/"
> +
> +	# Collect raw coverage data from the kernel
> +	readarray -t source_dirs < <(find "${GCOV_DIR}/" -mindepth 1 -maxdepth 1 -type d)
> +	for dir in "${source_dirs[@]}"; do
> +		cp -p -R -d -u "${dir}" "${output_dir}/raw/"
> +	done
> +
> +	# If lcov is installed, use it to summarize the gcda data.
> +	# If it is not installed, there's no point in going forward
> +	command -v lcov > /dev/null || return
> +	local lcov=(lcov --exclude 'include*' --capture)
> +	lcov+=(--output-file "${output_dir}/gcov.report")
> +	for d in "${gcno_dirs[@]}"; do
> +		lcov+=(--directory "${d}")
> +	done
> +
> +	# Generate a detailed HTML report from the summary
> +	local gcov_start_time="$(date --date="${fstests_start_time:-now}")"
> +	local genhtml=()
> +	if command -v genhtml > /dev/null; then
> +		genhtml+=(genhtml -o "${output_dir}/" "${output_dir}/gcov.report")
> +		genhtml+=(--title "fstests on $(hostname -s) @ ${gcov_start_time}" --legend)
> +	fi
> +
> +	# Try to convert the HTML report summary as text for easier grepping if
> +	# there's an HTML renderer present
> +	local totext=()
> +	test "${#totext[@]}" -eq 0 && \
> +		command -v lynx &>/dev/null && \
> +		totext=(lynx -dump "${output_dir}/index.html" -width 120 -nonumbers -nolist)
> +	test "${#totext[@]}" -eq 0 && \
> +		command -v links &>/dev/null && \
> +		totext=(links -dump "${output_dir}/index.html" -width 120)
> +	test "${#totext[@]}" -eq 0 && \
> +		command -v elinks &>/dev/null && \
> +		totext=(elinks -dump "${output_dir}/index.html" --dump-width 120 --no-numbering --no-references)
> +
> +	# Analyze kernel data
> +	"${lcov[@]}" > "${output_dir}/gcov.stdout" 2> "${output_dir}/gcov.stderr"
> +	test "${#genhtml[@]}" -ne 0 && \
> +		"${genhtml[@]}" >> "${output_dir}/gcov.stdout" 2>> "${output_dir}/gcov.stderr"
> +	test "${#totext[@]}" -ne 0 && \
> +		"${totext[@]}" > "${output_dir}/index.txt" 2>> "${output_dir}/gcov.stderr"
> +}
> +
> +# Reset gcov usage data
> +_gcov_reset() {
> +	echo 1 > "${GCOV_DIR}/reset"
> +}
> +
> +# If the caller wanted us to capture gcov reports but the kernel doesn't
> +# support it, turn it off.
> +_gcov_check_report_gcov() {
> +	test -z "$REPORT_GCOV" && return 0
> +	test -w "${GCOV_DIR}/reset" && return 0
> +
> +	unset REPORT_GCOV
> +	return 1
> +}
> 

