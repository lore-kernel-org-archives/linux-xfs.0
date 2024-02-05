Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2974E1A2
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171656; cv=fail; b=nOSXQbYsGL+/YT+/7ShUJCplLguApt3Puy4tw4DROxNEhN4Y3tpbFnNZzgiJkRVU0sLIS+ndT58S/vVAIngCsZBqX3ZSKSXcukosk8TlwEV4zB3oaGqw3KpFZ3jKAnVy/riWOzyxgB4AnHGAyRYGSHIxGNqgC9Pa9KR6oW5aT2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171656; c=relaxed/simple;
	bh=yfz0oSKB2JIkPGiKR/CO9khBhcyXMWf4Wh+4Rkp3+8k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K7cuGGu1BYm10AZsYo8mEUKmji2ef8UDcYz5Q25fBGzZ0qUJNN8cOQz2eUt2KkQHcyTbApNd75CbZTThPVCHWupC+iUT7nwaZhivXAAA7jV9246kyM2kavL25+bB8+wYM60pVjS8bB/jdusVJF2pryuEy+eXbNdG+GrnHnERz7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TzJJUmB4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mOiXeO1o; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TzJJUmB4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mOiXeO1o"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LG7Mp020854
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=TzJJUmB4gG6Bp3xu8heyIu4OQSr7CvCcPAHKqpnnxwsbmh2xQKiZJYVxeFYc9Lp1yHBz
 cAmPg+CujdkWgRAjj/eOmAutEKdX7HesF6pXrXNXJt65oBK0DFgD6c1QUhNbkZZ6dyUp
 MCNLOql35iP6EhyNb1mXn4Ng/WMJkxuWkGVh00N3wgsGpsJRMJ9YIKCx3dBzZPIdeJUS
 axjqC4aOGdGifUxhy47vIDAhfSylF80jG4tkInB3eORtS6oxL7MB6lxfaQWahdpDfegU
 bXQFnzDeFMlKs2sEBGrJSzvaU1iCBWFT0wvtxQeLROJuWNGEKRvVDfS9CLmCJ4rpxVx0 kQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbd5bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415M6cc3036747
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e1nc-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2jKrNfegSRBCDCx9rfcwmzHo7TUvuFRM+G75th+MnUgkD1K59jr3yutQ9DbDN+zwNSJW03PjbjVBA+6qETdj351WmbOHU+kNf2FCJNN2sg2QpKogeHBHpEODMmwAs2dn4MtxB0AOF7ptSAUPKP+thGAe6A3NRc0v3X60Adu+m4c6gE3FuL7DhVO00S3LNtOfBV/tsNam0zTuOvTr3aLY4LJMFqMr4Hgc54KvkAe10PXdJMIe38k1+NOq3EFIweUJszRevvNZMwa3Z4SwI6+euOoouT8D42caDnx3paaUzFRtyv2iv03oDGDPHptatS+cH1Wy+lKhHDISkk/4pSzgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=BziqbxQ329vR0CsdDuTn1iEvOPMWWvJy1L/jxFgo2GUYNLrOprVQBu/CHlIOHqwoCD2QiPK+TASDFRmisHLk1hxTkJZoRepsGmNpiy4pHzrc75yxkE0LXZvAbpvYPQPNl4tjIwTpCZQE2QyzcGwOIqNaI83L1FQTBlmbC2lj0a3DFXS52EXgdhSSD01W97OB9VC3S2h1jnNXshKgCU8ro662c6FTZbJO6mMbaDDnT3bd0rF8FdiUfPHNWbqDAt//q9MTaqgNhsMQw/oEo7Kttegynxn2ibNXMbkRH/Ubcx61WMNVxBEfQibkIcxCcA+iW8/zU6YjnCZYds6iK+Pimg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlnX6uAbZdB/vZF7HYgMZrK0ZqIondb8E6yvQsbDz0g=;
 b=mOiXeO1oNr+Xt3NNqNBg2Tl5OFjrzDQP5lV3i+HqJrr6Rf7h21devmZ1FvfwA+jL5ji/cqoDSq5S8H7l0wwwhaUjVBL9rP+6MUQFASrLdVFHyK+RW8zgcU9rjEYHjypB+ICWvkRigQTqLAm1AGBig+uEg/scKskt9/hyJoQjgiQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:50 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:50 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 16/21] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Date: Mon,  5 Feb 2024 14:20:06 -0800
