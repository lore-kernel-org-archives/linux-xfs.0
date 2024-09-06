Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68671B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657136; cv=fail; b=GcXqjJr7ioE9efrv0LLNKUzK/TpcasBgqzAxDAoR8+p3cy6BhJElCYDApvnwecWjTAKUC8YZgKk9xpHmecCDdK9nAvjUmydBitwwvuC6OTLy8lkad+vnu9C0acNl5Qwb31G2vf0LaNSMva8bHfu0HOHFrW/avvYUCm55RbJsghw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657136; c=relaxed/simple;
	bh=KfHg2Eep2tRf6yH+r3TTqOaY6IuLS3vc1tTzNaPqbJI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jt+2DFpnnDkOcNopmjUUZXnSI/i3zUQFEglkpBPDd8mXAqFagzJ98N4YDgwvB3Kb3U1e+4I2cxiBA0KAwLGnMWguqjnWNA+3qrcv4pzMw4TvKL1gKUGeyzgHQW7btfVfyaMXhspIL365Gc5F3h/2nRO6twHX7Wq9B8WhIlfqR9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vq0baL9S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tw0nBBWl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vq0baL9S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tw0nBBWl"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXW8L027362
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=dWqzcZo+RPBn7UkvV8UiSUVMdHx1G0TBHeopD+Q3nQI=; b=
	Vq0baL9SRMhnjlScKiVkNxzzzpign8aM1zfAGAMOF+0Pf97Nt8tGQwGwMiK8VeBq
	r00ANpRyOsFcrPQtwWQGtdA/Nyp6AEJ+sFiIPBYz5DxBR0+f8fHDCJsKyUof15bO
	WAHsZi3gXEfcpQWiq+BVuhk33iEA/WB3v/FLRPNSkml1wyfCj7gTMVn1peKeJdkJ
	gSeZP4MRYQ9A1u0ejt5zOL/+012kj60MQSPOod16cLCRp0FYIDLXbeu7vK9Hgu24
	mCjr1l8TAmeEguyYs+9IYugXH5d1p6Iw9iMEnNpcpUON/vUbhhiCxxjVU8PQHJda
	q00uABYDjyYmlnb6CwhWNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwqjhcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KVjFg003260
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhybs7fe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UlKVMH1IP6yarD6E13vs6A06MVEO5VPxlLMTz96cQZF/D0JcrxXwds+XIC8cu2l+ZRPSuToe8oOc+/lJ3T+iJMdi2qp4pvMXgfJ+30Xfec3ku7Wv2Wh2+4Dzkg65jMxPiXNS14yBsuRjUXn2pTp892fm6WZ7oRP53orQtsP4+mUIzNyNK3jL7+ooVgyZrHMZ76Im8h3FQnmQFm8RTEG3rx4O0C2TsajDdOPKiuzvVWIDe2Pt6YrvjCwtJvyrXGLlkb+W13AiGAOhOCRY6WP1gpH0UqqJyryQ0orTDBOJkszO8QLxyhfpFFrqePoACUFwJg1f1ikIQSSc73euaekJIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWqzcZo+RPBn7UkvV8UiSUVMdHx1G0TBHeopD+Q3nQI=;
 b=AXRqPqJZBTq0tGTIoFBiXHhPGOR2jQxaHxU7DHj6PrlXlanTDKS/w6wmA0wI/P3GcigNEyrcCxv/HTA4LTSrr5E19vrgCgWEvGzna5TpXnw5FvE0lXavT2EwYig4qDhPz/KxHp4/PULr+xyw/SoQj9ZNoRqDhbAcqivSSNUXrX2AFrQz6HiDtfHwA4NiEtiwhjUdj5A1563SVzzS0JGbzreH9MskQX+PPScs5s7NskG6dxoAp1yAzjZr4dVyjXhI9aM+yjqJwbtSFdqTVv9fCg2VIqYhuYBrf9zA5OsGru8U9mKybtSYkil27o6JRMcBfYA/nZ1jtV8YoS+d83CtIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWqzcZo+RPBn7UkvV8UiSUVMdHx1G0TBHeopD+Q3nQI=;
 b=Tw0nBBWliTlsq9VT5sfY7OZ+7toH5WUchTcla8DTr07WiXLJuwC+wybFR+sVETeYrnia8bXw43XQMjMJqziwNITVpDV5Ah0j1slVgJHwQ1XT6OHzg/Zk2iLix2chD/0w8+8CJvfQ44va96eICj8gP1Xqr/tl3czEr2h5ddamYEM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:09 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:09 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 14/22] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
