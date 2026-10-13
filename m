Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDC74C33E0;
	Tue, 13 Oct 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884407; cv=fail; b=Ff0huR/MDfxaQLQMGiaJ91CCJzsBa4v2DjUY6wbpSYFDgum3S0aWFYz5gL6P1f5yevfZNbQYtLDuZRYsl2c/TynBUlTh0kLMiNbF3N+DysaRRHKfzOD6EDpyW2LmBuXNpTe1bb5HU+23WWegtwZ4173SBqKuwclCghToqIqVMYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884407; c=relaxed/simple;
	bh=HgsTudX65gsjehdyfMpPtyLnVAS1FPqxubYZ80AqjoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=K3zRdsk+8phakWMFiAoLcEA5Jc0L7fJgLriRABUOJ1j/MFBkxb8QMC+wGQv5OPInXjps/G7H6R5WKTNfyy9KbgLOoSgfi9q1UmuFwy4rCBfeBxIfPyC4Ju/VzOQZi52yHVlK/+e9wM+ZIpx93nXRlI62yWYmSyNqXTHTj+a4r84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SB9u6yi+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cJtmqicn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SB9u6yi+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cJtmqicn"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQN83031805;
	Tue, 13 Oct 2026 09:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=kpsrONGlD+pVtWEv
	FHnn6M9sh1ZuLVMm0g/GEsjqelg=; b=SB9u6yi+WEoIHyM0p2yXx8YUALzQlynK
	fCrNd9K/sf0q3KFqyxfzCRM7xQPfIcZwbxaqMcMS/vdJ2sHGGCyOTq293niCiHd5
	MP2RxpAwRYpVAc4FOH6qUkBFNlOwLLy01V4q1bNVgY6NqmtHkJ6DIUxuGQFF/+oL
	G6tvCy54qjSzY48+a+W8CLnoISi+3oOj+Ov4YGw5utQJBsLRgVEIc0MteaVGzYzX
	HJpCAzXIruBXz47SmjTMK2w2dQrBuqNV9A+hCyWIpU6U8DMsXC13YG+1LaMqsbC9
	lo78Wpd59RgORtPgstaUsJs+nc7rsPRNJMqTV330DkFlQne7RKKgtQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTcR005392;
	Tue, 13 Oct 2026 09:40:02 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2d2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B52N/IRPJBOPu/j9lLJabCtwUivklX7zL4LgNQazZas8Xn5S6ks9wNTTcRK/iaWcWmWFci3+b8E/1vmSU9l0gFgE6O36HOv+W4f3imqqd7B1WD5eGqK4HWSYNQO4DAplxZqZXj22Q/T/nuwEHZF8HMGOI6k3cgPv8jyQd7l3er4VETk8LUBRGiNJYWW0YQ8smbhPT1wu7AFCqk5XLEOpUJ5pGbRXZlXQz2U53w44pgqalZ5I1pMq14Za0f1wVxy4Vyds0C0xjNRcjXJk1rnU0ZUGOtaW5L+bXQt4Ild80DfnVu3FGssouhSyA7af62Z8uLlOzYKcNa+7SdD2GbufdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpsrONGlD+pVtWEvFHnn6M9sh1ZuLVMm0g/GEsjqelg=;
 b=Dd4D07+mFnn/SFJ/jQ3OwRprZvVI1ggJ/YYVDMXj93EBd1kxxHyfJQL+WQLGxNSWUH5guLDpFsEQ0MBV78QM+quqn+OOQ/mVFoFd0J7QYpCe4yRZia1t3mgLM0PEnhmOK7/90YQouCUburmI8PVsKsbqv3Q5ADlvCEKxhf65rTl5LrV3NbVm9lmmCxwWfZhhK2t+LQ7N/BReHTK/X9KVCjwpbxPOeLthHLIPR3Rhgvg1bmHHRKukORWmEGHT23U/5SsSaFhvgX0y+wD/F3s5UUYrbCSjImYdN3zkvtHZglAC7LScD+UvkZL1hokrc0wbpRzOkc9HID0R/TPaLhOGcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpsrONGlD+pVtWEvFHnn6M9sh1ZuLVMm0g/GEsjqelg=;
 b=cJtmqicny4yd2BYCXiBbHab7VDbI7AGvtR2pv1XHcI99g10eVmwYpNSKOAE5pSpvEW/AMK+Ob2OIb2kZLT0LRxt9yKTd2qfR1LfICXFt2dI7ECquQ+1gsvKQLis4jESIxZ20uenxoUIist2zNBRbPYOkdgAIj4CeNId7CJLunvk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH0PR10MB6957.namprd10.prod.outlook.com (2603:10b6:510:285::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.10; Tue, 13 Oct 2026 09:39:53 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:53 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 00/19] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 15:09:29 +0530
