Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7FA233140;
	Thu, 12 Jun 2025 23:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749770688; cv=fail; b=U9MJqAW4kHmSSv4F3fJ8K+wZ/uPGY4NJQ8J4IuS7Fi5I+KmWFheG4ESaaIBB06c6Yqlu1E85Cc689mQhrDzYwr0B2rjcpqyYxC3rvFewu1foMBBbkhSDBQRdeVFaqd9BKUxFnSdcy8Zu+EeNVX4/ywhss08xGdLsAZkMG2vDgnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749770688; c=relaxed/simple;
	bh=A0v7kPsYbkkkUndKCgpBDocfJsdagqVV34PbiQsk1WA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CyW5ApqAgBbS5FXVNmD8vnF/SDUQyiorbULqlMZPefrWalkaffM+biOIXYiICsYEgL7Mfi1Ktg0SS7nXFeobV31FFRHFnfrC1+26tkdGb+5fOTpg1lVxeDesQVqMg8HzcZbILxHcFdCmmYExDHt1ezl0HVyDPFYhNH2/XaLrHZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WJemYvuH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CT02SXAx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJemYvuH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CT02SXAx"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CMBmQ9029832;
	Thu, 12 Jun 2025 23:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=A0v7kPsYbkkkUndKCgpBDocfJsdagqVV34PbiQsk1WA=; b=
	WJemYvuHjr3AT804WsEUlVsKKjM9hB9dpf3BtpWbQGQF4vkFSMzbNYzaXAR0qt7r
	50Y6qCHz36d4fLa94fopQ6MGseBywZzo99IRLkqt3IgsCjfif2xEVa3hLNBAYIiG
	GAUUbbtZSaSgQdP3odqiZAtQ6geP341xgalqhbAuXR/sWOZqNkDyIG2Kz6DuE4FQ
	sLvapmRqr0c8xJujPSwWYeGYiK9kkLWk+96BHyQUz/PJt76rogwoJvudLlxmCLub
	8TMHfLYHl8vaHN6eHUktCt9rxUYs6oza0Dej5FIFEEoN0yomlkLhPDQojn+5NyXc
	cv+o8aWUSSb6RCMNQVxucA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xk252u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 23:24:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CNAA6R040714;
	Thu, 12 Jun 2025 23:24:38 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011041.outbound.protection.outlook.com [40.93.199.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvd7erw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 23:24:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NmU0SsicUnvqY/dw/sZemFa20eaZO+i8yz9Me/Byjz/ILaOA3lkaRJebS3QdMOhuCSAz72pmfykJxSU2D35z1p5yEvQSCnweMHKzv0UGSDh5a481+jMowd8vbCpfiKT3I4DykKxtWx8eSm40PER1e7e3QatNEo7SQ9E4m64VxRWSuUX+5qHEZewn41MQemIuNWJV2mYraCKf9JZAOldO8B+SwuxcDfgSJKbPHPZry0iw/BvIEtekuXZo5ziWHAlytFE53Lq2d3atXz1jnCs7IuTFihIPT+Z6I7GqMhx82xKQgFlJagNcvo/Id5VenHzqkyXCXUu8LTPa5tCyqErZng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0v7kPsYbkkkUndKCgpBDocfJsdagqVV34PbiQsk1WA=;
 b=CHf+8iZ1qREzMW7f/o0XnwH2n8uWtzzj1ssgV7XoN9jc2bwTsv8vKf3ekVuqrzVjNwNmDqtoxR7uz0kkMTLlUftbuNk6TU5I8N4ifM6OTIaonTHdu/RjqzsrMexYpUXSBeTNVrWcn8URWoIO7Zj1LBKNBvUWZqx9uRHBJhim0tFsgeN0ghb01hguEj+I2sUv5B1ts7NeM9pTNRanozhVAaxH6QqhIxjPnUeT85DY1c1Ux7B43En9E7Mv2ykJDCksCQIYKNbDqZA8Ws4mHFQb/QKQHdgd3QdudqmJtvksyBot4SRuK4MroVwtqLsOtA0kiek4VDovDphovjBsEUTwIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0v7kPsYbkkkUndKCgpBDocfJsdagqVV34PbiQsk1WA=;
 b=CT02SXAx4AEvzgkfZ/IUZIpiLs38cssYA2Ayb+fb7Hz6g8UOoThG7lwerIrqktHb5yNTS96qBlLpC8KJYrohdXA6+lWuwiQc63WEntIkAbG8ED+Q9JOTKO3zhNWvpcTWebtPAl3rNQWM1Mj8q3G7W9oysmDwdeG9zK/T84rKeyI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH3PR10MB6714.namprd10.prod.outlook.com (2603:10b6:610:142::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 23:24:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%7]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 23:24:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "djwong@kernel.org"
	<djwong@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        "ritesh.list@gmail.com" <ritesh.list@gmail.com>
Subject: Re: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Thread-Topic: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Thread-Index: AQHb2z1Qs2qbqpL2A0ucVAMjCf1edrP/GnyAgAERTQA=
Date: Thu, 12 Jun 2025 23:24:34 +0000
Message-ID: <7E2C7236-767E-4828-A06F-F279D2270F3D@oracle.com>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-3-catherine.hoang@oracle.com>
 <aEp8ZYT48ySTLWqy@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
In-Reply-To:
 <aEp8ZYT48ySTLWqy@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.500.181.1.5)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|CH3PR10MB6714:EE_
