Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293C6D2FB;
	Mon, 16 Jun 2025 21:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110750; cv=fail; b=hReEghuL61k1KAmrUuR54rlr7TRSdk3CqHEZGoFDiDOjPaAJgkcm5dODh2LuhPkX26FBynbC4f8o5ens93xzFvRDm31OT5Q9H9nqc4g0ToXu0OJnUUFcSYhrIOWgJiEgiYgxZYBqouGhNAD7BfadsrXtZyhvb5GPqcGuZLDYdZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110750; c=relaxed/simple;
	bh=lkXOPV1DohQCKbwc3d43etN6mLi/hD9reurKybEwS1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SKYYO/EYN3rCqMvnuaEJMh/Fh2GHJVvf8JJHoh5ft2+bv7AX4ENrtOsgDGljXarYuT+a+zf9whk08zPG8cYl8qSsJvoWScAgLuIRW2R57++HZdhR0DbypTozfWvKi4uoVzB0NP1lJZsjpo0Pkd/hlL0xqOnOOyHs5zw3Ym9mr9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NWAdVbnM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lRJK7ciW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NWAdVbnM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lRJK7ciW"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuUYk017647;
	Mon, 16 Jun 2025 21:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ncBxi0iiFjjW6rZmFeBzcmmyGdN2iY5Y+e9flvtNoaU=; b=
	NWAdVbnMU4r24H84svmr04KAafMQ8ZJpcowfULOuw+Ux/Vtf3Y8b4jvu824KftwI
	mV4Kpq/New0sca5S08bEId66AabEn8k5luFf/zB43LMzEeqRYIaPPp1DyJIPORXE
	XzwSfJSR6KtDrXuGyv7bid6eKkKRNgj9Xv790OZ9fTCQvtMTJZWtO0DsBYgXRbPy
	vr1V5qmbACuWxGwLwkW4qKnu0mMYvTJ61Pfx4rha8UjwhQkSs/AQ9AUjAd4VkGvs
	HqTjctROpkphhuLf/6ZZEzCuzSgEqdBagWk3KQfWaAYGMG87zakicd5VIdtCSHQB
	wLrhLpO38pR+Pj1xbvD7Ew==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yp4m4ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLQwkP031624;
	Mon, 16 Jun 2025 21:52:21 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh87r0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnjuhfZV36HMxF84QUpjexHTv3JiYEt/RV/RWg/2aj+62dUjTx8milMjCn1qEcXU+kS3wi5hRGca5iSxuHDZnFd43SgOuHQ+fMTdp9IlPFJIMJkYBoHcEgL2qlqMdNjzdvQWVR29JTJ2upTTaNh4k3NVN0rlIM7wsP7bHv1YDb+KUwhBHEPxdrZ45iV+RjS/CADs9/I8v2Qdgw3UO9NcIf3qBoxVrsKY/enYtl3bzX84XeyhnNn1dvop4aDY3qcEWSk1+tbSqDODxMjXcvHCFupzo8f5M8LbJlUHItmFKoJ3v+iLr4HxSkNIhzUhJrW5xTVrHiBxFcvRMUndShQ99Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncBxi0iiFjjW6rZmFeBzcmmyGdN2iY5Y+e9flvtNoaU=;
 b=bY7o0+3d/qKyIlC3Qn+pGK3ydle1n/M1+OEcXsUOWKVOfTjLc2XXqEiUmYsgfBd+/3e/6rRFUaH6pVPPi7DwJyWxAcvg+OW3sEQmsTpTbNQampyl9Pn7NlIzKauYnSVhbPRNIVtWCjBor6z4xC9CMW4CiWxg7H5weDRm7sTmp5bYS368sbm2CWJIYiQ/CpGC9kWjSjTmYnLECNj1rHZlruJaJN+sAMs0XncP3BOzupnPx4In5RiXSFDbiAQsdqkp7bD+O3ajbnlzgehRmWYrGQKWcOLg8bv8pkwgslI59CnZiOOhVh+igolQ9NPMD/9x16bw/2OGWk9VvFtveBgeqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncBxi0iiFjjW6rZmFeBzcmmyGdN2iY5Y+e9flvtNoaU=;
 b=lRJK7ciWZjJCnfwxNJs4St5rwsGiHGfK1l1jHsypVmfXH7b5nG+9cYIfU8qtuWkxspB0pMf4s0Fd4oD4jiNlb8YvPjnVWZthKKcWTnMluqyWwKmvqk7e0N04bLAKkJnoPXFTK0VYA3Hr5hAxwSbtBCE7ukrtQ3zpMYnLfsDQgOw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH4PR10MB8148.namprd10.prod.outlook.com (2603:10b6:610:244::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 21:52:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 21:52:19 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com
Subject: [PATCH v5 2/3] generic: various atomic write tests with hardware and scsi_debug
Date: Mon, 16 Jun 2025 14:52:12 -0700
Message-Id: <20250616215213.36260-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250616215213.36260-1-catherine.hoang@oracle.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::26) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH4PR10MB8148:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6bce3d-d4b5-4b55-9889-08ddad201141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tELWawgBPntbSyjDQEZSLME67SE2v35i8X8RRuvtvVH8huOyjIMff5yiDMll?=
 =?us-ascii?Q?2TpDpcBli3vQ/BLWn23TQr9A9XGykVtNfMjBYQsdZP0Vw5vKTvK6fmMieaBw?=
 =?us-ascii?Q?+43glXJbPXBqqAalZ/VLgje7oVrtQ7RL6mlv96CFAYt04t0D5fegHuE1ULbx?=
 =?us-ascii?Q?UEocLOIeM/fnMFuSQKrFXQ+QBAVbsqfLHlp4lSyRrjZnU92bAa3eQojj46ow?=
 =?us-ascii?Q?ygXqcj5tB4ZGXT8+g5odc4kDqx5bTUuL5wHIXYXwo0oT3Hkglz4ka8DmSVK1?=
 =?us-ascii?Q?w7lvVRl7EamrRkXIN4cWQdAd3IbSFGRtN45pVrZi3W3w3lzxUr3Kw74iIIiF?=
 =?us-ascii?Q?ARqA+eEIogzpjDeVMWM4zKvX6d/xnJNNiwzH5PwERI617GAEjUZx2CeaKG9T?=
 =?us-ascii?Q?Ux/+2vngdArntO0QLYghl2FeNpEl1XGmqiHCxdxfEVTzTAyQtr4Ft2S9BlWl?=
 =?us-ascii?Q?k22eKFafXhBbm2MWIaVcviSJHs5RBzv/mzwmOD/CNBK67WEGWp+NVkTFvddZ?=
 =?us-ascii?Q?ws/myJAqrel4JxmzU+C+Z56we+3/PlYyoThilZCdOhMQQipT09NPemQ2laT/?=
 =?us-ascii?Q?spIqzjYEZKmyYTgj8OtYAjzQtI8wvR7ndUynOWlMi0vL6ZQQLt+pxXS1PmQV?=
 =?us-ascii?Q?ImH2KFYDfaMUeYReJaxaZjy5GYLyIy2HGqnOmjoEVux+vildTPJQ6DecdVT5?=
 =?us-ascii?Q?43RGK+WmhSpmkkNncLaCurUme1/edXfCEIzLWGfFU51MCOHDBD+Q5zPow9BZ?=
 =?us-ascii?Q?ZbB7PZXovbtKM5kPQ3SFmkc3+M++MsVl97oSGRNk4NSU3CmpkWKlkTvyxn07?=
 =?us-ascii?Q?d3DJUluAO3AW0MQpglSjW3XMla1YvRvPHYp0bnz1aA6k8/bVLA13QnCm54iW?=
 =?us-ascii?Q?5sXAunXwNVk3zKVuT7CN8DCStbHThupyKe5hbtITWlRQFHaitp7M5sbpJsxE?=
 =?us-ascii?Q?AQP7WaowB1egTC2hN38iqnZxLZ8MvUvydgdZb7weyOWN+J6lXQuPVCrZmoYG?=
 =?us-ascii?Q?2D9BAy21rNH8CLbuSkDuwwPWKzjI69l7lyqOHTUsZtWi1W69rK9GQ2gTACrk?=
 =?us-ascii?Q?lP1q3AbU9pzz18jMY2EWBWbK/McLx7sl5vMdctO+TecVrjK3b2ku7SV4ZinV?=
 =?us-ascii?Q?o77TkAAPIk2vVZz0WjS/gB67//G3OqilJ9kuVvQmXDXnQ/J6OWlLY3TVjOT4?=
 =?us-ascii?Q?GPCo5ImM2/bH64wGXl9Ry69xadfOnkobYOoam9mUku1I8itAwksJIi5wxlLp?=
 =?us-ascii?Q?LIWI8kZ1C9ZHPBZ+Tjy+fZaSF2HFJfYfBV35kJR/iw/1sh6nh4SsCvD5s6Ep?=
 =?us-ascii?Q?eXq5gHBksOr9cnYjhhfZ8G3pe7KoU/IpFXWE4KJtoCS4U0YUJY2RM4ZzUL/C?=
 =?us-ascii?Q?vT7t6su/ZuA45juc6k1dtCpuX8yHkDm3bcH2uWYUJCn8WDLT15G5uAyz7XvW?=
 =?us-ascii?Q?KjwzSw5edm0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C7epKK2epScngYrfczXtUaEGpjSA/vKtm2C0J/AzlRkayhtRthanfnJod22C?=
 =?us-ascii?Q?pc2tWLLji5TrDefd40kp38wVmqjZUejLB0C7BsF01mMjbtrFHse10iph5/yl?=
 =?us-ascii?Q?bZtxEYrtx9io4a6bmrlesDOhgpXv8TzErbGWRb5TjxI68UmOnbeUuQ+cvvuA?=
 =?us-ascii?Q?5pHYPw59zfOjDt46NHTGTUg1o89jxJGtvqx0r2wTiCygTKerXHoqvWSPe2Wa?=
 =?us-ascii?Q?okms/zBzs1LR3WhLZAQWk12xl5OehqN/fYIKpl7ScekryytYFh6EUjuBuWlE?=
 =?us-ascii?Q?/xzYjkBLTkSPDi1TIZuybkkpgwWb+YMlpdHyQaXjow8VHtPTnvG1kLC2c0mh?=
 =?us-ascii?Q?+T6HWxfmcxZCKtVbsd6iCj/j76YFc15ii5y0a8aqfpVC7XSDxmaABG4cfkwW?=
 =?us-ascii?Q?Ix44Mcr9iQVdm0zE3hsLuF2DFNFEfEYh57OtdS1uoyAK5LVMDSJNiCfODai3?=
 =?us-ascii?Q?OFQCsDcHgHJRRclZqnzT3ytu99XUT+FaTIiNjj3vVE6vfLsmH23S3fAjkdJM?=
 =?us-ascii?Q?35FxUH+x31sEdjT7RjBrykGDCiyuKk50KDai7nZNQjxxd/kWcDzZTv0ond4s?=
 =?us-ascii?Q?bwzwGfuSgAbcjT2tQWbCGgftFWmKPzpkErZEsBYxN2xuTQNPLTDaW5UkR/ez?=
 =?us-ascii?Q?930KmGQiZ6CHDu7aHgDsadCYtSegvddA4ZenCsnXlijQRD/PDDXALYPmsd+6?=
 =?us-ascii?Q?FhyXrwjYncYsBE8QeuMxJnEdnnt47ttONLiBnokcks+5al4HJqtNr0GVNgCi?=
 =?us-ascii?Q?Rhnl2FGZEyNAP3qcPKZ+0t2TTjBjcEHJ3ibtZjbUVEtkxpWInqAUICVmYQMx?=
 =?us-ascii?Q?6SjZ4rSHZV37eu02jUQzaSUIrcBR0x91yTW0h7ncsE4xMUuK8558X5Zghp9f?=
 =?us-ascii?Q?+YRaAHTQlJZyOwt2HfWDf+LDo2n18kEnDK9p9cgWKQG3cmgFselTMDW68F9/?=
 =?us-ascii?Q?dIi9nSPUZKo8tQjqST0XjDouwQXvlU67+enX4bpVr+1UfRHT1lIks+z1Lqmm?=
 =?us-ascii?Q?OaLEvx3N1p4cRggcSuN6PvtR6AcLAQ5qOdGCqKWMnrIXlTLeceZFfIepCqlC?=
 =?us-ascii?Q?Q9P6Er9G127N5fELaTabud4tapEmcOJl7W4OJmGxkID6p+OlJTtq53S5/nXM?=
 =?us-ascii?Q?+zp2r97oC7yHhnd9OSshYZuLju8ZuLU9Xwwa3ct+STBjVmJ8YHH29x/0m16k?=
 =?us-ascii?Q?Xwege1XEPgPYhf8qukoOroT1npt9x5xJfRn8tqn7odIZ8aejv3HvFTkTplJJ?=
 =?us-ascii?Q?mWaQ4i5PRAgh3/wvQ9ZpzhV9XLOhQlbzFq6JpSmagHSwUTMZULg7y394+f4V?=
 =?us-ascii?Q?vd7UEoE5PUVri9fX2P0vtizP4kOrGMnmr6kai9iqCAgu2UnVHfNAcw/xKFFG?=
 =?us-ascii?Q?yDOe3xnPj09FClWIyhyfw8n2AUS4gin8E4WUue3kTAC17+X1K+KqLzvAV4mw?=
 =?us-ascii?Q?A/MUEW4AGGNWG5haUf4//1TViNlhQ8lXW5+4eASlhGpEKCRzTGoNcguv+nmi?=
 =?us-ascii?Q?yIvkX3r1TszKyXRaDa3z5stTtkQHohd6y/zIstEJiELAF+ruX3e62TRQNlr6?=
 =?us-ascii?Q?6KxlDhQYiIEtSGvzD8q+Tat0KfNa6LTU9kM6ef8hwcWEGPD61dC/lXlVjyww?=
 =?us-ascii?Q?TFuiRltgd1dsxCbq5y4tLdvgPO8zLo4MxWCbY1fVVua8iLhYdM3inbC2Ye9p?=
 =?us-ascii?Q?oUWzYw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GEMXyeKsHKJ4CLignCSfyjpCnP/CU4Bb8MtyyVoLmUp1rECCBEa/I1AYbAaG45DfKJqneSxBmVylOKpOzygWguKYxDLR+gbY6W3thqL/z8edam5IuaMlqC2aWBiljWwtRmpg9WYHbPew12j/PILBneRz0bLhv85LfoBAiXV04UcdMGmZG9oSASJMBCD+g5UU6/H40jrqCpE35eOXhNw65rv+PbH5BRg6yVDaqtaJH9KBQiKJ+zrjUNTqAmXaDrveAZ+DfFbo79tVtvVidX+qvtcpCXBpvMpaoW4U6+S8GfEhEnI9hpWq2Xd3JFfBsXJKi9eV9lBUb/0QyasnsnAO+sAomPMnifo6XoeAO0ptNci9gU4msmQ7OB6yGRQCFIQNzUh5yUKlQgJuNaXOd/ZH1VJtDkfiO20YjHvS9aSGijy8s13gNE2I9Pptl1JKwfqE1HQ1zmAf8Ri+o3V97nW3G2Z2Nq7gfHESqSRusfKXjnNxa+mwVEmvyzkJpK52nfPYXh5K8DMtBztD3UsQEow0at9sN33wym/229vv5/2bP205IpMnJoJOpoGGc/Oh2bLGJwieQZiuAKz+ILowURHLK2k3vg0nCyeYcyIl6V8UkS8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6bce3d-d4b5-4b55-9889-08ddad201141
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 21:52:19.8837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqfgt7GsfsxgXmS3R0OhnnvGUoPuKYb7avZ5of0RdhaMAcA6bQz975J88sjLdsYrh1SsyA1DVP1fPPRZjqurkDz2FZqQ1mv5Jk3pBWuFO08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NCBTYWx0ZWRfX2QcfQmDhqvol gV2V1PrjZy9dI14Vav3nMFXuSRRwXmjzlHAp0szfPSdsYLuSNsnftAcU1MPrcTK/NDFbCN6WZO9 qdQoP+KA6xMiU0Q321Bzr1r0e6Z0AeFdo0ocnnKVUSbKoxQ0cajoVgH+JM925QP1Rbi7LGxxka3
 Wy5fZr09NvLcPc295lOMk4Pao9iAK7aUxOKXIlzaqCAlHe3H7r/ocXKBkoIwO34P3TPyOwC3lw5 fnw48wnRBXqMFPVV2NPQNZcxhY4VfnG+2dpnL45lhfiUukCsahEmMExXvAdn1HgPoD7rT8qUKh3 Ee/Izep8OGGHmi53Y1tyeMRDVpEw8QZunInjMdfK6YLWK5mkebd8y/M17fM32SV2EZFsjvtLGsy
 k4XuJyBJnbU0BjgdhyLnYzdmt4tZj9iSuq3APixb5nUZ/VGJTWWMQ8GC7YQESNmp3vD6xV+o
