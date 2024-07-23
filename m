Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7A613A275
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 06:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721717630; cv=fail; b=ZEW2cmB2jIe7CtnPSh0+fbvrGO0oQErt0qXpO6kVGg86i1t/ud4oCPAUBqdUuV9Gxhkh9UW1dUQrSoR5iC619tlilmx9i56bK1Qyi5JRSU2n+rNTai6OiJviaL0C4k2VQJpJwAp93Bcvy2576ySHtwIIkqM9+NfL7wl1MAY7Wrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721717630; c=relaxed/simple;
	bh=6f7R8T/5buLC1pqwMY8DaoWHAweY1C71KK0+royybZo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2R4JdAqk/U21+Bd8i/zUwPgAsoD0w5Is8eG/7FarYbmNxjcNUH+YoojXGbpoKuJN/KWTkar5q1B/AbjaO7acLRc4vJcfIZUbwiVt4NIW5qia4aZ3Qh8JhaIxydF1JRWUIWvyBPj+F1Z4ou6gcAep44yO9Un1oWW8jmiBAPeWN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=Eq+lvcSD; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="Eq+lvcSD"
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46ML2vM1015578;
	Tue, 23 Jul 2024 06:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pps0720;
	 bh=idnC/PspFYBOf1oe19CxCjrg4vbts6nqKTQh3DyMtMo=; b=Eq+lvcSDSJIC
	R8deOTOmx74YdIrPuTBN1CaqMuO/cLRJwx+9DY0/H7m/NE7WUriMlO0g8N5DHiHA
	gEiCDU3hZnrlKGre3hEu1wAQGGqMz9NcZPVFF2lw2Tj+tWcoFH5SrbUvhDZ3IF0G
	aVBSupR2iEleKQiVNV4mtVn7gnu1OKKS/+WfCD8FaNEWf1r9Ok3Zp2YwUT2Gv1i5
	YjPnXSmSmMiRhBEzoS12klDvW1FO6Z9yLPoGGdSqP5bGlcA+pxw2NgJBmgycxVGy
	IVW6JhnKH+VuiqbSwizbbnrgJ35+unM6066EKznDrqE6XR8FDhNcDx6+1bxCkoPp
	pebCj0BBPw==
Received: from p1lg14881.it.hpe.com ([16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 40hm0x8j4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jul 2024 06:19:36 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 8956580566C;
	Tue, 23 Jul 2024 06:19:35 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 22 Jul 2024 18:19:01 -1200
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 22 Jul 2024 18:20:16 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Mon, 22 Jul 2024 18:18:55 -1200
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Mon, 22 Jul 2024 18:18:57 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iK1dG+KxZQDXELKSWQP/6RT4vpT+RCoS8JFIGcARHgsJHb2zyy2biqL36OmqNAsVAZxA1g6B+oy7gihsfNIMbYA0xva4okq4blHnPIT7JBNB3bQMFJFM6UClSgVCNc8+nRejx5aEfMuq0q0nfyafQuKsuzyupSsHrdIbA/L48MEtPtE6Yoa6aaEdaYtvhDPxAI1IoQNGl1gJxoVmyQeSvTvK3cU+1wnnnD5OXGnSJsL21ygBDN4QHmHTi3pljUrIXDkpdcbgVQ7ENk6JQ3/QpGhXbiVfXZCrVRpNL90rjegkcHD3WIbY+SlVYNPikb8AYzIcoinOICXx8aok+1brUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idnC/PspFYBOf1oe19CxCjrg4vbts6nqKTQh3DyMtMo=;
 b=To5FA0lbTy5wy9r8MwevJfEQfffzXzC+7X/5Nnx3tD7eM0pzZQft7ZVNwZ/Lng5KzdxBKOPwvIHHVPqfh00lIJgVHlDibLGYM4vcpXIqW5KBlp/V3vL1IB/4eYdrgb/rmOcVW8YquoP8dr56RG/GfRcbcKeVTkyuz01D2XtnpvdKItqa/nNBa0RCVIK7Tptsk50PhPTIDNLldZRD0JR5uj6cnAnrlG5+1OltvBSQ1syK5flf747iKMGcpKfkz5e66bB3eT2vGHBBNZOtrCVuIfjRGzKS4TX0YHdg/e4UAWV6J2GH/4X31vp9KV9zsrxwG6kwvi45TkUnzYOlRPIdhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::20)
 by SJ0PR84MB1435.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:431::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Tue, 23 Jul
 2024 06:18:55 +0000
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4]) by MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4%5]) with mapi id 15.20.7762.027; Tue, 23 Jul 2024
 06:18:55 +0000
