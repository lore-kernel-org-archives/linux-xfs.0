Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD1878F29;
	Fri, 13 Jun 2025 05:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749791845; cv=none; b=nCX3fac76Yqlu+SQqFZc/9QT9LuQf0ApVCHr7gmL1X3yNfWW2CY0fY4Nl+Qw0uZqaFiP07KamnSzWfbGmgkFHXu3WY6XWhBnvlHRhsMWa6ifQb4bCscorLuNl/RzgeHjQ/M6AIjYNhn/CeW4eQCMU2uRZRAqhejbH2sRPqYMcZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749791845; c=relaxed/simple;
	bh=JkxlVFWgSnNlMNQnr0h6iOyC0+jKBNgE2qzmfuHg/Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chVYdPiXmNPauhMyJNRP/NwJERl84r0eabkLipBFxjj0bdDnn3FXFByg27NBXdfcPeRF4eskTikvO88VAAMpv7s7CKquNW2LadQDUZ7FeVXaBnYtCLcVr+l5/I/DHEd/pOPlRAsHfYPWUgJ05iaRRQuUGFh6bkmxVw2EJTrtfwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qsRHVbG9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qsRHVbG9"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CLxsTZ020661;
	Fri, 13 Jun 2025 05:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=i0AtYG
	iRndNfkhBYVbzXUOP5YWrmSfqIyX+iUjClVUo=; b=qsRHVbG95zoufT7WvRtRjj
	PYaw3f4vsAkcFECus+/akqoQjLmdzILAuiboq1qg5V1rfCEQ/e5gP51KdxUg/ntQ
	Qvu4Yz/0AuVNkhMxbXk/ylqt9lUDFbDK600yefjhPZezrFUjQG93JizFB8QPJDGB
	+ODsLjrwYznW0WYFXnFOt9deVmBzlnGKk/+sjyM6qS9NJUA/0WxcQU0RKxRauO8Y
	VVl5n2PeNR/xQ9wLJzrD6EwSTqS2leHMsuwCFZ2ODYLGq8lCS3GEHC8dfmkdxnTi
	RBaoiX30Edi2KNcifnEawrz1nm3Du3faQ3/PbKoXnn0HCn3TsWYtXfMIL+n3vucg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4mm2fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Jun 2025 05:17:19 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55D5BgNX025020;
	Fri, 13 Jun 2025 05:17:18 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4mm2ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Jun 2025 05:17:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55D20MjR021839;
	Fri, 13 Jun 2025 05:17:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4750508j6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Jun 2025 05:17:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55D5HGjx46924278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 05:17:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF1CB2004F;
	Fri, 13 Jun 2025 05:17:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A92A120040;
	Fri, 13 Jun 2025 05:17:14 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.30.54])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 13 Jun 2025 05:17:14 +0000 (GMT)
Date: Fri, 13 Jun 2025 10:47:12 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        "ritesh.list@gmail.com" <ritesh.list@gmail.com>
Subject: Re: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <aEu0WImvhx8erb78@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-3-catherine.hoang@oracle.com>
 <aEp8ZYT48ySTLWqy@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7E2C7236-767E-4828-A06F-F279D2270F3D@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7E2C7236-767E-4828-A06F-F279D2270F3D@oracle.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Y4X4sgeN c=1 sm=1 tr=0 ts=684bb45f cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=4UbMwSzvF7_9Zk8yoWQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iTU0uQe0ixSyaCbXHGCmgJGTLX6geyB8