X-Authority-Analysis: v=2.4 cv=K5EiHzWI c=1 sm=1 tr=0 ts=68509216 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=_sb9GA80nfZML6AoPYgA:9
X-Proofpoint-GUID: KaHTS4NSFO27uwFzccQerq7Jtv9-vuAo
X-Proofpoint-ORIG-GUID: KaHTS4NSFO27uwFzccQerq7Jtv9-vuAo

From: "Darrick J. Wong" <djwong@kernel.org>

Simple tests of various atomic write requests and a (simulated) hardware
device.

The first test performs basic multi-block atomic writes on a scsi_debug device
with atomic writes enabled. We test all advertised sizes between the atomic
write unit min and max. We also ensure that the write fails when expected, such
as when attempting buffered io or unaligned directio.

The second test is similar to the one above, except that it verifies multi-block
atomic writes on actual hardware instead of simulated hardware. The device used
in this test is not required to support atomic writes.

The final two tests ensure multi-block atomic writes can be performed on various
interweaved mappings, including written, mapped, hole, and unwritten. We also
test large atomic writes on a heavily fragmented filesystem. These tests are
separated into reflink (shared) and non-reflink tests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/atomicwrites    |  10 ++++
 tests/generic/1222     |  88 ++++++++++++++++++++++++++++
 tests/generic/1222.out |  10 ++++
 tests/generic/1223     |  66 +++++++++++++++++++++
 tests/generic/1223.out |   9 +++
 tests/generic/1224     |  86 ++++++++++++++++++++++++++++
 tests/generic/1224.out |  16 ++++++
 tests/generic/1225     | 127 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1225.out |  21 +++++++
 9 files changed, 433 insertions(+)
 create mode 100755 tests/generic/1222
 create mode 100644 tests/generic/1222.out
 create mode 100755 tests/generic/1223
 create mode 100644 tests/generic/1223.out
 create mode 100755 tests/generic/1224
 create mode 100644 tests/generic/1224.out
 create mode 100755 tests/generic/1225
 create mode 100644 tests/generic/1225.out

