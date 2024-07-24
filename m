Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A290B28E8
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 03:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721793109; cv=fail; b=Qss0h8yAy1pK/z9mhbAfJUwqi09q14Htdm0LZSmZ/ZHYhMUOaVckXGKezPjCyYgGMSCJRdV+VVKqGw0HMB03PnURIeO45lTXUPTcozzWXDIesvDtvv3CRdYFNHCML3oXaN5WpFiX/r/tamPyDaar4lU3Q1AfAtFIzAiRoaLdwzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721793109; c=relaxed/simple;
	bh=8uRpeyNIPf+ETlyV0jnkmRj0DOXtRHneaivvClmO5LA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8cF1QI6K8tqAHKSH/qT6cUbNkra8ll/zKnIyAcGkYk9FnfjuL3G3wMT6WyVueXvFfMqQEoAQWAFK1qtqhJpsJ3rP4vXOwFoAvpomNahh0tOzFfv15PKhcK/P0psyeCO4k8bjNpayGN+OshU0hibpf8oB4YikeqEQVVXWdKw7Os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=eKSI+vpF; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="eKSI+vpF"
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46O37GiR003418;
	Wed, 24 Jul 2024 03:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=pps0720;
	 bh=8uRpeyNIPf+ETlyV0jnkmRj0DOXtRHneaivvClmO5LA=; b=eKSI+vpFn5Wt
	lf5uK0AsEBasMWJwtBsopjt6ojNQ+WLmvcek7jB8a4gpCGDG1VsBKDFv/T3hJks0
	107Mdl1sFxCqWSQxyhLLgTMDqetONPCZlJM+njV59RVrqVKXcm+MK0elxAXwI8dL
	+PzpROPTZTnNI0qb5mxR+p/7QBzgppgfIibwFmS7W3lZKCSh+CW/9E4Pj69W8OCY
	iOjUtD3+L1b31SKMjlWzzU9E6y437Cdd9xVhzO+n8CwaZ5nd9cJzO2huC2aUprlR
	7uYzZRHGEeU/gHqaEhWeBgFHnBKAXRWrJxrXCfDso8VM4CG4195+c4peqh4SpWDr
	aNNKCquVqA==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 40j914fhpq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Jul 2024 03:51:30 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 5E635147B7;
	Wed, 24 Jul 2024 03:51:29 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 23 Jul 2024 15:51:09 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42
 via Frontend Transport; Tue, 23 Jul 2024 15:51:03 -1200
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Tue, 23 Jul 2024 15:51:02 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzad0y7dc6/f+eks0scACNuXMNV8T+N9YF1XG9nRF84y4IPv2Or9qIXGHWqJaQfpPkTmERhiEZEqbohLg6OrHHmLmrMig5kAPkpVnVn+LWt+EqzhfgnEREsh+VwDld8CFcTQ2Ti5qGPy99N7Wi/JBhYd4YakFKiMOuL6nh+Th7gFG8oh5SG7s9MkFbdt9+QV08tDl7eMMETRigSJBsGSAtdDjhVeKC+zDr6BPykWDcDwqG8v+IbEz+/ZyCvGBHvTm/dugZ0Aj6frtkgC3I/vtCLevbVygAkETFyoPNehobHWPUvKWnLH1J2WsXeUldDhbLF+3H867fU18k4d4mGdlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uRpeyNIPf+ETlyV0jnkmRj0DOXtRHneaivvClmO5LA=;
 b=Dx3rzA8BCEVwWUOjZTBmNKY8xTKsA76LKxR2THbSwtBCDCsXF/NNC1KeCG4VFX4nR36M7anrFpaKfM7g7twC+Nq8p9vSgzL7c+IXvLsupfcROVHP9dFL88syqDo8AXbL7/XPkDNwKK/bKD3naZoP3sMv05YC6bdMsvFF77dBdGP0culrjhrbRhP2qsHSLkFOjTz79vHyIg1BnIVa87nGj+m+pWQ+xS0wkTTSMOFBFhJ/AmfCQfZhF+Qzare8WCJUO5ZwG8YCZJEhufVnnVK9AftnPUR43F6I7YvQzTAdROxWBbrt+O2Pl8tbySD1sKGk/B+kMJXHQfKiQ75x3mdgPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1a7::20)
 by MW4PR84MB1825.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 24 Jul
 2024 03:51:00 +0000
