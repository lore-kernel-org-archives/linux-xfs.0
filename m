Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80521188CCB;
	Mon, 17 Jun 2024 23:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718665445; cv=fail; b=CxrD1vBqqk8yUXQQ4PlUvyvJMABeDIzN+uz7oMKr521mr298++T54Fc6qVKOeTSivZGVHqZ7TcPuaFdyIb/NYv36Oj5pX/5XCBc/Ojvu9mHG1KNjWM1AxwcQJaLA5Bm+XRzgnRhYeugtyhCFlkrnWNq5bpF4fNR7D4x8uHGGlZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718665445; c=relaxed/simple;
	bh=xTCcLS1SYAwcPVG8Cr5f73mO/PWv/o3+2KP9Al+mzag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j6LmJgXw3fQh+4s+IubjesWCAFmkV4EsRjUx9Nz3BsfkGUrRiqkN2Wk1hhKCwZA5W2puY+je9jrYOSOUC8SHt7UFsFjHlNUX+ziYgEJQMuIZxhOAScaBKw78VJmZtfbPlcExTLeQzqAfJTzrK1E5A1mzZz+RbIDvmO/q9zhmWFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bi3pGcyi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N64xQoK/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bi3pGcyi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N64xQoK/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXT0T025706;
	Mon, 17 Jun 2024 23:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=8QWXChfbadAAEGlJho0KAhicvgDlUMwCBiC+UWxbBxA=; b=
	Bi3pGcyiNOWNAs5qPJ3PXf3P1ya2lFoXBRbdLL9hK4mNKtkxUD+WI6N2vG61uvfW
	XuOzW/rvlPi6Pkmrzi+OTkQ8xlxYeGrKJp04NFzepFyHZIdmjIyx7tmdVKRxQavH
	5CL5t6LsLjdUkHNk0xOdtXUyIW+haPOY6zWfy2k/I+9AGhsi6PgjwtuDVOiGJQ9M
	zxcUG+48SUSoRpr//XIWffRjF4qGLa323p+cqNRrywLFC41H75ABBO/q0hmeYXXj
	d9F2wlBMteeS8SQpVHJh0ExPEobB3ChHWxWlorZNYy+DJ/lewDBrl8r2FGZ+vBbK
	svcB3KUxuETRF/VTaxIy9Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1j03svb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HMZDeC030610;
	Mon, 17 Jun 2024 23:04:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d73jwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 23:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRT+P/fj+Xz154M/AliYbHEjhkF+owFPkWqNiajOoPxFhhoZveDGdNoyMbE23IEogvOIRtqkVL7Tll0aQ9BsXBQ8Strk996+VwgAffb7FeKWjcEKRcNAjr4688BId8FjcWQnuwYxf58lHxIsgxCU18fVJPKL0NIYLsfGnsu66jfbx6eq5EuJ9s+7AAmdu6Bz6Dutx7b3U6FcibzN3mAeiGm6nob+nHl+Nvg25YvpDxZyuvrJxLwgZ8U49bA/Irlp+4Kq8f49ngMwvEjlX2bVRFKvzWFgMZMpjTc7Bo2HDsiARIcNdutrlmAkkHnHj8i/1s2XOAlS7QYj8jXMT6yQIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QWXChfbadAAEGlJho0KAhicvgDlUMwCBiC+UWxbBxA=;
 b=Kk8Zd47RXI/i08YNXaf6xtNFmFtN+gNWpwi617/bZvtfLbJ5+kkSJ088/M/01ggBZV6YUsnLktCafZDIouEiRiKmHckN7Wq5w5SUa7SkpoQR5SsJ7GhLQfHPj60XtJbg1SyyM2JdHDc9qseYtTGSaFcl/40sFfbmLgh/Gyx/ORekOgjA5ZbctJ7vFFg7i0EaBUcpBnYX/YWIYR8PUtQ2UZe6Ho/UzdkIyrf7EHoVVRDChhs0WIKScCni/yQOG9Em88HwbWS68jL6TRiVnKdSalz69IIvGi9g44yB/ztRPaioVCOcHMtl0h0nc/NEwoyIzV0/iNkkWJogJvv6pK2u3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QWXChfbadAAEGlJho0KAhicvgDlUMwCBiC+UWxbBxA=;
 b=N64xQoK/Re9KLrv69ILNhDHYA2dt/EidGB03AvStPN1jI//1geSk4Rn6oUKO4X1LrYp7xwVJUESFYyqkyKOXuIGJXhL3T4mtVGKLCNlL4JYQRIlkSgVCtrHCxL5JrpT0r1t7PMcUlpM2J7lOZ/5AMbVLiCkrX4FUB4guwGukWN4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB7398.namprd10.prod.outlook.com (2603:10b6:8:135::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 23:03:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 23:03:58 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 1/8] xfs: fix imprecise logic in xchk_btree_check_block_owner
