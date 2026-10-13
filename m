Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7E73ED3CE;
	Tue, 13 Oct 2026 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884283; cv=fail; b=uKlRkRtYtKNuq/uys7AJRmIG/eT0DFPMMcF5ZkE4SptoAxIZcxgPAje+kr69fYJeOubHxmbhCMrRsXzeLktJVulkuBG5TraQ7Dsoe4LvNKhuz9JWOBfvXDLQMlb8bqvA6SGMqkoEN8Lyv3azPGiP32yE4N/txQt+0VxboDIK7wA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884283; c=relaxed/simple;
	bh=klLlUzVl2OHvSOmofLGI4scAZQjq5sr/6cj4SRTAobo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n/zMuT61+pW1EQw+3HLWjWdzHwWtwbaAGsPorLK7TzODdCFjVbhI6x3UnD5SQDxGSUu2QAvtoTWgkXqa7eCHtXNdSQ9sfY6RiR1haOKnI3gRkNspJfWnmUH8kd3/HEvEIfc9sJ3sHbk+fIYPGmuXIHTuW65EUvFxsF3FODuUUuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iL0wxPNW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MfqN/HCo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iL0wxPNW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MfqN/HCo"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CSVV4061657;
	Tue, 13 Oct 2026 09:37:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=; b=
	iL0wxPNWaiHJvxtjX7rASlSWan6wNmEFABOxzxM1SFh9gcOJxSW/nrx2JfGQameY
	mlgp+v2DV/urUu6fDt7Wzp+3KCJ/6gWi/2hDOYc13TvRDTajAe5Ol1jaHx8zIC/4
	m0OTqgZOF7n3gmYE2BScSZ952FFR2aHYEmeunxOAL0RrrA06OAE6VBM0+KWpSxXH
	DR9miiTcP3kJ0OYvfUiHedAQ1ybwxP85PUV74S+Kw+Dk34LPOrHb8+eLPpVGrNmv
	icKhh5yR8hWOQLdcJ3R2xAfSdRHT3MRakARLXIUZlIXUorOJTKVGFg9BrOkN7bCC
	QLML38kVRaNvLlWubLNCzA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dbkkq5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:37:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aUMT010972;
	Tue, 13 Oct 2026 09:37:57 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010046.outbound.protection.outlook.com [52.101.61.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d3f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:37:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NgET3ThFKDXx1ZdqzjTPVqYKW0fuQFU4UOmNPM0tD++9Pa1c+t7v0TAe3XcqT2fNk+WPL3y34CYWdFObqX8dIr0e2g10r1+EwCGML6sDG/w5nponW1ISm2I+CxlXgt1neVasT3rvAso74OrteCnqxiYADo2f+eRfBdq79DOxWShsDtViAXmMTRpvC7ReNMcHDyC/H45jWhGSbrJQb+G0ftZ131HRgQS9yFW8hblIQGLzg1PvUpHuYPTnZq7gQAHu9vObSL8K9QWDuM1lJGUJj/5CCRe07Pq7oTgLvefE47nLZQ9NaoRc19ylhxRq9qUbpBG0OrLX0lq8ijTzXfYkLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=;
 b=DsYz4O5gZXqsC5rhO99IUTkeLyVZOjdSD2ohfHTQ/Y+J4BpbwlGVBHyaFv24jgGxm+soOrtX3M3h2U5VT7JE412C6XTkSN4zi27G0xH5mYlvel+1nQ8hySMRD9VJvOzU3IND/KoCTq0pKGVhLaUbFfnkShKEcQBe0qvn/V7WPWo6qc4Qn6vxcjYMuCI8Eg3OagDvjF3v8CTxdNiDcPcyE4J2tm8KwORFJmBkaVXqXWzI8TbCNkWgPogd3yef9eqQTttcOkTV1Xnp0w+fMsBIgtvE+Ew1VA4UZ1qEfyy/N1KiIWZJBlHMaH6HW3j+uGzOIZQJFbDmeqMbrSdY6H8QdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKI7UGzTfIfw02bKeXN5sUCA9m0Nk35g8/30Fb6mEAw=;
 b=MfqN/HColNP6QDN203FBIKMsolyDL6tt6ktwL8yjuZ322G+rAMFbiIzoSUiEx7B55uoLVQbOEfLlHYKqHdokO8G9TB4CZ9HFIId7EsaaW7M4qu+TayHerscHAsIRdrkcENl/9w0Lst6Iidz+xasKNnvnfW4r0Xn2/45kAAIdUmc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:37:54 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:37:54 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.12 v2 4/6] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 15:07:27 +0530
