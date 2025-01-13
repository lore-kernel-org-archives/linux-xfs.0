Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAAB14B07A;
	Mon, 13 Jan 2025 05:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736747725; cv=none; b=eUHV7t5BwR3pQdotO9EmHAT+Z5yxmEmjWCmklnyXFt2+Wzx5qRsf7zfJeNl8YqzXc2hNjyXFs8UbGGhORnVRtjh3Ey1xXAkhdcACY7HQevGmgCdkcmL/V1u0owBaBLy9SJXOVcJ3I8yLxB+jwNxcGBVhpkYaQmLgKVmnSnJIfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736747725; c=relaxed/simple;
	bh=s6f3c4DtpXAbS+LjErPNjLgzmUnd8/je2Aqm9V4KL8M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=p9VlfvawuaDLKT1sggMLhFKBRV0zAN9rFn5ROrDVE8UvxPH/6hg5gTI5LL9NFme/tjAEyw/J2jblatZIq2qu9Mla+aP2MKaHRGBLq9OEHH22l3t9FnjhFOvpdLzxyQAOIBj37evADA8kSOT6qbvuuTybYvM2xyUrDFmoBQ5yKKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PNO8Utaa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PNO8Utaa"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50CNaXOQ022446;
	Mon, 13 Jan 2025 05:55:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4lszIP
	HYrMmpxakVQEMAE6+MtBmM3NlEYx+aOlquawo=; b=PNO8UtaaMCds8LamKhvvq4
	MXboZEVFGyD5mTjc/NsWQ596Xta2YbFzUUEIAOBGvdIW7/BScs5e44ZkI2KV5sUi
	xfagM2kt+BxfQE9OHFS+oTrKvQFXQw/U5r5cFIw1zlD7YIP1JZvag3+rZiYyLeHO
	mySqGh+iK2apDgTxeGeGgkamDbx6RcYnvLqJXfpp7h+3N8/QyuAlTgDxujVEJdWv
	Vjn6s8zfeexntC6O8A17h8T0ZipXOXDwC+6v/dY8Q3okNT8ZRTRw+jbWuxKjHp5C
	4yyIeD/svLoO7+ng6Hxt/P5Ol576dau/lyj/w2z4UPyuKF9Pt9a9xNBFMXo7Qn8g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 444qjagx3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 05:55:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50D30E1A002689;
	Mon, 13 Jan 2025 05:55:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443bxvun7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 05:55:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50D5t9p864356680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 05:55:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FCEF20040;
	Mon, 13 Jan 2025 05:55:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 972AF20043;
	Mon, 13 Jan 2025 05:55:08 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com (unknown [9.109.247.80])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jan 2025 05:55:08 +0000 (GMT)
Message-ID: <33c9c20f2e90f7184fe6b02cff8c4596bfaaf8c7.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
From: Nirjhar Roy <nirjhar@linux.ibm.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Mon, 13 Jan 2025 11:25:07 +0530
In-Reply-To: <20250106235240.GN6174@frogsfrogsfrogs>
References: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
	 <173568782758.2712126.12517347004514444060.stgit@frogsfrogsfrogs>
	 <58cb2b57d782f48652ed86a7d7726b851e723b48.camel@linux.ibm.com>
	 <20250106235240.GN6174@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-26.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: piBk5Fqi7qO5aNaZG2FafyUwusYsF4vV
X-Proofpoint-ORIG-GUID: piBk5Fqi7qO5aNaZG2FafyUwusYsF4vV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501130045

