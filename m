Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2015D39FCAE;
	Tue, 13 Oct 2026 08:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879240; cv=fail; b=NzOUpl2aeBq0VCxwOw1Uebkf8N5aORlEMVTX9z0LQEulBFacSyR44U2g8MxdP+gDtWpYJ5s2pSSTjcHNGusYYJrhK5oa25Ikmay706kbSzgLOsjwsXkSaIdifDT0fC2U4HFZ4d4YkhOzFI7yUFol7UtPMBl7H815MudAEuyZvPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879240; c=relaxed/simple;
	bh=wIC5ah5b9G3A38/PIe7V+7NvkOdhNmjbXQE4d+4hioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SeKtuAwJGGqY3lugazRuVZRvZS/erQjZcsL6smUMpYOT1mldKivB2q5ocVlFqiZyiofsqxIeTjDNjd8YF7IvJ+VZ8F2yFXzZgssul5BKr8KZlOmksVf6wQTOpD+tYFxCV6kKSTSNUhyJ5SKVxouG+RgMQu8hF8Ae7erYJpsLH1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WeI0X9+C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pOk2TeBl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WeI0X9+C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pOk2TeBl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D5UW3033679;
	Tue, 13 Oct 2026 08:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=; b=
	WeI0X9+CBRFjQP6uKDmpzBaRoQerZLw7eVp5+veTsfl/dZ5ajRCoNVT77+M00x3f
	dSS4kQ4caVban8FGwTvEd2Ih0g5E+c6lAR0DRUYne86Or5TXCfM4PcI4HxPWkAO1
	FhU9DAzbrpWjmE+ZX/LrDhmXyFdzbLvkGSaEVfgyY3MoX7Byd5TcnpNg5OlotpjI
	Msr/jhhfhzR4tYrDDC9uTdL8+vfHpFv0dPV7ta4TeW8Y7FlZj2/hMu/ZpKeujADM
	CQbodgZ6nIFxVeEQWEYphz7wmz69jzFaLX0U0daThZD0MMdSh0+h7mHFgmM/2ivy
	vnxPc8xudFNKSSVicQZxDA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbjvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86OLt024863;
	Tue, 13 Oct 2026 08:13:48 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013022.outbound.protection.outlook.com [40.93.201.22])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9aqh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:48 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFA5zNZ0Xd3tA03iybaqnbG5wwPpqXPt2hN/s0p/GJI/CBnVx5kQ4OZqgdBBWIRvecRL7aeDS5+3eIHMj7TAu7GX7E2wed5paOBNZewuMcV6Z0K8VDYa/R+PWkvpmQQLJLFJumcqtDSiA+GtXO9XinedPiTqxuYVJrTlBNEBv+P6OEYtRij7gxo4vk3RQmrbby1JToWsjKaYdGQZ7ZsjUHe7lWoNKHSJEQagMoT+kdxYcTshhBaRdECQ0nxGPDV6kdcCPns83O3HrcheOtz1ZV+BtHPcNU4tMfLA3Xs9ihCTRymBrBr68csIG2Rxhdmppmtz4uU7ETAxnWLFEMDn2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=xKDF+gA/ZX+CCihRSFycV5X5TXgEQXnCbasrBIHhLiFq5fnvNtE1Rfbo5CLhKjhLjfXMqz1trWJSUEeDymSfzBh3Gk3FDHTsOkwA8XyQMgDKjFExmuw3k5cq2XzCb5nneRDp6cJVoI5jewoTMF1+0YCSMtvz6DeOnRVn7+vzYRv+tjozSeBTjK48jRzq7xrgm4GgBvbhD5gcK9QcIXzhrYZz+Whwg37JnhadLzZvwqbVUUINeFSnmlM7BIzz0CecXBo/tRgz04OJl4NZV372pZjcuO1aNzPfUYipgsmIKw6fPLLR89yNa0OqwyySxf9XOz24zVfT7fRGINSMTlgcYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y8A4gCaYOsh3G252q4i4lB7tnCr02/3SzDR5IzAc/o=;
 b=pOk2TeBlauRbqQdId+x4eCJDHdcJDa38frMfxQHVbYylL/6HiPu2W7JYq6a1MFFAUgp8oz0JxsR2FaZhgIp9KKm3P7NnGjE+02q5Pq3mQonqjCj6hImOQVB/iOaOn64qKHriHMk9k4eyf7vkHRInlCOo3rBAReOhSqx816hv3iA=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:44 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:44 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 4/5] xfs: factor out stale buffer item completion
