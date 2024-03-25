Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F37317F
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404509; cv=fail; b=M95xyxxSGqC018mTK9h10ee2luhttKXBIyUo+67Banr8HAQ3hRIcs0GUPDs2xYhr5NC55AIhLsWAvc6bZFYL7+2DQC1MuUI8eEoXostWnQiz4MbVbuuZvUaTd2gnWLXerJN0TIMVifaeW8+hD8tULfoC0Le1DzyPW+eVWR0kqh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404509; c=relaxed/simple;
	bh=pKdC/G6Ih7Ig4Vf4Gc/Z4ZYqIoS+h5vUlA3n0z3Ra+c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HGwSshNCp5uUOR8MbsThAlrZqJVAt1VyNBcisT9dwMkRLVztg/0+GJv5zhfhPO1T62856/GG00+SgMVIib9zduSZ6OluQIG1ThpDABXF5gFYY/VLOU7ay+C9EhC1BK0axuNgNXSfggRtzcOBNby48jpl/v8yAdsrKCmALoiT5Ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fj47CYXY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XJIjSHHg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fj47CYXY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XJIjSHHg"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG7r7020631
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=sw6i7h+4dxG3QttKtuRnO5ujt2LKRN0UyL9QPDZOLBk=;
 b=fj47CYXY3EKH9o4r5Tn43wZWgK0+o/QnKBDbs1xpfe5axmRSHdTMRS4oMINgvB04uMfv
 lQO956Je3VTpXI+8vJPqbRcRDH6IAzFrho6LQSkldyJzaTJR1i4Mf27DOpcBtJ+BEUkz
 zXbrNYoIFMAh6FsgrKPdn704Nr6OZf2ooKLQM2djVq5tj2EvDYJCP3tfTPyWldu9cUDt
 aJIqEay+z7xEjzMMfY/h7zZK0/BVdYRPOiHH05Me1Sm3avNJ8UidyO6k6jL9sgDWisRX
 Ycp8uAF7YUpUZJJYnMHZu4Bs4b71lCk6sOAk7RPdDjLbq5WUz382BvpS6jrvIm1YDMlj 0w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct32h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKPhAN015960
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh64raq-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOJxLvxSHn7OyxQyrIiUf6OQ35dqwWvOFG13sjMhArY75eDvvk38WwZhCK02sUovmWE4S7vA0Y81npbajWVCwoSQnIjDDzll+BJYsIxEUo3APD+F2knzpt5ymo4W2NsTjLE+5j9VEqv52fy2jrGmWHhjTXnLDJWSM8m/xP4kwfPyZmPbR4H1r8P9INA47aEawwnRLX9CHpolbF5vdjhg5UN60KwhvrkjXNe6qqkTpMRAwE8UfsykXFjgYZx/EPM9kx3T3EUToYuIkMXLQx4itz3DCa7rLCoSDOL2GyBEkyTFLq+S3AtdzffLhB2x3S5dbDvXbGiu6rskt1sWnh5Ugg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sw6i7h+4dxG3QttKtuRnO5ujt2LKRN0UyL9QPDZOLBk=;
 b=Cy7tFXtz1lzVHTLPeHzjzqVr9Ulakk3OV0ETXonT/pOBGGz5vbg5HpZJYn8hQZ8337AT1uIG9sDCRQKldm35Y3DmGe+2v8lVq0Gl5tgu7babCa8dgLVDbwdCJDRq7EuPOK+yXc3bIQIzgS87NALNsUI/LfaKXTHNAaqYrI0dE+zhLzLKZc1sGxBXwJpZ4HS3Dx6ENSHcxX1pta1Q32MAkNOSl8qkcssyVqtKggjfHgGZB8izjQqnbsEUa0wQ3lhqkfUBB9Vh0QTOcADzGNnCCFAimQECeoH1tkJGRyhZmTKnhEzzC5Z1L101gxJpvaM8Dt+RHjU41e7+65eA7JUNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sw6i7h+4dxG3QttKtuRnO5ujt2LKRN0UyL9QPDZOLBk=;
 b=XJIjSHHg+1WwShJxHbua7XmNQ9G4vkA+0lYItC9e4komtEMfzKxW2Y51TsUYE1SAO8mYeNjnwysj8keZkGnOaOF8tvagN5R2oREsZVbTzNYObL0ZBkBtyyxp5lvJju2X4NQcHCcpYDRTPytfx4s7qynbeIkGvW1z6diowpXXCoI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:19 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 24/24] xfs: remove conditional building of rt geometry validator functions
