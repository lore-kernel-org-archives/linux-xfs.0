Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE4AEEB3;
	Mon,  6 Jan 2025 23:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736207561; cv=none; b=lI43gSco7nvuddXxcqkoArWN/k1VATCelyX3fPGNcJbUabnrGePjtO6un0g4QtEaD5Qq3aWX12TMSJo6G2b/ebmiwf3Zbw6vEMkxV2AngzTAvEEnvTYvZn3imSvBRcAPubtizRpERrd1Nhi27WtKRIltaqR9dLl6aT6Zoxn1TY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736207561; c=relaxed/simple;
	bh=8J8tRZFcCgE9EqQJabWQdRRYj6bXP/Jd+IndbbW14Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jp1W7XajnNgSQOef+JXbhvXSXj0vMu6E2Qoe5c9LX6kImcgWPpFH6CjHZRNt3lrOjPobdn8JD9GO8NwHmAuuAgkzZ8Nqfx+8k7L1AXF61PRzMV4PLpHI6ocVffGlNW17cSHKQxdyb6PQpaAL3fIqiLLLzBi2o/nMoImrIz1TnsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uG5g4idi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uG5g4idi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33A1C4CED2;
	Mon,  6 Jan 2025 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736207560;
	bh=8J8tRZFcCgE9EqQJabWQdRRYj6bXP/Jd+IndbbW14Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uG5g4idilsETQdmW5g4tl5IVuYRj4kGMI9GfcsgZH5ZfaDvfP1GfD82+G0ioav5JG
	 meY6lgGa6GN322EudpB6N7QIW/DFeFSnCUpZtGwFVVvS+chv1asSRou7v4s1f89ePL
	 ThUxBBDZvF6MGOu6M3Ax5D9umpxzlpgWDC90cyzIgWE+sWSw3dYuW93ckVPHx6eXQA
	 SWVSKejM5W6cpEvfDkovfX8XpLoCoVVFG/Z8PK4bgJZQFBDmrAEFJTzI7FQWiKjmqj
	 LmswT0Dp43w9Riqj6whggEV5dfDqUk2JlGuxCHLG65hqVpbkxZz2bnNmTl4d481Tq2
	 A6iW29NfRrLog==
Date: Mon, 6 Jan 2025 15:52:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Nirjhar Roy <nirjhar@linux.ibm.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <20250106235240.GN6174@frogsfrogsfrogs>
References: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
 <173568782758.2712126.12517347004514444060.stgit@frogsfrogsfrogs>
 <58cb2b57d782f48652ed86a7d7726b851e723b48.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cb2b57d782f48652ed86a7d7726b851e723b48.camel@linux.ibm.com>

