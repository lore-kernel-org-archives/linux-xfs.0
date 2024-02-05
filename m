Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D414D9E4
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171651; cv=fail; b=Q/knsCobyL3HIFu2Dbu+LqjXrJM5yh1z+uYrNU+mwwXc3nu3r5nXZ6O2QQWmJBE8edJqtceR3JaendkRUhuTmgMbtYEJxEjKyA5T6t7v+QmDi8+UmeDGKce3+V7mWPN1ZyYT+nO9PWI6WJL6ico9Eaw5nlVgNvJsyklMptE8l7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171651; c=relaxed/simple;
	bh=QGNaP4SUinhs+aAR8gx7RywonLkJKijV3dp3+AJOmhg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QfvLF0zhmYwaing4v0YWtHsRNHGHNoEpW1ynDx0ScShWq2Pqofet0RYEJJ4wIo8OydzOLsgacAGWSSINAne7Yq6FyU3nbu1QemAWAnqWcCO7IFiZyWz3x6MUPpX7Kt2P3g+fFm4hNlTlAVuUInD3+W6Lj0NDlYCN6MMo7gY7G30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MCe9b8V+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MXNEJpRF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MCe9b8V+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MXNEJpRF"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LE3Vw004468
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=MCe9b8V+iZw1R3CQcIFPpy2Jgtz8jN24wCmC7QV2mMNNJENuWDPW87ymVhWUeS2wVdtN
 dQRZLO+6NnnBgwh5DNPXE/F2fvN/PrQxpvUG1CByndkDwAHf9oqH6LO+J/Ogb8OszXab
 lKCqks2dP++UTshBWcHDiT1sfJ8ttvbsXSppq+lFar4bCMhDLpBfWtpk1/oYVsgmuXif
 OSnEe00uKG3gNXzegD/I8H2zAxGyESn3bM3W+OMi7Ricj21UKPP1BKqG+caupSEj/UYi
 +9QgH70D6wu/Zq5MhLffkWI7Wwzj4dqNh+IyXpbpU7BNrTHWkU206q8hFOHZo8iSakgE Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1bwen7m1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFZYU007100
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6k5uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvEVNkaT4BZ6DB0ed2+mRla/dzv2uQ2lUnTQKo4QvUxPeHD7MlF2yj1ZuHlWxRxXByYF7fhnVlPl340hHyOJnfzluu4AeoBt7fe6tubiAisKc3VkomdunVTXiAoYpNC8LrfXtzWw4bfgW33iM5/qIVMiUot76qws2yjdGag7lZECwe+EpXpLgfRt9o6dmKWSDXJriTwdMsym6hJbJDMgt2lexfzO/f9guYkLhY3URIi3tWgLrdARudm1MbT7289k9fi/nj5n3r3ePUAY3m7ixOPW39fPm7KHwcDBQg6nkPBUkl8/I1w0OCS2Qe/7Pl9ZlPhxyEHiO9MPXMLkYDWnlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=USDTn+tq6RgJ65ODGJcq4yVrBKCVp9T4LUv0ERJiJQjM5dLYaXciGgT5dEME0yNYf3UsmSeq5+Id2IEkNhNPaWIUc54u+JuZVKTuzhu4Qxj8fI8RZMcoHOCO9TfLvmkj8AUiROWLgpPbRCNg/oQ4GeLprZZHqurYZ7I2j/obB16J2GJChBVxBoXhJLYsV4fYmImt/ObB/q8Vc8B0lF1iNMA3/sephunzTie/I4tsEKjLtSQ3Uh0Qlb0sP1xqXY158h2pwiyMdDMcYWLawo/9zBFvEjWsBU9LaOwgqPdgWRzx3EjXL7xaYbDtc82VhCBmXQYaqdwxH4fy5zvgj65HHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3C7l7KSxJHeafQcIe+0S/PSdCveKAoPeYuysjY9HKYI=;
 b=MXNEJpRFfbFYKjKQ7eZVgmH2oFWqv7bdUBJxWnfZFNFNwFDzTzSenU+FDU3IMe1mTlbqeId9o65mihiDnDGzYEHWDGwCzRnrAT5vtbhWkcWdqxzeCiMWxHXWvcS2qT/ScS/R8HXWcZ6MFZtf7SHkfd6/g7lI+sxfKtP3LKofS0k=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:44 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:44 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 13/21] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date: Mon,  5 Feb 2024 14:20:03 -0800