Date: Mon, 17 Jun 2024 16:03:48 -0700
Message-Id: <20240617230355.77091-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240617230355.77091-1-catherine.hoang@oracle.com>
References: <20240617230355.77091-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::29) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS0PR10MB7398:EE_
X-MS-Office365-Filtering-Correlation-Id: dd133ce7-1a9e-4958-b67f-08dc8f21c564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?NNb30TXu0OGF4Nn94pN8br3ldoqJguRiXuw/k/DoZYIP6UCnaUYyf3JVjZDS?=
 =?us-ascii?Q?H8pO173xZN++Dh2qZjeACQ5GXKUUQYLl1yctojr/BqS3gLldeiK7bOdcOx6s?=
 =?us-ascii?Q?/gEJhoKVdJ5biwcol0W8FqGgVEf0Hj8pLXVV/ZbSqW3nZC+5OMHeFc+hvgav?=
 =?us-ascii?Q?u9HS3l7QXIsgsGmlvrqzEW8V37ObBa6k/0O3Q+BdxXik80Z/U9/OCqzzdKxe?=
 =?us-ascii?Q?hOLR360eCdCw9nMsrXGugkj7MR/g6jLKkLHQJ/2tqhFSgoepRs/QjRRVfWC9?=
 =?us-ascii?Q?FBIOP0QstWeCi+EYzzdifW7/JwDSRe11bl8D2b2/mWV14qHXchW2kusMRz/7?=
 =?us-ascii?Q?AdXGgBM4kBxZoUBMp/pkT7gCPTJvEQ3vx9jAQlpJiHqKmr3p4XXEP3ePchl6?=
 =?us-ascii?Q?kn+3F6/wXmPrswJWRne+yS7/Ae+QxtEgs0Ca5Hs6ERcQotoJMzpBjGJVIdqD?=
 =?us-ascii?Q?ABwqTIWeuiDjC8vSqMmNtOaOt6Ry/rb6QydY2lachZWXS4O/U4UyuzwH8ejq?=
 =?us-ascii?Q?gRsBox/p8npt1PgpXqOxienQlDWKcl035S958yDaEPOtQjx7pADXSRUgjBao?=
 =?us-ascii?Q?AKmCoQoRmAt8LN4LKUv14OXF9LT5q+w7Vap2b9oDoPNnw1UKwHXroiLaY8Uw?=
 =?us-ascii?Q?ULfh1o4COwFtr4zfeBUVUrVFHuWSkDf6J63yYbNrAWte6dbiJcCZIxVMNQAG?=
 =?us-ascii?Q?zXP8KvN73tZvgHNszWqwAirj7ylG/HDuVLRiu99FLSd3EmUvtWec8d9tsAKh?=
 =?us-ascii?Q?Cy/vt6ETA6nZLrOfyNCxHAC35nzgaNv03V+S8OO/gfFA1fqVCwowPXRnivh3?=
 =?us-ascii?Q?NwUVpJjFpfmJ20rLBCk9UY6H9rrsYFQpVwFdi3hMChhHUr6DSQMirKVxMXpM?=
 =?us-ascii?Q?/F0+1k7R8sVQmnh2Zrp873o50QNe7yBWUsPVXhQQNxuYMLCoKxzKwbzzkH4d?=
 =?us-ascii?Q?i6VdSnQzonq+o28bdwgvp9UicXp0YAOZ94ax36z02pU2rQNQFPnL5wiU0ors?=
 =?us-ascii?Q?O5F+H/Y36BYaA9IeKmWeIoTMeqVpPcwChmRd+FsIi/s5wv7IfiHkl88tKK7R?=
 =?us-ascii?Q?fB8mHY088JbMoaCdnrIhY0S2AqbSFLTHXtf0fNk93JIeYw+2Y2mIGnnOjMCn?=
 =?us-ascii?Q?dzd+yR6a6gudv2LXUkT4ix/Zn0PWrIxKnRunuYnJEJRM+/aY87CzPeeXu4Nu?=
 =?us-ascii?Q?9iyqf2Fz3oV+8TZImbXejswAZj+6/58p9IvCcvyb5nvgPFW6bkJw2of1Z5uy?=
 =?us-ascii?Q?W+pfQRYKhy0VbMzu6BMGEUsIzvFYTnC4IJ9rDz0COQJNsimzKvO3n1Kk+XG3?=
 =?us-ascii?Q?eEzS0aueUycg7Zv24viU2atc?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ScNvA0MrCK3+dl36kOzSSWUdgexKXhSgdxNVmp4/w8c1J3oHINfPi+/QTfQ1?=
 =?us-ascii?Q?AZDCSYxVwk3NO9udOT82kK4vJIMaO1ToNPpCoOP/Kae4Zu6mIhNtuMbyWk38?=
 =?us-ascii?Q?a3e8f578cnk7KImLoW2N1AMTtNEavH/0stCujUDxFZETbnhirj171pknvXYr?=
 =?us-ascii?Q?f+ptQVxUhmxj3Nmd/NN2uJbIxJYRpGqP2LSy0lRzKmaup4UD21Dh8dRL88mP?=
 =?us-ascii?Q?GUwuWlcYz/0a3iL7YpTmf9jrlZPKDLHArOHitYYo8H+o1+ZiLiyqN6V51mzt?=
 =?us-ascii?Q?9uCMMmNKfpsKrvdYHcKR3sqxHa/xfMs8dIhnX0UHS3f0BFk9Ln4vPBL9FWzX?=
 =?us-ascii?Q?4DDaie7MBw/z8eYOBn6sGKciDq/yzjYVlrL3MAGsz9R4YmK/bDdYO9OPxMfK?=
 =?us-ascii?Q?hDDugCeTJn02+HppwKWJFU51/tJpFOACYKW6hhr+wqJPBhEVZzlV/HuUrfOu?=
 =?us-ascii?Q?WoxnocYVui5zPtSraa+KMI32/RUaBXDoKCPLXsxkHiS45v57wkNdgV6PoBxr?=
 =?us-ascii?Q?9QSbU1cHWx2U/TeckBLWaOUUkANFYPtgmlB3z30RHL8BaNTgghMEjX55guVh?=
 =?us-ascii?Q?FTt5g91vsuvyCWVc4gxPLVr1IXO0tYTh7zN3vJiwLFgV+fBdg8F4leKC6fgJ?=
 =?us-ascii?Q?LfTKasVMPW92/vX7OXm+ct6SFGKTVOilu6IWtgLyoamWcK96C7S9GmPsvDl1?=
 =?us-ascii?Q?Al99mZjwthoH9vfFTjOW6XqNKhgoULgOlTY/9QnEr6pv8h+InY0m/ndZJ4dA?=
 =?us-ascii?Q?bRb8AslRnlNk7GCU2DzzIVjLQlHetjZ6frSQWzv1GF95kl2ZN07FoAF+l9Ju?=
 =?us-ascii?Q?OiTzG3yDhfBOrDl/ehEIzYGB4aJmR7io+03EN31yHlDkEThk1XB5PaVsvsUB?=
 =?us-ascii?Q?T5Oh1PKUJ/LFJzm3BsUNgNIWxYfno813nbXGAfxdwtd1cY4qjJ8l3aa1Oq9c?=
 =?us-ascii?Q?AWno1j8qk8olmnqM0Qm6CkH8u43GfVWhlV+1WUeJj/mImWtvYAgRMaCiCZTk?=
 =?us-ascii?Q?/l3UXQ55Csnkv7VYQtne73OTsGwu1EnIKx5r0aOaTOXtWL1CF0RWYaMZlsQO?=
 =?us-ascii?Q?4wDu48m5nR5Ygo1nM6kkcNHRvl8+6jtHYGTtrUw007GUGNRVHoGqoCu5ck75?=
 =?us-ascii?Q?UATaisvgsycQXnWAqkOEEkkMshGRuoTDe8nE9FaR7QfAeQrPdVKkmOKXj945?=
 =?us-ascii?Q?nHNYR5Plnyru88Y/X1ELoytzjGbJZyIBWcMyQMwYLVI16h+b8qG+cbU/M0nY?=
 =?us-ascii?Q?1uOLa7pYlpa42EaRURnxPrT/bFaa3/aRLyxAswW7xNG9Y6FmuARfeNG46nFz?=
 =?us-ascii?Q?AtUxYVCNGvDWmAs7MIpTaSS4mqGwM/N1WJ+SZpg1eLzz2iAfqpyZuAGHK88Z?=
 =?us-ascii?Q?z6Ji4feD7FVNyjyl9UuhrD4V3FsUrUIK0/HEsBzSz57JZUWyojFMtZdR7gTl?=
 =?us-ascii?Q?m5AXnOA6gWNQeVj0/Hvpnl7fqFYY2fku2xTF9F8UTrwmbQYnJF5MtNeg2FRB?=
 =?us-ascii?Q?dA4/aJ75D7VPmcoEr6U4Ho2qvJuuyNkT+EYcxzFWeM4kfoosRTxWYOLet5Dc?=
 =?us-ascii?Q?vDvGd5cfj+cqQ/CrO4JnB5cDKLIhPpDIGuP9fO0tj/mPbU/ve+xKe8wcmM9I?=
 =?us-ascii?Q?slXG8kuNTk7v8bNW60YSy32mkD4D0OUNcU3MYa/4y2F9v0W2X2Hi6z/gOPGS?=
 =?us-ascii?Q?7gURmQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	M+2TMIv+kvduv5MLkRHv9PBK04CKAi/5xJ0cYLMnEVGBQf8XPlGCbIr5+aG8Ezoom+w+PhxMWwWTV4/y78dnIFCVxSV/Ir9Qtzdv6TZ76Wsirn7Inqy/+vUGPRThOFyh7YilR9VYRsfnG6/nnyjg44ptmDdTa3I5+tFiaVhvoJhFIx+DWkcFcIkco9M2T0fB5UYasaMBX77k2OQ/NfwIWg/6msnnWt7QqgOMPlge0YOIf45SGhFJcJzYhK4iL+O7owMGxjLozTJoF3wXd9xOLKQv4r4XMPWYpe2nndMBCMKAQbfAtCT5iHfwNCicjX0ISx3og1kO6Wz5155JkSsHkqXtW3SOUykkHBcUCbaLnZzAQ2KD5qgp61T/VCLgex1wKnMLk9iwr0g5qvF2CS6a+9iWhFZz9hZBl0aWveg/lO7ed/JrYBdBAGRxJ3y4ijVSnXK3mLX1OAtsBjKODd/S9ylCbOYcksFwjnaTPn+W1czYjTfP92uGyt0Bpu65Z1slA8iJ9vo4HtbVu89EOLPR5WvgBBwe0f8d2eaKzg9k8C+//7AYfqrE8iAjxNw1o8jwv6w5uGPc5+qEhpiLxBDwF+RK867I53KvIWjbCK3nH8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd133ce7-1a9e-4958-b67f-08dc8f21c564
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 23:03:58.9440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3l4XOVbGNUuaX5jRtZKqyE6IZ7T70A0HCqXlOnFIzMOrNA4gfmO6RB9eVb5NrdNGNrObjjXaZ6SWmG+9v6LmthBCgkHcfhXbKtgT4D+2eDg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7398
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406170179
X-Proofpoint-GUID: Pqvd6yV0degdt0K2BfzMLcblbFw2BbPi
X-Proofpoint-ORIG-GUID: Pqvd6yV0degdt0K2BfzMLcblbFw2BbPi

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0afba9a8363f17d4efed22a8764df33389aebe8 upstream.

