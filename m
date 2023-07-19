Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DE9C001B0
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 16:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjGSQUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjGSQUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 12:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA245172E
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 09:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689783563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Vmv4nvA+TZ6YsiKikqUAavYF5C7EEWbcdxc/T6rZ5s=;
        b=DewyG4fCZKRdw8cskFqL6xmUHtoKpZdow0f+zIjNmy3uaa+QJbj161Pq5Ns0kdELyS8JYH
        pStUENHn1z0i6m2UPs50wYXFPQ/uUEc3g0xt4gIGUf1gruES+32GGtFc7pCgwlGLZei0C9
        Q/W4HQHBHYwxWgHom3fj52OlrftDHbI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-eNNry1lEPha6h1Lc8N9PCA-1; Wed, 19 Jul 2023 12:19:21 -0400
X-MC-Unique: eNNry1lEPha6h1Lc8N9PCA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b9de135bddso34928685ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 09:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689783560; x=1690388360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Vmv4nvA+TZ6YsiKikqUAavYF5C7EEWbcdxc/T6rZ5s=;
        b=YNtwcZITG2HSJCArMJ8FQ8nxw8kDt0/S1BiBgPvF4cduLgENSNv0+2elI6pReacpvS
         VUHAKqudbADzwg2dnSHVOv69ibKCObFzVvnU6WCS0+/8rb9gn8OCFdXyeBasWe5CXVC/
         sE16PLaSx5H0k2JGY0419v+5ibyyuR5t8LwsB8rqPqwS/F5PAn0x5RAPwxSJSHzphQ5c
         cwIkYa8F/01RzxsqAU/XpEttmUqXM6HbBUZyTEiqjlVQKAAICM0cBg9UNUKoXhjPZfnl
         U9vfMxOPy7WtRsZLh7pvJsQWh8Ov0wobG/xKFqZhvDlvJtekLoKYKsd9e+iGrQzb3h+A
         qBVg==
X-Gm-Message-State: ABy/qLbKFxsSC2DnToUqtyfH69EqFUu9SG+Qy0Fo3NN8CnssugM8ffYT
        5ouL0SNK3ubmlv2wIOQU+OwNAH03igCZRgouIwpr2oynBM5Wurk5AykjnUsP7Rnw35kKScEuoMB
        I9gxzHk0sD41YwRR+94p5usprfg9/gSE=
X-Received: by 2002:a17:902:ce91:b0:1b9:e1d6:7c7d with SMTP id f17-20020a170902ce9100b001b9e1d67c7dmr20261839plg.47.1689783560624;
        Wed, 19 Jul 2023 09:19:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFG2p9DklozMDjbocCxKQVPhB95IQxSMcZQPzHBO/gv6vIV9O7E0jyMiNTRuPbOzNUau1gs2Q==
X-Received: by 2002:a17:902:ce91:b0:1b9:e1d6:7c7d with SMTP id f17-20020a170902ce9100b001b9e1d67c7dmr20261816plg.47.1689783560270;
        Wed, 19 Jul 2023 09:19:20 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902bcc100b001a6f7744a27sm4183588pls.87.2023.07.19.09.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 09:19:19 -0700 (PDT)
Date:   Thu, 20 Jul 2023 00:19:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: generate gcov code coverage reports at the
 end of each section
Message-ID: <20230719161916.qne7ng4lnu32pw3w@zlang-mailbox>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972906191.1698606.10738894314642211560.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168972906191.1698606.10738894314642211560.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 06:11:01PM -0700, Darrick J. Wong wrote:
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

Hi Darrick,

Is that possible to split this function from check script to tools/ ?

Thanks,
Zorro

>  README |    3 ++
>  check  |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
> 
> 
> diff --git a/README b/README
> index 9790334db1..ccfdcbe703 100644
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
> index 97c7c4c7d1..3e6f27c653 100755
> --- a/check
> +++ b/check
> @@ -451,6 +451,87 @@ _global_log() {
>  	fi
>  }
>  
> +GCOV_DIR=/sys/kernel/debug/gcov
> +
> +# Find the topmost directories of the .gcno directory hierarchy
> +_gcov_find_topdirs() {
> +	find "${GCOV_DIR}/" -name '*.gcno' -printf '%d|%h\n' | \
> +		sort -g -k 1 | \
> +		uniq | \
> +		$AWK_PROG -F '|' 'BEGIN { x = -1 } { if (x < 0) x = $1; if ($1 == x) printf("%s\n", $2);}'
> +}
> +
> +# Generate lcov html report from kernel gcov data if configured
> +_gcov_generate_report() {
> +	unset REPORT_GCOV	# don't trigger multiple times if ^C
> +
> +	local output_dir="$1"
> +	test -n "${output_dir}" || return
> +	test "$output_dir" = "1" && output_dir="$REPORT_DIR/gcov"
> +
> +	# Kernel support built in?
> +	test -d "$GCOV_DIR" || return
> +
> +	readarray -t gcno_dirs < <(_gcov_find_topdirs)
> +	test "${#gcno_dirs[@]}" -gt 0 || return
> +
> +	mkdir -p "${output_dir}/"
> +
> +	# Collect raw coverage data from the kernel
> +	readarray -t source_dirs < <(find "${GCOV_DIR}/" -mindepth 1 -maxdepth 1 -type d)
> +	for dir in "${source_dirs[@]}"; do
> +		cp -p -R -d -u "${dir}" "${output_dir}/"
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
> +	test -n "${REPORT_GCOV}" || return
> +
> +	if [ -w "${GCOV_DIR}/reset" ]; then
> +		echo 1 > "${GCOV_DIR}/reset"
> +	else
> +		unset REPORT_GCOV
> +	fi
> +}
> +
>  _wrapup()
>  {
>  	seq="check"
> @@ -527,6 +608,10 @@ _wrapup()
>  					     "${#bad[*]}" "${#notrun[*]}" \
>  					     "$((sect_stop - sect_start))"
>  		fi
> +
> +		# Generate code coverage report
> +		test -n "$REPORT_GCOV" && _gcov_generate_report "$REPORT_GCOV"
> +
>  		needwrap=false
>  	fi
>  
> @@ -801,6 +886,7 @@ function run_section()
>  	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
>  	fi
>  	echo
> +	_gcov_reset
>  	needwrap=true
>  
>  	if [ ! -z "$SCRATCH_DEV" ]; then
> 

