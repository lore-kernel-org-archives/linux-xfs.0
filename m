Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587854E0B8F;
	Tue, 13 Oct 2026 09:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884502; cv=fail; b=etPCLo4TPgOk+lxW1CfXuTBUALJhINEvtXGkMUPEbOTG7tIcDquX9VArAtWB8fPqod3Rh6F/56pzhpeaO4FLMYlgudlP5DtEwlioxqERlM+zJpLZh2tFZ1TxlLWiITZq9THDPhrP30e4Aas39A2XAVHDZo0Y74yKy2e5M6xlmIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884502; c=relaxed/simple;
	bh=Xlxtkk2/MTS2I5RuXadDN7Suf+Wac7BVTOGmVhOTFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DrLMT1VpmlUASaDt26En4MgQLXxoHqmmdyNxZskEt3224+Lu/ORG2ctONxGgZdc1pEJdOCpccL7kO47vnZLTlNtVjgQYp80Fj8io6Hdw9puwgrzCLEDrjZXUiUCqQTVBictF5uVAx87diU0WlPJLKV8m2icQYQXfLC1CrMVyt20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mciTuLj6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cjZy+VEk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mciTuLj6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cjZy+VEk"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BvVB3110102;
	Tue, 13 Oct 2026 09:41:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=; b=
	mciTuLj66RofJeA86xlxTP7Q67KBQcpcphKfVVjDTW+pGgp3HVzZkOi923U1pVTv
	cORFAFMEsHSIKd6U3PRKn1NJRClnQR99zHaJENKz1zLT3v82Q3C0fo/ItY2LZwHY
	z3caSNGEzE6u1TiHrgenljjVwccX+5BcHZA4Daa6d1/rC2I82nN7NQBf+tCUiXNS
	DWmftADfTes+f6pAqgVOn5HwPWzoN6OOJBdrZMeoer3n6hNVPhxvkydjIxm7TMvA
	hCzYwFCtdgEU5ZnXmLd0gbT0umhrOUbCCio0h6lw6vCoy9DYwcJnmrtsy86hrKIk
	MLpT6s83lI3BKe1hjNkLOA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkrg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9agGC016159;
	Tue, 13 Oct 2026 09:41:35 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012001.outbound.protection.outlook.com [52.101.53.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp199k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4bBw5CYQhQES4jsPvDJ7ElZAW1D1vZGx0g85bpbzLO8Ul+g9vsNNOCCMOY9GeTtabt6s9t4tixxnxJ/4zqM7dfsi3XVseCzcbi2KaOCnfoAbPK63fZg38K9SdShfXcncPomORGR9qcLUJ0NKSW/EFKPDeAbCw5lTUVLkCMiUxtp/zZQQ8EuMs48FNiXo4HBGx/ft6C4HTYDZAy7ANVByNktanAhdhsoFur+bW0mWd8LgCOw07MWGNqQ/B8WlwpOn3V+cBqx9J9B0ZjkDAqB0mIYza/YcNxJepzvJqp9miliS70liu6ldFDHfh0jdjKGuhWaR8SIC8U8IIMz+eq+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=;
 b=DnUMz73NSIAO6gNDqsTEXmIIsjiHeZUyPUiIKbRPLs39wtJ3dg9XE0Enw9whpR/S6qRB7cJWCCxXUfm4kKwL9Le5JoY7H2LcJBP9f/EplKNoGE1BSKztv4PK4/KEeNRdJfR9nTEF7GD9u7wcqQD6eD+xb9hBZPBgvnFUCoflJ49iOgUL3or9tFTEgtpTBuUchSahrtLjfRA6Hv8yP269yba4WT0xyDjjE3XoccgDZ573uHcYFWAp/XNuqcMb7lS3yM/D6zuX55lCcBJElIeDebugQu/cyrNP+JT+ZEOmIvSW/7G151kmKTPOAjIGaOKwsVwtidvXic6wzTSIV4rwSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THGeNLNJt6e+K8znTA8jMpG96yCFsxwKs1th2+sMsK0=;
 b=cjZy+VEk/dod1SBtiOQjnPsOf49Gv2laiK4LBLtI+xCsmqt4hKrM7NDeWq8w8MqmSMw7OAOhAFoTtXnGk2s6ds724cdnrA5Hj5h+4CcpyVO3M6G3hzEsVbFoPU5mV4OOYAS8fFfhTTanr09G+T/l1YPXh3MVCC+j9S98mNZdmNc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:33 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:32 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 19/19] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 15:09:48 +0530
