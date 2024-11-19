Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E768927735
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 02:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983465; cv=fail; b=d9XQKWTbKjyxuE8YHbVfP514Gtpu+dQyVgOz+9PPgVxgSu7L+LTGC5olXh8oc7GHslEna2o8rkh2Z8SVoXHmtfb+BGQtC12kAgqSjRt7HwzlsNn0RupIcgVTAbQX1QULlIz+2NZIoVHfa+FX06UcF5Ap2o85KEZLueQcNEqT/Eg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983465; c=relaxed/simple;
	bh=a7kkzeHcOAXWFG+23Dtbg5HTlKKGJmtidnzFc9U1+X4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XVc0KnAKjIQrFg1qwwnNJRaROrjvd0aZJXB/KZV4FpmslrlcqDt3eqHym6mlQEw0P07Ywg00ZeTYvmvMCo4AnMWxzVhDjh0N5O5u2mcUJoRdgcA+rdqaNrawCF/yPWddIKpPj1MZP9Vl6NlUwkmlzcbTEkdu8eveC8xhRolFAws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kpyicY6S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Fp9uPKvN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kpyicY6S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Fp9uPKvN"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ1MaZf020360;
	Tue, 19 Nov 2024 02:30:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=a7kkzeHcOAXWFG+23Dtbg5HTlKKGJmtidnzFc9U1+X4=; b=
	kpyicY6SFPyW6iNjyqOPZX9mb1jvGzrnC90XGSKtl6x/o064Bd3CMkf3cuDe1iLI
	Tv5uVFVA6HjPSm/YXee39Y6PV02zDz8KPtBfk2uxIqulheXh12+dbETuJx1xy6OE
	nWomFFpUPSxBO8mkm8787OEIruKxNfIEGKitITmvZay2KJR6lgGIZLjArUJvGs0H
	WBeyoS0WvBq9nzFsVqGuvrBtWvRfXol1q6LOwWfiKuXYt64KGqh472eFa8rQSN+G
	gbestQoUyKfINjHnAa1Z1sCu1ztubE+WVEduwCvKU7/RA7wMFGVomjZZCKFCGRIo
	GW/3yAxKkXOUvjJlLw65fw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xk0sm10d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 02:30:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AINg3Ng036939;
	Tue, 19 Nov 2024 02:30:56 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42xhu7xsak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 02:30:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4nAwEwxs5Bq6GY3sBNkPiUakh8yDNH4jz7zfUA2askQb9gERzvSglXhdNUDNNdG+an76nKRG8+RphPhSTmP/O+93EQlsOuu8iTpwq7rY2SRaYGfT74AUUzQZZgQc0g7k7DK1OkzEAmvnbztyrC5KxigMB+BNrTzr/S/nO8Ng3C6lRpiahMzdx5Cf3ruMYeIlfKaiCdJOm/gvomyt3LMP6bj87l5qQyjoiQINwAfzzfYJ6OcaOPRQeWmn9Oulkh3mAsuoEqMwJjoqmqXlFb+mmDoEATAfnAwHu7kU7/a42jfBF63YO66dTRMd2rj3Szd+7bZPNABovzFLFJzTHapag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7kkzeHcOAXWFG+23Dtbg5HTlKKGJmtidnzFc9U1+X4=;
 b=bc3cUJx4BAHEpUyFp6sXBnfJLx6xC4KYvNtdy8G2HhHbPAqNMaMVYatRnS614MdgXRIRtc/adDKmDCYim44hSekpCUgWsgh5meYxf8uOjK6iH9GGOxo7G/uOjSZRE9Qt5rr6cRWZt0CEcndYYlFvfcGZ25kupxdoJ5jRuZGw5NcSDFBrXxSIRSbX14hcc0sCVI0CI2+no8NLP6l1BsLCbqb2/OiEGOS7gKywrwE/aoORzfLV/20DI9CDhIqj0CYeduVOBFRpHIJ+bA6By0IhVX4PLXx+PYoThrfowRlqLY9m1sHd2PtOaroA4aFchtFXLRm9qvg1s/y9KTVAw0yDBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7kkzeHcOAXWFG+23Dtbg5HTlKKGJmtidnzFc9U1+X4=;
 b=Fp9uPKvNptt98eGCUQPtW8ed5XFyslZy/tSzZ4fELr8DjaTja9N12ol33j5CH19/mnEQWWgYFZidjY7xnBuXqLhWVGFGzlCgNU2C9nDh+UzZomR2Wioz7ZLs/XMELAqhYcQb+Jm66qePnbL5ZQnoYXUZ0GbI+n9v0LUyTcebZHE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB7802.namprd10.prod.outlook.com (2603:10b6:510:30c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Tue, 19 Nov
 2024 02:30:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%3]) with mapi id 15.20.8158.023; Tue, 19 Nov 2024
 02:30:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_io: add support for atomic write statx fields