x-ms-office365-filtering-correlation-id: dce2c733-7dc3-4198-a86c-08ddaa084acf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y3dmS3NZcmRockNrNUpoZjBVU0F1cVdBQWJlbDR4aEx0V01nNmFmQjJqa21o?=
 =?utf-8?B?VVNvV2ZJa3FWNDdJTnl1ZDVjKzRYdExsSUpHY1Z1UVQyY0czOENiYVk3RzNT?=
 =?utf-8?B?dDBWQi81RENCclE5N2RiQ2g1dURXUnRXcm9XZVM0cU5WNUJRWkxUbjdrVDB2?=
 =?utf-8?B?cUJEN0NQVjNacy96MVlUNk5yamx3UldMU21CMjNheWZHOHYzRG1QY3pLZjRD?=
 =?utf-8?B?SEdqVmN0UGFKTDJNbmRjVFZmaE1Wd01lOWx4QitKR0pmbDdtcmtvbHlLYXBQ?=
 =?utf-8?B?NG9kMUdkb2hBQnJVNDRWOGdWanhyNjMvQXRSL3NxcGhvb2tHQzNLQXRyOHpI?=
 =?utf-8?B?YitCWXIzbE82RjNKeTNxcHp5UFByRzNwM3ZYRzQ2ZkhnbHk1N2l5RmhtYVRN?=
 =?utf-8?B?eVVNSWlodUJHN1VBUVZXWFBzMCs1N1dGTjFrRk5vVUoyMFlNTzFPemtZQ0w4?=
 =?utf-8?B?bE5sMWRhSmpXYTFRaURSQldvbU9hVnd3RVdOK2FFL0JzcTlvUVROdk1uYkxE?=
 =?utf-8?B?dVpWbG9TQ3MrOVpBaDBPQUxMTnNuelRNelJYUFdFSTdjdjAwWE1yWU5vLzNz?=
 =?utf-8?B?V0wrNGZnYTRqMkc0U2J2aUxQZE5jWDdYdUxmQjRBUlBPQis1Ykc5cGZFajhm?=
 =?utf-8?B?UXZvQjlwemxSWUlzU1g3NDJmL25DekdxeEFWYkRrcUF4MjBtWlFFaTIzQlZt?=
 =?utf-8?B?aVJEYlFSZjdVTFV4eWVoWGU3OHJiYVFGdFRNSXJVSG8vYkNhZGNtY3FiOFg3?=
 =?utf-8?B?WVc2aDlESDZTNHMzdjlUeFpJMnFCc1c1RlVkU2owMlBYdkRiR3lvaUN5aW91?=
 =?utf-8?B?RitRTTNYTjl3U211UWVvUDBBMVBONnFCOXlrSXdHQVFGV0FwaHl4NUNzT1pR?=
 =?utf-8?B?dXBtUitocXJTU1F2MnhzQUg5cFJkNXVyY3VTSHVOcExISHc0bUdmNmd2Yys1?=
 =?utf-8?B?UTFBWW1SWlJyVzBkZSt3WVlFRTJRUVFERmYxV3VaT1JtTzJJMi9vMzVlK2d1?=
 =?utf-8?B?SDBVQmlUeStYc3BGSHJpZno2RTl4M28vb2NZdVJBVmlqK1BQNmtUaWRDdXVm?=
 =?utf-8?B?Y1g5QUEweVZzMTIxM2RYL0FTR1MvVzNzc1VtbXNEWXVMQlNRa21QQmFibTBG?=
 =?utf-8?B?Ly84K3BqM1NSVnhMVG9pR3FtZXp4NC95SFM5c2UvTkdEZC9RVUxxakZzL25z?=
 =?utf-8?B?VzZXai81aXZDbXFqZ0JMd1JkemtLRFBRSUVNa2NNM1ZKclZrWGpvTTFxbXJ1?=
 =?utf-8?B?ZEFBRjRVUmU5ZWZaR2FBZG9USmtQRGtodHp1VW9ka0tZYk5zNUV2RjJRdy93?=
 =?utf-8?B?WHRFUXMzL3ZvYVI1Y0RGNUwrcG96bVgwa0p4MUlTYXR5WVlJZkcrbHVaYkVj?=
 =?utf-8?B?M1RLekQ5VFdkcERidlJEcmR0SzFGVE9IR1E1ODNDTUIvK0lldDA5OVFMYkR5?=
 =?utf-8?B?RVRNU250UDJUVk1OUWRDUVd3NmhIWW5iMFZhWi9mVDdtZFNEM3pucDlQc1Va?=
 =?utf-8?B?b25oUkdsN3BBSjJBMk5PTjNhY0U3NUFKR3h3UjYxSnNJbjVlSFR6RlQyMnVy?=
 =?utf-8?B?aGpZNGNvNWlCUHozb1FVVkxLZkR0a2JlQWExckl6OVI0WTZGcFRTQVZjL09X?=
 =?utf-8?B?ZzJLT1RHZzFiU0R6aWRGSGxPbFh0S0kxbEw1aU0waU52Wk5WQVRnVnhTaU5F?=
 =?utf-8?B?clBZc1hvRjhGSUhib2M1QlNVV2duY2hDNWlaY0lDZU9XK21saTJ4ZWZ3dVpj?=
 =?utf-8?B?aWtFNjRDSlZnTU50ZGdCbFBoQXN2M01IYVNOdGNlZmNGeXhBYWg0QjQvaURp?=
 =?utf-8?B?WjJISGg3MEdJaDU5c0orUXR1OWR6eURjZlplVi9WRFpJcFdPSHZGY2Rpa2do?=
 =?utf-8?B?a1hHQVhtR0F2bnpmNFNJU1hEaitFaVJGdlNmN3JKYU4yQ1JTN0pCTkI3TGp6?=
 =?utf-8?B?bk9hMElETnV1MVZFSVNzRnhySHpxTENocEJNamdRS2Yyd0tlc1ltbVJhQkFO?=
 =?utf-8?B?U0x4SzFpV2d3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TG9MSi8zYnBPTk9ydy9Ham11YkEva25McUlFNmExV1g5SHlGa0NaaUdPK1ZS?=
 =?utf-8?B?U1N2bVgzVHZoUkc5Nk4vSEtyY2Q2ZVFMc1BqNjBxS29Ib1p1Vk9TWXlmNXk1?=
 =?utf-8?B?NjdLV3RXTDZGSktnL1kzYTBjbWs2SEcxUElBVmNXaUcvN29RVmxlbzlpbEEw?=
 =?utf-8?B?L2hlaGRaL2dMWXlXenpEODJEVnlCNStTMFo5VHUrUHVzV2xyWHZZbkxxYUxt?=
 =?utf-8?B?eXF1ZWFiK2NVRi9SQnlBelRYVnFQellYQmpoNU5wK0YwdkVPeFRBVkJ2cFZN?=
 =?utf-8?B?bVhCWkRzc2NzYXJWVDRJNERFSDJBRGx2VHl0NGxiYkoyVmZRelVaclBHZHNN?=
 =?utf-8?B?RHQvTnhBdS8vSkRlc3Vqd3RtMGROZWtYWTZ4TFp3N05wRVBaNnBJQXVzaFRW?=
 =?utf-8?B?d2VhK1ZUL0IxV0RsYTBBQndxd3U1bjlLWnk5MDExZ1V3N2Q2SHVmelhvTWFV?=
 =?utf-8?B?Zm03emJ5ZjNMSWwxdnp3M09sNWZjMWN6OVNzOHA1d3hVS0xjM0h6S2dDdFc1?=
 =?utf-8?B?dFZnMjZVblVYMHg5dUEwMHdjZzRlbHhEODV1MDZldkNJSDgxYTFURXA3MURx?=
 =?utf-8?B?TnpUU3BwZFgxc0VsSFp1bTZjUWsvZ2NTQkFjNUFhNzlKNTF3SWZjRGkvMzFV?=
 =?utf-8?B?aXZ0Z3Y4d0QrSXlqWW0rNnBQalY0blp6bk8rM3g0SDdYWkVCQXo4aGsvd3c2?=
 =?utf-8?B?VUhCekNnUGwyY0RRemYvL2F2Rm5IbzRWTStTSHN0WVczQlZSOXFGUWJoMHpX?=
 =?utf-8?B?bnp4VEFRTmNoTnduN0hGWElUTnZBa09CbDlydjRVTVR6VEFvdFp4cldKd0l0?=
 =?utf-8?B?eCtrMWRqcnk1TWxqQlM5bGYxdmdPS1BSaEtBbUhoWngrazI2aTJhcW9OYnVG?=
 =?utf-8?B?UmQ0Y2tMd2JMVWM4d09CNHJSdVBwYW50ZjhKMlZoZGFQcTR1NU43RFMvK1BH?=
 =?utf-8?B?MkdMUnBhZUZHWHF2dmptTVJjRnBLQTZKY084R2U5UHBuenJDTWc5andSTkt2?=
 =?utf-8?B?cW1LRWc0Sk1LRWFHd3VsUDczNk9YVXk2NmRzSzNGVHdXQ1U3NU5YUDFBbmhW?=
 =?utf-8?B?ekEzU0VMbGZkNmtSRDFveTZCTEtVdFhDVUdoMloyZjFzYUZDNjAwK0FodjBq?=
 =?utf-8?B?WE1sank3azJGU3VZTlVabExVYnZScXpxZGdKOFc4dmtvTEV2eWhRM0FXN3JO?=
 =?utf-8?B?enh4di93WUtSKzRpTE12dDYzM0syY093OVBBS1M2NFZpS2g1di9vdlhJR0JS?=
 =?utf-8?B?NzlhbmJuQXVpWm1TNSt4K1FJYW1EVVBIQU5nVzNEd1lSSW9uSm8rN000UXph?=
 =?utf-8?B?eVlpVURPSVRYMGJqa3l0cW9UeVh2YlVhaUZGTkZqcmxqSVZCSkQrUzk0STMz?=
 =?utf-8?B?S1luVEVFTFc2bjV5SjNmMVB3cWZFSW5GbjZyNWo3cmswSi9LWkdzQnlWOGx4?=
 =?utf-8?B?WThEZXlnT0orQTJNS2xNQWMrekhPUnpvSHN6TTZOazRpbm9BNXRoUU9QZ2FR?=
 =?utf-8?B?NEhRdGwzdGxuZmV5TDVhUzdwdEdpN1hvak1kcUhIZStxNVViWXI0M25zMkV3?=
 =?utf-8?B?c2xUbGdNNTh4eDYwZktIcFFHYUgvQ052T25TVnhIbU5QVHkrRGZ0ZUxoYVZK?=
 =?utf-8?B?RkYzazNqNG5aQlZqUGRmTXRacnE5cEJaWlR5TVk3TjgzaXg0SEtmazNsWjVi?=
 =?utf-8?B?ZmRCSFRxNVptSWdSdy9oUUI0ZGZybFBoN3Q0N3lTbXZBZlpuODRkUWpQdnNl?=
 =?utf-8?B?S1VYeHdRRi9MQXVxVnFISS9YcVg5TVRtUXRDMUN0aS9QWDA3V2UxWk1mWFVs?=
 =?utf-8?B?V1p4K1ErN2dGbnN3Wm01RlQzS2h3R3hMZmRmL0NHL3BoZjdwRXFldnVwYXha?=
 =?utf-8?B?TVJNWDlVakY2eG1nQjU3WS9GajN3NGhCdy9KSVlVVW5uby8wc0dEYVRXc0Zy?=
 =?utf-8?B?SHp1R2RjRFFMNlFSQm1zMWxnWFU3bmpOV0hBWVlncDlQLzN3T3lGOEZyakN3?=
 =?utf-8?B?cHVtN0FhU3ZLeFkwOFVKS0lYTXV4RjZCbVZFd2NRcEkxbm10ZmhUbVcyaWwv?=
 =?utf-8?B?WWdMQzJxS0dOZkJTblRIeWJjVzdPUVo2bjk2dDh2U2tSLzFEQTl5Ym14dldt?=
 =?utf-8?B?WFprSkdYbERyOTNJQjVIaWVVWjhQcU9SY2hPOUkwZS9zNkNVMnMzUGFTOTVk?=
 =?utf-8?B?b2c5NDJCYmR6SEkzeGpwWjV6MUZTYUpBaUxNdnhTczZRNVIzU2lRdXE4dUNj?=
 =?utf-8?B?MVJWcldwdXA0QVE5R0lSU0F3V2NRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB9A577E5348614F911B822ED70F389B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l4hZ8E8oJVYn1K9BL9SWE/9QVk8HLoBU3kA3LYPim1Se5cBesOBGSrD48LLgIYtyAQzuKqZqiPh023Wej1kV090QbOJ/SdGQ8TBe4RFfK1zH61s/bRsoyoPVN+VF5kywDB3VSq0Mfmble1DEo6mzBTYJ9UJ9XCWIhLe5u8jW+k2HxqECe5hC3A0Ap7iDv5AeHovF+wpH3D281m2OaRnzVWuiGp/7OJhtleH3QbL7B+X68DRgApOgZZE7joPm8RMsF5Gzr5y0zXORj1U+lPZpe88Zv5Vh/N9rtGjqTZiXs+hFEnAM40nDmriRaEAHlefL7CEiO1nBNJ3PQ8x9fePoqOm/sqpXskHsphV6CtlfJxYq8x+ryCp37Zio859nz4fH0FaLDpY1037mTdXXUFh4N7wT/xXdIGhEjkxf7QZ9RhpRx8QitlKolm580rsC06KBv3zFGtC4yg1qQzrNwG8HJK6kogL6tzQ92cdvHHvef2bILL2KlnKvSHhUs49BY3eQ7u2oR6lUkepqpImzD39/W0mPMye34tCwV0t7ogDzdm+3Zl8/xUDxOxViuWRBim9KcLSUrY45ssY0teBXlF+QRYNhK/YJwefawAJ86+CBlBY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce2c733-7dc3-4198-a86c-08ddaa084acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 23:24:34.7672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBEzYILuXduQSZmI1YjAuiFXgpzbMa7IEmtxGsxYCbjkG5HfE67J0zfIpw1RzMv1C7IxLhLpnbRQs//yv+ZjXSqPiBrFdONS2ISXGWAuMdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_10,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120179
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684b61b7 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ZXo7EPI8xSGldhcCVpQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDE3OSBTYWx0ZWRfXxjjZii6EvOXc S822xfGeGfHigM1smrLqdaKdvnKWpDZI6HswzjPMsKMpri/vsis8FFA3GkSeDgczhRPfurNY1zp MoGF85v1lrVdbgKaTlIhH7AhkDxh9vPDtY2ixUBrMYHvx/Bfigc4u91izUnJqiX084a+y/UDkf8
 pnSVpXYhXpTmRcy+3wx13mK3IZ1ARe57pNsU8ACWWuJ+fP0ewcrW0DBMRSbLgEoGnOPn0HcT93b eoMUksDiEsShyTdnsd4noPpE29d11J5U8yB44TTjPgD7kyxqqWKPCP3+SCBGXGCiMp/Bx0VFPkl Gld3Gr5dhgYhjXBaM7dUSchfbqiCtGwC0nrgaNPCCHZZCArsKFjxDpTMogw3hAAGMufLkgMnQvx
 lYoRw9m+p/gfj2Hyd6gbf5/QX8qUxtT/1KXZw3exAO+K0kSz2YiaRvQOsWN5B3pynlUGe7pa
