Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9B214A8B;
	Thu, 12 Jun 2025 06:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749709913; cv=none; b=SfAnol9xQWre9vZ09Uw6haSbrZPFl+r2zqhAQbEphhEGHmj+Xhp9IJtdDAWMzdcP89VKtsXg0rL7ZNg8cgcDsaf/HFueEBM8hm+L8vxA7pGI+i4S6jYXruGCcX8iMDWjr4H6dsQL2VYm5j+B/devbwApauuie/Vk7DBsyVumKW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749709913; c=relaxed/simple;
	bh=NQZ8qFQTRZMsS/6N1yqVHKfNEZtTkOrD3v9ktHE0zvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2Jrm1HSAIh2Wm0hPpmqMoUnd2advLtROFxZsUhSJI9jJZHAnQWTpqvsgP79oQ/vGoxNjkhFXRDP8rDBcvSeGY8dKwshLukYf3MuE2CpWZszbpmDvhIb0FYG8HXvdyiitvZU0CarTP1TFMBBuhK4lKVjT56vh0Zop8MQIPKsOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hpC9r4KA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hpC9r4KA"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BNcJLm008148;
	Thu, 12 Jun 2025 06:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KC2ew0yTrFCjBv2Zztas+ThcOL5AFV
	FASg/35oZwxos=; b=hpC9r4KAs+jUKN9dhOLQQWOAPtykBHctNPixPQEyv0QWLh
	x9XVJFch6X3tu/mdX6/psEFQi1McGrekESEwIvFx4hBCSl/Ord6rF8OvfZtFOAtw
	wV+plre1qbZ0Sk5qRWxdnDN4xEjThtd2rt50Q0ESha/WMPEjC+U+3/ENrYFQwWCC
	eH20seRpMN4bNGLZrVlOf5Ao2LySc/1rWROp2tmSElDn8bb1DqZ3LJxrfCTl4kX0
	GzaU0u8NXZBpojGpULWhP5ykCW/I4ckIMpWsJhrwGnb5FoB0C73FpQKLlIkKr7RD
	P02Wyd1ZgUezuMOgVWXhWOncrgG+fWfqLESy3IqQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474cxjh220-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:31:48 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55C6VlP0008633;
	Thu, 12 Jun 2025 06:31:48 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 474cxjh21u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:31:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55C5srVG022820;
	Thu, 12 Jun 2025 06:31:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4750503gq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Jun 2025 06:31:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55C6Vi9G52560324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 06:31:44 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A58FA2004E;
	Thu, 12 Jun 2025 06:31:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 221BE20040;
	Thu, 12 Jun 2025 06:31:43 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Jun 2025 06:31:42 +0000 (GMT)
Date: Thu, 12 Jun 2025 12:01:40 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 1/3] common/atomicwrites: add helper for multi block
 atomic writes
Message-ID: <aEp0TEKrA4M2YPXR@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612015708.84255-2-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w4jl7KgGF5AzdJ2WNEwmcft6IyOAoiVY
X-Proofpoint-GUID: IvQ0t1mUno0sFw9VoKzbg2RYrPZj_vJ3
X-Authority-Analysis: v=2.4 cv=fZWty1QF c=1 sm=1 tr=0 ts=684a7454 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=CNTO_eeQU7POBCuk18UA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDA0NiBTYWx0ZWRfX63kwJJaoLGu+ RgzwQBOfBtvMMwH7PsiLeFQmmPFS8yNDfZGRTIpueP91Sksaas3n8TKXw1tfoyZ4zlQX5dffALr SMRUWdulErTXU2f6cAQgp1Umk8xypxGeYJzBPvFN5MRkEUDU3VZU3X87MeFWZ58YLOO2/VYCTJd
 p173cwNoSGk3uix2OuDrL1V9AWWNi6tBLzLMm2hXii2WJ1RaJRZw7c+LLNJWSd5lrhIElL3TouC qxPimqj68kFq5HK111B9XWUSA2Ku+BKpt71wF/+oVas4oYfC4DN1yWLzNOp7yrNNNXfwOv5pXyB 8uHcw/cAeRyKKxk3gg20Z4fjCcZs5vzYxwGMa/wJtLSN0aOn0Yx8H3/OGDuSw3d76GUIdz4tbrW
 3eFi6mWeFI12qLmiaegEe5Wumv0v39NnPhydqC2jkdaUBNItdp2YUcsO+GN68fLAKZZSjol4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_03,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506120046

On Wed, Jun 11, 2025 at 06:57:06PM -0700, Catherine Hoang wrote:
> Add a helper to check that we can perform multi block atomic writes. We will
> use this in the following patches that add testing for large atomic writes.
> This helper will prevent these tests from running on kernels that only support
> single block atomic writes.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  common/atomicwrites | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 391bb6f6..88f49a1a 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
>          grep -w atomic_write_segments_max | grep -o '[0-9]\+'
>  }
>  
> +_require_scratch_write_atomic_multi_fsblock()
> +{
> +    _require_scratch
> +
> +    _scratch_mkfs > /dev/null 2>&1 || \
> +        _notrun "cannot format scratch device for atomic write checks"
> +    _try_scratch_mount || \
> +        _notrun "cannot mount scratch device for atomic write checks"
> +
> +    local testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    local bsize=$(_get_file_block_size $SCRATCH_MNT)
> +    local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +
> +    _scratch_unmount
> +
> +    test $awu_max_fs -ge $((bsize * 2)) || \
> +        _notrun "multi-block atomic writes not supported by this filesystem"
> +}
> +

Thanks for adding the helper. Looks good, feel free to add:

Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

>  _require_scratch_write_atomic()
>  {
>  	_require_scratch
> -- 
> 2.34.1
> 