Date: Mon, 25 Mar 2024 15:07:24 -0700
Message-Id: <20240325220724.42216-25-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:217::27) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	q82EnUY2Z3q8ZVIEp2/P4WArZ2M4fvOMYypqpQslh+4WatFJkyTaQj8jp7LbuX2SUeDVuiBxVnZE9pRH4cAhsSPQ0O85CT3Gr/HNdtBCCycx+sXItOOdgtp5zM/rxw/OCInSGwTyAVZnH9aNZp3dTVhCHxgqhtMZeoOEpOt1HuecM/Jxz08EE+m2QTLb26q2YwJmkh+jkjZG85yHSeZF7pEj+dpOLMi0fJhhOS1NFhDn2qil00DwdLnJ3QgXgb9XoP8AqZF0yJkTiWPZsOmeRVTu4tJiXXn1WLUT09NSUweBj5zzMx6ATsasYHG6iOGpU3unvVprN9DJTe2WU6a+ol9uhRaBDB49qoT2u3V2zdVYJ3/j17H00oOMYUAqfA50APZhQV8Ygi2XHIaj0go4zE5h0U8CBjSJjqS9GGtlTTtsI1T0nbx8e1sHu1aHUiG+P7QdEGi6uTdg08jCIPx/UJ6JZbQf1yxW3GXTTQaaCEKKXgziupOLrEwXsXUNABvbspNi9aTYqJRTI50RKTu8ljwOeGmLm1q7pQg6wTZ7eCaFguSqNaLnYgDN6DG+6WH1fLFvys2zWAUgWExAkkS5ri9qaG341CnVn/PRs3Fhld1IkkW9QiSf2QjaW4l3O9IdJpv9l2rK84PXJMFZ+uy6ZWwG056ZiQmekocqq8CUGSc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?XwdI+G6iU7TtBf1N4YVLc0GOX6hmWb+Mo7G+gRdOyRSqRzjBNHH6j+m/xT3n?=
 =?us-ascii?Q?uFihPOSMWGvqEMivXdh+mBcZWx+peqPHA06VhndDN5Fk83ZAYI1rG/Lefqdb?=
 =?us-ascii?Q?S6VUXAk/DYeEoFf2tPfC9HEouGsUS2+687dQKpMTOeTXI+/Oq78W9pC6Ff4E?=
 =?us-ascii?Q?VHSU3z1OlArUzKHzoHgR16kjt/adbWohRBPYbHAa7T18QObXmYvGQCr+n9ob?=
 =?us-ascii?Q?YdERfcp5YgARIyNgT17cgPC+gh6XtH/Y2Y2zXNsx0vsRk1DzI/+OYq06nqbU?=
 =?us-ascii?Q?bYc9rXJOwh252QOdeg8kAU2+QiMJY+gn7mABE5ga+J2sNfgfrzSizK3hZMTW?=
 =?us-ascii?Q?EryeZoIYnmS/mAkP3sN3fJizivaOAtRKQL+5Nd/fer1J0e5oU9BP+lJ6mrJ6?=
 =?us-ascii?Q?ei52GTalhrJoPQE5U8ClC0JgEJKF90zDUwJS4Y2gBcrqs9ZCkxrUSR70Sb5y?=
 =?us-ascii?Q?G642u+kZHRnzcXSI2Nj8hafu3UzKG/23X6PJv1DJZja3FIid3MJ6QWzlXUWg?=
 =?us-ascii?Q?GVkLt5SJwJUa3I69cppa0FOxX3fQi3RPao+B9XI8q60iS0wIvvah2cyrvaop?=
 =?us-ascii?Q?bUELZs4yPE//oBUigPxO9Cz6RwSV8NiBNuQ3t2iI9dPLlZoeJ6usG9CD6PFq?=
 =?us-ascii?Q?rq40dwoX2ngARFbvCV/yFZp7Ecd8zuay5+mwqRjr8u53x035xSMELQdjXHyA?=
 =?us-ascii?Q?Gshw6sdGtdrUOSFUGbzkhEFVXaznjxD+hEZ5mNziDqRJtsIzIIu208lPXucz?=
 =?us-ascii?Q?1J6W/6H+3SNO7hwJDiwz/0UugDL41eIsYFHdha1ue4pD68bd1eFUfPSner9A?=
 =?us-ascii?Q?ifDVzzve86ZY+Y5vTNF+57+2QkHGkPRkPIoScGR+CGHsVWOrbL/T1SXjfp8h?=
 =?us-ascii?Q?7SjRML1kTSqiLjs9juEctjCgMUlq8QKvaFybALhytdPGGNYz1ed8WkOSKX+e?=
 =?us-ascii?Q?5MqFMjnchuua1Qclon2gauB6j95GYvzu7TjKdikdeiGv99/9Kw7z4uSz54Lc?=
 =?us-ascii?Q?Rq3fphCUNtI01Pyt39unkbJuqB1vti4Cjgu+1etVYwLwuj8OkpJWo/ixn3At?=
 =?us-ascii?Q?AkTuNIHi4CCiYbjOIbB6WHchqpb9TSfg3lODSycAk0IPW/LWwf59tKB90AqZ?=
 =?us-ascii?Q?2HqMVY/dvj4XzmXcouzh++ZwhVjy78cJHbnwIHNI8i6vBsh8e0aArnnHiop5?=
 =?us-ascii?Q?aevYjU48xCnzdB2cJajtaS9nFDBpa3y3dEREOmia9ANHYeIs53O1XmS3gcuT?=
 =?us-ascii?Q?jiGJNx2AF4+cXgxRmzmswBekSZneY6iOBt3IhrOgqDo2kG3q9wZc8oxNspPq?=
 =?us-ascii?Q?MWL+FhnA3g8Kgeyqu4qNCFjAJJtPeaob0muluoiXoOmUweUVvoD0lmg1AdeU?=
 =?us-ascii?Q?AzlNnHizmyZP43XRzeAau3eXe1rbaZMqjScjj+ccQMCTcswMxE05/Mc51M0q?=
 =?us-ascii?Q?rjrJSo/cRVsC0tKWbXexsFC4Fnm+tf2kUtBKC/4VSNcMtWqA2VMx/qSRc7KH?=
 =?us-ascii?Q?MwUehqtbLsF+3fMAykISxA7s/N+kiuNuGjDq3NloAyH8lHFwshN1yGvdOBo4?=
 =?us-ascii?Q?rsm9i00Z+ln7Qab0wUMAVlB0JyFQpdbQupm2OrNt1+grvpnllhQIwejFxggp?=
 =?us-ascii?Q?+PWGop55oXdf0h5U44/SriTCIH6rkiAwhW70pRBVuN5uFPdvQJ/CvEiDo4JA?=
 =?us-ascii?Q?LzQLTA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sWu2FHbyDjAMnNeIJTQLBdBsJE9AIVtOGkAcQf+XCgTuiTagb/f8lA2mtlsh3USdpdv8lwKu50SnaCSP/kCZ5J+khIkIlSWXeTnXYUrzs6dxenQRNqHQvfppVaQbz/44KXWfV6GwUx7f2OOV/tfrSoG4cqe5RTQ4TlvcszNbzI2KZdLbf263X48mk/WN0T9YrtWFQrxEPBXAidw7nzLZuWQCsdVB0fqPnvECTEwEZh653Nicw25RkoIoQoy8osfpCd2k+jJo7g9UJ3+gJyWQ9Z4Dnrnd5uyMdyDDjC4/V0aWwBtsV734XeHaMTcAQy2mYYRo8EgZ33/1OioN0xILE5dqpoGUKGSRDu/ag4/enz5FwRUC0cQ6zFFV92a280KIH2fQfumMpFd96r2qnqK8r7FafbooXQdt+sFTo/wna7D8npyfM9OYKk7rvkP2DXqp0ipDDQr1LKVEd4NkHKMMhEiF7pEBP2BIVkWMsGKqJz4iaLChNuAk628lcRKAqHrdOWhPdgZ/Dlmm9UxFq0/8/N5v3/q418S5u4eJ9EnMYCkxGqQTfPyZm3ut7Q4PGe4I8CBQb/IZt+rKh3ixPhXAQ7nwkmu+QmeaUIcOvA9fJL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43dd4bf3-ae3b-45c2-fa50-08dc4d181439
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:19.5189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RS1/FNWt+tsLZUc9cTXPLApXy8ZVGiVOfX43iGEue7HcmDc8iFV2Dl/9TiDoT2KtYOBwd78JyT1aJ2yVS4BLiTwc/B+LoAdwV91VwPZipmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: tAvXoeRch2x7_f9Oay6mGzYq8-EX2axH
X-Proofpoint-ORIG-GUID: tAvXoeRch2x7_f9Oay6mGzYq8-EX2axH

