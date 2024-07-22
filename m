Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7066616D4EC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721658111; cv=fail; b=Ik0XCFzkJ03XMuVs/XAXta/Fwff+5ZdMoW3kbpolbEBQ/9yRhvq4OlfCttRiTT3IwKtnfc47DXMmc0O9EZYEqdH36xSQijcZOWXAGmv4cWjzgISDRq4xP3if/C4JvR7/SR3RGJeHSFAGppjHilnVaRIjlrY/HIf4vm+16YERbEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721658111; c=relaxed/simple;
	bh=tR++PE9Zqtn7Ahyc6e5R1ADPwXlqj/6opDbumF0igyg=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=enULLIffToBR5V3mlwCbLQjvIEuwWtaGNOTMfSHGeyizlNWoowJ5wLg1V8nEohhAlumCd/HkGI9ldtmgjLp9BvER19iT9i0wJdvGK4mp3yrRS9/fajX5tAQzehSmmkuF7l5qc+6sR65r804OEXoo/agM5RgrWpKY7h5BfkCKjgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=bJvTOoR6; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="bJvTOoR6"
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46M7RENJ022217
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 14:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from
	:to:subject:date:message-id:references:in-reply-to:content-type
	:content-transfer-encoding:mime-version; s=pps0720; bh=tR++PE9Zq
	tn7Ahyc6e5R1ADPwXlqj/6opDbumF0igyg=; b=bJvTOoR6irhJE6Z8fzXwOowh/
	AWzVjBgkDZMphw2AdvjrGE/86FdZ99qnEjAJeqKYpYdxuF/5iBXPTVS/6nIpO7A4
	dfjwOZaDty5IoKvGuok2WxaQ6DiYk47D5dusWbZBEybC/Ze28fwQyYGCLXW8hZh1
	p8BC1p/ssiNUBgXVGBldNbOlSMy+H5833jA3BTvRP4oB0oIJ7aXRjmYxNT/ZvHOa
	V7DkGlFRqz2Ds7Su6L9wOo8BRSp+1L1o0ByC01Znd8oQmh230+yRD9lIgXJkdZK+
	AKq5Ea29bXE6lotH9OcaAiHU+urtnyIE2kMhK35b9Jz2ysDg/iYa1UNspK1Vg==
Received: from p1lg14880.it.hpe.com ([16.230.97.201])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 40h45rq8g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 14:21:48 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 015828001AC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 14:21:47 +0000 (UTC)
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 22 Jul 2024 02:21:42 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 22 Jul 2024 02:21:47 -1200
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 22 Jul 2024 02:21:42 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8Ovi9LXIcGgYNoGYXiwBh5PEm8b+C61ZPES4GffbE1oqbgSRX8RDJVqLr+tYJMxkqFDxdUQDd39YTxUbjx9vYNUJff7j/0V3Y0Ti0kAQvZ4gOAeW3RcW1yRui7iwZ253Yp9IXD6ZEPpnFHyDz1ebYBHWEZrAy2VezW9iQwMKSOF575xjWj1cQGS6HwDQvMIZgJ+W0e9rPGI8zyZwE8bKyaurQAZijttVfWqfpxkaUMEPL89ePkDJ7O7x822afYjsiXYVDoa+Vi+pWVSelHAFcIl7rAOVzgX2+6HUoQ5ZpDiDxMF7jR54NpBy2MdIR1iaRiGBKW4R6IgkMk528t4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tR++PE9Zqtn7Ahyc6e5R1ADPwXlqj/6opDbumF0igyg=;
 b=wflpra4+Hm0XSaIIZIcoFL57HXa3nw8skwjNpdsPY13vScPqUeuPEBA2FzmLrZ7FxbfcoQ75HsBuu7gid+PEFcqFNPWrI9noLvgBckNjRAbAglQOCeL8B0rAozferWupllXq5S6upuec0sFzg37tWto/SNmKVVJTkW5DJo5QmqNQdLx/DH91u5DDVxKxH+405wbBO7fkA02wbtQ0bxn4Wgh8rn9TDxMAYKxkYKWJ95fI5gmAmU8W0FSMU2Wf1B0//9agJ7EG4JbYsUYrLiciUahLKZiMtE3DvaFS9sWcbFxoTMK2Qb742mtULSTBwNCkkGy637/9YrMh1f/KjHo1tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::20)
 by PH7PR84MB2080.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:157::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 22 Jul
 2024 14:21:40 +0000
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4]) by MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4%5]) with mapi id 15.20.7762.027; Mon, 22 Jul 2024
 14:21:40 +0000
