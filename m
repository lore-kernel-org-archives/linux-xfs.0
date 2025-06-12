Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523131F4165;
	Thu, 12 Jun 2025 07:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749711987; cv=none; b=VG9y6JK58I676ntOHY39bAMJV3t2RYfIMGvmAGfPKw9/k61dlRT37fOEwGRVGzwTwajUvFetxz9MgagWd6NtCUG3Rop/EMFFqfzqehZgCP0tq+Vz7jQCP9HIlE09Fv9EoykeTnMAJxrCxsooGYjTL+223CFnv01cmx9xnQhZ52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749711987; c=relaxed/simple;
	bh=B/raQJ5Ve+NP3SWlAm970pjkky1d5qh3QiGCbXGHbCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzPKBhq8NuNIRb5lJmQLH+wWW/HLf7XoiTn1kpXGXIYDYLLlj/aZAdrubtG9rcGcFrU7xAjb/zkuPIayayyCur78UqM1QyURyB8Dpk4JB84Y4MciU9Wxu77i3eE+XJ1QaY8R65os6oH4mUCvAe2uVKMzIhm9OZz00LliGZIFF20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bp7Gnolg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bp7Gnolg"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C4bXq1021660;
	Thu, 12 Jun 2025 07:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ojD0u2T+tGAA/satsFHZ5NQQ/uXsMs
	lVAdGqpjVN3Mk=; b=Bp7GnolgAochdgDxgn9WGPPulXXvWpOvp3emkP34Fn004k
	FG9EUUZMAKAkJk4esc/ZVUOFCgk4rxfLVrxDLeePfACFKDW1kfV8Qkd9hLsFhRcg
	CeOu/BumCtLRbNxhklaH7GB6s8XjrDMrbPI0YMlwZX1PHvMeuBI7veHr2Emq6UXT
	RbHaoKCAOm4NvEiCP2jkVQRmkjFA+PhoZ89t2ntWFU0PEMtB7aQbAsuQIsVPowcv
	3oTeOjEXdPBc2KiiH7S+Re8KrdgGKM5U8t12dkXZqsU/7QA8drdv3jODCNMcVmSh
	AWJIQ0ZIX1uuszMEGiQvGWOXCXkh49lXuU1fAjYQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474bup91pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:06:20 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55C6rwCV006353;
	Thu, 12 Jun 2025 07:06:20 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474bup91pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:06:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55C5NN6t022352;
	Thu, 12 Jun 2025 07:06:19 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4750503n73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:06:19 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55C76HLP46268694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 07:06:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5AA6320043;
	Thu, 12 Jun 2025 07:06:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E407A2004B;
	Thu, 12 Jun 2025 07:06:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Jun 2025 07:06:15 +0000 (GMT)
Date: Thu, 12 Jun 2025 12:36:13 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <aEp8ZYT48ySTLWqy@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=H4Hbw/Yi c=1 sm=1 tr=0 ts=684a7c6c cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=eh-ONMNY3_ng6Kf3CBYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA1MCBTYWx0ZWRfX2rXRTzD5wdX0 D0dixWqw+8ojkvJmuj9F0TwRNw9UtHeG/qs7m1hGe9b+Z9G5qkYGKpk9fEyFILKDIXRfltqthx0 cFuO+mqQXzZi4AFazrGqq4OzYUJrDS3RlJ21oh6X/NhfKmMKyH4clLThXXeVMwn6dZmVcOjDuGf
 SwwnEl7NKWMaOEy5KgnKtAnt9FW/qWSdMkWe+GDe4axcydAvfpHUzjWCoLWDaJYN3iEHm+vux+6 SRp76z66ZIDXARvXVszqZHltimLLeM2n6kHzH9f2+MKlCU7bekgAB1yp9eNpifJxN890LmcgMvq sG6CA19ZRab4bGM7/FiK867ZrlPg+zl+frVLFTxdcgKiuPMzY39vBFWdaX3HljiJUqhDBwYXkxe
 UknlbOIqRbva4fe/aSLFl0hdL84EujHbPgkj8OWkcqnOSKd1Rpz9qJkcp8PPcJDUV/qT0W8p
X-Proofpoint-GUID: 88jjsLDkJXnbe0-4mdcmywLw0Yp4Akgy
X-Proofpoint-ORIG-GUID: nWEMV9WbbP9A34j2gExhrdKYbAVpEUOp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_03,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
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
> ---

<snip>

Okay after running some of these tests on my setup, I have a few
more questions regarding g/1225.

> diff --git a/tests/generic/1225 b/tests/generic/1225
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
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +_require_xfs_io_command pwrite -A

I think this is already covered in _require_atomic_write_test_commands

> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"

Is it possible to keep the max_awu requirement to maybe 64k? The reason
I'm asking is that in 4k bs ext4 with bigalloc, having cluster size more
than 64k is actually experimental so I don't think many people would be
formatting with 256k cluster size and would miss out on running this
test. Infact if i do set the cluster size to 256k I'm running into
enospc in the last enospc scenario of this test, whereas 64k works
correctly).

So just wondering if we can have an awu_max of 64k here so that more
people are easily able to run this in their setups?

Regards,
ojaswin

<snip>

> +
> +echo "atomic write max size on fragmented fs"
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1225.out b/tests/generic/1225.out
> new file mode 100644
> index 00000000..92302597
> --- /dev/null
> +++ b/tests/generic/1225.out
> @@ -0,0 +1,21 @@
> +QA output created by 1225
> +atomic write hole+mapped+hole
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write adjacent mapped+hole and hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write mapped+hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write unwritten+mapped+unwritten
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write adjacent mapped+unwritten and unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write mapped+unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write interweaved hole+unwritten+written
> +5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
> +atomic write at EOF
> +75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
> +atomic write preallocated region
> +27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
> +atomic write max size on fragmented fs
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> -- 
> 2.34.1
> 