A reviewer was confused by the init_sa logic in this function.  Upon
checking the logic, I discovered that the code is imprecise.  What we
want to do here is check that there is an ownership record in the rmap
btree for the AG that contains a btree block.

For an inode-rooted btree (e.g. the bmbt) the per-AG btree cursors have
not been initialized because inode btrees can span multiple AGs.
Therefore, we must initialize the per-AG btree cursors in sc->sa before
proceeding.  That is what init_sa controls, and hence the logic should
be gated on XFS_BTREE_ROOT_IN_INODE, not XFS_BTREE_LONG_PTRS.

In practice, ROOT_IN_INODE and LONG_PTRS are coincident so this hasn't
mattered.  However, we're about to refactor both of those flags into
separate btree_ops fields so we want this the logic to make sense
afterwards.

Fixes: 858333dcf021a ("xfs: check btree block ownership with bnobt/rmapbt when scrubbing btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 1935b9ce1885..c3a9f33e5a8d 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -385,7 +385,12 @@ xchk_btree_check_block_owner(
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
-	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
+	/*
+	 * If the btree being examined is not itself a per-AG btree, initialize
+	 * sc->sa so that we can check for the presence of an ownership record
+	 * in the rmap btree for the AG containing the block.
+	 */
+	init_sa = bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE;
 	if (init_sa) {
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
-- 
2.39.3

