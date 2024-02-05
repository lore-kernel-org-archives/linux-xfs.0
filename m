Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC604A9A5
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171620; cv=fail; b=fpo1ra2dHdKEcU47DEu2K/DV7KXUeM06m7no6GnU/Hu6S5/UoDO/xyQ/JAGEX9eAqOhg0vHBNjBS8xmAjoIxoeAVFIV0hqfgE1C1os2aRH1C8ov42gErLb5hNDFozyeW+IwdBFWEkK+GW/YIdnmNvTxXouy+NxyLN1BjWRbhaQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171620; c=relaxed/simple;
	bh=G4s8hmF79/nIqZlCkO+E2+1uKWIYbvDkWTNOHM+CXr0=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=nqpcbTy6XDWiLR7WsNMf/JLPN61YqnUiKkcew7+r6FHULf63PnWh0U5dDEjechgonQbSGjz+sdl8o8Nbs4IXsvL9bCkj9WKYLidh3nAS8Tlw1q8D5BwcTDM1f3Zg7PIB2sgFxbS/NjKLbdXkr/NcytUeKugduMSM/Wv1BeXZW1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N+C9E6Ld; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=N1QKmVHy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N+C9E6Ld";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="N1QKmVHy"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFnWW018433
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=aHP77EZQ9aONuq3i+ENhH3gHPNVVBxvlCOa44D37MxI=;
 b=N+C9E6Ld7m5y2Kk/O5bLGUZ3XrYp/ajBeA10uFlCzoHRMEk3qLUT7mcpcdv4WTAFodpl
 meOGOw6ojSvfzb5FcxUec3QRgCwmfAkcyYf1QSUiGAaWbGzMmcsWC3Dzx7gDoU9zgov4
 XdqqAzkYqguozJ57GF3CdBL3BI1oPuoaGBJiR9Y/zRBA9uebOPpw8ybMhzjtRpUGT298
 N+J0D1cR4ot8myVzqeL7UG2Jbe2qv5uxELIJhBtUTGw029Z9n9R/zlpGAHFCDhRUQuf3
 Q6Lx7ccafT7qAY6C83T6/nS9EcNE327lgeWtMYKKC6iFWREt2eq4EKxhl93IHhfPzw81 dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdcw9n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415Kdkvj039547
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66756-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbbWYI5A8WLFTZ0eqZoLWgctVa8lt5Etg0DaDgRzW226RqyrAjDoDA4gQqVtwkvmbacM7chvgRz8VH2LfZm2VBqAu7wp9UCyqrXc+SkqBrgko6O2ldr5IxRBp99nmdMuWh0R+nzVg7pGJZGm3pRpdBJVJEcQxILKDfBu5/YUwMHuEpDD4WSbudrvxl1t7oIkITaWfHQIYlqddRpwsbWHbkMDyffWrnMAX/hFX/xuAA+7vNYgEOEkPClZ8Y8mKnNBp7BoOPRnHtrSGYC41FkeykG2UMNZfrDxE35ycsK3TJkutwmW2STVstjI92DXyoOJyb448XrB3YU0I3jmWF+wYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHP77EZQ9aONuq3i+ENhH3gHPNVVBxvlCOa44D37MxI=;
 b=T4JMGavDsZnjDF3jPxkyLTUSzOxtmBsoJBgxw81uM3vzzqS+dFyZsbLnlks5mqmAS4d23Wemxf0QjTv/WdNfHnwM5cxlish9kgclYvioZXQa4azwANDRkRXs6ZfS4CvCsFWKt6m0gT/zHfjM0f2E4qmMQ9EVonIg1viBOcJJ4C2wSvb7nwzileGs9eD4sp3q2UuKzFX92VGuAKw5sRtf9tTHZgd6O7E+wlj+O9UrqPn6yEIQf1rCxdssNn8PGRfgCj8g7uzEbRyg5x8ouB242fRhBd5MjNA6NV7PdlEXOI4TYVSWwsZRqHXeh3W/Pem5GwNqj7q91eZsxuDunRwl8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHP77EZQ9aONuq3i+ENhH3gHPNVVBxvlCOa44D37MxI=;
 b=N1QKmVHyWc1NsHoERwU7XkrTOrZcedwRgpUYWvjjbJWzcsKJIRfcwtpwdUaLdwecgwZH37OMX59jQ7m+OmdEKFAkp6b6Mh+cTLPwuUXbkZ4QL6V22D4B6M0F+nNsxaBenPXD4ugG+9VdRnZuH6x6/ZVWmy+Mymmvz714irrVaLU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BN0PR10MB5176.namprd10.prod.outlook.com (2603:10b6:408:125::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Mon, 5 Feb
 2024 22:20:14 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:14 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 00/21] xfs backports for 6.6.y (from v6.7)
