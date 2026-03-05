Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54F263F5E
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772695925; cv=fail; b=NB2FjVJ0oZCYkutXsxh1xC+4uWlSL2wL4j9it5GTMVcSboZV5zCJMO4uzYSY36pQsHR3rItXleXHxAzXJF/VYukCo3ZWlN9R/sWhWdwkwjJXbGmmtA943bxMFxsXMHMM4608HBL9UuLWvG8BX52KA2rRnRHMIvpo/svnJEJeHzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772695925; c=relaxed/simple;
	bh=mK9oYTr1VtE/AFIj1r4jL7wZIy9cWCQsak5V/xQQI24=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RuKHY1mQfFy02t5U20eWfQmed0pTgx2Xm5R4risFh4wdo7JVYljru3wRcxV333t3cTbOuRmZsdhxifIl2Eb2HnXkxqK00jvzBO5lCN7aF8q+jJDFFP76GDdgtC9D5A56Zy+o6jagNZqALOWrR+A3f4UT35b6P5CgyUGxsM4U7eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=FrIpz/Vx; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="FrIpz/Vx"
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6255pc5X2120390;
	Thu, 5 Mar 2026 07:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=Tr
	1CTlXEvdVjcdgeu0TVV4vLd3ids2LXBQOvBRvwPlU=; b=FrIpz/VxYZfx6MeCTq
	XHUU+wkYDjoxrkHEfxZbeZ/jjLpMZSrKtQu8kxfk9ejNkFBHY2KEt63ts9U1aVfz
	KqiCDCvWTLDApyawaUoVc/hieKky1ZWhr8+B1/Eis4KPDSALfZi2fE7kc+bok9lP
	Iklxtt8PL3o4Brc8sRKDHneJlTfL/JYxi518mqkJsy2z206b2+qaPLVFETxXKm8g
	wzHqZQVBRavhrtG8HcvogWRf8XrEoDvhTlCGjT42PLDyy19nqECrWT2tA/eqqx9J
	4tPLoArUTd85yiCmhOPossb31P3poR8r5b5v3XN1SHDQDu9IFA7HZojyGLVzLYXx
	w1Fg==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4cpwaypmdn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 07:31:46 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id BF5A680805E;
	Thu,  5 Mar 2026 07:31:36 +0000 (UTC)
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 4 Mar 2026 19:31:29 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 4 Mar 2026 19:31:29 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Mar
 2026 19:31:29 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avU5BbL0i6f3IOl6kwm301/I1rLpYF5oCkbHsunmz9XIm4lH/2cZjrVYPFUZIpw6Q4rpiPRbd6cwUqooOU1EU96RjfWba/kYQYp8KyWPF4y5t4ghX7edaz/ZH9mTMXyKMzH6ZkbsNphHxdj5Afz43BVQZbjbA12ZLx+lCoBIDjxuxgmuOzDxTpCapv+fBNMLwRfGYCD98QEuL2Vvp7jBSAVyHCKxH3a8cB7x9YxgTYHBLw5kq3s6CucGu0ZisePFUJvkjU7jSADTAyWQq9TJgqvXg9OMETfV5/RALhrDQTrTznj8bYqUPh7eR3SRIyMc0epzQLJ1w7jY3VfqqXLXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tr1CTlXEvdVjcdgeu0TVV4vLd3ids2LXBQOvBRvwPlU=;
 b=ekf/W5OizcRfhZsCVrRmLkEo9rPSTbAdotwGYYmEiqZk8/Lb237Wmx3GGDnyMuDRif9x0/ZAaZxXzPbUXKyDmJeowktnjq1NaXr70RFZJM4FQQDk5uSCtGGz2PcsroL78XyqfmOdHiCOt+sXdp79x1Z/wy+OZKW+ANZ3nSKDKalzmc4pPHg88adEB03JRCROx7xaptGgfQXglH/ZGF1SwGzuEWoNmFvi/lvdLzQVRZXvxoE+3nUQID0szpQp5Zi26xMzamdS5N7qzOBwxsaFsmruwhmoo9y9hzXLski3JcbVh4lDr7HUt/yJG3Cw8RJKlI5LgxzEgdUhSb1mraoDWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::10)
 by PH0PR84MB1835.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:162::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Thu, 5 Mar
 2026 07:31:26 +0000