X-Proofpoint-ORIG-GUID: GlGiJOvA1SktO9taKzBk7uZvz6wimkIf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDAzNyBTYWx0ZWRfXxQ168eLua2p6 TnnUNb9GwCk1nrG/7JnES41G8+WySbAfGEVqRlKQusKosAPQzg+hjJX46OuYzC7U0iKOZavPr28 AOOMiGrSfL9mf5iqka0P9FadVrIaTaExBYDLhyiVs5NNG4vTUqnWuj03IN4LBQcNg8BoDE2DQem
 dautQapfVxJcAbo32qUGncgl1matOsVwjLc9RAvnCRMBjjt4Pi//mscMvGilWhGc50XhmraX6ai IivvP73EQu9FgJdGnI3tAUNhorYx+ILvxlPfJa/c7uFrfu9T5ugBfsA3gbrxaNLP84v/OA/wRsY 1PGd9/mN0US4HcHKVKDS59EEQc+zVrewZ1fqnVgcZmt3+OkvME/6TbXxEjiqZLeiBEiPFAW+mEN
 85iqMPtf7964A3kTQ43cKm4jpPDqQjh9NDHSK9J1lApOGUlRtNjUtgq2Zw984/7j59QAjS4l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_10,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506130037

On Thu, Jun 12, 2025 at 11:24:34PM +0000, Catherine Hoang wrote:
> 
> > On Jun 12, 2025, at 12:06 AM, Ojaswin Mujoo <ojaswin@linux.ibm.com> wrote:
> > 
> > On Wed, Jun 11, 2025 at 06:57:07PM -0700, Catherine Hoang wrote:
> >> Simple tests of various atomic write requests and a (simulated) hardware
> >> device.
> >> 
> >> The first test performs basic multi-block atomic writes on a scsi_debug device
> >> with atomic writes enabled. We test all advertised sizes between the atomic
> >> write unit min and max. We also ensure that the write fails when expected, such
> >> as when attempting buffered io or unaligned directio.
> >> 
> >> The second test is similar to the one above, except that it verifies multi-block
> >> atomic writes on actual hardware instead of simulated hardware. The device used
> >> in this test is not required to support atomic writes.
> >> 
> >> The final two tests ensure multi-block atomic writes can be performed on various
> >> interweaved mappings, including written, mapped, hole, and unwritten. We also
> >> test large atomic writes on a heavily fragmented filesystem. These tests are
> >> separated into reflink (shared) and non-reflink tests.
> >> 
> >> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> ---
> > 
> > <snip>
> > 
> > Okay after running some of these tests on my setup, I have a few
> > more questions regarding g/1225.
> > 
> >> diff --git a/tests/generic/1225 b/tests/generic/1225
> >> new file mode 100755
> >> index 00000000..f2dea804
> >> --- /dev/null
> >> +++ b/tests/generic/1225
> >> @@ -0,0 +1,128 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 1225
> >> +#
> >> +# basic tests for large atomic writes with mixed mappings
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick rw atomicwrites
> >> +
> >> +. ./common/atomicwrites
> >> +. ./common/filter
> >> +. ./common/reflink
> >> +
> >> +_require_scratch
> >> +_require_atomic_write_test_commands
> >> +_require_scratch_write_atomic_multi_fsblock
> >> +_require_xfs_io_command pwrite -A
> > 
> > I think this is already covered in _require_atomic_write_test_commands
> > 
> >> +
> >> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> >> +_scratch_mount
> >> +
> >> +file1=$SCRATCH_MNT/file1
> >> +file2=$SCRATCH_MNT/file2
> >> +file3=$SCRATCH_MNT/file3
> >> +
> >> +touch $file1
> >> +
> >> +max_awu=$(_get_atomic_write_unit_max $file1)
> >> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> > 
> > Is it possible to keep the max_awu requirement to maybe 64k? The reason
> > I'm asking is that in 4k bs ext4 with bigalloc, having cluster size more
> > than 64k is actually experimental so I don't think many people would be
> > formatting with 256k cluster size and would miss out on running this
> > test. Infact if i do set the cluster size to 256k I'm running into
> > enospc in the last enospc scenario of this test, whereas 64k works
> > correctly).
> > 
> > So just wondering if we can have an awu_max of 64k here so that more
> > people are easily able to run this in their setups?
> 
> Yes, this can be changed to 64k. I think only one of the tests need
> 256k writes, but it looks like that can be changed to 64k as well.
> Thanks for the comments!

Awesome, thanks!

Regards,
ojaswin
