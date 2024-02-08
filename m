Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A654BF6;
	Thu,  8 Feb 2024 23:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434495; cv=fail; b=oNN5z6MGp++mvudT3BgkBCLk8GIBA392XyjVGGUNklSatOFBlzMkHavy/tBLJfTvkkZ2wN1MgRu+7+rM8UoCf+yStWm3zYG1EuI9BpG49QnB8y8LdOi1z9yIcHbis4NgNLEBwbZC+1ZGLPG23Xl7EWUolwvlFGysx+ZeaZ+uhAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434495; c=relaxed/simple;
	bh=DINMQXoMLKcvI9etsr1Nn5qXlW048R1Qt3MLdTsfjbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iMG6Me8K9vYofE0VVd+ZWGPHb3B3lx2Fyvba4ldFXU/wzBXRFZRYfT9ngu5kr4vqBi1vTdgxzEyD8yw1rlzgzOo6RPxOXhaIx6FkXgKTO0eE5bVwwPYKvLt2C9E+HEJB3jGxajcPgjjiJg2tY/7+NJ61M2N2rp1cdCUuavWafO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O/QUYL65; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lQko7P5e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/QUYL65";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lQko7P5e"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTUeF000433;
	Thu, 8 Feb 2024 23:21:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=SnsuUjRR6MGkY4DiJxA7Y7MTGuhFbIPyfCadn5/2C74=;
 b=O/QUYL65dJU+6PdUSyacuRCLTig8xjTnNZgVSNpThRnneiG3dtVzKR+xyKQP42iO0yOk
 954f5MU3z5jY9rtL9LRJ4/NzSlzoU54wdeWVqtFdVLjNiAdGV4R9Fmw1dlR8T3+Fc2qL
 jqzYkQbGStB1Kp3THiJsuaAcRqwuKgxYNdzFNNPk30kgqdNr/PUNOdxKeM8Q0OYsA8v/
 xo2ZNnQxL6lqsOEZhZpiNVpx1BxDLi+elNFoeHw4GjCrdvNZ5/UGPV/99/SuJ6uZ0KKu
 ufBsGTGLeI7BvFthuquCISTvbZe5bO95LWBjpW/wutx6NcUYESMTPhTzs/mbQd1XTIt2 Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdd6679-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418MVnPF019865;
	Thu, 8 Feb 2024 23:21:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq58j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjt8xv5NgrOMKaOE+mjJDrrFu6uq0aQJLKT5A6sdFSdBx3YfYKAOFM+H8JNZ87X+O1j4+YijV7dnv2RHEGkNY37s6YBGmNp4hxIOtGqzFQfaJml1k36SJkWvXuuE94bT9znpicELq4RBs+FWfveWyddKpRlm8Brjt3bFgCv91GkmAGCFbbLUuGCSMY4rW9zGHcVTSRGXE/z8QCeTCJWc//nLG4d1+Cnl9tvUpLvF37rnMzzVKZho3kTy0Ol1srlc8ahrrzOUdtg+uIqIxuDwrZqU31CATD/UHeVndVGt+wH63c1WGhTEwrvalIq5PkkIQR+1XkSXCl3Dxe+eK1KmRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnsuUjRR6MGkY4DiJxA7Y7MTGuhFbIPyfCadn5/2C74=;
 b=GXYWwuLV3pPaytgCjFuCajd+jdgURkFnzjl1I2Ffih7Cn+2dDNMbzOJIDbm7VQDzVvI12Xsmc6VOJcGCfND6L04s08CMNPTegezHWUlHsKf7245IIMLoJu4aUkzmc5+i4lrJmoUKxzidth8MVq2SbBOqPyCJONv97QNke5wojK7g0hPy1HQClatbmddDSiFfeC78MlKPddmookPcM38o491oNXz4wlzrzSYqtgbzSoZAX+eBs6dQBCn4CPZXGxxEtVCKFlMvte0Ado0YO4k4Qm6sgwXvoy45ugkgRVeC+4HWOYpHUxEAUxPtjqrFfcPjKFIMqg+nel90w2lYLaTjuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnsuUjRR6MGkY4DiJxA7Y7MTGuhFbIPyfCadn5/2C74=;
 b=lQko7P5eF2YTcCMdc6fUYsQKBGRnKaMQ5EikJwuEamG3zDV/GEcRlYj6boQM7MwFCUanVYo8OqI7uqZG0O14q6Akzq/b3YgugWaZmhp9TR7kN+hGVRUf14BXSdbyPZT8Mpe4cE/96/APf8sNYgkiGUZYqSNPQjCCjMXk0r2UxFo=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.37; Thu, 8 Feb
 2024 23:21:30 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:21:30 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 16/21] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Date: Thu,  8 Feb 2024 15:20:49 -0800
