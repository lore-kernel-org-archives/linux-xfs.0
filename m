Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBE74772BA;
	Tue, 13 Oct 2026 08:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879359; cv=fail; b=Ib7E4nfA+GpQ4jAGIomj+d9qIJcSBx7C6oHHE3btnFYFETfEUZz/eCGbVVpN43PXv49Rm5IkMud5fvLrmu6Fq8GIOrO2md+SGI37boW5dKqGAs2zw9iykHckQCiy8Fm0gHqzHq9UDJItG9g/WyC8DDU+qrIWYhcAGgA0QXtSWVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879359; c=relaxed/simple;
	bh=rUbJ53z8Udoaq9ctCnM7otGaGvYjIBzjOeBQHLC0YRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uHcNHQd+4oK5jN6lHtnsAH9B0to0yIIAOJdnf+D303ww1KXYXSehxaQvyEKJEAjfhINB//EWSKm8UxGQzULmEMGI7E2twTDVDZcLMDI4pAyW2Kx+4H8v+TwjhP2CDmmF2gi5SM8OuZQ45uWn27SrUQQyK2uuzOvMmuj/P/g1Kns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GeFY6Itx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l+R70E6E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GeFY6Itx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l+R70E6E"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2EjtL3035636;
	Tue, 13 Oct 2026 08:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=; b=
	GeFY6ItxxZCDyIukeeWkpUcSZbpq1jo1QwRTu2xYZufnzWyKPNpLbd7uvyUoL5P1
	pdjBDVYpD9JZcrXhjF70hwuNb3cBDB5Y2k6COf5ki4G2PaFMTn7MqIJWfiF3o1/0
	pvtwCVA4d5CSvdxCEDUDKJrRlbaDnyYLU6CU/mHbpbxhL2qWnXTB/2M/MxqYI1D4
	/gRmECnoYDkz2y/vhmswP4d53Ga7sUJ2xfzi/ihzU6srSpnTXsUzLep8FgmyXF06
	p8B3xS6wDd+FCl1zw67MNqg/IoxSnbWaCnePod/Ma1FSmrPivwOAjkt8y20TBu+G
	X7sQpES6YDeW8IshR8TuCw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbjyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86PYN024921;
	Tue, 13 Oct 2026 08:15:53 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9asm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:53 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWP5JfqjHWVH6qtcTZL+3rVWQ3MlkzApd28+It8C9XDgn0IypmQkkH3Trpp0Now3uquWC8hdRemu1FFlNLpOKf9T6Ewxc4cpvr1ZoBw9ExbtL6yUZ8v/3oLyta20Nk0ifdYjelXwN3yQD+biEddtquG0ffH1HoFk1vzSECPBKh46VaW7JkkjIoKetCi2b4kK9LBTGhzKvj2DGtKJFmSG9YrVBZMo9ZR8HbyBT9320+Xxqgg8BtL3PSMYOoP1TJW8JkEcXX6PbcHd0hwSYbBrvhHwqZIiDVYMTfmAXVyOwhULYrNNBYkoxrx0c4jeekCPOydLJ0OQR8n3rcWd4yT9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=;
 b=VUDmjgQPYcq80iabUQng/X8jsFUmefEHxUZmAdrVbUugzPUlLRdABMR8fW/K44qRGut4dVhcXkszNKs2XHfj9M7CijiDi0dM132rzvaWBahtJZ1mmoezk9GBs3xKF2VfNVB2ZahbvdHxNbLBsJJ58xdMWGcx/OmktiiCCMR5Y8waVR11xzhPlwLI6Hz/6ReD8ARKEJFGQjGFi6uZcp+BaQK/tBug9T3MjgtdVgaR+7epSZa3SGQZaWvCaUCvFu4qi63KJ2bDLuYxfw9l2czXKYcOFG5isD5LPUB77y/hkQdTBVi9flJsFBnzQNftfJcJxaz+rMBJN1fuxYcTIRPVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsdTNh3wyQ6OA8DFrfSDd4s5dz5wajzOn141+cOVxbY=;
 b=l+R70E6EFLZ6RRevsvG9isTr8udTjVc1rq0M7SfORAgihsD0NB9bjneeRhR/OMCXDDCfqMp7X8m+zc6thNmJMsR2UW1ufQYPD+KKI0qZp0+AtOXPBEkVal7grRe3nfRm1A/M1Xvtk2yTk96mmUnnGun+shyjkVvtJEhdoHX2IgU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:51 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:51 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 09/19] xfs: log items should have a xlog pointer, not a mount
