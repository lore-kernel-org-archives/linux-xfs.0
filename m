Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DED288C93;
	Thu, 22 May 2025 10:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747909585; cv=none; b=qBBJ5fjBsDWZsm7wS48BtJugKivL67rE3VgV52DgFz1Dr1Quz64zRi1mgK5EjJgZL83waC7DteRoc+s0cYvVgZtTsvXtTWyw/UCo1OGFwvwJ8dG0Ef1k0hZFhK8wnNc2KqtWQl9cKHF1+wn5Lf7qFrVwCftY5/fJzC8IkAft6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747909585; c=relaxed/simple;
	bh=8vYAwUedyt4AHou1Vjto6dOMU/ilOVwybfT/A3rAriQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtoKBLnr2V68a0S6pii35ojOUpxEbYuMkDrQYYo1WuLJC07mjwNRje2se6FFisXZ5ePSjcV/N4H83aAyFqFpewVrxeIoTJ+YMARyKx3+BN+CKhTZYF14CTcUEU+TZhWniuZYzbhTHAviWL8Y0YCdl+ZiejliqDnV+Pu3eT1AaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JPT5VOtv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JPT5VOtv"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6IXI7008422;
	Thu, 22 May 2025 10:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=LT+w2AF5FFJx9WyMKhjxS4zaCGIOHL
	C/4f+PhUZWci0=; b=JPT5VOtv/4N3orzQiXBFdkyYf6q/nNWIBszCSq6Z2PiAoq
	gPrs99FFMlI96B/hlO1srEX4ETmidJ2D6riaTK+9p28bGTb0lkTsS6q/0zrcmzKf
	P7JXvTVNUoOrKAqimOtc+hMz9xU/pWGLB4Jk/GIHEgYbfNWV7sAvPaRHm0FaAyP6
	dVLgKpuqOaVqoRDNRBFDK5n81MyfV5rt585aAtMTq6F9CXwkXfldIZGGwmNm0IWh
	2ZtntBgdNIJGFzQIKc2Tv1GgXOdpFuwYs8f1YgANq+Sqjz2ZBoB+KMwo120jzhrR
	MFaUgfyO7x61boXXJsKEK0LO0TcsV5yb5pxWNgWw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhw94qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:26:17 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MAP4Dk005826;
	Thu, 22 May 2025 10:26:16 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhw94qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:26:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9U2nw032091;
	Thu, 22 May 2025 10:26:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmgy80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:26:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MAQEBo31982004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:26:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E13D2005A;
	Thu, 22 May 2025 10:26:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9948620043;
	Thu, 22 May 2025 10:26:12 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:26:12 +0000 (GMT)
Date: Thu, 22 May 2025 15:56:10 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 3/6] generic/765: move common atomic write code to a
 library file
Message-ID: <aC77woH72592dR6g@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-4-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520013400.36830-4-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfX0XB0rCdhfVUe oEXE7iCK3W2Ktx8LG0VdHHoYG+bKm+i5i0bns4x/c1HNQhSBSoYmt5t/zvGKXWN/GfWMqTE6dYW cuu89sr/COmQCU9LCRDU2BWAKW5oPHRC/9gQhzeIf4Fev0D7uQRDCsjjW84E2FYoZOeqV/camGA
 Q/1SpPN5tp7CL6bwPCWa3FzOxTNqJL4q6WLcSJ/XwRTB7kPS0mOtka2tbnUXR8z7/EV0E6ZYTBm mFE2zFd9kS6zLwL7VHpF/U5CuKI/4DLT0o83FGB73JEN8kaesIxrsdW8ezIF7SDG1cYoXj0ngso BekLlNPIAGdl+0E3qaYkc70BmBjkDXcbeOPcBb+Zcs2m5N2ltEXlx23acOjuFaqO8X74ya2Jzwc
 PuWGLUHzPrWk8SbEp4TeD8HXE4uwjOzBqkuVdyC0+6KNMKhKYOy43Kkdv9ZIvS19HCJIVCFY
X-Proofpoint-GUID: gGr6D56i1zHsiKeU3I7f_TfPpNyv-NwM
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=682efbc9 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=QGcxWgy3iZzAVIVArg4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: DOvXWasrQicNwLUQgzZ7XthTGMWOtu_6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220101

On Mon, May 19, 2025 at 06:33:57PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Move the common atomic writes code to common/atomic so we can share

s/atomic/atomicwrites/

> them.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Looks good:
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

just a minor comment below:
<snip>

> ---
>  common/atomicwrites | 111 ++++++++++++++++++++++++++++++++++++++++++++
>  common/rc           |  47 -------------------
>  tests/generic/765   |  53 ++-------------------
>  3 files changed, 114 insertions(+), 97 deletions(-)
>  create mode 100644 common/atomicwrites
> 
> +
> +_test_atomic_file_writes()

Since we use this for mostly bound checks and single mapping checks,
maybe we can name this as _test_atomic_file_writes_sanity() or something
along those lines? Im okay either ways, just thought its a bit confusing
to call _test_atomic_file_writes() and then doing more tests after that.

Regards,
ojaswin

> +{
> +    local bsize="$1"
> +    local testfile="$2"
> +    local bytes_written
> +    local testfile_cp="$testfile.copy"
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
