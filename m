Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED64AC176;
	Tue, 13 Oct 2026 09:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884462; cv=fail; b=iGpobJZaL2Z7tvdcAzAlVodxD9YoJaXRRQfHoyuSQtWtHqo0N8NDTL2cDY7SJA6D9D0ngYi6ZOtJlKCEwdRur+tFE1A0LlZqjSMQ0sadENUp6SICgSjjgYsgiZv8AWQHWWSg+OQFzWA6Mw/fpYDnhqwsYV3eTkaZCvBEmmpCDPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884462; c=relaxed/simple;
	bh=emW44mA64NMaqCYDzQ5QAos4YIRnffdly9YBdTsf2zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QVAl+LbI1D33SlyFzAp+qCqcmfBoHqO+ackolD7t6u4RPfCBdiMSQq2Cv3ZUmXM3UuRJpmbVPVtHVVwYKnkvtjktiyHfA/ulXyH51WwIafodbVWte6rpuPrjCfbFVWQBicY4S+FVyd2OzqESWpik/DSjt15ToE9GA9BzgeB473Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TMB6RJ0Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yn9d5Vfd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TMB6RJ0Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yn9d5Vfd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Ej1Q3035636;
	Tue, 13 Oct 2026 09:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=; b=
	TMB6RJ0Zbw5z5e9FnMRYc46IX41b8m8/SctqPGDa+9GvgmM2AATe+ariEm/ZXjFw
	wgiOOFcxxKlAodqOvGmOm5gwWsI0ynaz/FiHV/P9pFqzwjZmq7BaiuQKR/x0mUnP
	yF1m5EG0SKp1OSwZ/N0CSW7RXGGlh4Jv8QF9Y8CVp2gaCpU9ne57bt8FtNPGWYpg
	KwqPb7QX1XaM9N0/Uw7qrdV8u0DjwEAjyPk8PeZjzIrfwm4fvDhdTD6IyYDZxACV
	HUYdf/MIsNy//DWz4p6CueKfEpsehXv9t7m6WVsBgTFQFca1dNPRtm17LmpEZZWK
	HMc6fhlIHJ88hkBy7I8gbw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aTmU005405;
	Tue, 13 Oct 2026 09:40:54 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2en6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EMhjdqOi0k2HIxg9HbhCoEcS5NTOKDtknIHmkl5CiVmqEnz+LKqtE22f+He5kkkLoTcbLbCZzAFoz87knlwMbMAb5ClHOyYorSH3NOZfLWZeA65kMLbqhSsmqo/R05nFlqiQYv4z2BCzUBXNuEIt+/wBgG29yLoKS5fiFFOzWu/Ko6rVPYm7AB4iyyNmSwcf/k3DAZqO1OIdFwD4r1GpMS9gKk48eOiwg5vuXf2s4dqSrbMNN7IW3EsKsXItU/+TXjAc6/T7PtvYglv6agJSlquwszIQ3bkLzLbLE86c2HKFl8V1rFbEHRh0fZmuJ5pqsdZYvy/2nO1NE9jgCzIe8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=;
 b=iCUV9je6sgrLL6ouEaUU86xvmnE2rhJgHycyYCdXUH+HVpFhFNAaY2ZHoN9tKioyht/HAYQsPmjBYet3gzdkrsNLuQgVrlCxiW+G8ltN0kOmP7Jzd4YFjtNPHjbzzIMB60uP8ZBa77U07L5B6waY+Af/hwstaaHc3OahNR3JKHPZ6xw0Lo/3bqDiVgpMxh0QRBi2gG4Ojg04Y+xFsSkLFRIuIdgVh4EntC7MnR5bH/YuxLyALfZsiptRf7892mBJ34gXwgO4H7BVSDNwMd1msWnikh8xkxJVBxTTNi8q7yrh1aFdo5NiUHKm4NoPtB9d+31eAdb5zVtS2KQ786Oebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFftGCHDvDnERBZoHEXtjsYPNy8xUirCR0ggbbh47y8=;
 b=yn9d5VfdxBXZe4iJR7QkTfY83KqenWR1l47P+LghRp/S5Owyw9kPJHXBvWjBtjU52OZEyVf6L7IfmqL6+G8D6EMty3C2jTnFZ2/tWhc+iMkwUk9mSVzGx5zKKePQkrCNb96lG2qgTIuB6t4+hW1fy0ej+GGj9z+76v5ObV4XzHI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:51 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:51 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 11/19] xfs: remove xfs_buf_t typedef