Date: Tue, 13 Oct 2026 13:44:53 +0530
Message-ID: <1d0b5f631acd7913c24397d61ee30f18f33df835.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: ba3d1194-4a05-4eda-0120-08df290231a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kGkmj3NCoM3AdkqRo7rVvOzyP/C3hXIezNapsaX/DUABBo0fYuOY7iIsIqc1Xne3kO3sSmST4Qt64AZA01U84V/XKlRtP5Q7CjiUNbYC7RZYJKGBaXUKxW5QCbt2m7OO4h2ZzBnS1mo0GMLhI8QiDzMwGCr8YqpbGFB3/HPWMNeEpwJWF28LoGA0XVy2qAfVEhfQheWOcNoYMXo8RiOX50r6IVR/d9frs4XchmyZUeQvPTmdlNif+TSMcd+C9sTxww51YhrZM+N4V6LkxUx9nbiOpFU7MJHem/1eaKDR282oN2IZhHunD0JtUSKaBsoy//XElC9CtHXxJzxxnjU5WAhObaxga4hinfshc2p0CbCN5ezfBQcJfeAjuWxO7cA84bNIZ0qMFwI0E5LOMepnSKWQKVjQA6glke7fOe2ZYPkwpBzK8futUQVviCCg7qM43w6SvQr2oAs8E2B3w8fZCEkPDz/fUdgqtMOgqOPvrFAGo5j/BtDaXF6Ar26NJBZIQP9XQrk2Cq+7tPsiff4GkLYksJl0fiyhwcn9iCzKY1xmogrVyXdK8WM49izt2EZQWwDe/lDYmTW9m+9Sd04Cm832NQmTnAp9lxJJ8Iuey/KoSY3OeSaU1oUMcrj7k9rnoJtrm/qZzdJ6VQAftvL/P9wcSFZ9+t5CkA0Yz7O+zWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2+62CrAEjs7o/FM15tDDusJ4xbBV04fmEVBKrhiS1B5G1WPctvWOutyCoZWo?=
 =?us-ascii?Q?EAj8Aq58CUXfvaziAWOt3c1SBdnuUpzsIJeXtLIK4NDR9b2GaBZ9UeSF6xmw?=
 =?us-ascii?Q?IRg4oQbEkF8y5vp1C6vMP6zq/nqfJedga8AdKEabgVILAtjRNIBOYw4MvEHy?=
 =?us-ascii?Q?hJWhbPqV7AcLZ2j+ISjVqs3Bt+I+GHhuMAuOjpF/PqZ+oiDx3skldkEva288?=
 =?us-ascii?Q?2Ya7PX2UPgKa9tsao78vJC7a1rnqfygAwbsPUzrtixbj8MytU/7JpJsaxnTb?=
 =?us-ascii?Q?iRJjHS94o8rUVirc8zaCdCYFkb4PTvqIhKgkBBFtfKfymvwLwe+TccKyaEPE?=
 =?us-ascii?Q?z3GjImM279jcl/HPUd53da34i/t2GyvwhlVeW6eKZkkYYwWBlAGqoxThodcw?=
 =?us-ascii?Q?3cLLjNiVuIy3ThjIMOREV7q9Clbz01U18HBggRbWXE3sjQAEreYivE4Qlxv8?=
 =?us-ascii?Q?x9p1owShtMGxBO5z04riwgwD+m441GiFwYCLKdS5sxHo1aKi7jpTCjVK4Oif?=
 =?us-ascii?Q?Nu0Ux7kT+dG8jWr96Rt30lHEvH/wwatY8VelgY8OOFrzAvsFd97fWI4s3Vlp?=
 =?us-ascii?Q?JfYmxLv8T8a/rAg3wruAuEUbxE/V7SoIxSFpT/ih1Tiq/0yRFD44DPocRd/e?=
 =?us-ascii?Q?dVVceHhwmhe0s7bqultCSxmiifWydRqcuYmeYvSjkmpsvqHEq7xuoRkpA9Yl?=
 =?us-ascii?Q?tMIf/myOXSkSs2fAqsrEA8GbNvtc8Jpq9XiFJGBDBt4D0+Ve4fJ1TURftio1?=
 =?us-ascii?Q?5SOW1/ucnD3GhLSqHJI/7JyDIsnGWVQyo+vfWf8kW4rp/pDrH8emo8YEVNCC?=
 =?us-ascii?Q?0+dntqvrh6BSEL7SDWd8PNDANJ3o/4WC8KT1RaUYw7VtMNZ5e6cGq9xRwOB6?=
 =?us-ascii?Q?lAKm8c5w7KPQE74EIPmXTL5Ys5F9QVvC0wgAl6boxoOzhs2aSPpOrneybc/n?=
 =?us-ascii?Q?lSEx5I12zVEZsalZ8cLxJltJiolw83Gk20WbtFG/FfuzOWk6dwWOoJzsHDId?=
 =?us-ascii?Q?idcuAteB0W56tjKAm8SKb9fZb/RDOdXJIyE6ddZ5mkPGycHsxrcJmceHst6P?=
 =?us-ascii?Q?5UnSo2OuFtnOLwdT+i9O9J9baRyREmYvuoZ26zzO55qiU/wAJ/1nruGDYn3R?=
 =?us-ascii?Q?WyoNoSXBQtsvLe52x3k9RKPV+YCG8BpSqlYIu3syvwXYoICpkofCJy6UolJO?=
 =?us-ascii?Q?DvcBWrXY0hGP4cr46brjuIprtIurk7tJYcPIAkDHecCCEEQy7QbtzhyLaQN5?=
 =?us-ascii?Q?OGsHf/nFuqJqj0ap/dzdAY20WltzYn6xNdKL1kjuxCl9CZHld4cg2Jn3IARi?=
 =?us-ascii?Q?4r+WuqCgncpCPpfIn6MoWWXEsRyX8CZdDEc+NoI6YUJT6YFM+yf3wl9nfZmn?=
 =?us-ascii?Q?91wp8oV7mBLF4d8YR3u2XO+KdbVIyKtQ0Z8GBw+l4Qc8h6xkFRGqGn1aTXXD?=
 =?us-ascii?Q?ScbsHeiupOE+iZ8RPZjkBDmE0vYq9zQ7Sqoz4MYgKo3HzSX9iLLa/LvxqeTc?=
 =?us-ascii?Q?CsF9iaP5Fpzkzt2ii/u/YyEBdXvWQyEbOf7g1ENayBJmhgilzqL3DN0dTCI2?=
 =?us-ascii?Q?vCKJluy3+/wCGHUcfx6VVH0y+r4e00wb4sKJVg4YM157KHyrte1JNBdpmN54?=
 =?us-ascii?Q?84tA/y/SHxiZ/a0eXWNrtdsRsIvnVtIDLgay/Km+sMwu9rxOeCK4rrzB1leW?=
 =?us-ascii?Q?tMVGKRqwhwmB4zneaMLQ8WVOH67Hja8y4jpzFAjoKC1urmFX3a+mY6lHcyGG?=
 =?us-ascii?Q?ZAIQ+dLzy5T4GayQhXystuTJOnLEJzJQGH8/QmOZUnYvAwOMRRhi303b6qDZ?=
