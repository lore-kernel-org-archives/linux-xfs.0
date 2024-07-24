Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4AD613D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 19:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721848953; cv=fail; b=qTwKMt4NC348/W2NOvUoYm4HuDC9fx37Wvx2/oPB9MAoHU6aa0T9DJwOmSpobXrnDEp8gjguRVz25zRX/9rVTDAlgOTT5CIZ9Vqj/roMgPngvWPb6qpYHp7ARlf4JLyaJmDbn5lOK1dc15sV5l5DoEgIJBKZNKkIoPg/3ltu+rY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721848953; c=relaxed/simple;
	bh=uioevvaMw0mDS2TQGSDPYEJ+gp/tYrE8L5SfqnwyAiQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CrDarwnypgD/yrt2IZZJXbtX5HOGY0j6mkovaEfS69NybZ4PwsjTYDqoN4+dP5blAmMYN9jQrgJOJjQ1Z44sJgFa3/aJ5KmWsT05xgWloTeAi48ZlbBk4BVibqe2UCr2eOjxWkUP5LCfTEQyPBwp22O6xwDQffzJDoBlB1Ww9dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IcudxOnO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eK9bL0pM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IcudxOnO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eK9bL0pM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46OFXraF029476;
	Wed, 24 Jul 2024 19:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=uioevvaMw0mDS2TQGSDPYEJ+gp/tYrE8L5SfqnwyA
	iQ=; b=IcudxOnOBnKYP7fedp3bQHvMxJD1pFXhySld+rPMm3rNzjRGvcFiepGaV
	aYxJfkj/weVACWWpbZaLTFUe3UvAVCySzLtWFsEkEHDAE7PO+Y3/E6V/XzvnETvO
	0FBuZJkdYu0FISj8nKSRWDV86E2x+OJ6ymTUf77QB2ok9+wgPD4wQmPvUwAVm6Jv
	o6bXhWxq7FYO3rtK8zZhY5tN9upDRcVnYS6vzxAbH8OvvtsoG9RH92VCnVwjtcdQ
	+m5NjRg+pFdfBbg8d9RaFyAUr423gTXjhklGFnHUvrBs7fLgJwvDboSjpqRozA2X
	xZtwvUjhHLJflZ3ho4NjQYXEBGkvw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgkt9suh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jul 2024 19:22:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46OIwimg024617;
	Wed, 24 Jul 2024 19:22:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a3awg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jul 2024 19:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EnRROtQopeM9KCl6HmaG9R48F0VV01MfGrzdhfVjt+NgQmrDlmJvk6KXyhLLKWes6dMuoqnWMIOUyK2YnJoP2bo/d8dScuZy6gdH+tkxS4WW4+y478zcIDReugukIJEnpik9/NsRV92I1GLtPhmuhpBl+MSYQX/1KfHhL7T8poJi9mltjVn1N42reC+RXhOkaC4Q2eMHEF5tRa1YNfwojGukSFCndOQuyK8R+e7wQmuKLRwCq0e+OqgbZ2r0ZygS+zz/AvZuz8C/cn/3HQXzvz1fJJiOwS+FMkcP1haD13ByJi4owPRcGPjkPm2YU6/molDheWDH3YlFBd3cnMu7JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uioevvaMw0mDS2TQGSDPYEJ+gp/tYrE8L5SfqnwyAiQ=;
 b=Uo0HYeKzrwTUPeaV9oAqx3DqzY6XJWaZu8vTVVHtOXyNh79jb/xzDzJThVTiIqXtFIEVvRtcfOGgGT1ENfAnhd2xgmJ+07rDUSOLct5JCRQN+9SdoG3vQxfiqX9WUeA6XK99BWOX2vBpLQvOKJQHfusk+uhNcHRQ+Svmt4ufS9BL/PiecJTRrJjMFAlqcuBjOloAzAf5tnQUCWph/jcS5duJlKUgPBulv8WbAqJaXDgPGLlJFryXTlj3nFAaKUOWtqd7aBj06siPX8jpZLhAUMWpGWBzPkUcPjk7UWgy5YE4zbPRW/6HhDK+BmH+zH6SCyUYxTNCl2qXbNZ3An488Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uioevvaMw0mDS2TQGSDPYEJ+gp/tYrE8L5SfqnwyAiQ=;
 b=eK9bL0pMY0WR3gNw1O9jjadcdz+HQYcucl1MjBkhaZlUhoXqtv4TU+H3R1QB5EhhE6e9F2ygcKJ11lxS9hapmkjxZeyud5qCm9RhXW4q75KBA90VdTCoGVJmzkLWfZ/AibB9Bw9wONOa5B2WP3voXC8Uj6iMZYWRUSVJKEmuLy0=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DM6PR10MB4217.namprd10.prod.outlook.com (2603:10b6:5:218::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 19:22:26 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Wed, 24 Jul 2024
 19:22:25 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Thread-Topic: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Thread-Index: AQHa0jOt/CIGTtEk2UiPk1YdzgTPfrH4fHKAgAFbKgCAAIK5AIAL/tiA
Date: Wed, 24 Jul 2024 19:22:25 +0000
Message-ID: <E00E2394-D49E-47FF-B2F6-C094B0414C66@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
 <ZpdEZOWDbg5SKauo@dread.disaster.area>
In-Reply-To: <ZpdEZOWDbg5SKauo@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DM6PR10MB4217:EE_
x-ms-office365-filtering-correlation-id: 9de808f1-6feb-4fd2-930d-08dcac15f362
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eWRYUG5ZNlpoVG5YcEZ5OW1tb1V3Y25RVzl4WGtoNXRGWjZvbnhnSERKMS82?=
 =?utf-8?B?djB5azgyb2Nld1ZENnVwUE4rblgzclZ5YmJ6OG5RZXpha2RUK0Z4RnE1OVFE?=
 =?utf-8?B?aS9DdnFZelU3YnBLbm5tdFhKTXdOQzRaVjF0cEpKZVcxbVFYalZlME54dDhW?=
 =?utf-8?B?L1NobFU1Q1E4a0h3a1lHZFBnSjZvU2xtRU16anhMdzdxYVFZeHhRdndQWWU5?=
 =?utf-8?B?OXMrRC9oS0Fyem9ZdkJYVUVzQXdoMm9tRTMvSE5oL05JbDNOblhTVkdUOTNi?=
 =?utf-8?B?VjBnenc5Ky9LZk5TemduRDRaRHVRL011NEhLeVdZcGx0M3BJQjhWMDdjZkVs?=
 =?utf-8?B?b2h2TG5FM1hhVzF3NXFIR0NmNksvQ1p1cldZOUhvWjlYeUx3YUJYZE9TcEp6?=
 =?utf-8?B?WHdYUlRDQjNvV0Y1eHNpWWRpU1JUZzNWS3AzSUp6c0hpMUErV1FaOUpEeXk4?=
 =?utf-8?B?MldpS2U3NTlKZmJ0MjlHdllpZTU0YUdhNEs0YXJDR0pEaWtHbmlkSnpvWTk4?=
 =?utf-8?B?bk92eEdCQlNiOWFKdFBYNHQ0WFJaREFJT0pkdUIwVGhheGJjNkx0TUdLNVlM?=
 =?utf-8?B?Y216V0Z4WHRseEFRTGNucDhYU2wxeWVvd1l4dVJzVDNDbjk0TGNtWThwMkxk?=
 =?utf-8?B?UXJjeXpQZEgrcVhQOENxazBRTVhJRVgzdmJlZUZDQWJkMnZwdmNpckpLMHN5?=
 =?utf-8?B?VWMxSkoxVy90S3NVbUpPaWVzNldRa0g0eE1sSEs2YTJGdlBEZ1p4dnFET2hk?=
 =?utf-8?B?RXk4UGwvMC9jZTFRdzhzTURaMDJadUVOdnczYjI5N004MTJXT0x0UmlLTk9v?=
 =?utf-8?B?c0pLM05laERmMXVvTWIyTURia0xLNFBNa0NYNmx5RlVrR0tBeXh6MnhvSldu?=
 =?utf-8?B?bVZIS3lEaHJya0J3TVBmTmhraFJNQVN0NWduWEdSNXRlT1ZFd3I0NDVRRWda?=
 =?utf-8?B?d0tUdjd3Rjc0MDlrem5PckNDSG1vZmExZERiNVRJc1Roeml0aldMNlBmWHdB?=
 =?utf-8?B?ay85d3VlbElOMGJlODBzWXdVWklvVzBwWEpqZHoyNG1zSHEyM0Fyd3Nhczdw?=
 =?utf-8?B?MlpKMThLT3ZVTWxWcWRkMFlqTy8zVjBzczY1WVlnSzVRNUQvdHVwa1NyOHFZ?=
 =?utf-8?B?a0J0SFZRZXVJbUQ1TkRSMzBZVFRmdlRHYTQ2elBaZjV3TUVTVmpiSmtQMXo4?=
 =?utf-8?B?cEM2YUEzTldaTXNKNWk2TFFXQ0k5UElZSEJxSkFFcW95Q1lINUxoUXU0SVRl?=
 =?utf-8?B?ejRZTmFpbytrak5SRE5uZ0dHSjBZeEJUTlRncmFBYTM2cjM5UkhDL1JjREpN?=
 =?utf-8?B?dFJSeWtiVmtZNkdXZ0M3QzJEbnR2R0JaNllOS3dIRHdkMnFiYmVHaDZHL3ZT?=
 =?utf-8?B?dDdyaWx1QmJ6bHQwZURVb2ZXQkM0eUJGQTRWYlF1OUwxTjQwcThJU2F2UUp4?=
 =?utf-8?B?Z1l3MTJuRXFVUUlsdEhlMzNnbmVra1NvYnNFTExaZ1FDemdlaXV1M2hpSFFv?=
 =?utf-8?B?VG1rKzVObXJTRU1YbWR1QWlIamJWbzJIU3JXY0pwbEo0NHZBbzFvQVRTM1dF?=
 =?utf-8?B?Z2UzQUtGdE5UNWRHRXRpTUFPQy84ekRiQUx4cGd1bjBKQUZlY3VyN29TOVpk?=
 =?utf-8?B?K0hkUjBNMnJIczdkYlZzTGJqWlR3TEhOM010TTY4VU5WeHVQWVNYMGhWTmFI?=
 =?utf-8?B?dkRvOGxidER6NXVkSDRVSVhySElhK09QLzVFRkFQUDRkNlB5Qk9sT085L3lI?=
 =?utf-8?B?SjRiT2pENjNaRVAvQ3laQmtQMjVNT0RvZWJ5ZGtjcG82aXRyODNvQlhHRXdw?=
 =?utf-8?B?UktlbkI4ckJ6ZVl4VDNqNjlKU2YzRGpIWU1iRUgxK2VIa29oRU1UQkJFM3M0?=
 =?utf-8?B?c2NSUXlWbFNIU1Y1eFliYnJUc2l4UDRzelhxcVVudlBWQ2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RmtwQzlxWFJpaDRmblYrcWEzWXNTMndYR2NhOFVRSzRhTTJHNktCLzlkMmZK?=
 =?utf-8?B?dGlicys2NHlvKzNCNkdsWCtDT3JnektHalVBK2pOb2hhZlVDQzNxMjBZeFFM?=
 =?utf-8?B?RG1KT20rcnVBTmNPNkZHbndCcU96QjUrSmorWk5nY0kycmMrclFBMUl0TWlt?=
 =?utf-8?B?VitKTllSOEZubU1sSCt6RFlBeVpQUDF1K3JSdEJ5TTI2QjFhRW9TcnY1SnZU?=
 =?utf-8?B?dURKY0JVOFF6eUl3Y0lEZ3BDMTBBMGcxUWhvQmhkdHdJQkNRY0Uyd2N5bys4?=
 =?utf-8?B?emJTaUJnYzBtMTdNZUl4MTEyN0p1UkhaZ1UySXpDSVk0cmJnc3RrdVN2WUlF?=
 =?utf-8?B?R2c5RHNIdW9QZ3IzR0tYbWNPWUE1QU5rR3JlZGxnRFlUNzhOYkVFT1lTR2dv?=
 =?utf-8?B?Qk9aUkRiZ0tJaEFkODlBV2R1RnV1QWlKd1ZGWWlCaEVqZFlocEk5dVd1a0pi?=
 =?utf-8?B?QXFIMmFWaG1DSHdxeWdYUkRsZDlUNGJ4OVV5NURUdkNkMzB5c3RYbVplbkJ1?=
 =?utf-8?B?RGVxaHNNSnpwN2tJRTJTWDZ1RkRtOGU0elp6dUFxZUZ2Y1pEeVNoVjBYa3dt?=
 =?utf-8?B?aS95VUNzdnRnV2w0MiszYlo4QWUyaVNUZlR3dGhJNHJsb0xrNU1sam8vM0tt?=
 =?utf-8?B?QUhLUWRSaVRxOVI4dUk0VEM3bDBzRXN0ZVcvTEwzb1YzeE8ycVZ5bjlwbFph?=
 =?utf-8?B?Q3F2M1d6bkZOcENQd1R2UUh0WVNXNmdtTEV0S3M4OERCeUp2eFJ4ZWU4NHNY?=
 =?utf-8?B?MFNyMEoyYTNZZUlpNjAyQ3JFSzNjSUYyY0VpUkMzb0gzOTVnVW9EWGl6TE5P?=
 =?utf-8?B?UTRWa2tRd2N4WTJGYTJYZ2tuMTlOZkR2ZUdQeEdiMjR6MVIvT2E2UGlKZDRq?=
 =?utf-8?B?YmdYRWY0eStJRmRtYXhiSE8zYVpzMXBrbkR0L3FYcjgrSElGKzZZMDlDODJS?=
 =?utf-8?B?anZHemlnaWVmWW53bHJOOWZnc1NRenBOOVRxUytqUyt3UWRBZ3R4VDhNYzZP?=
 =?utf-8?B?Tm1VQkFKbUxWdnZpOXNuckZuNmZ4NzJCWDJyWHF3bDhJaUhLWXNreWQ2TFpW?=
 =?utf-8?B?dXlsb3NTK3lNTjlGTVhRYTZmSFoxSm5kaFh6eTJ2cXYyWHNxSEpXTTVnbERj?=
 =?utf-8?B?a2hiaTNJV2xHay9LcVk3c21GYStOby9yanhvWkcxOWtQY2pDcmpnTmY2TVcv?=
 =?utf-8?B?bTUzMWo1U1VqNmh2em5sdUt0YngreVVSMm9kaUhscWR1Uk9EVmk4RHZla3Zl?=
 =?utf-8?B?Tk5Qbmh6amVNZ0NnZUpwTjFBTmRoMmZvemJIRG9sS2RhWE9ONlhPN05yVm5C?=
 =?utf-8?B?MklyZkxHa2FaOFZBUjdsd3BHWjRJRlczck44akxGOThjY1d3bmd1MjFSY0x6?=
 =?utf-8?B?VEVXN3dmSSs0ZFZXcEZiOXdwVkZJeUpqWjJDWjBydklsSmdBRFV1ZE0xclYx?=
 =?utf-8?B?WU1CVUdMNGhvb3Z0cDBNTnV0eHFvcXZnVUd3NGQvTFdIQktNTDNiaUZzTjdw?=
 =?utf-8?B?RGdkcXBHMkZicWFDTW5BV3BwSEphQ2E1RHdmU01sczNTQ2JFaWxuaFduQUlL?=
 =?utf-8?B?SHRwUklDUHoyU1JFd3Zjd2hwTFBrdCtUZzJCUTFsdkdJMGFFK3hqOWcwdnc5?=
 =?utf-8?B?OXpLaEZYZDRURzZiYmpKL3RtWFg0U3lUKzdJS3NRZmxZNGdCbWlZUXFFdFpH?=
 =?utf-8?B?bC8zYzJNVW5kTlRDMTV2UG54dXBtZlRWd1BOQ0dpZHcwUmR1d1VVQnIwVVJJ?=
 =?utf-8?B?VkdGb1drL2ZKU3hNbUd5N2o1bW1QVUtSUTJjWTNDWVA2WUtzcVlNbCtEWWFY?=
 =?utf-8?B?VGFCVy9Dc0tVbndZZDJPOXRIeUxSQ2NBSUtNbUlhZEZvbkdSMkRRTjVwOTlr?=
 =?utf-8?B?b0RiL3FuSjlUUlBocnRxT2JzSU9IWUx0STAzMDZ2VTAxeXZBWEh5UjFVMHpL?=
 =?utf-8?B?ajJiTjV6SUtMcGhEamZIYXlyd3pjd0Y5Q2Z3MCt1cURpaTRvRE0wYUtjVUlS?=
 =?utf-8?B?RWdmNWlFTkdNbUIzZHB6ZU52WTJ5WnFGQzVicU43dzAwYlBnTWdqdmRrN1Vq?=
 =?utf-8?B?UGlkSSt6Smd3OTYvYlczazlUYzU2L1JSZnM0TDdXL2hERHlKRmdxVHAwa0I4?=
 =?utf-8?B?UTRNZnEwNXd5VHMvcS93SG9jVlZkNVB1R3lUWllCTWM2M2ZjR2lFUFo5OFRk?=
 =?utf-8?Q?qphflXQJyws93wvXuxB5kpY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33EEEB40816C484A9791CFFEB972644A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6AiB7Vz04jyBOBHuhydLuQiWzmOEPuwVN9oI5k/FefzcwU2xKmWKQdD7NOgWsZdLWVcXMUDvBlQd/7rc7JEdjHAcxHU26rDgDAobLrHJqjlDEePdRxQaTuaGBo1W2eJhRrQi+4J+KkvVzE134xy4vEa/AEpmM5DkDkBfX4V1ingyDXeekE57Nvzw28YDdEMJ40KkvXzRkb/grkE+ioMaAnu0NwgNtgXiBucSiR7sP9dqczb/HMj9bJUS2aS2LBxfrrCu/achPaBWMkOr2pTFsRLODDwS8me+SVH1z0d4hgcpTrhh1OZa/WqQ+YbMZEXTsqudReWYcWFZNr4CagVce4Q6d9HnEhV/i1YSvg9Hdr0XaA9OfCSm9cOJzGJP+KzgBM7rLmClGlPR6ERxHOZSvRiQX6kfv3EC96Kjyp4A+kxcHQHNZySSoz5AaLeNx97GdZz4mee2DlN13Cyl5ks28SHF4uS90gIaGPGc5qSsIiGpoIzngZ1VVTVFFfyoRQnL/xZoTq0aKr1gK/qQRVd7oboGT5l/q9+DTKLA9X/3J86Kw8pHcYkyJM+WiJwsuZkITdYH1MtPRMSCUH5DI1beJL4f+2kJglSdtqeZRyZG8g0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de808f1-6feb-4fd2-930d-08dcac15f362
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2024 19:22:25.6927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ij9m8m8GLs7c9fWVjsgkRAN1DJTjdFc7Zm5HZGEW5S/bnyHhgkH9tc1zyFEJAW2eHBDMeimICqguAl/1zGuy+4QJVqheIoEEA4F/vjqCguM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-24_21,2024-07-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407240138
X-Proofpoint-GUID: OakKtFL06PMAp8dk0wPIaiCDyw3ThDeb
X-Proofpoint-ORIG-GUID: OakKtFL06PMAp8dk0wPIaiCDyw3ThDeb

DQoNCj4gT24gSnVsIDE2LCAyMDI0LCBhdCA5OjEx4oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAxNiwgMjAyNCBhdCAwODoy
MzozNVBNICswMDAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+Pj4gT2ssIHNvIHRoaXMgaXMgYSBs
aW5lYXIgaXRlcmF0aW9uIG9mIGFsbCBleHRlbnRzIGluIHRoZSBmaWxlIHRoYXQNCj4+PiBmaWx0
ZXJzIGV4dGVudHMgZm9yIHRoZSBzcGVjaWZpYyAic2VnbWVudCIgdGhhdCBpcyBnb2luZyB0byBi
ZQ0KPj4+IHByb2Nlc3NlZC4gSSBzdGlsbCBoYXZlIG5vIGlkZWEgd2h5IGZpeGVkIGxlbmd0aCBz
ZWdtZW50cyBhcmUNCj4+PiBpbXBvcnRhbnQsIGJ1dCAibGluZWFyIGV4dGVudCBzY2FuIGZvciBm
aWx0ZXJpbmciIHNlZW1zIHNvbWV3aGF0DQo+Pj4gZXhwZW5zaXZlLg0KPj4gDQo+PiBIbeKApiBm
aXhlZCBsZW5ndGggc2VnbWVudHMg4oCUIGFjdHVhbGx5IG5vdCBmaXhlZCBsZW5ndGggc2VnbWVu
dHMsIGJ1dCBzZWdtZW50DQo+PiBzaXplIGNhbuKAmXQgZXhjZWVkIHRoZSBsaW1pdGF0aW9uLiAg
U28gc2VnbWVudC5kc19sZW5ndGggPD0gIExJTUlULg0KPiANCj4gV2hpY2ggaXMgZWZmZWN0aXZl
bHkgZml4ZWQgbGVuZ3RoIHNlZ21lbnRzLi4uLg0KPiANCj4+IExhcmdlciBzZWdtZW50IHRha2Ug
bG9uZ2VyIHRpbWUgKHdpdGggZmlsZWQgbG9ja2VkKSB0byBkZWZyYWcuIFRoZQ0KPj4gc2VnbWVu
dCBzaXplIGxpbWl0IGlzIGEgd2F5IHRvIGJhbGFuY2UgdGhlIGRlZnJhZyBhbmQgdGhlIHBhcmFs
bGVsDQo+PiBJTyBsYXRlbmN5Lg0KPiANCj4gWWVzLCBJIGtub3cgd2h5IHlvdSd2ZSBkb25lIGl0
LiBUaGVzZSB3ZXJlIHRoZSBzYW1lIGFyZ3VtZW50cyBtYWRlIGENCj4gd2hpbGUgYmFjayBmb3Ig
YSBuZXcgd2F5IG9mIGNsb25pbmcgZmlsZXMgb24gWEZTLiBXZSBzb2x2ZWQgdGhvc2UNCj4gcHJv
YmxlbXMganVzdCB3aXRoIGEgc21hbGwgY2hhbmdlIHRvIHRoZSBsb2NraW5nLCBhbmQgZGlkbid0
IG5lZWQNCj4gbmV3IGlvY3RscyBvciBsb3RzIG9mIG5ldyBjb2RlIGp1c3QgdG8gc29sdmUgdGhl
ICJjbG9uZSBibG9ja3MNCj4gY29uY3VycmVudCBJTyIgcHJvYmxlbS4NCj4gDQo+IEknbSBsb29r
aW5nIGF0IHRoaXMgZnJvbSBleGFjdGx5IHRoZSBzYW1lIFBPVi4gVGhlIGNvZGUgcHJlc2VudGVk
IGlzDQo+IGRvaW5nIGxvdHMgb2YgY29tcGxleCwgdW51c2FibGUgc3R1ZmYgdG8gd29yayBhcm91
bmQgdGhlIGZhY3QgdGhhdA0KPiBVTlNIQVJFIGJsb2NrcyBjb25jdXJyZW50IElPLiBJIGRvbid0
IHNlZSBhbnkgZGlmZmVyZW5jZSBiZXR3ZWVuDQo+IENMT05FIGFuZCBVTlNIQVJFIGZyb20gdGhl
IElPIHBlcnNwZWN0aXZlIC0gaWYgYW55dGhpbmcgVU5TSEFSRSBjYW4NCj4gaGF2ZSBsb29zZXIg
cnVsZXMgdGhhbiBDTE9ORSwgYmVjYXVzZSBhIGNvbmN1cnJlbnQgd3JpdGUgd2lsbCBlaXRoZXIN
Cj4gZG8gdGhlIENPVyBvZiBhIHNoYXJlZCBibG9jayBpdHNlbGYsIG9yIGhpdCB0aGUgZXhjbHVz
aXZlIGJsb2NrIHRoYXQNCj4gaGFzIGFscmVhZHkgYmVlbiB1bnNoYXJlZC4NCj4gDQo+IFNvIGlm
IHdlIGZpeCB0aGVzZSBsb2NraW5nIGlzc3VlcyBpbiB0aGUga2VybmVsLCB0aGVuIHRoZSB3aG9s
ZSBuZWVkDQo+IGZvciB3b3JraW5nIGFyb3VuZCB0aGUgSU8gY29uY3VycmVuY3kgcHJvYmxlbXMg
d2l0aCBVTlNIQVJFIGdvZXMNCj4gYXdheSBhbmQgdGhlIHVzZXJzcGFjZSBjb2RlIGJlY29tZXMg
bXVjaCwgbXVjaCBzaW1wbGVyLg0KPiANCj4+PiBJbmRlZWQsIGlmIHlvdSB1c2VkIEZJRU1BUCwg
eW91IGNhbiBwYXNzIGEgbWluaW11bQ0KPj4+IHNlZ21lbnQgbGVuZ3RoIHRvIGZpbHRlciBvdXQg
YWxsIHRoZSBzbWFsbCBleHRlbnRzLiBJdGVyYXRpbmcgdGhhdA0KPj4+IGV4dGVudCBsaXN0IG1l
YW5zIGFsbCB0aGUgcmFuZ2VzIHlvdSBuZWVkIHRvIGRlZnJhZyBhcmUgaW4gdGhlIGhvbGVzDQo+
Pj4gb2YgdGhlIHJldHVybmVkIG1hcHBpbmcgaW5mb3JtYXRpb24uIFRoaXMgd291bGQgYmUgbXVj
aCBmYXN0ZXINCj4+PiB0aGFuIGFuIGVudGlyZSBsaW5lYXIgbWFwcGluZyB0byBmaW5kIGFsbCB0
aGUgcmVnaW9ucyB3aXRoIHNtYWxsDQo+Pj4gZXh0ZW50cyB0aGF0IG5lZWQgZGVmcmFnLiBUaGUg
c2Vjb25kIHN0ZXAgY291bGQgdGhlbiBiZSBkb2luZyBhDQo+Pj4gZmluZSBncmFpbmVkIG1hcHBp
bmcgb2YgZWFjaCByZWdpb24gdGhhdCB3ZSBub3cga25vdyBlaXRoZXIgY29udGFpbnMNCj4+PiBm
cmFnbWVudGVkIGRhdGEgb3IgaG9sZXMuLi4uDQoNCg0KV2hlcmUgY2FuIHdlIHBhc3MgYSBtaW5p
bXVtIHNlZ21lbnQgbGVuZ3RoIHRvIGZpbHRlciBvdXQgdGhpbmdzPw0KSSBkb27igJl0IHNlZSB0
aGF0IGluIHRoZSBmaWVtYXAgc3RydWN0dXJlOg0KDQpBIGZpZW1hcCByZXF1ZXN0IGlzIGVuY29k
ZWQgd2l0aGluIHN0cnVjdCBmaWVtYXA6DQoNCnN0cnVjdCBmaWVtYXAgew0KX191NjQgZm1fc3Rh
cnQ7IC8qIGxvZ2ljYWwgb2Zmc2V0IChpbmNsdXNpdmUpIGF0DQoqIHdoaWNoIHRvIHN0YXJ0IG1h
cHBpbmcgKGluKSAqLw0KX191NjQgZm1fbGVuZ3RoOyAvKiBsb2dpY2FsIGxlbmd0aCBvZiBtYXBw
aW5nIHdoaWNoDQoqIHVzZXJzcGFjZSBjYXJlcyBhYm91dCAoaW4pICovDQpfX3UzMiBmbV9mbGFn
czsgLyogRklFTUFQX0ZMQUdfKiBmbGFncyBmb3IgcmVxdWVzdCAoaW4vb3V0KSAqLw0KX191MzIg
Zm1fbWFwcGVkX2V4dGVudHM7IC8qIG51bWJlciBvZiBleHRlbnRzIHRoYXQgd2VyZQ0KKiBtYXBw
ZWQgKG91dCkgKi8NCl9fdTMyIGZtX2V4dGVudF9jb3VudDsgLyogc2l6ZSBvZiBmbV9leHRlbnRz
IGFycmF5IChpbikgKi8NCl9fdTMyIGZtX3Jlc2VydmVkOw0Kc3RydWN0IGZpZW1hcF9leHRlbnQg
Zm1fZXh0ZW50c1swXTsgLyogYXJyYXkgb2YgbWFwcGVkIGV4dGVudHMgKG91dCkgKi8NCn07DQoN
ClRoYW5rcywNCldlbmdhbmcNCg0KPj4gDQo+PiBIbeKApiBqdXN0IGEgcXVlc3Rpb24gaGVyZToN
Cj4+IEFzIHlvdXIgd2F5LCBzYXkgeW91IHNldCB0aGUgZmlsdGVyIGxlbmd0aCB0byAyMDQ4LCBh
bGwgZXh0ZW50cyB3aXRoIDIwNDggb3IgbGVzcyBibG9ja3MgYXJlIHRvIGRlZnJhZ21lbnRlZC4N
Cj4+IFdoYXQgaWYgdGhlIGV4dGVudCBsYXlvdXQgaXMgbGlrZSB0aGlzOg0KPj4gDQo+PiAxLiAg
ICAxDQo+PiAyLiAgICAyMDQ5DQo+PiAzLiAgICAyDQo+PiA0LiAgICAyMDUwDQo+PiA1LiAgICAx
DQo+PiA2LiAgICAyMDUxDQo+PiANCj4+IEluIGFib3ZlIGNhc2UsIGRvIHlvdSBkbyBkZWZyYWcg
b3Igbm90Pw0KPiANCj4gVGhlIGZpbHRlcmluZyBwcmVzZW50aW5nIGluIHRoZSBwYXRjaCBhYm92
ZSB3aWxsIG5vdCBkZWZyYWcgYW55IG9mDQo+IHRoaXMgd2l0aCBhIDIwNDggYmxvY2sgc2VnbWVu
dCBzaWRlLCBiZWNhdXNlIHRoZSBzZWNvbmQgZXh0ZW50IGluDQo+IGVhY2ggc2VnbWVudCBleHRl
bmQgYmV5b25kIHRoZSBjb25maWd1cmVkIG1heCBzZWdtZW50IGxlbmd0aC4gSU9XcywNCj4gaXQg
ZW5kcyB1cCB3aXRoIGEgc2luZ2xlIGV4dGVudCBwZXIgIjIwNDggYmxvY2sgc2VnbWVudCIsIGFu
ZCB0aGF0DQo+IHdvbid0IGdldCBkZWZyYWdnZWQgd2l0aCB0aGUgY3VycmVudCBhbGdvcml0aG0u
DQo+IA0KPiBBcyBpdCBpcywgdGhpcyByZWFsbHkgaXNuJ3QgYSBjb21tb24gZnJhZ21lbnRhdGlv
biBwYXR0ZXJuIGZvciBhDQo+IGZpbGUgdGhhdCBkb2VzIG5vdCBjb250YWluIHNoYXJlZCBleHRl
bnRzLCBzbyBJIHdvdWxkbid0IGV4cGVjdCB0bw0KPiBldmVyIG5lZWQgdG8gZGVjaWRlIGlmIHRo
aXMgbmVlZHMgdG8gYmUgZGVmcmFnZ2VkIG9yIG5vdC4NCj4gDQo+IEhvd2V2ZXIsIGl0IGlzIGV4
YWN0bHkgdGhlIGxheW91dCBJIHdvdWxkIGV4cGVjdCB0byBzZWUgZm9yIGNsb25lZA0KPiBhbmQg
bW9kaWZpZWQgZmlsZXN5c3RlbSBpbWFnZSBmaWxlcy4gIFRoYXQgaXMsIHRoZSBjb21tb24gbGF5
b3V0IGZvcg0KPiBzdWNoIGEgImNsb25lZCBmcm9tIGdvbGRlbiBpbWFnZSIgVm0gaW1hZ2VzIGlz
IHRoaXM6DQo+IA0KPiAxLiAgICAxIHdyaXR0ZW4NCj4gMi4gICAgMjA0OSBzaGFyZWQNCj4gMy4g
ICAgMiB3cml0dGVuDQo+IDQuICAgIDIwNTAgc2hhcmVkDQo+IDUuICAgIDEgd3JpdHRlbg0KPiA2
LiAgICAyMDUxIHNoYXJlZA0KPiANCj4gaS5lLiB0aGVyZSBhcmUgbGFyZ2UgY2h1bmtzIG9mIGNv
bnRpZ3VvdXMgc2hhcmVkIGV4dGVudHMgYmV0d2VlbiB0aGUNCj4gc21hbGwgaW5kaXZpZHVhbCBD
T1cgYmxvY2sgbW9kaWZpY2F0aW9ucyB0aGF0IGhhdmUgYmVlbiBtYWRlIHRvDQo+IGN1c3RvbWlz
ZSB0aGUgaW1hZ2UgZm9yIHRoZSBkZXBsb3llZCBWTS4NCj4gDQo+IEVpdGhlciB3YXksIGlmIHRo
ZSBzZWdtZW50L2ZpbHRlciBsZW5ndGggaXMgMjA0OCBibG9ja3MsIHRoZW4gdGhpcw0KPiBpc24n
dCBhIHBhdHRlcm4gdGhhdCBzaG91bGQgYmUgZGVmcmFnbWVudGVkLiBJZiB0aGUgc2VnbWVudC9m
aWx0ZXINCj4gbGVuZ3RoIGlzIDQwOTYgb3IgbGFyZ2VyLCB0aGVuIHllcywgdGhpcyBwYXR0ZXJu
IHNob3VsZCBkZWZpbml0ZWx5DQo+IGJlIGRlZnJhZ21lbnRlZC4NCj4gDQo+PiBBcyBJIHVuZGVy
c3RhbmQgdGhlIHNpdHVhdGlvbiwgcGVyZm9ybWFuY2Ugb2YgZGVmcmFnIGl04oCZcyBzZWxmIGlz
DQo+PiBub3QgYSBjcml0aWNhbCBjb25jZXJuIGhlcmUuDQo+IA0KPiBTdXJlLCBidXQgaW1wbGVt
ZW50aW5nIGEgbG93IHBlcmZvcm1pbmcsIGhpZ2ggQ1BVIGNvbnN1bXB0aW9uLA0KPiBlbnRpcmVs
eSBzaW5nbGUgdGhyZWFkZWQgZGVmcmFnbWVudGF0aW9uIG1vZGVsIHRoYXQgcmVxdWlyZXMNCj4g
c3BlY2lmaWMgdHVuaW5nIGluIGV2ZXJ5IGRpZmZlcmVudCBlbnZpcm9ubWVudCBpdCBpcyBydW4g
aW4gZG9lc24ndA0KPiBzZWVtIGxpa2UgdGhlIGJlc3QgaWRlYSB0byBtZS4NCj4gDQo+IEknbSB0
cnlpbmcgdG8gd29yayBvdXQgaWYgdGhlcmUgaXMgYSBmYXN0ZXIsIHNpbXBsZXIgd2F5IG9mDQo+
IGFjaGlldmluZyB0aGUgc2FtZSBnb2FsLi4uLg0KPiANCj4gQ2hlZXJzLA0KPiANCj4gRGF2ZS4N
Cj4gLS0gDQo+IERhdmUgQ2hpbm5lcg0KPiBkYXZpZEBmcm9tb3JiaXQuY29tDQoNCg==