Message-Id: <20240205222011.95476-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: d84688dc-30a2-4307-3902-08dc2698b21e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	K19CCthZ+dhiP3TkqtR4dDz9Fjr6yYk1HLyVVucKmUvkb5Y30ndqaLnMQRHxsLk7G2nh6x3KfakTyAz7oU0TcP2aoG14BfVhNM8qovJNJPvmage7txj7ksTOTGqhN6AVuIIyxK5nCW8+d/FALyfntVDEWqg9AIB2mMkhk2wGWAYMQjTLQdpUNA04NYzJSj50VQPiR2SBC/YmYPqhy/89hu51T81Vu95bUF+mv/Sb4PkoxdT1O/7CtraAuKr5wrm/NiVrMSfVVqJcliziY2BdGk0s/qdkTW0zdGyOcGCSvAZblApl76F3O631xZsgDv0HG9c3MDTOIHXPQGBne10DpJjaWMGq6TKqTj2BIJNz4/kLygW+kGq89Nw+a7zdpftOV5nwyRKz729kmCfOH9HMUbB4AGh/U61hXYoq4lOcHoUt5EVze2CCmVugay5nBsJ9lDlPlM9P7/Tf5bpoWKofXav4/oUGFXaBFyBkGVVdxQBUBPL5ncDRo7O1op/mruzxqkqvN2JvMydvunqac78NqauMduvpPbvCXZwqx4JBG2Q464YZSrtDzCNFsqlOyXa9
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LLhX7q/cO5Kny2jv/37NbS1qelDYCZmJtL+A9Yp0/1qk4NhMNVqWJwd+mve1?=
 =?us-ascii?Q?qWAuFVuP8QGYps2IRdPfUJYbdwYTsVEXWEXrCPoCGvUq4BtbOzY2Gpv7os0u?=
 =?us-ascii?Q?EAjT3fyw+FgOOKLeIPKor989ttDw2ent2aK32v3A2NvI8nrJOt4TKiLn9R4t?=
 =?us-ascii?Q?RwR0CXg5TzhiXOCTZ03acASDfyaRKir4zm12vZCL0DbQRdGFRWg0UHivpBdB?=
 =?us-ascii?Q?SI/W9v4eS4RkzlF0WIqL+CVYj7UCjr5+iY18rbYv1ZNMA+oL5FwLR4/SOwq2?=
 =?us-ascii?Q?cje8GgWPQhAiANkFGmN9gpTCZSdJkd0KDsGfVIFXjFhuIaiPyBDgnpn3aSd7?=
 =?us-ascii?Q?lZLKUjXYHRrWtcnhuRhctuGwveTkiK5pQIIFLvAqf8qESjSmusNPE01Sdxn7?=
 =?us-ascii?Q?9KK7ArWX0BRfhz9MOHyhBa95MSKtqY/0UUXlhN40c2EPOPCwcrJF931kJu4B?=
 =?us-ascii?Q?QjaujdH2qN1DT4+OGtAphS9qrGVCjesISXi9f8FMarhhZi3wSQcmA9gqY98+?=
 =?us-ascii?Q?3HwjEiw4srnbfgM6j31qY4DPuMaNRv1TEgYExBT4NTbVAZR592oyWV8y+HJX?=
 =?us-ascii?Q?sbonrzuXssmFzDABynrr53x9S/pJmKCsLYzlT3N2uMthebMyDSZFmu9Fog57?=
 =?us-ascii?Q?iPwgNFWmY5VRpPfvmUo3YlopBP4z6ZNve5FdJNrLDWcv0SMiErI3B6xPGqIC?=
 =?us-ascii?Q?+fbrlbQ+fBcYDbnE5ruzpY6KxcwTTu5tJTB0gbdas6gt+KQRHVKwc7SkTCA1?=
 =?us-ascii?Q?IVCglqlxC/oKBRsO9MUixb+y0iPEYNLabOtKkPg8/V5Q0/BrRCLMuGQnmOW2?=
 =?us-ascii?Q?6YAnk/wsjvZ2JtELVwTOeYEy8dF1upn1FrgUazXQUXwDHTMQmzdb16TB0t2f?=
 =?us-ascii?Q?BvNUOd9yCH11jxmhMFej7FGPmBIXH7O320HvjPweH833syT8bjStViFX5gW7?=
 =?us-ascii?Q?rx6qX3povguErJ9Mx7zu+7ovxbKXYCrY1qjlCN/CjZh92ER/PKQCfBP3QUsG?=
 =?us-ascii?Q?5/b0AIVG9BuBGUtdYDpJHzfQCdF+wYD6hx/x4LvXqY55bRMlCdApgwiLkKDn?=
 =?us-ascii?Q?+4eioVgdthw5y4lz+cWoQ2AmEnilSW1P04EdDpU5Hy9Emw/vQjque1nczZi6?=
 =?us-ascii?Q?zdUS4fZ2Golo2Chqqz2dNwqm6dyKuHGv0Udeolbj79Y92seNONYVM2iPMEvf?=
 =?us-ascii?Q?PNsdH3X3atoa4KhH8EkCYws8TrDyBluGt/5uRmCqDdxz2/fgA4cJp16RpGp3?=
 =?us-ascii?Q?eXkXrpwlElhODYCXoieINh5s2G+AO5SqYAXx3BxGx1gAMLZH5nVzUri7Ygwn?=
 =?us-ascii?Q?ATAea1El7zTH1Oel7U4Cf3t08Fy/rsV0xtPEA5OYi1j/ADf5SH0r5FMogriD?=
 =?us-ascii?Q?wpbx9kevUKSkFoYKLnddIOOyC5EL0qDeenmESXNq7wlKjxGitYg5+6Vq/ycO?=
 =?us-ascii?Q?GKLxKVzsBSMkOmrbRSMmVw+YJLnDpaIZJ9zcimwsDMvSF3mYiu7fSzoUAMU3?=
 =?us-ascii?Q?62jwFvjCqqWIqN23rQBo6araEX2zNmklcHmoJGMovQ1kI6wWIV/TwYM63VUL?=
 =?us-ascii?Q?RyWpxZUeHTekV6kRIJVrgo/wvoMnjUjsD/6xSpjV4IZ3CDaPhdfx0uAQioh2?=
 =?us-ascii?Q?SPcCTmKgZzK3qlO7SrJ2hgDZB0KzMCDkjpB2/u08DJpv6tsPIQJXVdn5JZ2y?=
 =?us-ascii?Q?3ddQlw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QgIdkaD9m7MIafRCo3JaPO9vBZw34h3xxO35XjUjliAHVjslqBHJPSg6vaz6S9vZ5+0JSVdC+B7BNStVs5smuqYYU+iSNRIKgDy+IHudFodTKy2eKhUjwKftJ59+5fDZLbon6nt7faO3gO4v0m3Z6IWS8LNrW5XMCt6umYewbkgsoeD6XlT4TLbf6fpn/JcMzzPAX2VCNXmtBhp395YPgxVT1m8ObByuIFDohp7rp/62Lh9Lxj/0p4lKtmqtXOObSdt1BGnbcRV6JinApu1X32KqLhzjzAryqwB4RUzjhPnZe4cPle6B0Fbhlsjez54uTgnmY9rBJYmsRMYzrxuBxN/0YN/txh9WFLZqW+SHUaL9tFBAu4s54htlB7Rdh8wKAcDT2K7K+toVb7KF5rfnKDGH6Z+CN2pRdORaJ+uGiGvaX/eeySYUgahBwxcDZGEu1O+w70yilJJtWWXnuaHh4q9eEcsKCM/28dUyEHRuB0XujqaLaktuZ4za/DPRPJiv71t6iFNJhzsmsBDZpu6v3qgBFsOZQJr5o+B5nBsKRvUXxuBgLtlleQQJgSyA/1x4CLzmTCHCNlF/y3ysoBw4QEUKMYGYXfQKHCgjnPY6Q44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d84688dc-30a2-4307-3902-08dc2698b21e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:44.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5kRbxFbs59eIjfdds2JGr+XeG0uUbWQAZPmxwDCabvOwSVzQ4rHePU/htZN0LBHlXL7hS8cmK7dD6dTTTBYQPGwKNXUNPgVG7g+7EY5Gtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-ORIG-GUID: YDMBOvagmcFvJkIQPxFM-1-gwbZ_vZrK
X-Proofpoint-GUID: YDMBOvagmcFvJkIQPxFM-1-gwbZ_vZrK

From: Christoph Hellwig <hch@lst.de>

commit 55f669f34184ecb25b8353f29c7f6f1ae5b313d1 upstream.

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 658edee8381d..e5b62dc28466 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
-- 
2.39.3