Date: Tue, 13 Oct 2026 15:09:40 +0530
Message-ID: <0ce792de233a915ba9154d8b67ea9c29ac55da62.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN3PR01CA0100.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::22) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: b6876959-f987-4ff5-c64f-08df290e116f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|260925021911599003|260925021311599003|260925022911599003|10067099003|261009223027099003|3023799007|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	IejtOsY/Sdk3wcrVfXXhxSJkOfElT8NaTbV/SClVp6AhsLRV3OpX7FktTKx5bfH8hLcBOd1vB2bqIRcUuEABD5Hdqhbf4yI86Igu+RFvrZbpVqPwcgwI5X9/65mPZoqG6v0T+kLL6vwbj9Wt02BUAZKhnbC49U+Cibqhhg3+0CLtA9tcI4ApKmYcOHN3NWR4Lrs8/1DVcFQshBkOy0tKnfxtpIb3NaONSyTEN5pTRd3RHAu4YIRDDdIJFfIT62pmkm+rFvF18uMYiffk4LyuC5f5OmbXMwet/VBeTKRygQme+VRYIlheXjjaw01XIjtjqyYPFDOL17JGCm6zKtXDbycnMni1+bPJXqOxVpAy8WeK0IZoxRsGPUW9B8JSAdQ2ll3r6/7+0T4A+mwswrMzcCRre/Oe8dZ0Pyf4CZCeWFtQcZf2KfVVdDSabYGHwGTjHyWcSsvcMP7sn079mrcY/vrt7cyoVawfPs7mRAcajBD/dEHBvfLtSekhTYNmk1hVEW4dS5pxWBOObmpd2J/LTzPDKujzBuCgOd5HQTpnM+Aseb6dLbLvlP5f+La+7EfikcGBa58mqRepCqk5myIp4uj1Z67gbUW9m8XUQHVU/8RvypLy0YD5PIslicHdnhg0NVGsQS9SJ7ggbVsQV5T+ZIjRi4W+bmuOKi3gELEazEo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(260925021911599003)(260925021311599003)(260925022911599003)(10067099003)(261009223027099003)(3023799007)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q1YEuoelIBOOP2Fq1GWwL579u5OvxlbZbMNRf5FHK57ThVbZB9JGvsCF1jHp?=
 =?us-ascii?Q?AJSXH1SIIfVNOeEc6l5GOi0sbd88yDQQ/T1LABgTYEjhW89AAvTmmnfqOHu/?=
 =?us-ascii?Q?5W+gmMjsdUGbsoB4+1cFiqc2IuMj4NLu738oddWOg6Ndg7ZBXkDgst00KjpP?=
 =?us-ascii?Q?RPy9Tr8BllUt2e8GFp9GpOZLDtiLC8GIX/IcuRFWBla58OzQRHU35WyPlDbh?=
 =?us-ascii?Q?GhwFvuQmt9wdqBC5REmH6wvJmL8hqDoIYtdUT7KAuTa8bY1lPEUaHctFIk50?=
 =?us-ascii?Q?0Gm+PnE3tYmj6gtxpTX0zhL2YxHrA/Mh+nEHAexLZHJ4T0p9Buwch009LjBI?=
 =?us-ascii?Q?7Kc0K5fonTPjiyZD4mmuGy3yVjR2Z2MOpuxczURx1XdTWcHciebanIleZBeb?=
 =?us-ascii?Q?BihYJl/sNpnuGdaKgIK8rDOs0csKp07MjGgBLKr96uZeNWDYS/8C9BJW3QG3?=
 =?us-ascii?Q?OQsa7eZoX+g8gs1w1xdFRH6a/j8+08v4s4ydi91TATvPLtZSGjTtHoDZ9JvI?=
 =?us-ascii?Q?ISqta8Y02Az61ruounz3q3k6u2dhjlkHeXxLv6/iKW4/4YS8vrrPW/y2ne4y?=
 =?us-ascii?Q?IY5UksDcwCB0oiEJ4aoKQPih7/FqXC45F3yetDdtdHrahizciElcNS2QdBC1?=
 =?us-ascii?Q?nqjGvXVaVcugGx41n1DuIVe4gY1k+r3j8qdbhWf56o9vkzJQuYXFalTBrOKq?=
 =?us-ascii?Q?Q8nVZkGxo6g7vJyStm6xkZvAc/mhl0sGVU+iWYsURRmVdHvSzYlcBiO0i4x0?=
 =?us-ascii?Q?jL8dQ1AANMYR+9Q9RJEhEt2pFFosrtvKtApBPahbw5yQPz0ltcq5imywiduW?=
 =?us-ascii?Q?MnpYBniPKeTGlU0brHxdf1bLurtthd1TfmOwBqE4aDEMuOPi680AnXa/1LZM?=
 =?us-ascii?Q?fRFWgE9ZqvSQ6FmmsvnK/huMY4l/8OOAdgyHKCjptuPs/VRD8oZXMpurMUSy?=
 =?us-ascii?Q?BPkfIkjv5tAXcmodUA27rbIRZ0f0qIFRNuWZqvUHivd9jdGil28h8PU3h74/?=
 =?us-ascii?Q?fIbwHVDZjtiE8IKRn9NwSqu41cMRr/WJ+xNj+RplUv3aAEOhmhale7UjXx2m?=
 =?us-ascii?Q?l4zRqeUOj++oyMrDNQl7SDzLzqgB9zjJjI+yMvztmw86tgv/NMvv828As9lZ?=
 =?us-ascii?Q?LFNuuFF4CIgGi+VGwrRial233kcW0iHZ5tGUzvYoPRloW4naBJudupZjvxLe?=
 =?us-ascii?Q?ST1zkESbcSU8umZagNSq7REvNKDcBvYOKnVxH4UBxnPQdtmPe/SFJjg++5qY?=
 =?us-ascii?Q?uXi++cA8r4Bj9NyvWXwSfULRp/8zcMYR5+JNM0vN0msLfEFgw2OauigG68/n?=
 =?us-ascii?Q?d2z4Kg7IzQ/PYwJP7pICH9CIVuFxbt9jGz4D0Opho61g7GV94S3oRBnus7I3?=
 =?us-ascii?Q?3TxSuYI8TyFl/sD4nb/s9KbVWzBEfmTMkC9dW4PHGhoki88OXoaJFTvpblY+?=
 =?us-ascii?Q?C9ecqHeHZZo0+62QUX8f6RcjYeVwg7fKwM8zR9uTa3saMm2EKhT5yLBbvUaf?=
 =?us-ascii?Q?VNv8byb7McB2nuay5nqhpcxo2RtQeIGSdwMqFExNWYFdstNI/Qq18wzZlkTJ?=
 =?us-ascii?Q?3LcUczhFOREHmYPORvlLXwjtTlEe3H1e+oc4pItcMq/wWJEx/+Xkv3qcKt4t?=
 =?us-ascii?Q?3DHKAtgBPR9/j18hB/yMvtTd++gInTXludxJyVoz2TV+jjI8MP6ELHSyLdTo?=
 =?us-ascii?Q?Gw0GkuNLXgH+cenh8X2vFNnbAiYu+9BZH1i7sgmpIsYcYjISI4a9D6yMLv19?=
 =?us-ascii?Q?U0zhVlcpT/RDzLsl0muy2t2ovRYXqkpmVPZCBdusPugli9+vzCpxxspy3muc?=
