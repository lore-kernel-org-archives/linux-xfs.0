Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC56B673;
	Wed, 16 Oct 2024 00:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037515; cv=fail; b=BnRyE0RYQ7CtTwMxjSDm7tInRP+n0RsYnrb9B3y5TIDNze50vLAJ7kBxMQ+y+FMGSgwY7MK1F20OQqHDAuSOSL0kpfcqSxOyANdJf7imLP6jDounH4GI4x8CVdZHKQxw3pICk4Ld78AzKyLRyTctey4EQKKqpVDJTqLpnV9bvSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037515; c=relaxed/simple;
	bh=IKpHs/vcpX3tHyXAAHi2HLlw5WIbbG8K4GUF7lETtJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hhwNv3a+GoYI0LKSkk7wqqI1Ku1VE3w9lX/EYVSJU8w1LQCpvtON+TUeCQdAgyOQCFLvQGhu4NlF8hm0OZzL0DPJG/NrS2wATsNO4eFg90aaKgbGc/mHYeZHCMR0GJUz07cEK08fy3wxJHjUfxp0dn8xSXRXd5URfY5mJFnRHUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nNNNzUB3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PeTLC//K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nNNNzUB3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PeTLC//K"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtik9019421;
	Wed, 16 Oct 2024 00:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AAS2J1xnl/M1O+Vhx2m8stCKhpDUIkJjCKDURS+6VCY=; b=
	nNNNzUB3Ps3Yzn2B3Iw3+XCj/rql8vp3rnLsY+yAJblIu3Br/YR/Bhi8jd0FrHRC
	oh5n6b0FmX0ptoVozd5xV+nDiH9iBjjp99j8A8hwcNadahZgUh5OyNS5ztp3tCJM
	0EDUiIJzbs5YVJ+hHtyFYbM9Oj4smkPLdvWYKlSEJyHL/ooaBWWdsQVMpvnOhr7m
	i8jQyZscSVE8z4ieIFK2N4Esa3hI72wWWVl7kQXGNKyEqI0T1Rm0FmPsRb3pD91V
	WKHGtvlRX7rCJq5Z9fnFbamDMyY1E4xIOwIgzYg8elV2GPOL1ixT67eFHku1nk5Y
	SmpyMgRRhlZ6eUbm3a9gYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FM6a1E036660;
	Wed, 16 Oct 2024 00:11:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjegwrk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yagkZpeZ/QzjnWZCPII3IDOUWFqlY58qW62+/S0NiZGTKdn/SPMRLl5INYpqhrXRjD5MA4NBGfQ7m6at6b+40wo7bLmJAY6oVMvJICpqYPZYQUwWpdUXJ1hiYOfYfQvDLcGtdOAEwJ6XOoAhCuKcIHinxNjH29cXewKIDlPI3nU488rb/42jOF2VzGS4FSTvu5gcAo5l80PAiZu40ZLFmAK/6A1R25Gwd2Fobx316M2RfveouBWtSg2xXY3IZu+upYsXxqRNOySewZmSK4prMIFMcCwiKpx3XA/Nc0NqL3ZvRO2a88xYSj2G9Z3RKcLPhEI0XfVO0DpBS95NIKutJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAS2J1xnl/M1O+Vhx2m8stCKhpDUIkJjCKDURS+6VCY=;
 b=FGMKJGQkE0Ae5fgoxrWMwXKRMcqrK9Uu33ip9ztgdq9Q8ObTIQUCbyjqhdOgTjdM4GJZh5v4oGqazE415fM0f8OvIDozh+i6W0RJzGerfi3uzbEwmmUGPwqQ8h0KESqRN/zxwQNXkxISpSvoO/4yLLOzHAWVg5YQdnERo8I9CYdvVzRX77pcbJzRbITpKuIE6JCx4Z7vByoPTMuc4Ptd4YElerGiqNESuOqu9H3pcKOh0D+H9Q9h9JvSaMCN+RGe6CKuw7KtZ4Wb3bueYHG4ACHOAOieDa60y6JqaYlvX/iX8LzGK0o/f4jzqvx1vlxVB0NRN1mwY0+CN+pp+TEEPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAS2J1xnl/M1O+Vhx2m8stCKhpDUIkJjCKDURS+6VCY=;
 b=PeTLC//KEbuemduMD3E8qZOp2R9L4qz72A4tQQ6Hh1InLBI8AnUo/yP+23GeZDQ+ceQ8YZcNDma33wI4o7uWctQMuTwlQ5sCHbLvQm30TrfpvxL5S8i5lmW+mkj+/7lRWd5K+h/6BavUUG1sOtH9yi2eydgfpWPZH/OjNUbtsc0=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 07/21] xfs: check shortform attr entry flags specifically