Message-Id: <20240205222011.95476-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0080.namprd05.prod.outlook.com
 (2603:10b6:a03:332::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 978b2068-4249-49df-d55c-08dc2698b5de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	oK8RRNY1qz64PzM9yJSoyapjNcKArR0Ik3OKFSWWPI2NSHM1XQ0G2eb3eHiuUhfu2yKVzQYlQueafdi2p6wFhhZj3g/DHzoYCaN1JotLLLxwSHh/vIbt70yV2dfAJpEwCOUuJCD6oSJ6DGFYh+uqg8Azlj4QLvcEJdtmwPmnvlw2TS0LcPVWgNTDC4DnD6TN5SeOQg1M1UYCkCVMT1W5jpkJhiKeBp/1QK9LTAiUjyhmsgTm4Vvqyn4Skzt4/Rmg9aRqAzYNyVyuRsEDqY2oglp/jIONAm/g3fjI1t5KMXKPFiJmjWc97f6n/KWnJNY5vcEfik2m67RBu3t3n67X2nW86Jo5854CRnCWbnFXL4fEDa4Okj4hmZG12e+F0emU2MvpbqLrjshCp6fkuBId6tGUArXw7moZ7IhVUNkRyTdBMmeVJ1jdQnORljqPASjUHwoFLlkKzeeeUUNvtUqPPE+4OoSkxgbusURAN2mTouPWq4hqzI1cDuq4qtnZPxLLGxXxxHW0RD0/dgSucggGE1mC+Ym5eVH0dyvZm2UyFbz+aOEPyvLzS5R9ZUgGQzJO
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(66574015)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZzU3WnlrN29WQ3dVU2RiOWdqSzBrd3VoZnE0UndzQjhsOTZNSzN1WUQvL3Fw?=
 =?utf-8?B?OU5WNExtWWF6NzNpZGxLWG9WNnF5UVd6MmZpdTlLQzFaVXNrcWwyZnRnZTI4?=
 =?utf-8?B?am9zRmZXSnpRaGZyb0dXYUJ6TlZ3SW90NjZ5RzdFcS9NOU41enhFZlZ3MHdW?=
 =?utf-8?B?UnVZRXZ6YUNKb2hoU2RoUkdLTkJXaUdHL2dkTEY0NFZQN1Y5bnJVRzd0OE5w?=
 =?utf-8?B?VHFnUVVwN0RHUWg2TTdRdGxHa3RHM2V3N0tTcHJHMWJiTmNITE41WlhlN056?=
 =?utf-8?B?ODBKamFXZ2d5K04zeTA4V0FxRjhPMjhCMmd6eDZQR2RjR0hKRVBDaHNtVkVy?=
 =?utf-8?B?UDB1UU5YVitnMHdKOWtsOW1OUk9GVVBSc3Y3bVhHVGVxa1gvMGwvZ1hRSnBh?=
 =?utf-8?B?Szkzd2g1WmFFQ1Y3Zk4xT3pTYTNvK2dabnRZcXF6TUJZdHg1M09WRVNGQnpP?=
 =?utf-8?B?STBoaHpXQURxQkVyTlhSL1c3R0VJVXZ3cm4zYTFSQUE3MGZxdHEvNGtlUGo0?=
 =?utf-8?B?S2xjaHEwM2lqSjF4b0tsSVBVYyt2dzlqU2hpTjN6akd3K05iNDdNbXN4cmNu?=
 =?utf-8?B?MUxITFhxejhKT2I1eGxNZ3RhUCtnY2RPUUorRDVOdXZpOXNTVTdwMk5ndklX?=
 =?utf-8?B?TjRNdEg3eGlDOTkxbXdid3d5SXBCRXNZUmtDUC9LRVZUMCtlVXZ2cnFGdWcv?=
 =?utf-8?B?cDF2VWtiYUtIZWlhT0hBeTJuR0VHZ2F6RnAxcTQvT1o4ZWtCSDd5VEJiYnd2?=
 =?utf-8?B?Zit3cHhjekZBcEE2cTAyc2t1T2F2T0tpWGlSb3ljKzY5ZlU3NEtFYzdOMVZj?=
 =?utf-8?B?dEhQZk5TTE9wc2ZzclFsQkFWa0lPRDNDUG5ERTRVekdVakp1Z3hrSUg5WkEz?=
 =?utf-8?B?RTNjMDQ5b0psTGRtS1QwUzhVWWZDbHdQWkpsZnk3Q21PTzNlb1llTmtpNE5a?=
 =?utf-8?B?czBZaUZGd0NaeVVNRmhONWtXbnFZSnJ6NUUrOTZ6clVYOW5hMTQ2Wk1CbW1R?=
 =?utf-8?B?STNYMnJSRCtBS1NQdnAxWHRNa1BXMjc4VDZQdUxJQjNoaks3QW53bzZraG5P?=
 =?utf-8?B?WXhhOEo5bEUzbTNxVloyR2dVR3REOURnS0tiL2xOR1Awc2luRjVGZ05MWHFo?=
 =?utf-8?B?V041emVwQ3k0Q3hFeHRaWlBwejhQVmlhZHBZR2dJTzZmZlR1cEpSaVBuZXRx?=
 =?utf-8?B?Ums5dG5KcVFRZkMrbXphbGwrSkpIQ2N6MFZTM3hGeS8zTTcrWUNFKzMzRHI3?=
 =?utf-8?B?amJtZWNKQW10STNYRmtvbVpOK3lhSDhzM0k2VEhWb0s5cmQ5YW42RTgvNFRo?=
 =?utf-8?B?SkMrbTZhQ2JITEt5c2c3TUd1emsvSUZWbUVTY1NDbEFVcy9rNkxpbEYvaUxT?=
 =?utf-8?B?TjBpVTJWRlBnT1hHbGFBc2VpS0RIV1A4OE9adnVuUUoyU2VWaUJ6a3hLYStB?=
 =?utf-8?B?UC81bjRPY05lY2ltSllkK0lXd1BGUTZEL2piQ2pEMFQrMGJiNzlmcG1ydmlp?=
 =?utf-8?B?djB0Skx0WnhWTVFGT3ZETmljWHZsUkpPMVg4RTZRZUhtYjNxR2RiMWgxVk9D?=
 =?utf-8?B?VWhQWGFwWm51aVJWeXlPbkx5R1NnTXM2VnpnRlJTUEV0ZE5jb1YzK1pUaitQ?=
 =?utf-8?B?dHF4Nm1YM3ZWZVZKamRGbVptN1A2czNsZWRicGc4b3ZyR1pybmRBWWlBTHJ1?=
 =?utf-8?B?VzhKVDlvYVlYaTM1RU9mRnRJR3RVTkxhNU51VURnelkwMG4vUlFsbk1ycU1x?=
 =?utf-8?B?aU5oOVVRSllsZmxRTFpWUU1CYzQrMFEzSkgrdmFtTm1OYm11Mzd1THdVZjc5?=
 =?utf-8?B?TU9aL3pwS3RGSHpOVEUxRW1GNk1pY1RNZGkxWkUxeG1RRWlleTJPWFRvM2Jl?=
 =?utf-8?B?QWV2RzFvczV5S3VPRytQQUxZaWRvakNzUnREUzU1b2M1cG5iQXdTdDAzekdj?=
 =?utf-8?B?a3hPZmMyc3BWWi9tRWpwREFiWTRVS3NhZFV6S29lRHlGSVIveGNjR1g5MVJC?=
 =?utf-8?B?SVVQVjBBSFJ0cHVzL21mODAwa2hrWnVheUZRajdOR1lmUjBRSzVtZ3ZOTVRV?=
 =?utf-8?B?K3F1Z25yV1laeDYxc0tqSTV4eEI1Y01xN2EyRTdPT1oyMmo0T3dWV1FSRkla?=
 =?utf-8?B?QUJXc3JUajJWYk1wN0VYUys2MythNllhelhTcTh5ZkxSL21vaVdIYzdncGlh?=
 =?utf-8?B?Q1crWW9BY1hnZmVsaVVsN1BrN1V2eFFjbWRMbUFSRVVScGxXNGNyVGNCT2ZC?=
 =?utf-8?B?d1dIbmNBeWRMRmxOQk1OMkdkYmpRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lxg0iieHK5LNk+XWwtva23OihQkR7Gr2qa9YOwJwGXznamcknEWtDgJi/YfRDIAuEBCKixobz6tOE/ZD4r/+jcc3QvifST6DyOJ5zCNERYPW2XJPSKQF6OzsaX0xgTxpUhDvU+S4eypbs+zY0sh0uJSZr6CKyWLBF7PIkxihtyuupu/ww9BRSEVG1q438k6/DKJ45IvfAzhmHN1EOMeZNRsjK9PeDvyzgcxJGmXTXBXyt+xu6GJ7sNb0oqcWEhH/jxTON0HTeh8m501GS6+V0f1QE2IsQCXOmFB19mndcYCLzgJUZhPLw+qKBE8rMngCHWdezjevNGP5FUzOOFAK8es96SgOUThwHqN8Of59g04ilTiF3BVjfC2MESFJ9ppWmDNf9dRpzeewTM7JBd3u9H9LAClbuqnQ3wYFbBTRu9C2GPVi1TdW1Q6XHhTasvrVurtOuww7X/ACVQFu/7Gv0TTbCjDsCmYWRgz+NVUXmxlIowP69hAFFdjtj7AYffAtZ3NxFMkqfA4nO8TxaMwiWShiPoKhyVUMVvruQhrDBo2YoWn8TEslYn28junvPbLF8ZnWC/jtjqanq5W6R5PGH3uV7MPD91dppYJprwN/hW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978b2068-4249-49df-d55c-08dc2698b5de
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:50.8838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VRyaIoMIlEE1AHPZLukcJMYRaHq+JCxnccKYvZzq4poQL1UUJRwWVK/gqiE3MrX/9SAT06VZpUxg6/eOITDHyAebmIImaHDKqo6ZMRTmaQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: raXbrOoFUhR7OHlqo8tgXd5KF0m3qwVd
X-Proofpoint-ORIG-GUID: raXbrOoFUhR7OHlqo8tgXd5KF0m3qwVd

From: Anthony Iliopoulos <ailiop@suse.com>

commit a2e4388adfa44684c7c428a5a5980efe0d75e13e upstream.

Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
intention was to select DEBUG_FS, since the feature relies on debugfs to
export the related scrub statistics.

Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ed0bc8cbc703..567fb37274d3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select XFS_DEBUG
+	select DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.39.3