Date: Tue, 13 Oct 2026 13:43:19 +0530
Message-ID: <7beaca9ae211764bbd6ff41bdc7705ab409bf384.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 841a06a1-83d5-4c8e-102c-08df2901e626
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5tr+n7b0TgQPv6SL8lSluyRgNk3yCyoAprGv6wDcC+OgIhCKfOJjUfat3+zp7fFPdSh8TjN9VwwekaDFPKOC9o5/gIkgyybtEmt2FiNUZ40nC8IrpdVFHV/iObWAGCMPBqewlR5TFWmZPg3EBXoLSqZRUAHt8mr588ZEqrI0wTNMLU1BJxaal0u45FDv/6qQbLL8DzdEWWoMUBduSazJ4furTSqFFmLm2OP9GCYMPOe3LGnbkK3KuwJDVOK9bwTklixOnPGnaVyOXL8q/E0sJFk95lMSTrJP1yuc7rXrzy70rAYIS75kMBsT1j15PBLcHiYb0fglMYGXz0rEAr/iAQfVBT9aLFa3B5ZERNc2XAooROZEgAgVOwXFblHMBYQipAfvM9UsiWWRmQ5c8InzO/fJSUk4L5YRxxb9TfdC0wTyrcoZQP5FZp6KtNSeB1JnogGyNlQhOPvFFIvmvRDokWr8qoyxNPVlXuLgp/u9IYys96r1u8BmAwJr59Tv/miNTgiVBCkn/I5lfNjVXDVGrqDH3eostEKjPBZkKN4JAgz8+qs55+p7ZMSLEzKTqccW6SWmw3WEkuhBxi3T3LUOjpcxzZ37dhIf24haZc+WCwLHQx3kp/3KaZVGn0F+YTLcxUZKC8L8zm6EfSiW3C+gz+/Tvs1JzcCaCdWxuCkmrII=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JFdJNSyX9IrG1uenJsXiJsoxBATx+RUJaelhtIkoVD0y0vYbGhb104mYeX1L?=
 =?us-ascii?Q?53gLX2OkflJpGMZtRBXCM1p36On1ax8PjYZhYoVhSQCca0HjH7cMPRwH4OFd?=
 =?us-ascii?Q?TqF3tNTkvQv3jjDblLGNfMANOMzV9H+eHnX6cr3vkm8fWksOY677O64xTieK?=
 =?us-ascii?Q?969NNMZGt2kTp7jK/46zydWimeqei9o+npZbI8QYCeXtFIRb1v4bb/s72oGD?=
 =?us-ascii?Q?oheTJFGgvISBErYYYUMAfAjUY7HZ1Syegmk/a9zYsjgYSi42mtIGbXiJMK4E?=
 =?us-ascii?Q?7PDY3G4VhvlAlI2IOL8iAX2pha4tPVcEVR6AGdGKaash6wCy3uF5hF5UzzE0?=
 =?us-ascii?Q?MM9Ig6LAZk0rRE5wCF9Po8B3uxdG7fsdluprCaFVHqiOEliaTnCD6+VFd0VB?=
 =?us-ascii?Q?mDy3iEhRWfjnG72hujjB+8TyPVUehJkvk4y7hD3bV4BR3o9A1S5QwQhapq8x?=
 =?us-ascii?Q?hxCkJb5b4oU6rW93jTz7/T3uZnYhYsufncqaHl/VbcR+sABaaHTvB/6Ih6Gt?=
 =?us-ascii?Q?t4hXYvtrQXRiNeVg7glDSbDBQg92kR0yysx/OoPv20mmJ5NPou3Ci4jBqByY?=
 =?us-ascii?Q?9Q96GfSMPf/Hw1AEgCXhhoDeM6ZejDfEv/4bq95IvIYVKPEHRj16vnB6O/y3?=
 =?us-ascii?Q?mNNdkrg6ETNfKq6R2BDbwboW5cI0fJsUucS+l8kaSMLnN/t3cHfPKfn+mhd0?=
 =?us-ascii?Q?IMBLDRreNR03jL67oTSOg5RCkwjG78qr8su+voA/ymJo4jfXHP2GBMnX9ns5?=
 =?us-ascii?Q?YeefNo57oAiaZfsQnTDfmUIq3kq4c06fYwgVM4TCMJF0TO1hWo/gGBMF6I33?=
 =?us-ascii?Q?jJxfoAsebskfMWVMyfGNpoFTnxXzQwF+gSIhOX4E6GF79DOn49sSqCvDnHyh?=
 =?us-ascii?Q?UmlZXmpRWHkiXYj6V8AZ10ClsIETmHj8GHsoCxC+wLA3SgfSqs2I5d79eOnE?=
 =?us-ascii?Q?TpN9lwYggB7ntNS3rI7uieodovIyJIIcxIt28k93VRgVuvBmHqGbu6hlyj+x?=
 =?us-ascii?Q?E2xGYUBpuYUSIgCtvt36CQzZZPGYtG47fYb2M4eC//rlTuasrN+sqmJux1OT?=
 =?us-ascii?Q?2szGlFRtUzdt34B2REilWbc+nRhQwOEg4TJ6CMVNge3HiynmkolPO4NN8PBt?=
 =?us-ascii?Q?TaeV3DQEEbRI/HevFUlcapKnoc8kP4CxIm96MLGy7xb6YeNBwVu3KMw+zfEG?=
 =?us-ascii?Q?SScQEyRNnHe1fNwIRBWa0MMiTFnGDRcWF4gM0jGpMWKW1fstuhW7L32V8UEJ?=
 =?us-ascii?Q?BpC0P1rxm5b0PjxAHClieDqaMdVe0V2f7uoST+FvrrlSwsF5MAcGJvtMHUOv?=
 =?us-ascii?Q?703Jr2kMapsY7TDZSbTTZ+vywY2lT5vuSRfp3AquPO3R3K1hBuM57Af0ZgXW?=
 =?us-ascii?Q?SmECCdNy+hzpLCWu3dpFLFTfYAjKg1m02MsvIYXhYI9Py1CAl5gmPFonZEq7?=
 =?us-ascii?Q?CLijYjPyNYfG0sZTMXWGdwBc8AOGeihBWZIqkrI05y2fRIvvhkL/FxWivd38?=
 =?us-ascii?Q?48pLSftVf7asAc/w4g3wy+EWMqlmLFxW5KV6cziMwOko0ut15eJi0RpmNcAZ?=
 =?us-ascii?Q?lbK5G4rjpjkwTRAQ8NV73oiSoQjc8yIQNmqzysLCq44rH3elJhuP6CeGWjEN?=
 =?us-ascii?Q?MIwzJWI1CTSnPFRecu5b/xG2RcabiV9C9Tgg57tweSTbMM5ku+bZ0za/xwQa?=
 =?us-ascii?Q?kzrvxDoBfUXutkCUJMx52nmH9PMfhDF2PvulupYZsq2kziin89lPpdQ+Aw2P?=
 =?us-ascii?Q?ODcBYkER1AeIvBIiIU0cN6zh4XG96jfP18KHx4BuRRi1Oa2H1CZrFUsU4A35?=
