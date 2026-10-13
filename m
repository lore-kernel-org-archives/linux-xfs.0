Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94C4AF9D1;
	Tue, 13 Oct 2026 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879387; cv=fail; b=emejPNJSNuE01RLuDHX2eWP9ow1zZUQnsC+b64g7zRz7F2mDArIFzYNVypfePCPr6F56cExkw3DYZ8LnNXITsYsoiUs4++DStj/pix5htMVWJz6KbEbD/qXHDQRdp1S6ettDaxvXl79eQhzD9vqKGaY+qlkx7O/aHF49KOPdA3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879387; c=relaxed/simple;
	bh=99jHL3j2KqJhaOoaT27NbvEhK65eKRAbkLqKKzQeFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=etE2UkwELi06T7R9O7w4cVvMYaWILJldRH3CVJdtCZp6slXcyDCI1Xub5HR8RwZotrc1HSy2YB5GWdI3b3y9eFp2c9Wfi8SWaiQzRJbaMWP7RlnefaX0xbPZnuDdL9jy/pxCxled5EjknMgt/UFws/gHz0I6/ylnDNMuQDi7XNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dRRRUvcJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BueiqAyV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dRRRUvcJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BueiqAyV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4HE1440146;
	Tue, 13 Oct 2026 08:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=; b=
	dRRRUvcJsibEuaIFxGaJCTwydO5TDe6JQRghzpsg1l8WSpFjAzjeZHz3DKCWuajb
	ldokHZkPD3vPgNPxCM45qFWIy1CyAcLtXd/XMjTXSHU9awUeyLECvCT14/TdABes
	4MKH/i1lhhdqN23I5SJyeaqtv+q5ASTHJ+T9/6s1fM1p78kkeJ6Sfx6aLVp46rjw
	F7iAqTWpM9xedSdC6GE+yPlGemtwtCugXmGWpoUlOZpNdiMEeqa8tUp2JxbbKZbj
	I234vALcNM/Jfkd+m4gxDTKklpL05UWUKaxUvxE/lfsmKA/gtOtj6hLVO38hSVex
	iiEdFjxZDOCBsCegQvwBsw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86S6s002156;
	Tue, 13 Oct 2026 08:16:21 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8ysgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gg8ZNu7ZDqfs1WXB6sczLmhD74o+fne3NBeAii3Mgktw5DcBizENlJUTWJWxmRiME521RDWunisfY40PE3xl0ywGZChqNimC7l+udMCJzuGlRS6qW3HwyA5qeZgO8EZpFVKJvKrv/MFnCDF1Ud08Ne9EFqBW3lzOFM1QIntALgm9bADdQ5hoj4l5U2SZz3Q6cUdL4G3+hAKa/ykF+6lPZT77YE2IOnOETB9kvRo4PMLuJlwDJqwNKFFzONdBEull4O2/3JSDBhK4H6wRNAiUSVUYLaDUemmAE4lAirvd2lRZ2m8ifIgZfzHyntdu1UdsbXK466wnkgBK/PS1C1KYJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=;
 b=V+4LRdrLE8O6GhK2kRqPQ3e3Reht8XXph0mzIslQcISV33TYZ5SA45mN3/pA1TRaLXE5qSeQM8Quy9zn/McaNwNtzJpxtgr8r1KjvlyGEA7SWTBhrczAKLDtNrCf/+OJsljMsBMV+mwYuE/TCH3tmvMmf4xB1mvn3uLKwSGEm4jvcB2HD9C2x4mOtsygU5lA4bKuY6XWTY58H8WMybFs6nMvWztlJKDxw4E1cxQ/LG3iVarypuKEhBbfVzs+IeL+3MpK4hpUr6XTrzyN00cxIl9ifR4lXrQlf4zatgfrrKcOf961KApcqJmdjbYlw0QkNm9bNipG1IHftSNIDZnobA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=;
 b=BueiqAyVZwFrAbnloztV6BPgHfcLHHQZR30Hq0Enzk5Zp9USgS8k2HP/dQ0D3fI5gU5gFyGQIMnqW6wDlOYEHLTqSTIcDINDaTidiCd9Bt3uledAp5rS5M8fywA7udFKY0EBWXSoSmA3847R5SdZMbCE2I494NvBqH9IsfHh9sc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:16:18 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:18 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 15/19] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 13:44:59 +0530