Message-ID: <a7c8a0d8d5828d0cf57b8d46f92908c7bc778df8.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0097.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:278::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: c72bb10c-a91f-4115-7447-08df290e2a4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	vhjc+xSZWU9GphRPCIjouo/fCVR61JoTePAPbWlxg+T7C/iRvdKaJNC1j1JCla+M0M817pZ0pG9RVNahdtMfjOHG34snvwLo6Xg99B+kl1F0mcUWLyYdXet2PZpqQhLlLgl+huh70iZ3vzJi3XgUYb+5x2nucAXg2DUFlVRbYy08K4u9JRU4DjeQAKUmy3Sv/wkH0/l2fAQWDsEuk54NjPO2ZpxuiSHnMg1XDMykCNHuCiqArjxeVb5iaglW3uYrrkLueXKA2K2beloAyOB/Fy/qtHkBW4vJkAbwEBHbqNKGNcVZwYP+JzZU1gYmVZw7dqhwNC5mUF5oM51AHBCeeTmne7XJb5V9ciuEOs/AZgOtjIMsR0IZssySik0JZGl6jZ5R2rsGkhwKwMtlbZai3j/2dskIE+LTXUuFEdNRz6zfT4IxTZRZOwvTODHZNUy4rB2FoM/KvPF10I7SzNL13EUX5PluOSyF6mtBzzdEHjdyQaLDJYHH00xCFYCWvZrUqOFk5JXLUyD91Brm05EPpEr4WaXc6egyc2ijhZzJ+UhlhG2eKCAtwAmXK8mXcR4oYQSMiAFgZ8uvJD8KiyoxivZeCQ2NRFPjXfM5tfvKxFw4mdRJ4G0WDVD0imE1gbPXztsvJwGyogHr0IHSd2jMIFGwfl7nrJXG1jBZuneuHuA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3+VFlw9AAo7WForCsYWr65VSRRI+gz6S7Z0HNVBp4AgpBGs/ukYhbR9YBsKK?=
 =?us-ascii?Q?mOd8Xour9DwVfkBr/ztHQLjnRmw1u9Bj+bX4msF4ke73asvtmFqHQeiEJ52y?=
 =?us-ascii?Q?T8mJ98/9YdUQaNwvTYT439H/ddMqEY2BuhBuSofVirnVRQItK/Owrri8jSux?=
 =?us-ascii?Q?IZN/pH4pYWP67nHx1YtSuCglIZ6dto93uBssQfsEbJcRrTgA4EHks8agesRI?=
 =?us-ascii?Q?luzOdwGebXadQ3GGuxa8WTwioopUhDIZjf3Sj+ZosKYkseLKBe9JLdSaXX6o?=
 =?us-ascii?Q?WchoH7F0y4AWjSVcS1FvFVGNZXE9XNNBtNQb/NmvxDguRnteyV4PkGybj7V1?=
 =?us-ascii?Q?E3/orjrNC+vMVN1UzXWkXFvNFQORwczADEShYwIPObDwfRDdviA0l/+ReICG?=
 =?us-ascii?Q?ln/GANgr57ng4KEWwSzPfeU7gwxicA0MGOfUL5PI+acqSIIkEcwHtWhQClo/?=
 =?us-ascii?Q?MsNh1eC5UqGObSEtUQ+rLls6GmQqHledEuPbD/MpfaMoJYu4w/+Xh2lF/wIK?=
 =?us-ascii?Q?rvZraDSbkHqrrxgt4xwtZGp/miBivBvB6awfrMhH/kRsyTwPy9Cwvu/z2p9g?=
 =?us-ascii?Q?iNoay52/GWZCc8AWC40Stv8Qcv9Zwrqk2hlbkxROAJZ+yjmLoR4ElMFzGTtR?=
 =?us-ascii?Q?5MGVKhqj/butFOkLPAEJbU2MIEr5AjL3roC3A4zLd/n+OBlvW/JCz4hTLy/W?=
 =?us-ascii?Q?SivTGVV/TQUpTc6kUOM6Q0Fpr91FrUIqjUA29TZWoN79yEednRtzhLCiuCF6?=
 =?us-ascii?Q?SWbVBumTTHpq5kunoxCKkKBb6SRrZpGw8Mq1fYoe1APIHu+4lC6v4Q+M6zFm?=
 =?us-ascii?Q?cuwcAMNYdHIJ5lPIh5pMpKLID31zJr0kM6XEE2NOInJwrwUKqF8sTwqUV4hg?=
 =?us-ascii?Q?B7gTceyM8NYjlpxdLtMuP8ChisMNFKwMuyQ8nyQysEp9JibexhI6uIbaAl95?=
 =?us-ascii?Q?72TJvvRYPJ46BhBxKsYvLh0VZBNvCp95q+zsc5hJacghLusD6edbAUKgaBL5?=
 =?us-ascii?Q?Y6pSZ2Qbjq8sUB+jn0Aj4iaxl2hHpa4E1GEWsv5IcE5pR/79z2jojqL/uzjU?=
 =?us-ascii?Q?uPMlKpHfqhVDx7ZUnpzqKqgUsBZotz6OoFEiNiwdEXG8fkLyFtQznLpoPQoy?=
 =?us-ascii?Q?g84mv1+PULlk+UtLXvIUOm2oVLejx9J3qbLpoq2YQ2wgduyhALb5nDDkmx2+?=
 =?us-ascii?Q?JKZoHTdbutkMBoHp/7FSzEq7PmSBpgYvULEd0xgmln4f03bcIGBNwxj4bYDU?=
 =?us-ascii?Q?ot1pFvAPF+QgWtAKqxeoTzruSxI3LnlEV+vXXMQlYeHx3MHEdsP85OJxjRqp?=
 =?us-ascii?Q?k2Rf3GW7k2US7FzRkG3rf2qjQy/2hlv2QN/c0hoRP27UXq8Ko90F3Jk9nZ3+?=
 =?us-ascii?Q?Qv+GCm6SZNMaQk8mAtLa7kEiVtOd6U5LEjpxYvBFnPPmckymF9va0WWaTCOw?=
 =?us-ascii?Q?PYDtjueNO+MJqnPvKGoxfhJtOkdSLbaX5PPf7fTcJdPQ8uCrH1yyWdcNgW77?=
 =?us-ascii?Q?ZNowXqqYokPbUMgSua+SbMG0j4Pvm7Bp9z/KjRxcnaYFRNSQqkOXg8dOLgZr?=
 =?us-ascii?Q?ZDL7adpcj7RYMAPdnVRbNXnL96CAB37talEvNvN6MmzCNnC20llwowu+Muaa?=
 =?us-ascii?Q?dwQ1phqrrR9joEl6cLWbZQMGP8BPkbM0FDzMcoDdUI30HtiUdi6I5wi386Nu?=
 =?us-ascii?Q?46EzQrXL5BcV0STMeir3bM2dGr63dWLRZfqmmfsmjwx2b/0slCFa5WmTNqet?=
 =?us-ascii?Q?Ez+gb4x68JjuD4js0yuHCbgq9/SwkeeS3PX+d4uOQXqGcClfyqxkaZ/vBw3E?=
