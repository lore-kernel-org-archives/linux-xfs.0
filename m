Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5767E44E045;
	Fri,  5 Jun 2026 07:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780642949; cv=none; b=LUVvfqsGmvz/Yh4PD1eLqowOfCkoHzLM2tHjnNSxmGM65SxSi0eVwGSZL78jFrbZnKkpAXyc0tXOuXfA9LP0He0ZR17XCwPaxSRGjGcg/GdGB8s4Tc5X4npnsS+iALx8t0NNbiCAmeXYi15nS2h5exHbpxWEDZlrvkq0qnaR0so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780642949; c=relaxed/simple;
	bh=w/+/6rrBfGmqhksp9cE3QPWt/MoxgHkXtUArdGf6IAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NN3djC2NdO6CAwyI4vwID9SlVPo1SODq2KYoKcBeNVQyfF2/l02Cek5vxfSt3bu6OVD5lj4CgYeMT7d8OL8GIeUwWSror/Pjlw9/ayEqf7juGpFnPInVpiN/4C7Lq+Hj4vh8Z9oO7Y7y39zzgBchZLtipwhLSbnQyWWV2cgNUvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cKWA04Gd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cKWA04Gd"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6553q5HC1276410;
	Fri, 5 Jun 2026 07:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lMmZTP
	BvVmAfWw6UHCNYOCnoU5hGtfEHL+4LcPu4gWA=; b=cKWA04Gd+M2TSKGl5kLwrw
	t2j0N5UtZ65P4hC51snUmmLoGICPMMJ6tnD3veP1AqoAH/MaSlr9QK6/yIuh+CdA
	GQquDQWXuzdkzQIspVaRbYKCRC94b6i4psxXyEx17hj26s6MavdbsFLQ6S5gVgNO
	wVGIQhZenuMo6MBXriSKYEpgj6PHXGHksezCkKo4UeRE6lfl+AnAaNYNq5CPTLWo
	xvvcLM844aodwTFehgOcYn0yq/I5VQ1prZP7ebyzup9YXpgq62wpp/9BAHCGbLAk
	M2Qngy6tD57Jgi+HLKGTEEBrIWnFiGlCXlGB1KnjoRp7Z0flGmsSIsqg4FfO8rig
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqm5b741-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 07:02:25 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6556s8Fs006380;
	Fri, 5 Jun 2026 07:02:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egb7kgkqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jun 2026 07:02:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65572MCt15073676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jun 2026 07:02:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B81A20043;
	Fri,  5 Jun 2026 07:02:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75F7420040;
	Fri,  5 Jun 2026 07:02:20 +0000 (GMT)
Received: from [9.124.211.90] (unknown [9.124.211.90])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jun 2026 07:02:20 +0000 (GMT)
Message-ID: <7b7bc867-8cc5-4741-9ea0-eb2036dabbd1@linux.ibm.com>
Date: Fri, 5 Jun 2026 12:32:19 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] common/defrag: skip defrag tests on DAX-enabled
 filesystems
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <20260604122305.39805-1-disgoel@linux.ibm.com>
 <20260604145434.GG6095@frogsfrogsfrogs>
Content-Language: en-GB
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260604145434.GG6095@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: OQiP-1nUzOUUg7e5EercHgIf8apcxpZh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA1MDA2MSBTYWx0ZWRfXwkiwUIFrmnGP
 ZxVU8la3UOrDXOgjV7zcX+PfnG7N+rLJ3myYn9KkgKCHUkQ0zNQRzPrblmZxikpTeQ+ZNiqLMur
 /+lEIWg7YhVuQhAFt9h9a5UWi79yviVJFNy1W0arPGPyZI5LRvWBCHnlQwQmKhXojQh053q4NFr
 Y9yryqhw3Uzq34bwZroqU9ZWEg5eaa3VzTsW9cDOXv12ASS0gW6Kvaxnbn1eVcfZx8MoixYTs7H
 Phtb/v6exC44ugJ6g8PCoMCvG5u2z7tM6BI2HDBzNvRORbs4/JevYCup8iz5Hb2K9cfVCJsMZQu
 VZVVX+6si+3g12FeGX3O0LbyQvM8WmeIvNK/AL3hom6T9dq17yomOY8ehNeIm8atPQ7Fca4Nf7S
 yb/5i+mcto7v+nRpQWjkE6cNl5XrmYMbBBVa1cqAxSLRLsFma7X2YRtsnQrnG4B1FoGGcAlHxVb
 7JIcBfp+vyzRAY5X7jA==
X-Proofpoint-ORIG-GUID: yCLECjlm1GS25DxfgPClcs-ndgmH5sl3
X-Authority-Analysis: v=2.4 cv=Vf3H+lp9 c=1 sm=1 tr=0 ts=6a227482 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=M2Qx3g68xeCqwtJH3wQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-05_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606050061

On 04/06/26 8:24 pm, Darrick J. Wong wrote:
> On Thu, Jun 04, 2026 at 05:53:05PM +0530, Disha Goel wrote:
>> Online defragmentation is not supported on ext4 DAX-enabled filesystems.
>> The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
>> on DAX files.
>>
>> Add an ext4-specific check in _require_defrag() to skip tests when DAX
>> is enabled, avoiding false failures on ext4/301-304, ext4/308, and
>> generic/018.
>>
>> XFS defrag works with DAX, so this check is ext4-specific.
>>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>> ---
>> Changes in v2:
>> - Made the check ext4-specific as XFS defrag works with DAX
>>    (feedback from Darrick)
>> - Use __scratch_uses_fsdax() instead of grepping MOUNT_OPTIONS
>> - Removed unnecessary comment as _notrun message is self-explanatory
>>
>>   common/defrag | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/common/defrag b/common/defrag
>> index 055d0d0e..f17271cd 100644
>> --- a/common/defrag
>> +++ b/common/defrag
>> @@ -6,6 +6,10 @@
>>   
>>   _require_defrag()
>>   {
>> +    if [ "$FSTYP" = "ext4" ] && __scratch_uses_fsdax; then
> 
> Shouldn't this be:
> 
> 	ext4)
> 		__scratch_uses_fsdax && _notrun "..."
> 		;;
> 
> in the case statement below?
> 
> --D

Yes, that makes more sense. Keeping the ext4-specific check inside the
ext4 case is cleaner and more consistent with the existing structure.

I'll send v3 with this change.

> 
>> +        _notrun "ext4 online defrag not supported with DAX"
>> +    fi
>> +
>>       case "$FSTYP" in
>>       xfs)
>>           # xfs_fsr does preallocates, require "falloc"
>> -- 
>> 2.45.1
>>

-- 
Regards,
Disha

