Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA71A08A3
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738495; cv=none; b=kv0GI6bU7L6SL1zEkVaIGdPsTEVLvmeB6+B8pWrddxraf1z6vWuvcGX+zpLAtAAVM/vFziSBHndqmxFtqZMgbATuHUwHe5D4/uBEDqOQdHeWDHkDlKdqrwF+vKuVKfgQK8P200bHaC0AF6gi4Pfbapx9q9q+4ovv27ehB7gmQDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738495; c=relaxed/simple;
	bh=5KJN60egZHBYcmddIyl0M9NNfNmMuusNCAKMm/gmOJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBCySUomQWgsLq5s8kj25aLxb8CKV3+RT6JMRhy5KLSbCg8EjCUIWncsOQUgczwrbt7T067455PkVq9YlQl4l8xRQq6AaCzqaW2vxszFgjnM7IIpvrJ3HMemd9pGek6WySBL4G6j67b5fh2HRGy+G5We5j9MAGH4+PavAmYEU20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NUIo/REG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NUIo/REG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A7nvsw235984;
	Tue, 10 Feb 2026 15:48:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v5aGYo
	Pbhwj+7RhMfGJL2FtbgcaWKz580EEqDsdKpV0=; b=NUIo/REGy5xsoCe35gDnck
	NOk2Hz5H7h+YPv/t/HV5goiKgdoYlxJDTu74KGcWAyOJ9nJylxZGRm6IbHhbtTb1
	h7dyLbeNxHyJATCBfF6531DD877pM6rs5zTxCc6ypaflb7p+8P4gl72gg1DunRcJ
	tKH2PHcq/iG81Eqr2k35ShRqhrleIx2DO7vc4iHDuMfkkNPEGPhCt+SBKowthhNq
	6CM482NVLL4fGWUURC2JsUNRaTEBt23Epd1rtHmoE6kXwIiS4irCRSUK5277O5/r
	PSqxgePRTYf7agDm5tDHLkqeqa0/M23fJfRILncqa6gx3dkT2TL/FoOMR0O+CiqA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ud16d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:48:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABnpcH001819;
	Tue, 10 Feb 2026 15:48:06 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21m4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:48:06 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFm5Zt20251382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:48:05 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C1E758052;
	Tue, 10 Feb 2026 15:48:05 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B72258056;
	Tue, 10 Feb 2026 15:48:03 +0000 (GMT)
Received: from [9.39.28.3] (unknown [9.39.28.3])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:48:02 +0000 (GMT)
Message-ID: <2df700f9-d12d-4330-a00d-b40dfe5068d3@linux.ibm.com>
Date: Tue, 10 Feb 2026 21:18:01 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v1 1/2] xfs: Refactoring the nagcount and delta
 calculation
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, cem@kernel.org, nirjhar.roy.lists@gmail.com
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
 <b70d0fa35690cb120a6f79a7283af943548acb45.1770725429.git.nirjhar.roy.lists@gmail.com>
 <aYtSUp0m5KUQ8HUt@infradead.org>
From: Nirjhar Roy <nirjhar@linux.ibm.com>
In-Reply-To: <aYtSUp0m5KUQ8HUt@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b5337 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=rWpYmltK24Q33_LO9rcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEzMiBTYWx0ZWRfX961H8Je5jkgM
 16f6MiJLANBVEcYHMK+tB+aEZMOtowx4+Kp7ps93wvvAj773jE+n5ect49VDN1mqUQq9PjIv9cW
 cyVGL5Ke6gTxhBEEgTgYwvV0R9dCD0NT040co2gLZoslLYv4A/Fp0MlYM4+nEh9YGJUsy6gyrA7
 SHJv4QAhkw4B0LhXTlLNVa1Bgg27phkKUIBY+ol2OOM8rQkR+ZYj4XrPQG+njjQOOa0QE74mC/M
 TbjZcSgrJqt9Qc6vwWH7zHxZUNASTSDYOvKHx1ADHeFW2jb9eCAVULe7T14Dmj1R27cYm9WJGOg
 RZiBgbr5RONm7DLRS6jvIWpkVzpBo0EyTtL9+ti9+hnVViwROGrtX44scRGlwdLpDa1gjrFN36E
 v47Mldu7+ZMfMA/AOel6eEr9+fCSS0PQ7Vdi1/8CN9HkYD7pqJXokU8n3Cmhor/y2I/eRaQOnTX
 Xe1zCVjyHgg7jkxK7jg==
X-Proofpoint-ORIG-GUID: 2NlrvC1lLZfps_HldmfkjmCPDD1Pa6na
X-Proofpoint-GUID: UoF3XsQuh9xJoElvzrcYQ17qx1jOrsz8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100132


On 2/10/26 21:14, Christoph Hellwig wrote:
> On Tue, Feb 10, 2026 at 05:56:34PM +0530, nirjhar@linux.ibm.com wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> Introduce xfs_growfs_compute_delta() to calculate the nagcount
>> and delta blocks and refactor the code from xfs_growfs_data_private().
>> No functional changes.
>>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_ag.h |  3 +++
>>   fs/xfs/xfs_fsops.c     | 17 ++---------------
>>   3 files changed, 33 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
>> index e6ba914f6d06..f2b35d59d51e 100644
>> --- a/fs/xfs/libxfs/xfs_ag.c
>> +++ b/fs/xfs/libxfs/xfs_ag.c
>> @@ -872,6 +872,34 @@ xfs_ag_shrink_space(
>>   	return err2;
>>   }
>>   
>> +void
>> +xfs_growfs_compute_deltas(
>> +	struct xfs_mount	*mp,
>> +	xfs_rfsblock_t		nb,
>> +	int64_t			*deltap,
>> +	xfs_agnumber_t		*nagcountp)
>> +{
>> +	xfs_rfsblock_t	nb_div, nb_mod;
>> +	int64_t		delta;
>> +	xfs_agnumber_t	nagcount;
>> +
>> +	nb_div = nb;
>> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
>> +		nb_div++;
>> +	else if (nb_mod)
>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>> +
>> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
>> +		nb_div = XFS_MAX_AGNUMBER + 1;
>> +		nb = nb_div * mp->m_sb.sb_agblocks;
>> +	}
>> +	nagcount = nb_div;
>> +	delta = nb - mp->m_sb.sb_dblocks;
>> +	*deltap = delta;
>> +	*nagcountp = nagcount;
>> +}
>> +
>>   /*
>>    * Extent the AG indicated by the @id by the length passed in
>>    */
>> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
>> index 1f24cfa27321..f7b56d486468 100644
>> --- a/fs/xfs/libxfs/xfs_ag.h
>> +++ b/fs/xfs/libxfs/xfs_ag.h
>> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>>   int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>>   int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>>   			xfs_extlen_t delta);
>> +void
>> +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
>> +	int64_t *deltap, xfs_agnumber_t *nagcountp);
> The formatting here doesn't really match the functions above and below..

Yes, right. I will fix this. Thank you for pointing this out.

--NR

>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