Date: Fri,  6 Sep 2024 14:11:28 -0700
Message-Id: <20240906211136.70391-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0120.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::35) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 07d1e585-f811-429b-d5a6-08dcceb89197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y+meNWvHzeaN8kuP4obLd7VzULbYAtNFM9Okv4tbwqfmmuPZtMID59n73Bfe?=
 =?us-ascii?Q?PpN+Er0G7QtiShn+jX1yEAeLWdNVgz81sCaJByKM6kAjW8T6ketGjLgnCKPm?=
 =?us-ascii?Q?U0qi4bsr5+GychdbKWoZSM6TjoeBB6xnAyKTd12o4L6pj3PBVYEgIj1+ZllG?=
 =?us-ascii?Q?ghRyF3nXVVfl9gy99Hr5uSof/qoGazvIJUPnK25Hvxl1Z6Hf8dUIihGIrceV?=
 =?us-ascii?Q?B6AJnDdizb63E1IXcA0Ve8QP0TF5x9GTXqs4zr1bhRbk003zpEBooWhuBuPq?=
 =?us-ascii?Q?XrWndEO4+ZVAnm8M2OyInCFCGsX72N8yHCv9lYozD0Ao8R+pSNZjN8AofeM+?=
 =?us-ascii?Q?1iJ36uNZlJTzlDkALQ0+JCrFhU+B0iYyOGt2H1WQc7ILQWaHp7ipOxvCs4Ah?=
 =?us-ascii?Q?I7wOurdwHs/jJqGgRrvaZaM5CSak4Z2SGskI0IEm1ycvfLqCJNObHZbflmCz?=
 =?us-ascii?Q?fYGhSrIU44zcc1dtXmqARLmKIOpMWNaFIN+SwayyVf3URPSmJlaoKbXbYjQz?=
 =?us-ascii?Q?+QT4vadnxetDAf++agj0qSkMeRcxdX07ORaclJn3IbIkNy2PuJ+G+5/2pd8I?=
 =?us-ascii?Q?cBGr1SMlH9uWRr5iQtJtuDgZzUfDRTMSLWHD5EkZ4r/HXJUl1VR03TToZFYb?=
 =?us-ascii?Q?0hjf34xW0EyIknF9ks+Y/lvnSjrv5bPgELUwCgmEVdP2gwm9FLPCo+JFvBad?=
 =?us-ascii?Q?2L4DLzqn1JbiU2JBefvDvbY385svGULLJHEBM/nIT00qhIIgGqodCQXfwiB6?=
 =?us-ascii?Q?gzpaUZYFXiWJJENhf2sqF3iUA8EbGnThisudp4tfne+3K58E8lMCoYI+Mmzl?=
 =?us-ascii?Q?9tlWUZFWJ47p67xyjsXfXty7K1U8yDPtntVl9rkcbOpLYTewfbGSCYV5J45a?=
 =?us-ascii?Q?tIi7eGIfOdE0qmA2TTU+RUgjLd0Xnl4bCYFi7IJdyg2HqwPVyUsSuDodvs64?=
 =?us-ascii?Q?HeUC4TmxPBugt64DV97cszz0H8uEF0zHUzV8LUmCQUfhHcgC99i6Aatvl3pW?=
 =?us-ascii?Q?tqmxFg3g+uayOCAb+MxkbHyj5kFCg1n5ELu8VVzTvw8IgkCyUnvJVQRGxghj?=
 =?us-ascii?Q?q/y6eG+CSMJUaJxwfLHIjk6zO5OMIM2PRcUi4vXPi3sb/qS/u1naaRYtfzsS?=
 =?us-ascii?Q?axiXLda3hEhzEsHC+c2SUvwKbxkuwFIpI9HLM25wyg1GjXF3WRoQOBQkBgNl?=
 =?us-ascii?Q?ph6hMMqkkz4Dl0TFUiwTy10K+Ghjjoon4nZD/HdCQ2+deZy3EtLmoFnGc40u?=
 =?us-ascii?Q?rDE7lIsoOvOavpGOAgk0keI3lpP/xiH9Ov5YnQ2tJc85jM4it/6UYktUuVND?=
 =?us-ascii?Q?iduptqObs2POhklUm8C7Oy5uD7B0M70867tFzWvMm4S+yg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t5rg0Q+63GCqivK+8XcwXS+DGz2tqPjw+DpIYJx7bD/6pgceD7WgU1/3O+GN?=
 =?us-ascii?Q?W0FZpH1w29y+YfvrC89B3g8LZqxjsL47VpAF6I2wysMAMFZejvR1OAR32r7F?=
 =?us-ascii?Q?w0lAQGaB7cBx1RPg0twyxC3DaOEv1vGse4WShjISdB4ql4lym1NX1Ztr/BKO?=
 =?us-ascii?Q?/0+QKpS+LnAGsgX9iFKfjJAcP7XCVTFj716xUyU5IUHALX4sgYlZf0d7Trjo?=
 =?us-ascii?Q?6ptq7e13NE5fqSLCc41vhh2aI6gmlTpAF+XmtOdiV4ft/3LZaYelp6y2b5I5?=
 =?us-ascii?Q?mJtsdPBAVB6XhR63cC0fCGtjV70nFyFuplSrc2AJ5dB5OtFA10uLmks5Ru4j?=
 =?us-ascii?Q?g5MnAVIju284sfn2tHiCrDQGvSOrwrk86tCfIfmNu38LKR3h3r+A4w+DxsVw?=
 =?us-ascii?Q?8X5dvefdj/6EgyqBMoWvC7KIV7q4oZO2yoXTIS5uIksE+lx4vmFDlbGBSAL3?=
 =?us-ascii?Q?XHuk894hOeACb/4bCxx+ALbywdxSSazaGr/A7hdBRszpdlz5PKW9g0+Ina9j?=
 =?us-ascii?Q?pOSD8eCsQZ6l64DlzDQpLW6cfwZvb4oyhuPLXCZn9iBtl3tdI4WXYfa7SRMI?=
 =?us-ascii?Q?05sIVKgcIObs4fp6klyhS250HvGqpgVwI50mIVB50Sr9kdY9VoVGaoc8jMY1?=
 =?us-ascii?Q?WZUnAV1GrstIK68vb3yfmcP1AjuMaMJFOjmvz1nrHDk5c/xxXYcsf7/N8ggD?=
 =?us-ascii?Q?4+xwQ1VwlqJqXY9nWsvBIc0r/4+eLOLDHvrKY2/KJiJn9NXsKFbsJi7rXrVb?=
 =?us-ascii?Q?TUAIyomF3U5XNXKb1O50Zn6LcVehD5IOFpRXiaCHvmLbupH8r2uDFJSFii10?=
 =?us-ascii?Q?AWlUKMLu8y+WNFV0o/A5oEoUyuL4AW5/HAYUxMPlsHLtlIyXoztPCOaGWIqw?=
 =?us-ascii?Q?xW0vvNSxYpekMUcfNTi8zgPiM1Oqcnv7bqGhBCM+sogNggfd+ixIJQygKYxk?=
 =?us-ascii?Q?6X14zz7l9LUMAUnBCzfEH+JbAemJEpqPA6MPtQqdtbnEdRx6aS+BgsIqBoI7?=
 =?us-ascii?Q?rvTCJuRxdMwHj8XA64NGOntnBC/6GYbGbE2e2qfqPbfEY1vZTeVDqabRZO1G?=
 =?us-ascii?Q?JM9vzOhCdZrF4SHNeOgCm3ct+TQvyMt7NwCd8GN0TmxEw5u1cxS5767j+iyz?=
 =?us-ascii?Q?4STBswlWm27iu3dI7gIeCgP5BTZArU5GATb82xkjUwngHgiSxFCjxtjWbzeh?=
 =?us-ascii?Q?QM9Y86+sHOf5E1VLIyCXe9F7b5pQZdtDRMR4NGJDhDVG4d1gpYbTFHOIPfJN?=
 =?us-ascii?Q?kCpoduAni7NUeX197nQCe415K+J7XmFJvYSpDePw1wxCk909cvklLzAiY3b5?=
 =?us-ascii?Q?8AuayabEtqp4kbdGGduOyxHBmsn/53htatXx1vQNfoY6soaiaoUICjZZUxll?=
 =?us-ascii?Q?uGNHKwVia0IMFOFZeI8EhWNei6QnLWW1nZTclb998VZ8qALZQNRo6psvQ9Ju?=
 =?us-ascii?Q?VTZRIIzOWqyv9tW4rE2GYJTDSVv3GdX+bq5gAOtmPrFqD75z4Y5nbxJLxmq/?=
 =?us-ascii?Q?zE5LmsfkJuqUMSRa1BUgS2X+EXSSbIJ7jBifRGIAM0LEmghLn9zWAEGF0Omg?=
 =?us-ascii?Q?tVZ+kD2lC1FqFffz7KlcOLoBEnXfcBydbRKMiMjm33liwA4g986QQzsAcEKW?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7+FNDjPC5265MUVmDtFnXtfqZEag/btq4Nf1oi56op9UiWKVXW/S5czHoQIvJnOBtt3Z7sm4WKQji3oO+v3EE9w7Qh4hvDrGBKS6TX9yab3Vh/dkoGlzihNlbHPvMmt72j4txv3CeTTGkAFM0nPzDWc9KKxDwnpTM5cX98ufZVDSz9gL1KjbAnhfG1jjkFTcll7PjtrU5WUr/VVMpUhM4pSjQSRdb0V/adWRNsOqk0FCx6l1mFULI48FT7MmhJbF2yAd86B3sgaZ2l3jat7UcGPYhhO2KUIlbtITTSJ1PBs14SOLtuwiX9X/n27eiSVYGZEbgqn8i0ulN3CnBk3gbiDZmgpY1UjiLPK5QcT+wJNkftUMDQxHFObp6kq/pfVbebY9xaIX/hXFJ0P2HolZre/b0D3HoxF38PVMOkvTcVCs22mVcSOMQIb9QRsT5kVXcOAZwWijd7CKCY/T6od6u8RVpYe1Hn7YdGoh2dFwK90DZottjz1X9FaPHxP65lDIRumsQ70Mt0F3epRErpo/qUsgJ+LzwnJqS6q9i+IGvOa7eJUhP6vlKj2pS7lJZLjQQQLToQ5OWdR160mVDVtzUyh2K65TzoBJ0QP+cEulAGs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d1e585-f811-429b-d5a6-08dcceb89197
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:09.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/MdpFBVGAqNk0sdZSQVP6cVY854pYugtwTomB1e8QeWtqJXB61KJB86i5XGqerNefNID8IQnxX7LnZzQTXVJJo2G2Z8jE3baAnyy5th24o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409060157
X-Proofpoint-ORIG-GUID: EDDZfY9UtNBiOWN237-RUfV905wxqbOr
X-Proofpoint-GUID: EDDZfY9UtNBiOWN237-RUfV905wxqbOr

From: Zhang Yi <yi.zhang@huawei.com>

commit fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677 upstream.

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0ac533a18065..eb315c402794 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4595,7 +4595,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4641,7 +4642,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
-- 
2.39.3

