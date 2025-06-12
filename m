Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB26142E73;
	Thu, 12 Jun 2025 07:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749712072; cv=none; b=ZfEcXa1GQ5zYgCUmO6Xqf8OdQMqPuObhN5kArqDeJTnm0CJYsZR7nvXDCpc/QP7vq6QhpbImZ5sXLluj2yCYk14A5SvhUVMPGDYbjY1pVfc14zayNiNO/W1cfmtBDVZzyA6zeQB289+zDRc9i750SCEbmQ0JEGUfSwUUpyRS788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749712072; c=relaxed/simple;
	bh=4NLZ8gc9LAUAScLvC7spfxUUC8b4x42mxNDZNBImUpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMv4s9Dy+tpch1+E5SkcoLbWSzKcVigY4zDKvlwPIMZExH1lfI/V6bx0SPu/C60TRNmK8WAKm87HedZulRhuz9wNJA72ZSd2kUHFZQCS9rejh4ds3hvr8UrDfRm4ZnHLsE5MgOQJpL/ANRTNGHgtQVrD975lurE0uRMh4a5rWww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R5PLVVVC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R5PLVVVC"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55C0Ua3F031334;
	Thu, 12 Jun 2025 07:07:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=itubv75H31cYAkXtdOUX30FycVPbJG
	ZcK9m9Eh2HpS4=; b=R5PLVVVCp6TBKcE44OaRiL6IVu6BXOommloWlnBS9/cgRS
	huuncPk/aO3gcCKLqTj7Xu+6sssYrEV1Ag/fyuji3lsDwRvc4tZT/WMhdJPE4bpt
	YBUpXvZ5vJBQKkJ81uRbmu5LfccRX4O6AUWYW58tQ93yld+whUoUHPS7GQwoCCMZ
	DvTVX9MtQwORIF4V7MzYnDMeIjSJ0zjuAFiYewVBt1V1ULNVVwsT9uksHYMw1AmQ
	/kbL0IbRdtQWtZKzv/Kl8RuMsE9NUawkiiwc+w0nEDbfabOqM98XS4I1s5ZOIs4k
	brQpLULJio4dx6BOxmhacvSM6iLygsI0Hy5zoOVQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4me738-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:07:46 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55C6kamg018829;
	Thu, 12 Jun 2025 07:07:46 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474x4me735-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:07:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55C31bC8003367;
	Thu, 12 Jun 2025 07:07:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4751ykubuc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 07:07:45 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55C77h0v13304228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 07:07:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 904EE20043;
	Thu, 12 Jun 2025 07:07:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25E0220040;
	Thu, 12 Jun 2025 07:07:42 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Jun 2025 07:07:41 +0000 (GMT)
Date: Thu, 12 Jun 2025 12:37:39 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH 5/5] common/atomicwrites: fix
 _require_scratch_write_atomic
Message-ID: <aEp8uzE5Nj3vygVX@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250602192214.60090-1-catherine.hoang@oracle.com>
 <20250602192214.60090-6-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602192214.60090-6-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Y4X4sgeN c=1 sm=1 tr=0 ts=684a7cc2 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=CNTO_eeQU7POBCuk18UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: z5tdqCNHB0ZE_TP7mYQ9i8hYr_7pAKpH
X-Proofpoint-ORIG-GUID: HEt-g8DlTXPo3XDMkQab5GMwKfNs0fhD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA1MCBTYWx0ZWRfX7XQx+7brNCd/ qgI0aPK2g86rdlJABEDSQCfhqPt3np+EBJ+xpFR9RqT3sezToL9J4uSzV/D+lb3VvFw3Lz9uAaS iSMUzKYbJ6k79FLzbkBN0vJX8XKD0mxN9yjl+boiGmUxz6PXOlxUU0gFV7MGLErNtmnY5RN8EWn
 mnyK6i4Mh6XIoHRJ/Cas0ULxZQrmHUdgrVfy0G/pK0/PLkH/uronivEcJlhYrpmgoQZVnreNvXt T+1f4VtvUJJ+Mihtd8VdNS8YeedHMueMOQ5Ko5y9LdzgiXeT3mp8hk8NMjPy4ohsbYZ1fQnamhl 9UXHzOTG787gBfiiLNHisWXYQF/BSe4MDn9KjPd7OjxEbT6O9ns6UcmCD3e46JhbTvv2llvEpgx
 RYLI8m2lnApfg8y28ZcZHsA52UPoxXd53gnwdGiYjw5IiLPXhFlBRwVbLhHWTMvJZIRvtQVb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_03,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=951 spamscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506120050

On Mon, Jun 02, 2025 at 12:22:14PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Fix this function to call _notrun whenever something fails.  If we can't
> figure out the atomic write geometry, then we haven't satisfied the
> preconditions for the test.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  common/atomicwrites | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 9ec1ca68..391bb6f6 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -28,21 +28,23 @@ _require_scratch_write_atomic()
>  {
>  	_require_scratch
>  
> -	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> -	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +	local awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +	local awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>  
>  	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
>  		_notrun "write atomic not supported by this block device"
>  	fi
>  
> -	_scratch_mkfs > /dev/null 2>&1
> -	_scratch_mount
> +	_scratch_mkfs > /dev/null 2>&1 || \
> +		_notrun "cannot format scratch device for atomic write checks"
> +	_try_scratch_mount || \
> +		_notrun "cannot mount scratch device for atomic write checks"
>  
> -	testfile=$SCRATCH_MNT/testfile
> +	local testfile=$SCRATCH_MNT/testfile
>  	touch $testfile
>  
> -	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> -	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +	local awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> +	local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
>  
>  	_scratch_unmount

Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Regards,
ojaswin
>  
> -- 
> 2.34.1
> 