From: "P M, Priya" <pm.priya@hpe.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: RE: xfs issue
Thread-Topic: xfs issue
Thread-Index: AdrcQhF5C2oUXPgHTjOszvEetVnEuQAAKJxQABB8OgAADMBcQA==
Date: Tue, 23 Jul 2024 06:18:55 +0000
Message-ID: <MW4PR84MB1660C7929333CE85B3EE9DF288A92@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
References: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <Zp7Z+vLH5qmyGXHV@dread.disaster.area>
In-Reply-To: <Zp7Z+vLH5qmyGXHV@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1660:EE_|SJ0PR84MB1435:EE_
x-ms-office365-filtering-correlation-id: 0b6060e7-b6ef-4049-a2d9-08dcaadf54b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?Jv0/+LxqOzupK/DSjS01+TFJpto6uyX7hSGmXelJpvWEiwWyQDp1eUqIIL?=
 =?iso-8859-1?Q?P9BTTtqJ+Ct7uGqzAa03+qSDgiQWuubbaBgre2qd8395chJtoVbMJkiVnh?=
 =?iso-8859-1?Q?R3NOUdmJx/EjrwpLlzRFJv4/5jd9hk8h/5vNgJbF2QkDKcI7Xp1W7C7Xk6?=
 =?iso-8859-1?Q?nmAUqs32squpAJDiq5Eqa6fqGpxD9IRcylT4yIayIO8K1jC4arv4lsIbui?=
 =?iso-8859-1?Q?I7zUbCSlFfUB7ExWV4SuMZ38/WVsOfa5t9gB94jXV2PvXcp+rxOi6yxxv4?=
 =?iso-8859-1?Q?R3cp3WYtmPN0/MkCmreU9l11rMgl6NaqQP+EpByPY/5lLLlOMusZAF5Ps1?=
 =?iso-8859-1?Q?R9W0F4uB6YskuP0fUVn04ZIn3Ry2Vk7fD+81c+17fYjseBDEn0GwW0uKsl?=
 =?iso-8859-1?Q?sWMLU+fPqN0NNPF2wbUVQdN8oPrQt1dKa1jN1r3qR98BxGWyRiuHx19QAE?=
 =?iso-8859-1?Q?6R/iTULgaIg4QKc4P4cZkr4tRQuYNo4N58wzq6zPpG/AePJLHvYqENbhl5?=
 =?iso-8859-1?Q?JemF2vnra2Zhr3MsES1fJSUuRMW8GwHeKa0EjLHQAMrA5wkywgo46V+js+?=
 =?iso-8859-1?Q?ccgIaEKsIRgQV7PrFzS1SOU1ItBoSsELVqSeRIZO8g+Ee/GExBrVFyf4Eh?=
 =?iso-8859-1?Q?bfR1Y7eNTJcJZJtKjjY8Imeik3VDi6Ee1iN0pGrKu3oK1h/RLgN218p5rg?=
 =?iso-8859-1?Q?A5ZeTDvtN4GwjDE1PCPZnRuJi3rq3Smdr7ycFdXfqBxTP4KMQ5oI86lCoK?=
 =?iso-8859-1?Q?ZI4WfH7KYbtTdh7SUByOB2W/sUXmXeVk+BQSNwgr+cJN2R0+9ZbxzfLjef?=
 =?iso-8859-1?Q?TYb+kt2VuP1r/fYFc06B0OLxiUpNpfTx5kWU+upF2vXCvXZGaoMNtcJgDl?=
 =?iso-8859-1?Q?gRBwAawnXk8i88sHwvv6X/cNcHL73754q0Pv4GD16EpdSmSZbYOsF6t+Af?=
 =?iso-8859-1?Q?evdSRK3AFHylUpqriAr0YnFQQmWA6Dzu98QiAoMIIK8oMmrL91c9LaiCRK?=
 =?iso-8859-1?Q?Ne/Pa85hM0mvBpXGXI1Z5c0XrXhyCFwAytc/L08jMP97QxlWL0jyfoYTl+?=
 =?iso-8859-1?Q?Lddl8HLf4Ygsx6t2KnMb+YuyMOuq0HUs7lM9AiSpRJlV9JMIt52piPvat7?=
 =?iso-8859-1?Q?Cpfm+mdONwJtSZa4HL8yAEzjGNrsZFdWVs97wAUO6ecshiI90a4yKDjskp?=
 =?iso-8859-1?Q?jcQkodQIHcbqjlv6aOoTp56eoi4vkpcrVa9T9L/eN6P88tydxjqq+DvL7J?=
 =?iso-8859-1?Q?wMm5/MwSA/Z9kk5PvsMquLi1HGrJUQDvkhYRwNeRpE2zr7aKRP45ZuwUbL?=
 =?iso-8859-1?Q?i72ApBKQ8kGEAb4rEXVpQFhLWyAkup7jh9mLg0+qMMGydBEitnYW70xdOi?=
 =?iso-8859-1?Q?BwmNQYTT/sgLe7J4Gbjq0oc79RWQ9EHdp55Wy3KTYBQz7WfvBQkfI4yqeL?=
 =?iso-8859-1?Q?+LRw3pdn8NiJBTU0SGaiCnxtXiXaGpV7rVTAMQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BPg/gJzgABLdIXTxl6eoMoic1lw8EPfFCByWetHrvpFFkSudy3uLOS2HjT?=
 =?iso-8859-1?Q?BxqBQJQvkGTw3r2ooAAMKURUpubEa1AODvOCuMDXMZqB2ETV1RxfX4WD++?=
 =?iso-8859-1?Q?tNv3SQCIlTtQ+ZOxbz6on3uTUBDv14U2cs1FoF86sX+X7CPDpead4H21Ge?=
 =?iso-8859-1?Q?9507kDivH2aphlqT/3r3VLTWOFdpVN+zom+hT/gOhXBXzXBjZ87MiXA6/g?=
 =?iso-8859-1?Q?1TBi1R2klv8WlbZX58LnMGd+lPkcAIWnDdNqg+R4pdqFmwyYx1ntPHk5E4?=
 =?iso-8859-1?Q?Ucm1wqMkP8qgITs2mvA3r8yj3bRYUxOogBcvc15AQUJQUo1ayK5Xi2Kjyn?=
 =?iso-8859-1?Q?zVAd829WaKpaTBvQJOCMVyOk492bXWDl6rk66udUfhsZdHZAjMP4bQImKq?=
 =?iso-8859-1?Q?Rl0LrUaleWPm3f5EeezDIrb1LvIc/jPMd+rYwFMsg2yxZQnl1m3WDF1TzE?=
 =?iso-8859-1?Q?DZiu+tCgWlHGGfEgnNW743WLq8M8jyORxnYT1RP4Ifcr3w0k/7VkehudfP?=
 =?iso-8859-1?Q?yjsDS25l3rZV8gNVXhDGXLrqQk51T7sV3zMX0rRF/JSIZVoZe5TZa2p5Bh?=
 =?iso-8859-1?Q?LXu6VXc7j4U4m8MHRVah4UYdz0TbO7VgRY9yWhY9oy87jRYoB/nLV8bwh3?=
 =?iso-8859-1?Q?Mw+owDtmXvNp/WkJ7Bmli+lvqSzBvqMuUvzuvH1L1dgCLWdSbnx1JDRa9D?=
 =?iso-8859-1?Q?SymDNXLm5TLuLwpGHpWND388hyAjlMclLsdOgI03S01t7tOMv0YnyAtjgd?=
 =?iso-8859-1?Q?Dq3/WfIWZJBDfdN+KxaH7m7XzOx97McsqMbgYp1UlHEPSShIPMg5FWYVRK?=
 =?iso-8859-1?Q?k6hr2OMHRpQvrOwi4dgYaJYNclm77vv4yCow7D8JbE33PBlmjOtyQUHqrk?=
 =?iso-8859-1?Q?1s66XdiHmwC97gfT7BvQsy8dDkWVBBfxQz3dnksVtjS944ghv+i+CpIGAU?=
 =?iso-8859-1?Q?sJ48sh3mS84ZXdJga+I0VpZA+JfkxugPg6FeGAxS+NwSfhX4EF/sV7XVKA?=
 =?iso-8859-1?Q?4Ia53fE1fndDkprfkWv9fySQ+AIG2rmaZIjxBfhwV6lCTgJfixZD3Z5SGI?=
 =?iso-8859-1?Q?YqS1kFPmjl+UIGZQV655L5EEX/rS9xjAdcOGpaaCQyyQHr8/sX75Ib+w4t?=
 =?iso-8859-1?Q?3MHhiPqmeANjZjxOdKGqFHA3tIO3lvVGUGYgW86W2GGbK680FyQT7P1FbI?=
 =?iso-8859-1?Q?juh0JhaLAWRCfC6BVtdpyPl67RktfAogFm2cgVEV2dpAPtqgdBSBNTpaVx?=
 =?iso-8859-1?Q?tovrrpQNcSDrZLa5suBPhBYOYAajWU9afr6ZxWvC+/SlW7uUbHvAiGbosb?=
 =?iso-8859-1?Q?UqLoU9/MjedHkmjXnbJpDgZ4iatH2Id8xC+YM2yDAdXlQsJMexyj86vuMK?=
 =?iso-8859-1?Q?MR3cePCXF2yFaDNP47R2U56vzeSQ6b6Ftz7D8E32kQcFNzF/W96TCdRDYE?=
 =?iso-8859-1?Q?wcqJ4mrYdPc4En+ZTPCCMxYxIcCCmTgqAI+WEogjvMUUOvn/BA1ee6jaud?=
 =?iso-8859-1?Q?uZJvK2rfnGBVroM5d/46xl8/BVPGfZRFXdtJD5Dh9erPMABT6KfQNrKDWx?=
 =?iso-8859-1?Q?cJaU+ISYzUAfYH/oms3xIC965Vw55j9JT9IZYhmOqr90CDNZ/r4G6RHdgs?=
 =?iso-8859-1?Q?y3+BANT12fKxI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6060e7-b6ef-4049-a2d9-08dcaadf54b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 06:18:55.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6SeYomGH61cGYarTBR5tDK2QF5ovCe682GrBt7f9x1wUgC0xKzuu9mX5rh+k3wLyZGisqqkGY7LgBZ5xC6dvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR84MB1435
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: jAO-Wh97wgrb7-qtSTZ72uzUfyv2XUMa
X-Proofpoint-ORIG-GUID: jAO-Wh97wgrb7-qtSTZ72uzUfyv2XUMa
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407230045