Thread-Topic: [PATCH v2] xfs_io: add support for atomic write statx fields
Thread-Index: AQHbOisNbpqOKzvTqUy5Jd6XAP2BVQ==
Date: Tue, 19 Nov 2024 02:30:52 +0000
Message-ID: <EF17168C-C933-4A14-B8F5-DD8E7EA37CCA@oracle.com>
References: <20241118235255.23133-1-catherine.hoang@oracle.com>
 <20241119000154.GS9438@frogsfrogsfrogs>
In-Reply-To: <20241119000154.GS9438@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.400.31)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|PH7PR10MB7802:EE_
x-ms-office365-filtering-correlation-id: 115c8986-bcc9-4638-898b-08dd08423045
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YlE4a3MxQVpQTUVzeWtuUHRMOEIyWnc4N0lWellqNUJZTVpRZWhyZXV2VnhI?=
 =?utf-8?B?Z2dXVkJPb045NTQ2bWYrd20xY1lEWldka2o1bEcvS1VpSGhYbk9RZEkzRVhE?=
 =?utf-8?B?bnFlL3ZjZGtkL003TkhoTjMvV1haeVlDOGx0WkRXamNScHdUOHJJUHZpamNu?=
 =?utf-8?B?KzAzMVdKZSt3dWZoY1loTGNON1BYT1RaUVZnRE14K3FTVis1VisyRm53cUlj?=
 =?utf-8?B?VVVVQ2oxd09PVXdHL2ZFUlRpUmJGRTM1THVDVUxVYWdBYmJDeDd5WldEZHEy?=
 =?utf-8?B?c2JXWGxYSWpVNHBxZHUzdDNIa1V5N1JxUUhEYUVXVVNEUDZKV1JFTXBMV2lP?=
 =?utf-8?B?a1NyVmZVMEhRVkJ6SHJ3SFAxZ0ZmNWZNVGN4ck5GckdGbGx2Y0NyVm9hWjli?=
 =?utf-8?B?Sk5SYU9jUFpHbEJKMWYvVnZzbzJnRnVVKzlBczBZRlY2NHcvakZsWVRGdU9E?=
 =?utf-8?B?NjZ6dFBJdmkrS1h3U0JNNWFzS1VxY1UvZFdnZ2MydEVYYzEweXk0SVQxRzB1?=
 =?utf-8?B?TWZMT1IreEFXZ2JSVDAzZ0ZLd1RYUHV0N1dnVnZZMk9iM3lwVWpDNEVTV25M?=
 =?utf-8?B?VFh1T0M1elNNY0lRL2pCRzNTa0lRaDUvUVJPRVROdHIyWTlzVzJxWHRUYXBK?=
 =?utf-8?B?TEl2UlZWZEl3SlZhRGw2RHNLT25ERVZPRW8vYWxzbjN3d0ZFcFR5NjVtWWtz?=
 =?utf-8?B?alBZcGdvcll4V0l6RzNJdzBxOHZVWXJ0OG9TczJ0MVlaN250OHVSeGxUYkpO?=
 =?utf-8?B?VXlKU0xIV0Q4T2Y4L3NUNzdRTWl1cHlJcitBRUJiS21IZHRveXlxY0V6R3BS?=
 =?utf-8?B?MzBoZzBtSWVJU2VKeGE4ZjVOdkd5UGpoZWlscGF3a2RSSTdFdUdIaEdEUUZI?=
 =?utf-8?B?Z1pnN3lDTkxXWldXVlJmV3NPbGZNcTQyQ3JVU2hjK21UOFZ2SjFkTW9reFhO?=
 =?utf-8?B?b3V1TWhYTXgrYnNicExDaVh5ak5iTGZmYWNYZ3VqNUFzMFgwamplVmlUN0s1?=
 =?utf-8?B?OGpFUXBVaCtDNmtqSkl5STFQWDdiZmVzUkphWmwyQW4wandXNUs2NytlVldx?=
 =?utf-8?B?TWo2RlA0ZjZGenBsaCtGOXdVeFRNTmRFVVF3THdsa3hpY0JUTnVxS0dvdzdI?=
 =?utf-8?B?bEV6RnNCOFU4VFRJUVlLbnJqNmJVbWJNdmF0RXU2Zm5tMkNoS25LRFNORU9E?=
 =?utf-8?B?aXM5OHlmNGUrZ1RZdzlwSUdyL1VBZnAweVVTVGRySlhqbDlpdUx0N3poM2lx?=
 =?utf-8?B?cnlGNXhRZ2tTaUZ4dU5TQ05aVVdlT2F1MTlPZEM5ZVNyL0lkdS8vTzlMUnlJ?=
 =?utf-8?B?S0xGbnVNd2NOeFcwN3lpQk5tOW9BVVpxMUpMTnJkaDBUYS9TYXJJRjZ6TjRI?=
 =?utf-8?B?bFlMZDU2YmhQeFpad0xLbUphYlZXSGtHaUdraXRmclZ1L29pak14S3JKbVNz?=
 =?utf-8?B?VEN0ZDR4V2xyZDVVVXo3K3piQ2FXMmNrUDBrSmtnTUNWdWx0RndVak90OUFI?=
 =?utf-8?B?MlhaYXhTOUJMd2ZSTFN0VGFKM1R2SkxjQXN4a2FqYjdzc0lHNVlqTGcyTUg3?=
 =?utf-8?B?MTBpVGpJNEduVitteis4ZDlKTXhmeEVFNzBDSGU2TW9PeWx4U1pKeCswOUtw?=
 =?utf-8?B?b1ZiTExXdDFSVWJYRG83ODJzb2RPdTJ4S3A3Z1dibnFiODhUdzVyZVB4UU1M?=
 =?utf-8?B?TWVkUkgzQVUrZDlicFB4Z0x5RkdDWG1PU2Y5MGpwYzRtWkRqdjJPTFM4MTZj?=
 =?utf-8?B?SklaWTlQclh1Zld0OFl4MHl1YVRmQWVMZVF1a1JFZlVlYlVNZWJ1NUorRTUr?=
 =?utf-8?Q?xMZXGLULoF0gKtITbRnw6l8sIhqmtxlakXrvM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?REdIOFVCRHFyYzZydmhOSmkwQXkxRmdHQnl1ZGlYdDk5dDRxK0traUFuU1lk?=
 =?utf-8?B?VlZBa0NNSS8rNlk1N2FwRkFyY2s0THVTMlpSQ3RuT1VxeHp2TjAwdlBTZzJp?=
 =?utf-8?B?TGhGVWV0V2hTa1Vqb3BVbG5ZTU9hV2FHZEhpZE40cStsaWtycStOcU5sN3Nz?=
 =?utf-8?B?eEh1ekVwVTl1a1lpOHc2NG9USnI3WUJlckxhdVZ4T1RUSGRTbU1nRVRRSmxU?=
 =?utf-8?B?UDBOZXpmK3QvTmJaVXVnTnduVEdCeGtvWkpWRTYzY1lpN2JpVXpGcnFUY05R?=
 =?utf-8?B?SjdVbmpXWi9WVVNLYkhTc0dVNjV2NmhNVGtQMTVLRnRoL3U0bVYvL2QwUFIx?=
 =?utf-8?B?aTV6dHRyU0dBWnNkaCtOUEp2alBHR3dUQUhGMGZ6ZlExNGNzZjNhbHNZQTRV?=
 =?utf-8?B?VnN5ZnZKR1B5eUs0WUFveXMzalZvR0R2eThiMEZUc1pDY3dwWkkxa293MzB1?=
 =?utf-8?B?Ly81TVpFMnBUcWtBL2xGeFBJVCtpcHVMVUNyQmhYSWxzQXl0cUxCODM0Sloz?=
 =?utf-8?B?TGNxbzI1dzNKR3lxWnFqSFZ3aGtyR0dTS2hUUGtGYzVoSGFTQTYvYXR4eEx6?=
 =?utf-8?B?SllWTXhQcUhBY3NOQ3FWaDV2TzNwT3JIZG5TWUlaVnZKQ3Q0bXg2cFV3aTk3?=
 =?utf-8?B?eEF5YjNRd1ZKLzVyd0h0SUZWdS9rTklVMUVnN0hJb0ZXcmdDRkwwU1IxTlVQ?=
 =?utf-8?B?Mm1xY01nakdDVThLMGhhV2hUZVp3R1ZQNlZaOWJhVjhjdmpNUE1scU5VYWR3?=
 =?utf-8?B?ZSs4L3Naa2lGMjdRSllJdzRtR2taSk9PNGhzYzBvMFZSajB4NkVwMzVESXhw?=
 =?utf-8?B?ZWhsUUt5WkFBSEFBcTlMWU43WC9senptQys5aWhiTVQ1amd2OEMzUzA3Qk4v?=
 =?utf-8?B?SEFyNVRZMmh5UzBxemY2V1BidmlvTUdyOC8xUC9zMFJTS3pMcjlwZWRiUEMz?=
 =?utf-8?B?RDMvUks4WjF5WDJhdWkyajEyQzluV1J4TzRyM2ppRlhHL25peG5lQlNCVUJW?=
 =?utf-8?B?emNicGZMd29ialo4UU5nKzkvSTNNS3JoVDdQSTJuOHlWVDNTNTV3TDRtbFlw?=
 =?utf-8?B?ZVZlZlhPY0ExVEsyZmdQMmJ0N05tQW1lNVJRS0dYcnVTYTZmemdnVmhaajJQ?=
 =?utf-8?B?dUJZbTZGZmtEWG4ralBwZGRyOFRvNm5zcFdQUGVmWDhjS3d4MDZlZlVnRmRU?=
 =?utf-8?B?Qm0xL05HYzdSZEp0Ri8reE53MWZWbnFBYUxkL0U0RHlNVjhFVGdhRStSM29Z?=
 =?utf-8?B?ZzZqNGh0TUZYeWxsQ2tWbVg3Rk1mbUVyNTBkTVFvVmY4TTU1cnBaMVBqS0oz?=
 =?utf-8?B?bjU4Vm9YbFQ5b3ZzdkxQWXE4NmN1cUVRQnJYSTl1UlBSWjNTbE0xTkdYZUhp?=
 =?utf-8?B?TVZlcGJ2aFU2SXkvZ29qR0Zma3p1NW1DWFByT3FwdlRzaFdqVHh6b2huRVQ1?=
 =?utf-8?B?TzRqUFo1RUFTb0RQaVMybGtrZzA5ZldlcVU4SGpwa2Zpb08ySEZxRUVZbXZk?=
 =?utf-8?B?SUVvSTNTL2JHanpFbjlQV2tuN1N1SldkL09Pb2NOekx3NE9YcTYyUTZoWUZp?=
 =?utf-8?B?ZHVGc01oYlpRUzl2RzBmTDM0czFTZHVRNll1dnl6bm94aFhMK2ppb0RBd0NE?=
 =?utf-8?B?a0puaFJ2YTBTZkV5UUovcHZUN1I1d3JiMk45TlgrS3FROTlWU2RlV0lxUmJh?=
 =?utf-8?B?MytkK1NZRlpsVjg0YWVhL2dLNUNsV2M4cFR5UWk4NWxOOTlSc0dKbzVkWHlw?=
 =?utf-8?B?a1BUMTVvNzUrVUtya3BhcDdHVUMrMWJ4M2VsY285Smk4dmVrbnVaNldXV3dP?=
 =?utf-8?B?QmFXZFZVTWpSSVg3WXVIbmhUN0ZuRkxwZ2RSRWp1c01xZHhiRWR5aG1ocW82?=
 =?utf-8?B?R2hJUDdMU25tS0krYXc0Mk9TbGhiYjEwU3hiTktVSXg4eTgveWxRT0pvL2Rv?=
 =?utf-8?B?dkgwc2MxenJMUHRocXRlcGhmV0NDL3gxZDB5UWZZSDlPMGY3Q2w1akQveGp4?=
 =?utf-8?B?dGJJY2Fia3hNS1EveW0vU1AwR2J3djhscVRMZlgyYzVQMjkzNEduWkFnR2NK?=
 =?utf-8?B?LzdHSUh6czBLVTltSWRrQmo4NWRNWTJiQkZ4eXluREVJNENENm5Ld3NLZnF1?=
 =?utf-8?B?SUNjQ1o2amtROXFrc2w0cHpDelpNS3p3c3E3NmFXL0dBS1FsVEdZTkRNU3VK?=
 =?utf-8?Q?v0uW+9gidzMHxv6nloKUJ7s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A45598280676D44385838F2C6F656418@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lf+jUpOhZ8CMsHmpKU0f09BX9vP/l+VoHwxcip6fqgs0gRhLIFnYIh10hSsAVjBDI1Xqvs97lqA1aO2aqnluzDDHrBRshy4tevsL/P5f9cPze7vC64Gkc0FhKca+XXRX+3E+znwuURDFp2JrB2VCFtYEVfROcHO3oAXENhD70a0BIPaDGvR/ypxbOnM+PPZ0P0jtYXIh4xvPu56CQwM2OTaPRm0rn9cHtl7s1Q9r3aw+1KxMgs7U9/eX0ETpwjctmMlP9C1HvcbimBGyXKYi5cjMvIgCoUSEmElmy3sCU/AaKzqJZNxni0E03gQEZarOfcJZX/Uwjo7h4DblgD3kxiDPet4LfOoCwmsQI38hw+QVCkNeyEN865voZ3ZGLt5nVsctNSwQAblzWF37SFLZRvDkzQnH1zoL6dwrk0Njt+C8ePgtwF3BblJHdTtkeV1+EnxC3ALD0n7NhC36PTLwWrNxo5kdjgqAJceEvHyxH7jmGoxzi6YTuRQCDzR+gDKoDNju+Qtivk1oYj1KkjPlVBBp7W03vKq2ROkjhkYtg3htEDxglC6qOpF+gjqvUzYLywWRHIpF0bKbKJ4BvCCTqdlRJz79RCDm6IJoH+h/9y8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115c8986-bcc9-4638-898b-08dd08423045
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2024 02:30:52.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vz4SyOAor7xU/NqSBNEqNf/T3QmLVljWGaNVUm/6XxpWmxpUnKfQ5UPylmCyFr7Y5RnJItop/HmqXcAAhfFW9jdKR/0xCJr0IKmZ9gcs8Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7802
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-18_17,2024-11-18_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411190020
X-Proofpoint-ORIG-GUID: vTkY2VnMNlXYiaeLC9eHE_or7y3epxvi
X-Proofpoint-GUID: vTkY2VnMNlXYiaeLC9eHE_or7y3epxvi

