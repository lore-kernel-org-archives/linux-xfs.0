Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8474A0C;
	Wed, 16 Oct 2024 00:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037522; cv=fail; b=rV3amQnkc9mtEuisndvIDNIHOQvfEW8MlmNrVJrL6O43+pYV8LAwSwJQuEcbvHmKYSXxhmpRRUFLGKBi0Aw73qgv2Ts7O2MzwOtkNDzZBzlo7Gp80NgTaY1GmPOJ1jM7TPlyIy50bG7z010eHBxEvZW/UtuS+ByYA4mMu7VLd2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037522; c=relaxed/simple;
	bh=hsSZ8suBUmIFNtNACOSDElXaGVs76z4OghNjy8nD210=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o2m1B2dccSeeQmEHn2r+W91uN+gUvD+dsDIur0Xf2xZfQHC5agB1sG/+wRGFxyvYqjkui2pEun8Rmxd4kuiqhKspJVwoOVEwRgKWrkdQ8sRr9ar2JjVNoQ3NurUfJ/6BabkqfGt1OMZ59zm1HpV2iDIrNXliZ4T/XjgKGIPSrks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JCZNTbI6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wRj+bdGn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JCZNTbI6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wRj+bdGn"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtiip001646;
	Wed, 16 Oct 2024 00:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JgXlRMXzxzjeEYPySLEQ/BSfhz6kuCWSOss0RSqAVRw=; b=
	JCZNTbI6/06VTuVGntgVrZi54lUQkAq/2K1hn7kP1a9yt8nSu3nlYNWpkkTAGDP7
	U5v+YaeJAGcmKf7wfjMVXzuWmmtghFPcuSUfnnggC52+7W85soqVq59RcBtp9JK7
	llxo377j1VneiF3NwdsuSaPLT0Dp09B8TzffT7N5rbrC5lj2dnBPDgU68/EZuXzV
	dac2ObhrP4S3OFyd2/4FA7UZ4hnlIWXFTbzSVqjs16KdG4rTZP6pU6FmgMCgkuvI
	TUcYzaDAmx5Lm5BNb6neC73kXoa0Nbb/lxs12viN1FONlJ8xfWrtXcUyF1EdoFMH
	vSYySxBQDuGb5KLOCjjsrg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427g1ajb18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:12:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G04RAa014014;
	Wed, 16 Oct 2024 00:11:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj84v4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldPAMlZpqK1H5vXUUaP9fLyR57r5b4iEyxW3hmBA/HZNrxclNxl9OmjphxWVUpxOa0mSlP6zlPB9Bddm67v5snKYqvQ7B0iOYoPVDQJln3NOKKKy93S5SFVUSbpnZEQOiYln9QC0jQ7S5Mjhn0TrVPx3a7FIzRIQ5dk8S47uCE3Ye9h5YgFYgiLpryu+AmdoH1TXSEx7lU9bUe7LSmrDr7oWSvB4AAIAde8+7DYD5hFZLR8qft3a1vIpJmbGxwaY0Fp3eMErl86encxSn5Zg9AxIYGBage5fFthTsuQa+wg2sZW0fs5mgWT1xVGZbINuBH0g9KMpOc6A/9TDFzkHRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JgXlRMXzxzjeEYPySLEQ/BSfhz6kuCWSOss0RSqAVRw=;
 b=AOAg/edt8fZ5sl1S/WwZaJEiSIJe4fNsT1rrkxdwD8khS7w+tbq9RsTYEsMiMdYLIKoyaWB5ZQEXGHnIQ30QiHReAX9mRJxPZ1v1XMUek2BI+Z4ZilacMZoWaLqK0IASkmt99zc7YzNruk0R4fUUT32h98wf8XLthWltLQ7Y9oIIzrE6DaBQ6ITCT1Ttw4TfZVL/Y6AqeOtrfz00ibxMAptAZb136BWy8WhhfvY0lvZF++haLLfb07gW1alxKjwvioWiQZIR2zD3Sh99HT9NsbGdGJQkrXykdXmjGQ1eNdZIEuEwSwaSfIVDTiRIGZSHzRBRb8aQwE6v5cSYlqLRmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgXlRMXzxzjeEYPySLEQ/BSfhz6kuCWSOss0RSqAVRw=;
 b=wRj+bdGn0Jpf05A3TyGGhu1Hxsi8oz8RY78lXj6gnO5/l2bbRJYciVfeeB/heTeyDLIyhEc2cmBSzXohFATWEdfCD5479QRCaaiR5NYBX1PFAI6ih/pphv9mCAlO3kiXvpV1uIPRVlIsQFeCEOpfB5+I3NvaIuZiwARAGsiHDyc=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:56 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 14/21] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