Message-Id: <20240208232054.15778-17-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240208232054.15778-1-catherine.hoang@oracle.com>
References: <20240208232054.15778-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: e7997a3b-0899-4b3f-9a5f-08dc28fcae2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QRMwmAhdE2fnYGtn0R0TkmNiXOPyGkLgMiw6shufUf1fE9tZiiYZW90gNSyfIQBqHb7WYBkpNXjC1KhHzYiHjRQUKxkbqNtnjFP39rQfuC8ssp195iBt+KX2PXRUzjsQsofLylnzfd7CPKM77QzlqLknk+Uhf7ema3jJcZBBIB1d0Z7Z79UgiWrIdWkLZJnVpudC1znY9Xh5lFad3kQ6mmUGXRbYOEqvXJtVkN24fIg0ND2K8fHX443oVuR/sbKpxj/DFdxTpV8Nf/CzQ8vqMZzUaDeNoUpqd9WKDz/Np01ahRafA029XNuuqw9n58NLKABprDdjxkk5+rCh9nIcvRLUkDMm6V96oX80839s8Vhm5kJ/MXsZviWLvAF4y0f2evYVwi3ZInwBgZys1ZjZOxT+SzahmmqH0T3OyB2y6EVCC7dibgiXZ5Ctg3pwWTyDzmyRkIju7wGpviMoSLdMZV2Xj9DPgdEuzlleuf6d558dE+FiOC6fnGQcGZH0tecganvJ6oOIDpOr18nG5bnreXWIxJ3X98tnW6vSG8ectyj9TawaFWkMmTXJPEpRai/9
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(396003)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(66574015)(86362001)(38100700002)(41300700001)(83380400001)(2906002)(66946007)(2616005)(66476007)(66556008)(6916009)(316002)(6666004)(36756003)(8936002)(1076003)(44832011)(4326008)(8676002)(450100002)(478600001)(6486002)(6506007)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RWRrbzdNbzU5YkE3UjZOSGdCQ2ZyQlk5cGY5OUFCTU52TU1oYXpwRnVXZlN6?=
 =?utf-8?B?dFNSTzV2ZXpDUWIvODdUcUJkKzVGMnVLalo4R0c4anJFdndQM2dhZmhzSjJN?=
 =?utf-8?B?YVdyaElPMWt6K05KM29yS3JjMjBTQnVBL3prSnF1blBkWmdUSk1Jb0FhakMy?=
 =?utf-8?B?eitKR2NkOFBveFVycTVIY2pmbUtTQU4rTzU4cGlVejBSc25IYjZwV3ZFVnRl?=
 =?utf-8?B?MHNuMDJuTVpNNEF2dmxqUHo2RnFWVnFKQWcrbnRseksyZHZiY2ZHaU5VV1RJ?=
 =?utf-8?B?bS95Z1lpalBCaEY3TkZyaUJEN1NYSWxMZDNBbUVsZXl3YVp4NDFva3hRbE4v?=
 =?utf-8?B?cnVuWjZWNEVRd2ZTUDE2YmU0MzJFL1hwRUNxUDY2cFUvN082V0RnbjE3dzVH?=
 =?utf-8?B?by9BTXdLcUxORFJrWEc5SlJWTVRJWVFvSEtKb3hIajEzM0QzMUY2cVcvczZ4?=
 =?utf-8?B?TU1GVXhieWRVRG5tQUpBNW5rSWRqQlFFZmpZYmVPU3daaUtkV3puVEh4ajZr?=
 =?utf-8?B?VDkwZGNhWC9BTTVsTFlZNUlKTVJ0MG1CY0VhM1NIVjUwZ0dPeW5RSHhpb0tz?=
 =?utf-8?B?aXN0STV4ellJcUtHZnFYTUJmbEZ6Snl5QjZycWZsNVg1TTI0Zk4vRCt5eWlD?=
 =?utf-8?B?N1NueEJvVnFGRmdpUXFkRXVqQndLNmM5Y3EzSkdHUzhLQkZUcWpTQXIwbG9O?=
 =?utf-8?B?MHV2bGU3RlFFbWdjVkFHK1NQbytFK2F6SjBrQUpBYlJjYVF2ZXVCTnRvSkZ6?=
 =?utf-8?B?Rm1mOElpdmNuSmtORTJFclN6Q1NlbmR6OHg3RllpVVJqcm9iNk1LYW05ak9n?=
 =?utf-8?B?NUtBTW1SL21Ka2FCUG0wci9XWksvazcwL3FFZGw3Qklac3NsUkpZcCtybXJw?=
 =?utf-8?B?RVlxeGhnWHVXT3VCUVNhNkZEV2s1QUpNcDdFNUREeFZJbzVZL2lyNzdxOGhW?=
 =?utf-8?B?aTY1WGVpNnp2cmVHNW9PL3c0TUpPTHNrRUk1enpmWXpOS1dDYUYzWm5UTjR1?=
 =?utf-8?B?VkNmd3ZIRVl6alJtSmU2SGUvZDlsa1hqZFhRZmZEMFp6QnlFRWRJelVyS053?=
 =?utf-8?B?ekNMOEw4cnpaYzBsWGlOeUY1RyttQ3FEeC9zT3lGdEV1WTByZmhZYzZSb2Jz?=
 =?utf-8?B?bE9BKzJtUHJUQXd4V3FkSUxTNEtIYjVwaG5mREtOWjVISmYwY2hZczJ6U202?=
 =?utf-8?B?UFZVWGkzdGJQVlk4azUvVWxDNEphSThQalY2UlBaUHBFdHdVUkp4ZDdRVUZT?=
 =?utf-8?B?RjNUNHplM0QyK3A4ZDUwdTVNVXBFUEJYYkZiYTJaSE4xQ056ZW16alRTUmd0?=
 =?utf-8?B?RUFPTjVDUWFHNjBmRnlxQkNVODlKbW5oQXp5M3FUN0puTnB3WlhpSWh3QTZB?=
 =?utf-8?B?R1NrOUF1b04zcS90akpwZEJoa1lUdnR4Y0g5QkZIQWs0R3BrSkxaQ0h2U1pY?=
 =?utf-8?B?bnFKcU1wRjJtRVYxaHRjNmpvMmZUS1RxWkt5VDBONmVENVl2Sko1bS91UHl4?=
 =?utf-8?B?OTI3dnVrbmdxT21qQVFDOERjY2dabGl3TEkyclc2Q3dxNE5LZ2NpRVFxNjd1?=
 =?utf-8?B?c29DMEhqbEIvbm9kbzlNN3Q3K1BJaElwV0l1aklHdEdTRmVLWW9palh3M0kz?=
 =?utf-8?B?QXZUNjVZNW0yRWxyQkVYTTdHditYQnF6ZU1rbUNQUldoV3BpNTdBV0I0b2xW?=
 =?utf-8?B?WGlFWTM4NXlHVHdLcXlwV25nMFZZMXNzWlhKS2xBTDJHdmQySzFtSGlsUU1y?=
 =?utf-8?B?b28vNDdUNHZ3T3pFTVk1NVd2QXhIWU9kZWZ2NXRwOUQ2QnQ2bU1zcU1xSXBJ?=
 =?utf-8?B?SzdCams5NS9vcnp1cWdiRDRVRHVCczJmM0phMnh2RERidWRPcEF5YWRJajVM?=
 =?utf-8?B?L1VEenFOeUdzVm8vM3JvaExJeTQ2bTR1VVdjTFhOTzU4UnRrU0tCcWd2bWcx?=
 =?utf-8?B?UUtuSEYya2J5Z2dwZFdkZmx2U0l0K05aU2dwb1N4MkY0NVVBbXIxQUkrWk9L?=
 =?utf-8?B?Z0xwbTFkam5HRThmYVQrWmNXNEpZYWV3TUdCTk9vdXhMQkYySm9DNHNkeHpx?=
 =?utf-8?B?ekVFeTFicE1KQTdyQ2pyVnVlZTAvai9TOFZlZ1NOZUZNcVVmVTNISHB4MW9V?=
 =?utf-8?B?YS9NdWoyd2RhRFd1Q3JSdmpVMWNmK2JqbWtTdlMwZVQvNFUxTjJpNStpbFlk?=
 =?utf-8?B?eFM4RUltVHkzbzlsa0NEaGZORklndE8vMktFWDV5Z2E2ZVgxV2FZcW5wYUxS?=
 =?utf-8?B?WjNQTkNlV0N2eSt0eHFCZmsxQVp3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GQZe8PLmMyADtA9jj0o+zkKrJIzwRFWk0A6X7m2cFTtuaVJVKMDwKkA2anW+8kKZn+A5wdzez0+KkvJrTgYQgfuqJMUFmanKgei2OgvOO9lEJhWN5NplhhacyKBxXeSf3/qYBDJajoANcyCGwO9PsyDkDsrmexniSNiD90jLN8m9YxALoJy/2Hp0WjnKWUVzoDKn6k9WfZ9DgiM5U4nfJw/f6JFjM+RIrWR0mi/EKx14dBtDQFSb1bH3lR3EmOtn/T1WFO2Zpb+2UbxxpxeEjlxtVpucoYJngMa3xHzDdpJSDOa7Q4pQSoBvPpA8EE8efPa3ihBI+9FsoTqpCzc00B0j7gSWuhEiH25NA3ITIb6GSDMDt7KWW+JyZe/+Ady8GSUsdKC9oaYCi6L0kdHk6DZ9Bc/mdWbldaZhQHV/ktrOS2gVLKERFUkjjYcOk7zuPJ6yw0XZiqcCFn5DkLEN72xqvCmD5rVOeIRuxqoySJ863sQ6gBQAKI8Il0QlvTKUrnWI2vSP0D4eOTlJMjDrZiIaFpyYbI9Pc5IHPppAtAZtnNn9by2E0pW3sqEZJftS8Y8x5DMlwiz5jEQlzmB9zJMAbNQFDx6csYcUvqgt6iE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7997a3b-0899-4b3f-9a5f-08dc28fcae2a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:21:30.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6uU5U/ntfJxNUhmtVThXTGZwVuN9uPg6MQKbCYCv/1C3pjADDn1nvkqDX6Xl8OVG/gOdscY5o+mIg5UrwBgHt0XZ6ZTJjMru4z7DenLF9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: Isq_Drq2F3stt9RB0JoO3WROD5hz2L8J
X-Proofpoint-ORIG-GUID: Isq_Drq2F3stt9RB0JoO3WROD5hz2L8J

From: Anthony Iliopoulos <ailiop@suse.com>

commit a2e4388adfa44684c7c428a5a5980efe0d75e13e upstream.

Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
intention was to select DEBUG_FS, since the feature relies on debugfs to
export the related scrub statistics.

Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ed0bc8cbc703..567fb37274d3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select XFS_DEBUG
+	select DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.39.3

