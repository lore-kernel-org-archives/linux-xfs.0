Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5579303A15
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738671; cv=none; b=shYBpUxhUbO69K3eM0uWIgdk47BA/cXPbK2OyBu8m019Lg3Mjyh92YoFO/a5LQiWrk0PkVLPvmod2+aOaagBfZc0dIhgfc3sQYyYibGRkYg/4MGC7T36fweLdM1YLag+SysiEVPyj9dokgOe/gzU4EbtZl9GyMxbRsFPnncWnn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738671; c=relaxed/simple;
	bh=4Ol6Cx4bCOcCqp06AHqA3yb4q8PeNJeNSCNWgExNUX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUV0xxPm8pvzsuyhwC2vhjo76kk7hESNiWtCxTM9Dv9mn2xqvwgURmv2GiY2n3MhOa4sOya2oBiLVngxdVVa+SKYJNuCJIvge9dvMbYmsq9R0wShB2eTWHsVO+WTPtSp/TfD5pSr85Da9ERAG9MkSKKzkGbT2wzKC3JJdVWVeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CkwVD+Ck; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CkwVD+Ck"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A5Qp2L3475385;
	Tue, 10 Feb 2026 15:51:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NLxCfI
	R5J9uxAuryOIsJXyyvJVVDQN591U0zm4q/EqQ=; b=CkwVD+CkqkgkYteDX8cfp9
	hsbeI7SdfFbM1s45yR5c1yBkCn9+V0ryNu/Sm+sW/D5Addn+qL/Cx9qv/wJa7CE7
	MWNdCkg2D2i1u77p+tCWXA9xWdemYiCHlWHeS5b4xxvrTAwIEJFPENCkZQD3eTxY
	tD4anZ+o2QyucAGzaTUBFGF6JoOmwErnIv1zeTyrlV80KUO8g4sUCoomv8cX2Hgu
	eqB7Y6wBysLz4G1EJlNiPoP83ChZ9ek84ivUoUrtfk3VzcFgaK0YGZYMOeIPHkmj
	uzlv3fCrUkriYMfq4kA4EWfuZ/pPHfgvarJI7ZBv0kCrOb/ljP+qmpjQjm8/9WZA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wtujk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:51:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AF1xVR012610;
	Tue, 10 Feb 2026 15:51:01 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6h7k9tgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:51:01 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFp1D830343794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:51:01 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C81A58056;
	Tue, 10 Feb 2026 15:51:01 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39CBE58052;
	Tue, 10 Feb 2026 15:50:59 +0000 (GMT)
Received: from [9.39.28.3] (unknown [9.39.28.3])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:50:58 +0000 (GMT)
Message-ID: <aa0af75d-9ec6-4e14-b680-6b3cbd63962e@linux.ibm.com>
Date: Tue, 10 Feb 2026 21:20:58 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v1 2/2] xfs: Replace &rtg->rtg_group with rtg_group()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, cem@kernel.org, nirjhar.roy.lists@gmail.com
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
 <3234d5a2693e1c18c2e3d34fc45d59118d503b67.1770725429.git.nirjhar.roy.lists@gmail.com>
 <aYtSvJLCAPZXywit@infradead.org>
From: Nirjhar Roy <nirjhar@linux.ibm.com>
In-Reply-To: <aYtSvJLCAPZXywit@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698b53e6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=pGLkceISAAAA:8 a=5asF9uG36T2BCy9-jNIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: FDrvxkkMwCIxvNdT9cKXYyTb211MUOkj
X-Proofpoint-ORIG-GUID: C0wdF3uaohXijk6msvC_OffN8PhEfJSj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEzMiBTYWx0ZWRfX+OIlSC88C6u+
 dsKIpyJECqXEwtVmmFzSxSAt2OThq86zo6mNgDEn9MaY8xKdUIEAFv4nOMD5LKMuAucIEcOIDAl
 qKkpZFsv/KI3BqJ38fM4X9gzLPsxF583PeOew4a2Omx9D7FmP9AWPk2cWjcs7M0ZrKTsLQ48CQ5
 HEZA4i/mUUWkUlfEDOkFum1iBDm2Iu8yQXPKG+V2PmsapYBLOqngl4pBOz7OZrHpH5Z10c80Gqb
 Sx0GEFRrZsnlw6+fv+n4pzJL6qKtlr4y0wG22WO5MXyyuxM7d1DmX6iP4njaA1KLFw+PzBxQmed
 FLEaI5XBimRgfmdwlUs4uN2T4Cn12572FhcGqbVOQQ2zRiT2yFH09leGNJU7qRqdX0P1Go1rHgx
 4EI40KE2HskaXuWp5EDCYl8Ms4HQbWRS4NHJ/w0CrUXMDQK1/uw7ITmrKAkA+Dohd+ftZKQbEGa
 LdF0mhkrCvs1jgw0p9w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100132


On 2/10/26 21:16, Christoph Hellwig wrote:
> On Tue, Feb 10, 2026 at 05:56:35PM +0530, nirjhar@linux.ibm.com wrote:
>> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
>>
>> Use the already existing rtg_group() wrapper instead of
>> directly accessing the struct xfs_group member in
>> struct xfs_rtgroup.
> Doesn't really save much, but I guess we should be consistent:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Nit: your commit message could be condensed a bit by using up all 73
> characters.

I will fix this. Thank you.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

