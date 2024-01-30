Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D35179949
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658281; cv=fail; b=DMCUAnaNddLl8l6+R8evNoSFdYHPfQJq/upkKcmLzaXKANWiztpwC3OdmKXmSX4/wIbcpQE/ySdnpBdGw7b7IuSa6FmQZ8XuNnaV/SI4hPKXkwg66Aict/g5CB65CDGsolrsgDDFmdCtvrcmD2XHfsjYz/bhv0eG5s/GhhmQdkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658281; c=relaxed/simple;
	bh=/Vf32951WbjLwk0YzCK67Kzyt+8nZouy4yut0yKV2Ko=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YG8CMTBT+RJ9yoAXNs1VRQ1OqMIv4TijwPGyzkQe1MwPUtv1PElW+u/NFgc9mQ6HDzon2HYFWQEf6NxH1dE/Q+8Ca0ZezgfJ+6uTEND2taevT4dhoebjah1Ou/g5PN/+koNnbO++0r8rMGrXHi3+F3IB+oPzDSOvehLn2srUp5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CSbLKymM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GTClQrmD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CSbLKymM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GTClQrmD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxj0D030554
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=CSbLKymMlQt97pC2wdrOhSXWn/Ngu9wvYxE7q3RYUpytW8D5diXQT1ZApi7KfnVR9Mpv
 k2u+z3mHLRXUNi0dKvzGniPZAE75jexjBvQhkNppmdOIDhorBIsz43Xv+VuozRzAApl8
 ulWCd8+14A3iUguvxFY5xZ/AcS+Uzfi0qI5e+B0bPjR0/QsCfSNbhsoJvBvOwpJ7/sks
 eXFLAJF6zcN51cQhVMMtUS7/W8xLA+EtLHICuL+0jJfezfr6lAGDYkSdNalOccFFcf9K
 XC2k/9FRwbl7glFQHn84T8YIOWHgmd+NOV4MdQaN/FSw4lC+q2j+O4+cNJ7Unu6jQbrz ZA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM7lKh014564
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9800uu-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkuxxNppWTC02ZV6tATu1X0jCE6utFMqh50pev0HUdiqcWqF0qSvGOAiBHM+o0/W5eVRsKkZeHZPFOGE8BaxDifeMiwns40hs4nmrQz9Hnr8TsFdTMhqHTN4Do7R7e7LW3wRpOYS7+AjBQ4C14Z3FoSP6a1xHZOU++P0tZrCkEqkfF/TiYx2kQpYEJ4aRKrIVtaK4mthmBPOHgmJuX4ReSGpH+3rMhu9ZKAbcgvDSQLe+tG8cEDBOpxHOgOjhsA4lAkGSyRvMTitkZvks0Q1tIo4tKqPPn8DcKOJLVKIA+J9yPNDw9Jf1sMDM8HeFy64qzO5e3yDCuSGH/whfVzvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=CRlVdX29++yE73fta1WDTbscWilztbtuXVII+iSfM08XsjOJ31tFsDhTvELE5wUYKmAcXF2oUnEpVabOCpf6gQZKVrJDk4daealQNC1ZUg6EIHxFC0KrPUitPCkTZ+C6+sWW2co1cZKlSkCDyE/nC6m4pOwzhpvq2GVTgIbSXjjsoJ8+nh63QWUzta+EJ6nRO3rssqNsMIXU0ZhUAl1LcRGIjTeY7RX74pqdpWE313rebKT4hWa5La+w8tup8G0aA8Qe8a12am9mUEp1978KxpIevhNJfGWN9K6TtBbBuxDVX6i0i4WDkvCO6H2noDP1BCj7k4uafhe38L6oQrKtlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy+scyhp7l+kFH1EaJfPS+TuHkOU/JmszeYszauM/R8=;
 b=GTClQrmDvZmQDUMMJ8ZTEglm+kdQT19pJhDkmSjDjC9mtGQSxg3UWDo93gOkgw8D3dt1Ku7eUh7PFRusScV0Q7OtQLqBW/8mJVJE9Gcjx9ZBhtF0QcQjJ8BN7CKR1eyYZo4aE+QBfJzO1jsJDJzAlVUywnReJvYCuyYsyapcQU8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:35 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:35 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 06/21] xfs: make sure maxlen is still congruent with prod when rounding down