Date: Tue, 15 Oct 2024 17:11:19 -0700
Message-Id: <20241016001126.3256-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: d67bd84c-8590-4ae6-4cfd-08dced772578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Fk6SdFkOCTbXsxBVzT+SJXSss0GBBfPWC3/KLsXKvoFms0snDyVUdusKIugo?=
 =?us-ascii?Q?pp1rMDpgMGZ7ZiR+DJNMplLPK78vTfn9zzk5WZ/hS+QcpCK2wO+bV70mwig+?=
 =?us-ascii?Q?2IMSWfhgF+X+8r+KfZUuLuKWYagLcqcvcxdX6j22Bq5JPa71rQ5hv3b0d24b?=
 =?us-ascii?Q?yCYFHuiWl0nnI6SFbUlCpkcrIidcYzkYvXPtuUTXptPQTNxn96tddFMn+46H?=
 =?us-ascii?Q?7OXNNK0nIj7m7Oy+s0VkRIVDOdZBfW14SKv2J/N67I1Zet5f8CKFSMLF1Zf0?=
 =?us-ascii?Q?wQMbYVI65thw6QK3dzN3SlkeYgoJqyqINQ4/QjrNuLaVZxfxZ3qOPPyDTgqc?=
 =?us-ascii?Q?pwezZKfcDurIcAWA2Y1sPQA1J0yK9siHIjvZCHUYuQLF2ln94vENfnasiJDB?=
 =?us-ascii?Q?t7/YIXZwyRjJhRnFUI6PfZ67dI/usPBepVbi8kE2qq7Y462ezxGwgowoG/6f?=
 =?us-ascii?Q?qVkwH7+BpbwTz9Q+qTBMv0eqpm50iIHPifBmVhm4kt0oGbMr4JhS4bYzUgFi?=
 =?us-ascii?Q?wV/PI93/NBt3PvXzla0KtYa9o/xMrOP2Dl47iUd2boW8SXIGLZLkPR4apqcT?=
 =?us-ascii?Q?FN4GPvHB4h6tom7gt5kToPkQLNHVC0yBWFgIT//qMOaYqUtXADAzDTbUd9sq?=
 =?us-ascii?Q?K/2Z2elqemjqo0RODa1/WeQHIwsad//Y/iVeoeMxvmnpNRn4lch67TfjJbiU?=
 =?us-ascii?Q?Ufj5RfehtiCUBXjYvBham7/XZf8ddy2aVgdusEihwuA9kU28pFwrXkFcOcJs?=
 =?us-ascii?Q?slz+ogHs6danvQn9h61pXsADBcnTTomZ7I4FH6sj/YWfDW3M7tVfmh656zAP?=
 =?us-ascii?Q?XyV6wYI8L3frbHMMLAsl+ghHmw6hZi6aSqjvA51g72G+ivygmu2taMoFT3Ki?=
 =?us-ascii?Q?YNMYy0qFrD8mMzLtC2bHN8MvXNuNUkWrNghJP22oQMVGWyp86rp+3SiFLDOF?=
 =?us-ascii?Q?K+XVhWh/lAL+6aVxnBXdVmJgXOOt1xWzgDMFh8UwllSbvTxmSx0DCIMwq4Pz?=
 =?us-ascii?Q?LLWqNHMdP37LUy8LGww8qJgAnpOeg4CUkyAGeGHby6CZgkkNLXt0Xiv60nGC?=
 =?us-ascii?Q?wj4UKeFz9KhV18glReT3+a/LYRj5qgBAeGa4jRDlRBx7bmGNh8DM8QGesueB?=
 =?us-ascii?Q?2saXeSHWGrmTSFVXXyW9VvyGA5EYF+7iToxQ/xyjwLeUqWGYv7qVxrs42oML?=
 =?us-ascii?Q?QzWxi8XyF8yiBMZ78o6z8voytgwYVwNP6rSg2xxu6ykxJOB+auAWR/Yf5xOx?=
 =?us-ascii?Q?6clGxm7czlbOQNKE4B8/AtQN+F/Im2cbPZ7GQ76qlQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CISjZJ6RUeB4pBqF2KQ9iry2RM4K8Tfqf/8K/E1FI1E2NLeFnKNRCzYLlLqO?=
 =?us-ascii?Q?jxknz2xY7KjPF8eboLaQnO6m7cypM4xjVqo68wWDsY9j9iQELrVDZaJR2lDC?=
 =?us-ascii?Q?xxOGsiTyztDQ/b1qOhVex9VkkIzwX3x+CRW9cniENS+Ew0vNVegvAuvZaDLB?=
 =?us-ascii?Q?Wno1tfkL5iRyUnc6JCIUAW0E72VeAZaphXCzBIHdD4kCG7+vRhI728ltfMaz?=
 =?us-ascii?Q?vBy3gOAhAa+FarXiacd77wKMwp/NLSX8F0ngS2wcUzoy15+VQ2BH39caUiEB?=
 =?us-ascii?Q?bTfTd6rYJwOpVw5DRZ1AT3qIJrONqyjkHl0IxOuL7N3095gSBoIdUss/GPat?=
 =?us-ascii?Q?4NkWMSoqRUrAToWnCu+uuGCtdzAv5+nJLVXQx6CzxS9cJ6lpfFi32l3dizNP?=
 =?us-ascii?Q?VWsP1zZnsMyZREPnG1mHcG8yFOCXIUbQlrXMbiKhIo/a2uhAajUi4vysl9k3?=
 =?us-ascii?Q?Mne5viVF22nATS94RROIuAQIM8lipn/Z6tKCdGMQY0eQb3U/zw1DvmfWhv6a?=
 =?us-ascii?Q?ESNta8/sX7O+wg3pbn1TIGfIFBH9j+jhU/o0ustBvZXSFxokeaQ5UjnxGx1N?=
 =?us-ascii?Q?F9AdXsYqo1NCv+qEz1/AoIEBu/dJeQnsOmolyDf42SNxOSagfJ/FZDmDT3Kb?=
 =?us-ascii?Q?WOy5v4m4MriwPiHnOzoUBsUXVW00VRuxVW/RavW1eejh5whiWq+JC0jTmpVa?=
 =?us-ascii?Q?80DFTyqSIQrE+YTWduawoUuY/NQIrgXgZjDm1B/pIKB/FAFRRvRlDX/PDqxI?=
 =?us-ascii?Q?DTLjB8Tj7CcBOOpr/66Ei5bOkD593Wu3OcdlkaiqRNfUm8zjSkcS2oWg0R1A?=
 =?us-ascii?Q?vEYlcOBsjMayf1udIEVg4JEW/BLXNBUoxZOKI34nNndPWBnx4UvYjX70jOlL?=
 =?us-ascii?Q?PE4LzVvDh6XLXAZj9YyBNcZSJDZrYPp0/98mNcaPTwrjUI8wjpmHng7NEZ7U?=
 =?us-ascii?Q?m3J0CMeQakRYIKDmuLoGl8tN/wdlWN9gn/sT2Q0guZeKlrhDb5mVYjUmF/x1?=
 =?us-ascii?Q?jrBfrtoxq02NYRsqCI1mRA6tNcbMK+DiDl9Um0pmUj8Akiy1khksc2F+hg5/?=
 =?us-ascii?Q?cwoAapT+J+SLbTXriDhOCGORVrdZ01jDwCLimj67HOTYS8uGFIiQVqkED7LF?=
 =?us-ascii?Q?waZew0PXFEETxmYDMaCfflIrhIddOom6igBvO+NesuADSkzXe0H8NR3AIccj?=
 =?us-ascii?Q?pT+9iliRy0bikr4VG5v67ORf1c5vHrmLA7M75dL0WV4SVoD0VXoQjmtLwxc0?=
 =?us-ascii?Q?mjlwvpCmXe56CNfjBDEDT6Ymw4Vi45elHrWLrCZgAzwMmqe4J2LxzaJ/2M7i?=
 =?us-ascii?Q?JOSPhBUPYRy00+YjupnQ63UqiHxyU+rzHkDo0EFu3EYsA3q+3RDftsLVRbZ+?=
 =?us-ascii?Q?zZB8aIRDnRD0UGC3CFnhUv2T9RVObRbe4ejfjtM5Nh5+lE8e8f5Cmo2/qcCV?=
 =?us-ascii?Q?fgTi2EyDkTWKGxg+brJnXSge7o/mEb17DJ6Hkzfuc0buiW9xXS5jR0MxN/6u?=
 =?us-ascii?Q?5m3r1fskWR45BxwKJASO8l8xs+sfiavvnWBm9NH1JvlBBfLJ0l3g4+lTxLzs?=
 =?us-ascii?Q?+x+fut2bi9DoOLbKOAQh//3HF+reZ3VE6StVuBUSr6A1XLJNRpiMpNnjxYBG?=
 =?us-ascii?Q?XH+raBD5lWLcq5njeLXHbQHqH2YEiKVAZZvX0Yku+w41wMSKgr65D3cyaV7t?=
 =?us-ascii?Q?8arwaA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YAIxxkkh95Fulgs1jGJ+sOI5+xdECDrgQtXryf/FsTGH88Z8higuA0Uu8BCXCzDTNi0pjdTBQwJq0swhlJiw8shoquAlZWQrpVMnzT05yANegQ/oyQNyNq/iJjdvFEJeZk3pVCYKFuW5nPqbGqU/RGmV7EQaGaX6/P8AfR+77UZiG0lsB27rtTsk7twngpkGFWzBwctiwtyDcTCXU4l+PAhuoDHqO/4E73hOgLukKcrhx+trsLo8ucMkii3VPGNFJlKcnQUCF9MdRSlMoSOWAihrSD6PpOPekCYSybS2o0pOlVp368ZkAVCT9Ne1ZZ6PrgOFzo3Nxc7jhxyDQ1duNMaVGV4ER3HtC6Alj6JC/ICyJCaj1LfiVPDiMjkQ372J6Mm5Q5n+mX48BiqvdFdNhNj/qMAOsXuVwpnj2aoSJ8Sqi4Zh4a+AJMoomKpzEfKzVm4lgBqRdil4DZvX+FTKFhrIByVN18Mgu3TUfUyPOpJirjx8L2GDfeLxlhS0+FIvFIUzxwwJuoV5uPteikJBJoM+zDR7BkLwJBMtqBj1ocAOuII4qhwGUCHh5dtMe1/9JJ3EtkR9C8y87Vdft7Oh87cb/XQiaMHG43VSXe1qjik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67bd84c-8590-4ae6-4cfd-08dced772578
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:56.7072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qabp2UdKIURJVcVJ3ApJYmGHlBRdu8PCT14JvLu3z4TRhhYlCei2jwir9xcojkRl6fnkC/osVJCH0aZ4KThtJ9oaCRS/7x1dPshv/yAwLYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: zm5-N4zoivh7yRbrMV1vVwESfjOQsreU
X-Proofpoint-ORIG-GUID: zm5-N4zoivh7yRbrMV1vVwESfjOQsreU