PiBPbiBOb3YgMTgsIDIwMjQsIGF0IDQ6MDHigK9QTSwgRGFycmljayBKLiBXb25nIDxkandvbmdA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIE5vdiAxOCwgMjAyNCBhdCAwMzo1Mjo1
NVBNIC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6DQo+PiBBZGQgc3VwcG9ydCBmb3IgdGhl
IG5ldyBhdG9taWNfd3JpdGVfdW5pdF9taW4sIGF0b21pY193cml0ZV91bml0X21heCwgYW5kDQo+
PiBhdG9taWNfd3JpdGVfc2VnbWVudHNfbWF4IGZpZWxkcyBpbiBzdGF0eCBmb3IgeGZzX2lvLiBJ
biBvcmRlciB0byBzdXBwb3J0IGJ1aWxkcw0KPj4gYWdhaW5zdCBvbGQga2VybmVsIGhlYWRlcnMs
IGRlZmluZSBvdXIgb3duIGludGVybmFsIHN0YXR4IHN0cnVjdHMuIElmIHRoZQ0KPj4gc3lzdGVt
J3Mgc3RydWN0IHN0YXR4IGRvZXMgbm90IGhhdmUgdGhlIHJlcXVpcmVkIGF0b21pYyB3cml0ZSBm
aWVsZHMsIG92ZXJyaWRlDQo+PiB0aGUgc3RydWN0IGRlZmluaXRpb25zIHdpdGggdGhlIGludGVy
bmFsIGRlZmluaXRpb25zIGluIHN0YXR4LmguDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IENhdGhl
cmluZSBIb2FuZyA8Y2F0aGVyaW5lLmhvYW5nQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+IGNvbmZp
Z3VyZS5hYyAgICAgICAgICB8ICAxICsNCj4+IGluY2x1ZGUvYnVpbGRkZWZzLmluICB8ICA0ICsr
KysNCj4+IGlvL3N0YXQuYyAgICAgICAgICAgICB8ICA3ICsrKysrKysNCj4+IGlvL3N0YXR4Lmgg
ICAgICAgICAgICB8IDIzICsrKysrKysrKysrKysrKysrKysrKystDQo+PiBtNC9wYWNrYWdlX2xp
YmNkZXYubTQgfCAyMCArKysrKysrKysrKysrKysrKysrKw0KPj4gNSBmaWxlcyBjaGFuZ2VkLCA1
NCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9jb25m
aWd1cmUuYWMgYi9jb25maWd1cmUuYWMNCj4+IGluZGV4IDMzYjAxMzk5Li4wYjFlZjNjMyAxMDA2
NDQNCj4+IC0tLSBhL2NvbmZpZ3VyZS5hYw0KPj4gKysrIGIvY29uZmlndXJlLmFjDQo+PiBAQCAt
MTQ2LDYgKzE0Niw3IEBAIEFDX0hBVkVfQ09QWV9GSUxFX1JBTkdFDQo+PiBBQ19ORUVEX0lOVEVS
TkFMX0ZTWEFUVFINCj4+IEFDX05FRURfSU5URVJOQUxfRlNDUllQVF9BRERfS0VZX0FSRw0KPj4g
QUNfTkVFRF9JTlRFUk5BTF9GU0NSWVBUX1BPTElDWV9WMg0KPj4gK0FDX05FRURfSU5URVJOQUxf
U1RBVFgNCj4+IEFDX0hBVkVfR0VURlNNQVANCj4+IEFDX0hBVkVfTUFQX1NZTkMNCj4+IEFDX0hB
VkVfREVWTUFQUEVSDQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9idWlsZGRlZnMuaW4gYi9pbmNs
dWRlL2J1aWxkZGVmcy5pbg0KPj4gaW5kZXggMTY0N2QyY2QuLmNiYzlhYjBjIDEwMDY0NA0KPj4g
LS0tIGEvaW5jbHVkZS9idWlsZGRlZnMuaW4NCj4+ICsrKyBiL2luY2x1ZGUvYnVpbGRkZWZzLmlu
DQo+PiBAQCAtOTYsNiArOTYsNyBAQCBIQVZFX0NPUFlfRklMRV9SQU5HRSA9IEBoYXZlX2NvcHlf
ZmlsZV9yYW5nZUANCj4+IE5FRURfSU5URVJOQUxfRlNYQVRUUiA9IEBuZWVkX2ludGVybmFsX2Zz
eGF0dHJADQo+PiBORUVEX0lOVEVSTkFMX0ZTQ1JZUFRfQUREX0tFWV9BUkcgPSBAbmVlZF9pbnRl
cm5hbF9mc2NyeXB0X2FkZF9rZXlfYXJnQA0KPj4gTkVFRF9JTlRFUk5BTF9GU0NSWVBUX1BPTElD
WV9WMiA9IEBuZWVkX2ludGVybmFsX2ZzY3J5cHRfcG9saWN5X3YyQA0KPj4gK05FRURfSU5URVJO
QUxfU1RBVFggPSBAbmVlZF9pbnRlcm5hbF9zdGF0eEANCj4+IEhBVkVfR0VURlNNQVAgPSBAaGF2
ZV9nZXRmc21hcEANCj4+IEhBVkVfTUFQX1NZTkMgPSBAaGF2ZV9tYXBfc3luY0ANCj4+IEhBVkVf
REVWTUFQUEVSID0gQGhhdmVfZGV2bWFwcGVyQA0KPj4gQEAgLTEzMCw2ICsxMzEsOSBAQCBlbmRp
Zg0KPj4gaWZlcSAoJChORUVEX0lOVEVSTkFMX0ZTQ1JZUFRfUE9MSUNZX1YyKSx5ZXMpDQo+PiBQ
Q0ZMQUdTKz0gLURPVkVSUklERV9TWVNURU1fRlNDUllQVF9QT0xJQ1lfVjINCj4+IGVuZGlmDQo+
PiAraWZlcSAoJChORUVEX0lOVEVSTkFMX1NUQVRYKSx5ZXMpDQo+PiArUENGTEFHUys9IC1ET1ZF
UlJJREVfU1lTVEVNX1NUQVRYDQo+PiArZW5kaWYNCj4+IGlmZXEgKCQoSEFWRV9HRVRGU01BUCks
eWVzKQ0KPj4gUENGTEFHUys9IC1ESEFWRV9HRVRGU01BUA0KPj4gZW5kaWYNCj4+IGRpZmYgLS1n
aXQgYS9pby9zdGF0LmMgYi9pby9zdGF0LmMNCj4+IGluZGV4IDBmNTYxOGY2Li43ZDFjMWM5MyAx
MDA2NDQNCj4+IC0tLSBhL2lvL3N0YXQuYw0KPj4gKysrIGIvaW8vc3RhdC5jDQo+PiBAQCAtNiw2
ICs2LDEwIEBADQo+PiAgKiBQb3J0aW9ucyBvZiBzdGF0eCBzdXBwb3J0IHdyaXR0ZW4gYnkgRGF2
aWQgSG93ZWxscyAoZGhvd2VsbHNAcmVkaGF0LmNvbSkNCj4+ICAqLw0KPj4gDQo+PiArI2lmZGVm
IE9WRVJSSURFX1NZU1RFTV9TVEFUWA0KPj4gKyNkZWZpbmUgc3RhdHggc3lzX3N0YXR4DQo+PiAr
I2VuZGlmDQo+PiArDQo+PiAjaW5jbHVkZSAiY29tbWFuZC5oIg0KPj4gI2luY2x1ZGUgImlucHV0
LmgiDQo+PiAjaW5jbHVkZSAiaW5pdC5oIg0KPj4gQEAgLTM0Nyw2ICszNTEsOSBAQCBkdW1wX3Jh
d19zdGF0eChzdHJ1Y3Qgc3RhdHggKnN0eCkNCj4+IHByaW50Zigic3RhdC5yZGV2X21pbm9yID0g
JXVcbiIsIHN0eC0+c3R4X3JkZXZfbWlub3IpOw0KPj4gcHJpbnRmKCJzdGF0LmRldl9tYWpvciA9
ICV1XG4iLCBzdHgtPnN0eF9kZXZfbWFqb3IpOw0KPj4gcHJpbnRmKCJzdGF0LmRldl9taW5vciA9
ICV1XG4iLCBzdHgtPnN0eF9kZXZfbWlub3IpOw0KPj4gKyBwcmludGYoInN0YXQuYXRvbWljX3dy
aXRlX3VuaXRfbWluID0gJWxsZFxuIiwgKGxvbmcgbG9uZylzdHgtPnN0eF9hdG9taWNfd3JpdGVf
dW5pdF9taW4pOw0KPj4gKyBwcmludGYoInN0YXQuYXRvbWljX3dyaXRlX3VuaXRfbWF4ID0gJWxs
ZFxuIiwgKGxvbmcgbG9uZylzdHgtPnN0eF9hdG9taWNfd3JpdGVfdW5pdF9tYXgpOw0KPj4gKyBw
cmludGYoInN0YXQuYXRvbWljX3dyaXRlX3NlZ21lbnRzX21heCA9ICVsbGRcbiIsIChsb25nIGxv
bmcpc3R4LT5zdHhfYXRvbWljX3dyaXRlX3NlZ21lbnRzX21heCk7DQo+PiByZXR1cm4gMDsNCj4+
IH0NCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2lvL3N0YXR4LmggYi9pby9zdGF0eC5oDQo+PiBpbmRl
eCBjNjYyNWFjNC4uZDE1MWY3MzIgMTAwNjQ0DQo+PiAtLS0gYS9pby9zdGF0eC5oDQo+PiArKysg
Yi9pby9zdGF0eC5oDQo+PiBAQCAtNjEsNiArNjEsNyBAQCBzdHJ1Y3Qgc3RhdHhfdGltZXN0YW1w
IHsNCj4+IF9fczMyIHR2X25zZWM7DQo+PiBfX3MzMiBfX3Jlc2VydmVkOw0KPj4gfTsNCj4+ICsj
ZW5kaWYNCj4+IA0KPj4gLyoNCj4+ICAqIFN0cnVjdHVyZXMgZm9yIHRoZSBleHRlbmRlZCBmaWxl
IGF0dHJpYnV0ZSByZXRyaWV2YWwgc3lzdGVtIGNhbGwNCj4+IEBAIC05OSw2ICsxMDAsOCBAQCBz
dHJ1Y3Qgc3RhdHhfdGltZXN0YW1wIHsNCj4+ICAqIHdpbGwgaGF2ZSB2YWx1ZXMgaW5zdGFsbGVk
IGZvciBjb21wYXRpYmlsaXR5IHB1cnBvc2VzIHNvIHRoYXQgc3RhdCgpIGFuZA0KPj4gICogY28u
IGNhbiBiZSBlbXVsYXRlZCBpbiB1c2Vyc3BhY2UuDQo+PiAgKi8NCj4+ICsjaWYgIWRlZmluZWQg
U1RBVFhfVFlQRSB8fCBkZWZpbmVkIE9WRVJSSURFX1NZU1RFTV9TVEFUWA0KPiANCj4gSXMgdGhl
cmUgYW55IHBsYWNlIHdoZXJlIFNUQVRYX1RZUEUgaXMgbm90IGRlZmluZWQgYnV0DQo+IE9WRVJS
SURFX1NZU1RFTV9TVEFUWCB3aWxsICphbHNvKiBub3QgYmUgZGVmaW5lZD8NCg0KSSBkb27igJl0
IHRoaW5rIHNvLiBTbyBJIGd1ZXNzIHRoaXMgY291bGQganVzdCBiZQ0KDQojaWZkZWYgT1ZFUlJJ
REVfU1lTVEVNX1NUQVRYDQoNCkRvZXMgdGhhdCBzZWVtIHJpZ2h0Pw0KPiANCj4gSSB0aGluayB0
aGUgbTQgbWFjcm8geW91IGFkZGVkIHNldHMgbmVlZF9pbnRlcm5hbF9zdGF0eD15ZXMgZm9yIG9s
ZA0KPiBzeXN0ZW1zIHdoZXJlIHRoZXJlJ3Mgbm8gU1RBVFhfVFlQRSwgYmVjYXVzZSB0aGVyZSB3
b24ndCBiZSBhIHN0cnVjdA0KPiBzdGF0eCwgbGV0IGFsb25lIGF0b21pY193cml0ZV8qIGZpZWxk
cyBpbiBpdCwgcmlnaHQ/DQo+IA0KPiAtLUQNCj4gDQo+PiArI3VuZGVmIHN0YXR4DQo+PiBzdHJ1
Y3Qgc3RhdHggew0KPj4gLyogMHgwMCAqLw0KPj4gX191MzIgc3R4X21hc2s7IC8qIFdoYXQgcmVz
dWx0cyB3ZXJlIHdyaXR0ZW4gW3VuY29uZF0gKi8NCj4+IEBAIC0xMjYsMTAgKzEyOSwyMyBAQCBz
dHJ1Y3Qgc3RhdHggew0KPj4gX191MzIgc3R4X2Rldl9tYWpvcjsgLyogSUQgb2YgZGV2aWNlIGNv
bnRhaW5pbmcgZmlsZSBbdW5jb25kXSAqLw0KPj4gX191MzIgc3R4X2Rldl9taW5vcjsNCj4+IC8q
IDB4OTAgKi8NCj4+IC0gX191NjQgX19zcGFyZTJbMTRdOyAvKiBTcGFyZSBzcGFjZSBmb3IgZnV0
dXJlIGV4cGFuc2lvbiAqLw0KPj4gKyBfX3U2NCBzdHhfbW50X2lkOw0KPj4gKyBfX3UzMiBzdHhf
ZGlvX21lbV9hbGlnbjsgLyogTWVtb3J5IGJ1ZmZlciBhbGlnbm1lbnQgZm9yIGRpcmVjdCBJL08g
Ki8NCj4+ICsgX191MzIgc3R4X2Rpb19vZmZzZXRfYWxpZ247IC8qIEZpbGUgb2Zmc2V0IGFsaWdu
bWVudCBmb3IgZGlyZWN0IEkvTyAqLw0KPj4gKyAvKiAweGEwICovDQo+PiArIF9fdTY0IHN0eF9z
dWJ2b2w7IC8qIFN1YnZvbHVtZSBpZGVudGlmaWVyICovDQo+PiArIF9fdTMyIHN0eF9hdG9taWNf
d3JpdGVfdW5pdF9taW47IC8qIE1pbiBhdG9taWMgd3JpdGUgdW5pdCBpbiBieXRlcyAqLw0KPj4g
KyBfX3UzMiBzdHhfYXRvbWljX3dyaXRlX3VuaXRfbWF4OyAvKiBNYXggYXRvbWljIHdyaXRlIHVu
aXQgaW4gYnl0ZXMgKi8NCj4+ICsgLyogMHhiMCAqLw0KPj4gKyBfX3UzMiAgIHN0eF9hdG9taWNf
d3JpdGVfc2VnbWVudHNfbWF4OyAvKiBNYXggYXRvbWljIHdyaXRlIHNlZ21lbnQgY291bnQgKi8N
Cj4+ICsgX191MzIgICBfX3NwYXJlMVsxXTsNCj4+ICsgLyogMHhiOCAqLw0KPj4gKyBfX3U2NCBf
X3NwYXJlM1s5XTsgLyogU3BhcmUgc3BhY2UgZm9yIGZ1dHVyZSBleHBhbnNpb24gKi8NCj4+IC8q
IDB4MTAwICovDQo+PiB9Ow0KPj4gKyNlbmRpZg0KPj4gDQo+PiArI2lmbmRlZiBTVEFUWF9UWVBF
DQo+PiAvKg0KPj4gICogRmxhZ3MgdG8gYmUgc3R4X21hc2sNCj4+ICAqDQo+PiBAQCAtMTc0LDQg
KzE5MCw5IEBAIHN0cnVjdCBzdGF0eCB7DQo+PiAjZGVmaW5lIFNUQVRYX0FUVFJfQVVUT01PVU5U
IDB4MDAwMDEwMDAgLyogRGlyOiBBdXRvbW91bnQgdHJpZ2dlciAqLw0KPj4gDQo+PiAjZW5kaWYg
LyogU1RBVFhfVFlQRSAqLw0KPj4gKw0KPj4gKyNpZm5kZWYgU1RBVFhfV1JJVEVfQVRPTUlDDQo+
PiArI2RlZmluZSBTVEFUWF9XUklURV9BVE9NSUMgMHgwMDAxMDAwMFUgLyogV2FudC9nb3QgYXRv
bWljX3dyaXRlXyogZmllbGRzICovDQo+PiArI2VuZGlmDQo+PiArDQo+PiAjZW5kaWYgLyogWEZT
X0lPX1NUQVRYX0ggKi8NCj4+IGRpZmYgLS1naXQgYS9tNC9wYWNrYWdlX2xpYmNkZXYubTQgYi9t
NC9wYWNrYWdlX2xpYmNkZXYubTQNCj4+IGluZGV4IDZkZThiMzNlLi5iYzhhNDlhOSAxMDA2NDQN
Cj4+IC0tLSBhL200L3BhY2thZ2VfbGliY2Rldi5tNA0KPj4gKysrIGIvbTQvcGFja2FnZV9saWJj
ZGV2Lm00DQo+PiBAQCAtOTgsNiArOTgsMjYgQEAgQUNfREVGVU4oW0FDX05FRURfSU5URVJOQUxf
RlNDUllQVF9QT0xJQ1lfVjJdLA0KPj4gICAgIEFDX1NVQlNUKG5lZWRfaW50ZXJuYWxfZnNjcnlw
dF9wb2xpY3lfdjIpDQo+PiAgIF0pDQo+PiANCj4+ICsjDQo+PiArIyBDaGVjayBpZiB3ZSBuZWVk
IHRvIG92ZXJyaWRlIHRoZSBzeXN0ZW0gc3RydWN0IHN0YXR4IHdpdGgNCj4+ICsjIHRoZSBpbnRl
cm5hbCBkZWZpbml0aW9uLiAgVGhpcyAvb25seS8gaGFwcGVucyBpZiB0aGUgc3lzdGVtDQo+PiAr
IyBhY3R1YWxseSBkZWZpbmVzIHN0cnVjdCBzdGF0eCAvYW5kLyB0aGUgc3lzdGVtIGRlZmluaXRp
b24NCj4+ICsjIGlzIG1pc3NpbmcgY2VydGFpbiBmaWVsZHMuDQo+PiArIw0KPj4gK0FDX0RFRlVO
KFtBQ19ORUVEX0lOVEVSTkFMX1NUQVRYXSwNCj4+ICsgIFsgQUNfQ0hFQ0tfVFlQRShzdHJ1Y3Qg
c3RhdHgsDQo+PiArICAgICAgWw0KPj4gKyAgICAgICAgQUNfQ0hFQ0tfTUVNQkVSKHN0cnVjdCBz
dGF0eC5zdHhfYXRvbWljX3dyaXRlX3VuaXRfbWluLA0KPj4gKyAgICAgICAgICAsDQo+PiArICAg
ICAgICAgIG5lZWRfaW50ZXJuYWxfc3RhdHg9eWVzLA0KPj4gKyAgICAgICAgICBbI2luY2x1ZGUg
PGxpbnV4L3N0YXQuaD5dDQo+PiArICAgICAgICApDQo+PiArICAgICAgXSwsDQo+PiArICAgICAg
WyNpbmNsdWRlIDxsaW51eC9zdGF0Lmg+XQ0KPj4gKyAgICApDQo+PiArICAgIEFDX1NVQlNUKG5l
ZWRfaW50ZXJuYWxfc3RhdHgpDQo+PiArICBdKQ0KPj4gKw0KPj4gIw0KPj4gIyBDaGVjayBpZiB3
ZSBoYXZlIGEgRlNfSU9DX0dFVEZTTUFQIGlvY3RsIChMaW51eCkNCj4+ICMNCj4+IC0tIA0KPj4g
Mi4zNC4xDQo+PiANCj4+IA0KDQo=