Message-ID: <cover.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::13) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH0PR10MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: d6bf9111-38e1-4ab1-ac20-08df290deed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|10067099003|261009223027099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	0DUZ77BD4MT2SXxKxjUj+c97Sjc9TUvDwVAmsOgOjGJ9IwGXWWeL/ET0yiSus2jsAlG6cbsWIXQ7xsmbgGpAT8QfB4lR6iuPK2oinrWtSFvmdYrNVGBVQ5Qss4UAXK9lMhD1/H6OByL7tfF9mo4XZGLikZCmFduE4zRpF05kCQSgZNtpL33zjZmpXGyn2/vlAblj0JXM7AvgtVfZ4nzHeIflN8dqcF7v9CA4qjXpTx8kOsnigr2D1LCmrJucGZNQRWN2cv4xJbNL7tVLmYqh9I0dXkrAt1dQx2uo2EeC/PBb6NN90KCXSBdhmMKPyT/I3a+msQZA+RGoREqes8nb4/0v4+UIhDDSNLBQCOIZyS1i4XmtVIMdQ29gdO18b/DXBc/sGQZD0DgBY1j8qZXtW+oEiF0N68BZjFx1Gh9vg5C/Ul6tPw+IPP+N6PAFV0hK/xhi/mbXg1g2p541P6s9mXkcxJ9ryycHWxbNc7m3/5oRDoZ+TN7CnAk2/O379zzXhPYXF9ZQ1Qk0VVtWILHXUFuRdDIbN4NdbV0HYeQ2m4dwv3Y1Xpk5Rh10r+r7rP8+obKW3/FXXsUmHeacxM422CIwf2EF0xUf9M5wkmbEFs7/itdvnrcnDXxXkn0/x29u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(10067099003)(261009223027099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LT4PYowjDupvmozknjAW87r64sP+K9PPQBG/vryX1I2A7sZmmUAm+fjCt8ad?=
 =?us-ascii?Q?XU4mARhRqEfnqQDwIyN9kq4aXw/HZt/h9HiBO9qHofUFHSGig4NZnjRjZ3Gp?=
 =?us-ascii?Q?53GrMkSJulirqN8wHhKIF93iYlZ1uwHzkf5mnyleNtIf4BKtz5n5srIlFjJM?=
 =?us-ascii?Q?gL5swTUynAqliz4zWdNCpDC0TiYppXIh9z4hSHTehDqNxHklKPW/OlifVHYZ?=
 =?us-ascii?Q?PeZSmOQGl4uCedbqjv+I5ILHMPf0ng+jP2SI5tyX4j2fljtOsHcy0QX31hQP?=
 =?us-ascii?Q?9ntOjXWxJZp5w14duzJaf+h7wsgAF1K9PUIdPxafNbv+1iDcLn03/Oxyg/Q+?=
 =?us-ascii?Q?YYJEmWGWYEr80COFFZY1FORaUIpVw91YAX3i+GYf/RXTdG4iT3YKYxSvDxeX?=
 =?us-ascii?Q?eXbku19PfWVJfsIRu8/N48LAJHgiO/PrcpZM43b1ZUmMacacAyfxnHvSMTZH?=
 =?us-ascii?Q?B/aJSkVdrS1qPYDr8CjBH5P3zH7XHAOvnL+Qs2ooEpfm4/S28ZeoNUj96vEA?=
 =?us-ascii?Q?8PBYTmTgV/305JCMwSxGWEWpyZE1e2IXYyuFkXyPC2p61k96a6jKHKziTbPJ?=
 =?us-ascii?Q?hREdOyvYqts1cl/gOq43wxGgJhbxmAx/jBi8xTp71saYExjYMpw/helxJuey?=
 =?us-ascii?Q?wsuqebPds1psGC+JBHdzH41nVt6Ktkxf92ZRZdFK6xYNuAp/LzDHvfY/+gG1?=
 =?us-ascii?Q?T2FBYZgFwt2MEGHBP7gWwhTUwU0CpXBehgEm7zLMsqHOSyUlijAF8cWCJNhv?=
 =?us-ascii?Q?912Se491TDCGSQnEbUH4gm5PhtpPwtTMOyPuPYEB71MDvXYFnwxqfnzHS2qA?=
 =?us-ascii?Q?f0cD/UeWM9Vg/LKzMvUQ7/OsIWecpK1Zpsf9D1EVmvz+b3UKQEpt1jaa7oM5?=
 =?us-ascii?Q?hFvEdFyMyJI53eI9Fs0Ad3k9qdMiJc9RwgdHaco4nBRCTTGDITlyzIwHPIK5?=
 =?us-ascii?Q?6xauNfdkVGnCZ6OWgWyazFfSaNm+789WWcF9TJNu4ZyMptXgxq9jma6Z2t/P?=
 =?us-ascii?Q?xLVOrQsNY+NrpQNU4c1+uiC28jFjOmK/v8sBosd7Wv+925EqHEbqGr2xTjAw?=
 =?us-ascii?Q?T7ccDKJhHpjehlFJ/e/Nu2QMtLcW0rmHgfC5XoI0zfIr+3yWSTace0RCHp3Z?=
 =?us-ascii?Q?eyPuDpTrOq56z2G00EzwPXK7sQCpY9eg3Z0ZTzlFuDr0F5R7lmJ6+mlQ9+BN?=
 =?us-ascii?Q?pSj6JC5+mwcVgcfXi7IhBNIweYUey7IHy71s2OjZogms08xG9tkbhz2xlhab?=
 =?us-ascii?Q?dj/7i8gBoBOSKQI/d1sVRtMmp7YFm1mA687P7yN5oD0S/mm4zwMvOY0HoBw4?=
 =?us-ascii?Q?GH9p9uxtoC3icHk303aH7tVTtHTXPuLzAtPNCWDtBTBl4frBdh5Nm7N34LQ6?=
 =?us-ascii?Q?drIbXJQJC1eXKxoigUSZ7RiC2GvRRwLDv+DSFwwn2rLtyfTFZFHNnLgJLI2r?=
 =?us-ascii?Q?rGZikIQGH8ua0XuIRhwFetkDD2Y9ILNKBOrqa8EayDcT9k5JLZUF3om5p1HC?=
 =?us-ascii?Q?QlwtgE/YItSzLrDOefNes1ft0ObzD87O/q9TUysDvaJyWhv7RmraAbswxr9p?=
 =?us-ascii?Q?qxLW1I7aYrANr7hQ9XgN6r0i4eOYn3mvt5x8w6oyePB4KZLJqK1KkAlN/O3h?=
 =?us-ascii?Q?+cJphbK4FjRsDaPi39IvLdR84Cfp61DdJbDBvZrTyE4kSE2VwkRkbm/0DkZZ?=
 =?us-ascii?Q?Hf9pi27PW/u+aP0duAVqEMuPyA7WfDqbZ86zg+4rP67WQxajg3s/TVpalR2Q?=
 =?us-ascii?Q?pyzUuQPGqxeJGVfLI+7KN89iVf82sg3v1axZ518fPs7JBF6KMIf0RJNVBwxK?=
X-MS-Exchange-AntiSpam-MessageData-1: kk5bmTNdy83oYihTTXja3KLP4AJZEtJWDX4=
X-Exchange-RoutingPolicyChecked:
	fHS4kxpUwoPpd1pQpXYmgtkfHw8pYzloSCORHfSadDQ51mMPXemmYy+zbG8On9XmbcY6Hncd7wflEyY/CGTXZQhTpwGoX/eTFbqqwpolsVQD7MXxlJ7gVVT9SBVZDHYrHlhYewYuvvlUYaAH+33sBkSYp4gFsQYwSEr2G27FB0mBUMPo8K+I5fep+rX1QLyIGOakSyCf+2XJDoxDz4BabE4w5J84dP5jAFd1X7TiX3/M00hOpkUDX5dJp9CX0J3Kg0qERo5qis/Vs6gU3Uv0i6e00R+HiB901ecr2QNDLUOLw7Tiko8vhe0wKrsvNaCtSnFVXzfctAI4T3iWVpjvHw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fqNajGkmfYac8InSwgXuYjVRoJxkEkjqDG2fGP0HWIgwt0uHUQ7PpfNCb1zP9A4Gjo/FB42PGhxrHU/1SJ+n2WCcGopm4J0fcbuHAiI7CMPb6+3gJLnlzs1r2aI57u1AwOt3v2+f0SeCNiVCtazzUd1M3WYpiqfgKm/6GmNRbzzQorsf+Qc4LK5xqsxE9pRh55UDNl/2zSs3gow3hRvzyxQ1U+PrBT4QYgIhBD6QeRwQsF1552PrtT7m+X/HFSEcMJCku3Sz6oJoO4VWsfGziFspFOIH0i0h3kKNgMP+OsAGY7XEKvJgYEj67tTOk8fC4/nvOt53oerC85XMGDh6Zuhjm5Y3MPWIyYX6CnyTpD35t+4yz2fZLZLE4X4qL+dUwJdzBei53Plz2NdokP/mRV1BO8/rNFivkUsrJmpXxp1cjNpTVv71Opr/aqpDCcXSb6FvWlJatIgmhltTsjkJz7ypGnRbLpi1r4qdVvANDK2fzHb2ztRCMt2WqfGv9uDeFLB6qkZyq30y2k2TTvgOjCHVTo257ZrRhfvV1uvU73Dm1LNZxtJBPwlcxYLW8+9OClSbohAMBVfy+pugnxGC4PgcemO+wWU3LIrk/N9n1RA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bf9111-38e1-4ab1-ac20-08df290deed1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:52.9230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0TAXHQx0T9MagtdjSI2tBz9L8985eMYviWnRbczcGf8h6wFwcahH4iuNaS+bZPyPWwdsY8rq0C3BHQrVfw3g60pg8a1Oj66r0ntUibApHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXx7aZcRRlohfB
 UcCHXKvljBDda9Ivu3CkV2VqK6/ctvTlj+ONotlp50Y1O3/RZXrCENU7T5Vyq0jtlFHBbjqqQY2
 WZ5yjihi7mVeWasqPM1//BoveLgKa1+HJsG4BFG98xfJJpMMbdmygXneMj6Cc4kOPk44UXLRdKU
 1OMT2Cb0Oxc3QIPs56g6S4F5S/MpbLR7QG2wTEgFhAfppPWCnZxZfrZ5WY6uHydm8Gzrgw0BM6z
 QqL0LYK/5OQJNCWG8eg8hUCzXq70B/sJaO1c8mkXuMTTUWyELmbPdY0ks8ZDkSuvncF1ISEk9r2
 WfS2VJTcMUI1M5Fo5zOTaPR8o+R5G7Al4oigtrnZOzkBxaEsbKIqffy3ZGyJAyojfXq59AweYwV
 q2caCwyH6lGeGZB3yBhpwApSU0wd3OWGTwuy6NpI1rqm6ZATi1RLdVjmyf73qXoyXgsMz3DEPqD
 3zfTjUkeCTW2m9DXCxg==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc72 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=ONJcZ18tqKTzyd6mlaMA:9 a=biEYGPWJfzWAr4FL6Ov7:22
X-Proofpoint-ORIG-GUID: jHSg-BRctXd51nzPCdSmCMzgZwzJle3i
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1MlIFGnn1BHO
 6az970GCCbVS3T8EdjvXE5BOsiRI6NZ8EsvrimdWVQh5kkJnf57joeZIkDB2NPqG14e0NpWgiDo
 Hfbzos4Tc31LxQw5TVXj7tOr9GqXxmuYQtOcOA8AfXpKddObOiWZ
X-Proofpoint-GUID: jHSg-BRctXd51nzPCdSmCMzgZwzJle3i

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

Thanks,
Siddh

Darrick J. Wong (7):
  xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
  xfs: improve the code that checks recovered bmap intent items
  xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
  xfs: improve the code that checks recovered rmap intent items
  xfs: hoist recovered refcount intent checks out of
    xfs_cui_item_recover
  xfs: improve the code that checks recovered refcount intent items
  xfs: fix intermittent hang during quotacheck

Dave Chinner (11):
  xfs: don't nest icloglock inside ic_callback_lock
  xfs: convert XLOG_FORCED_SHUTDOWN() to xlog_is_shutdown()
  xfs: log items should have a xlog pointer, not a mount
  xfs: aborting inodes on shutdown may need buffer lock
  xfs: remove xfs_buf_t typedef
  xfs: buffer pins need to hold a buffer reference
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

Guo Xuenan (1):
  xfs: fix super block buf log item UAF during force shutdown

 fs/xfs/libxfs/xfs_alloc.c    |  61 ++++--
 fs/xfs/libxfs/xfs_bmap.c     |   6 +-
 fs/xfs/libxfs/xfs_btree.c    |  10 +-
 fs/xfs/libxfs/xfs_ialloc.c   |  38 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c |  22 +-
 fs/xfs/xfs_bmap_item.c       |  76 ++++---
 fs/xfs/xfs_buf.c             |  24 +--
 fs/xfs/xfs_buf.h             |  14 +-
 fs/xfs/xfs_buf_item.c        | 384 ++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h        |   3 +-
 fs/xfs/xfs_dquot_item.c      |   5 +-
 fs/xfs/xfs_extfree_item.c    |   2 +-
 fs/xfs/xfs_fsops.c           |   2 +-
 fs/xfs/xfs_icache.c          |  10 +-
 fs/xfs/xfs_inode.c           |   9 +-
 fs/xfs/xfs_inode_item.c      | 164 ++++++++++++---
 fs/xfs/xfs_inode_item.h      |   1 +
 fs/xfs/xfs_log.c             |  50 ++---
 fs/xfs/xfs_log_cil.c         |  12 +-
 fs/xfs/xfs_log_priv.h        |   7 +-
 fs/xfs/xfs_log_recover.c     |  17 +-
 fs/xfs/xfs_qm.c              |   7 +
 fs/xfs/xfs_refcount_item.c   |  60 ++++--
 fs/xfs/xfs_rmap_item.c       |  75 ++++---
 fs/xfs/xfs_rtalloc.c         |  20 +-
 fs/xfs/xfs_rtalloc.h         |   4 +-
 fs/xfs/xfs_symlink.c         |   4 +-
 fs/xfs/xfs_trace.h           |   4 +-
 fs/xfs/xfs_trans.c           |   6 +-
 fs/xfs/xfs_trans.h           |   3 +-
 fs/xfs/xfs_trans_buf.c       |  16 +-
 31 files changed, 723 insertions(+), 393 deletions(-)

-- 
2.53.0

