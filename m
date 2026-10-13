Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A433B47E9;
	Tue, 13 Oct 2026 08:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879313; cv=fail; b=PLaj8Hiss77t4V1OAUYbCLfn3AVbEwzhbbOrWYJma0LcJTl2gJZmkvn8zTRL96edqGvjhNQhVZA63r15lIYuC3H0i5gqEIRv9QhzMAWXJGIht5CPyJw4msSU7UhfaJxc/eMWJ1LpjkzG9nLuO4pW0sWmEzPDnIJ3kE4wpQEvD9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879313; c=relaxed/simple;
	bh=HJy5x6B9kUrJBhkHqGZphKmcfbuGSHsFtFZl1skqLvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sj2BdMeU3OrR73FXWqRj0M6oOfiPCN2k3dRsqqGBQDPzsO+OnjHv3CzZacaRKFXEBT4CfJo70YCbMOFX9r2tL4iDvP3XDZ5AS1Gsw3MDp2OFKPQuAMSSd9KGFqF2HjIht3tAb2I/GMhwHo8xKDG0AM+700xcVW1zwgwX4R70gwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JqzQ0AE5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qV7Qvz57; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JqzQ0AE5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qV7Qvz57"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BvNY3110102;
	Tue, 13 Oct 2026 08:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cwIegvRcVLlIOVRTkL0lz5mLgnEqWmcsFHcCBjnL8yc=; b=
	JqzQ0AE59J+yGl5WX2QrGCoO3FIVCmfp7KzN7F0nWSklYjHMYdLWa3YnQbTIgCbc
	w6wI0cw35rPizs2UZD2P3nnctc020WX8KQBQ/8Mh9xtR5zBRVmNSrzIe2mELFK9s
	UTuAz+bTn6Tg5tsAyXu5o1cMnDobv6p/bUrTPogXNisH3ra6VhA38ghd3PxOspKv
	+NFPB876ylSCUNSbdvCbE7qXMnYMuDDBEdX7/7UTU17WIjQV9UTcUhP3HoFRkaqa
	aMuDRuzE1mKlXi3WeDjJHV91cjyiOHZTWDlXgAEIXLJrph78rvs+KowD6FAoC/E3
	b9T/syrMaSZUwaTUy6Efwg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7ddgkmk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86jBs020887;
	Tue, 13 Oct 2026 08:15:05 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjsfw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNaPn3MrHNSuA5MLJE/EobikOPULhWuaAb6pWO44wudhHoSFRCKWrzpwY37sxwtfCErFsjDS0gOGRaam8f8tX6HWdjP4eDadtKwe3rbP+bWJRJ8PNZVxCYqqSVnCm+f7hePJHo1JQPY+AhR6vzNiROfHNRJ6xwp9gVXqacGYR/UQeWadBthqrb+uQQ/h3PNKX6WXUdQGdKMlMuGRkH1nSj1aniilqCvxiid1amJ6dTu9VSlccJrpZswix2olm0FSlUHwJG5exflA2vhCveGHK+NBg12StYnfm6Hm5RT9f7Rd9Nvnk0/su6VVFagfl6ZP58GxlV4HkG2oGnr69bhNew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwIegvRcVLlIOVRTkL0lz5mLgnEqWmcsFHcCBjnL8yc=;
 b=g4YzlFPK5Zjeyk88/+VOBQ6/RyQbKe1jRgIAqnJArUsQ5QcduPF+avomQSDXxhr5q6ZrfZz09yC2TPmyA4Gn1QV2zX1nnuthkMIpx307VAz2oPowJbowI2ZUawzDtjiESbLhk9hasTc4lXRqC8QN/x0Q/A3T1KdRYtrvQCSfllEUna7RNHgeoRKeMF4lNocQSvR2Tap/ltjRh1lIb3lHIfDIenF8/4T7DhRog4ngnyvRi9L0UUWmdjtycQiqiVwUzbglXj58oMjRn3OMo2JKaInaf5+pahhraTW80SFguqJg+S1IxH+GmqNN5BxgCUUbi31ASvdBvHtpSLoHduq8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cwIegvRcVLlIOVRTkL0lz5mLgnEqWmcsFHcCBjnL8yc=;
 b=qV7Qvz57pH5iDlHIiYqrWTChV4QWGT0kiWL+ZVVmic5EDAuDgWwZ0KZqEh9cHiykrH120ZddtG/2ElNG3M89q6UgkhR+SXUoNtyd6ryQsdL2l741ua119v2tmEvXr6Q2ERxOvU766oAUG/uVsXr+ERT1VKtSL4vEexU6CWD9PHw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:03 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:03 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 9/9] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 13:44:17 +0530
