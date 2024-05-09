Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1F322E
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251289; cv=fail; b=CKYtXf/QxU8hehOI1D5bDQ9mw5UDovzxvjIQNx48CTeOeETpiEZuj6XV2RES7hGaSkfWkIYpWSHNQfkG8/1ZPvye73tZQ8b2Hci7PZrOhDrxKsU4QMjyF6dnXk3d99KnMQuZNI6aQWqoVLEollSjfCpkE+F8piPYxyXpKr2WtvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251289; c=relaxed/simple;
	bh=KJv0bt0T5mRS92RRYYfiOh3t36bvciriUn6jy8hQkz0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=eK9H4FTjN68XZLxYPmWUTyo+CTV7ifOIOedGwL7cLWITLgutsNsPdPcI6LkJHgeK81JsqH6XktwH/ZfXNfYeThS8Rj05CJ/I8cLmD33YORkvq41X6mBcIQLDfcibrgkxne2K4tOoceAmiYZmTzay6Me6ebUDsEbo9XlqP8NTCSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h44Nqqnc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bI5uMEbl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h44Nqqnc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bI5uMEbl"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 449A28jn011468;
	Thu, 9 May 2024 10:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=SmOMetH967WA7uXYboOoFvv9mt4cJcxLM4JZfa9csJY=;
 b=h44NqqncseDoEIqIou8/Spi0hsYPDLXICnOyjJe7SWtR20QMJeGEHZKf7CZfFzq1107Y
 Erg52hy+QUy0vAMbXaqvqbPWy5jI38pTZfAkVCmYdtixEgHHS3ouNkJ/EaSSuuPy9J4p
 zfhIpUdeWx3X6zkzupCJiygnS3Wo/hsyOn1MG9uCrryrLYhueuQ8KgIWNXboUCxYGERR
 Kyux8sAx/ECFolFSaFndrodSnaQ6ahmHQaOL0qxl0tnC/YFv1RBAZlaYuuP01x49RMRD
 Orvp4NoiAqdoiqJR+xRHnIY/lr7DEs9hN4lTs8dOa1mKfeX8vUrYC/M4Vv+TvW7PMyhV KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0t628b45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 449ACuVB019125;
	Thu, 9 May 2024 10:41:17 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfmxrhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffd0/54UEGDi/OLA3GPZE2sw+JkNEM+6cGW1kkHFDIPuyhbF2lcxVeIXY/IgtG6m6vAivhSFyzXPyuEsJ5xLaEVe+FSnJU5XMzdH8fe1Y3wzXYv1XmYUVlebvuwppmPDAI8gcgaefq4QS25ivvPpAzLb4BF1mo+A5wajEuMqfCz6cbGEh7rA3mdEIaesC/yatT+95qE++y6fuWVrFRb3GWyI8qq/VqZvI9gRLkmNV2+odR3chT+wIWaxxKvRPA228pI9SmWC7j/Awj8SmTuIX4IZnw3B7hWt5MpQmixG7wSkHoQOAICc0NzSJz2aardD/Fy898GipuWmULnJD0Zzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmOMetH967WA7uXYboOoFvv9mt4cJcxLM4JZfa9csJY=;
 b=j79j5hHAzBfXvhHXV8tQKBa+SHGvCUARupn9Uius5f0k1ATEpEqFONa2U4/Sz1syHbkQFiyZAoZXofX566VVzld/puRqvDmBOgt/fswVv6nXk9pd10229NoWZnvQCIbScPu6ymYBeBhiOSsJ0hbTFcTVKDB2KgIF4U6hq/K49W9fTUfL2JHs3Ld1ZB77xO/78+wQbL8d2QCd4fCTgW1D1sUBcjnymh2FOBmBNacx47eKb7oybFwIN8R9AwICDE43xcf8gGX7YWRSLj+QZNiV6aQ4xag+T1LzP+83Hx/MbXp0nP0BOQgTeIFZMHd4/HLfY31IZi1ntCrFdMLAs7viCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmOMetH967WA7uXYboOoFvv9mt4cJcxLM4JZfa9csJY=;
 b=bI5uMEblLtjYUQ/lPdQTydXD4RjNYLlpMrr5R8/U5S2BGDBIHLY0MUY7GS3pEJDr8qOfgO6ibJgnaOpjON54bosEhOFntdz1LqjTchdAnxMnoTZRpQj40MO4x5XvLpCGgIY5f4eXsxjo+m8JA8cIJJdjDjMv36xfMXVZfCGHBgE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7337.namprd10.prod.outlook.com (2603:10b6:930:7b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 10:41:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.047; Thu, 9 May 2024
 10:41:15 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/2] xfs: fallocate RT flush unmap range fixes
