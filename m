Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B449928935B;
	Thu, 22 May 2025 10:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747910236; cv=none; b=K6YZN3Ytj1RM/MAim9tzxTcEaXmTvCsEALCC0u60TzxkObuvZbxsZUm7gRSyZgJB3pZYu9W+lz+kO6IK+ym6lISyIVxXBbDfaV7pGb5b7xPcsp+hjhyT0C1HwGEXV55SrMZ/nsO6uNtpPSLIDWxa+6evo63WOGis5PP/eGUW/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747910236; c=relaxed/simple;
	bh=G5uTwWA5i48uL89kVS2szNH3AXBO92HqhLGD441Dsg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mIkHuYdQFQm4tv+3DfoTXrwwfJjbWTrLvkrub1U6e1U7XdPIlufXupZaMQMzoCrfgw54M/dvWZfuQccq6bmz7nZo/UWYdSTZRLpCCeNL2On2Oy/MCoPph06aBobZiVwt/hKQEVmPsffmBrKeaxUz9q3S0phVa0AQ1XFx/qdHx8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=L2MXHquu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="L2MXHquu"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6IhMH008644;
	Thu, 22 May 2025 10:37:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=kbesWa9dQKkaq9kWji8moI4f4ndD56
	XXkK2lUmgwaWU=; b=L2MXHquuxCpNLwpAEqXxvZlgN09BoMmWJS7ogTKhCAYHvu
	ozfrCSUJB9mUC3mGBkgfduU1PArBgVBuW44ZqBEEGfxrSYGxoRd51R/w2b4tghn0
	oB89ggr9yM8uRNfytZoIk1Y8I6J84VHXSW+4R4rQfFegn7d3FkkAEHJhT96pmx9w
	/r2Rfz3VoJMzr3ZqPhxxeEWAAcxHFLvXoZD06ut6V9EH90V1y4qP48dzQKklic+L
	9UZVup33S6WQHdsjnubdznMYydYxGfAlZhLEVp0qnwUsw81gR9m4zrERiAHUl5Dz
	H6Np8D9UVIlIWdHg1me4bR2WRtHozq17k1jaVAVA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhw95ud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:37:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MAS7XU012028;
	Thu, 22 May 2025 10:37:09 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhw95ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:37:09 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9alD5032122;
	Thu, 22 May 2025 10:37:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmh092-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:37:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MAb67N44368262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:37:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 570002004E;
	Thu, 22 May 2025 10:37:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C76CD20043;
	Thu, 22 May 2025 10:37:04 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:37:04 +0000 (GMT)
Date: Thu, 22 May 2025 16:07:02 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 4/6] common/atomicwrites: adjust a few more things
Message-ID: <aC7-TgvZr7NP9O8x@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-5-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520013400.36830-5-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwNyBTYWx0ZWRfX3/ELqwypBOJu CDOa7LnPBWAjZa5hTbnDYAwKyVRFgib0+H5//Hak2zo1aHF9Aq9gfcK+i8zllmjFHaWWt1Ws2Hx +q9YC9nGe5TLdUeWb1Co6CUfDpW+qvMlXjd25iznH76u0ECHlzZ1geVKb1k6tnD7Ad+CRQvZvDE
 lcK/HOj1T0sZezwoCsK19KbM/5VtD2I7TKSwJwe9u3NumWOfwy5qc0oKXLjDQkdkfa1t+UP3N5B gJLTMYW9U3Mq7lTWjV3+7X8nYGEm6rrAxQpmoFuTODbAdLS0+LGjsg73KaP8ewDm7UUJMqvS4sF ZzBNyNTa78OuQSDWCpxy/WDuR6E9vnJ0ZZ8wUSWExR1rCJljF+fP5UQmtUeLvLjWMU8lwCiQ7hL
 dIWRNTSIWsPfpITIxGj/9esbh5/kks6FVs3I9QRR+mcLRSRcloVM2uFY424rNU0ClPVAIFn7
X-Proofpoint-GUID: 1I7bmOsQatL8v60Moc2oJPZRqcs-Lwqi
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=682efe55 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
 a=c0ztrfrD0d-NIN_P9LUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: FZuCBW8SZDm_EA5Q_SV9bqCRU5dRle4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220107

On Mon, May 19, 2025 at 06:33:58PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
> reflink" logic work for any filesystem, not just xfs, and create a
> separate helper to check that the necessary xfs_io support is present.

Aside from the discussions of having a helper for
_requre_atomic_writes_test_commands for SCRATCH_DEV (in other thread),
rest of the changes look good.

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin

> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  common/atomicwrites | 18 +++++++++++-------
>  tests/generic/765   |  2 +-
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index fd3a9b71..9ec1ca68 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -4,6 +4,8 @@
>  #
>  # Routines for testing atomic writes.
>  
> +export STATX_WRITE_ATOMIC=0x10000
> +
>  _get_atomic_write_unit_min()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> @@ -26,8 +28,6 @@ _require_scratch_write_atomic()
>  {
>  	_require_scratch
>  
> -	export STATX_WRITE_ATOMIC=0x10000
> -
>  	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>  	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>  
> @@ -51,6 +51,14 @@ _require_scratch_write_atomic()
>  	fi
>  }
>  
> +# Check for xfs_io commands required to run _test_atomic_file_writes
> +_require_atomic_write_test_commands()
> +{
> +	_require_xfs_io_command "falloc"
> +	_require_xfs_io_command "fpunch"
> +	_require_xfs_io_command pwrite -A
> +}
> +
>  _test_atomic_file_writes()
>  {
>      local bsize="$1"
> @@ -64,11 +72,7 @@ _test_atomic_file_writes()
>      test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
>  
>      # Check that we can perform an atomic single-block cow write
> -    if [ "$FSTYP" == "xfs" ]; then
> -        testfile_cp=$SCRATCH_MNT/testfile_copy
> -        if _xfs_has_feature $SCRATCH_MNT reflink; then
> -            cp --reflink $testfile $testfile_cp
> -        fi
> +    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
>          bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
>              grep wrote | awk -F'[/ ]' '{print $2}')
>          test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> diff --git a/tests/generic/765 b/tests/generic/765
> index 09e9fa38..71604e5e 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -12,7 +12,7 @@ _begin_fstest auto quick rw atomicwrites
>  . ./common/atomicwrites
>  
>  _require_scratch_write_atomic
> -_require_xfs_io_command pwrite -A
> +_require_atomic_write_test_commands
>  
>  get_supported_bsize()
>  {
> -- 
> 2.34.1
> 