Date: Mon,  5 Feb 2024 14:19:50 -0800
Message-Id: <20240205222011.95476-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::6) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BN0PR10MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: cda89675-5a4b-425e-32a4-08dc2698a044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pV8VihLSRf6nRz4l8eFLNeqcZmRV46keOze7DGR56oFd9/YsRlldl003q2E4K3+dNGghAx1J0qvNFS07HMUj8lee4WQE6g4uSfVoCN949c/bmOnxJab076UEKze3mtEJSjA4d67f7zzUy4JeKuQatVYskPFIh5jgJCqsCu2Ke8ZFBIMI2oA6YZHdBdYTxP7X+7OpqCJ9lo9ByCnqUiVTBuKNmakzzJWiKI1h0JGyjnFvM6Co+VVeWYmRf7tOYgL7kqZmK4hnhp7YcgAmLZssd8pK8stRe730cdAIf39j+/UsLckGHl6LQvALud4ugD6XYU/i3RjRNTzghKShI5j1EWww/9/K28qYF6gFSjIxFatalxEdcIEt09rDIsda1ZyPZ1zwmkFgEzJ8UU6uuTmdiRUQxWHrGQGY119RryhObGM3sojnmbSTh6P2Qy0RlfaaEP4XetfQQHOpLcMo6QNB9S6AHmzl/1Ay90wlvUAh5+WMnx34g9MAKoXIky5db80o8nP9wjnvynfcF1nYieycY0Q0rlhJc22u/Is+Y5Mgc8L4Q3vbnyVjRRbtDd/fxKcs
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(6506007)(6666004)(83380400001)(41300700001)(1076003)(2616005)(86362001)(36756003)(8676002)(8936002)(6512007)(2906002)(6486002)(5660300002)(66946007)(66556008)(66476007)(316002)(6916009)(478600001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dE4vdklnaUg0MERmMHBWaXljTjFCcjVsQkdpbG81TUU0T1ZxNnRoYTEyN0pn?=
 =?utf-8?B?WmZEbFlwUzdyT3lLelZrT2ozSXYxS0J5OUVHM0liVUZTWGFqejk4RHVtRE4y?=
 =?utf-8?B?UmpOYmgyclExUWY1N3ZEb0ZRU2lZS09ZVGdzSENlNGRYZWZYQnVZYzFwWURw?=
 =?utf-8?B?dUM1WjQyZU1zWnlUWmo4dFpWT0hkWlZ4Y0RLbThSZ25vS2J6eUZ6VjFQdU01?=
 =?utf-8?B?Q2haaXY4VlQvQ2syRFY5eU5Uclh6bUFSa2JPaVhoL0NJY1JJQkl4R3dkWi9t?=
 =?utf-8?B?b0tZa2JaaUcvWnJ6Y29GZU5KeStyZXU2Q3cydk5VQys4bGxEUkJuU3ErOVY0?=
 =?utf-8?B?YUJNeTBXQ0dGL2lCR3B5dVlPS2trM28wK0VkRHovOGdrL0trMTNsd1NMaXpr?=
 =?utf-8?B?SEFHbkZUQXNpWXNJcmMxNEx4cTFhenJpbEtJdHh0bE1jN1hFeGNIT2hoZXZN?=
 =?utf-8?B?TUpxL3JoamUrZ0tRYUdiZmNRamVENzZESTdPc2IwaGo4REJXVSs2Z0o1b1Rs?=
 =?utf-8?B?WkhqdTVWMHNhY1prbFhXM3FRZmh2WlBQUDlXak9oNXBqY1c5a1h0a1BRcFB6?=
 =?utf-8?B?VHpMQzMvNTZWSmhXT2F0azZNK0ZaMi9XbmxDMVYzQm5sSzZWVHFqcGo1ditX?=
 =?utf-8?B?UDgraEZaNG45TThicDR1YVp1V3BsejVCV2E5WVd2STZiM0ZmNVVUSzV3QlB0?=
 =?utf-8?B?RkNRUytjMTkyZG96RCtJd1h6SGdTcE1OaHdxSFViWmVwb0Z5NUpYTUQ0cEs3?=
 =?utf-8?B?R2tsYXhjRjdiRW1Qc3p3SERBVWJMeGhlSDQ3VCtHc0ZRV0gwNHpuaW9Tak5i?=
 =?utf-8?B?L1RlRVowbGF2b1FheHJJdGtwOFhFNHMzd1FidDk0VG8zdkpkMXJibkNpQmZ3?=
 =?utf-8?B?WklRVktXUDBER2k4TWJ6SU9uVWZydnNBYnVIcDZKakdtaFViRUlhTlhOVDZr?=
 =?utf-8?B?Y29VdmhaZXpmZGt0NTRTR2U0VytiSzFGUU9SVGVPYkt4ejEvYkx5NXIxYnUx?=
 =?utf-8?B?b3dRcjVrZWozT2JKZE84Z2s5TkxBV0dQcWNmRG1GRXF0NVo5UVJwWEltdHNS?=
 =?utf-8?B?aXVWelJsaVY0TUx0T2puaTBTb1A5eC9OeVE1Ui9EdnhxS0hQczhZelRQdnFV?=
 =?utf-8?B?azFZNXhaeG5od0lxLzIzS2Z2bitrUEtDRXhzRE1CMDZDN1EvTHppaDdCS2lK?=
 =?utf-8?B?YnJyS3NRNkVVd3Zxd2FCaFFEN1FxVFk2Z28xSTFIV2MrMDNWVHdCbHZNK3k0?=
 =?utf-8?B?dTFwekNydlNtZUVhQ1ZydXkxdFROSmhZSVRJVnBvVDU0NkhwajFUTkJxQjVJ?=
 =?utf-8?B?OVpxS1ZzdURxVVVIUXo5bTE5a2w3TzFnTWszK2I2OEhPd01pWEhDNlozV2pO?=
 =?utf-8?B?TVliT3pMbWNINUtxeFZDVjNKSXZIL2NiMHlhbjVJa05haVBzNVB4N3NxRmN5?=
 =?utf-8?B?b0wyVjc5ZEs3Vy9KTUZJWDRyL3UrOS9OY2g3OVlQVmFYL202T3I0WDY2bkRy?=
 =?utf-8?B?cUdWYXh6WWZVK2NTT256KzkreDFaczRFVWRBKzJhcVh5ZWw2aDAwU2c2bGs1?=
 =?utf-8?B?UjdCMDdxVkVtTnN0Y09IdlpzNzc2QW1tNVBQNWlWc0FMRmpMdU8vZ21zbGRt?=
 =?utf-8?B?bk5RaVhhSWRibEg3Q21zKzVEK2VxNm80UzNjYkxNS25nMVVtNVRpNmljMElV?=
 =?utf-8?B?RWtkVzVaY1NvQzE2U0ptNDBPMythVTZsOEx1dzh3Y2JSZlE2YkMwNy9wYlZ1?=
 =?utf-8?B?eTBTVWlwTldTR3pyOVo5UGloTWdDbk5CTzBweTU2ZS82a0hYbnRlTU4vZEgw?=
 =?utf-8?B?SDVKTmgyYkw4akx2ZVNLWEFHM01kSjlxQWhYT29KRVJZbmcvd3lNbm81Rklz?=
 =?utf-8?B?SFVtT3cwck1YaThwNzRvZGlBeWZaWGNYMFBUNkFHSkRYcnU5K0RxSGJQOGhm?=
 =?utf-8?B?NEFzOEFIMldNa2ZZYjFodzBseXhEa2VoNmVwblpNUXlsQ2VOblc3a0N3OTBH?=
 =?utf-8?B?UllBT1d0a1B1dW50SGw4UGg3NDIxcXJ2MmpmaGNBWlhnaTJ6UUZMRmNPaTh3?=
 =?utf-8?B?d2FNeDhkajROY2ZRZGxFYlM0S3lvT3dWcjg3ZTcxNVc2NktVbUJoZzc5Q3hE?=
 =?utf-8?B?djN6cEcvS1RSd2Jnd0hrUHZWNk82b0xxTzV4RU5xUG9vQnRPWDc2OHVMZFVt?=
 =?utf-8?B?MSsyZytuS1J6L1A5QjBqUStqS1Y3WTFvYWJwL1pNN2dPTE1sdVpFT0JtSGox?=
 =?utf-8?B?ZktOMUZDZXlzR043MURWOWpKd3NRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	B6NRhO6s+yobzI+M/pkahllOMxvjdWVzhvuVA+tYfJ2U+P2iNFGCuiU5Kwmr7P0tSKe+q29gmRUkhNPOA5P8pHunWwONPfaVBkxshsYgYk7ScAgfJpAigTitd7aeKkOiLfUmm+3jqUv82QSlak2+CqV7dIC6ngxqjBYFB7YvlbaPRuVccTKWh7Bh/5SQ4baxsDAaKQJg976gcQNjPKZcsQ4zg1HI711tqy5bnJjTQEt2HZ0nuZfezLZsZwmHMpiCnbkZGrY/0XAz1hzzXTKG/6obA1Oy4jMH86AzpBaleFFBWY0DSWT8V+F9ipjn2AT+P/JV9EOFiwVhfuDyiDiKmEuPtJn2Vh5oVdzK5rmCzUW4gxL1tgNkV6rCo1LXL/wGUidM+cRU6RbhfZcUQwgnXFRiz4mJpCP8uBSNRpp3dIx7uzutoV35ap1iRI0gBL5zEwQ34MwHoD/tIFVBEDrf+gOgZVp85w9Ekaq/2QiIfQ4hW3IJE8BesyOnghnjKSEt8Zz2BCvCp5H7RwonhyzHZcaMg3t0UmzxOsJwoiYwFOAEpmTkfoYi1GNDAt/+17jFV4xwpO0OmxTJyDqegl/peiHPkCj34vtig75BkKFui/c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda89675-5a4b-425e-32a4-08dc2698a044
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:14.6544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiiPah970Ji/Taz/JBgPFomg/LNvdulU/yJqiOBEzQZJK9ysk5b1r3DzeXvLm8RQRTebus5XcdbcyYsfpBtC805MGcVm+hHcK4kAMH6wgE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5176
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: N6F5_temd4tdy41w8LZIX4fOeRRgKg8n
X-Proofpoint-ORIG-GUID: N6F5_temd4tdy41w8LZIX4fOeRRgKg8n

Hi all,

This series contains backports for 6.6 from the 6.7 release. Tested on 30
runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1k and 4k block size)
4. Reflink without rmapbt
5. External log device