diff --git a/common/atomicwrites b/common/atomicwrites
index ac4facc3..95d545a6 100644
--- a/common/atomicwrites
+++ b/common/atomicwrites
@@ -136,3 +136,13 @@ _test_atomic_file_writes()
     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
         echo "atomic write requires offset to be aligned to bsize"
 }
+
+_simple_atomic_write() {
+	local pos=$1
+	local count=$2
+	local file=$3
+	local directio=$4
+
+	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
+	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
+}
diff --git a/tests/generic/1222 b/tests/generic/1222
new file mode 100755
index 00000000..c718b244
--- /dev/null
+++ b/tests/generic/1222
@@ -0,0 +1,88 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1222
+#
+# Validate multi-fsblock atomic write support with simulated hardware support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/scsi_debug
+. ./common/atomicwrites
+
+_cleanup()
+{
+	_scratch_unmount &>/dev/null
+	_put_scsi_debug_dev &>/dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+
+_require_scsi_debug
+_require_scratch_nocheck
+# Format something so that ./check doesn't freak out
+_scratch_mkfs >> $seqres.full
+
+# 512b logical/physical sectors, 512M size, atomic writes enabled
+dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
+test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
+
+export SCRATCH_DEV=$dev
+unset USE_EXTERNAL
+
+_require_scratch_write_atomic
+_require_scratch_write_atomic_multi_fsblock
+
+xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
+xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
+
+echo "scsi_debug atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+echo "all should work"
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+_simple_atomic_write $sector_size $min_awu $testfile -d
+
+_scratch_unmount
+_put_scsi_debug_dev
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1222.out b/tests/generic/1222.out
new file mode 100644
index 00000000..158b52fa
--- /dev/null
+++ b/tests/generic/1222.out
@@ -0,0 +1,10 @@
+QA output created by 1222
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+all should work
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1223 b/tests/generic/1223
new file mode 100755
index 00000000..db242e7f
--- /dev/null
+++ b/tests/generic/1223
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1223
+#
+# Validate multi-fsblock atomic write support with or without hw support
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+
+echo "scratch device atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+echo "filesystem atomic write properties" >> $seqres.full
+$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
+
+sector_size=$(blockdev --getss $SCRATCH_DEV)
+min_awu=$(_get_atomic_write_unit_min $testfile)
+max_awu=$(_get_atomic_write_unit_max $testfile)
+
+$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+
+# try outside the advertised sizes
+echo "two EINVAL for unsupported sizes"
+min_i=$((min_awu / 2))
+_simple_atomic_write $min_i $min_i $testfile -d
+max_i=$((max_awu * 2))
+_simple_atomic_write $max_i $max_i $testfile -d
+
+# try all of the advertised sizes
+for ((i = min_awu; i <= max_awu; i *= 2)); do
+	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
+	_test_atomic_file_writes $i $testfile
+done
+
+# does not support buffered io
+echo "one EOPNOTSUPP for buffered atomic"
+_simple_atomic_write 0 $min_awu $testfile
+
+# does not support unaligned directio
+echo "one EINVAL for unaligned directio"
+if [ $sector_size -lt $min_awu ]; then
+	_simple_atomic_write $sector_size $min_awu $testfile -d
+else
+	# not supported, so fake the output
+	echo "pwrite: Invalid argument"
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1223.out b/tests/generic/1223.out
new file mode 100644
index 00000000..edf5bd71
--- /dev/null
+++ b/tests/generic/1223.out
@@ -0,0 +1,9 @@
+QA output created by 1223
+two EINVAL for unsupported sizes
+pwrite: Invalid argument
+pwrite: Invalid argument
+one EOPNOTSUPP for buffered atomic
+pwrite: Operation not supported
+one EINVAL for unaligned directio
+pwrite: Invalid argument
+Silence is golden
diff --git a/tests/generic/1224 b/tests/generic/1224
new file mode 100755
index 00000000..3f83eebc
--- /dev/null
+++ b/tests/generic/1224
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1224
+#
+# reflink tests for large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+_require_xfs_io_command pwrite -A
+_require_cp_reflink
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# reflink tests (files with shared extents)
+
+echo "atomic write shared data and unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared data and shared+unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic overwrite unshared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write shared+unshared+shared data"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+cp --reflink=always $file1 $file2
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written+reflinked"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+md5sum $file2 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1224.out b/tests/generic/1224.out
new file mode 100644
index 00000000..89e5cd5a
--- /dev/null
+++ b/tests/generic/1224.out
@@ -0,0 +1,16 @@
+QA output created by 1224
+atomic write shared data and unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared data and shared+unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic overwrite unshared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write shared+unshared+shared data
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
+atomic write interweaved hole+unwritten+written+reflinked
+4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
+93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
diff --git a/tests/generic/1225 b/tests/generic/1225
new file mode 100755
index 00000000..b940afd3
--- /dev/null
+++ b/tests/generic/1225
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1225
+#
+# basic tests for large atomic writes with mixed mappings
+#
+. ./common/preamble
+_begin_fstest auto quick rw atomicwrites
+
+. ./common/atomicwrites
+. ./common/filter
+. ./common/reflink
+
+_require_scratch
+_require_atomic_write_test_commands
+_require_scratch_write_atomic_multi_fsblock
+
+_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
+_scratch_mount
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+file3=$SCRATCH_MNT/file3
+
+touch $file1
+
+max_awu=$(_get_atomic_write_unit_max $file1)
+test $max_awu -ge 65536 || _notrun "test requires atomic writes up to 64k"
+
+min_awu=$(_get_atomic_write_unit_min $file1)
+test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+test $max_awu -gt $((bsize * 2)) || \
+	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
+
+# non-reflink tests
+
+echo "atomic write hole+mapped+hole"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+hole and hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+hole+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write unwritten+mapped+unwritten"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write mapped+unwritten+mapped"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write interweaved hole+unwritten+written"
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+blksz=4096
+nr=32
+_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write at EOF"
+dd if=/dev/zero of=$file1 bs=32K count=12 conv=fsync >>$seqres.full 2>&1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 360448 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+echo "atomic write preallocated region"
+fallocate -l 10M $file1
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
+md5sum $file1 | _filter_scratch
+
+# atomic write max size
+dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
+aw_max=$(_get_atomic_write_unit_max $file1)
+cp $file1 $file1.chk
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
+$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
+cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
+
+echo "atomic write max size on fragmented fs"
+avail=`_get_available_space $SCRATCH_MNT`
+filesizemb=$((avail / 1024 / 1024 - 1))
+fragmentedfile=$SCRATCH_MNT/fragmentedfile
+$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
+$here/src/punch-alternating $fragmentedfile
+touch $file3
+$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
+md5sum $file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1225.out b/tests/generic/1225.out
new file mode 100644
index 00000000..c5a6de04
--- /dev/null
+++ b/tests/generic/1225.out
@@ -0,0 +1,21 @@
+QA output created by 1225
+atomic write hole+mapped+hole
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write adjacent mapped+hole and hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write mapped+hole+mapped
+9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
+atomic write unwritten+mapped+unwritten
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write adjacent mapped+unwritten and unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write mapped+unwritten+mapped
+111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
+atomic write interweaved hole+unwritten+written
+5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
+atomic write at EOF
+0e44615ab08f3e8585a374fca9a6f5eb  SCRATCH_MNT/file1
+atomic write preallocated region
+3acf1ace00273bc4e2bf4a8d016611ea  SCRATCH_MNT/file1
+atomic write max size on fragmented fs
+27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
-- 
2.34.1