On Mon, Jan 06, 2025 at 04:48:34PM +0530, Nirjhar Roy wrote:
> On Tue, 2024-12-31 at 15:56 -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Capture the kernel output after a mount failure occurs.  If the test
> > itself fails, then keep the logging output for further diagnosis.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  check                  |   22 +++++++++++++++++++++-
> >  common/rc              |   26 +++++++++++++++++++++++++-
> >  common/report          |    8 ++++++++
> >  tests/selftest/008     |   20 ++++++++++++++++++++
> >  tests/selftest/008.out |    1 +
> >  5 files changed, 75 insertions(+), 2 deletions(-)
> >  create mode 100755 tests/selftest/008
> >  create mode 100644 tests/selftest/008.out
> > 
> > 
> > diff --git a/check b/check
> > index 9222cd7e4f8197..a46ea1a54d78bb 100755
> > --- a/check
> > +++ b/check
> > @@ -614,7 +614,7 @@ _stash_fail_loop_files() {
> >  	local seq_prefix="${REPORT_DIR}/${1}"
> >  	local cp_suffix="$2"
> >  
> > -	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core"
> > ".hints"; do
> > +	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints"
> > ".mountfail"; do
> >  		rm -f "${seq_prefix}${i}${cp_suffix}"
> >  		if [ -f "${seq_prefix}${i}" ]; then
> >  			cp "${seq_prefix}${i}"
> > "${seq_prefix}${i}${cp_suffix}"
> > @@ -994,6 +994,7 @@ function run_section()
> >  				      echo -n "	$seqnum -- "
> >  			cat $seqres.notrun
> >  			tc_status="notrun"
> > +			rm -f "$seqres.mountfail?"
> >  			_stash_test_status "$seqnum" "$tc_status"
> >  
> >  			# Unmount the scratch fs so that we can wipe
> > the scratch
> > @@ -1053,6 +1054,7 @@ function run_section()
> >  		if [ ! -f $seq.out ]; then
> >  			_dump_err "no qualified output"
> >  			tc_status="fail"
> > +			rm -f "$seqres.mountfail?"
> >  			_stash_test_status "$seqnum" "$tc_status"
> >  			continue;
> >  		fi
> > @@ -1089,6 +1091,24 @@ function run_section()
> >  				rm -f $seqres.hints
> >  			fi
> >  		fi
> > +
> > +		if [ -f "$seqres.mountfail?" ]; then
> > +			if [ "$tc_status" = "fail" ]; then
> > +				# Let the user know if there were mount
> > +				# failures on a test that failed
> > because that
> > +				# could be interesting.
> > +				mv "$seqres.mountfail?"
> > "$seqres.mountfail"
> > +				_dump_err "check: possible mount
> > failures (see $seqres.mountfail)"
> > +				test -f $seqres.mountfail && \
> > +					maybe_compress_logfile
> > $seqres.mountfail $MAX_MOUNTFAIL_SIZE
> > +			else
> > +				# Don't retain mount failure logs for
> > tests
> > +				# that pass or were skipped because
> > some tests
> > +				# intentionally drive mount failures.
> > +				rm -f "$seqres.mountfail?"
> > +			fi
> > +		fi
> > +
> >  		_stash_test_status "$seqnum" "$tc_status"
> >  	done
> >  
> > diff --git a/common/rc b/common/rc
> > index d7dfb55bbbd7e1..0ede68eb912440 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -204,9 +204,33 @@ _get_hugepagesize()
> >  	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
> >  }
> >  
> > +# Does dmesg have a --since flag?
> > +_dmesg_detect_since()
> > +{
> > +	if [ -z "$DMESG_HAS_SINCE" ]; then
> > +		test "$DMESG_HAS_SINCE" = "yes"
> > +		return
> > +	elif dmesg --help | grep -q -- --since; then
> > +		DMESG_HAS_SINCE=yes
> > +	else
> > +		DMESG_HAS_SINCE=no
> > +	fi
> > +}
> > +
> >  _mount()
> >  {
> > -    $MOUNT_PROG $*
> > +	$MOUNT_PROG $*
> > +	ret=$?
> > +	if [ "$ret" -ne 0 ]; then
> > +		echo "\"$MOUNT_PROG $*\" failed at $(date)" >>
> > "$seqres.mountfail?"
> > +		if _dmesg_detect_since; then
> > +			dmesg --since '30s ago' >> "$seqres.mountfail?"
> > +		else
> > +			dmesg | tail -n 100 >> "$seqres.mountfail?"
> Is it possible to grep for a mount failure message in dmesg and then
> capture the last n lines? Do you think that will be more accurate?

Alas no, because there's no standard mount failure log message for us to
latch onto.

> Also, do you think it is useful to make this 100 configurable instead
> of hardcoding? 

I suppose, but why do you need more than 100?

> > +		fi
> > +	fi
> > +
> > +	return $ret
> >  }
> >  
> >  # Call _mount to do mount operation but also save mountpoint to
> > diff --git a/common/report b/common/report
> > index 0e91e481f9725a..b57697f76dafb2 100644
> > --- a/common/report
> > +++ b/common/report
> > @@ -199,6 +199,7 @@ _xunit_make_testcase_report()
> >  		local out_src="${SRC_DIR}/${test_name}.out"
> >  		local full_file="${REPORT_DIR}/${test_name}.full"
> >  		local dmesg_file="${REPORT_DIR}/${test_name}.dmesg"
> > +		local
> > mountfail_file="${REPORT_DIR}/${test_name}.mountfail"
> >  		local outbad_file="${REPORT_DIR}/${test_name}.out.bad"
> >  		if [ -z "$_err_msg" ]; then
> >  			_err_msg="Test $test_name failed, reason
> > unknown"
> > @@ -225,6 +226,13 @@ _xunit_make_testcase_report()
> >  			printf ']]>\n'	>>$report
> >  			echo -e "\t\t</system-err>" >> $report
> >  		fi
> > +		if [ -z "$quiet" -a -f "$mountfail_file" ]; then
> > +			echo -e "\t\t<mount-failure>" >> $report
> > +			printf	'<![CDATA[\n' >>$report
> > +			cat "$mountfail_file" | tr -dc
> > '[:print:][:space:]' | encode_cdata >>$report
> > +			printf ']]>\n'	>>$report
> > +			echo -e "\t\t</mount-failure>" >> $report
> > +		fi
> >  		;;
> >  	*)
> >  		echo -e "\t\t<failure message=\"Unknown
> > test_status=$test_status\" type=\"TestFail\"/>" >> $report
> > diff --git a/tests/selftest/008 b/tests/selftest/008
> > new file mode 100755
> > index 00000000000000..db80ffe6f77339
> > --- /dev/null
> > +++ b/tests/selftest/008
> > @@ -0,0 +1,20 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 008
> > +#
> > +# Test mount failure capture.
> > +#
> > +. ./common/preamble
> > +_begin_fstest selftest
> > +
> > +_require_command "$WIPEFS_PROG" wipefs
> > +_require_scratch
> > +
> > +$WIPEFS_PROG -a $SCRATCH_DEV
> > +_scratch_mount &>> $seqres.full
> Minor: Do you think adding some filtered messages from the captured
> dmesg logs in the output will be helpful?  

No, this test exists to make sure that the dmesg log is captured in
$RESULT_DIR.  We don't care about the mount(8) output.

--D

> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/selftest/008.out b/tests/selftest/008.out
> > new file mode 100644
> > index 00000000000000..aaff95f3f48372
> > --- /dev/null
> > +++ b/tests/selftest/008.out
> > @@ -0,0 +1 @@
> > +QA output created by 008
> > 
> 
> 