Message-ID: <7edc2c06152b380bbead59ae0e4cb9df416057e5.1791883280.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883280.git.siddh.raman.pant@oracle.com>
References: <cover.1791883280.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c2797f4-b53b-4e82-77b1-08df290da826
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hBP5sGtxTi5nShQhgSOGX50O3wh8SxAw1+j6v1QyXC5e8OVeh3cYEvN5VXaM/XKb9mJ+DRIHupJ1rC7KSfRM6bFq6asxft6K7D0El2QoldqmzwriQjtBMRLv8gbUnuy0Ospbm9wITXHfOfT4+LZNc3cfsax3+5VauFt+dV+63N0R8i0yojyssbSIbM7taVXBZQycdS/2Cb3yAid8NWVr+eIdXydgeuOF7nTmKlHNvGsws3bQsyPSN3jYSmtrIR81uuhMXjnMOStNxdBIgiQPTAIzifkiFfDKQSs2Z/RaU8FMEdyNS6Tgxu5yaAcQnacqn4ygyrdvBRMDUUJ3OIzs4obvZykE9p08QUBOVOkM4+aszdBqwy1oDtxULF3yWTpJP7LaA3U8bR9/EIuI28mN2VNugbWhajggXjScaRIs4+NHnHd+Yxp9xy2rGsjm02Ws4L2cNQAz2l2/1IBKlIpxPSrQ+7j2110jWcsW4bXs1CZ3njYRpzI1Zdo78rQFkYmSNrlVbGaH4MISZKNdNbfcT5LSXOAtOMmU9Gq89CVRQvGKU+llL/T1ZmOFqeOtKTWfzRwTspDcsW8USic8/LJd2FFUvxP7aabs0UwfqU2dZ3mzNvAXfUGgcqxQERYFk/MWUCYMplVg4vjSoahclUnkV7MHZZRM6SGL9aZX36YqJFE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?69blIlhUHx+IGAb+5eGprtxRahT/Tc5lbyATMPrdK7jbOX+OxsNRt/AX27tF?=
 =?us-ascii?Q?Wx6ivKH3c7OUYoKdWMXcaIVizgKC+tj4DRoHEznWhbeTyL63m3+kzBiizFOQ?=
 =?us-ascii?Q?513VUzpmDOv09FiOisvXzyZ2rixBB+WCsX6o2A5I5oIJ8ICcJ+y77fFS5QXw?=
 =?us-ascii?Q?btnsCosvPOzqotUy2GNq0c12lii1WLFcAPv4spqQqaEntphP3MGUA/xbnvx+?=
 =?us-ascii?Q?5h9zrxgBTQwtMrrbbMJD6mmnxDaET6Ia/Re5h3BkORgGcWhq6Q6yuBEhcPYb?=
 =?us-ascii?Q?pX9PkksjDcruPP0NADihtHFNtGUIuoC01bcBl0dSW/x6qCxhxqsM09XhJw8h?=
 =?us-ascii?Q?3qoNiaDxqLbPd87V5M3745fDCW5bdnEVo5UYg64VqjRb0AvD+V9WgMiJZ74k?=
 =?us-ascii?Q?ya/2BoR6YPNGYe1mQzOuq1xpIATVEBS8AinAth7Vzd+l5eJk6+jzhalROOt5?=
 =?us-ascii?Q?WqFHhutO2Y0ymnsi6CGrhONXPQcT/6Aa4K/ks2l2E/7VOH/hu+mvJhTxSS+M?=
 =?us-ascii?Q?I3pYSDG5cf3Ic3RJMa1gAR7sUHjxZEjyVCX45McXVjlkJwzcnsTBlahjbpPR?=
 =?us-ascii?Q?3FUOslkCu1zum5ZUayB4SjEGzKATpFx5Qin0xbmjICWIJLXdpUD/MAv0ykHO?=
 =?us-ascii?Q?b7j12+SKa3VmsG5+ho3qkQEzqhbfY+jdwA43hjESot6unJODbfRxWiv52H6o?=
 =?us-ascii?Q?UAD3IASwwSCbj+zTFQHzxTDzS3v7TeUQ8Tk/JGKmufSOu4dnnPHcoU5y3rIf?=
 =?us-ascii?Q?nkp0qHhsU6Deu89r2T4F4LyWEGDENSl8ZltzJD0B53e9jQgDL9i8Fc41732U?=
 =?us-ascii?Q?RbTBzMTuggRTgkI/itPWMmfyjPHCzejAl9f+unbbGn4Eh1OVRtisptS3O93o?=
 =?us-ascii?Q?aOmZymTU2RObvnZACj3ApBOG5B0Lldung9zM7JLyPpl55ZqyZOYbzECg6wZ6?=
 =?us-ascii?Q?X6DAP1E05XpYizhKnOmSTmKHLobuY9bIEI1U2ndNJLh+QxwEujcfk9oeG3ec?=
 =?us-ascii?Q?Pbq3KYpoV8M+MAkXEH8CqJwtLbnu7jSTUqv+FfM1E65y7V+RSq3P3kT6Cise?=
 =?us-ascii?Q?OgG3syDWFABB7g0nFbcgO/VgQ7O5tAEdK41CTyR1DQ9/Ocuofwpm59KttSHO?=
 =?us-ascii?Q?GzZF82W9oE17xkM+2SgPB7D8L/QyLpP1rk4tTrXjF6S4DhCRzlkSweIyC/OY?=
 =?us-ascii?Q?QrML0JDZNdROui8PjOArhRcyDRhJ7mC3ctN57RQzXb4QD409NHJ4RjTHnsV+?=
 =?us-ascii?Q?SIyz72bTknw8bEkF0ope5pfhZEetBDmVrYF3O19Yt5HjLNxlRMU3XrlvIoYZ?=
 =?us-ascii?Q?5RmSoRJAOxY0mwJQGLzyB/OX+u7bwdRcjSPWIdkTWreEAgmCPawh8QrOOjQE?=
 =?us-ascii?Q?1jiLKqF6v7nDwbCyItF8nkPdeVCW6f4GggyksYYZM/zlwLADkGzkTGh9S9wr?=
 =?us-ascii?Q?CBz6StWn1GRSQUkB58dbfq8qbyUE5783LewIYQuGuVU5XUTBiMnn52KpepAj?=
 =?us-ascii?Q?3/OY7QhvyTgjiLeLMsGpSD6zY6BUA3diGICUmKmmaUdqZl4w6hod8IfwKnms?=
 =?us-ascii?Q?XJwLqCpcsJk5NRT+gVDGkxrDgSfQQdBTrNErmS2aJeBBdIzbCCTvJKC6gj1E?=
 =?us-ascii?Q?ekM5xWZ2nmJsFKZFidVGaotnf20ruoCP/m/Flcnbz0XMCj6Qf20Lr/EXfl3I?=
 =?us-ascii?Q?s65+fesn+YKYT4GwRxNST6nTHQtfNXBkaD+KlxHUxh0hvYHYT1SLT9j55Q4s?=
 =?us-ascii?Q?F15DhHYxTb4DI9sbCBkorlsJtgIDuUvNQXB9in3uYJfRiI5cj2FE2iFg5g9e?=
