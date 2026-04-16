Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9981A01BE;
	Thu, 16 Apr 2026 18:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776365825; cv=none; b=L0Fx25STLP2DkFj3wMn7gbur1j/B5MQ3Hy5iX1uVcg70p+1VOr9vFf9Gsad9QtX0uxlY3sZrr0TAbrDBbChERQCG5armSxhprtw8tH09sis2wLxwPHE+sO74M9Rqctv4NMyvWW0I/cCLRNKM8V5wU4sQld/KrjJt+Jzs0/PsXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776365825; c=relaxed/simple;
	bh=sNkKOujcIYN6qdQ1L8IzqvJd33wSmKHcz0YUA0iwWc4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h89yAvSGztreSJg5v5fh0yt7J9aIAr2xhdtp0wnm1u5wcUB/8G6gnknqyft9XxPQ1+bHV+G7nVg9CcQ8nW4gKdx9e87/4Fa7nJFBFhKrn8/uQWL2QECWYb5g4anA9w3JxiSKbfU+L20CqsvBbisN29yzkdSG+wq322YLDIq5jhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RyTdP600; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RyTdP600"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9C4C2BCAF;
	Thu, 16 Apr 2026 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776365825;
	bh=sNkKOujcIYN6qdQ1L8IzqvJd33wSmKHcz0YUA0iwWc4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=RyTdP600dBSrvsX7eeRnQtz+CAE8+HEh7MdiL3JK8WcBYiMzH2vTmaljBBjjGOz/h
	 katTy+u0SDr+wvFImPDokauPH//dpTRogA9Z/GCHDiVSzSl4CO4GLdJ0ya7QYSswtU
	 KhfkM+Vy9qresDe+Bs2Y867Se8whCyJEpm+ILie4/gWcHRXw3YI3t/mBQY02CqsG41
	 flN28b52ieOcBjtHWYcH96BC4yE9pECAXR/a+KGU+6nidVYFBv8N45D+t+T5SNp+uh
	 4CmlEwxn/TbCZC0YGRBMjcpoSZ/1Q/1hnNKMsnpP9ytbJPwvxpY52enq2G57X8RJuJ
	 fx3JEpHW5b5jQ==
Date: Thu, 16 Apr 2026 11:57:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <20260416185704.GA114194@frogsfrogsfrogs>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
 <aeEeHCuUuBwStWxJ@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeEeHCuUuBwStWxJ@zlang-mailbox>

