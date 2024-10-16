Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B003C0B;
	Wed, 16 Oct 2024 00:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037512; cv=fail; b=P/DN6vnzf75GAIrtnY0FSfAHTzQCJ1pzm5lBAuTZLOqji/AkraFlN0m1L7Yrx6TEuMIfOBrnqvRP6oSui6qr8Brp2VsF2jhmNEziOC4fp1Q8NzEzR8obpk0m0OoBggVKo/F6r2kuvVuGs5ic+xIA1eKnrDajQ+qvzFdCffeLBCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037512; c=relaxed/simple;
	bh=9O7WeMDlEcG9jizvjDG2IbD7DNKi3oYqpEKhLtCpeNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XS9//05dX+rFueiZVwVdNpDAN55nNzCCQKPePLad+rRcsE0xQF8qWSLaLcTJG1CJTQnfke1cr4j10q1I99bFzeRQTGdiIq7O6hVVGRZlV8lwSSN2mLu1xXRcoaiZ7FdZKTk7+vL3VPoVUC6jDSXTEi9RFg+1DFphkBafMlithXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OJYK7pfB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TrrVxGPy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OJYK7pfB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TrrVxGPy"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtdP0028999;
	Wed, 16 Oct 2024 00:11:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=F7gXWRnz/FU0XVpEB2URtum4ABl4v3V9m5/M6PYt230=; b=
	OJYK7pfB0ylMVofhecn1xo2VpthmtP1ZgS09BjBdvN6EkLvSU6+nsMirfWNLNP5N
	8r/k0LGNXVuASqpPaQ8JistlzMfjJxZ4dFYTDZ6Y8Bs3rFDZrId+9IgUPbJ2RKEN
	Y0cdRL/h5QG1bI5vRAHa4CoZK0Ri5bepa0foHRzLxyLkch16EsyltF6KayWlpJIR
	qFwCPpeTtO2CUzoE7z9CMXryngLl7/SgfNYt642EX76lBLnapY7VGl6/rg7ksVoN
	eygiQJUPbroMdZ6vE+WcAooLlO8/SJFhDnyH6oqGfYO6us7m5y8zntgWfPUXQgnt
	/Ksjo8/BJh61ITAKJl8Xyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427fw2jk3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FMj2LS026388;
	Wed, 16 Oct 2024 00:11:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85ahj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FVMQGOnfkf0EbYhHEIzOpvCaqa9ea1sRroKyBdsaPVzj3izgCZJk0MTNKfvAAXTF/VK7KCdj7+ujvYZq2gh69RBcHsbeD3XwqRiUEYA6qLuHp3INlVBCiiWKLyjqaPuZNJihmWMauxQflnhs/2TN2iVBfZL7i2rtwyMXnKf7+/vv8ikLF5Jprq4GaZ613NqJC+/QJVLnsOZbVYmJN2m22NOAQF9pdA4peevlggZhVmwkhWjqx2Jlu0mGQlN1ag5n0JgBfW53lpw/rtF2iT0bdExDiu2SzstozOAy04kE8kLgl7QQG4xFisvFP9YeXWqtC0TOt8VJh8ju9yz0KF24jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7gXWRnz/FU0XVpEB2URtum4ABl4v3V9m5/M6PYt230=;
 b=nByFiA24dO+5nzXctTwygk6ghAwY3UvPYmWPvzBpaxD0OUL0YjrTXKIWzL6amRGO6B5IVfsNU18GkyE8SONJT5OXWU7cg0GEianSCOplZDUoQqaq2l031ePxzgDgBEmsYGwLv0l8AAuiuz2qbEhR2rWq+b1xiu6YMM4omCZYWLnW/75dq1G63PGUCveziIIG0rw3fQO5mlmezQRHVRk/oSXEPGndRwc7rg3jFKk12ePdi+CQ7xzeBCJ0JZPRNbYEY4pjVcObBEfK2msdvVR6kf8UJHuL6VHz4wo74i0BLXPnXagtIk/8plbBztoMXQx2JMST/82J9wZrcgzHJYEAJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7gXWRnz/FU0XVpEB2URtum4ABl4v3V9m5/M6PYt230=;
 b=TrrVxGPyfMkK9NTABAk+f9DIKtYQU62UWemHF/+AKeAbbGXbBg9Gbh6ViwIRA+yFIcXTlGxQwV5VIxkCvifbG+tnas135LS5suSvAk3e3/FCGbHtE4rxY0l18TDghdSn5HJtc6Kc4rBuG9FMQrCvz4m4dCGkSvg9jTJQD8zyBRE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 00:11:45 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:45 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 08/21] xfs: validate recovered name buffers when recovering xattr items
