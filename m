Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4EB393DFB;
	Wed,  3 Jun 2026 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780496424; cv=none; b=qwWVF4i17Sh2Y2wX8G+oA0MyiuXaJQXh2KYZtmFfry979z4Vdjr1ufo0VqhZBsDgR8h6sawwKMRzWYRgo+4uJd83hJ10rgqgskL4YXEnxVkKPZZz7qQ1CAT+CBTWRoU1TlKIOpJGxonQxO2bUihK/H5TyXvppCGoIgd9YDixImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780496424; c=relaxed/simple;
	bh=C1G80uloHWbUU6TtGpDyrrZ5fYXrguyugxVwzv3/exY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BaRNT3ik0vxFVEUFY1W7enf6wcbtsSLKqU3aYLptGEgLhIGJIS8A26qijXc04kuXQHSBSKGscpwwFpFdzxXsbq5k7pS+4zZsTzhzYdF9iYskU73/mMDC7iSR7cCNvu6nab4xePSFFR7px4O7p93FYUr3iJtpL2lV5m923GYV2C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XjBvNZsp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XjBvNZsp"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65360Rdx085385;
	Wed, 3 Jun 2026 14:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cs4FH4
	t13OX6OckvaNIKxHNFja8bAQpbZHTYZ+p74Fo=; b=XjBvNZspEGKzuCkat9z4mp
	lcm/gzKaiv7AclEur67E78UXHuHC2129mGk/ZYJ/DO9NqR8ZLYS5NyLmzJXrIxoV
	l1L8sdSyFHOUBZdCAVGpiQFB4qjvCk3UAEZDBj/8EPcdU9Qs7Igfon5pII/oa6ID
	D8MkRA/VzByu0MXW5tcigQVv0Y9K6it91VfyLFVt5Apq6UZ0laMXJfA5IBI/67uu
	qRj31uLTfz1N8z6v4kCYWC2ATgxwfQI4E1C7UdQo8x3q141cely++NjXM3FsK6B3
	0bWndFW9F53TfrblWFBAyXpqVQD5sufxLcPQ7pHvWicXV4KlNvw2PSBaRsGNNMVw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efpaeatn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 14:20:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 653E99wK030529;
	Wed, 3 Jun 2026 14:20:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egakw0n0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 14:20:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 653EKHM847055354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 14:20:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 421BD20049;
	Wed,  3 Jun 2026 14:20:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEC6E20040;
	Wed,  3 Jun 2026 14:20:15 +0000 (GMT)
Received: from [9.124.223.193] (unknown [9.124.223.193])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jun 2026 14:20:15 +0000 (GMT)
Message-ID: <6405e164-3749-40d0-afbe-8e2ec6807b84@linux.ibm.com>
Date: Wed, 3 Jun 2026 19:50:14 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] common/defrag: Skip defrag tests on DAX-enabled
 filesystems
Content-Language: en-GB
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, xfs <linux-xfs@vger.kernel.org>
References: <20260602101418.55131-1-disgoel@linux.ibm.com>
 <20260602200930.GB6054@frogsfrogsfrogs>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260602200930.GB6054@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Zt3d7d7G c=1 sm=1 tr=0 ts=6a203824 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=O_2PV3spL_lJ-ijEIfUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: WLhPtRNsMg4jLAE3G5aifuuPa8EDqQAm
X-Proofpoint-ORIG-GUID: 9warEHkdJVfIBME6a2S_1Yft8OwWOSWQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEzNiBTYWx0ZWRfX+lbXKLB7SR6Y
 djPoTmYuyUEPw4aM41eP1C1m/9piYQ13Qq7wfe39J1ihDloD/HyImpOMWE8ZA6aeEM7fjeGwdhr
 K77EWzuNggyTWwdR4ny4jmA6MvDmgHuZyK+84Way+a6/Syvvbg9W0BLvhKp8rbdixruibO+ZpeA
 3snsLbV9F6gNq7M7mQ+Eh88omVEPuMb52eTLetnmu+nf3QqOScEaKZHgy1GEKSYIQPFhzAVH2yf
 qhYx6PnQJ92iXo64QoGs0U1pijFS9VGD12y/jzUlJQrdbziGwtp+DJqeP006ZXViDPxQn5APodH
 7EZ9blmcwztKs30Zx2/S92vNvyltEt3HmsG8CKUlpWdUcQDMuZA+vulpddjmZq9lT67JiCwRfac
 ZRQ/EIWv/y5RSy01tvE7AlvGfyeLTBSzb00/yPnQWizUN47FrPUl82lMx1YL2BdyDrurLV0ttZe
 725yW5Gq46pZZdO1X5g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030136

On 03/06/26 1:39 am, Darrick J. Wong wrote:
> On Tue, Jun 02, 2026 at 03:44:18PM +0530, Disha Goel wrote:
>> Online defragmentation is not supported on DAX-enabled filesystems
>> because DAX bypasses the page cache required for defrag operations.
>>
>> Add check in _require_defrag() to skip tests when DAX is enabled,
>> avoiding false failures on ext4/301-304, ext4/308 and generic/018.
>>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>> ---
>>   common/defrag | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/common/defrag b/common/defrag
>> index 055d0d0e..28db2f7a 100644
>> --- a/common/defrag
>> +++ b/common/defrag
>> @@ -6,6 +6,10 @@
>>   
>>   _require_defrag()
>>   {
>> +    # Defragmentation is not supported on DAX-enabled filesystems
>> +    if echo "$MOUNT_OPTIONS" | grep -qw "dax"; then
>> +        _notrun "Defragmentation not supported on DAX-enabled filesystem"
>> +    fi
> 
> Defrag doesn't work on XFS on DAX as well?  It seems to work fine on my
> VMs...
> 

Thank you for pointing this out. You're right — I missed that xfs defrag
works fine with dax.

I'll fix this in v2 to only skip for ext4.

> <confused>
> 
> --D
> 
>>       case "$FSTYP" in
>>       xfs)
>>           # xfs_fsr does preallocates, require "falloc"
>> -- 
>> 2.45.1
>>
>>

-- 
Regards,
Disha