X-Proofpoint-ORIG-GUID: TA5pjAMtB1TMQxGTLVAADAoH8oJGnIe5
X-Proofpoint-GUID: TA5pjAMtB1TMQxGTLVAADAoH8oJGnIe5

DQo+IE9uIEp1biAxMiwgMjAyNSwgYXQgMTI6MDbigK9BTSwgT2phc3dpbiBNdWpvbyA8b2phc3dp
bkBsaW51eC5pYm0uY29tPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgSnVuIDExLCAyMDI1IGF0IDA2
OjU3OjA3UE0gLTA3MDAsIENhdGhlcmluZSBIb2FuZyB3cm90ZToNCj4+IFNpbXBsZSB0ZXN0cyBv
ZiB2YXJpb3VzIGF0b21pYyB3cml0ZSByZXF1ZXN0cyBhbmQgYSAoc2ltdWxhdGVkKSBoYXJkd2Fy
ZQ0KPj4gZGV2aWNlLg0KPj4gDQo+PiBUaGUgZmlyc3QgdGVzdCBwZXJmb3JtcyBiYXNpYyBtdWx0
aS1ibG9jayBhdG9taWMgd3JpdGVzIG9uIGEgc2NzaV9kZWJ1ZyBkZXZpY2UNCj4+IHdpdGggYXRv
bWljIHdyaXRlcyBlbmFibGVkLiBXZSB0ZXN0IGFsbCBhZHZlcnRpc2VkIHNpemVzIGJldHdlZW4g
dGhlIGF0b21pYw0KPj4gd3JpdGUgdW5pdCBtaW4gYW5kIG1heC4gV2UgYWxzbyBlbnN1cmUgdGhh
dCB0aGUgd3JpdGUgZmFpbHMgd2hlbiBleHBlY3RlZCwgc3VjaA0KPj4gYXMgd2hlbiBhdHRlbXB0
aW5nIGJ1ZmZlcmVkIGlvIG9yIHVuYWxpZ25lZCBkaXJlY3Rpby4NCj4+IA0KPj4gVGhlIHNlY29u
ZCB0ZXN0IGlzIHNpbWlsYXIgdG8gdGhlIG9uZSBhYm92ZSwgZXhjZXB0IHRoYXQgaXQgdmVyaWZp
ZXMgbXVsdGktYmxvY2sNCj4+IGF0b21pYyB3cml0ZXMgb24gYWN0dWFsIGhhcmR3YXJlIGluc3Rl
YWQgb2Ygc2ltdWxhdGVkIGhhcmR3YXJlLiBUaGUgZGV2aWNlIHVzZWQNCj4+IGluIHRoaXMgdGVz
dCBpcyBub3QgcmVxdWlyZWQgdG8gc3VwcG9ydCBhdG9taWMgd3JpdGVzLg0KPj4gDQo+PiBUaGUg
ZmluYWwgdHdvIHRlc3RzIGVuc3VyZSBtdWx0aS1ibG9jayBhdG9taWMgd3JpdGVzIGNhbiBiZSBw
ZXJmb3JtZWQgb24gdmFyaW91cw0KPj4gaW50ZXJ3ZWF2ZWQgbWFwcGluZ3MsIGluY2x1ZGluZyB3
cml0dGVuLCBtYXBwZWQsIGhvbGUsIGFuZCB1bndyaXR0ZW4uIFdlIGFsc28NCj4+IHRlc3QgbGFy
Z2UgYXRvbWljIHdyaXRlcyBvbiBhIGhlYXZpbHkgZnJhZ21lbnRlZCBmaWxlc3lzdGVtLiBUaGVz
ZSB0ZXN0cyBhcmUNCj4+IHNlcGFyYXRlZCBpbnRvIHJlZmxpbmsgKHNoYXJlZCkgYW5kIG5vbi1y
ZWZsaW5rIHRlc3RzLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiAiRGFycmljayBKLiBXb25nIiA8
ZGp3b25nQGtlcm5lbC5vcmc+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNh
dGhlcmluZS5ob2FuZ0BvcmFjbGUuY29tPg0KPj4gLS0tDQo+IA0KPiA8c25pcD4NCj4gDQo+IE9r
YXkgYWZ0ZXIgcnVubmluZyBzb21lIG9mIHRoZXNlIHRlc3RzIG9uIG15IHNldHVwLCBJIGhhdmUg
YSBmZXcNCj4gbW9yZSBxdWVzdGlvbnMgcmVnYXJkaW5nIGcvMTIyNS4NCj4gDQo+PiBkaWZmIC0t
Z2l0IGEvdGVzdHMvZ2VuZXJpYy8xMjI1IGIvdGVzdHMvZ2VuZXJpYy8xMjI1DQo+PiBuZXcgZmls
ZSBtb2RlIDEwMDc1NQ0KPj4gaW5kZXggMDAwMDAwMDAuLmYyZGVhODA0DQo+PiAtLS0gL2Rldi9u
dWxsDQo+PiArKysgYi90ZXN0cy9nZW5lcmljLzEyMjUNCj4+IEBAIC0wLDAgKzEsMTI4IEBADQo+
PiArIyEgL2Jpbi9iYXNoDQo+PiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0K
Pj4gKyMgQ29weXJpZ2h0IChjKSAyMDI1IE9yYWNsZS4gIEFsbCBSaWdodHMgUmVzZXJ2ZWQuDQo+
PiArIw0KPj4gKyMgRlMgUUEgVGVzdCAxMjI1DQo+PiArIw0KPj4gKyMgYmFzaWMgdGVzdHMgZm9y
IGxhcmdlIGF0b21pYyB3cml0ZXMgd2l0aCBtaXhlZCBtYXBwaW5ncw0KPj4gKyMNCj4+ICsuIC4v
Y29tbW9uL3ByZWFtYmxlDQo+PiArX2JlZ2luX2ZzdGVzdCBhdXRvIHF1aWNrIHJ3IGF0b21pY3dy
aXRlcw0KPj4gKw0KPj4gKy4gLi9jb21tb24vYXRvbWljd3JpdGVzDQo+PiArLiAuL2NvbW1vbi9m
aWx0ZXINCj4+ICsuIC4vY29tbW9uL3JlZmxpbmsNCj4+ICsNCj4+ICtfcmVxdWlyZV9zY3JhdGNo
DQo+PiArX3JlcXVpcmVfYXRvbWljX3dyaXRlX3Rlc3RfY29tbWFuZHMNCj4+ICtfcmVxdWlyZV9z
Y3JhdGNoX3dyaXRlX2F0b21pY19tdWx0aV9mc2Jsb2NrDQo+PiArX3JlcXVpcmVfeGZzX2lvX2Nv
bW1hbmQgcHdyaXRlIC1BDQo+IA0KPiBJIHRoaW5rIHRoaXMgaXMgYWxyZWFkeSBjb3ZlcmVkIGlu
IF9yZXF1aXJlX2F0b21pY193cml0ZV90ZXN0X2NvbW1hbmRzDQo+IA0KPj4gKw0KPj4gK19zY3Jh
dGNoX21rZnNfc2l6ZWQgJCgoNTAwICogMTA0ODU3NikpID4+ICRzZXFyZXMuZnVsbCAyPiYxDQo+
PiArX3NjcmF0Y2hfbW91bnQNCj4+ICsNCj4+ICtmaWxlMT0kU0NSQVRDSF9NTlQvZmlsZTENCj4+
ICtmaWxlMj0kU0NSQVRDSF9NTlQvZmlsZTINCj4+ICtmaWxlMz0kU0NSQVRDSF9NTlQvZmlsZTMN
Cj4+ICsNCj4+ICt0b3VjaCAkZmlsZTENCj4+ICsNCj4+ICttYXhfYXd1PSQoX2dldF9hdG9taWNf
d3JpdGVfdW5pdF9tYXggJGZpbGUxKQ0KPj4gK3Rlc3QgJG1heF9hd3UgLWdlIDI2MjE0NCB8fCBf
bm90cnVuICJ0ZXN0IHJlcXVpcmVzIGF0b21pYyB3cml0ZXMgdXAgdG8gMjU2ayINCj4gDQo+IElz
IGl0IHBvc3NpYmxlIHRvIGtlZXAgdGhlIG1heF9hd3UgcmVxdWlyZW1lbnQgdG8gbWF5YmUgNjRr
PyBUaGUgcmVhc29uDQo+IEknbSBhc2tpbmcgaXMgdGhhdCBpbiA0ayBicyBleHQ0IHdpdGggYmln
YWxsb2MsIGhhdmluZyBjbHVzdGVyIHNpemUgbW9yZQ0KPiB0aGFuIDY0ayBpcyBhY3R1YWxseSBl
eHBlcmltZW50YWwgc28gSSBkb24ndCB0aGluayBtYW55IHBlb3BsZSB3b3VsZCBiZQ0KPiBmb3Jt
YXR0aW5nIHdpdGggMjU2ayBjbHVzdGVyIHNpemUgYW5kIHdvdWxkIG1pc3Mgb3V0IG9uIHJ1bm5p
bmcgdGhpcw0KPiB0ZXN0LiBJbmZhY3QgaWYgaSBkbyBzZXQgdGhlIGNsdXN0ZXIgc2l6ZSB0byAy
NTZrIEknbSBydW5uaW5nIGludG8NCj4gZW5vc3BjIGluIHRoZSBsYXN0IGVub3NwYyBzY2VuYXJp
byBvZiB0aGlzIHRlc3QsIHdoZXJlYXMgNjRrIHdvcmtzDQo+IGNvcnJlY3RseSkuDQo+IA0KPiBT
byBqdXN0IHdvbmRlcmluZyBpZiB3ZSBjYW4gaGF2ZSBhbiBhd3VfbWF4IG9mIDY0ayBoZXJlIHNv
IHRoYXQgbW9yZQ0KPiBwZW9wbGUgYXJlIGVhc2lseSBhYmxlIHRvIHJ1biB0aGlzIGluIHRoZWly
IHNldHVwcz8NCg0KWWVzLCB0aGlzIGNhbiBiZSBjaGFuZ2VkIHRvIDY0ay4gSSB0aGluayBvbmx5
IG9uZSBvZiB0aGUgdGVzdHMgbmVlZA0KMjU2ayB3cml0ZXMsIGJ1dCBpdCBsb29rcyBsaWtlIHRo
YXQgY2FuIGJlIGNoYW5nZWQgdG8gNjRrIGFzIHdlbGwuDQpUaGFua3MgZm9yIHRoZSBjb21tZW50
cyENCj4gDQo+IA0KPiANCj4gUmVnYXJkcywNCj4gb2phc3dpbg0KPiANCj4gPHNuaXA+DQo+IA0K
Pj4gKw0KPj4gK2VjaG8gImF0b21pYyB3cml0ZSBtYXggc2l6ZSBvbiBmcmFnbWVudGVkIGZzIg0K
Pj4gK2F2YWlsPWBfZ2V0X2F2YWlsYWJsZV9zcGFjZSAkU0NSQVRDSF9NTlRgDQo+PiArZmlsZXNp
emVtYj0kKChhdmFpbCAvIDEwMjQgLyAxMDI0IC0gMSkpDQo+PiArZnJhZ21lbnRlZGZpbGU9JFND
UkFUQ0hfTU5UL2ZyYWdtZW50ZWRmaWxlDQo+PiArJFhGU19JT19QUk9HIC1mYyAiZmFsbG9jIDAg
JHtmaWxlc2l6ZW1ifW0iICRmcmFnbWVudGVkZmlsZQ0KPj4gKyRoZXJlL3NyYy9wdW5jaC1hbHRl
cm5hdGluZyAkZnJhZ21lbnRlZGZpbGUNCj4+ICt0b3VjaCAkZmlsZTMNCj4+ICskWEZTX0lPX1BS
T0cgLWRjICJwd3JpdGUgLUEgLUQgLVYxIDAgNjU1MzYiICRmaWxlMyA+PiRzZXFyZXMuZnVsbCAy
PiYxDQo+PiArbWQ1c3VtICRmaWxlMyB8IF9maWx0ZXJfc2NyYXRjaA0KPj4gKw0KPj4gKyMgc3Vj
Y2VzcywgYWxsIGRvbmUNCj4+ICtzdGF0dXM9MA0KPj4gK2V4aXQNCj4+IGRpZmYgLS1naXQgYS90
ZXN0cy9nZW5lcmljLzEyMjUub3V0IGIvdGVzdHMvZ2VuZXJpYy8xMjI1Lm91dA0KPj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwLi45MjMwMjU5Nw0KPj4gLS0tIC9kZXYv
bnVsbA0KPj4gKysrIGIvdGVzdHMvZ2VuZXJpYy8xMjI1Lm91dA0KPj4gQEAgLTAsMCArMSwyMSBA
QA0KPj4gK1FBIG91dHB1dCBjcmVhdGVkIGJ5IDEyMjUNCj4+ICthdG9taWMgd3JpdGUgaG9sZStt
YXBwZWQraG9sZQ0KPj4gKzk0NjRiNjY0NjFiYzFkMjAyMjllMWI3MTczMzUzOWQwICBTQ1JBVENI
X01OVC9maWxlMQ0KPj4gK2F0b21pYyB3cml0ZSBhZGphY2VudCBtYXBwZWQraG9sZSBhbmQgaG9s
ZSttYXBwZWQNCj4+ICs5NDY0YjY2NDYxYmMxZDIwMjI5ZTFiNzE3MzM1MzlkMCAgU0NSQVRDSF9N
TlQvZmlsZTENCj4+ICthdG9taWMgd3JpdGUgbWFwcGVkK2hvbGUrbWFwcGVkDQo+PiArOTQ2NGI2
NjQ2MWJjMWQyMDIyOWUxYjcxNzMzNTM5ZDAgIFNDUkFUQ0hfTU5UL2ZpbGUxDQo+PiArYXRvbWlj
IHdyaXRlIHVud3JpdHRlbittYXBwZWQrdW53cml0dGVuDQo+PiArMTExY2U2YmYyOWQ1YjFkYmZi
MGU4NDZjNDI3MTllY2UgIFNDUkFUQ0hfTU5UL2ZpbGUxDQo+PiArYXRvbWljIHdyaXRlIGFkamFj
ZW50IG1hcHBlZCt1bndyaXR0ZW4gYW5kIHVud3JpdHRlbittYXBwZWQNCj4+ICsxMTFjZTZiZjI5
ZDViMWRiZmIwZTg0NmM0MjcxOWVjZSAgU0NSQVRDSF9NTlQvZmlsZTENCj4+ICthdG9taWMgd3Jp
dGUgbWFwcGVkK3Vud3JpdHRlbittYXBwZWQNCj4+ICsxMTFjZTZiZjI5ZDViMWRiZmIwZTg0NmM0
MjcxOWVjZSAgU0NSQVRDSF9NTlQvZmlsZTENCj4+ICthdG9taWMgd3JpdGUgaW50ZXJ3ZWF2ZWQg
aG9sZSt1bndyaXR0ZW4rd3JpdHRlbg0KPj4gKzU1NzdlNDZmMjA2MzFkNzZiYmFjNzNhYjFiNGVk
MjA4ICBTQ1JBVENIX01OVC9maWxlMQ0KPj4gK2F0b21pYyB3cml0ZSBhdCBFT0YNCj4+ICs3NTU3
MmM0OTI5ZmRlOGZhZjEzMWU4NGRmNGM2YTc2NCAgU0NSQVRDSF9NTlQvZmlsZTENCj4+ICthdG9t
aWMgd3JpdGUgcHJlYWxsb2NhdGVkIHJlZ2lvbg0KPj4gKzI3YTI0ODM1MWNkNTQwYmM5YWMyYzJk
Yzg0MWFiY2EyICBTQ1JBVENIX01OVC9maWxlMQ0KPj4gK2F0b21pYyB3cml0ZSBtYXggc2l6ZSBv
biBmcmFnbWVudGVkIGZzDQo+PiArMjdjOTA2OGQxYjUxZGE1NzVhNTNhZDM0YzU3Y2E1Y2MgIFND
UkFUQ0hfTU5UL2ZpbGUzDQo+PiAtLSANCj4+IDIuMzQuMQ0KDQoNCg==