Thanks, David, for the quick response. The kernel version is 3.10.0-1160.11=
4.2.=20

-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Tuesday, July 23, 2024 3:45 AM
To: P M, Priya <pm.priya@hpe.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs issue

On Mon, Jul 22, 2024 at 02:21:40PM +0000, P M, Priya wrote:
> Hi,
>=20
> Good Morning!=20
>=20
> We see the IO stall on backing disk sdh when it hangs - literally no IO, =
but a very few, per this sort of thing in diskstat:
> =A0
> alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed=20
> 's/.*disk//'|wc -l
> =A0=A0 1003
>=20
> alslater@HPE-W5P7CGPQYL collectl % grep 21354078 sdhi.out | sed=20
> 's/.*disk//'|uniq -c
> =A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 197207=
9123 18657407=20
> 324050 16530008823 580990600 0 17845212 2553245350
> =A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 197207=
9123 18657429=20
> 324051 16530009041 580990691 0 17845254 2553245441
> =A0 1=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 197207=
9123 18657431=20
> 324051 16530009044 580990691 0 17845254 2553245441
> 1000=A0=A0=A0=A0 8=A0=A0=A0=A0 112 sdh 21354078 11338 20953907501 1972079=
123 18657433=20
> 324051 16530009047 580990691 0 17845254 2553245441 ^ /very/ slight=20
> changes these write cols -> (these are diskstat metrics per 3.10 era,=20
> read metrics first, then writes)