From: "Darrick J. Wong" <djwong@kernel.org>

commit 881f78f472556ed05588172d5b5676b48dc48240 upstream.

[backport: resolve merge conflicts due to refactoring rtbitmap/summary
macros and accessors]

I mistakenly turned off CONFIG_XFS_RT in the Kconfig file for arm64
variant of the djwong-wtf git branch.  Unfortunately, it took me a good
hour to figure out that RT wasn't built because this is what got printed
to dmesg:

XFS (sda2): realtime geometry sanity check failed
XFS (sda2): Metadata corruption detected at xfs_sb_read_verify+0x170/0x190 [xfs], xfs_sb block 0x0

Whereas I would have expected:

XFS (sda2): Not built with CONFIG_XFS_RT
XFS (sda2): RT mount failed

The root cause of these problems is the conditional compilation of the
new functions xfs_validate_rtextents and xfs_compute_rextslog that I
introduced in the two commits listed below.  The !RT versions of these
functions return false and 0, respectively, which causes primary
superblock validation to fail, which explains the first message.

Move the two functions to other parts of libxfs that are not
conditionally defined by CONFIG_XFS_RT and remove the broken stubs so
that validation works again.

Fixes: e14293803f4e ("xfs: don't allow overly small or large realtime volumes")
Fixes: a6a38f309afc ("xfs: make rextslog computation consistent with mkfs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 14 --------------
 fs/xfs/libxfs/xfs_rtbitmap.h | 16 ----------------
 fs/xfs/libxfs/xfs_sb.c       | 14 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.h       |  2 ++
 fs/xfs/libxfs/xfs_types.h    | 12 ++++++++++++
 fs/xfs/scrub/rtbitmap.c      |  1 +
 fs/xfs/scrub/rtsummary.c     |  1 +
 7 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 8db1243beacc..760172a65aff 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1131,17 +1131,3 @@ xfs_rtalloc_extent_is_free(
 	return 0;
 }
 
-/*
- * Compute the maximum level number of the realtime summary file, as defined by
- * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
- * use of rt volumes with more than 2^32 extents.
- */
-uint8_t
-xfs_compute_rextslog(
-	xfs_rtbxlen_t		rtextents)
-{
-	if (!rtextents)
-		return 0;
-	return xfs_highbit64(rtextents);
-}
-
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 4e49aadf0955..b89712983347 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -71,20 +71,6 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
-uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
-
-/* Do we support an rt volume having this number of rtextents? */
-static inline bool
-xfs_validate_rtextents(
-	xfs_rtbxlen_t		rtextents)
-{
-	/* No runt rt volumes */
-	if (rtextents == 0)
-		return false;
-
-	return true;
-}
-
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -92,8 +78,6 @@ xfs_validate_rtextents(
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
-# define xfs_compute_rextslog(rtx)			(0)
-# define xfs_validate_rtextents(rtx)			(false)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index acba0694abf4..571bb2a770ac 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1375,3 +1375,17 @@ xfs_validate_stripe_geometry(
 	}
 	return true;
 }
+
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The historic use of highbit32 on a 64-bit quantity prohibited correct
+ * use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	if (!rtextents)
+		return 0;
+	return xfs_highbit64(rtextents);
+}
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 19134b23c10b..2e8e8d63d4eb 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -38,4 +38,6 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
 
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 6b1a2e923360..311c5ee67748 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -240,4 +240,16 @@ bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
 bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
 		xfs_fileoff_t len);
 
+/* Do we support an rt volume having this number of rtextents? */
+static inline bool
+xfs_validate_rtextents(
+	xfs_rtbxlen_t		rtextents)
+{
+	/* No runt rt volumes */
+	if (rtextents == 0)
+		return false;
+
+	return true;
+}
+
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 2e5fd52f7af3..0f574a1d2cb1 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -14,6 +14,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f4635a920470..7676718dac72 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -16,6 +16,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
+#include "xfs_sb.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
-- 
2.39.3