From: Zhang Yi <yi.zhang@huawei.com>

commit 2e08371a83f1c06fd85eea8cd37c87a224cc4cc4 upstream.

Since xfs_bmapi_convert_delalloc() only attempts to allocate the entire
delalloc extent and require multiple invocations to allocate the target
offset. So xfs_convert_blocks() add a loop to do this job and we call it
in the write back path, but xfs_convert_blocks() isn't a common helper.
Let's do it in xfs_bmapi_convert_delalloc() and drop
xfs_convert_blocks(), preparing for the post EOF delalloc blocks
converting in the buffered write begin path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 34 +++++++++++++++++++++++--
 fs/xfs/xfs_aops.c        | 54 +++++++++++-----------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6ef2c2681248..05e36a745920 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4537,8 +4537,8 @@ xfs_bmapi_write(
  * invocations to allocate the target offset if a large enough physical extent
  * is not available.
  */
-int
-xfs_bmapi_convert_delalloc(
+static int
+xfs_bmapi_convert_one_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4666,6 +4666,36 @@ xfs_bmapi_convert_delalloc(
 	return error;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in iomap.
+ */
+int
+xfs_bmapi_convert_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	loff_t			offset,
+	struct iomap		*iomap,
+	unsigned int		*seq)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs offset
+	 * and put the result into iomap.  Allocate in a loop because it may
+	 * take several attempts to allocate real blocks for a contiguous
+	 * delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
+					iomap, seq);
+		if (error)
+			return error;
+	} while (iomap->offset + iomap->length <= offset);
+
+	return 0;
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e74097e58097..688ac031d3a1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -233,45 +233,6 @@ xfs_imap_valid(
 	return true;
 }
 
