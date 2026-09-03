Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1A0496917
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454726; cv=fail; b=mh0oAN3QmKSsBeRURobwDZPcSQzDxiNb5xO6zkH2VSgoXPV+odUOfY0kJP3/Mrdri4Jeoh1FVmojAHejqNsIgfI58syOcFWrB5ATm8XfSLWN7qneOYBeF8/bO3NtugtL3L8cRd5LfyW50FI0p/iU7RU9A8hPHo0+fZ1AhqTGIdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454726; c=relaxed/simple;
	bh=Mh9XU63jynXjrQSCUzyS8Q7AOLPO0VQv6xXANBPI6A4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MEP08pA3+7VMAucalyyzE3tlkHnOIZQm4pMFtpJJC2cexy8BJP1xyx1X8w4PRdF4pJbWEiAhjmZohBGcf6FIfEnizyONgoMLDBCwStK7BrZPx9dGIs9JAa7/sva6XzhVR6xz6mPLloVqZoIA5ib7m0Jpar1mMyzaBruMzqbkMy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iPAVGdA4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TRqzCX8F; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iPAVGdA4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TRqzCX8F"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 683DrAqe473483;
	Thu, 3 Sep 2026 16:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DMf1NzUu6O0O/3f+kbRUTULtP6VeYC936egq+/0hQq4=; b=
	iPAVGdA4I3EJJcbV7jAKONsOzwoDwmZhwjZssSOH7e4Ei5E5GDsXBhOzGeeEyVfY
	WkEKgeXxpK9OCggRMc29mKwigFqR0b+lLgWe9+y6YKvibRdqr8AS4peZ3EHRSbxa
	EgtbtgYpm2Iqzy4CH2bQXVWGqTqYkcLB1Tj2dcnEYjpsqnuR/RtIS6HiV0s6zBZm
	m34rNYyEPEicRIm7PW/1cw9q6QKSJC+Gk699NjvIugHmFwJ5b/xjYgVyAcpx0c+b
	tWffFmtSKITOdWc/TE/g5ydkW+NRbkOnAxrEi87iksKw3sWl7G4nMtWHi3ZKFG48
	okFashOz9y+HwuX3pbiRuw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbp72hct2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Sep 2026 16:58:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 683Go6Go034197;
	Thu, 3 Sep 2026 16:58:41 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvh411q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 03 Sep 2026 16:58:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jb05izjG7SnNgG7Ea0wbzJSBmPw082gcIwMjX8/ArQoWN/WVfM4GZiAeTCPETjsQwVoTUmdK5QAHpxGxLUrTYoD0r5ztwyPTtofMUWLmF9VtDjcLU69BgfD9DHXkR9u14Se3dGpxb5tBaZjZ3BAUmqO7o0TF4z4QCvv4FNH278PgE3sb884+Nx9Q3tibi3lIaXSSKtATWBK97Kmszbq9PZUACWB7eP2eLf180bv1ty5Gdx6RNvRq1Sn+tPU7PRhFIZzdL83CzdIBNeTYhAMzULe6443w0s0chPtQ4H2+xFOg8GiwHSXIkxTyHNR6IFXvfz9hoQ1EtR/nl12bd4WMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMf1NzUu6O0O/3f+kbRUTULtP6VeYC936egq+/0hQq4=;
 b=QaMv1jVAjgn9i2QpRN/rcDcD8tI5DoIMyKMlNoUNQVy9jR8Pdly73Hq7Y9GJOOlNGhUyDz6cm5MypuiewV0xCvljWyGlfgNlFpDPO5Qplavox/rUJrq7j9Xj6jtfJo7+EV6RcSaKSoxmWosDGAs8R5BM2elaZ2AGSCWmFXSfsohUNArkIttpZLrG1pAwF9qtIQGizVKvvllcaTf8wpXK5D2YxAAnvhAwjrGI/lxilXnraOUdZadDw8tYmlKjOjD3lBT7KhAeJCiD0waWAg8SoynVWIamHCNKVTMyzRIzGAMspCeCFTv780TwCIPrwexe7sb3yjim/9PFZofCkz2pWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMf1NzUu6O0O/3f+kbRUTULtP6VeYC936egq+/0hQq4=;
 b=TRqzCX8FqlKyZkV1SQ3eRDrSUD9DpSWWd1P+bO5TtGiolavkUtlR24lQ6YYLK+/eEi1a6/ntiSorHsr7fjFOnnI8zJwJ/t5nYVg/+GfjBs2OwqUaN5ZTNv12oxZzv3cM2n8AAPMFIeNjxy0oiVufCvQCzDlO+fvyOUDanZ/GGG8=
