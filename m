Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53151F419A;
	Thu, 12 Jun 2025 06:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749711558; cv=none; b=Fgp7BrSj57mpiaKrLiPTwkfMBYR3J7EvJR0VF191M6ce5RCcE/m8tFEMxaxQvA9pmtjWimJtMIHHgQXADVpsgYFoSAuDL9+Ga3IDB4TpNv8T5IJY9txn/37+s82ZvohSISD7xf0P9JXqdBSgh3WexohwNNpalb+wAbnCpNhAKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749711558; c=relaxed/simple;
	bh=YtWo1ALVWmR8/EG/+eWEUtqbzlciKXavzrEEAVz8o4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ef++/RJiT2Zn3PtTRgvwgBCDPTESp1vrxH4QkmIkw/OW+HPNt15K0mNf/GFY4BfegfFGJB+5zOyDSxrd7FRSDSMfpCog1BoNoiG6sNbnFZaJQOUzvuwrtvKZZGgpxUi3gpZsQVRSH/JzMfrhe3TMbrE2aigWErPxYZHWMrfM+2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jDkmhvXE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jDkmhvXE"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C5cv5x027642;
	Thu, 12 Jun 2025 06:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=je8aSBQkGjYrOKrwHUYm3WR22eM3hG
	6oUuh/4WMLsW4=; b=jDkmhvXEetSrlowJ+s7AgyfqjoVl0SH2Ue2837Th1NwEd+
	mgAk26k1T5PQrgxAkLAAUtOePks52yxEPo/hwtCW2oaNuWXKr35elehAzmQSciGw
	ZytkGqJFDcwqzyBk8/1aD9qvf5SVLirqhiWhHPQpvL/+2UyEiFWzZPpoEK4l7Gax
	KAWzNR25Az92uJmwQ3ho/I3AUU9UQ7s6a+k5HLEC2gzlJQErZvYr8Z5oz42ZXkO/
	DKSO4BbcJHC/Djj6SijdvlzSklyIAmUTuNFL+lFFFudjVAhv1oQaLStK177f91Yf
	zvovfNlfYnjHxW2/ltixnqM+jUTAyD74u0jQIG3Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4me5jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:59:10 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55C6sY6Z003169;
	Thu, 12 Jun 2025 06:59:10 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4me5jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:59:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55C5mVLe021908;
	Thu, 12 Jun 2025 06:59:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4750503kxb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:59:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55C6x7vS29622858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 06:59:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 782F920043;
	Thu, 12 Jun 2025 06:59:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA1F520040;
	Thu, 12 Jun 2025 06:59:05 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Jun 2025 06:59:05 +0000 (GMT)
Date: Thu, 12 Jun 2025 12:29:03 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <aEp6t7WRJfYGlHrO@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612015708.84255-3-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Y4X4sgeN c=1 sm=1 tr=0 ts=684a7abe cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=CzOoDP5PHOBD5AjD0A4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: _QDT_GLELKlAcwA70nGJXcrokOf-HChw
X-Proofpoint-ORIG-GUID: DcOLKhrJORwosR6GBuVaufFGkOluAt3q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA1MCBTYWx0ZWRfX2RJPYli3PsDo 8a5YmpsGGVPwNgUXlH3J4qwZZgOa4B2bf39dB4Or5iAkOGSvkqIPjK7lsBDBlVFU6QiFDwD0D5a PCFwfPEMBpykw5FBvqtek2AFc7PrbfNd4ri3E49i4dAH5jiWu/HZyHTM4sRLtkvvwWy8f+Uelj3
 9+Usa5W1AGyyY/4wpXorgA6ufgqTvoFfzP6uVJ/qbtmLLiuq1S4wyyJvMpSbHtg4HXNfp69NXyj vTlG5Y5d4nv9hBPp9iKp343NaOeTxMTIMOsX55m+8RuJdzh7UtWkme5GrT4yBU0O2dDxkAJulfP vyKbGOCcak/8sOkgGx7Jy19lQuqCGSNhUk5zjwoTcWHzPyimunV6JBNaHa2tn/6qvTyVoI0DYmy
 zVcBnDxXi+UediHGoeNt5xkXPfZd2w5F5xJ0/EJEvQyqOXvn8UV+cxwvUA2veQYKGwKAz5Cu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_03,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506120050

On Wed, Jun 11, 2025 at 06:57:07PM -0700, Catherine Hoang wrote:
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
> 
> The first test performs basic multi-block atomic writes on a scsi_debug device
> with atomic writes enabled. We test all advertised sizes between the atomic
> write unit min and max. We also ensure that the write fails when expected, such
> as when attempting buffered io or unaligned directio.
> 
> The second test is similar to the one above, except that it verifies multi-block
> atomic writes on actual hardware instead of simulated hardware. The device used
> in this test is not required to support atomic writes.
> 
> The final two tests ensure multi-block atomic writes can be performed on various
> interweaved mappings, including written, mapped, hole, and unwritten. We also
> test large atomic writes on a heavily fragmented filesystem. These tests are
> separated into reflink (shared) and non-reflink tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Hi Catherine, Darrick,

The tests looks mostly okay. Just a few minor comments I've added below:

> ---
>  common/atomicwrites    |  10 ++++
>  tests/generic/1222     |  89 ++++++++++++++++++++++++++++
>  tests/generic/1222.out |  10 ++++
>  tests/generic/1223     |  67 +++++++++++++++++++++
>  tests/generic/1223.out |   9 +++
>  tests/generic/1224     |  86 +++++++++++++++++++++++++++
>  tests/generic/1224.out |  16 ++++++
>  tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1225.out |  21 +++++++
>  9 files changed, 436 insertions(+)
>  create mode 100755 tests/generic/1222
>  create mode 100644 tests/generic/1222.out
>  create mode 100755 tests/generic/1223
>  create mode 100644 tests/generic/1223.out
>  create mode 100755 tests/generic/1224
>  create mode 100644 tests/generic/1224.out
>  create mode 100755 tests/generic/1225
>  create mode 100644 tests/generic/1225.out
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 88f49a1a..4ba945ec 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -136,3 +136,13 @@ _test_atomic_file_writes()
>      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
>          echo "atomic write requires offset to be aligned to bsize"
>  }
> +
> +_simple_atomic_write() {
> +	local pos=$1
> +	local count=$2
> +	local file=$3
> +	local directio=$4
> +
> +	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> +	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> +}
> diff --git a/tests/generic/1222 b/tests/generic/1222
> new file mode 100755
> index 00000000..d3665d0b
> --- /dev/null
> +++ b/tests/generic/1222
> @@ -0,0 +1,89 @@

<snip>

> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +echo "all should work"
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d

I'm still not sure what extra thing this _simple_atomic_write is testing
here that is not already tested via _test_atomic_file_writes? (same
question for g/1223 as well)

> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +_simple_atomic_write $sector_size $min_awu $testfile -d
> +

<snip>

> new file mode 100755
> index 00000000..f2dea804
> --- /dev/null
> +++ b/tests/generic/1225
> @@ -0,0 +1,128 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1225
> +#
> +# basic tests for large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink

I think we are not using reflink based helpers here so this can be
dropped.


<snip>

> +
> +echo "atomic write unwritten+mapped+unwritten"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write mapped+unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write interweaved hole+unwritten+written"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch

Thanks for adding more unwritten based combinations :) 

Rest everything looks okay to me.

Regards,
ojaswin

<snip>