What kernel are you running? What's the storage stack look like (i.e. stora=
ge hardware, lvm, md, xfs_info, etc).

> And there is a spike in sleeping on logspace concurrent with fail.
> =A0
> Prior backtraces had xlog_grant_head_check hungtasks

Which means the journal ran out of space, and the tasks were waiting on met=
adata writeback to make progress to free up journal space.

What do the block device stats tell you about inflight IOs (/sys/block/*/in=
flight)?

> but currently with noop scheduler
> change (from deadline which was our default), and xfssyncd dialled down t=
o 10s, we get:
> =A0
> bc3:
> /proc/25146=A0 xfsaild/sdh
> [<ffffffffc11aa9f7>] xfs_buf_iowait+0x27/0xc0 [xfs]=20
> [<ffffffffc11ac320>] __xfs_buf_submit+0x130/0x250 [xfs]=20
> [<ffffffffc11ac465>] _xfs_buf_read+0x25/0x30 [xfs]=20
> [<ffffffffc11ac569>] xfs_buf_read_map+0xf9/0x160 [xfs]=20
> [<ffffffffc11de299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]=20
> [<ffffffffc119fe9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]=20
> [<ffffffffc11c265a>] xfs_iflush+0xda/0x250 [xfs] [<ffffffffc11d4f16>]=20
> xfs_inode_item_push+0x156/0x1a0 [xfs] [<ffffffffc11dd1ef>]=20
> xfsaild+0x38f/0x780 [xfs] [<ffffffff956c32b1>] kthread+0xd1/0xe0=20
> [<ffffffff95d801dd>] ret_from_fork_nospec_begin+0x7/0x21
> [<ffffffffffffffff>] 0xffffffffffffffff
> =A0
> bbm:
> /proc/22022=A0 xfsaild/sdh
> [<ffffffffc12d09f7>] xfs_buf_iowait+0x27/0xc0 [xfs]=20
> [<ffffffffc12d2320>] __xfs_buf_submit+0x130/0x250 [xfs]=20
> [<ffffffffc12d2465>] _xfs_buf_read+0x25/0x30 [xfs]=20
> [<ffffffffc12d2569>] xfs_buf_read_map+0xf9/0x160 [xfs]=20
> [<ffffffffc1304299>] xfs_trans_read_buf_map+0xf9/0x2d0 [xfs]=20
> [<ffffffffc12c5e9e>] xfs_imap_to_bp+0x6e/0xe0 [xfs]=20
> [<ffffffffc12e865a>] xfs_iflush+0xda/0x250 [xfs] [<ffffffffc12faf16>]=20
> xfs_inode_item_push+0x156/0x1a0 [xfs] [<ffffffffc13031ef>]=20
> xfsaild+0x38f/0x780 [xfs] [<ffffffffbe4c32b1>] kthread+0xd1/0xe0=20
> [<ffffffffbeb801dd>] ret_from_fork_nospec_begin+0x7/0x21
> [<ffffffffffffffff>] 0xffffffffffffffff

And that's metadata writeback waiting for IO completion to occur.

If this is where the filesystem is stuck, then that's why the journal has n=
o space and tasks get hung up in xlog_grant_head_check(). i.e.  these appae=
r to be two symptoms of the same problem.

> .. along with cofc threads in isr waiting for data. What that doesn't=20
> tell us yet is who's the symptom versus who's the cause. Might be lack=20
> of / lost interrupt handling, might be lack of pushing the xfs log hard e=
nough=A0 out, might be combination of timing aspects..

No idea as yet - what kernel you are running is kinda important to know bef=
ore we look much deeper.

-Dave.
--
Dave Chinner
david@fromorbit.com