Date: Tue, 30 Jan 2024 15:44:04 -0800
Message-Id: <20240130234419.45896-7-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:a03:114::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: e1141d39-7464-4f1b-d6f8-08dc21ed69ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NwZ8K5eGAYNYzVkMF7vMuSlSR0POOWABzoHYtztI7aOejQwdYKf2YofYsWWyqgX37zKtItFx6m+7mlvJN0Z8PIOyUcJv9+znB1fpRBeMIRx8Z5okO6zuGFlDhmMvAp12o9QDlipMd6VFtIfj3mn0eKqZpmvgnx3cy1N8RVcenb9Tq1sKz+mifsd/Tr4u1ak72FKUTvUXSNU++up2jkFylRdyvHHO5jQaarjpjUDUALouoidD840Nzeo788T08Dwvu3tCxhSN3U/dHIxwU97yVKk2UUO7hQYzjuxxL0zu1V70LqvjJ9rlezH4xzCn8OmlBd8T0Tyk1N8H/a35rywN/xQ7FxtzUeSg2AihIScdnxMYkegPTWh3wOtObtCJ6sx24DnstSGL4lv2gkbT1gNQnqcUUpu7n2e6gFup8+mQzJg3vZdFjwMh0Y0+rCX5AzBgE5JwQLq1M5zdd92o/9qAtOz84TdHsakyZxwell1PMLU2D6mR64lF+ehSJNvYcd40xWXCrBCqau74nmpmDEXxKLPGG3jnqV0VNTbBvQ5ZrCE1F0eugSdyHjWJjtAfxK1p
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Z4+ab+HWXpPpoNfE/DfrRnM9ewBIJvhx7g/U1DMz8bu0vkkmc4343OcQsHwB?=
 =?us-ascii?Q?+mHdtPkK5WPqVYGaBaU1kZ8TW0+gPLDWoYh1OCR0Dz32CHVpvycQM9OQQAHN?=
 =?us-ascii?Q?ElpExshIMQRAXmY2vmhJ7hjgpKGGd50Z8dNUk44ffc79vmE1vf9/XxxGLO5h?=
 =?us-ascii?Q?2C3Ll0HawNZJQ7CGNg4bwBXd9ebztIqAmgdlHm3ExMhM+ac5bcUT+7+Pf9Kp?=
 =?us-ascii?Q?hWXC7K9waMJbDv6vh7EmpYJXT0m32sqwXFXCCG6jLGY1sZsHsfsoZ8mRMNSO?=
 =?us-ascii?Q?qq6ETjY36b959EOZWK6lhYUFiVnDO4LRhuKIcEYFEnzbrN3ZNSq6LDj5OU21?=
 =?us-ascii?Q?NVbIGY/3T1capjL1B5+QLI+Z6SMceVk6+whvLmLk6uH03CrN3AxBMe6b9/h9?=
 =?us-ascii?Q?nCLsEIz8egMPlLGTUOTj88eUEELYn4R2ZvomHEzJM9OdqCaXpDeqexfgxR/Z?=
 =?us-ascii?Q?5HyrWEA6KqrWx5m0SUZqePXUZg6tk1MWQLAx9RKNatVIVBU7jHVuAyPDifxS?=
 =?us-ascii?Q?FDj0PdnPGKtqAXC32ltRMRIMuaXfh0eFY3bg+vOWvBomz0sLQDuntAjWsupx?=
 =?us-ascii?Q?0JHxj6hjPg5LB8xSp3kr3iYgVOwXNBC1UDBSEoIx1Md/ZWGLBcYpnmTFlc1w?=
 =?us-ascii?Q?8yOTbwpuXt+wlqUt2cSOjWrpLmxQSKGSFTSMKaR172KAjaWcOhTQk8DzZb5t?=
 =?us-ascii?Q?2Y2JKQA11GhhpXl/PWNMUEyDkPzV4WaLXjDvnmmiBXkNUsM67Vcc7XAMRKk6?=
 =?us-ascii?Q?umTPUsibfzK21xJEqhMSQNEYCTA6uS4n+4oZ0sICNNQ4qg8apydMytnPCUgm?=
 =?us-ascii?Q?hNgYUiO8AwSJjjGXCgo8uzFbTglSF31h55+B2xIj5T3beNz/6TiFDkP0r99P?=
 =?us-ascii?Q?hjELAAPCAAJVvX6azM+kX1ZvrBHNPucYR5QzCLemwkr53eho3hSWLqw5iluL?=
 =?us-ascii?Q?VPc9ACn1lnkLLQZAhmKaXD5vxAjCpRyyoOPQ7GvOm26dfFhhFo1SuXAkmiJq?=
 =?us-ascii?Q?S8bK2lyIPzgFmC9SuZo5M9k4XxtJ5aY22Qjj/tVuAROQj0Fxg9ZMx6nR9OXi?=
 =?us-ascii?Q?t94yWvNS7RrVcrVGxvha3NW3XFxU/amVl+2CQin/BuH+u/ADaLeqygWnHTWb?=
 =?us-ascii?Q?uuOtiu0CTWV1RgFSk3+s499X2lwhjKDidOyJU3rh4nV4T6HdNDsnJJ/pLApv?=
 =?us-ascii?Q?FDV4t/M6DvtDB/+L+d9zduqGS8qvrQO4qnVVI8wYdldWWxKiZUaQ4kZCzfQr?=
 =?us-ascii?Q?CzhZzcPtT1wBreBuXdB93H4gGlBshQ9Dqp6X3zs9a8AfOeG+hxUEblngf2IQ?=
 =?us-ascii?Q?/G0sxBvPZWOf9bdphEO2VFmyGSjqJerQdjVW6gWj/sNBkkeIw297CCdyS0GG?=
 =?us-ascii?Q?BZeFxn3e943WqkJZom6ayBSbsZ2E2vjpfAaFauMFKy7bzifpeXfAfQhNVm5Z?=
 =?us-ascii?Q?PWkcn0hk3/sDDLuCXCTM/sVBgNPhEo9xaMuCfJhGudcad9YU0DaGRUZCAjxa?=
 =?us-ascii?Q?3weCFXYLsvlw/foELxbqH3cwtyEI7M7/yeSsI85TZEdqQUwjLi5OWk6SaeXm?=
 =?us-ascii?Q?v8P2EURMcRBr4FgkoVvteiTnVMOxbby6oNENXr5H1xcs8X8C2UIzy+9O/HR7?=
 =?us-ascii?Q?lBZTpjv16B8qxj8wUXHxz8vT6IfvYsw2D1d7PzlFj2vJ/yKqP8SK/TWgUArp?=
 =?us-ascii?Q?xlg+jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AWLSiYdDsiCtfJffJTQXajI0VpkFaTPZ/RfFPaX/l+HPygDTP/eY0ASLqc56hXCNebPJZC9sOXZvjM92UJaxR6qwsYrlVpy2jkp6hv+u16DSCKXaMOx+wz0doeMensltgEl9cy3U56URBoXHJ4bhXpBCErHrkQT/pFXKSTYka+pIFiSxeSLkdsb4ll8cjcqfbaXA/RDd2RXmwGwTPHH5JBGAvc1FO6J1PFF/YjCXWQHD03FzGsxuYx+SU7CQadlouIo0ApjfM8BNz/O64N/fWWOAQNC1xB0A8IRF//H9ubFT3cHhxXHD6yZb7Tizjn49WHNwFoEmVZdaCf4ICZqpx4qFu/BPM836icwPkrWtOeBlXD1avyzWohIGIkKHmeWAk8cmNjBC/jHdyH/PmU2DYUvdoI6vnSz5adrQUcDFxFAL56GgEqggS1/HwTv7JeCr78AVIvpWDr/ejoplltm2KCKeGJ8llqfUcUq/W7EZ8dh9wgBkAS72IMeALlhyCk5E8tcJhtppRz/qNjnd5brBOFarsGa7zRgvsY2S0snjMnek0yQk3l0ukN7P0+XXQysTiIBgIhvSIzu0UCt9g4vVOy9DUcySFz+qXifXXrgn2uA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1141d39-7464-4f1b-d6f8-08dc21ed69ed
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:34.9686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOyS3nAwMldGHNoRpm0gMZqxJ5E2K054a6SJ/Da8D/z861xd9PVZI0a84cbczRefSqTfdarDHnlkQ1uwBOuRPbyej15M3Z4LAfMj2dQhGo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: 7D1iGMwR360OAOep7iWIwN8-lDnGgio6
X-Proofpoint-ORIG-GUID: 7D1iGMwR360OAOep7iWIwN8-lDnGgio6