X-MS-Exchange-AntiSpam-MessageData-1: vqhUeYB8b1J1CojR3kKhtD9SBVMboKvvE3g=
X-Exchange-RoutingPolicyChecked:
	jieNPx4R1ix4zB5n+1Aeoz0+g1rcLGVj1MkrydI5wmhV4bQkTqHY+P0DfczqpsPASgLC4eZGzmBeIuF+P1lV/M5GeTMNA1uCsOHzoRb5K7kNILRiaWshGyWNJOrvT0hX4I4Au7Od/YQIn8qck0OSYHa5EQhOIcbuZaGJpsu541BqyhV9jFwJWVkdRoKOyGX9Ilt07LWKaXe9lY3T9ZLc69bnEYcEXQKawLV41bI6EfOg1O6tSJkVemtVg8qq3c/IN14OZBsOTdt4AzSRnYSePul/vemLETgG3kgGDjhO7G4jlgNa/tmWfqdAoVyerfEyVjbaMGHrX6BkHw3Bin7fDg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uq30uxyOEkMFA1rhZmQJwtAumPWb7GYVmMurQIq/ShU1RYcDHKsT+07XQQL24PWZku366q1xAYHLYnVRvxfZqeDLbbxdleekGEx+JCACukvQpSQWYUHaxJvqPP0R+TPdfgyJufYLMpVw06lUMbUB0VsfDGNLg+ACv6MqsaHUdQKmo25qjpOGL6B/I8BIO75fJb8oL83Rzkbr9BdHieAG7W8Zx9uN2jfipeRaLXnsYCyl85haL4hdT+SncCAjGq5SL6LjiZbAVGpoBbglHXY736Nv15Il1he/p5O2N7YluyNOn5VLmc1HKdkamBoyn7ZbaqRDbDmSU5x1PwDxPjk8bzHAwONRswx6+TUvDey1dyr9WVBl7hPPcPNCdPI+hJAK+OgyvY8aITUVhVb9nXkhlLsyn+PhmTXbIaOGw7J8S6BeTnBB8KNtSCgzXLH5v+MNcsBUy/OGvfcDHrz2lCPRrixcPiaFVg9cUSKK6nqDxwDt/LLsbTMu/q54mnbeV0/KSisWf+sb+lDWpftU6JtC7ZSYUMePjecgzp9zFtdmMTNBraJB+MyvjxkmdJgvlr9fPzC0IPgtXirFEHfljKpMlIUf5Ep3ZWU9yLPOgySPDd8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3d1194-4a05-4eda-0120-08df290231a1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:51.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6VkIW8IGNq+XxWP4SIu3SgjT9TNVmgQ22LftE+tmcy7fdejodFcYPCCMk1nmUxIRJJlQ0IztvaV7aX85/9pT/vZ+QYITOUFoIPDzYmgfXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXwLhp2CojEhBn
 ZBphEbyexMYwDrLXhK7Rr8Q7h5YfVnS1xPRlxCS3ecbGNMta//q6Xmikn6dRGn1kH8Uio9lMmTg
 +7dQu+JYapxJmTqhy4qknG6dM95e5xbSSIisjaS8WxGJm6K4cC/3B5IGgNlBQXM3qXLFbkR+R8c
 iVE04xQVkUZmfiykSQ5l65XzxBFq3ZUCi5f9F1JEi3h0DqlhpaDHO04CEuzXewgzSvZ0KOMlBt9
 sl9ntUt+1HbWUzo8XGdg4r+fZRuizgVZC8Y2crnkpuqWOUpNVbu38sw1Pzn3+NZNEmm4aW7u7d6
 gUNyIO6nkarv+Ur3VQBuYd68SsOMrw3/uRQ9l6TKl3pboDw+PGnNJoisJdDfBOGZ0TOR4RkW03s
 Tw4CvRQrTJWFT3VG71DJOqfdWkuaYFuygdP1dwYkK/OJ3uex6Xoyw3kw4xGzr4e819kKuMMmQZv
 73L/BZDGTAJnMIw5Yrg==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acde8ba b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=nZXUwzawmNCwDP6AOoAA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: nyXKmDSdNh0nDqgW1kEV9psc7iHJXxoI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX8bHOByEOjGDw
 /Vu6DQl8PAq2x/bOC4lkP9+gqtQvkdlmKBgt49qEpmsUIIRzVRS4gBTUv00+TyCY6nPmszHVWXT
 sqJQgOBBpw++jIJdLYderd5AX7vYsX/QTQbUeBvMAw0AwLvQRetB