X-MS-Exchange-AntiSpam-MessageData-1: IVknARpCULElolDqgKizYvSKnh3pNgh+auE=
X-Exchange-RoutingPolicyChecked:
	uxpKyCCDqSs43UFvW8XuJrO4qhLJM3eYzkHFnkjBrDnQIZrCJpPaW4ODILHkZciMI7z6wf1nUrH8naImJFGWAzjieT7qfNV17L74pvLnn4AxssU1YsCMavdXvsaO/1ZPvKUfJWa1qSnml7oXsttnAgVQafAimi5MSeKs5eMiizAxUY41jLHd3bIjS2MZLtzbvi6Cs8APAC5qMujdwPgNVi02EyKFq+36wADF4F1eyx0DiKuJeLA5Rk0hDar3BvugtFfrQOth4y2WY+o0ECBXHidtVNStbhBTwWhp2pOVO2+WJ49JHCUfc14BOmxFfdxoQkfo19GVBpqQSFT9jBWxig==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MltYtJmfcFfHyGtMmEcByQRPw71WAIQRe+0LdWks/7aM5G16rNcJCx0nY2wcrQ9pNHN9kLaSB9q5W9A1m/kIUliIErfz5B/42P/WxVcnjkmJFt8RgGmqVF51TKHzNvAihSx3ZgmBBKk/bPQdA0i2wVQ4L6ACs4qylDDsv+f2cqznxfqym+Jhv1XWCVeXeBKeZJClr/lb2nuB3eH0zxSU7YrQc2sN60p+V88e0695P81T4FXvKBcvvJwp331WLINwREtXjpfvyrBxn3GqrOoT1wrjzf1mzQHqB6PD9KVv8aKmxcKHSEzDs/+iN89hv4T/JTd35OngOXXfL5NzGya20DYNsCzrsCX/gy4bHd/uaDrq8waGEkLf6mBg3664mPCG1OUalZmyKHVkl4+qG6F59peJFLUN40iAyzGCb4HreGABDB6eYHZ3SyJg7Xmmo1oAPmyz5Ci9lRkRykyVofSJPq3yeem/C3CBs41xX086R6qA4EIckCMAtqvlhGiW5ukA8uld9TqFaNdVD0dV1g5YbYN+fksYiXzHDY/bS/EOyGyj+RMRLU2gh5rr/Nh0oi/1Hgjhb4kG6F8UYev8gV9Cbq3475m3OTB0joFvzL+Ekps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c2797f4-b53b-4e82-77b1-08df290da826
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:37:54.5668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2hsIqPmFN8nRHfl1g1VwjtDS9+nQSXoWz3KK2nnI15Pn84QLueQ4FY+ZESYe31/OIqotqwyInSh4xTGyxAHjO59A+/ci1bvkjLex5Cz6xE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=Ra0FmFtv c=1 sm=1 tr=0 ts=6acdfbf6 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: N6VMIWUHcrCVSUVtgp4-9RmQaCShTRwH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8vTe8fyMDQbU
 IRWS1arcYau0WU3KOdr/K1QqfU8wm0/RAa6eS5bzgTQlZAh2pyo8mzcBDlOJnzpRNvix1eRNjpp
 I2bron9m83YjxlNC7bPD2sFMfWbkS0byO4fItqraymKdR5cKXAiNWnIl6t8t00cbCkuRBNUt4CN
 YLB0gKcAhRvRpNaYsvQreiR33ah9810PSb6S6LIXQSKeb2LC0XtxKbPKqc3NkngvQjPNTr7zcgs
 netsUvRaE83l8oifYy+prEuCs3J+XXIBz1exU2eVQdPLQOG8HXrzU+y5Lz9Xv2t1wP2UUHU/IrR
 +6JyxXIBdVoYX/CoyVzBO2hYPPSd7iL5oP5AEjZhMhM1/S8BKKnDy60rOpkf5B3ClVP6/z5CiE1
 D3I7LJ9GharG6tTJQYMdG4lq+hI2TS/wsKaOiehYVCoRSSevDEj63QxQPpyQ1dmCs4vCcnAZfQ+
 4gV5XzuzRNWvnmsudMQ==
X-Proofpoint-ORIG-GUID: N6VMIWUHcrCVSUVtgp4-9RmQaCShTRwH
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXy06vEnQ5w1zi
 4tyQc72myN2yD1exS5XW7oNYUdIXhLnT8qdwwReXqbL5riQrVNP5VZuAThFY2+MGbkOoe13SMUi
 FHBH0RKfWr5rntDYe/xbi//o3wB6TUVwdDzIw7wK6FbD9RemXFfv

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 116 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b746a1a0f8dd..042282a08216 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,61 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
+				GFP_KERNEL | __GFP_NOFAIL);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kfree(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kvfree(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+	ASSERT(atomic_read(&bip->bli_refcount) == 0);
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -563,7 +618,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -673,7 +728,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -824,33 +879,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
-				GFP_KERNEL | __GFP_NOFAIL);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kfree(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1072,34 +1100,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kvfree(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1119,5 +1119,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7ddda0aa9dac..8a8a46e698be 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