From: "Darrick J. Wong" <djwong@kernel.org>

commit f6a2dae2a1f52ea23f649c02615d073beba4cc35 upstream.

In commit 2a6ca4baed62, we tried to fix an overflow problem in the
realtime allocator that was caused by an overly large maxlen value
causing xfs_rtcheck_range to run off the end of the realtime bitmap.
Unfortunately, there is a subtle bug here -- maxlen (and minlen) both
have to be aligned with @prod, but @prod can be larger than 1 if the
user has set an extent size hint on the file, and that extent size hint
is larger than the realtime extent size.

If the rt free space extents are not aligned to this file's extszhint
because other files without extent size hints allocated space (or the
number of rt extents is similarly not aligned), then it's possible that
maxlen after clamping to sb_rextents will no longer be aligned to prod.
The allocation will succeed just fine, but we still trip the assertion.

Fix the problem by reducing maxlen by any misalignment with prod.  While
we're at it, split the assertions into two so that we can tell which
value had the bad alignment.

Fixes: 2a6ca4baed62 ("xfs: make sure the rt allocator doesn't run off the end")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_rtalloc.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 31fd65b3aaa9..0e4e2df08aed 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -211,6 +211,23 @@ xfs_rtallocate_range(
 	return error;
 }
 
+/*
+ * Make sure we don't run off the end of the rt volume.  Be careful that
+ * adjusting maxlen downwards doesn't cause us to fail the alignment checks.
+ */
+static inline xfs_extlen_t
+xfs_rtallocate_clamp_len(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		startrtx,
+	xfs_extlen_t		rtxlen,
+	xfs_extlen_t		prod)
+{
+	xfs_extlen_t		ret;
+
+	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	return rounddown(ret, prod);
+}
+
 /*
  * Attempt to allocate an extent minlen<=len<=maxlen starting from
  * bitmap block bbno.  If we don't get maxlen then use prod to trim
@@ -248,7 +265,7 @@ xfs_rtallocate_extent_block(
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		maxlen = min(mp->m_sb.sb_rextents, i + maxlen) - i;
+		maxlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
 
 		/*
 		 * See if there's a free extent of maxlen starting at i.
@@ -355,7 +372,8 @@ xfs_rtallocate_extent_exact(
 	int		isfree;		/* extent is free */
 	xfs_rtblock_t	next;		/* next block to try (dummy) */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
@@ -438,7 +456,9 @@ xfs_rtallocate_extent_near(
 	xfs_rtblock_t	n;		/* next block to try */
 	xfs_rtblock_t	r;		/* result block */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
+
 	/*
 	 * If the block number given is off the end, silently set it to
 	 * the last block.
@@ -447,7 +467,7 @@ xfs_rtallocate_extent_near(
 		bno = mp->m_sb.sb_rextents - 1;
 
 	/* Make sure we don't run off the end of the rt volume. */
-	maxlen = min(mp->m_sb.sb_rextents, bno + maxlen) - bno;
+	maxlen = xfs_rtallocate_clamp_len(mp, bno, maxlen, prod);
 	if (maxlen < minlen) {
 		*rtblock = NULLRTBLOCK;
 		return 0;
@@ -638,7 +658,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtblock_t	r;		/* result block number */
 	xfs_suminfo_t	sum;		/* summary information for extents */
 
-	ASSERT(minlen % prod == 0 && maxlen % prod == 0);
+	ASSERT(minlen % prod == 0);
+	ASSERT(maxlen % prod == 0);
 	ASSERT(maxlen != 0);
 
 	/*
-- 
2.39.3