Changes from v1:
- add "MAINTAINERS: add Catherine as xfs maintainer for 6.6.y"

Anthony Iliopoulos (1):
  xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

Catherine Hoang (2):
  MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
  xfs: allow read IO and FICLONE to run concurrently

Cheng Lin (1):
  xfs: introduce protection for drop nlink

Christoph Hellwig (4):
  xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
  xfs: only remap the written blocks in xfs_reflink_end_cow_extent
  xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
  xfs: respect the stable writes flag on the RT device

Darrick J. Wong (8):
  xfs: bump max fsgeom struct version
  xfs: hoist freeing of rt data fork extent mappings
  xfs: prevent rt growfs when quota is enabled
  xfs: rt stubs should return negative errnos when rt disabled
  xfs: fix units conversion error in xfs_bmap_del_extent_delay
  xfs: make sure maxlen is still congruent with prod when rounding down
  xfs: clean up dqblk extraction
  xfs: dquot recovery does not validate the recovered dquot

Dave Chinner (1):
  xfs: inode recovery does not validate the recovered inode

Leah Rumancik (1):
  xfs: up(ic_sema) if flushing data device fails

Long Li (2):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail

Omar Sandoval (1):
  xfs: fix internal error from AGFL exhaustion

 MAINTAINERS                     |  1 +
 fs/xfs/Kconfig                  |  2 +-
 fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c        | 21 +++--------
 fs/xfs/libxfs/xfs_defer.c       | 28 +++++++++------
 fs/xfs/libxfs/xfs_defer.h       |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 ++
 fs/xfs/libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h          |  2 +-
 fs/xfs/xfs_bmap_util.c          | 24 +++++++------
 fs/xfs/xfs_dquot.c              |  5 +--
 fs/xfs/xfs_dquot_item_recover.c | 21 +++++++++--
 fs/xfs/xfs_file.c               | 63 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.c              | 24 +++++++++++++
 fs/xfs/xfs_inode.h              | 17 +++++++++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++-
 fs/xfs/xfs_ioctl.c              | 30 ++++++++++------
 fs/xfs/xfs_iops.c               |  7 ++++
 fs/xfs/xfs_log.c                | 23 ++++++------
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  5 +++
 fs/xfs/xfs_rtalloc.c            | 33 +++++++++++++----
 fs/xfs/xfs_rtalloc.h            | 27 ++++++++------
 23 files changed, 312 insertions(+), 102 deletions(-)

-- 
2.39.3