Received: from MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4]) by MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::3844:7698:9b5b:55a4%5]) with mapi id 15.20.7762.027; Wed, 24 Jul 2024
 03:51:00 +0000
From: "P M, Priya" <pm.priya@hpe.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: RE: xfs issue
Thread-Topic: xfs issue
Thread-Index: AdrcQhF5C2oUXPgHTjOszvEetVnEuQAAKJxQABB8OgAADMBcQAAksi4AAAw9FtA=
Date: Wed, 24 Jul 2024 03:51:00 +0000
Message-ID: <MW4PR84MB166042CCA1E3ECF15FF7ED1288AA2@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
References: <MW4PR84MB1660F0405D5E26BD48C5DD7C88A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <MW4PR84MB16604A5EE24D0CA948F1D2B488A82@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <Zp7Z+vLH5qmyGXHV@dread.disaster.area>
 <MW4PR84MB1660C7929333CE85B3EE9DF288A92@MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM>
 <ZqAl0CIXzsfAta0e@dread.disaster.area>
In-Reply-To: <ZqAl0CIXzsfAta0e@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR84MB1660:EE_|MW4PR84MB1825:EE_
x-ms-office365-filtering-correlation-id: 017b3da6-e219-45a4-c28a-08dcab93d545
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?jNRtDFx4PRixmHDaQBpPQz01/9c84IxnA4IqEvYAkYFVErKZc0PaZXGkhcI/?=
 =?us-ascii?Q?qXjXTOrc2hsGKCY61dfXdnQxr7TPNjKMZAk9+JJhszc6k+H9nMlFpuJZhqGK?=
 =?us-ascii?Q?ia0N0XHX1ONiCxQ2L7Zzr+SNu8pf7dPEUefsk2M4rHmenjgSv/lqe+vqTDFU?=
 =?us-ascii?Q?gNOt8SZRxQSkqIkhhbczEgqqei/mfzqSTCElYXi7zzdaEl7Fo4iiVxp2n+fX?=
 =?us-ascii?Q?HVktlriuP7RPWI7FgcRxR6G46kHg5IFIImHFDmiIIGLYxQ1n7x4DbFnB2XtL?=
 =?us-ascii?Q?8kIADhXAPYHC1kPr6ryExBmYn3pdRc036DcYYNXwBLJBKcagULCUXzYfj9BT?=
 =?us-ascii?Q?06jEe3KnaVFbvAPmn/+G7eCSsv/LI6uea9fDICRoDW0uQsVcZv+ZP8XCifgl?=
 =?us-ascii?Q?t9diHvTPBfBtosQnyyk3+GfSjtXKqIdSL3Bdex2AKkATu2dFpKVx7rJo2K5n?=
 =?us-ascii?Q?wpcDLmYmK2+EGFVEzspyJ5kUmZK98fu/hamxuBw3BZQ/wXSivk5txf5bqwdx?=
 =?us-ascii?Q?JUPc1+uTJ5dFdbpBAG6aa8G9rDvmEt1CuyP6N7aXT6j++IlaX588cI3HrWAh?=
 =?us-ascii?Q?Ef7goRQql9Xdgji3uicEpM598TzGtJHvnQyfhHWyPeqKGBtmTFOmtzMzSdIU?=
 =?us-ascii?Q?kjlCD3WypRCYPBSjnjV88O57N/2WW6fRoJ+T5Mtqspzw6KGSxyDy27rDL171?=
 =?us-ascii?Q?UTBI7whBQjIWhbVsmtHnuWn6J60fOAkEiOLpKiDaGlEPICAkGQlQx89CufjO?=
 =?us-ascii?Q?33gjr0CqB0eh90z5YxArstpeGpAlHOg7uhV7Im5nMl3QFj0Z/VhOIJCHbfbw?=
 =?us-ascii?Q?+5sGVcpaVmr6uLvhrcwOHdq2ZaJ26PZFWEBuUS3OIlSjP9e4E3si5EGOtmp5?=
 =?us-ascii?Q?JxBvfGgMXFWnVGy8EspjsOvUe6fO7LV0VoyMKoEosnGk0UkmLSI9Vo1EKV7b?=
 =?us-ascii?Q?K5ccEebOvoAHkBizVMB+4Xhq4T4DO0AVKM5q7bZa+UnmeZCcps9ImrGf/4fO?=
 =?us-ascii?Q?e86hsLQlS5pnp4ssRig5lGBWjMX5hZ+8wQYcUmDraiI3MhFHaUDov+a0yAnq?=
 =?us-ascii?Q?yYWm9w2TDvRSLUKwMz2i1VFAjDQHB/0vPb452sO6Ljf8CxaBzlqU1bSqY4Wm?=
 =?us-ascii?Q?7HNDBeqsH79L/WwezziEIiVjH5tOynTY10Z/M5mtmqBpq5OIUF74rfgoQuGB?=
 =?us-ascii?Q?ik3wT5hqHMIoFot1/odgG8EztByd+rs9xmnRhUegC0PdqRAcu/bWbmw/1D2H?=
 =?us-ascii?Q?r/+xDVhnCBtymds0UNoxX3uyZtXR0X7RZhVEW2/zm3cToPNEalnriMo/Oust?=
 =?us-ascii?Q?aKKHmCBmBTE0PY2nXit8kqBjfdTZe8mPI4MNk2oR7Pyv0baaaV69sjVroaKg?=
 =?us-ascii?Q?x7AMgBsCvDrKn6kX0zJ9l4zb601m8Eyv10J7Yg+cy4Xyr7yS8w=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YRCQnkG9pICdOQmG7oln3rh9Hl6u0TzImfgfDFtawNrliai8JYAXtJK9yjos?=
 =?us-ascii?Q?wfPdbmXIc44mrNGym7axDMtBfznZ2Pl9z+HqdHTbV3VDH9cakoTwZf9oFAxy?=
 =?us-ascii?Q?aHEklUZfrPj8vuNrdlt2qnZ1WlRmGTQ2BVcvbwxDjVBeeZntMPHgJ2hvydA8?=
 =?us-ascii?Q?U6unhSvRkR76d2mRu8q7mOkS8W30l/BGXbxjMm15aIOJD/tI0Sv8GWp9Gsor?=
 =?us-ascii?Q?xYuILOScl+3dHukWoWhpapVyEobWnhEAQb76jUrs602bF6Nm0EiQPwTD/IId?=
 =?us-ascii?Q?GVsCKsXB2tARpiiTXy0WTYZwAa1oYJrPuLZlUYbhrF+/58Z9AByiNn4zwC4+?=
 =?us-ascii?Q?AnWEcGD9OIxbacnyOhamK/wyVJrEoqTaTx5/oA1FhvoahTGhOhRR4eod+zdN?=
 =?us-ascii?Q?TCZ855p5AFGdCvj+4y26790Dwa6EMxYCAkFWBFAzXm2uVA/Y9WbEhNmWpgxU?=
 =?us-ascii?Q?JuGozTR7N7cEsm4JKcOZFapNX2cFsT08NqXISUuLPEMWdUpwZ6mlz/y9FYhW?=
 =?us-ascii?Q?0SKme50t8nRjiW0v/TRJajxjNKNvS09q4d53v+PslL3Fk+ojx86gH445uZHs?=
 =?us-ascii?Q?4ef6EFIDgrqbFyNftvz17aQdZ9a0wpPLY7CQicFQEi+NZUFzxplaHIDnIsaS?=
 =?us-ascii?Q?HS0Aq7EmyW1n7M7KqIpsQqdnuTkMFaC7jRpGrhzuv62rThhcvKsDfmhWaqYf?=
 =?us-ascii?Q?mNkxEYuMSYESmzqh4HQi9jL59jZPCoqMdcTNDqWyFO5c1xIzOhGkRT4HPh4I?=
 =?us-ascii?Q?8CsgO7Ik4/Hh8X7qW/KQljpOY9FAO//icLRPhX0p5xxtVwmzC8Jfz4vk619m?=
 =?us-ascii?Q?wTNC7IWgHnioSknDQ0NYXkAHcV7wc3V+r76QO6S0mcln+AHRviu7E5QpkNEg?=
 =?us-ascii?Q?6cQ1XrPiKIIyJPKSX1B7JyfzDZ7qABBmMYeNpTVAmyUWqa+MYR+K266xiuDy?=
 =?us-ascii?Q?PzS2mWOuyNtqfRtnrRr4uWTpXtUGjrbXA+q+YNMBmjy90EZrfIuj5v9uVzN7?=
 =?us-ascii?Q?EoT2IuTSyLepESijI2+r6CwRiGnvOdg7hhVD/j61lc7WRbG/PYK1XbduyjfR?=
 =?us-ascii?Q?Uvtc6JDUE2DGXPWlGEeJXv19cIuOoU8gZmXgJhWmQwxq0G3HGkTrO5ZRthTr?=
 =?us-ascii?Q?rLs6OC/aMhrgsfjYu/lGRCJScD2rOGmyVtLaftCHdJNXLXaD32r3ZBAm9/RK?=
 =?us-ascii?Q?gkYaUR9CHjUCW4iB1cZF3+H/pRBT6YpN44UPhrMxStkSRD1It6Oz7xtZBjKG?=
 =?us-ascii?Q?1/m92jkkAPgvBO+S/52aweTf8QVF9QqVphIjUyPBLpDQztoBXXhKmPCIPaLH?=
 =?us-ascii?Q?NsWfFElJR5n42ReXydWojQOXvVcqahIhcml7/SO8xTso3+WVw56m9t3GSnUN?=
 =?us-ascii?Q?FG04ngYYHNC0hApBqhERS192IEz3YQYtd4D2S+5eCGaR4jWnl+vP0qTI66zT?=
 =?us-ascii?Q?WH4oPgQ7vVKV4QfJ7NvzsI39v4zgg45wR6vtan3JAuys99zTj+JItF6sflB6?=
 =?us-ascii?Q?Bwe6UWuKCcrAxIjU6DTwoxGx9FrEH67qdIOxV3FrpKbcH6xMLFedkDGheMfN?=
 =?us-ascii?Q?rwqyO2AZl4CEsRzUUVE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR84MB1660.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 017b3da6-e219-45a4-c28a-08dcab93d545
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2024 03:51:00.5920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88aOdsMsBccjqYMQUmdEDet4PF6OP19GyM7zg+9C1IuLmUugNtqRgXvQf759l0EfoN7gFL04f8pUXKIK0sHRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB1825
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: SOFSKjoMoZjkWafMR_aC-y8twEAcccL8
X-Proofpoint-ORIG-GUID: SOFSKjoMoZjkWafMR_aC-y8twEAcccL8
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-24_01,2024-07-23_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=972 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2407240027

Sure. Thanks!=20

-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Wednesday, July 24, 2024 3:21 AM
To: P M, Priya <pm.priya@hpe.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs issue

On Tue, Jul 23, 2024 at 06:18:55AM +0000, P M, Priya wrote:
> Thanks, David, for the quick response. The kernel version is 3.10.0-1160.=
114.2.=20

Ok, that's a highly modified downstream enterprise distro kernel and far ol=
der than any kernel upstream actually supports. There's little we can do as=
 upstream developers here because we don't have access to the source to hel=
p diagnose any problem, nor is there any way can we fix any problem that mi=
ght be found.

IOWs, you'll need to contact your distro vendor for further triage and supp=
ort of the problem you are having.

-Dave.
--
Dave Chinner
david@fromorbit.com