Date: Thu,  9 May 2024 10:40:55 +0000
Message-Id: <20240509104057.1197846-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0007.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 22b51744-0f3f-4327-1a32-08dc70148d48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?wAkFzp5WbjoUD9t0iOgnCbe7chcvQs/Nfc8cFzMaPdYbrZoPbN05c1eKrcTc?=
 =?us-ascii?Q?6Zi9F317ncseiB/Xm8FSF7hQiN/Ig5jl151UtyOBJr5tq56bGFES4wlKqGgc?=
 =?us-ascii?Q?yp9AdkvSFTwS6oCG/ryaND5on9QBVqF44T1EAqpNYfATfmx/s82ngzJ/ZSW6?=
 =?us-ascii?Q?SLc2txrEevdmUCFa3d/jECX99BWJZX11L1soBep4OVjPO+BBJoWzFPluDNMj?=
 =?us-ascii?Q?piQMLXLGzWlK9UQetB+iAf7IRBanCdk0wkptituJdwlteTn5acc4K3pphYV7?=
 =?us-ascii?Q?FNrQU2wik4SJMZdX3vvCJ8Ey001VyZBkbx3mJHxyE3PeBy/djXi3LFIcfM06?=
 =?us-ascii?Q?eYdok8sCaq6Ttdi00rBouA9ruq9hVM7MXYOijYTJmLwIfgQEw/QO4sfiCrVB?=
 =?us-ascii?Q?N7UkDrmye2xu42i0GJI92+dqRJRw7r8x9n9TrAMmKhaIITUYz2aQUGCEgrH+?=
 =?us-ascii?Q?trrIHnZKfzi2nPAa0R+i2oG6Aayi3S1PpYTWxm84nZ7YyB19663DAqplAD25?=
 =?us-ascii?Q?ESMNPTn9vfcez30ifJHhayKcblywi3iSGMMT/Cz1g+TCr1vmyoSumswis4dZ?=
 =?us-ascii?Q?g659VNuizre9sRMHUjd518PO8CLG9m+stgnwVryllukDM5b8xb8klbrPETww?=
 =?us-ascii?Q?RUjY89yvCBhFyOeTbIMeoWoJChTbEKBrZ0Dqc18IVdQvLQ9YBKU/QiAFHIyB?=
 =?us-ascii?Q?UlELunpeUaZqREyfG4ci8T968GWpOEmE2u24VjkCzmD7zMtu734ZSsEptJyV?=
 =?us-ascii?Q?PsM29tkoMsqzPcyqAmZAyMae4bS0s5xlrLsT6xXuMtpuJge2PkWTQmKqWCDW?=
 =?us-ascii?Q?2tyro5TXwH2CKLVA55RLuPfPR0+7E/+0BYxpFaQy54TJvmvnO5ow94BA71Jv?=
 =?us-ascii?Q?i+1LE4lemxZFdnseYOmZ/dUzZZVtWaW1ZHNqCFXZr4vInIlW0rBbB5mRmjVg?=
 =?us-ascii?Q?uoW74AQOTjdRpQdiP+Bgnzb9Ekt+R88VFAHVyOhVg7oKSNaJkdaVPGIE6vej?=
 =?us-ascii?Q?ejAz0mDE5E8RfPAw1yLB1XNP/1CYOWZ5xgUzdf3qhypDCWGK433hvD5JVRLp?=
 =?us-ascii?Q?k1NgV+9kEBrRaB7HsGe6rAXGD2i2/6vBOEu5nhVgAIKlOxOUsgnzO90OWXMU?=
 =?us-ascii?Q?6805wwfeXJvmhbPAZ870qTAQ+FITMiydWLu3hSmh10Y6VblMsSlA0Q+U3bl8?=
 =?us-ascii?Q?UR5qs0CMe3WLMG+b9UuJmPAyRDk6TPmQmqR3lQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4+fLiy1DCj/Cx+PlKk2vLtmBpaj9DUIeFUhFK9Xn6NyZmnRZ2iqwX0VO01Hl?=
 =?us-ascii?Q?Qq3Yj8VuYu22SIqYyLod8kH050FbSHOpVNL20365Tr75y94lwlrAaBwZV7TS?=
 =?us-ascii?Q?/oF1xNlKFcqTiPm8SpJR3btNU/C2XB9nFVZncoutWxXR+A+QhcrFRLzlSsD+?=
 =?us-ascii?Q?XlPqOz2ExyCkFnInjC7ftotzf8aBrxi2dlaRQOnyVK8YvTcWu4IxA0reK8u4?=
 =?us-ascii?Q?EQOz5NKnGMiOLGaIfBgRCWSP/GrD8/U08SqX62OguS6b3iIL63I/x0TEMkpk?=
 =?us-ascii?Q?yBuMaP0yVQDtKj+lM7QUAcH2Ypl9ie3oR7e4CTd6AW96wpXoISF6EHOv+jsY?=
 =?us-ascii?Q?U7+ZuFPtjebpaUq2+jbdy9V7ofwU7G359FW2wzPtMDW/k13fh2BfH0goRrjR?=
 =?us-ascii?Q?8muNU7w/hAHKhfNgbBb+fm6PAWRgwXet/88oLth5w/zet40t/hz6Iw3ca0SR?=
 =?us-ascii?Q?TMd0yrXJYiQZFAazwujaNyArTSNuRPvWxbB7vSH9XOx8sjMn7PbLzKunJ7Pt?=
 =?us-ascii?Q?RVp27v1JuoJyfk+pUHwFd68hy4dr8YtF+3sHbQIWxIiTgPe22ui9KtylqaMg?=
 =?us-ascii?Q?lgQXgUq/3ZH6rutsWFT98eSdd1PPkjO8Ft+CAl/Ru3QB7/jyQdWcpFxA/z/u?=
 =?us-ascii?Q?4Sm+gSQ8VToDOCSJAqI64tPz0Ic0RHWKLUAt4lBt01OZH9o/sgOtSm+0nbm3?=
 =?us-ascii?Q?wP/q3WZ9hv0EwIlJY+YSXWBIsoU4KLDSVTYowDOmP6nxzy3QlDhrCuQJzf+0?=
 =?us-ascii?Q?HNqm+EwHxt5o4amCOx5VfCsY1Kyu7O0/gmTNjmfWs1b2KUtQaGFSO+GrHOnr?=
 =?us-ascii?Q?d9w1dHBDZisKd5bqIYQ6V7Koh9/XxgGFj/t95Ol10spJa/UYcQP6aYPRanOk?=
 =?us-ascii?Q?Gujea5gS4e0dcJYmVCeV4uVLynUl1hOXE55Q/vodR09+5mUOtbgTiR58Bagw?=
 =?us-ascii?Q?k/zvldL07TpLtDS6JPzHR4aK7uEPquX5BA+eXaHtl3bR2p6Zm+or1VqqoT7a?=
 =?us-ascii?Q?yFP/rEtlBceoq8SeMk3h3Hbvi8we4I5DtdfZVZSvlXQCeBUth1hwvxFaXoF2?=
 =?us-ascii?Q?rCtoPYUfhGFLMaqFJTyjG0RSyLpjmPIPCu+S597S4gds5lDEBoiZZpSZ50+l?=
 =?us-ascii?Q?qFD3HsPEKk5notIYS0UgjA4p2mTOiulhmmAFmdakqfw+kAORScj9OuWyQk8T?=
 =?us-ascii?Q?0IkhUeYPxCdWiUNaEeXpDVRNMIDepiraeMMGZAj3tdGpDaK4lPSwwaq+jCDr?=
 =?us-ascii?Q?BH3wm/8Uq9mlol2bkAyUMU+fC4xV2APiRSAkHXgGsAgehqFrIJe2Xzmmi5jz?=
 =?us-ascii?Q?cx8VxKCnuldsZSF5kNStvnSI7oa0BpdJeg3cYYhhmwBoF3pbjHLQIOY/Bz9R?=
 =?us-ascii?Q?fiM56T3Dx/9sRvlaT5035C4k7tAhtw62kMdldlIMgbOrddWvENcnLK3X7AAs?=
 =?us-ascii?Q?VdzCnmxyEMRiCOHxvEwYrWzkdToFakdaBWku4KQULW+Pu8HYPXHb+OvNRcAR?=
 =?us-ascii?Q?4thX7apU6Shs3y+35aGE8kdfFlsWXBLbAFXEax5KenKxJkLqf8GtRt/GlxlA?=
 =?us-ascii?Q?kjUeGfaP0XtLv/S0h2CMBjyjXJf9HjofCSTHzzq9XRm+sdLt3y5kbU9/OuJj?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NFrczRd7VDU4bPL3YmE+hQV8naqyWzhqyb3F/VzRD3Kk3amNv2Wrhn59gx/hHx4mqsKhJLl/fl8nz9vVZ59+PayLPUh0K9xl0BuQbHBQu7w5Xs/Jpu4UPOBYTLPLvOm6JM7KnpEB2rNXPorUOaxdYHbch2U+c5dQ8FKrbVjWs9SyBwOQXeI8RNaZjt2jMfnIsqJdYJGq5HxDwQZmFBlENpwImbhlwUFO8EpbFiSFBpCZRugahvn606r+NzhkWxTMc9/ItrE8U/S3TuJ+yT3ruRsmXeDRH0cuts2iu0eJudlYIIFGlKZnK8QlIgv6dOdPNX5u3GFZqeFENBnad0MOzUaTOzrECXnWm7j+NeqM0MZsxXD972J0AzH7fO8OnqGJ+9MK2Re2WLD0M20Vp82gzl997uKtINO+aMEPelhbT4Q4ZIXQzkxwsD6xqCQ39HZmqe57UasNEmEtYOpOiIdxps7QK2mC3avC6NkUCyryXNvNQS9MeJtWEKZ6nkOTuB7FUoBqTRp2bwFa83hf1eLAarVpxKZLEZq74pcUIDS8hmyvtJ37GX8KfwtdRF+0FmPXhywUbfVI4jB50RlpmVBWBJo/EcLbTUajlmvMgJ595sA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b51744-0f3f-4327-1a32-08dc70148d48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 10:41:15.3472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z327LqUdfHTQurZNIjjvZZNmRwzbZFo7xemlfq/+cEUTdZW8M8b5lh+HklhkzxVaFZ6aHu7B4HEJjMmUgVIX0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-09_06,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405090069
