Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9E11CD1F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948036; cv=fail; b=Wn76A0eEWnNPldfLyGIOvp7ixK26c6O46DPojtnzD6nFtLNJf3zklIgq6MrKDt7vYVpEUZ9sqVos3NhIEl6JAlUF5u5M6dO9cdO+ztoGiGSC1njA5r9XraISQk7P1gYfKIWMyN0z8qjpDiBvE0BwWrpHENEjnbLvFMvSryeMs8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948036; c=relaxed/simple;
	bh=MfnDyCWKouDYckWy5CfFuAAdc1Yrl4XoiXiTbigxekI=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rOvtUOG9NLbQUp8wcfXhlXXMdOqwx2VNJp7qeJOShBcdGks4bE6gfW0ZDUO9oxmRJKPVcutoLt8w8T1V48p+V8Bw2i0Eu7oV6lAfQmV68wf3Rfq1Q45nam1ht6srbzGNUt2V0BChPXLaD2MXGiYuchPVLR5+arlfmCTCtopnOos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=jbPLkRgA; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="jbPLkRgA"
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A5474A009368
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 06:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from
	:to:subject:date:message-id:references:in-reply-to:content-type
	:content-transfer-encoding:mime-version; s=pps0720; bh=MfnDyCWKo
	uDYckWy5CfFuAAdc1Yrl4XoiXiTbigxekI=; b=jbPLkRgAI2pNe/JvK5CjX6mJB
	p2FZccw95xvlNjWPTbimlPmCXt8wGQk7LpdEqSSygibWZQqZF+8Iu9XTEOVvCZXU
	+vZjAlIg1J/Yk8rLyII0wEqFddNafl+3vjTmXLFOhhsNHDvLV+6kxrqDVzqNj+Vy
	8ha1ZZ+zsV/RMaKzMAS6VhW7pbYG/3vQ+CSzA9oyl+PXSQgO7oubhDUGJ/F24/nj
	uozTT9spKW2ZXqVRBI5nWiDyZwuikmmhdZ/9k3C3SKwME5TclBzVfN0Kv2gCmhIO
	Rgsh1MRUQGRBS/9abLWA6iEVX61vnvgzjZBCfkHT1k1YaC8C8FG9VcwqDHoxw==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 41jfmx0dp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 06:00:32 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id BAAF8806B4C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 06:00:30 +0000 (UTC)
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 9 Sep 2024 18:00:18 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 9 Sep 2024 18:00:05 -1200
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 9 Sep 2024 18:00:28 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4f4npDhQSuPM48dkcLtU37BDzZQ3dxTD5YZSR95CNT39s23MeiFuiC4KFCJsKy1T01WOMX/rTlW+4bowgRKA+JK9/vUGLPCkXIBkJegUdM1EUWvqUbvRiQFtDr+0V2tLWokJhDhclPlLz0ZOZqKZuKPhvlXPaj6M6cn9VE94a0z+D9NAu5TbuLo2cBpMRX4/uolgc5bfHZu+cBfgomuFLSW/tqwj5uGFrnDBD+Gj+Tuh2LiW9ZAhTT5Q76hOg1+tirW4O13dCOp3iv2lbPEK/ShLK1YId0Jid1d8i2BnZGqg7AeLgOH0k29m5FwNN7smBAbZPPBbaUAF0AADDzuNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfnDyCWKouDYckWy5CfFuAAdc1Yrl4XoiXiTbigxekI=;
 b=r5B/uUnRNSKRB3nokY2K3GZhg/xCV+WrTzpooMKW4+1wMao49vnGCojJPSCMKTV6zUZqthoxyiVIYk1UGR8C9iW6zRHYqI4jwJjKFt3l2aGDC6R2ZX6Rv6WOKY18Cy10Z2biFUNXnoNUITCwBCq7wvKxJyNR2oBnvZlHI83dlxF8PAa7u4fYFhCcSRygkEPg8wfn+HONWWoXYXuZxA0D799zAz0Ow/OCzRr3ItC13lykfT+L2HpDyEo6yRdqH3oO/hMLjQJa00YXfeI+reg9HuMHDMMa1Br23ezKB5ghvuYk5Gzfj3gE5C0cwP+TYIH3b+JhWJH4+V/MyK0OwNAXtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::20)
 by PH7PR84MB3806.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 06:00:26 +0000
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4]) by MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4%2]) with mapi id 15.20.7939.022; Tue, 10 Sep 2024
 06:00:26 +0000