Message-ID: <3f2791e2ae4671734c62a0232baa011e0ea1475e.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI3PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e5780de-4434-4c8b-f450-08df29021502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	iJ2kMQMX2TlI9NQUanQBkhx8Wz6+gHIeHXgOotKSUmSdFADuwlpIOAooEvix0Azyo2AtK8qg3D5s5u8bStaighovwNthl1wPlCi1q8I/o05lGCyy4h4yUWjUq8t7F8pyKeCRtm+Yd1Udb/iltxNi0JH3RjozcBJxN9/VjZ79RQ5XELqsZ2BuWKPCUc351wU9Lys4b63SVvqYGXMrgjVnjg5eCVX0LOqQNXhDCe+aCcnO4acjqdRNAp1Aj19aEVhF4DQ4F2D9AUJCjy8KD+9EqL2RmNxPcVSb/soJe2v4i6uEfUNbWLwUWaWIsXFp8cGuzrR3blNhSTLODvPHJrYZjxdWxhV/Jm2Ss/lWDSwxxZ7SdO6FQo1e7HT/63tzR/hDeXnaUG+uGQD5sUdBnwB+JZCs2X2Uq86K0DcudE/bwFCnWNgZam5QoJ3m/6K4R3PzaPNAHGWK+WV+hghw6HPaAQeNrsIbVpqjP8TCVkmsez/eFYtwoADga/rTQbO7KR8mMftbGmoH+RaEZtpppNQz4btq2rFczJJO2VBq72QYZiv94922FD7sq2xWWyYzr5dBFNeYZSJjfpGoFRJgZmnN3p75J7csSLFtwEy8YUkmMU1PnVNjpYYlM/JjyvDb9HwpC4ie3zzama3IJ62024W/YXVGfcxk9avwnkwIYcfNwHE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pUaRNmJ+/ij2zVqn15bpYK77BHriRSGu480PPbqGNabpTeUE5vtOhA3+0L3G?=
 =?us-ascii?Q?LZw2rGWXNNt/DNj5l1lPe/4DgngUfOOT1SYuIxmg6RMZkPOQ8gR89HO3aF1T?=
 =?us-ascii?Q?w7J1LeiYUxXt7VLWAZNs4FQVrWwDIXp+/9vKLcGt2j4UcfcWUXvlloySepzF?=
 =?us-ascii?Q?Zh4Z050lEEuFBAN/56OLHT73NO+2hWLBHhIMDfOyfIkSyot8i1h61z2P1P2k?=
 =?us-ascii?Q?pl6c0Nrd7Byb5QpXwzGU+SzmcHGfHhzeAtgUYwTCFUw/jwz69zl+rJX7/Eqq?=
 =?us-ascii?Q?Swh0awg6uLFxApZvHZp1FQPlll90Y/8dQz/PX1MmpLI40AzmuWLXOuPzPD7a?=
 =?us-ascii?Q?BYwnFg4HIv4ju0YClG5P8iW4HXg8mJyuQVHqmvF8gzaWNGmbkMEo7PPyIAkZ?=
 =?us-ascii?Q?f3FblCy+6D37K/n62wKjoy1lFxGHfmAROBCavCiDMhJGhGqR1Kcm+8iGFRem?=
 =?us-ascii?Q?3+EgpGBxiEEttoRIJonKWMzqlHwfJD44bwA2GAEKzu2YDYi0P+Ncb1UyksSb?=
 =?us-ascii?Q?yzPRW7YBu8qxus8U3Q5lvH3Ailwse7BKYyj1dl9Ugt3PuHBLJLOB+MfJadK2?=
 =?us-ascii?Q?x9mRAoVR7mkBZUINoENfd1VdK0tJKeYliXIIeYwZk7CJdLoD70fn2MPKfOm1?=
 =?us-ascii?Q?qP86rh3asPDedxKYpkJEyg+OTJMX1IJ5wXwkx+IGqHBBePwYOZZypRHMKWOp?=
 =?us-ascii?Q?S0WDSCaN31HFmy9qewxTzciUgRgqrbRuHNIW2FfgkI7b38wnUYhwREIMI3cG?=
 =?us-ascii?Q?8g3lZQzDdR+CqDGZloEtH8A2dBwy7PVC4KxAB3KKhHw8BrVmVtAeiW+bhnV0?=
 =?us-ascii?Q?OC8jqGvBgQFMMde3dSlKqv5uKIbiL3fTBKprNPXN8VxBd/mBDtAd1fuP/tcf?=
 =?us-ascii?Q?bJeYbVKBOGrhVUy7cOhN48brBg4cYlywjB5WO2uw2Hr7lMvCcYuB/9PhAGZ+?=
 =?us-ascii?Q?wfaIQG5yWCNYMHAQ0QddSGS9O7gVaRcpgMwoI0AJA2tc933TaXbaUjiYGddd?=
 =?us-ascii?Q?uZDJjcsI0Dx1tAz40awwibKHfQxti7UluN3lWPRQbaxAkXpZgjvoHaX+t0iO?=
 =?us-ascii?Q?Wb+hjLp5vO1g5XP93YWVWU0TgdF+scusRhtRa5mKgTIMY+BbSZE3FfqaMf8Q?=
 =?us-ascii?Q?GzkcjENhvuMLVEmMRhnHL8iputvBQ3ULkP7JpONCcFU/Th04iAVK4nvX90DB?=
 =?us-ascii?Q?P1aOx1G2gCLVDb6N9T5UekeQB9fGOt5H7Jr9Tkc6S8QJ2A+mxs4QNqjgqgIF?=
 =?us-ascii?Q?i8NNenqtcL3QvjxsNpruj5q7doadyz0uDfV1Zc2t3yNXcZ7nIYOJUazsPJO3?=
 =?us-ascii?Q?HRJjbZWKd3my1beKu639+AuaNGIxOioa/XPsjERp8Skpom9vizAagG9KvMxc?=
 =?us-ascii?Q?YfmyUSdW89eIlRiyevEyoYYTAWeX0Va/nreowGt4/5vFmM1183v6DCjHBNGF?=
 =?us-ascii?Q?qGKF9Q2CLhvDcOqnev3EV4mzU14Ec8z5GWCSa/6TPB0OWVAtSVcIg5ZI4TX/?=
 =?us-ascii?Q?lmrcD+AL9hKe+3TqkgAB3SkU7YYEw/V86T5WNFh5Lhcyig7zl2l4U/20zruD?=
 =?us-ascii?Q?96XsUPC9vfR2n/A1rzKmr064u94BGUU6Rtyp3iTHbUKXxzAcY0A5pu9KFTOA?=
 =?us-ascii?Q?0aTL1oKpYowOvh4R57lEdMewHLP7riZMBIhHV527gfXEKLV/Va3FIvUNp3NN?=
 =?us-ascii?Q?rTJD5rt6EtngQclI6mTpxKeVCVGDk/K09usIQAEEg5RDuyYQfjylPMy0/NAe?=
 =?us-ascii?Q?xNsZFmaS8MuakD17/XdXTGjyDV7g5BNtNy3/Lvz4ui5iLBtfh/bd78r4nSPA?=