Date: Tue, 15 Oct 2024 17:11:13 -0700
Message-Id: <20241016001126.3256-9-catherine.hoang@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 28d006d2-d596-42c3-ce9c-08dced771eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vASTANdl9fPgZ96n4n77t6G8i6Z0FDHsKWjocRNf570ryONh3eCMTyI7tMvd?=
 =?us-ascii?Q?Di5FwGoJJWHJzFVu+Xr3x60ABecVuCXkRcso2ylVx/D/ZSqountlNbCEE8lU?=
 =?us-ascii?Q?OgLUB095+Q7+ileVIra4TnJF3z/FkmIcPD+EWQGTd42+/BR/Ir9PcTuX/ee+?=
 =?us-ascii?Q?VD7l/rKgYbTF3PZ74H01CzZ3m6E6r5UMyZFj/M0i28ADC5OUGpJ1Dds2DNoG?=
 =?us-ascii?Q?eGabDh090oMH3BZZL/3jR56kKtPy11voiMlOsHesRz9RFlhSv1zp+7J6LK+1?=
 =?us-ascii?Q?0ffXgFHIMe7GLZcon4VsaUbv72gh07nJoANuCzHnqLdRh1mDKuUD/4lvHSah?=
 =?us-ascii?Q?SiqAM46LQd5DwEtzd7kjIMOwvVxs0Y+feV+A6Ok2ziIPKzlQaoqZI/tgaBDf?=
 =?us-ascii?Q?QjbaoWwCfnPDo4nuWsIxdEj8qdtXMjoQSsvg6A7ObshpijM+AT1Hs7Kguvr4?=
 =?us-ascii?Q?rlYydxQcSLYha7iY0kTQuA40U0IHX8zSL6IecYqq98akFi0Q6vHfyUAf1GaO?=
 =?us-ascii?Q?1J3Ky0l7PCZctLfvNIVvq+gGrnRpZj1zLXl7T7O6ZrgSkhEFG/DlxzwYzyct?=
 =?us-ascii?Q?OBzYCNy2Un5u1L+ihvZ6l/yoEU2Hsd6zaOv9+GG0oj9Phj9UWrZaexg35RwW?=
 =?us-ascii?Q?oRqwyaLwkxUOPTkUGbOIb/mxme4tk046eFJrwRq6Cbx3k2/Tp/9LDTMzJU8/?=
 =?us-ascii?Q?9n3LoTmBx4v/lnXLSg18GQWPHk8rrcVjyojSGNmMuybDunvGZfVZc03gWGNS?=
 =?us-ascii?Q?vPQqE42P8MYn2Tfvv5TFlx0cUdJljJZG8pm0O1kYReyUBAi66Yduo6Hx6yBK?=
 =?us-ascii?Q?Ng9xAqbAmS2jNWNdoK65To7Hy2oTGTpoZWPK4E0eyFFnKgiOQvBJ2DIlqX4v?=
 =?us-ascii?Q?xtce2m4Ah9AW5HqFcycBcdPdOxI2mWchs7OjgUD4NezEsFYMkcPbSqN6f5r4?=
 =?us-ascii?Q?T9ntSVeg5p4PoJj6Q4Q+P1ELebAbich1gegl0U044MuBeNg/M0V3RbJvYCBP?=
 =?us-ascii?Q?h0rCljrX27Lxo22IPa4th3VmdKnyZeGn5dXALXVog+tZ5GrqV3sGhz6xXFiW?=
 =?us-ascii?Q?48PQyXeQwNKv8NIkPtzGQm2Y0zpOmCGMERDKHizvsPbg3W6s+eBGw7c2BgFw?=
 =?us-ascii?Q?w3PvBBBwwUeV4pXjwEH40BdraS3H+JCXBDD064+z+DQAxdUa8MiRyRTaz57V?=
 =?us-ascii?Q?AucGEXYxV/W36hO8E/MYeyQLLZmwsZJtmsVHMsdPUmzYs0/b5r8HPm0xpA2j?=
 =?us-ascii?Q?15jSOpbQ03VDPcddWzNB91PSmYkzHA3LHwxmjAy0DQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dILblBVU7BAWOeJUDnHJ4q3UP7/7oKtWalww8gcu06my1PP20rogKR9fKUR1?=
 =?us-ascii?Q?GlF+1RnRiGeDeSgzsNpqRF61GAI1rS2OVmdqSerYHbDh4TM8Eimd1U3YTsGV?=
 =?us-ascii?Q?+RIci0LUPyhXhKoMFd4Q/yZ0joCUodCZrgs2jcXPGYqI/LFxN13H4tworTVd?=
 =?us-ascii?Q?P0l0HdzhOUqQB5k3edMwvm6x1ENZ34RDteCg4H0gbtRsyPeO4A7mnW0hN8sw?=
 =?us-ascii?Q?uWfqeQh+xI9lmlNhrotg1ZEV2cQ2pMlDF3RC7gAQ5au5zc5CH5OdPZWVKqL+?=
 =?us-ascii?Q?2DSVGEWvuSiltMgxkmQOMIJ5Fd8h8psL0rlyugKv68Ld1q3Vzf5qevYQ8EEP?=
 =?us-ascii?Q?AlZTd/vBe/2vcvuRiShT2MXBGqDl5lw0Ho8kMhA6SKRfSblt/mZ+Ujd8iI0G?=
 =?us-ascii?Q?rRN000S2nEJ+Z2h4kowDzSQprywyYxx+pA8nTReuqhCnl7RTTAb++HTHDaxp?=
 =?us-ascii?Q?GfuBj3Gw/xG6iksZvT1rL5nlti3zXtkK1bxMVlEGa07phXIwbt3O7Xg8E5Ne?=
 =?us-ascii?Q?IRwFv0VQwmfeY9wyiN6fC5B2V3nzXNFhqk6zlnZqJAWLfJgWzx3sQE1zyfd1?=
 =?us-ascii?Q?CNkn2DbLxpf/Nlgaow39yUh8rQoZN+aPCGqh+v23F9JPEQPjirT1SbI/gHlt?=
 =?us-ascii?Q?ZDWuUj9SVgSUcKSODypCJvzcVdJ6sBMOVKTnQU8fvgIOZv7tgXpLrze+j1RB?=
 =?us-ascii?Q?8kZ4zjYj2+JnSssq11MB/EWtbeSmIzWceJZvNB48GgeXfWqV87W0ttVuDjvD?=
 =?us-ascii?Q?L5E0JoCUX6awovDEwdFQ2D7dBXiG9OsP1b/pZ2cDNtrGx19tgL4B6RYFtTt1?=
 =?us-ascii?Q?IZwP+/8V6b7lDFjVq9i7mvS2AC2WArJEVkwkx8VGfkmpJ4YCa8+HRr3Qredg?=
 =?us-ascii?Q?vXyaefP6skYX8Aj4mmv/Vi5c+B+npy/yHvg+1Psczbd9DQVawBB1D5jF35wj?=
 =?us-ascii?Q?+O3btKY/Xr6C9lSUOYEzqAfQ468b7cqFvlH3RrQ+5/PEllH1KCO7lKi5YzX/?=
 =?us-ascii?Q?3CeK0qVYa67NDvpXZjoVPM1+Xjokw+GcMWDEoPTiWPOC2QBPySfyklN7ZW4K?=
 =?us-ascii?Q?tZlGXVRG1co1FZNuOr5PTStw8oiAsEPNkTmcnZjbXZJX8/Z9LscUcwQyQA5U?=
 =?us-ascii?Q?65tZuX21y933YSLjUxdrUuucdF4WOcx5aFrku1A91+C0Xfv5BkWpY1/gnoki?=
 =?us-ascii?Q?TMa5n3WarUAS8J64fAkXDC2QhxOGYzizzgBfpay4ATHsb0PTZ/wPxhoIyN4L?=
 =?us-ascii?Q?JOuCxvb5+7HNqLwFKEW6XfKgQ58iwLTxQT12Qu+lXdu1ZgObUaAk+aLV7oSB?=
 =?us-ascii?Q?0IFBsANwdQxORf/uj12QNlOjYmA64ySZoD9vXW0obzMoi4TVy0utYzO2+bUj?=
 =?us-ascii?Q?TwMyCDJIFQ7oRm0hX+eJvbomq6OPwTCAP07gIpoxdMaL2x8a6BmuctCXkjaU?=
 =?us-ascii?Q?LXgVAF256qPZGhM5HMxqqALI1V24/gXhEMkoOpTXg+wYde+Inc6BqVZrEZjj?=
 =?us-ascii?Q?BTcKafOpahEDpdhtq05j0LjTzPSt59YwZH6ijv5qzBs0M8zmdk+0+UxG+3ug?=
 =?us-ascii?Q?3JDKDjlZD1kZD88SU6YG/KioTznkqCKHjW6T4y5tho3Bb2skbADmIuCawvXh?=
 =?us-ascii?Q?X5Ps9zTWLl+6I7UHxxTt7BGh+xFlESQpv66IR3fLIF4C5hc6VqM9kGrdlFPX?=
 =?us-ascii?Q?cQrkOg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mnv3FBKGLW18aGzDraGCaih++kxBYRXDNpRQBg528xpN/mnOdmnEtQ6wlyBcBB4dUm+0sar8B/Fc95Cxb4CXCXJ9WHKwM1bSe+rYqGjVzBZvkxugyIJcmjPibU+ryYbFvMVwDE0slD9ALzAJhZSHNDhZfnh1eYcK+T4PTdX59sXx7CzHWShWlnsuWvNmg3qsEU3Bh6F3WyB3A1l94h52fZ0oDR6nqmNCpH8Rc3ibRr0Ku0ZZfx7LpN9aW9Hb+H+IE8qL40aF1RLkl7h9yoOJ3jmQuZBjRoXNQSY0Y8k+MBPdVfsopd2FKb/lC538vomfIeGXwkH/xgxU8otQvpdTu/NzZV+WwnBxfyAJSCswX8Dh2yWgy8E9VoO6FKlN0KDiXM6k8FPkgesJJibYoEJpOL/eWEAYn0FvyBOkb+b8/4CjlmOaS0aMZtp7je7oxSLvyuMnG+EKargAF7HKkAYL8w6LvF8bGiGTIgsuqG3Fs5enFVl8CsVlpo187zORLHRlyjenJLh4W6mZDxVYu00xcx0cxOtoUBch6MPiB7gM+ahuQxbHr0cFwnH/4+oKT21Jw7fNbbwCY6VJ9uet9/6ls3eSLwKHo+XCt8Z4cRf5NnY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d006d2-d596-42c3-ce9c-08dced771eee
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:45.7040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qOcui/eL/5wl2zq5M7MT/3B58RLfM4GGFyPjh7S0EPWcwl5VJLTzGahL7KB0+QIH/xGwaslgPnLYzhC6ZpNNLEEL1yQ8BW8hCwvZEx6Utqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-GUID: KqKcBViwiwZgHUs_ovCslIIQc86adHsf
X-Proofpoint-ORIG-GUID: KqKcBViwiwZgHUs_ovCslIIQc86adHsf