From: "P M, Priya" <pm.priya@hpe.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: xfs issue
Thread-Topic: xfs issue
Thread-Index: AdrcQhF5C2oUXPgHTjOszvEetVnEuQAAKJxQ
Date: Mon, 22 Jul 2024 14:21:40 +0000
Message-ID: <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
References: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1660:EE_|PH7PR84MB2080:EE_
x-ms-office365-filtering-correlation-id: a778bdc9-3d72-4812-69f3-08dcaa599ae7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?sPGV05WjFYe2lg4L5WeGDlQxEJh5mSxs42mtTAhZZ25lJTkJafvNMiPvKb?=
 =?iso-8859-1?Q?osECJE05dNIXgAEWTaxChKKEBW7cbAfvwzN/6EuEx+G+hFuPlY/YoLgqZV?=
 =?iso-8859-1?Q?ftJhm14lPIGquWHr7B5Irqp9NTqZztGJo+C33avF0iux+VHxQO3qdLYUwH?=
 =?iso-8859-1?Q?XapcemaA4Kjw5JTKz/v01K6jIIc3eOz9S0sDKGfuY4My8KZXDIgtsFa4/T?=
 =?iso-8859-1?Q?KxAN6jB/XKgMRD9o1NUNQFye+VwRz4w1MAbbAcRzZbMyPwRoeheDJ2r3Sf?=
 =?iso-8859-1?Q?1ssyDvjde9hPhpJQQCML5EFOb3oYLS/s5oiIr4QU+o+F1f7UAvb0r74/pX?=
 =?iso-8859-1?Q?VKTv2AfM3XAaIktS42bm/btRf0xRlifxsH/MD49eT07OuW97BeMUdUNVu4?=
 =?iso-8859-1?Q?n9XIN75v/qoB4uSQBL/zSskyd5K98leKc0DeWAxuiEDRF0a3uj/8LxbgCD?=
 =?iso-8859-1?Q?gWrVPg0smAl0PBLybNH1+pD1GZsIA7prP+gCZ+YadL6j6jSR4NFr5/I/1q?=
 =?iso-8859-1?Q?3vtGXpNFJkaVxyEb7mWXw7q4BvlicwYc97ucNNOkyUdHerX1734yEbDdXY?=
 =?iso-8859-1?Q?lX9YFbfJFhk2xz+MLdzL9O+EYzgg8FoiO7imOLN3Z8e1lFZ05Tg8VlfOr4?=
 =?iso-8859-1?Q?Bj02Cqcv91L0MlXKM8PFw4hLp0svaiT5QbxISnhCMjyJXMEn9iCURwbC/a?=
 =?iso-8859-1?Q?aqmueNM2DUp1k7pk40cC9C6DTXA1uI7TXRQDbIdU85wcLgZKYUaZYjPdgV?=
 =?iso-8859-1?Q?eeRW/3PnOTyJGFur+nRG/r5iEBENVSPPQIx53F5BGZxDYuSLPNBUYKhtwC?=
 =?iso-8859-1?Q?2KNNAi+WyfrriHTWIsPsf4aiSp9lV8In/0P+Zvg5u/vad0/nm5kidn2B9p?=
 =?iso-8859-1?Q?5dnspjTiI/0VGVda5RTcjQZwET2qS0fqm8RiQzlA69vbI7W5dgGnKNcBOE?=
 =?iso-8859-1?Q?GCJef5BRA3WtY0g4i7bTr8HvEOuojsAeMfhXJbtbxw+6g82I4Q/iawNgxG?=
 =?iso-8859-1?Q?f1fWTXZ0pnYJHo1JpwTyOyjIZ/JEUuridDHkhJrTT6Qa4VyHNbP43OqxHj?=
 =?iso-8859-1?Q?tvWYakZIHw9lWY2NbQ/UJgYcTysPfedEbeV3pHy9mTJ7BnXDxQGKwcCk8g?=
 =?iso-8859-1?Q?HRjwGvnVDA6H9bgd+U0c/aIYjVmNzKwqXKhrBS7XcIVl4aMy63Hhy3+h+K?=
 =?iso-8859-1?Q?plWbkdwRRgZY/ZTtrxOPB/4zEd4auIBVobnnOs27iyrbgPSgy4md0ojm+y?=
 =?iso-8859-1?Q?D8rxCKAiM2YA9W3y1KhK5OKxqKFmAdzAnVRTj4e+GbgOC8DpQt4BGrag/1?=
 =?iso-8859-1?Q?XjQYUWKYe3ub9iCcq/5YHxHs8XkSyFyx7WX1sJSR6Xc4oj0o5lr+2a4gkw?=
 =?iso-8859-1?Q?27lYYmqkLVTipSmsUTovDvKSW7dmcNEdRgRZ+hyZr2EH9IqFH6IdEdzKLi?=
 =?iso-8859-1?Q?m+t4LXs0XSVVA3kbbT+CIYVmbX6+C+F0lXcRwA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?y9q2pHJADK7UhrTnM92Nk6u1ADKH+7kortyOOuowBkhh9wxKgVco55C3fu?=
 =?iso-8859-1?Q?tY5E52S7C2BYN9owScIP6nStbsujkZNUQcS+vteKoaHdtnlF/MECvEnCRj?=
 =?iso-8859-1?Q?dUV5kUiUqTbh71o21GNeSlhRTclujegSt1kIw+gVMN6XzlmeX17/X8cSVp?=
 =?iso-8859-1?Q?36Wd9u01WNqOMUWDrHkuMgeqnGhHqcVzlJqIOw78DCDZhkClN9/7lQR2Tw?=
 =?iso-8859-1?Q?0xHpcB7lxKC5lf+jJvbHPepD/Twa56ZWBHcg8Pb6pDLm21u5LQyf87adDV?=
 =?iso-8859-1?Q?+veaL9Mp7d06E/Rd8glMHUAvD4dvsrJ02n6Gnjzit904F5lXqSIlsR1Yzj?=
 =?iso-8859-1?Q?GO25GlKDgxJN+7Nb7CzA1q/NaXGYtWf018tApz32fdMeHrCG47+8kP9QWj?=
 =?iso-8859-1?Q?0OikZibfsbaovdYqfoHRWUIWrQZE4aIZHLgmOAABmC17Ct9pctOvV4f6bb?=
 =?iso-8859-1?Q?CQNxpZrqIHjuOYSiH9DJ7hlhYW0azkVGB4mUQfoz65HJSAyk4BgCHbrJMB?=
 =?iso-8859-1?Q?fUMvJgA5ei6r9vVoDJBWYyRKUe3a4tVaVMpm5GeVFKqevo5Fdk5gotNfOE?=
 =?iso-8859-1?Q?htZacDBzXCdexh5OJQI6Yzy/DwWlAExKk4+kebcOWHTAxcK3QnW3tgH52P?=
 =?iso-8859-1?Q?wtlBc5N8efwyAE8p7lJEE7MFBHU061Ms8jyW3OmkkFLS53dqS7LkeuEBAA?=
 =?iso-8859-1?Q?lfeSurkTvQLC6RmBVNhqIQS9JBXbDyOeZKwVo80p1pX4fAsoEg5hykp2w6?=
 =?iso-8859-1?Q?AsKJUdHpD9ydJWTcM91dn3YcFsE4VCUOyPQy+6Z+iu6R5q/71ZlZe5vQKh?=
 =?iso-8859-1?Q?YfZ6hm2OXVhBveL/GrDULNdpqXIYpaKSXHQf8EwA9cVjjNhFJ62OQ5dJb5?=
 =?iso-8859-1?Q?qxghXLigfBIxvagdbAgCF3iKRBeYWargdQxp7O/nuTo2HfWe0HE+zGaPnM?=
 =?iso-8859-1?Q?63yeuhSrQxjWQdwhbZb2lmh1QVYk4hqWRqJKY5EVDi0TuOuj8Bf1L0idAQ?=
 =?iso-8859-1?Q?S7WJgREo43nTjfwhh5nSHnbC95LsyLikviEb4BYG05qE6PmsTGu5JlrnPp?=
 =?iso-8859-1?Q?qMoL9iScbhdtuSS8KFM5lJZ05MeAu2EuTXXhKNnRa92gmHNhPS+v5wVYnt?=
 =?iso-8859-1?Q?TmRGfrY8ZBTjre2mSrYT6cAe/ve30W1oHWprJckrXLl4f7JflePLqsrky1?=
 =?iso-8859-1?Q?bP/2DIdAZbdJ5U0oEaicZcDN8ihSKbOWePgk1ffsqp05SaUyOQuQiuFsXo?=
 =?iso-8859-1?Q?lp1Q1ejqaH6jnbU6QCj3K2F37pCgnewC2HqgXdmFp0/UljO8K+3KJnsANk?=
 =?iso-8859-1?Q?/3aQATwo221A4bcaZiSPVmuzMglggwdg+03RlUv24mGe11vIO/p+0vocpS?=
 =?iso-8859-1?Q?+5mQcCXIwb0H9nNONuMqZxpLeTtC7d++N01h4y0x8t37QgKTbj/8pX+LMi?=
 =?iso-8859-1?Q?ZorK5m/vliRQedjvHTDgONUKPLVM8jF/aSv+mRinNZPqCEI1CsqWSQviAB?=
 =?iso-8859-1?Q?SSBSb/tO/8R6fIKInFY+XrFxhUKQ/fIJFMk55AnDS6/IQVPrPiCZKCLdzf?=
 =?iso-8859-1?Q?KwWzDihcDBzr8PGirQTyGVRjt0dJtesjP+DUxy9GAgp2VA64R8en86iPG7?=
 =?iso-8859-1?Q?MCAkJGSFksJFw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a778bdc9-3d72-4812-69f3-08dcaa599ae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2024 14:21:40.7216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4qFSmR+H6LQR3KBCxoM4HalccB6yTpxbMi0N7ATLmKGOlDUbWyxNGyk6Sq9Zqhfvmp5KtU8bhjRbPTSPEy7xAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB2080
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: B6xshgZdfF-Oa28yjmFds-uHvzv2qnn_
X-Proofpoint-ORIG-GUID: B6xshgZdfF-Oa28yjmFds-uHvzv2qnn_
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_10,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 mlxlogscore=837
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407220108