X-MS-Exchange-AntiSpam-MessageData-1: KuNlR2/73LWgV8d0uvnxGnK7vu7Rk53E2pE=
X-Exchange-RoutingPolicyChecked:
	aJpBhYepZeQ48lPTJi9hES76ljC8daiMvLSzzioaAacE7IhviBsD6SGpWPE7dCrsEEOBefeYkyVUmAhxIII6fxOKq8BUYqtYa/TR1NVVy5TbIoK0OTxY6++E/Nr3u0PKuBd4zOI8RyN+ZcgjgSMSCrV54viKJ+hAa4MfNJLiysrgLOTd/DNyDhXOGJ0hcvUu8Mh4LLkWjDiqBxWO8nKPrFC6fN+44Z0KcmQe4Vlc9DblnhWwuL3nKOeYnFfjp1u5ReFqFt4qRvdcda6xEemf9/5Js/5XPmm2Nt++RA0gjx8Bfnlhe+MidEYthkNwNrL4Xs/lwzfgSFj5cnGwS78qUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yyrGEoOqf0tbaJAT65JCLke5dkYLylFOhfHi1gmY0pRV6ndIezXS1KCFNMDhMqFs9oowZRoNjGKBlL/LdC4FUhqG4bwtCrmIXhftzvTz81N6K16D31s/PRDnRnqVbevCAsB5pKG7pLWKfbNT8/F7j7DE1RzMX+5agu4JHv73LD0c6SVK1vJtJpA47pBOe+rJtU70aK95/1gnh5NFbEgyHXkGE9wT8tEwQsUDTp8Qw4k8/yLm/RPp0UaHWIG2cj6zI57hln0AwspoeeY2Lu4ZdMCiOdGIWSmcDZm6q0zatfs77CAIREPMY9ud1LF3VG2KSsgAA0IPG7G0fl4uRA2jjcneeSHrQbFda0nK1v6rDoA1vsd3FuO8nYxRL5sYQPOJgbnpTSJa9Jl0Nm97CewRs11kdVIK/nIpNy2yWYc4Eg49GhYKLVCKU7UxyShXE0H3EAZwHYtvaMB7bFkk+zoECte3bOz8qRbCC3y1nCvSBTZyiU+7OL5UBbTsOnhhWwdji4g+j1otLjkkGwJce8J7xr0CTB0IEYm7zi8Q/d0mg+pMminVdjrq03qmwMMhjdPEl5IOmfey0LQg+pN2U+lXACRj2/QYlbVzIs5qerVJWnI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5780de-4434-4c8b-f450-08df29021502
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:03.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utqtfw1Z3oAEBUIaP0EkmbyEyZ1nPZO+S1rjVnynCp8dqshpzIaQ36iEBM00gffSFv/od5YhAZ4q6PILOmWSLIJfwHIioeKxLBBZwfvtORE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=EeZd0/mC c=1 sm=1 tr=0 ts=6acde88a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-ORIG-GUID: gY4X2BteHXCD4vmKnzfxUf2zuOYeIRPv
X-Proofpoint-GUID: gY4X2BteHXCD4vmKnzfxUf2zuOYeIRPv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+uUZR2LVEdBG
 A2Tav8dkcoc3k3/yJofbQTgRMlZBj3DQbqss91U61f7uctHPShR4zlCyAGH4CQcZs5/EaL+sFZW
 STR8XrilEo3YuAHSIc1JoUSUY/2ax3JhD665F8/ZxMB9xe+eBfvK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX28sAmfXSbd4F
 6SJFH4X2fasKuGnZYi2ofbMHUcwj4EiC62eMvNzA1tCNnpk8Tjzrhe/mi6qPp1U8I4W9xQ6QKpZ
 y7euNLkfgys8QdHwsru+det7gm/TtB520cdHCB1X3C4no+WugWunkz4QHFGZ5ve7YeoGTiGPK7K
 I4uJ0zsxTeD7ooBFvimmnawrOKww24tcDb85/Uac5VXeGi5wG982U6rB2SMqxtSiRN/HT4MRPxQ
 UzIL1Rq8TK4GQYbcin7jiKY2lH26CHU4rWh5sxFtg08kKdaFLzeHMesFyUn9TB/mNrWiCH3eMrU
 muUmplcft5O91/r6wbtmuVEPaNihbotBQ++50OSmFIW8r1C4ZZnV8Nfoi2/ULXFU4cQI3kyD2lg
 3WOD2bdy4mfG/9Q2qTNbR8BNMoltK1lnCUYyywQgO7kJdapKDh9F9cRWwXlY8vRKsEZBtWh1tSq
 3P+ji5YaO91wd7l1/Voo3gj+945LoxcRMdGZ2/Hg=

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
index 9c3918a63a23..8147c8737f02 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -708,43 +708,42 @@ xfs_buf_item_push(
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
@@ -765,6 +764,15 @@ xfs_buf_item_put(
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
@@ -772,18 +780,19 @@ xfs_buf_item_release(
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
@@ -799,16 +808,56 @@ xfs_buf_item_release(
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