-/*
- * Pass in a dellalloc extent and convert it to real extents, return the real
- * extent that maps offset_fsb in wpc->iomap.
- *
- * The current page is held locked so nothing could have removed the block
- * backing offset_fsb, although it could have moved from the COW to the data
- * fork by another thread.
- */
-static int
-xfs_convert_blocks(
-	struct iomap_writepage_ctx *wpc,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	loff_t			offset)
-{
-	int			error;
-	unsigned		*seq;
-
-	if (whichfork == XFS_COW_FORK)
-		seq = &XFS_WPC(wpc)->cow_seq;
-	else
-		seq = &XFS_WPC(wpc)->data_seq;
-
-	/*
-	 * Attempt to allocate whatever delalloc extent currently backs offset
-	 * and put the result into wpc->iomap.  Allocate in a loop because it
-	 * may take several attempts to allocate real blocks for a contiguous
-	 * delalloc extent if free space is sufficiently fragmented.
-	 */
-	do {
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
-		if (error)
-			return error;
-	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
-
-	return 0;
-}
-
 static int
 xfs_map_blocks(
 	struct iomap_writepage_ctx *wpc,
@@ -289,6 +250,7 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
 	int			error = 0;
+	unsigned int		*seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -386,7 +348,19 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
+	/*
+	 * Convert a dellalloc extent to a real one. The current page is held
+	 * locked so nothing could have removed the block backing offset_fsb,
+	 * although it could have moved from the COW to the data fork by another
+	 * thread.
+	 */
+	if (whichfork == XFS_COW_FORK)
+		seq = &XFS_WPC(wpc)->cow_seq;
+	else
+		seq = &XFS_WPC(wpc)->data_seq;
+
+	error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, seq);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have
-- 
2.39.3

