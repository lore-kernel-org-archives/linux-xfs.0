Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C574EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 00:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjGZAF4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 20:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjGZAFz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 20:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09687C0;
        Tue, 25 Jul 2023 17:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DDA7615F0;
        Wed, 26 Jul 2023 00:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC934C433C8;
        Wed, 26 Jul 2023 00:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690329953;
        bh=ckqKZBajGndHKL8dU0UR+69o5fMC3VP6lDaHzVTGc5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qs+jGV4g33zUxeZ5af1tEh4nUSJ8Q70FtBCUA6i8ytkNCwAtyahQwI+JWCc5epF1T
         vQVklU+DfvxqzAsZvLLCTKZm7Bt+Bf9XB+iGcBuiNiH8DOMyvHagpCXSs8/x2laqiT
         0BJbb7Z3/NNAUqcutlYqIMcLsoVaB/l6iMxatyscnCntjwqfiyMQ+q6FEVlCk/x60A
         LX4KxXeU54HOVRWHjd+NIdd6zUu55zFUbjqvUB6jYs1dDWhPG7F8tIpT7Gm3XUbVMP
         sAuGGUHD4QXfLYQAoa78xxUUChv7MKLvf4r7wprXsOtuXjzPkXWpxRphebQQhPjNJo
         e/fexoGIBl3ag==
Date:   Tue, 25 Jul 2023 17:05:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: generate gcov code coverage reports at the
 end of each section
Message-ID: <20230726000552.GH11340@frogsfrogsfrogs>
References: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
 <168972906191.1698606.10738894314642211560.stgit@frogsfrogsfrogs>
 <20230719161916.qne7ng4lnu32pw3w@zlang-mailbox>
 <20230720022924.GI11352@frogsfrogsfrogs>
 <20230720142429.pp4rv7xqjnaqlfmb@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720142429.pp4rv7xqjnaqlfmb@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2023 at 10:24:29PM +0800, Zorro Lang wrote:
> On Wed, Jul 19, 2023 at 07:29:24PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 20, 2023 at 12:19:16AM +0800, Zorro Lang wrote:
> > > On Tue, Jul 18, 2023 at 06:11:01PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Support collecting kernel code coverage information as reported in
> > > > debugfs.  At the start of each section, we reset the gcov counters;
> > > > during the section wrapup, we'll collect the kernel gcov data.
> > > > 
> > > > If lcov is installed and the kernel source code is available, it will
> > > > also generate a nice html report.  If a CLI web browser is available, it
> > > > will also format the html report into text for easy grepping.
> > > > 
> > > > This requires the test runner to set REPORT_GCOV=1 explicitly and gcov
> > > > to be enabled in the kernel.
> > > > 
> > > > Cc: tytso@mit.edu
> > > > Cc: kent.overstreet@linux.dev
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > Hi Darrick,
> > > 
> > > Is that possible to split this function from check script to tools/ ?
> > 
> > I don't mind separating it, though I don't see much reason to.  Are you
> > concerned about ./check growing larger?
> 
> Yeah, a little bit, the check script become smore and more complicated.

Ok, I'll do that, and augment the documentation for patch 1/1.

--D

> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  README |    3 ++
> > > >  check  |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 89 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/README b/README
> > > > index 9790334db1..ccfdcbe703 100644
> > > > --- a/README
> > > > +++ b/README
> > > > @@ -249,6 +249,9 @@ Kernel/Modules related configuration:
> > > >     to "forever" and we'll wait forever until the module is gone.
> > > >   - Set KCONFIG_PATH to specify your preferred location of kernel config
> > > >     file. The config is used by tests to check if kernel feature is enabled.
> > > > + - Set REPORT_GCOV to a directory path to make lcov and genhtml generate
> > > > +   html reports from any gcov code coverage data collected by the kernel.
> > > > +   If REPORT_GCOV is set to 1, the report will be written to $REPORT_DIR/gcov/.
> > > >  
> > > >  Test control:
> > > >   - Set LOAD_FACTOR to a nonzero positive integer to increase the amount of
> > > > diff --git a/check b/check
> > > > index 97c7c4c7d1..3e6f27c653 100755
> > > > --- a/check
> > > > +++ b/check
> > > > @@ -451,6 +451,87 @@ _global_log() {
> > > >  	fi
> > > >  }
> > > >  
> > > > +GCOV_DIR=/sys/kernel/debug/gcov
> > > > +
> > > > +# Find the topmost directories of the .gcno directory hierarchy
> > > > +_gcov_find_topdirs() {
> > > > +	find "${GCOV_DIR}/" -name '*.gcno' -printf '%d|%h\n' | \
> > > > +		sort -g -k 1 | \
> > > > +		uniq | \
> > > > +		$AWK_PROG -F '|' 'BEGIN { x = -1 } { if (x < 0) x = $1; if ($1 == x) printf("%s\n", $2);}'
> > > > +}
> > > > +
> > > > +# Generate lcov html report from kernel gcov data if configured
> > > > +_gcov_generate_report() {
> > > > +	unset REPORT_GCOV	# don't trigger multiple times if ^C
> > > > +
> > > > +	local output_dir="$1"
> > > > +	test -n "${output_dir}" || return
> > > > +	test "$output_dir" = "1" && output_dir="$REPORT_DIR/gcov"
> > > > +
> > > > +	# Kernel support built in?
> > > > +	test -d "$GCOV_DIR" || return
> > > > +
> > > > +	readarray -t gcno_dirs < <(_gcov_find_topdirs)
> > > > +	test "${#gcno_dirs[@]}" -gt 0 || return
> > > > +
> > > > +	mkdir -p "${output_dir}/"
> > > > +
> > > > +	# Collect raw coverage data from the kernel
> > > > +	readarray -t source_dirs < <(find "${GCOV_DIR}/" -mindepth 1 -maxdepth 1 -type d)
> > > > +	for dir in "${source_dirs[@]}"; do
> > > > +		cp -p -R -d -u "${dir}" "${output_dir}/"
> > > > +	done
> > > > +
> > > > +	# If lcov is installed, use it to summarize the gcda data.
> > > > +	# If it is not installed, there's no point in going forward
> > > > +	command -v lcov > /dev/null || return
> > > > +	local lcov=(lcov --exclude 'include*' --capture)
> > > > +	lcov+=(--output-file "${output_dir}/gcov.report")
> > > > +	for d in "${gcno_dirs[@]}"; do
> > > > +		lcov+=(--directory "${d}")
> > > > +	done
> > > > +
> > > > +	# Generate a detailed HTML report from the summary
> > > > +	local gcov_start_time="$(date --date="${fstests_start_time:-now}")"
> > > > +	local genhtml=()
> > > > +	if command -v genhtml > /dev/null; then
> > > > +		genhtml+=(genhtml -o "${output_dir}/" "${output_dir}/gcov.report")
> > > > +		genhtml+=(--title "fstests on $(hostname -s) @ ${gcov_start_time}" --legend)
> > > > +	fi
> > > > +
> > > > +	# Try to convert the HTML report summary as text for easier grepping if
> > > > +	# there's an HTML renderer present
> > > > +	local totext=()
> > > > +	test "${#totext[@]}" -eq 0 && \
> > > > +		command -v lynx &>/dev/null && \
> > > > +		totext=(lynx -dump "${output_dir}/index.html" -width 120 -nonumbers -nolist)
> > > > +	test "${#totext[@]}" -eq 0 && \
> > > > +		command -v links &>/dev/null && \
> > > > +		totext=(links -dump "${output_dir}/index.html" -width 120)
> > > > +	test "${#totext[@]}" -eq 0 && \
> > > > +		command -v elinks &>/dev/null && \
> > > > +		totext=(elinks -dump "${output_dir}/index.html" --dump-width 120 --no-numbering --no-references)
> > > > +
> > > > +	# Analyze kernel data
> > > > +	"${lcov[@]}" > "${output_dir}/gcov.stdout" 2> "${output_dir}/gcov.stderr"
> > > > +	test "${#genhtml[@]}" -ne 0 && \
> > > > +		"${genhtml[@]}" >> "${output_dir}/gcov.stdout" 2>> "${output_dir}/gcov.stderr"
> > > > +	test "${#totext[@]}" -ne 0 && \
> > > > +		"${totext[@]}" > "${output_dir}/index.txt" 2>> "${output_dir}/gcov.stderr"
> > > > +}
> > > > +
> > > > +# Reset gcov usage data
> > > > +_gcov_reset() {
> > > > +	test -n "${REPORT_GCOV}" || return
> > > > +
> > > > +	if [ -w "${GCOV_DIR}/reset" ]; then
> > > > +		echo 1 > "${GCOV_DIR}/reset"
> > > > +	else
> > > > +		unset REPORT_GCOV
> > > > +	fi
> > > > +}
> > > > +
> > > >  _wrapup()
> > > >  {
> > > >  	seq="check"
> > > > @@ -527,6 +608,10 @@ _wrapup()
> > > >  					     "${#bad[*]}" "${#notrun[*]}" \
> > > >  					     "$((sect_stop - sect_start))"
> > > >  		fi
> > > > +
> > > > +		# Generate code coverage report
> > > > +		test -n "$REPORT_GCOV" && _gcov_generate_report "$REPORT_GCOV"
> > > > +
> > > >  		needwrap=false
> > > >  	fi
> > > >  
> > > > @@ -801,6 +886,7 @@ function run_section()
> > > >  	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
> > > >  	fi
> > > >  	echo
> > > > +	_gcov_reset
> > > >  	needwrap=true
> > > >  
> > > >  	if [ ! -z "$SCRATCH_DEV" ]; then
> > > > 
> > > 
> > 
> 