X-Proofpoint-GUID: nyXKmDSdNh0nDqgW1kEV9psc7iHJXxoI

From: Dave Chinner <dchinner@redhat.com>

Log items belong to the log, not the xfs_mount. Convert the mount
pointer in the log item to a xlog pointer in preparation for
upcoming log centric changes to the log items.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
(cherry picked from commit d86142dd7c4e10e50bdb3679b405d748214b2c28)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")

5.10:

Fixed conflicts due to the following missing commits:
        38c26bfd90e1 ("xfs: replace xfs_sb_version checks with feature flag checks")
        75c8c50fa16a ("xfs: replace XFS_FORCED_SHUTDOWN with xfs_is_shutdown")

Extra conversion in fs/xfs/xfs_dquot_item.c due to missing:
	40b52225e58c ("xfs: remove support for disabling quota accounting on a mounted file system")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_buf_item.c      | 5 +++--
 fs/xfs/xfs_dquot_item.c    | 5 +++--
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_log.c           | 2 +-
 fs/xfs/xfs_log_cil.c       | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 fs/xfs/xfs_trace.h         | 4 ++--
 fs/xfs/xfs_trans.c         | 2 +-
 fs/xfs/xfs_trans.h         | 3 ++-
 11 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5f1c2fda8e4e..70849a2bda45 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -474,7 +474,7 @@ xfs_bui_item_recover(
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
 	xfs_filblks_t			count;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index deb69740d492..132acdf0aac0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -21,6 +21,7 @@
 #include "xfs_dquot.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 
 kmem_zone_t	*xfs_buf_item_zone;
@@ -347,7 +348,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_log->l_mp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
@@ -535,7 +536,7 @@ xfs_buf_item_put(
 	 * that case, the bli is freed on buffer writeback completion.
 	 */
 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
+			xlog_is_shutdown(lip->li_log);
 	dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	if (dirty && !aborted)
 		return false;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index f2cef1470373..12b265a630ba 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -331,7 +332,7 @@ xfs_qm_qoff_logitem_relse(
 
 	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
 	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	       xlog_is_shutdown(lip->li_log));
 	xfs_trans_ail_delete(lip, 0);
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qoff);
@@ -352,7 +353,7 @@ xfs_qm_qoff_logitem_init(
 
 	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
 			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
-	qf->qql_item.li_mountp = mp;
+	qf->qql_item.li_log = mp->m_log;
 	qf->qql_start_lip = start;
 	qf->qql_flags = flags;
 	return qf;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 11474770d630..632747305463 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -588,7 +588,7 @@ xfs_efi_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index bb57a125eae5..dbe5c9ecbebe 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -991,7 +991,7 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp;
+	item->li_log = mp->m_log;
 	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 407e80d06bec..f9c24bada01d 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1181,7 +1181,7 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item	*lip)
 {
-	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
+	struct xfs_cil		*cil = lip->li_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2532a2a1cd59..459d04320c6a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -463,7 +463,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index f248e2b0ab5d..132976ae6888 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -516,7 +516,7 @@ xfs_rui_item_recover(
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
 	int				i;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86951652d3ed..2b7e6322ec66 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1169,7 +1169,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
@@ -1222,7 +1222,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
 		__field(xfs_lsn_t, new_lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d334bb3ce643..4e1400ea6a99 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -644,7 +644,7 @@ xfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_log == tp->t_mountp->m_log);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 97485559008b..f1805119a1ee 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -8,6 +8,7 @@
 
 /* kernel only transaction subsystem defines */
 
+struct xlog;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -31,7 +32,7 @@ struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xlog			*li_log;
 	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
-- 
2.53.0