X-MS-Exchange-AntiSpam-MessageData-1: QPcqDQ9tmpK4uPJ3g7qbDKtce03UMwUoHuo=
X-Exchange-RoutingPolicyChecked:
	djT/5PbrGPETYN85TUtv62cz0ZAsvAANGRMLolz+mfdqXrG9ydY5bBf5A4Wr3ICYrVC6m2yzoM3nDV+qHhOb6UcfqMpnsUaYMt593fmCKqp0yuV8cbLJtQmLKicxr1i3NetxuXfYbduzT35OEnFxI9BN3nSAXRSTlZ6MrIKpycdslwuTnhLSPNhmoccgv7yo5ZQyoQL4fpi7Vn5yL5DAAMyukGNXF22r75xnUflOuPB/5vO151O2SfD1uxyVjiXud0547X3kK6YNDY/zklgxFPNo8btrZb/lmpBR/4v2MJCM+W6ZPYwE/cfQNjUc0Gj8YGLMtqVijDGgajMhbmqgpw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PaqIt2hriCukTyZXC+J19kHXYJzJJ6d9REKksl5qGdgx7Z32JHdGgLL+2gBI43YWNaZIn7aDpdJc9ieMsPFcUE6sL4tnjGwzZj0DFj6ZM2C0hItZYOECvS5f98FpIKIRhPNtUtXHBs/5Qf8HzG8fN0AqcA6FicgqFaU2nEKbRJr15U1Rj5couC5OCxXEYl9uK/5c3VaSyMQ8rLTqIoRCqliYc0Jck3XgmK17CeOiPkFo4AAof1FOrGPpAnRH8jCm4i7OGmDBLVdfh3LkpCa9NsKVXb8gyAj9yxvD/On1luZ8ixRkTeQ5KdPp7eGMRRtQTWG9h+j3yz4vsvfxw1SyaLdOvUK69KGdNgK6mIA88txVRWF9EMNSaXtIY6X7viyvjRe14/ruaQx4IjMFnLH521tD3LylCaaoisL8erzU8JVjPJGYyIp7ZbewyBshuVyFl7p7VbmpLqzA2Nboh+A/wYOnzrGBnrmpRzLExdRxx0C0AUjAsjU1DNy4fWGzhVNfIMoP/ejaRN5F9WZscqUdHEddXCAgDFtbViL0Z3PDyaPwfBcGC61ksi/nLweehpDUpoJqfWbWHZeeMjCOyQlNhSf6xtrTolK1ZZB/k75zyiw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72bb10c-a91f-4115-7447-08df290e2a4c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:32.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l7AugyV98R5giK+PpAvsL25CnVOtJhgiwP8JvZcbf/AcCROMSng2C2hti+YiNZ0BY/qoio14A6jCtb0NQnoTLful6vdsoXXYwz6Upjm4tj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acdfcd0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13537