From: "P M, Priya" <pm.priya@hpe.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: XFS Performance Metrics
Thread-Topic: XFS Performance Metrics
Thread-Index: AdsDO3LyAKFhVtc2SFieusyqvePGcgAC9leg
Date: Tue, 10 Sep 2024 06:00:26 +0000
Message-ID: <MW4PR84MB1660429406E16C5B4CE9711B889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
References: <MW4PR84MB1660E875ADC85F675B7DE5BA889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <MW4PR84MB1660E875ADC85F675B7DE5BA889A2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1660:EE_|PH7PR84MB3806:EE_
x-ms-office365-filtering-correlation-id: 214b3d04-4aaf-4e69-6094-08dcd15dde07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?bAXOvYgKvlhFY6JQjtO8x/i9EcUjsYRXB16IHtRayMtTNC3dLPlhzf6AJf?=
 =?iso-8859-1?Q?u8Xh2VJpVCaD4p1HmxXbDw5Dp7m34ZhO68TbpiVsER97YjmP3zCDYQ7SZw?=
 =?iso-8859-1?Q?DO+dwzai70iGu6j6uYGmMckeuttcmUKvv4Oll4eRyAlh8fkL2/gH3PGtbb?=
 =?iso-8859-1?Q?Usj4gdW7IkPHKoBDPf0uIHyoAcYrGMB1hlukdEgyedHkKy69bpneCzr07u?=
 =?iso-8859-1?Q?QG4lkgsT+gHss8C+jBHAKP3l6/7KRcBJSmqir9AcugfA17erZkIYy2fHM8?=
 =?iso-8859-1?Q?AvFkzvk57NIoU/imejDb8/O8f0NYe9d+47xlR701MEIfr+gLbC8d9yjiIO?=
 =?iso-8859-1?Q?oDsMCeXFppAIxBHwq0KSNPqhCYh60fKC2Cp1oF8wnoKRtrel9Djj0A0/Rm?=
 =?iso-8859-1?Q?QXFGvfRzNg8npaA8ai7xlTA8sHN+050tYrVnHl2OAM7OZQqnBjEM7dWW4s?=
 =?iso-8859-1?Q?+c75RPjNZkpABluWfiHMKbwVlbRWAV/AzeXVonI23am1rMvhVSvhiGCuGU?=
 =?iso-8859-1?Q?AcRAFO5smzuvZwgGkkkSRWJd2EZY+hnnvfqkPwsMXN+/mVSjvWH9ZgPMa8?=
 =?iso-8859-1?Q?GMLOPWfvyQ93OCyXhqS3LuBy7OjlMrKO4R0nURxKUHdNoGmXHmBhIGcKeP?=
 =?iso-8859-1?Q?IEQAaAsOIv1Alrbh537rXwi3sy3v5Sjvqm5ygYfFLN/twuVCGsGBzq6VFD?=
 =?iso-8859-1?Q?zltE5hlCcgnzY4OSCOvdOI6LGlChjWZfmL0KXv8k70uyU6YfvBlAowZJwM?=
 =?iso-8859-1?Q?QIP7JPwIl9e0N4psclyHgzHWRV1B4oOohXzuvMXSTn87qspWKY+CVq1HKf?=
 =?iso-8859-1?Q?4NAe9HuYTqNoUMRqjTdWT4GZiyP+umcdL7cnORGGqGtG/w2ovonchDqcVS?=
 =?iso-8859-1?Q?MB9ykAjhdHw43s3IthUegdBQ9pH50Jfl23uCbVNEnQTAmVFjwuI8pM+7ci?=
 =?iso-8859-1?Q?erhCS3d+QUPBhb+qlrBFoDEjBZtbgzSPXeXrleptupNtaxDSHkZhlwbY3K?=
 =?iso-8859-1?Q?IBl5tEkBmqTx+usiaar9N5/gK0/jBJfQxamzRYGo48j+OBt0tolu7fWY8S?=
 =?iso-8859-1?Q?HUVz+b1O05PCgtws88ucF6Kj+k4Rtg+KQA/CZksZRpn0udLcu7WaGAvklz?=
 =?iso-8859-1?Q?y4rEs4ptit8zCNkcmd5jJ9Q6GPXSonTRa9ivrrU6byfe5q2SOHUJfo8Izj?=
 =?iso-8859-1?Q?8G4EaJzZhJKKbKT71sOa83sXF0hqxAjYMTbN1Ioz4n+jhxcvBE2br62liZ?=
 =?iso-8859-1?Q?1xHFjpo/ZTa2s+gck6e3MO5I6X+YBeRiu+6MlQSItKpt9XvF/RRBYlSPnP?=
 =?iso-8859-1?Q?rQ4pF4h0qIMF0G4jvW7GYm2NEYYu9YCVBQ15ZwScTEJXnxUrdJGXpDPPon?=
 =?iso-8859-1?Q?K2iHumgvDxv9PV+rj5t3gAJbD3sBUSEeHpemTZpD2QLve0859uSqYPIF0d?=
 =?iso-8859-1?Q?YowQU10XMSTd5/QvboKtg3EXF9pjII7dv9oAJg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kf8v5z6y+jtDJ/Mved9JAgjw0YyT8+8FqwYpUhMSkFy2oCQO4xOrWs8385?=
 =?iso-8859-1?Q?uA8fkEitkbDp3xCoI3k+6s3IPn7lUK6tpmFAuQ+zgqxucgbSXWBytser8x?=
 =?iso-8859-1?Q?tE1Ca/f/Uq96VHFN0keYCParlArvxs+ia7BJWBRSh5vD8wtdVGkVNWE0VY?=
 =?iso-8859-1?Q?wZ6AO2uNBeKPX2nAuX3n1FMhpuioKB0/CSS5RDIkij5ekJtUe/dbryr+yu?=
 =?iso-8859-1?Q?Fk2AHMFcgfvms3dpKyvzioexJ1HeSrLnVTJ4fitX+i/iw1m3DeR0fQ36C4?=
 =?iso-8859-1?Q?ema4D59KLCYCe07N6NHVY7sdHtllZ1WSN4CKYCW+iUOc5TCNHp77XIONsv?=
 =?iso-8859-1?Q?PUILLAVOneursyHQCfuHxsEwFQLW4XYTmYxTsGPsuwwtlugsk9dziO8w0V?=
 =?iso-8859-1?Q?2AVaW8JbmCYc5TFxTccwP9QgRiZ7fLHLTWUK7L3HVUdQ7/d7+Wdccr9ByJ?=
 =?iso-8859-1?Q?7dUcYPK/R420oFC26XoVXXmppqRbWhXNK04VepLhLuyogLdQUxvYHOQeCl?=
 =?iso-8859-1?Q?cHiAd6PHuPhYGeRT5YN4N3hwNL1jOmX8DiyABqH5lYtHdOKQbwqR5352ar?=
 =?iso-8859-1?Q?zs7gISSpxgdRWdvCxPwxQ4tJEiboTJih10O5HrZMEdaTEfSSiuZK2laqD6?=
 =?iso-8859-1?Q?10TiuKDNfOrqsFa2cAieOPrnGHn1vEThngIHDTDHwIjUuRVcx69tmvk1Wk?=
 =?iso-8859-1?Q?CHpI8gYso1YzoFRK8rNMluI+MOjBLdJT8quP79yAieJ4PNM0akHfubvpHM?=
 =?iso-8859-1?Q?s+ODm8IV9rtUqAH0gD9eMwO4gy0rE5ZVkhf1xOA6nDEF9S4+0gJJZbR4GH?=
 =?iso-8859-1?Q?y6G0pDI57aWDd5A2cMa2qWCm8h5+SsIN93Zc9X71FesSOEDbI0icKd+9Mm?=
 =?iso-8859-1?Q?RRhZZ2UjSQpdY3fgi6osrpKlsAbXM5PHJqlzMwW4FkP8v5Glkix0XFUYGS?=
 =?iso-8859-1?Q?2cA1k77RN9eDWGklp8J9DYy8kEbdSyUNZL299sD9YN3HvzK7HvN9R+em97?=
 =?iso-8859-1?Q?XcAf2dDhNophMBwa6K48U781gg8a0tXP5bwp7dVCCftiNDQWbz5sIYiIxR?=
 =?iso-8859-1?Q?mSvbZsHGTKwg9yfFPZf3evNtX5ju3Ja+Cg0tz6CnMsX0nOIFa7SFrbBfQ1?=
 =?iso-8859-1?Q?0ZCnWu21fYvFP3xiMjVc4uHoQl51iL/dqD1zZmhlONZq80ipzxgIwItfMn?=
 =?iso-8859-1?Q?lpwrMCDr+NrEC6jePH/RfctlpEYLUni3PD3KwKbNO26teAsVjc6HG10Zpd?=
 =?iso-8859-1?Q?/wpiY56T9ZQzMtb5ljlJOx4UXjpJkML5oEKpi65CekzLWkQdMKaPalo4eP?=
 =?iso-8859-1?Q?0lxsPny+qGCk4VftEwFA2XSOVk5eAtscLgGkovu2Datiok7qdIyfsRSVuz?=
 =?iso-8859-1?Q?Fqw2ABwBlBz3arX8eIAetAHAS0NOWYINBcXr4hO3HoZcJrDGilA3J8LESb?=
 =?iso-8859-1?Q?N3M/JjQ1tEEi42uvx3HQV42OKD74pNf0mbADEGUbQUVox9f3VyYyd/qezi?=
 =?iso-8859-1?Q?+Pf7w31sUdn6kOX6N42bk1fk6Tv7O08+szmV3fN6oGuZ9XgH6gXIGTW5mz?=
 =?iso-8859-1?Q?ev+Yv1wvDTF+shZ1Rh+2nYB1/PZLa6gfjxdozxHxaxNJFHTI+2zZcAbXjp?=
 =?iso-8859-1?Q?94IUIqu365znM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 214b3d04-4aaf-4e69-6094-08dcd15dde07
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 06:00:26.6521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0A0oKz0VZ/W6AJg/+eVCzGfSR03cmTa2ATrPkE3YtgSujwDvuuQbpRwipY2DUYt4IlWT5xi3tqdcgZNNk8oGLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR84MB3806
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: HT-EZ3fC2erOsyzFtDWQxBe0UNlyyxmS
X-Proofpoint-ORIG-GUID: HT-EZ3fC2erOsyzFtDWQxBe0UNlyyxmS
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-09_12,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=564 clxscore=1015
 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409100043

Hi,=A0

I am looking for performance metrics such as throughput, latency, and IOPS =
on an XFS filesystem. Do we have any built-in tools that can provide these =
details, or are there any syscalls that the application can use to obtain t=
hese performance metrics?=A0=A0

Thanks in=A0advance for your time and help.

Thanks
Priya

