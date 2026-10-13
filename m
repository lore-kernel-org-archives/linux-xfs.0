Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F4513B58C;
	Tue, 13 Oct 2026 08:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879180; cv=fail; b=q8rjPbmqkkMtrhsbwvATqGWU+iomw1Ahzsm3WiGanARnqTmi8/+3qhCG7o2Nt7Yj6UXnUoCVr45T2AMvqWdzBbOo9NKAJ70RCMhpx7Czu0VnrFxCb7BaG1N0m0kqR3++CmC1Xy/06kUwl/Y7OjFxbzQRVGtpX99wvDmpiS8CCiQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879180; c=relaxed/simple;
	bh=GJcJJGrVL9mq2fuC6anFDSw0/r2B1tFUJpQMiq/qMII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QkEKx9KlDXZad9gBFlnggHx8awVkrcrZXEMHfMHbqf+ozf4nNGskrHMZnTr8dG9ahj09V/xP8QuC2BHCj4iQKoD3MrRo2M6E0moG4MwymoKmPSOJeh24mntpfj4Btz49sBNc3NkuwW2sVdHxZF2S0lyHoYwhqu2+GMI4w6X9uWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mfUs3E5G; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g+pRamEJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mfUs3E5G";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g+pRamEJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Cfv0680865;
	Tue, 13 Oct 2026 08:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PIXOXKQbWmVMtSHQpok7l9J56BOr50KcIpFRG0v9IZI=; b=
	mfUs3E5GCCnDVf9l3DKGJdUeU7uq5KfNKZNitXgWGBgTi5UjOZAMKeZ6dzHoUPRJ
	u3hcmTA98RvrgJBIL+C0PkDrLqB3sQ6EfT7dE6Q1ve1mw2RBIgY/QRt1nOyGLDD1
	42D8rLL5wUDlMvM1hJV1eumj9V1v9bGhx4r1NY1RDcrr/Iv5L+62TxSvqJXmYy1R
	AlpSKJwFR4guNK63eEiZJWTJl8dBM+SzNtRwzMpdKN7xC+nCQpHw3nXpCcUDPJtf
	4YhPv/QIvJohV8DF25KMuz1B5RvizCk09G13Q3/aDgK4c8qhByeYQZcWmjd8Re5X
	rmMsVtwGwzmzBkwyY3fLsQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dddune8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:12:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86maL035036;
	Tue, 13 Oct 2026 08:12:54 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012004.outbound.protection.outlook.com [52.101.53.4])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7b48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:12:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=REZwGX/uaQ6h20upyhyXZAdC0FM2RsodPp70wE6iVZseZbgWduJ8B7zmYDPRx2EqwC8p21+5EEzR6kLQHLAItFU6VrvPzxcF7JbxGCN9wwUQsmGe4YrselrjktZLZb+LVBcyC29CJnquNASMW8KxlMiJTEs0Ju5Bk8KKNd5lb0uDTxisyGnFUTz+RG+P5RA33PqNY77I8xJ1/FhE5+gK7plP3K4zK5AhLl49kEnQipMWOgzLQea72FFdElBPSupTXw2OyQb153jyPRFPya8jgsfzWIEyGtBnISN6iyyhBrSU+ukcQ45yhN1tfFBnw5ajHqcpT1SX9iVtRLV9EcWckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIXOXKQbWmVMtSHQpok7l9J56BOr50KcIpFRG0v9IZI=;
 b=X0fHS4zTyGgkob1IyWJA+Qfl4E5/FfUbTUTGPxDgGxeMuy6uxsbIxDuwlPhJYI4V8JrSEcxdzBdy+QFg1UFI0G7dD4sOL5xG4fwz2bwplkQCSSNBtoT75kxA5b7+O6GA2kKkxTYjG6pmu4A5ezy9AQ9982AfKW3+Ut2HLAIWSUKiGGFUC5if/AFs6HTqf7sLL+zPhMn8Mmf1phoIMFJ5FS1/3NWL6lVSs7zAqePspefUr+eh4c48MnP/d7Zv/3gsLeIHuteNbu9FR/n4OZgyOhCYnck+V7Ey/eT5/AfeRDidQMTrd8iwqho+URHNPlCffC3RYdZhNGfR3pnPVTW5Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIXOXKQbWmVMtSHQpok7l9J56BOr50KcIpFRG0v9IZI=;
 b=g+pRamEJk5fon6YGMwro78WhJVIoHqJR4k2V3o7k+pOxOwZwDqWF2gzWx7kJLPLlF3Nn04OgBT/aD3f+K++ZZMf+OXhgUZa3BEqGoJ0/uN826YC9JtKNOiX8/TBi4kkpgVjuxQHaQ6h3IgKkQBBlEGzoEvv7Bb21XKHGiaThV7M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 MN7PR10MB104148.namprd10.prod.outlook.com (2603:10b6:208:637::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.11; Tue, 13 Oct
 2026 08:12:52 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:12:51 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 v2 0/6] Backport of XFS umount hang fixes