From: "Darrick J. Wong" <djwong@kernel.org>

commit 1c7f09d210aba2f2bb206e2e8c97c9f11a3fd880 upstream.

Strengthen the xattri log item recovery code by checking that we
actually have the required name and newname buffers for whatever
operation we're replaying.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 58 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 064cb4fe5df4..141631b0d64c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -719,22 +719,20 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
-	unsigned int			op;
-
-	attri_formatp = item->ri_buf[0].i_addr;
-	attr_name = item->ri_buf[1].i_addr;
+	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[0].i_len != len) {
+	if (item->ri_buf[i].i_len != len) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
+	attri_formatp = item->ri_buf[i].i_addr;
 	if (!xfs_attri_validate(mp, attri_formatp)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
@@ -763,31 +761,69 @@ xlog_recover_attri_commit_pass2(
 				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr name */
-	if (item->ri_buf[1].i_len !=
+	if (item->ri_buf[i].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
+	attr_name = item->ri_buf[i].i_addr;
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
+				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
+	i++;
 
 	/* Validate the attr value, if present */
 	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[2].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
 			return -EFSCORRUPTED;
 		}
 
-		attr_value = item->ri_buf[2].i_addr;
+		attr_value = item->ri_buf[i].i_addr;
+		i++;
+	}
+
+	/*
+	 * Make sure we got the correct number of buffers for the operation
+	 * that we just loaded.
+	 */
+	if (i != item->ri_total) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Regular remove operations operate only on names. */
+		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/*
+		 * Regular xattr set/remove/replace operations require a name
+		 * and do not take a newname.  Values are optional for set and
+		 * replace.
+		 */
+		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*
-- 
2.39.3