X-Proofpoint-GUID: Cl11o-GD-pSgoXgbDX2FS-OEuffMug17
X-Proofpoint-ORIG-GUID: Cl11o-GD-pSgoXgbDX2FS-OEuffMug17

As mentioned by Dave Chinner at [0], xfs_flush_unmap_range() and
xfs_prepare_shift() should consider RT extents in the flush unmap range,
and need to be fixed.

I don't want to add such changes to that series, so I am sending
separately.

About the change in xfs_prepare_shift(), that function is only called
from xfs_insert_file_space() and xfs_collapse_file_space(). Those
functions only permit RT extent-aligned calls in xfs_is_falloc_aligned(),
so in practice I don't think that this change would affect
xfs_prepare_shift(). And xfs_prepare_shift() calls
xfs_flush_unmap_range(), which is being fixed up anyway.

[0] https://lore.kernel.org/linux-xfs/ZjGSiOt21g5JCOhf@dread.disaster.area/

Changes since RFC:
- Use roundup() and rounddown() (Darrick)
- Change xfs_prepare_shift() comment (Darrick)
- Add Christoph's RB tags - I think ok, even though code has changed
  since RFC

John Garry (2):
  xfs: Fix xfs_flush_unmap_range() range for RT
  xfs: Fix xfs_prepare_shift() range for RT

 fs/xfs/xfs_bmap_util.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
2.31.1