Message-ID: <a235b4cd31d8a6980bc8c536ee57589fe23e87fe.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096::28) To
 DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 396516da-c6ab-4efc-ef98-08df2902420f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	j2SlN0vnkS3JVLTZXyX/rGf509/u/1wrKdaVtd1ZY5aIN6kwtXY6EZOhTdSETdW21G+ypJELp4zxbsuqIZ1rcUHY524Vnlt6gDlfC25kKDMczBEyrmpb2f18olA5bzoducNf1rUXmxW34sFSqW/ARlclxK19+nWb8Sof/a6yaUU+cQVi8d3x3dJM+k6As6eDGTi/g72zQp9Ad9j2ny4w97jvAI+PZwmKIcATbaOknkL11/M8RBNAb6ZIFKp5ZgqJwWuHN7JYl8FrwkcHdNVZjV1em/w9odHdVstDFiU06w0+bEAm5LKnQTIog2F1EQwFHGkSnudsu/lqoFgX2RmdNyEG4r+TxETExa3bAAUPmfv+LwEXwcMqyo0s5yHmYr9pVHsbT41UBGnTpw/shv6iy5gLbYx68Gyh5wUtAigDP1F2BnvdehCswdT5eaQ7n06BF0SnG4kzdUbpsf1g3apVbZdDo0hGLuUtBkw6QBQFV6+BM7PEK6ft/P9Nx7RkDTO6qWucN/c4S5ryO/+44yu5l6wdQ2+853iSEkTRWpyloVJPFA8yet84bt6PdaO6iBPeBEdhukTnm/qXO4QHYnnN9kncEqQ5LXYoV4M5vExsr1d318C8QFzgFhKUNxglGiCkvl5DKBFQgiNzxNQV2jhKE4iHgfAfT7aLkw6s3ZYcI34=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?idw9gE33wQ4lcJ5hsSLpHjrg6GullDM6+D/zvwGUdA3jpJhnUH1SCRU6jxoE?=
 =?us-ascii?Q?uYx55kyVGXyMg2zgEmlgSyXNnVRzaQv2Bcklk5U7UdafQfJbNIhUrbFgVU8N?=
 =?us-ascii?Q?wkJrbqjdwgwnFvOi1hnAlrKqyLyKGkz5t0iaBk8C0nxNH5696BEgFwkeSfb0?=
 =?us-ascii?Q?27PJwP/qj833AWZER5PX7YBKTKFglX5tB5u3UFT59CC81BF0oxRjDbSbFgYT?=
 =?us-ascii?Q?xMIqsTqx7dLrx7FXTNb8PctpeGZS39INIAIpJcXUilZl0X8lWWXCnmAjjsTk?=
 =?us-ascii?Q?wxbo+5eS41uNGgA2euR9zcBpi6Oj+e0+TI9EbqjqpN6Vsb5G/2r8MUKfLbg+?=
 =?us-ascii?Q?Lm7JDDqtuUXSkdij1Z2ec000ky9kSl4VgNpOfZcLPVDFhy4J5JfU4NqOnl3J?=
 =?us-ascii?Q?JNMk+AGV2xu0v3zehBpxNu5xTZ60Q8S5TdTQTVaFl6ioQMUqUig1juD8VLW+?=
 =?us-ascii?Q?Z72sPGnb9xZ28Mth6O0i1PuxSPsMgKf4rX0Am5d1JmJQhn3dq5Xoipo98tKj?=
 =?us-ascii?Q?IUv+7IO10axeqysHiEUFRYhldufM0arRJwv9gZXuKklUrAes7lHs10HGDl8Q?=
 =?us-ascii?Q?b+xVg9bpxsFvRgwD0QWo4NPo1aPaAG+ymDtCiz81bttu16/4aH1zc8AMFl/F?=
 =?us-ascii?Q?CghVpTXPFwpa4EAo+e/IUs7CjeemUs+pYxTEOTCfFEbp3um6eLe0Zi3f4u5h?=
 =?us-ascii?Q?V8JQAhE8x/47kqLB5Vpa0EXXEyrvrh7jyCrFML5fteSlrS0k3+Y0Dt90c0O0?=
 =?us-ascii?Q?HPxd2yhH1x7ER4tJgy1jWjK1crF/jnFgSnaNmMU5Dmfnho90hipqOqCMGFE+?=
 =?us-ascii?Q?iJVk4TsVysfw2FT1iEGsLlx/TGE8sBHtlM6cg6Fxm0/iovTdoLbi6pXM348R?=
 =?us-ascii?Q?X8bThAaRK15ggqmS1z6Es2U0gsgFNJ9FMv6OBKum55JLUyXSc5wLvEO8n+L2?=
 =?us-ascii?Q?Dfj0e9Eun3HcN1QaHJf/jnvOrM7GgArEf8eUGkPpwu2mWPpLl2Y5Tf4oFNnH?=
 =?us-ascii?Q?ugA2bk+OMQEF6vh9TGmiDhJ498COU2Zgcw+Bv2Rdy13NoOovnazCK0sn22iX?=
 =?us-ascii?Q?PY8FPYR8QvYutdDYKRJUC3fZfQWkWrhP6WT5FdX3IDe7tLwKJOblJqMdiGbS?=
 =?us-ascii?Q?EMTkH6moCAuQmoOry1NJbWawO1jyhsxn4PCZ80VtdEE5BjDShTae2beUFxwk?=
 =?us-ascii?Q?1cRWg+bfBrcVX9KhX8fvvND2Y3oSEAkKYoeJ3FTNFiAp4IqE6U35DyxXsd8H?=
 =?us-ascii?Q?tCuOITJNK4Mwk4MUMJVwze+1mUQO3IJ9I6JaomwLGCnarvTLY69AXU3mmvTs?=
 =?us-ascii?Q?63gVPobkJvETSF0UFySGpyQsF242ns01AbQq1OTCJyreD34K8ynpyJpjnoXy?=
 =?us-ascii?Q?tWV9fY6XTTGmojKvcQUjqMMLA+qx3NN0k9U1IqwTZP0gqzIWIxaXcaXLuORx?=
 =?us-ascii?Q?WQMFM5kZgNFMkbb1o1FojRXyh4AhIdrI7dEhjfiChF3jm7WUEYbHsvnatdGM?=
 =?us-ascii?Q?nTXcXuBrzcOr63DrxXLiQ2sXOTLjaugys/Uk4eqX85OedHM3mA75V7AssY79?=
 =?us-ascii?Q?uJtflO1814H3FGkbdR/Dm/2L4Cxdb8CJnmZr19vqJ9KPFADDpHB4PWoQuvBQ?=
 =?us-ascii?Q?OYIxJBGG1XsBYKn80MaQN1tvLwDKxS3VMZcIBFJPttUXOBRoeyVyK1CbKwxL?=
 =?us-ascii?Q?b2ltDeawRUwG9r5wVYUjeOyfo2YbTlp3o6Z8hT0Znjze6durB7yAT1yOZDTq?=
 =?us-ascii?Q?ZmYR6oG3IoAYRhg29shyAIfzIKkcoC15KaW0Yt0e4dBMdxVSYvnQlSdxm4Yt?=