Received: from MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2ba0:a89d:6d4e:eda6]) by MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::2ba0:a89d:6d4e:eda6%7]) with mapi id 15.20.9654.022; Thu, 5 Mar 2026
 07:31:26 +0000
From: "Joarder, Souptick" <souptick.joarder@hpe.com>
To: "Darrick J. Wong" <djwong@kernel.org>, "cem@kernel.org" <cem@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: RE: [PATCH] xfs: fix returned valued from xfs_defer_can_append
Thread-Topic: [PATCH] xfs: fix returned valued from xfs_defer_can_append
Thread-Index: AQHcrAjUv5mznThbmkavTi5naYBPZbWeyGeAgADCdyA=
Date: Thu, 5 Mar 2026 07:31:26 +0000
Message-ID: <MW4PR84MB158899BC13DF2C9A6D22237A8F7DA@MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM>
References: <20260304185441.449664-1-cem@kernel.org>
 <20260304195105.GZ57948@frogsfrogsfrogs>
In-Reply-To: <20260304195105.GZ57948@frogsfrogsfrogs>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1588:EE_|PH0PR84MB1835:EE_
x-ms-office365-filtering-correlation-id: 94ead30d-f300-4daf-14d7-08de7a8935e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: XD7z9cLhPPHJEs9sUwDz3v64ALt5ui3unTJgUZM0L9FCFIjY7TIgxzup5y4rwFrakGiHP1F9kSo9pchpFSd8bPiE3v83qzLbsIu5+Onxl3yN4vPb6t9dNWWVDZBOxIl4eDFYmrTdzUNmmnh+utGGob5DhdkmY/Sj7XoJQuhLD8Ezoi7DMdIQUqUANuLjaE9lce/fasmtXWZh96iyi8QieSjR4xWVfq/Fqzs+Vmy3CCtK8jSK+Fg+bK+Q/UjPuuC2HwWCJTmSQqehDSaRBQ4nio0+11d3A5MNaBtR67AUtYbFs64nYY/eMdCF5Ozjmb7HEGol41TTnQ55bgWmY9eRpayUb3tSKBZTNs5cc3TBmGDU8u/PRDedybXwFCBGlNlsoHmDN38UpX67xx4g0ineGjBxSznyASnjKMal/G6b47bYTAgnlJPfvqHpq0ehCC8Zt1IykWQ/4PNlnr1VV4oBOg/RvHGCQoZt4do3ZJGF/s5HFvoTXVx2YYxAHm2LEEVbkCf4uYg009dNLviiJahSLKejOYW+n3ILaZN3m6gCu4eOeb5fjwqpWVK4f571mXxtvn5i21yLPam6xWsLzyouDtc/kcPFTtJXGr3FH4ym60waFWBp1zymBxPFKFqtKwqujWZCRRcBvo4Cfnmbw3HTBJahFJWajSBCWvUqcy+CIIAByjI2D1GuAQ8a5OjWbfVg70y3K5uKsDh73Bso/3shNcDuIAauy7Li//dBBrSjjDyHeUjg57xmmhsm5Que2BtZ1u4oubv+vSPvcAmCwbATGN98+bzvY8inn2uPXlVHo0I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lDhWmxCnmZddjzK1QVetHdSqWurmqLa69giKBYqe5swOE9b6AqaDyCH9B9hc?=
 =?us-ascii?Q?TZVWMsOzdcoPK0dVbG+1Iyol/X3dkxbfpIVqzyk19XOrLKd05Hs3xPfd086G?=
 =?us-ascii?Q?RYd1MZsKaoMbtJIWQWWeXJWoeTxvTNRCDazb10+KyN28v/3IrAm5VmIm8aSk?=
 =?us-ascii?Q?ULsoPrjWs6vx10AV/RHYDEdxnBaw6/bMq8rXvGOf5JLuOPEPZFRgNXAkZuJ8?=
 =?us-ascii?Q?ww5tpEqCL6ubs2Lam4A0nrhESzcbbBmCsgH7pRtNE6n2tvkQY7CY0HzDrfIc?=
 =?us-ascii?Q?JlOA0yiX8t6LwQJj5FLQZyG8aGg90+qmuA+xFna6kAUGmjbnNAbaJKFPhkqH?=
 =?us-ascii?Q?lMOoTgycT6TT+PBe3pkQ58uOm0XM5ZfWRfapHEffiqf8eHUVdnFjOxn1O9p8?=
 =?us-ascii?Q?gAPb+CmFtQ76PC0E7x3CeH/lHzVFHYK2DEMcmHBJVqT2HdOEYcl88R+HfY6U?=
 =?us-ascii?Q?CsaxAZzH0tO8v/syGU936US5MB9H0Kh+AvqEpRUBEX6pRvEEyuyHgGB3KcHW?=
 =?us-ascii?Q?n1aYye1Px18B/Y8+vIkNGkqMLt3isQZmiN5rIB1iEH2CjD5A4kb/NmRFv9/9?=
 =?us-ascii?Q?Z77+xpcP3PkIERlK5cH+3tJWxqezm8qh7WMIXSCyO/lQH7pxaKH1exNpOSov?=
 =?us-ascii?Q?jCmzzGZblbEU1cVLLOtCnpe/A0wx1ODs6uA1Ggqv3aNr7/N3TceRyKzdgSrw?=
 =?us-ascii?Q?lZWaIHbhTLyN7CSgzFrx9S1D5pnV6gnrR1+qJRYMg4szgAR0m1yY16OlltNd?=
 =?us-ascii?Q?K7JKgxkNo3VWfvXF+dVJUZFShci7iq4bFZtxrEdJxAyj0wDRo9P93M/+MlfH?=
 =?us-ascii?Q?Vg5yHckY42fRuVRMDZmn70LIJPIcJDd+7YXV1smWUu75yUHfUnpj6d5gFkA3?=
 =?us-ascii?Q?8ZO1QnJQSuQRt/Dthuy/lgaSMRlLc3KlCeVNBu2+HNvAZXPy60/fbOx4Tzhj?=
 =?us-ascii?Q?its9ai0oUPeAaPqNDpwBNKSL3go3x2x/Q8ZvhIFG7A+r3PzcSSKoiiBjZEiB?=
 =?us-ascii?Q?IU3pKLJ6UbsUMv80N/O8Uw5o39JGFP1rVXj/r3DpWJOAfIr6NReSl4OLKtYD?=
 =?us-ascii?Q?gg5hWLCsxQ/WY94uBbazFQUGZLq0udKN2fxCmoH7y9b8XncaNUzXsVO0AEsK?=
 =?us-ascii?Q?4WXiMCvUzCPxIjPfgF0Iv72KZUI3UQ3GVDsG8L5FAZsLC51kCXTzp/Nt4mGZ?=
 =?us-ascii?Q?Ia4Ey3hzOgxJ7AJAFabOpNMma1gqhVzjZu/v3jq6G1xMJ5OvGUcgElmu7J++?=
 =?us-ascii?Q?45ZhAkz8TwdW10k3sZ/gqcNyY9XcHtCwWEPhau05EtbWBtCtg0zYtv68y9J4?=
 =?us-ascii?Q?SZcpLB6fdeFGPcWOgynnTVYjr9RlmI1c5h3RbUcbM3kuEqamgPPj12E6jhEu?=
 =?us-ascii?Q?cqI1Bcpo6mT6GSv8DnGI7UlOuzTOdeTB5ZubpvgYP8+SbgQLi8Rl+ovW4k1R?=
 =?us-ascii?Q?Ib4KBWWYBysj6wklkHJ9+jQB3jVV3+kIGLcpEK5i/ASmyAso64m63eDezS4F?=
 =?us-ascii?Q?50rFNYM6BWLkmd6e/ivHNLuJFJRo93Ml/qsK6YO1yzRYDVcEbc+lOa9RwjGq?=
 =?us-ascii?Q?YpqE/gB5+Q4XkCRtSpNEvxAk2l/5r3d0iC2sl36FMPPdwIPDiEwtaEP3w/lr?=
 =?us-ascii?Q?JJRa/Wpg0GRzUgx+BXDoRAnPKcEm4iXDwmtNtKqmUOcVJxaTLGJqiVrSipXU?=
 =?us-ascii?Q?CzjUSeMpjFM4cvhB+z4YojfZ330klTcXwl+hdq5Zts+d6kY0cS/hAx74FHc0?=
 =?us-ascii?Q?SKL/Yz5KNQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR84MB1588.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ead30d-f300-4daf-14d7-08de7a8935e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 07:31:26.6166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pirZghDDsOhJsyBOH/0JyB/8x8/8nQV8L4d7ELv1TVMbuaEZps+G/SLn1TfmbWIGyCvqIgwrcKXWFpHTKe5yjJi5ImQDB+mEy/eqysdeWrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1835
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=DOeCIiNb c=1 sm=1 tr=0 ts=69a93162 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=g3u0LPWLDYfGfufhFw6-:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=MvuuwTCpAAAA:8 a=uA6knhVLLWKJEw59vEAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: yhlAz3lKmCAXmO_c2kTtLzoivZWtOzO7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA1OCBTYWx0ZWRfX/MpKHbDNDRl7
 DWBlsLnhz4CRn8/vCAcZ8SgIm8LoD89TwosCmyMFGg4SAU5L0YSSchfu/FZYB2W8T/F1rq1UotS
 8bT83B4F7QWrKVJi4jZN57mikClea5IcB01VMtN0K08uIBm44iuwg3gDybHx8Cq5M9dCBrDTDQm
 /2ZphcFsHLHqMKEUHhgOSBU8LKEX8orBgSQEdTsJUIQfvUW5CKb7HuG1hGCeycT9Gu5997Avw5x
 pyTOgvlMRYdvWYwz/xrZCtVWw2Yr6qXqXErtSsnI82+6WUGs2svhQoZQhwSK3cLxrZgnw0lpU3j
 ZC1ks2mbTZ5pPo47jdQYsPulQz6EoNWZCTzKhvMGHwbhdlUI/mFRM2mmNP4SntvpkJSwrbRJpPN
 X8Epc13Tyt3BImDv32bL/iBZAgaGVJ7fxGXKg/ZSF/dxuzdxiebKGPtrzMwJX9j7CPM/vKjcP5N
 rnvLBvYoVOAwddJFbUg==