Hi,=20

Good Morning!=20

We see the IO stall on backing disk sdh when it hangs - literally no IO, bu=
t a very few, per this sort of thing in diskstat:
=A0
alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed 's/.*disk//=
'|wc -l
=A0=A0 1003

alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed 's/.*disk//=
'|uniq -c
=A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 19720791=
23 18657407 324050 16530008823 580990600 0 17845212 2553245350
=A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 19720791=
23 18657429 324051 16530009041 580990691 0 17845254 2553245441
=A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 19720791=
23 18657431 324051 16530009044 580990691 0 17845254 2553245441
1000=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 197207912=
3 18657433 324051 16530009047 580990691 0 17845254 2553245441
^ /very/ slight changes these write cols ->
(these are diskstat metrics per 3.10 era, read metrics first, then writes)
=A0
And there is a spike in sleeping on logspace concurrent with fail.
=A0
Prior backtraces had xlog_grant_head_check hungtasks but currently with noo=
p scheduler
change (from deadline which was our default), and xfssyncd dialled down to =
10s, we get:
=A0
bc3:
/proc/25146=A0 xfsaild/sdh
[<ffffffffc11aa9f7>] xfs_buf_iowait+0x27/0xc0 [xfs]
[<ffffffffc11ac320>] __xfs_buf_submit+0x130/0x250 [xfs]
[<ffffffffc11ac465>] _xfs_buf_read+0x25/0x30 [xfs]
[<ffffffffc11ac569>] xfs_buf_read_map+0xf9/0x160 [xfs]
[<ffffffffc11de299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]
[<ffffffffc119fe9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]
[<ffffffffc11c265a>] xfs_iflush+0xda/0x250 [xfs]
[<ffffffffc11d4f16>] xfs_inode_item_push+0x156/0x1a0 [xfs]
[<ffffffffc11dd1ef>] xfsaild+0x38f/0x780 [xfs]
[<ffffffff956c32b1>] kthread+0xd1/0xe0
[<ffffffff95d801dd>] ret_from_fork_nospec_begin+0x7/0x21
[<ffffffffffffffff>] 0xffffffffffffffff
=A0
bbm:
/proc/22022=A0 xfsaild/sdh
[<ffffffffc12d09f7>] xfs_buf_iowait+0x27/0xc0 [xfs]
[<ffffffffc12d2320>] __xfs_buf_submit+0x130/0x250 [xfs]
[<ffffffffc12d2465>] _xfs_buf_read+0x25/0x30 [xfs]
[<ffffffffc12d2569>] xfs_buf_read_map+0xf9/0x160 [xfs]
[<ffffffffc1304299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]
[<ffffffffc12c5e9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]
[<ffffffffc12e865a>] xfs_iflush+0xda/0x250 [xfs]
[<ffffffffc12faf16>] xfs_inode_item_push+0x156/0x1a0 [xfs]
[<ffffffffc13031ef>] xfsaild+0x38f/0x780 [xfs]
[<ffffffffbe4c32b1>] kthread+0xd1/0xe0
[<ffffffffbeb801dd>] ret_from_fork_nospec_begin+0x7/0x21
[<ffffffffffffffff>] 0xffffffffffffffff
=A0
.. along with cofc threads in isr waiting for data. What that doesn't tell =
us yet is who's the symptom
versus who's the cause. Might be lack of / lost interrupt handling, might b=
e lack of pushing the=20
xfs log hard enough=A0 out, might be combination of timing aspects..

Wondering if there is any patch which address this issue, please let me kno=
w.=20
Any pointers to further debug would also help.=20

Thanks
Priya