On Mon, 2025-01-06 at 15:52 -0800, Darrick J. Wong wrote:
> On Mon, Jan 06, 2025 at 04:48:34PM +0530, Nirjhar Roy wrote:
> > On Tue, 2024-12-31 at 15:56 -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Capture the kernel output after a mount failure occurs.  If the
> > > test
> > > itself fails, then keep the logging output for further diagnosis.
> > > 
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > ---
> > >  check                  |   22 +++++++++++++++++++++-
> > >  common/rc              |   26 +++++++++++++++++++++++++-
> > >  common/report          |    8 ++++++++
> > >  tests/selftest/008     |   20 ++++++++++++++++++++
> > >  tests/selftest/008.out |    1 +
> > >  5 files changed, 75 insertions(+), 2 deletions(-)
> > >  create mode 100755 tests/selftest/008
> > >  create mode 100644 tests/selftest/008.out
> > > 
> > > 
> > > diff --git a/check b/check
> > > index 9222cd7e4f8197..a46ea1a54d78bb 100755
> > > --- a/check
> > > +++ b/check
> > > @@ -614,7 +614,7 @@ _stash_fail_loop_files() {
> > >  	local seq_prefix="${REPORT_DIR}/${1}"
> > >  	local cp_suffix="$2"
> > >  
> > > -	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core"
> > > ".hints"; do
> > > +	for i in ".full" ".dmesg" ".out.bad" ".notrun" ".core" ".hints"
> > > ".mountfail"; do
> > >  		rm -f "${seq_prefix}${i}${cp_suffix}"
> > >  		if [ -f "${seq_prefix}${i}" ]; then
> > >  			cp "${seq_prefix}${i}"
> > > "${seq_prefix}${i}${cp_suffix}"
> > > @@ -994,6 +994,7 @@ function run_section()
> > >  				      echo -n "	$seqnum -- "
> > >  			cat $seqres.notrun
> > >  			tc_status="notrun"
> > > +			rm -f "$seqres.mountfail?"
> > >  			_stash_test_status "$seqnum" "$tc_status"
> > >  
> > >  			# Unmount the scratch fs so that we can wipe
> > > the scratch
> > > @@ -1053,6 +1054,7 @@ function run_section()
> > >  		if [ ! -f $seq.out ]; then
> > >  			_dump_err "no qualified output"
> > >  			tc_status="fail"
> > > +			rm -f "$seqres.mountfail?"
> > >  			_stash_test_status "$seqnum" "$tc_status"
> > >  			continue;
> > >  		fi
> > > @@ -1089,6 +1091,24 @@ function run_section()
> > >  				rm -f $seqres.hints
> > >  			fi
> > >  		fi
> > > +
> > > +		if [ -f "$seqres.mountfail?" ]; then
> > > +			if [ "$tc_status" = "fail" ]; then
> > > +				# Let the user know if there were mount
> > > +				# failures on a test that failed
> > > because that
> > > +				# could be interesting.
> > > +				mv "$seqres.mountfail?"
> > > "$seqres.mountfail"
> > > +				_dump_err "check: possible mount
> > > failures (see $seqres.mountfail)"
> > > +				test -f $seqres.mountfail && \
> > > +					maybe_compress_logfile
> > > $seqres.mountfail $MAX_MOUNTFAIL_SIZE
> > > +			else
> > > +				# Don't retain mount failure logs for
> > > tests
> > > +				# that pass or were skipped because
> > > some tests
> > > +				# intentionally drive mount failures.
> > > +				rm -f "$seqres.mountfail?"
> > > +			fi
> > > +		fi
> > > +
> > >  		_stash_test_status "$seqnum" "$tc_status"
> > >  	done
> > >  
> > > diff --git a/common/rc b/common/rc
> > > index d7dfb55bbbd7e1..0ede68eb912440 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -204,9 +204,33 @@ _get_hugepagesize()
> > >  	awk '/Hugepagesize/ {print $2 * 1024}' /proc/meminfo
> > >  }
> > >  
> > > +# Does dmesg have a --since flag?
> > > +_dmesg_detect_since()
> > > +{
> > > +	if [ -z "$DMESG_HAS_SINCE" ]; then
> > > +		test "$DMESG_HAS_SINCE" = "yes"
> > > +		return
> > > +	elif dmesg --help | grep -q -- --since; then
> > > +		DMESG_HAS_SINCE=yes
> > > +	else
> > > +		DMESG_HAS_SINCE=no
> > > +	fi
> > > +}
> > > +
> > >  _mount()
> > >  {
> > > -    $MOUNT_PROG $*
> > > +	$MOUNT_PROG $*
> > > +	ret=$?
> > > +	if [ "$ret" -ne 0 ]; then
> > > +		echo "\"$MOUNT_PROG $*\" failed at $(date)" >>
> > > "$seqres.mountfail?"
> > > +		if _dmesg_detect_since; then
> > > +			dmesg --since '30s ago' >> "$seqres.mountfail?"
> > > +		else
> > > +			dmesg | tail -n 100 >> "$seqres.mountfail?"
> > Is it possible to grep for a mount failure message in dmesg and
> > then
> > capture the last n lines? Do you think that will be more accurate?
> 
> Alas no, because there's no standard mount failure log message for us
> to
> latch onto.
Okay makes sense. 
> 
> > Also, do you think it is useful to make this 100 configurable
> > instead
> > of hardcoding? 
> 
> I suppose, but why do you need more than 100?
So my thought behind this is that in case, the dmesg gets cluttered
with noisy logs from other processes. No hard preferences though. 
> 
> > > +		fi
> > > +	fi
> > > +
> > > +	return $ret
> > >  }
> > >  
> > >  # Call _mount to do mount operation but also save mountpoint to
> > > diff --git a/common/report b/common/report
> > > index 0e91e481f9725a..b57697f76dafb2 100644
> > > --- a/common/report
> > > +++ b/common/report
> > > @@ -199,6 +199,7 @@ _xunit_make_testcase_report()
> > >  		local out_src="${SRC_DIR}/${test_name}.out"
> > >  		local full_file="${REPORT_DIR}/${test_name}.full"
> > >  		local dmesg_file="${REPORT_DIR}/${test_name}.dmesg"
> > > +		local
> > > mountfail_file="${REPORT_DIR}/${test_name}.mountfail"
> > >  		local outbad_file="${REPORT_DIR}/${test_name}.out.bad"
> > >  		if [ -z "$_err_msg" ]; then
> > >  			_err_msg="Test $test_name failed, reason
> > > unknown"
> > > @@ -225,6 +226,13 @@ _xunit_make_testcase_report()
> > >  			printf ']]>\n'	>>$report
> > >  			echo -e "\t\t</system-err>" >> $report
> > >  		fi
> > > +		if [ -z "$quiet" -a -f "$mountfail_file" ]; then
> > > +			echo -e "\t\t<mount-failure>" >> $report
> > > +			printf	'<![CDATA[\n' >>$report
> > > +			cat "$mountfail_file" | tr -dc
> > > '[:print:][:space:]' | encode_cdata >>$report
> > > +			printf ']]>\n'	>>$report
> > > +			echo -e "\t\t</mount-failure>" >> $report
> > > +		fi
> > >  		;;
> > >  	*)
> > >  		echo -e "\t\t<failure message=\"Unknown
> > > test_status=$test_status\" type=\"TestFail\"/>" >> $report
> > > diff --git a/tests/selftest/008 b/tests/selftest/008
> > > new file mode 100755
> > > index 00000000000000..db80ffe6f77339
> > > --- /dev/null
> > > +++ b/tests/selftest/008
> > > @@ -0,0 +1,20 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 008
> > > +#
> > > +# Test mount failure capture.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest selftest
> > > +
> > > +_require_command "$WIPEFS_PROG" wipefs
> > > +_require_scratch
> > > +
> > > +$WIPEFS_PROG -a $SCRATCH_DEV
> > > +_scratch_mount &>> $seqres.full
> > Minor: Do you think adding some filtered messages from the captured
> > dmesg logs in the output will be helpful?  
> 
> No, this test exists to make sure that the dmesg log is captured in
> $RESULT_DIR.  We don't care about the mount(8) output.
> 
> --D
Okay, got it.
--NR 
> 
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/selftest/008.out b/tests/selftest/008.out
> > > new file mode 100644
> > > index 00000000000000..aaff95f3f48372
> > > --- /dev/null
> > > +++ b/tests/selftest/008.out
> > > @@ -0,0 +1 @@
> > > +QA output created by 008
> > > 