Date: Tue, 15 Oct 2024 17:11:12 -0700
Message-Id: <20241016001126.3256-8-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::39) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB4727:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e0b8cf-a8ca-4337-a518-08dced771dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6q8TrxJZxDugCOvw2jFT3pYWsSukbHcD/BKsPhee0P9chR1I+AuBTw4jiJUE?=
 =?us-ascii?Q?Kgu0/qhe25QvSesJioBbKWrohHHVd6h2c+RY9Vfmm+CZW9XRpV240Wz1pXhR?=
 =?us-ascii?Q?spTlx9kBB6QoL+yVLwPhUhZEoClAk1iKampjdUp/hOcx1QcGtCFb1e8FAa91?=
 =?us-ascii?Q?Kd1TE9UfiU94JubPrpHe6lvD8H1/0UAe6h/AjLhfptwSvz39sxNtsJsAGnt1?=
 =?us-ascii?Q?nZFFIWKPhXy28IOLrDR5YDnvmnIlbTSUEkUQp+hUccXB7mmr31IpGqDLGyKo?=
 =?us-ascii?Q?QE61nwW4iQeZE1YTicrTi3WC4+6hB1cugMZWOx0q8A6XCI0GSSJU87m1H3pF?=
 =?us-ascii?Q?+vvJfiKq1mN0xGUOYBTwK5eWdX1vJirslag0uco67umivRDHTatBlM9P70HM?=
 =?us-ascii?Q?IBzl+fxV7DKcveyqjk50VWxNaF/ZINmAKh5JstjQ3FP49QBuaNdat8CM4aPl?=
 =?us-ascii?Q?rkCR6sCwzxYAKAhhTUzK97eVA6q9dYnIS3rj0cldnP5T6D0ciO7/FQ+N2LCU?=
 =?us-ascii?Q?NDQVXTLueWSdLKdlzjf8LKtnAslelW+tac1m4vnYjYxGRcLAzeWHXSLbXMZF?=
 =?us-ascii?Q?nbHo/5VMeKzv3N4XoC66lzm2yrE3lpqDawAs9Je9B5LhoIMxfrEfd3J4XnXY?=
 =?us-ascii?Q?N0uRx5w3kUWLdK0rinr2xG3cH1HCb9gcl/VQmkaF4MZj+eggXaGl2pIZkvwE?=
 =?us-ascii?Q?M3wa582hxMV5/ON+ih4b1YtlFlyYUygCFCALx/lNZe3SlOuqHqT6pzJOFwd9?=
 =?us-ascii?Q?7TAcbAuM5/tFwFAKZflwGkUXvdTlPpgpHxulCRYyn+5jN98n8nB9RpFeeME7?=
 =?us-ascii?Q?Baz8fxKRQJyODZ7ljkfiHwU0UHxDcn/9u1sD0nGRkGurB8wG8WTpUbs2aqSx?=
 =?us-ascii?Q?hXvT57ANocg1oVO0Zd5joQEM9fo3McwZLHfgZ3dEJHUk3NwEXm5N28c2kZjY?=
 =?us-ascii?Q?0GPMJAkNkV+cWJxqU4SOdyClIjfxy9QNVBsRQf01YAthAXRCqEiFZQO1jReK?=
 =?us-ascii?Q?oyzrrCK6BAIJVfk4Y/cgy1RyBNzuYUkolbZ72qS0ovFv+OzOouj35nOGNP+v?=
 =?us-ascii?Q?kQ2x61hVwxWyHIgmMKEcm0vBzOuNJ0G4AfPTRS3j2Gv095IZ8Errr8wMzyC7?=
 =?us-ascii?Q?Co5fuaDUnTAlTyrbKma0+maMFZRRKw+NsV5sRE+QQp/QfqjBuW4XaHc0JLv6?=
 =?us-ascii?Q?vsMHZkYVuZPnBESG4e/xP2Oy2BCRR3W+mUDwwN8HvOYCKhSchgsJxi05Mfoz?=
 =?us-ascii?Q?CbaOIl5LHbWbLjAAqKnIqwgW+FotBzJmkL6sP70Ryg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3cstph/rwnorCOOd4jv1rCxzDxKo5FV9zEjSsrQRaxIS+qnsw7ipdcXbUZbT?=
 =?us-ascii?Q?B03zhJjV02P5dJ/ua6a9B1hW4M+hiUYpF5CmiXRCDxgjh4DndMbIf0b8+jZ7?=
 =?us-ascii?Q?TaUZS0jM90xB/B2P8u9EMoClCldXqdYEQ2rATe170VJ07S1KfETmNWhDkkZL?=
 =?us-ascii?Q?U3d/4hAGKWEbiNNYN+cfI5WRuttvupwAJhnDN8K2ZNnhqccoPNPkMwiZ4ZQR?=
 =?us-ascii?Q?Udfy7bVEh4QAME++u0T7HhO3Zcy6QAr5TGy3coXdWEBlCNY9NZdX8cLeBd8W?=
 =?us-ascii?Q?ciRqrcf/vQdEeYVQOBgjVfrfqZ/RK77ZkXMcIpfwzD/hs8JMgQQPWF3Ij9np?=
 =?us-ascii?Q?K8FgRcfRFeC0MUhrhoiExMuOd0kds6ytoHnxprCREXUx4siEwZaRynqharSb?=
 =?us-ascii?Q?6QfOIOiKgEFS0mTh/i7h89xJKAlKwJ4k0gZ+nKfxU8pCV3liPqvjbJx/3wLO?=
 =?us-ascii?Q?p9Et8GpDJ6NS0Ao8CdzyUhilZqIpXMkUz8q0yuvivHrG6uVVFB6jVZV4HaLV?=
 =?us-ascii?Q?PX7OH3+106iMBXiXdgxfNd4fwoPa0QYz8zUwuvILVzoPpwgIAwg7GcwS4Et3?=
 =?us-ascii?Q?KnOQ0gd1CrAURtSRhTfiesGIA6Nn66fK+LVZfdxFn1t6svmKNHokZBrVVpRN?=
 =?us-ascii?Q?OuuQtQA0Xn3QFI2Wqapi7+auY9x1Y4pKPm3EtNnIao2sjIGS8ncXocngqbOu?=
 =?us-ascii?Q?b3Z127OgchUE3Pqxia03ReXLpbS3X7MbJYlWGTfbw+bJly0v5pNhSJbpZehf?=
 =?us-ascii?Q?FPZPczsK3f7rPJMAhpwFLvKKn7GNbWaIdFp44+Phjs7nqp7MpefZ3/ibfHzf?=
 =?us-ascii?Q?L9R+3eo5FYKr+9kmTejkpWtyOOUdjmcmShkuwVDYfu1aVULhSjiXBOo1e6LF?=
 =?us-ascii?Q?zetig4+Tsaip1X6aKNMDc5gX2p0LMUUe0xZyBmI6/IVSa9nhGmUbwPQqIW1v?=
 =?us-ascii?Q?IFusZvibRQ9SrBmxxPL6EneqC34uEKLoYizA/7vVxAwncXUh4+JCdsHwM9lu?=
 =?us-ascii?Q?HOHUK8RwoYqkTkyW/A1vsLvPCloUqDTmZiJ0Mapgc/I/3US2wIsX3hEWj8+v?=
 =?us-ascii?Q?MpHKuuG6CLESznE8Tee/RAc/MJSnAMzX13GrBaYpWmsX78mHWu0x65OOfHap?=
 =?us-ascii?Q?Y126EFt53iIx++Jjhu1FAmIin3tzfGwsCo3LYZS4D1fBdHmACxO8SQ33dXbF?=
 =?us-ascii?Q?scL0n976y6cRBlOurdpwje7Y5Rv81sHR7MqtyN8NQzvNffA0ENFE4iuRLNBa?=
 =?us-ascii?Q?Rw5ttuC0kxLfTjID8ihv8nlhlOOhRKc8GQGQUHwOp3ZA9l3tz1SfJ6gI/JDK?=
 =?us-ascii?Q?En0DJZeNKsxqWacbyTVsChftYelpiwtOmk8PZPQdc67sHzyKn+ZeXSD5W8/9?=
 =?us-ascii?Q?8/QNjuov01h8vda4hO17zUf1VfAqhd1bTnMQdy0ZR5CimOv5vNRh+rGi6dl/?=
 =?us-ascii?Q?4SeWuQKaSnp/9h7Y8q33sEIy5eAxhx258xwyEJ+FdwbBmofdM3MEj2bscUXq?=
 =?us-ascii?Q?uP4dxQgZfD7aOn17GdcF4NbzYc0cGKZ5OHOOCg5eZTV19cTAd7dDyidORIpS?=
 =?us-ascii?Q?pQGSrYdNsNu04qpwnanzcfQ9EbMRtLmAHQWWfGN9iWhRiILXg1jMH+KM22wT?=
 =?us-ascii?Q?dZY1rhRi09gJ3p/HZYAfuxNgAZuDuGnKGnUPjXs0jIrhr6FSLND3Y9AeswBT?=
 =?us-ascii?Q?mTO9vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ek/QIFq8ECo8h9Iva4dlCypnMFqR7k1ELKrC1VsbhHYMJMSVE0PxP32C4F0ktdmoTEq4k1fxCf6rotd3F5F62hsdQ9yJDxNqlB91fffnCCPr6RcJXvYZ8iB73gC7ZnW2B+lC6KqKDCYmb2I8LDqBrJvsHTQUvu8qJRSrIHdLU46NcPcZjX6/Tfu8ZLC7kNXjnbX+/4x+oxRNPhl8cO6e1T+rhjZk1ItVtZcJjTwDLGCsWtfPvtwAcn7Kow5i5/iVnvXl49mYNpvo3vREok4hLHOcxBrZjlM0DvzXHsZfnAkED/JmoKcTSIhSn739LCyiL32mmkWcwWYKiUy0dlv/vHxLWzlQq/YorCXKvNeQBZZM86lWsA33iG6KDYxOM0hP/xFkggQ4wvXayfHT8jAAz6S5fqwYq0bYGe8gxrZwpOSMhI5LZiiI0BDn8a9B463hAcHp6oq4H4SNxntVsdGYgZTOYxLLcX9QxnU9ei724OVig2F4+w9awyJNBX8Qi5GBSTtOaxnQi9QMOeScbRZ16rFa+sEMI/VSSODe3yMLsPVTqoNggIjdBidQoO1dFg3b/JWq5bOjlfs5SF1ODsm4CeUfqvKuMzayc+hvIXzotyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e0b8cf-a8ca-4337-a518-08dced771dec
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:44.0250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUE7A8Unh2R/upv3qSxcyFyzPmo26BX2XfeRXiT61oX3Nj81UWOBpi0lfh7QLSM9F2EsyGQIaJtBp8JZMkkYO1lXcjxxfM0fY5VK7CJOI+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: hEcE6qJ6yPQND4E9r32dmqrbXbS29cMG
X-Proofpoint-GUID: hEcE6qJ6yPQND4E9r32dmqrbXbS29cMG

From: "Darrick J. Wong" <djwong@kernel.org>

commit 309dc9cbbb4379241bcc9b5a6a42c04279a0e5a7 upstream.

While reviewing flag checking in the attr scrub functions, we noticed
that the shortform attr scanner didn't catch entries that have the LOCAL
or INCOMPLETE bits set.  Neither of these flags can ever be set on a
shortform attr, so we need to check this narrower set of valid flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 990f4bf1c197..419968d5f5cb 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -566,6 +566,15 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		/*
+		 * Shortform entries do not set LOCAL or INCOMPLETE, so the
+		 * only valid flag bits here are for namespaces.
+		 */
+		if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)sfe - (char *)sf,
 				sizeof(struct xfs_attr_sf_entry))) {
-- 
2.39.3