X-Proofpoint-ORIG-GUID: 0yn6X_67IojRzN7yytisR74oh8DjCVeS
X-Proofpoint-GUID: 0yn6X_67IojRzN7yytisR74oh8DjCVeS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX5MRXXee7R/rE
 c1f3Vddwq/KDv8oe6Q4W491P/EcJ03llwudGYZblVUJdIFwytBtH1ih2ik0g9feB3JBEgF7Xxon
 5UjPPeflBcYsL39Krr3giW/21NMO3qeHuVnrqalyqAWBuDQY30Dx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX3iCtlQmvQogE
 YMtDCzdDv8f11vXjJhUz2mnh2fDvGV+Qs32/ZteozoxGMMxE1Y0NWwH8syRjk5C9MDsxSaAuee/
 O6f7LH4emI0PfauW+1Y1mgQvJ9Zt293l+lySs0BbfPPgg3SSc4ghSRxMQZmI/MvapEYPXZ35cwq
 46tWEpyyfhEvnCk5EDSeHkWp7djBeDGYS+5OuoCWrng487pJGhhSOi8JmdbndY3axEDnbiuPDi8
 yDNZYlO96xgb5K0uB9ZM9UvWGWeIeX7m3O4vCsFUV/1uy+bojo8OIX+cCHNOKLnD2pVMBJUHHJa
 uYD8imRFGg8hpp5Q3e0IWKC5cJSpv7PisIXt+BI6SqoZZW+QKP9LiwIVT0GZikaxUtCEkX8lEl0
 NpItr7i8DiGffWRDxufoFNX5FtnqKH8JJxDoqpQB4uTG/9MQjD4eFt5OyzrbfldOy/qpZAa8bTy
 TUxAdQvjXKizkFJwVqW+BU6VynLBVCkLI9IF7Aa0=

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3a96279f97a1..8250347e2a94 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -627,43 +627,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -684,6 +683,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -691,18 +699,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -718,16 +727,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e3ccbf3ca801..c39202c0135a 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -51,7 +51,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