X-Proofpoint-GUID: yhlAz3lKmCAXmO_c2kTtLzoivZWtOzO7
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_01,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 clxscore=1011 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603050058



-----Original Message-----
From: Darrick J. Wong <djwong@kernel.org>=20
Sent: Thursday, March 5, 2026 1:21 AM
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix returned valued from xfs_defer_can_append

On Wed, Mar 04, 2026 at 07:54:27PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
>=20
> xfs_defer_can_append returns a bool, it shouldn't be returning a NULL.
>=20
> Found by code inspection.
>=20
> Fixes: 4dffb2cbb483 ("xfs: allow pausing of pending deferred work=20
> items")
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>

Yep, that's a bug.  Fortunately a benign one.

Cc: <stable@vger.kernel.org> # v6.8
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Acked-by: Souptick Joarder <souptick.joarder@hpe.com>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c=20
> index 472c261163ed..c6909716b041 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -809,7 +809,7 @@ xfs_defer_can_append(
> =20
>  	/* Paused items cannot absorb more work */
>  	if (dfp->dfp_flags & XFS_DEFER_PAUSED)
> -		return NULL;
> +		return false;
> =20
>  	/* Already full? */
>  	if (ops->max_items && dfp->dfp_count >=3D ops->max_items)
> --
> 2.53.0
>=20
>=20