X-MS-Exchange-AntiSpam-MessageData-1: ce+hrEooj9KnN+8wXTTAuWAv+lseL+UAiQI=
X-Exchange-RoutingPolicyChecked:
	Ew6vGcBGZulh9Hz7/k+w/8tIoexwkSnrU1vmcGcgUSE7/xco2utStswvVhuBxyrxziMMgy+QpydfICCuA5kV8hKRghqGytymeSg9YiJVXb8R7fQX0EN0FpJG/L1B42/WVIUImySG9Geg1QbNurqbfVMsPnKC1W0BhxZrSgUCaeaTEsRnggwqhn/eD5aFXQdR2a07sc+xWTUBol0ECMk8+9KPuNXqNpHfy9GNYczpEo2mPK0gGFgdseCjnBZN675SVDTUZKAGOiX7W0M6LW4YnPCbN+mvDmFGiAeEkZlv0eWa+C3ilsHKahdAVWV0f1Vx8Lv8qwfNKSYVVOVDlWhg4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f4vIltuHUq7X3bgVFOBf91v5M5PsG1GwxtCnVrdoLm9SlScPzJjJybdqH3BVVTLooWYTTJp2UmJY5xYKhGPYk3QBKeNa8M8tzRc6IgV+H4DCAoj3w/555HHWVyH4zbrpynMlJshL3ayzBZCtzd81Vio9nlYEey5UND6Fs48bgD5rAOw6F+4+KVRKSMp+RKJwJK716KMDR7X4cJvHk1KrG002ZX1GUr01R5+GmmEuqMdFD340MplnsEMDHutMjvq6RtV6u3WSjpyxZAy2f7s66V4V8+yBCKnx6BLbpkXJLjRx4Ww7R1/HBNHs+qkXJ1Ti+sYYuqMUm/J7IXDX7133CqMBz2UuPc7Di0SoVPKeEJ2liyTeJb32uBIb3Xupuz/tSjuemE7lZWAPLbMv8zFRYrkUZmPmQqbQv8ibXXSVKJrvONdRcGuTDA28bmuGfQbUPlPBilsMgnJsKVjOcdsR9So5hAd3k0NQTbLpu+ZPPsDqvPDSZycUPnY+W34/txOCDzBJy0lzPnOjIBL6Ff5bxqjTmSk3RH23qaUufFumqVS4cfJKSKi/Fcm9y84dAY13cG/K2YceSB7xB5GzznJMufhsAfk8ZSMENQerhEIdrcY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396516da-c6ab-4efc-ef98-08df2902420f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:18.7911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0fRr3FYd8LPb9I4c/Up83uCwMemmXQhoKjgUqed8McjjMegvpracKiNRhYGgEsvq9Y/wz444m4J/fgjDCwU+w4pmanqePGNDHs9EHoaV3pE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8d6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX8eWrUBo24c/5
 paRbAYRAITZ1usADVXyqVYXI+2iaGkKJbPEaM/HvBuEKoPBu3sbGUvYmxT7eQySrYjgC5G/UyQe
 pAjtZ0wPz/4FMedvSgZDlVYuDPGsJ+qVoGKH//TdPVAwuGJAzpft5uzvOZx3/7UktA2bdfq1K8k
 Gx3o3xiK23bxZP5J/kbIdoJQTHdAigKjbDir+NtkgKiwHHqJCQcArSyGm+xoz3lz2DZPaahvRPQ
 tJ6p0yVNAVFWpYfg24RAS4/WL6R4FcbZtIcnNJ484yLGArSCUjm0LkS7esTkr0mmpS4AFQEmm3e
 Zt/+nqs78OZGsz4fLkOmK54j8OBGdpA2eb8I0n+W3+bdfR037xYKMsdNez8x2iYr+Wha8f05r4W
 ER5aNyp/hR58LP/g1Vnv9iXqbH8BANYdlSyueZ6NNid7P/qdH7TFV0UOGJ9vFcQkld9K4phXJ2+
 9MKMPBuBKgKvG2qhhvQ==
X-Proofpoint-ORIG-GUID: lBZEin73DSTMB46RCiIOZluDI2Nt9kM2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX11/qvQBmd/ct
 9FsPCixBkeWdkp8GLBRFTmpHDtPVyL8kqx0Zp/cP/bN4ibsepUQ4Gswt58dmyT4OeY0itkNjB5V
 YtwkwTXDuWzGqNCg7zq1w1aJbMCq9e1pqh7CafsoIg8L4CGejBV+
X-Proofpoint-GUID: lBZEin73DSTMB46RCiIOZluDI2Nt9kM2

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)

5.10: Add header.

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d973eca1a881..f52737051b49 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1040,7 +1040,15 @@ xfs_reclaim_inode(
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5c04c61964ce..a36843bfb6ef 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -33,6 +33,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 
@@ -2553,7 +2554,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