X-MS-Exchange-AntiSpam-MessageData-1: Sz+pJHpE5YiLXKpZ+AZz9cfwxVRRr8G/yQU=
X-Exchange-RoutingPolicyChecked:
	u2g74gdDLvdekgjuIiY1DTuUHhXoVxDDRu2UF1TxpBDTP8NtAEm2EJuJdhax3cCNHQCfaTuPy6ASCD+ku3zQTfuZAj0PGawdWbzeYvp2imFqSe5UqIOW3/kvFfhi/7v/QUtET4R4BjHQbJzyliOKssdY6hj57fiLWnZknh1Y/vGr/cc02HcVY6zfcFF07yXTDPVscPtKMDRjUG8lkzsuw+R1jlxMj2qmtLwQyXy5V8fW/kToF32a1LOLwMQ1od81Vry1R+i1JVm32gNnJ/4YOTRnt17rYvjzpJnnTid6fIDu6eYfzgJxKLoXk/BceNcSLq+pOIzOOwEJXmtd+IpYEg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1ebCjvRa9Sww6wV+VDyfMBa4D1V0M/j7kdciatsrCvv2CGNaCkY9b0gi1Q4SC34m3BL35TrC9sS0hxhVEvCP3fLtfB2uevDbRFdW+foAOKBRMfzjtjoV7d+oqxjQhCAoVFVawMmgT0nGYcwbokdw6crejL9byXQSHTxVxF58uVGBIsiD1ktbjIE/9bxUW04WFP/JsRO4pjx12rKIbau3HHOGJiRl1zVr1MJixusNaNXgv1upQF4xz5EXIxu6LTLYzBUkZ3imgFnhgJWLi7hkHLeRGNIEVUGKGTVb863xmT/QHbUAN1UMb9I86IHjHqB2e4w5IZX2de5ZTHThtxUl6+ZsCGdn24bUSfGBjSgmJi3MjJ3nk2Nh7kF1oR2wLwLdOyt88OBc99tSEgSG57bzvoQ66C2yLCwJ3Kb0N0/AfXXiyP3Lyk5nmk7zQAkKt1P96QxV6wv6fB1fkPGmG31+FjgJrKQTHCuI/iPU/5dcnuh2kF3wWiI2mT5J6JAElaKXckTbiS8JP+qcI9yiHXESvdDYoB+AIjQxFTBaa0iy++p5YA4Xwf9X8zI8vsS7D9fyDvnuFc8TGtrikolylx6Xzzvo/x48Uio+kGleXOhdO0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841a06a1-83d5-4c8e-102c-08df2901e626
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:44.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wown+duP/DUP4Lfk4SN+SInh2AAZ+F0E1If+UYjvMOscIjGCAJ8Cbxs4zHs+WurF2fqWL30eberDDE619y0LoSzUmYTjlERO0GlPGR33qcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXyVnNPUlxLn4E
 4iz1M3EsY+JgBzmM2LhTHnHE2l+xD81KgD+TWYB5qIiNRFzSYhg4ICCBeL12RPoCloRk7x8Ixrl
 lnT5/VEgFtFkRnCUJoPHLlO0hfQywneIm+7i/Kj2XLhfrAUbs5vzGBXstv4wQwpJSGX1xW62Eir
 wg1Kj7phuPZvci310DJ4kTR9QHXkmg/56PVQndA0qoi5Lu+dEox3QtvUh6gkRqsxg+FXtviixWC
 2rOZvIV/ox6IY6bTZ6TF9CF3qL0E5N1chLYYcT4UOVYr0zbWjiZUdGI7tpH7hjwyhnFYTjAFvPJ
 vjdB25je0OflPG+KJrgpfwDy8AF5EwY6Tbxy+lrzTZ/L2f6PU6jw2Ore6VIHAXj+tRDjdBkyQ/d
 //FRU43NSp8iaNoRXO4Jw/AwwmlzKWBFMtCf4I/aziFfgW7JqOAnwhkhNkWGTCvDCc5HZcOlUZQ
 0L1W+ATQriEt5/khjAw==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acde83c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=HRhzHcoIBzGTXiVGymcA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: 7TemPme92zEaHmYNnSQ0JKQN5Vd_WDJC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX0XUAP9oQC4Dv
 tcv3+eF7R9tJI/1PEGwBDG6Y3982btOElRUa+hBnbJrPex/MFANAdRBeR6tszUyqNyTejEHUc8U
 qCsUZ/qCq1nvX2d52S813v9muhZx1x4aHjJjyrd6bmcrGkKFWQOU
X-Proofpoint-GUID: 7TemPme92zEaHmYNnSQ0JKQN5Vd_WDJC

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb9..ade89a233e68 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0