X-MS-Exchange-AntiSpam-MessageData-1: +2bYJ7P8MkeIsUHNbtlJhZOZnUNBpGe79kg=
X-Exchange-RoutingPolicyChecked:
	VV94bptSpVtk1rOZJ6PRILPUAGWupUho4Bbr4VSbr3LWXIV4gXbio1aHjxH3coEK/zkQFAyMVkvsWoq0/sL8BXXUsSneDcHKHQxQroBLzy0wpXQDlryxiPvQPXbTiBpMyhbMM/JZiz23nyWiR8BJkYs0kkCTVnI6qg4L2Wca33u4yjbxsnJIF2edZQgITrAZxrP4uaUDbKDytNmQv/XV4h8DlSHzuF6M76D6A7pp64aLRItjfLKQa4ve+CaO3GokQvH+nX8nfo2Cav62Qw26bdWhTGrbAS3MhsMzBO+0OhmBy7N4cgQGPmqYfo1Fp9lcuuzAlqYY5b5P+plEg8baCA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5HF3UZfievJ3OmYAud7R1H9khqdTpVbYrWsKHdAoa3LSAbtl7skIHqCa+3L1kHoO81zfyzbQznjoXyuOd9dehT6LDlmrFJ/jXBHC3Y3fVLQR6jx9yH1djPMIdA5J136KDGd5WshM4Bdz+lyVIxrX5aKSe44ZE+MG3phBqMjdGU5CDyIJ0ajjv/ZovinX1Hhoc4vWI4ZbyIvYLjjONRjo0UKQcRvBtoSPVBk/+JEDECQfMPGOlW/B2kHZhfzVwiIU7kBzf+Kj0k10fcDoJ3CW4dG0vHdUVGlzYho9jppZWDp2QLYh+EyTuyeDnhBmql+bsh08aZBzBDrI/pe6oHxvVXM29Jsl4NVi2vDRmvFvlFe7tm+tmlKssgW5ayb0aEgsu/jSIMPBTSNz4hP99jAVUIRtsLtyLGbXmQmZOJ8BImKo2WTKNoM/q/zuKtdYeIQ8UyDLCDTEBLPJP4CNitELWB2EtK3Nl2/KSGtANY0Zrtjhdk97AqNaIDEyVYACD/v3i0xva0wA3iQIhp83pt9N+iw2bdyBkYSEvJDIwkcCNELYIkVB8b5sSX5/xCZmIme3ScgT5mMloCvIjbzWViAulBOBZvz6rCWdm8rnYoDaNBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6876959-f987-4ff5-c64f-08df290e116f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:51.2133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2EkMrJ9HK8n3LKCBuVSbXdvH15KOr14sTdrXJ8BdW9yy9qraCZkNIEPcGGLzMft6yhU7Xenw3TlDkbcQ8eyX/rIsFsvGKTWmKluHDtN+euw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXydafR10RmHe7
 LXseb06bKyff3Ap9Ui9ObvQtp0Hl5JiOyKz072FZp9guGN9r+cAG7VpYk71yoaO7wN7OIYyaekO
 LUG+MqI5TYFk43KeBH7mjjYaorwwBV0OWYP4k6Lg+Rd34XCF+dF/Vg4MZIjCiYS7IYZB16sW6p3
 CxRAzTYHMG+e9PZx4nmfaSro/SkpNinJ0dE4qWgbROB5IqnUD0OtwhU+l/32d3YqLJ1L8VBikJf
 iW/7t257+UqvFKosfnIKcEjkq8B5A1WFE9/RAN2mM4M0DUSbzA734jAu1P8qS+wO9Os34MiopR5
 EGLWwIgUJo50OTwtp1sXLiOtAijC4pGFQf/46aXqE96S5PMIbXfk6zc1E0Xkx2kD1JEc1JoOJ/x
 uEiCmbVuzomKokxa06qMGTbBMfzW5hSPUm8u9Axd9JMFqBtclBBVxPfF0GczyTiXiqJkzryPRcL
 Vx9LtcYrcLb+sWGPILA==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfca6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=rWiefVkh0gDNh2EwC_cA:9