Received: from BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17)
 by MW4PR10MB6371.namprd10.prod.outlook.com (2603:10b6:303:1ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 3 Sep
 2026 16:58:35 +0000
Received: from BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577]) by BY5PR10MB4337.namprd10.prod.outlook.com
 ([fe80::587:3850:b94b:3577%4]) with mapi id 15.21.0382.007; Thu, 3 Sep 2026
 16:58:35 +0000
Message-ID: <24cc9708-11ac-41e2-94cd-170bb64f9f33@oracle.com>
Date: Thu, 3 Sep 2026 11:58:32 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH v3 2/4] xfs: support additional levels in the
 agfl minimum calculation
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20260902174025.284387-1-bfoster@redhat.com>
 <20260902174025.284387-3-bfoster@redhat.com>
Content-Language: en-US
From: Mark Tinguely <mark.tinguely@oracle.com>
In-Reply-To: <20260902174025.284387-3-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To BY5PR10MB4337.namprd10.prod.outlook.com
 (2603:10b6:a03:201::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4337:EE_|MW4PR10MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d01f15-3efb-48fe-0570-08df09dc97a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	pzMd/ImMpPGA3I6Le4VPIVxfLj4bHZN5c/GzY0KTuOQ8Nfm3m/5s225lvmApUXcMp0G3Y8DVmscxrbquW6tULSDc9qu3iR5x7iX08ci6W6nUe8tntoWoX6T/q2OUP3t3SOffOJnZB0O/YePd3xJ3/6kiMjfAF+LXCcFRK9vQxvm1YJ23Ruv8pUKDUvlg0Ix+EEISyWBbdpUvD2+V4ocVZ7nHpi4lLFxswY+C8/RgFGKDNUnb6+bLvdyi2aj7yGJwKF/HZYfXUc9dk8zlwQpvUuZijyIppUncZ+QDmeCLGJGIt6vRM8/AjnSCtRW/7cavp35l9v9ol32Ki9G1iXkKxS89tadUlYeo8xWq5AWb9CA97ZnPh+q7WVXlI8Zw/CHFj7L/J4VB996niPXQI6+suUXy57BthJ4M3w2Q9GrfGLexcGM9ibK6DwFNfEegf/gEbB9WcJlhoYW+FM/N4UZIwYVuEsG0uZCuTqhIlJpfIuIagHSi/Tg9OKUNBATCxLm21AdZbtMs+Enh4ZqsDCPiB2o0Lr4lsocft8Dx6yj27fhQY814E/ZAjyqDfY0G0dHZt+H8jrMT9iv3G047oOP/Ju0GU+ryWzQAf8kuWEKT7HZ4vgtfFivIlL+I+7tL+jtfaYfqaHRPpQFfdw9ewxuFGzxC1VdobAT9fjsZcGsxcIg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4337.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGtURDZFcDM0UzhORm1KODc5aWNoVGhUanlBSmVrSFYvcHBraldDYXBNaWJG?=
 =?utf-8?B?M1VGM0ZrZ0NCYy9DRHVMMHRpdTVIREVRS21PUTZmV05PT0hySHNBY1U2VFZD?=
 =?utf-8?B?d2d3UVNtL0NxY2E3MjFYSkc3NTFMUVRFdnJKYmNnTkJnTXU0cng0VGxRaVph?=
 =?utf-8?B?NDBGQ3JxMkxEekJOeEJTSGM5cUNWbUtHblJBTDdrOERqS0MyK285dGhwdEJ4?=
 =?utf-8?B?UzBmVUxlNXNQb2xwWHBDQ1RkcDIxL2plRWhoZXpXdVhIYWlEbi9oOWNzZVBp?=
 =?utf-8?B?SFJYWDFkWWNBZlBSdkJxbnpScDJsY0o2eEF1NE5nQ21DTHlrVlJXckd6Z1B4?=
 =?utf-8?B?Zy85RHdWUTlMdUNsM01KczBVb1hWM1VEeFE0cFY5OG1tWFl6VG5zZTNucjJS?=
 =?utf-8?B?bzBMUzVpcnd1bkZuMk8xOTVZUHRmalRYelVhZnJMbmY2ZHpkdUpNSEtkTTlM?=
 =?utf-8?B?N0VjUDlZNUxsV0JiaGk4NnlPSHJkaEpZRlVwRnBibE5QN2VHVXFRTW9ZWTJG?=
 =?utf-8?B?Q2w5VFZ3TWJWVkxzd2M3YmFnajhLWEJLMklNTDFHL2ZIYit4Q3dLNkptdFEy?=
 =?utf-8?B?OFNnTjdCK0dGRktiU0hWMTRFZmVvZU1IeGJORzFsaG1TM0tPODUyU3grRWZn?=
 =?utf-8?B?anJUeTRQT0gyanZycG5TWjhvdDdXcTJobmFRL212eXRDR0ZkWWd5VTdHM3Fq?=
 =?utf-8?B?cW1BVnBSbTVwd2ZqbFpxTTh5MXcvVmFtdERLQ1RlMGcvSE9uN1V4ZkJydm1v?=
 =?utf-8?B?cnBrMUJNQlczMTRUenk1VzZib2RHRnFwUC84SnlYdlhwU0laNUVLRXZkamJ5?=
 =?utf-8?B?UXd6eTUraXFzZk1QRDZ5REhIUWRva29TMTZHRDFhdkIwZFFTU0V0WjhXVWxL?=
 =?utf-8?B?eTdjbCtFWFlyNjNnZ1dDMk5XdEhDSWFWOVd6bllyUG1ianpxcDRvb3N2Qitn?=
 =?utf-8?B?ZUdxeE1mZjJhWXhaWktxL05hQVhDSGZFaWFkMHdqd3NKdysyMXhISEw2aSt4?=
 =?utf-8?B?QzhyNzZyYzdUejA5cXhacWVlSmtsd2xRQk02NWd1L0JJMW5VdVpDQjF2VFdH?=
 =?utf-8?B?MzhTaTNRMEdEd3VvVUZOTUM5bGJscDA2SGgvbDlVTWVFRmJRdFI4SFVBNkMz?=
 =?utf-8?B?WWplT3N3MUVGRlh5QVVqd2hEcDZ5T0NSWVVDZ2Vvc0xMZUNpY3E5UmU4SkdL?=
 =?utf-8?B?T0lKS3hqako4b2ZGbHdIeDVYZkNxSWNENkx5a1hsdlRHMlk3MDIvWFFDdEZv?=
 =?utf-8?B?RWU5T0IzUUFHQVpKclNrTjBrQVpZd29qSFN5cGpERzYrdUpZYWk5YmpMdkll?=
 =?utf-8?B?Y2NNTHVtaFlXeVFmUE5CWUJJOEgzRkJINjdMZm1rMnlURFEvQlp6ZGVhanA1?=
 =?utf-8?B?ZkhPSmZMdGxvbVZtL0JDMmZ0dVpPT2RVaEhzV2VqRjBZYlR2YXVhSGg2Y0xZ?=
 =?utf-8?B?b3o5Uy9UQitUTUthbDMvUEtxdHVNcXR0dmw3bkZ0Rmtqd1lYR3ZMTGdCMG44?=
 =?utf-8?B?VWZWVXRnRVRXVC9WSVF4VmJSODl3d01EQ00zSWR0K3gyTW1YK1NjY3phNVpV?=
 =?utf-8?B?QTB2UTRpdjJqczdHZk5ZWkUzRXA5d3FOanZqRVlXUnFUYUhNdi80cURQbExl?=
 =?utf-8?B?OSt1NVlkcnlFc0NYMXh1c1RHSlhXU3FGVFNJdlJiczlHK0dJbGJkWkdVZUFx?=
 =?utf-8?B?TzRvenFiRlhUbjJ4NVJjWFpZc3Jvb3hSc2dKVmM5WE52cmM4aWw3eVdlcWQz?=
 =?utf-8?B?eXBQOEptR05oZXlxckVlNFo4ZlNhUzA2Y2ZjcHlta3ZySGFIUVhTOWwydEd2?=
 =?utf-8?B?L1IvL0tXbVVoSnNYVXRlNWs1bG1IT1IyVGcxWEYxLzI1bmpGWkJMWjJKVE1S?=
 =?utf-8?B?WUtWL1pkbkRBLy9rb1oyUjlqK2tZK004cC9qRVF6ejlTc3dUTkVNdnllRm9C?=
 =?utf-8?B?WW96OU5BKzc1K3pnbUtzM3ZsV24xR1h0d2lmZHk2RkRSYnVGbnl3Z1NEeml3?=
 =?utf-8?B?aCtiVU84TG13dVNMOWVzMm5hbElUVWNjVjdnSjlIL0MxdVh6azgvbnFZWUxi?=
 =?utf-8?B?NCtiTTZRRTNmNjZ2bFpSeE5ablpPQzJYWSt0ZVE1NUVvNW9JTUovY3NpM2hU?=
 =?utf-8?B?UWdpZHNsNU5pYXJEL0MxRjQ1Z2RKQ0NtYTlCSFpKYXA2VDB2clU3ZUdoTEh1?=
 =?utf-8?B?QlZreGFsU01CK2o4N096QXd5RnBTSnphVHd6Q29hdTdJZ3JWcXZhc280OHpp?=
 =?utf-8?B?WmpwZE0vdlhvdjhBMFBrem04YklFajlUeDhWL2l0R1ZzWjlIYkhDRHp6ajZQ?=
 =?utf-8?B?OHZ1Qm1KclZUNnlmOTdNanM4cDJ4QytXeTdJTGFsNllpOGxveFVnaWRuTVU5?=
 =?utf-8?Q?ckWHwpc0bpaPcyiU=3D?=
X-Exchange-RoutingPolicyChecked:
	l8wTxXa6stfk0fXVEnqCwCqv4vjPOvi4ox0M1KwNUaMQ/H/Zb+e9cW0brrNPStu6V9wsoRvGcVF+gS/sOfpPejbwpLPCjoPjrhoiL1JJ8bEDCAA+MoZwQs+v5guU3XJkiWRfcHivwn4ps5kaMkYAivrJibodov1jG2YGkWmwRPtcU8KqDE8sQIhKK1YO30WhEryk6gH7YmJ0veRJ6xhHkuLmMyls90/3Kav2tDcyv4GJLLnSWLm4SLwz46G1Qs54QZzYu0jQKQ/jToXNjR41mOOFwfo6rbRSZ6YxHUz29gQ3Ehbs/2QGAx2LNEh0SunCK3DiT5AjGGd9B+qqXc/SEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XMu/IkUo8Y45dBuSzIzIYojHCWjk2F7RAMmtq+HrO40xdPvzWiSkkmswHWVsWpw3kLlItRaT23ji9a15/55zMIQZXipb7s5oBokcHQOX/45ZXygmMlPP8dUbl8n6dITu7Peze26wc6A3kRGPvdMFPkKYwlQ9GVLg6X2hJwo03xIdNA9mTv7oJiXOjCI5pz3TrSeKs5kH3CQfVV+mZ84iGC/Uu6yOWR5ekz1El3dwAnnc0Lw2Y1R9p6MaNhH7uvQR5rulZiGSUNRH80qbGDIPRc0l9lNqmhHfKGaLFZ2xMQXHUzAFF53xD6kj8AeIhOFKnQpiL9Hx6WMqTsJhFzs3buXZFjZxkGBYBklNjCGsr2x+VgTdjRZnKNGksKQ6zg85SEBvhXDe1ZTqvx+qe5khIZxTDS5212zNGrGE/9yVgxdxr96YtcVzbZYHWU+LYjX2VHM07ltEHgLQIFJtDbkimvGjk+qi0xD5vzwFUy973e+st5qH4QncpWc/pDidzKmnsTqWRHh3/tqbmqo2zrOr+rwBhoEGYkoti9VVXmCNZigl4Oi4fIyph/qjurJf9jb7/8myyiLepIrqirNHltMnExMnAELxKRZx8eWV9E2bhR0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d01f15-3efb-48fe-0570-08df09dc97a6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4337.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 16:58:35.4306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1KelL/raU3wuLh+XyZxZTHmxnFQeDARucQDaHRphdguPOydI3JslUuDZNiLbk5WtvNOnMd09B4HZsogS1EcYpTahjlQ+u+mXN3wqUcA4kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-03_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 mlxscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609030147
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAzMDE0OCBTYWx0ZWRfXx2iRRpBobqch
 XB6JNFsMaltDs2JVeEPJQZMO6BfX8Fk5Rl4hRakpVQwn2/JfIPL634fD6oRpaBlQAFg7jaK21/j
 p6l+Bf+2OYAwyirMlSRfiHfOgG0mDQCoj0i6ubm7t9mUeqGW3ZgZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAzMDE0OCBTYWx0ZWRfX+2g1UM6pjg+q
 6nathWq1fR6MuFekGoGdWL+jRtF19DVj4vGzCyu0FHX+kmd0fT8iHZSMUoT5zyu8EvqA+1zWNGN
 HyOCRMAu5FHe6QUquDNnkgHRunyf7bqDAR8NYb1F/WU0XQPtNGtZhPabhkvQdrJnSfRhjUQwFBn
 1TJGUt8V7jx7yDuV7oZfa3ec/tYJpUt88IplgyDA/JLrzKLY/tHvrQPthZiNgDmCOZzGZJXyz2c
 /0xghQfb74XAIMB0f0aAjRP8Hk7I2K+mi79qfQKPDgBhPM8JsB1EJo5tbvR67eK1gxoNJVDMTTX
 5Sn1Jtnr7CVtJ0KO7O3IlOIWDa3iF/EX+t7RdUdSAllaM/F14aeju3255++DwsXJcieZfc8IH09
 cnXvo7VBirDtS1kGcgIrrzVCmkTGhiksyzx+BmU0Um3bX+nPYH4z7EfRoTmH77YEs49yUEnP5Er
 lMIvLeG0EkHePjoD+EA==
X-Authority-Analysis: v=2.4 cv=G7os1dk5 c=1 sm=1 tr=0 ts=6a99a742 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=4uHq8YL4IBPoBP_vM_UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 7tv6Cw5pht2T7NoS6jmPBtFUPf_WgnyQ
X-Proofpoint-ORIG-GUID: 7tv6Cw5pht2T7NoS6jmPBtFUPf_WgnyQ

On 9/2/26 12:40 PM, Brian Foster wrote:
> xfs_alloc_min_freelist() calculates the worst case AGFL block
> requirement for a full split plus partial refill for each alloc
> btree. An upcoming patch needs to calculate the requirement for
> multiple level increases, so add an optional extra levels parameter
> and factor out a wrapper function for the common case of a single
> split. No functional changes.
> 
> Assisted-by: LLM
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>


you can also add
Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_alloc.c | 31 +++++++++++++++++++++++--------
>   1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d99602bcc16f..dbb85fb6314b 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2439,17 +2439,22 @@ xfs_alloc_longest_free_extent(
>   
>   /*
>    * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
> - * return the largest possible minimum length.
> + * return the largest possible minimum length. The base calculation accounts
> + * for a single full split per btree. @extra_levels adds additional split
> + * levels to compute the prospective AGFL requirement increase for
> + * multi-allocation transactions.
>    */
> -unsigned int
> -xfs_alloc_min_freelist(
> +static unsigned int
> +__xfs_alloc_min_freelist(
>   	struct xfs_mount	*mp,
> -	struct xfs_perag	*pag)
> +	struct xfs_perag	*pag,
> +	unsigned int		extra_levels)
>   {
>   	/* AG btrees have at least 1 level. */
>   	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
>   	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
>   	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
> +	const unsigned int	levels = 1 + extra_levels;
>   	unsigned int		min_free;
>   
>   	ASSERT(mp->m_alloc_maxlevels > 0);
> @@ -2476,15 +2481,25 @@ xfs_alloc_min_freelist(
>   	 */
>   
>   	/* space needed by-bno freespace btree */
> -	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
> +	min_free = min(bno_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
>   	/* space needed by-size freespace btree */
> -	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
> +	min_free += min(cnt_level + levels, mp->m_alloc_maxlevels) * 2 - 2;
>   	/* space needed reverse mapping used space btree */
> -	if (xfs_has_rmapbt(mp))
> -		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
> +	if (xfs_has_rmapbt(mp)) {
> +		min_free += min(rmap_level + levels,
> +				mp->m_rmap_maxlevels) * 2 - 2;
> +	}
>   	return min_free;
>   }
>   
> +unsigned int
> +xfs_alloc_min_freelist(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag)
> +{
> +	return __xfs_alloc_min_freelist(mp, pag, 0);
> +}
> +
>   /*
>    * Check if the operation we are fixing up the freelist for should go ahead or
>    * not. If we are freeing blocks, we always allow it, otherwise the allocation