Date: Tue, 13 Oct 2026 13:42:40 +0530
Message-ID: <cover.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0200.apcprd04.prod.outlook.com
 (2603:1096:4:187::15) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|MN7PR10MB104148:EE_
X-MS-Office365-Filtering-Correlation-Id: cb402c69-27e1-4357-ba9d-08df2901c68e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|376014|366016|10067099003|18002099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ErzZqQHUbpxJOYtM+pOIiMAjNHfNqAlVqNtw9rnJpK4X4Yx5YiPSo/1VAFt12+0O38YHKJYRj2ScSGTy6jbk0/knKuIfZV8twWiEnTos3cnh/2YKetIKBouvfaqhnC6/4RuyU+4E6X8KAm6/aDHybT3cM13UQBluUyPo4KIxnXTyJh6S/jJZPMgNu4qLeDrVrXU1FAj9k0HmlVl4PuGQjZuAcQE1bxDLO8MKpLBLWcQXWaifu8s04zukmHYrPAo0eil04PZzGzbywVGil1lk6kIZhSHiF2HWxRcKu7twW641QfK+EBrJyZkydZmD1iDSc/VvKfmU2RWkQni2HO2CBnspy2oqUaIPo3draApaZH7DNtUyJgQkFsoDKvnpA8Bw216VNPNc6lTBonoOqcySmrn5MjTdF0MWyiSc2HW1EJnwjjrxYeDGCgsGhH6Xg/YUiv0OztvOfgtov1B+mg0EvXp/ytPjSH1MF4P/sqSuE4blDG5aanaIu2sbjiPuT4ZZMLSMEudF8PgMqDhZWOQRRbgkhCTf4+TBiYPWldAeag0NPz9Ghefx9XXdB1KNK5Vzj2E+eaJF4trFs67qs1fjfruIDSCrd+L5iJPx/FIJzNG8nhyeVjRqyekuCrXa4vKf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(376014)(366016)(10067099003)(18002099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wyd49mon9YodHqVhDNNCg5EQYRf7GwwBdkBvmji76je8wH2MDrXok8+bCDMy?=
 =?us-ascii?Q?Rf6dVrVigt5nbVfrhfPfUUx22xuiTfbCEZ5sOAoy+N2B+SZ38GTwbZ3630e1?=
 =?us-ascii?Q?FN8ABmawn1GP2Czltm0mfjMXnI2HGd7Gtt6dP2B/hrxkhXE56MUfsjXsk01l?=
 =?us-ascii?Q?P/43DZAet5b1FKQFA90F3sx095ue8TmLRx0Oyq3KfGUKKQvsDrZ6MoFgV4qi?=
 =?us-ascii?Q?mAeCmMVl/KRB6bXBtdpb8k81WQsY04tOFy7a+4MTzQt1cAtb46pcq8X3Nzx4?=
 =?us-ascii?Q?0+cP+TDsTGumXWOPSX13VayFxo0/lA55aTDcQkQ7JosUlfAitlsEudAY7AaW?=
 =?us-ascii?Q?0Fu9VMt0/01QU47qIoSnw2lNWoPhJYEfjY9Z5NmiBptyCwvUKR7+ApYzHG5Q?=
 =?us-ascii?Q?xq2KAQz+8CHX2OaITePDBJxwxV91uMnr7AeHRjvjgDcVmGYgdwBSwrh2aLLE?=
 =?us-ascii?Q?dGWWesy7aasXsrLfcRL2G3SQMDdUu5tFHYz9VdTCIkHS3QNoOpDyqDThiRuv?=
 =?us-ascii?Q?mMmdiE00Whqh9HwiKukVhKxF9e2KpgF02Xu4PnZZqvh9XJ0yncZnyLYvur/q?=
 =?us-ascii?Q?1pOAbLQu3zJZIx6UuEllJhomJRH/RECirndDrIwj+VC8QJgWrTEvDuCk3pa+?=
 =?us-ascii?Q?w/TzrJKfqlBawLyB8euzav53G1OMLsoLJI7AyUGOkXtAAwaiwpczE3pAZ6a2?=
 =?us-ascii?Q?qfEKbnG0IWqWaOxUzYeQyJatWTK+UhIJbd/j2dcPSIcIs9cvnuQmAtun54Nn?=
 =?us-ascii?Q?zSS0EKFmw1OyUBysMwuvGqjskIPvYcbdRiosjHd4/O574sXzzThmOuR6Dj65?=
 =?us-ascii?Q?Ol5/FWeJktYMZGSJYTcGuVV0OJOziKH+urDpj/ZOjwW6Hvlj6cwLxuUI2IcQ?=
 =?us-ascii?Q?7S88ttsfwFImAae34/kNWcTGdT8x6ms73jK4qT9D6MQESs60OW1gm8Jb+auZ?=
 =?us-ascii?Q?wbvp9SobnGvW3aLSvI8qsBXJ3433CHoE7bl3Amtj1mb+GqXX7HuH0I8roQUN?=
 =?us-ascii?Q?bUmQ7Z5IEU2yDV0D/1bce23NsueX5deuB0V80x9rNj1Fk+CCuRROuw+KnrHF?=
 =?us-ascii?Q?pXyAyHufK9TSw4I0Ml20c0G10tWcAon/L8NIXLbjxhZ5j4mVQH+GNz2j/C9F?=
 =?us-ascii?Q?nDu6IxXbEf2ycRkf3G0cPT/3Tvhp0nv+xaD42TA6Hkx3+S4V3JYGm+1BNzg4?=
 =?us-ascii?Q?c6k7m0xSNE6JGMWrkFaKOgheh5ZYrSUc1zA56Bpy+6DM5TLJMvB5ylbntfp9?=
 =?us-ascii?Q?hWNS1RVnr/Q+Pt9XcvdoMcNmGyU1G9ZeY8B4gwivoesiaEm1CmPnCevfuH45?=
 =?us-ascii?Q?KJ/uHI0HgOxOS/XUlKMRce6jZHohiZ3qoPFyB6ENpwodbkM2y0rMx6CU6waT?=
 =?us-ascii?Q?pVtECcgZ6YXhfPThWa4+6Q+sTH1XIOAfc+Lo718qg56iye9ieUqtdu1BQgUs?=
 =?us-ascii?Q?yt3y0kbFXird2Y+Y0Cdq1cqapsNE5BsiozCpGuwSLek2HlZ3AoZ9gFRsvAPD?=
 =?us-ascii?Q?yb9sXRz8OkX189j0zgzByLFRwnYMWBNdZsRuScGKquZfBcBWIAey5tKZg8XC?=
 =?us-ascii?Q?AfX8tTf0Xd/PPMJX9W9abZNhGkdFdOnsyC6qeUJuaX0Ir0HC3iJ1XoRBOEae?=
 =?us-ascii?Q?44Gj4jtheiJo3A9xY7c+Ui5Ebc2idOR791u5TJnPdaIsgPrUU4Ne6EkH4HAQ?=
 =?us-ascii?Q?UGN0BCK9GXoZJAH+FQ1e0z1zNyl8WiNobLjFF02UPLzXmt299eDOzGSdhexJ?=
 =?us-ascii?Q?e9RtG610nHV05HBHtm5mpZxyhsjiwoVxxinHDU5dtas49fS47JtoNxOTT/Fe?=
X-MS-Exchange-AntiSpam-MessageData-1: asvXd+PUllqGySigScsL6stE+h701KnZIoo=
X-Exchange-RoutingPolicyChecked:
	wxvzmu9kGfYJtmpvgxwXYPUhkkgwfQhFJcVgnqwjQ7JU+4zhncomz3ZH2wY8OzYFdF5SXWD2L+tIxiUYllbqLCigppxgbPFkmySyCu8dU8iSXLIVm1SGHXsf9t768wCYJ0sjmnDd7y7YoWua78kukD+NDxyK+eTf8qT4dsHzRKZ/rBvIvmXdtbUUqWl50PPvlMFxUPa8/G9pHZ9G9ApUm/6DdFVY3A5OytAX2/iuO78ajqVIRxQxy3wmcDTrFxa7Z2EzPx3ZhQLHiH5aIEamxfyHB95me5Q3Sh0QdclMxn75b14MJg1ujc+2J5OxtvCs7qOxbhCX1ZACEgXYvTEXBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	95IaHiZnm/Tdbs1ivtvttHytKCpZOiyGg2Q8ob2m9ZLy5ejEUROm2X6gj8IbkIguzPLT7Bm5IVgHIU+VdeRfJIf8HQNe55JNaCgYaEIaWGzSiHtxgzbk//ZFW/T9zDy1SFVhi8miEHE0L6v3yTqbGj2GcVQ7bqIvmFuQNDqUXg/zZXYwan+4ygC1B4vzMUzO4jf7ULKKOwniZ90r1RLz1WHWlDT4jBgJ6H7jIMvxSMeSDiyENqEy22qt4qIlepMSdccmRWhtXNn/qR1SeMri8NoFfJJPGMReE72e1J+WSg4CXQKWIpRJlFIDrG9qRTwzYVmgMAYIBESwKuoz8doNT6DX45BkfEA2ioWOjTzn3p/cknLbe0dL5GgbZvmC7C9SQfX8yio6IpBJY9+8RqMFgARZsqpO7MYmSMMCCS7wDUy8RVnd3iWtuamK2j6v8H8NCn/AF+SDJ8P6syv0603Dd2EEmOePHk8MfPTUYU4inag6axz8GWEj5cyJT2bbr5oJUrNDePx1o2Ad3rF4clg7fsqAWWlnsfG/zi/z8OFk1ZjvWgWa3ESXUjIW+TIRnR554iXiucFF7YBfsUFQTFkUsrUo1/ikh6+ZWyvn+T30iAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb402c69-27e1-4357-ba9d-08df2901c68e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:12:51.5564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qK6VV7XxlDbdU2i/cndqEwzu9yzcBt1RHSkwCo55KO8/wyWejppQTuapsAVrfTbNeIC9PlPdlY1lqmCqK/uVxac+gpF+S0dIHcGbtDhfeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR10MB104148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-GUID: OHnIR9XLkj5ygyRNDWvnnF8wQSNVVhB5
X-Proofpoint-ORIG-GUID: OHnIR9XLkj5ygyRNDWvnnF8wQSNVVhB5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX0ppHEJcgplvJ
 +ME4AIyjf8/QsNFlobRh3esLdH9WN5ANPFh8BlXsLJ5hBa8kKyYJjYieLBVQwWuoG9/1ykrMn7G
 KSeTGKOAb7wKgg9Tf5YxAD3Gx5uhFTOlZRL+R+APFMcFWytgDw0O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXxa4BDLBMC7QV
 xKFSwdvslMHCN2enH57HXGN1OFgY9vnL0HHUh5AI7PozYCzHEa5DrmgDgvTkVlQybSkAHwD5AMe
 GNBIjQeacbSQmTXtVdPWRZQ+LPZ/qvp0mwn3RJZXAK66eRU3IJ3tTXnSu5uDB3+aS6oVH366t11
 X0yhHRM8U3uIQUd50USwyNLw0K5Q25wCmOHTHVr8HUNbwSbVU3SAaj4b9DvAr1aDPwA4T0w/6+8
 SYxxmEaNT7q8S+KV9OgrDI2J7KWx0TdEVib/7oX6yC1Ss72A9v+vvzw21Kz9U04MH2d7tWEd8fX
 O+Vc5rcDldpA9CL/fipOzQ4aCfGMriSkEkQziVddI8d2wG7JZiwUTV6YguZND5HdTFJIkHqqod9
 KL17uFijcID1OczcmK9QeqRBaH28j6UIeVI2U+QKYF+dkKptV+6bR5phvgKoSNNcyXzlBxjPhwP
 gOLv0bRFbdLL/pn6DzogSHIfcI1XdI3Pk2VdOpTM=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6acde806 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
 a=3OcxSVRvUSqaRT7DloUA:9 a=biEYGPWJfzWAr4FL6Ov7:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12107

Backport of this series:
https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

I have added information in commit message upon conflict resolutions.

v2: Address Sasha's comments to v1 in the below mail:
https://lore.kernel.org/stable/2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org/

xfstests_xfs testing results:
	Generic:
		Ran: 001 to 771 (672 tests; gaps)

		Failures before changes:
			Count: 4
			IDs: 633, 696, 697, 753

		Failures after changes:
			Count: 4
			IDs: 633, 696, 697, 753

		No new success or failure after changes.

	XFS:
		Ran: 001 to 789 (311 tests; gaps)

		Failures before changes:
			Count: 2
			IDs: 300, 556

		Failures after changes:
			Count: 2
			IDs: 300, 556

		No new success or failure after changes.

Thanks,
Siddh

Dave Chinner (6):
  xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
  xfs: catch stale AGF/AGF metadata
  xfs: avoid dquot buffer pin deadlock
  xfs: rearrange code in xfs_buf_item.c
  xfs: factor out stale buffer item completion
  xfs: fix unmount hang with unflushable inodes stuck in the AIL

 fs/xfs/libxfs/xfs_alloc.c  |  41 ++++-
 fs/xfs/libxfs/xfs_ialloc.c |  31 +++-
 fs/xfs/xfs_buf.c           |  55 -------
 fs/xfs/xfs_buf.h           |   1 -
 fs/xfs/xfs_buf_item.c      | 297 ++++++++++++++++++++++---------------
 fs/xfs/xfs_buf_item.h      |   3 +-
 fs/xfs/xfs_dquot.c         |   4 +-
 fs/xfs/xfs_icache.c        |   8 +
 fs/xfs/xfs_inode.c         |   2 +-
 fs/xfs/xfs_qm.c            |  87 +++--------
 fs/xfs/xfs_trace.h         |   1 -
 11 files changed, 270 insertions(+), 260 deletions(-)

-- 
2.53.0