X-Proofpoint-ORIG-GUID: pV7Qzm7c6dGHRV5XRv2ojL4iRkm1fkN9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX8NMqIss+Rxnq
 mTUNrzUfjC3Lu0dMpUsEm/TfSKxtMccF3ZqMQGegMmECULkdh91EzOUHGCYd8WI5fdtLoQTeSOP
 ZNzU+UTE/7Pfp5AMMDJyyr65h0p8q6Xf35dqbKaNZ9Z/Zku8YVeK
X-Proofpoint-GUID: pV7Qzm7c6dGHRV5XRv2ojL4iRkm1fkN9

From: Dave Chinner <dchinner@redhat.com>

Prepare for kernel xfs_buf  alignment by getting rid of the
xfs_buf_t typedef from userspace.

[darrick: This patch is a port of a userspace patch removing the
xfs_buf_t typedef in preparation to make the userspace xfs_buf code
behave more like its kernel counterpart.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
(cherry picked from commit e82226138b20d4f638426413e83c6b5db532c6a2)
Stable-dep-of: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")

5.10:

2 extra conversions in fs/xfs/xfs_inode.c due to missing:
	1abcf261016e ("xfs: move on-disk inode allocation out of xfs_ialloc()")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    | 16 ++++++++--------
 fs/xfs/libxfs/xfs_bmap.c     |  6 +++---
 fs/xfs/libxfs/xfs_btree.c    | 10 +++++-----
 fs/xfs/libxfs/xfs_ialloc.c   |  4 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c | 22 +++++++++++-----------
 fs/xfs/xfs_buf.c             | 24 ++++++++++++------------
 fs/xfs/xfs_buf.h             | 14 +++++++-------
 fs/xfs/xfs_buf_item.c        |  4 ++--
 fs/xfs/xfs_fsops.c           |  2 +-
 fs/xfs/xfs_inode.c           |  4 ++--
 fs/xfs/xfs_log_recover.c     |  8 ++++----
 fs/xfs/xfs_rtalloc.c         | 20 ++++++++++----------
 fs/xfs/xfs_rtalloc.h         |  4 ++--
 fs/xfs/xfs_symlink.c         |  4 ++--
 fs/xfs/xfs_trans.c           |  2 +-
 fs/xfs/xfs_trans_buf.c       | 16 ++++++++--------
 16 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 15640015be9d..7cb9f064ac64 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -690,9 +690,9 @@ xfs_alloc_read_agfl(
 	xfs_mount_t	*mp,		/* mount point structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno,		/* allocation group number */
-	xfs_buf_t	**bpp)		/* buffer for the ag free block array */
+	struct xfs_buf	**bpp)		/* buffer for the ag free block array */
 {
-	xfs_buf_t	*bp;		/* return value */
+	struct xfs_buf	*bp;		/* return value */
 	int		error;
 
 	ASSERT(agno != NULLAGNUMBER);
@@ -2647,12 +2647,12 @@ xfs_alloc_fix_freelist(
 int				/* error */
 xfs_alloc_get_freelist(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
+	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
 	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
 	int		btreeblk) /* destination is a AGF btree */
 {
 	struct xfs_agf	*agf = agbp->b_addr;
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
+	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
 	__be32		*agfl_bno;
 	int		error;
@@ -2711,7 +2711,7 @@ xfs_alloc_get_freelist(
 void
 xfs_alloc_log_agf(
 	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*bp,	/* buffer for a.g. freelist header */
+	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
 {
 	int	first;		/* first byte offset */
@@ -2757,7 +2757,7 @@ xfs_alloc_pagf_init(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	int			flags)	/* XFS_ALLOC_FLAGS_... */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_alloc_read_agf(mp, tp, agno, flags, &bp);
@@ -2772,8 +2772,8 @@ xfs_alloc_pagf_init(
 int					/* error */
 xfs_alloc_put_freelist(
 	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
-	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
+	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
+	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
 	xfs_agblock_t		bno,	/* block being freed */
 	int			btreeblk) /* block came from a AGF btree */
 {
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index de9c27ef68d8..5483572512ed 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -321,7 +321,7 @@ xfs_bmap_check_leaf_extents(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_buf_t		*bp;	/* buffer for "block" */
+	struct xfs_buf		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
 	int			level;	/* btree level, for checking */
@@ -592,7 +592,7 @@ xfs_bmap_btree_to_extents(
 	struct xfs_btree_block	*rblock = ifp->if_broot;
 	struct xfs_btree_block	*cblock;/* child btree block */
 	xfs_fsblock_t		cbno;	/* child block number */
-	xfs_buf_t		*cbp;	/* child block's buffer */
+	struct xfs_buf		*cbp;	/* child block's buffer */
 	int			error;	/* error return value */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_owner_info	oinfo;
@@ -830,7 +830,7 @@ xfs_bmap_local_to_extents(
 	int		flags;		/* logging flags returned */
 	struct xfs_ifork *ifp;		/* inode fork pointer */
 	xfs_alloc_arg_t	args;		/* allocation arguments */
-	xfs_buf_t	*bp;		/* buffer for extent block */
+	struct xfs_buf	*bp;		/* buffer for extent block */
 	struct xfs_bmbt_irec rec;
 	struct xfs_iext_cursor icur;
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 0926363179a7..aaa59daa77d0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -394,7 +394,7 @@ xfs_btree_dup_cursor(
 	xfs_btree_cur_t	*cur,		/* input cursor */
 	xfs_btree_cur_t	**ncur)		/* output cursor */
 {
-	xfs_buf_t	*bp;		/* btree block's buffer pointer */
+	struct xfs_buf	*bp;		/* btree block's buffer pointer */
 	int		error;		/* error return value */
 	int		i;		/* level number of btree block */
 	xfs_mount_t	*mp;		/* mount structure for filesystem */
@@ -698,7 +698,7 @@ xfs_btree_firstrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -728,7 +728,7 @@ xfs_btree_lastrec(
 	int			level)	/* level to change */
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
 
 	/*
 	 * Get the block pointer for this level.
@@ -990,7 +990,7 @@ STATIC void
 xfs_btree_setbuf(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
 	int			lev,	/* level in btree */
-	xfs_buf_t		*bp)	/* new buffer to set */
+	struct xfs_buf		*bp)	/* new buffer to set */
 {
 	struct xfs_btree_block	*b;	/* btree block */
 
@@ -1633,7 +1633,7 @@ xfs_btree_decrement(
 	int			*stat)		/* success/failure */
 {
 	struct xfs_btree_block	*block;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;		/* error return value */
 	int			lev;
 	union xfs_btree_ptr	ptr;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7e8ba9698aba..8fcb5c6810e9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2454,7 +2454,7 @@ xfs_imap(
 void
 xfs_ialloc_log_agi(
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_buf_t	*bp,		/* allocation group header buffer */
+	struct xfs_buf	*bp,		/* allocation group header buffer */
 	int		fields)		/* bitmask of fields to log */
 {
 	int			first;		/* first byte number */
@@ -2675,7 +2675,7 @@ xfs_ialloc_pagi_init(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_agnumber_t	agno)		/* allocation group number */
 {
-	xfs_buf_t	*bp = NULL;
+	struct xfs_buf	*bp = NULL;
 	int		error;
 
 	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 6c1aba16113c..fe3a49575ff3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -56,9 +56,9 @@ xfs_rtbuf_get(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
-	xfs_buf_t	**bpp)		/* output: buffer for the block */
+	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
-	xfs_buf_t	*bp;		/* block buffer, result */
+	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
@@ -101,7 +101,7 @@ xfs_rtfind_back(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	firstbit;	/* first useful bit in the word */
@@ -276,7 +276,7 @@ xfs_rtfind_forw(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -447,11 +447,11 @@ xfs_rtmodify_summary_int(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	xfs_buf_t	*bp;		/* buffer for the summary block */
+	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fsblock_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
@@ -517,7 +517,7 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
@@ -539,7 +539,7 @@ xfs_rtmodify_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
@@ -690,7 +690,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
@@ -773,7 +773,7 @@ xfs_rtcheck_range(
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
 	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
+	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtblock_t	i;		/* current bit number rel. to start */
@@ -969,7 +969,7 @@ xfs_rtfree_extent(
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
 
 	mp = tp->t_mountp;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 118819030dbb..78f6f5bce3e0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -278,7 +278,7 @@ _xfs_buf_alloc(
  */
 STATIC int
 _xfs_buf_get_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			page_count)
 {
 	/* Make sure that we have a page list */
@@ -302,7 +302,7 @@ _xfs_buf_get_pages(
  */
 STATIC void
 _xfs_buf_free_pages(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	if (bp->b_pages != bp->b_page_array) {
 		kmem_free(bp->b_pages);
@@ -319,7 +319,7 @@ _xfs_buf_free_pages(
  */
 static void
 xfs_buf_free(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_free(bp, _RET_IP_);
 
@@ -352,7 +352,7 @@ xfs_buf_free(
  */
 STATIC int
 xfs_buf_allocate_memory(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	size_t			size;
@@ -463,7 +463,7 @@ xfs_buf_allocate_memory(
  */
 STATIC int
 _xfs_buf_map_pages(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			flags)
 {
 	ASSERT(bp->b_flags & _XBF_PAGES);
@@ -590,7 +590,7 @@ xfs_buf_find(
 	struct xfs_buf		**found_bp)
 {
 	struct xfs_perag	*pag;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	xfs_daddr_t		eofs;
 	int			i;
@@ -762,7 +762,7 @@ xfs_buf_get_map(
 
 int
 _xfs_buf_read(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	xfs_buf_flags_t		flags)
 {
 	ASSERT(!(flags & XBF_WRITE));
@@ -1005,7 +1005,7 @@ xfs_buf_get_uncached(
  */
 void
 xfs_buf_hold(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_hold(bp, _RET_IP_);
 	atomic_inc(&bp->b_hold);
@@ -1017,7 +1017,7 @@ xfs_buf_hold(
  */
 void
 xfs_buf_rele(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
 	bool			release;
@@ -1161,7 +1161,7 @@ xfs_buf_unlock(
 
 STATIC void
 xfs_buf_wait_unpin(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	DECLARE_WAITQUEUE	(wait, current);
 
@@ -1373,7 +1373,7 @@ xfs_buf_ioend_work(
 	struct work_struct	*work)
 {
 	struct xfs_buf		*bp =
-		container_of(work, xfs_buf_t, b_ioend_work);
+		container_of(work, struct xfs_buf, b_ioend_work);
 
 	xfs_buf_ioend(bp);
 }
@@ -1388,7 +1388,7 @@ xfs_buf_ioend_async(
 
 void
 __xfs_buf_ioerror(
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	int			error,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bfd2907e7bc4..5d91a31298a4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -124,7 +124,7 @@ struct xfs_buf_ops {
 	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
 };
 
-typedef struct xfs_buf {
+struct xfs_buf {
 	/*
 	 * first cacheline holds all the fields needed for an uncontended cache
 	 * hit to be fully processed. The semaphore straddles the cacheline
@@ -190,7 +190,7 @@ typedef struct xfs_buf {
 	int			b_last_error;
 
 	const struct xfs_buf_ops	*b_ops;
-} xfs_buf_t;
+};
 
 /* Finding and Reading Buffers */
 struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
@@ -253,16 +253,16 @@ int _xfs_buf_read(struct xfs_buf *bp, xfs_buf_flags_t flags);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
-extern void xfs_buf_rele(xfs_buf_t *);
+extern void xfs_buf_rele(struct xfs_buf *);
 
 /* Locking and Unlocking Buffers */
-extern int xfs_buf_trylock(xfs_buf_t *);
-extern void xfs_buf_lock(xfs_buf_t *);
-extern void xfs_buf_unlock(xfs_buf_t *);
+extern int xfs_buf_trylock(struct xfs_buf *);
+extern void xfs_buf_lock(struct xfs_buf *);
+extern void xfs_buf_unlock(struct xfs_buf *);
 #define xfs_buf_islocked(bp) \
 	((bp)->b_sema.count <= 0)
 
-static inline void xfs_buf_relse(xfs_buf_t *bp)
+static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
 	xfs_buf_unlock(bp);
 	xfs_buf_rele(bp);
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 132acdf0aac0..7794bd956861 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -403,7 +403,7 @@ xfs_buf_item_unpin(
 	int			remove)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
-	xfs_buf_t		*bp = bip->bli_buf;
+	struct xfs_buf		*bp = bip->bli_buf;
 	int			stale = bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
 
@@ -931,7 +931,7 @@ xfs_buf_item_free(
  */
 void
 xfs_buf_item_relse(
-	xfs_buf_t	*bp)
+	struct xfs_buf	*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 775f833146e3..cb3d54893fbe 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -28,7 +28,7 @@ xfs_growfs_data_private(
 	xfs_mount_t		*mp,		/* mount point for filesystem */
 	xfs_growfs_data_t	*in)		/* growfs data input struct */
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	int			error;
 	xfs_agnumber_t		nagcount;
 	xfs_agnumber_t		nagimax = 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2de204f46216..5c04c61964ce 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -799,7 +799,7 @@ xfs_ialloc(
 	xfs_nlink_t	nlink,
 	dev_t		rdev,
 	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
+	struct xfs_buf	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
 	struct inode	*dir = pip ? VFS_I(pip) : NULL;
@@ -956,7 +956,7 @@ xfs_dir_ialloc(
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_buf_t	*ialloc_context = NULL;
+	struct xfs_buf	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
 	uint		tflags;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 46b1213e8ff3..7cb7a0aa6c9a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2633,7 +2633,7 @@ xlog_recover_clear_agi_bucket(
 {
 	xfs_trans_t	*tp;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	int		offset;
 	int		error;
 
@@ -2751,7 +2751,7 @@ xlog_recover_process_iunlinks(
 	xfs_mount_t	*mp;
 	xfs_agnumber_t	agno;
 	xfs_agi_t	*agi;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agibp;
 	xfs_agino_t	agino;
 	int		bucket;
 	int		error;
@@ -3502,8 +3502,8 @@ xlog_recover_check_summary(
 	struct xlog	*log)
 {
 	xfs_mount_t	*mp;
-	xfs_buf_t	*agfbp;
-	xfs_buf_t	*agibp;
+	struct xfs_buf	*agfbp;
+	struct xfs_buf	*agibp;
 	xfs_agnumber_t	agno;
 	uint64_t	freeblks;
 	uint64_t	itotal;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 915bc2950d4a..d9ed4210fc98 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,7 +32,7 @@ xfs_rtget_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
@@ -50,7 +50,7 @@ xfs_rtany_summary(
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
@@ -104,7 +104,7 @@ xfs_rtcopy_summary(
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* summary buffer */
+	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
@@ -144,7 +144,7 @@ xfs_rtallocate_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
@@ -226,7 +226,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -345,7 +345,7 @@ xfs_rtallocate_extent_exact(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -424,7 +424,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -626,7 +626,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
+	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
@@ -900,7 +900,7 @@ xfs_growfs_rt(
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
 	xfs_rtblock_t	bmbno;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* temporary buffer */
+	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
 	xfs_rfsblock_t	nrblocks;	/* new number of realtime blocks */
@@ -1154,7 +1154,7 @@ xfs_rtallocate_extent(
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
 	xfs_fsblock_t	sb;		/* summary file block number */
-	xfs_buf_t	*sumbp;		/* summary file block buffer */
+	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 93e77b221355..ed885620589c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -115,10 +115,10 @@ int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_extlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
-			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8d3abf06c54f..c835827ae389 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -154,7 +154,7 @@ xfs_symlink(
 	const char		*cur_chunk;
 	int			byte_cnt;
 	int			n;
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -366,7 +366,7 @@ STATIC int
 xfs_inactive_symlink_rmt(
 	struct xfs_inode *ip)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		done;
 	int		error;
 	int		i;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4e1400ea6a99..5cd296a75fbd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -460,7 +460,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_trans_t	*tp)
 {
 	xfs_dsb_t	*sbp;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	int		whole = 0;
 
 	bp = xfs_trans_getsb(tp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 42d63b830cb9..9aced0a00003 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -121,7 +121,7 @@ xfs_trans_get_buf_map(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
-	xfs_buf_t		*bp;
+	struct xfs_buf		*bp;
 	struct xfs_buf_log_item	*bip;
 	int			error;
 
@@ -401,7 +401,7 @@ xfs_trans_brelse(
 void
 xfs_trans_bhold(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -422,7 +422,7 @@ xfs_trans_bhold(
 void
 xfs_trans_bhold_release(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -538,7 +538,7 @@ xfs_trans_log_buf(
 void
 xfs_trans_binval(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 	int			i;
@@ -593,7 +593,7 @@ xfs_trans_binval(
 void
 xfs_trans_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -618,7 +618,7 @@ xfs_trans_inode_buf(
 void
 xfs_trans_stale_inode_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -643,7 +643,7 @@ xfs_trans_stale_inode_buf(
 void
 xfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
@@ -737,7 +737,7 @@ xfs_trans_buf_copy_type(
 void
 xfs_trans_dquot_buf(
 	xfs_trans_t		*tp,
-	xfs_buf_t		*bp,
+	struct xfs_buf		*bp,
 	uint			type)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
-- 
2.53.0