On Fri, Apr 17, 2026 at 01:56:23AM +0800, Zorro Lang wrote:
> On Mon, Apr 13, 2026 at 10:51:25AM -0700, Darrick J. Wong wrote:
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
> >  doc/xunit.xsd          |   12 +++++++++++-
> >  tests/selftest/008     |   20 ++++++++++++++++++++
> >  tests/selftest/008.out |    1 +
> >  6 files changed, 86 insertions(+), 3 deletions(-)
> >  create mode 100755 tests/selftest/008
> >  create mode 100644 tests/selftest/008.out
> > 
> > 
> > diff --git a/check b/check
> > index cd7a79347eac28..c37921ea58e558 100755
> > --- a/check
> > +++ b/check
> > @@ -608,7 +608,7 @@ _stash_fail_loop_files() {
> >  	local seq_prefix="${REPORT_DIR}/${1}"
> >  	local cp_suffix="$2"
> >  
> > -	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints"; do
> > +	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints" ".mountfail"; do
> >  		rm -f "${seq_prefix}${i}${cp_suffix}"
> >  		if [ -f "${seq_prefix}${i}" ]; then
> >  			cp "${seq_prefix}${i}" "${seq_prefix}${i}${cp_suffix}"
> > @@ -982,6 +982,7 @@ function run_section()
> >  				      echo -n "	$seqnum -- "
> >  			cat $seqres.notrun
> >  			tc_status="notrun"
> > +			rm -f "$seqres.mountfail?"
> >  			_stash_test_status "$seqnum" "$tc_status"
> >  
> >  			# Unmount the scratch fs so that we can wipe the scratch
> > @@ -1045,6 +1046,7 @@ function run_section()
> >  		if [ ! -f $seq.out ]; then
> >  			_dump_err "no qualified output"
> >  			tc_status="fail"
> > +			rm -f "$seqres.mountfail?"
> >  			_stash_test_status "$seqnum" "$tc_status"
> >  			continue;
> >  		fi
> > @@ -1081,6 +1083,24 @@ function run_section()
> >  				rm -f $seqres.hints
> >  			fi
> >  		fi
> > +
> > +		if [ -f "$seqres.mountfail?" ]; then
> > +			if [ "$tc_status" = "fail" ]; then
> > +				# Let the user know if there were mount
> > +				# failures on a test that failed because that
> > +				# could be interesting.
> > +				mv "$seqres.mountfail?" "$seqres.mountfail"
> > +				_dump_err "check: possible mount failures (see $seqres.mountfail)"
> > +				test -f $seqres.mountfail && \
> > +					maybe_compress_logfile $seqres.mountfail $MAX_MOUNTFAIL_SIZE
>                                         ^^^^^^^^^^^^^^^^^^^^^^
> What's the "maybe_compress_logfile" ?

Oops, that's part of another debugging patch that isn't in this batch.

I'll clear it out.

> > +			else
> > +				# Don't retain mount failure logs for tests
> > +				# that pass or were skipped because some tests
> > +				# intentionally drive mount failures.
> > +				rm -f "$seqres.mountfail?"
> > +			fi
> > +		fi
> > +
> >  		_stash_test_status "$seqnum" "$tc_status"
> >  	done
> >  
> > diff --git a/common/rc b/common/rc
> > index 5fe44e2158ffb3..18ceda1b32cd63 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -288,9 +288,33 @@ _get_hugepagesize()
> >  	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
> >  }
> >  
> > +# Does dmesg have a --since flag?
> > +_dmesg_detect_since()
> > +{
> > +	if [ -z "$DMESG_HAS_SINCE" ]; then
> > +		test "$DMESG_HAS_SINCE" = "yes"
>                        ^^^^^^^^^^^^^^^
> I can't find you use this parameter anywhere. But you do:

That's exactly where DMESG_HAS_SINCE gets used.

> 
>   if _dmesg_detect_since; then
>           dmesg --since '30s ago' >> "$seqres.mountfail?"
>   else
>           dmesg | tail -n 100 >> "$seqres.mountfail?"
>   fi
> 
> do you want to treat this function as below?
> 
>   _has_dmesg_since_option()
>   {
>           if grep -q -- --since <(dmesg --help);then
>                   return 0
>           fi
>           return 1
>   }

_has_dmesg_since_option()
{
	grep -q -- --since <(dmesg --help)
}

would be shorter?

> 
> > +		return
> > +	elif dmesg --help | grep -q -- --since; then
> > +		DMESG_HAS_SINCE=yes
> > +	else
> > +		DMESG_HAS_SINCE=no

...as this case is broken anyway. :(

Will resend with less cruft

--D

> > +	fi
> > +}
> > +
> >  _mount()
> >  {
> > -    $MOUNT_PROG $*
> > +	$MOUNT_PROG $*
> > +	ret=$?
> > +	if [ "$ret" -ne 0 ]; then
> > +		echo "\"$MOUNT_PROG $*\" failed at $(date)" >> "$seqres.mountfail?"
> > +		if _dmesg_detect_since; then
> > +			dmesg --since '30s ago' >> "$seqres.mountfail?"
> > +		else
> > +			dmesg | tail -n 100 >> "$seqres.mountfail?"
> > +		fi
> > +	fi
> > +
> > +	return $ret
> >  }
> >  
> >  # Call _mount to do mount operation but also save mountpoint to
> > diff --git a/common/report b/common/report
> > index 7128bbebac8b75..a41a58f790b784 100644
> > --- a/common/report
> > +++ b/common/report
> > @@ -199,6 +199,7 @@ _xunit_make_testcase_report()
> >  		local out_src="${SRC_DIR}/${test_name}.out"
> >  		local full_file="${REPORT_DIR}/${test_name}.full"
> >  		local dmesg_file="${REPORT_DIR}/${test_name}.dmesg"
> > +		local mountfail_file="${REPORT_DIR}/${test_name}.mountfail"
> >  		local outbad_file="${REPORT_DIR}/${test_name}.out.bad"
> >  		if [ -z "$_err_msg" ]; then
> >  			_err_msg="Test $test_name failed, reason unknown"
> > @@ -225,6 +226,13 @@ _xunit_make_testcase_report()
> >  			printf ']]>\n'	>>$report
> >  			echo -e "\t\t</system-err>" >> $report
> >  		fi
> > +		if [ -z "$quiet" -a -f "$mountfail_file" ]; then
> > +			echo -e "\t\t<mount-failure>" >> $report
> > +			printf	'<![CDATA[\n' >>$report
> > +			cat "$mountfail_file" | tr -dc '[:print:][:space:]' | encode_cdata >>$report
> > +			printf ']]>\n'	>>$report
> > +			echo -e "\t\t</mount-failure>" >> $report
> > +		fi
> >  		;;
> >  	*)
> >  		echo -e "\t\t<failure message=\"Unknown test_status=$test_status\" type=\"TestFail\"/>" >> $report
> > diff --git a/doc/xunit.xsd b/doc/xunit.xsd
> > index d287eaf5a25fb6..efe0badbb338b5 100644
> > --- a/doc/xunit.xsd
> > +++ b/doc/xunit.xsd
> > @@ -131,7 +131,7 @@
> >                                  </xs:complexType>
> >                              </xs:element>
> >                          </xs:choice>
> > -                        <xs:choice minOccurs="0" maxOccurs="3">
> > +                        <xs:choice minOccurs="0" maxOccurs="4">
> >                              <xs:element name="system-out" minOccurs="0" maxOccurs="1">
> >                                  <xs:annotation>
> >                                      <xs:documentation xml:lang="en">Data that was written to the .full log file while the test was executed.</xs:documentation>
> > @@ -162,6 +162,16 @@
> >                                      </xs:restriction>
> >                                  </xs:simpleType>
> >                              </xs:element>
> > +                            <xs:element name="mount-failure" minOccurs="0" maxOccurs="1">
> > +                                <xs:annotation>
> > +                                    <xs:documentation xml:lang="en">Kernel log recorded when mount failed.</xs:documentation>
> > +                                </xs:annotation>
> > +                                <xs:simpleType>
> > +                                    <xs:restriction base="pre-string">
> > +                                        <xs:whiteSpace value="preserve"/>
> > +                                    </xs:restriction>
> > +                                </xs:simpleType>
> > +                            </xs:element>
> >                          </xs:choice>
> >                      </xs:sequence>
> >                      <xs:attribute name="name" type="xs:token" use="required">
> > diff --git a/tests/selftest/008 b/tests/selftest/008
> > new file mode 100755
> > index 00000000000000..bcd1f13ed27778
> > --- /dev/null
> > +++ b/tests/selftest/008
> > @@ -0,0 +1,20 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
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
> > +
> 
> echo "Silence is golden"
> 
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
> 
> Silence is golden
> 
> > 
> 
