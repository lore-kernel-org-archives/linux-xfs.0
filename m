Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4F722EF4
	for <linux-xfs@vger.kernel.org>; Mon, 13 May 2024 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620673; cv=fail; b=ZcTsovUtYN7h3zJ5gQM0Zk9Gw5Ddrc/aqtCqzDCEbczNpmsoyahLowubpLQVXR9pteGwpbSfncctGtA2tFfxvIi7rbPfnZYLCedhRksqEGJVEannZ8DoWInzdhbKxRZ7rHpOKpM1VXguqEEYHCGgZon7NXNJP3V42UWg5chWUM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620673; c=relaxed/simple;
	bh=50puNE2uhgl1ua3W6BcDomeQxHwub3C3bn/E0owfo5k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d5HDqvG5hAl1LKobYn6YbqdKJIoVNEzt39RIjHTkfU94e3rv9TX2zEr/ygLHZTsBv7ZnZwDb019ynaUUYImnnEK875mLoSM5WM2D/XjxETJJLDP7YV+Vbtop9ioDB0HEtdKvWiqD8GrBWIoncz5EEpgs6/yQMkj4qaNRlBiAmRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gQkjzm3q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aWQMMc3m; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gQkjzm3q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aWQMMc3m"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44DHGqEE015916;
	Mon, 13 May 2024 17:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=50puNE2uhgl1ua3W6BcDomeQxHwub3C3bn/E0owfo5k=;
 b=gQkjzm3q5YveYI/Iy5g18eFSlGskde4RSL7FACk4R1g4ijkU0Xph8TjvMeSZW51us9SK
 Grf1YGPkaubUacIV6u47Q+TH0XwcvAPIUdKH396k8NK1HT0c/C33ZpDwGOnnq4wI/rE0
 YVx1mUL7wQCPgtJ58gOtGLPhf6cyoKHzSYqrVWy9pvHo0rDxVFBAgZmfQOsdPnP25KBU
 bi1qya/Rh1uLOj+KQJ3cJIbTpYtSC4GgfHjAJvb/QG4Li70Y+C9tg+bcsThC1a4ueXYa
 X6hNAHHOWBxTGahL5/xFfAu0JQm10VBT6mmqEZJqi0jNu4WgvdzRYIiClkl9L59wOmyl GQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3q48801b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 17:17:49 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44DFuHbQ018918;
	Mon, 13 May 2024 17:17:48 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y4680wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 17:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+dKIIsduXIachC3UrgE4gqjef/hZpr3Be5dZQmqYkvJv3HjSwomu2L/R4It1JykiOsWFVI+2HasPh2GtuHVTlP/qEeC5mV63ifpJcaFNG1Ks6hYQfDfsy7ziCgOmjNzdwYG6tbWicmhDEpYTTx5EfsBoFAS9jtjajLJkNnTlxq/o8QadPSnEIetOB0otfVGcbn6C3bbbj3uQWFxp1005bYlGmSPeIzqON1N4MokRqVnEmFZd0j7buK/UnIi0rOQIqL2/qVtpIlPozaw4hTymn+AtbduPLGBTdG0AeLvaiyfMlI8MI8Y5A0tUGfUOvAhgSc6jrX/OAeqWRB7Uy+Y/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50puNE2uhgl1ua3W6BcDomeQxHwub3C3bn/E0owfo5k=;
 b=XXd09IO4T1iE0gjjyUPCcW0IdgTBAo4NpupJy5arbj9oKPdrfPDTxjaK3arTMbSQReJyBSqgEBGpXgf7z8a6hoaN/+Py9YfUf3WFhjU8QV9nbdBeBQKL1Do5mlXaq6TP9iBTgp2PHAJi1CIr1cxIyVOaR9QGH1pcMGeRKAFuR2jEmXskSRF+5D4YZcMFFnZC7UoTmZlE/hx4U9eK3/xZmnk97xvTnBYRB07DwhKnttm8sNIRwovicp3bklmFnhht5E5NS3CEeEWODPOODqt33FcTybDJzZesRk6wRfSHJNqV0jE78KZB8N1xjhpwATVyEcFK/1MnTh+6874A/Vz8uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50puNE2uhgl1ua3W6BcDomeQxHwub3C3bn/E0owfo5k=;
 b=aWQMMc3mHJTwQbzDOQM+C6bdScJsziDEcuFHHnDGvBYgpUiZaIMwm4AUwo3jo+2Kimm68KB42PhYTkq+oXAk+gR3SeCiszRLD1zCx5zWvxSzdOh/ziTD4P/72F1OuaWzlXGAVvSPrGeKS5fSlfDvc9CSZx3QQe7kmZok0vWZZ2A=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.55; Mon, 13 May 2024 17:17:45 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 17:17:45 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: allow changing extsize on file
Thread-Topic: [PATCH] xfs: allow changing extsize on file
Thread-Index: AQHaoWmxcn2oWXSBBEq3b4hzshxxLbGRSgOAgAQmDQA=
Date: Mon, 13 May 2024 17:17:45 +0000
Message-ID: <E0BFF9B4-C167-4534-A3F2-2C8BE8B9BCB5@oracle.com>
References: <20240508170343.2774-1-wen.gang.wang@oracle.com>
 <Zj7QRSyiXTJ6Kbli@dread.disaster.area>
In-Reply-To: <Zj7QRSyiXTJ6Kbli@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DS7PR10MB7129:EE_
x-ms-office365-filtering-correlation-id: 4b7bb0c0-c7b7-4d10-562a-08dc73709b33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Y2tCOU53WWdDSE1JN3lCejVlRCtaM29PQlQ0aER1clVreTA3b3Exb1ZHRWFS?=
 =?utf-8?B?WlBUY1VJbnJpNjlSY0ZYaVFZQTduSGNVaS9zVDNYRU01M2c5aWRyRERab3Zj?=
 =?utf-8?B?bXl6M0ZmVWorZGxFODFzQjYyVGhIbFFiVUloc2dxMnhNUnhTMndpcnZFclRT?=
 =?utf-8?B?YkZpaFRmZVNnckw5VWFNM082ZUlkSWM4YlNmMVh4V1A1MzFaVWdjcUZQVnZU?=
 =?utf-8?B?dmxKNG5ZWkc5NFBWSGlKSDBjYTF0V1EwVysrOEN5TE54Y1R0ejh2R3ZVeGFv?=
 =?utf-8?B?TGU5VWpyVXorSDczYXIyaFB1eGE0SVBFaGZYcTFmYVd6QzZId1V6OXp6YzUz?=
 =?utf-8?B?b3Q4amV0UlJzcDB0YU9vQUZRaXpNTEpDbE1nT01nalhWVy91dWZMTVZYT2lL?=
 =?utf-8?B?Qzc4SWVrZkNRSFYweXpEY2piU3A1WE9BVEhuUWt2L29ZdSsxY3FQS2F2VGFZ?=
 =?utf-8?B?WjhvUHcyVTZCenpuRHZhN3QvemxqN1U0Yk8wZ3FpRzVzU01oWEFaL1BZdEJE?=
 =?utf-8?B?S1FIREkwMUZ5Ukh4NzZQd1d2ckdBSm01eVdwMHcxUFYrYklnYnRBV042TFJC?=
 =?utf-8?B?T3hTSk80V3hITDNkQ0FvRHZLbWdrOHh5MThQdTZxcVRSNktPS0dTZjl0dTc2?=
 =?utf-8?B?REY0eGhsMUZDWWFWUlRiK0ZGaFg5azVvRThZTlVtMC9NVEVhc3E2YmhVMkV6?=
 =?utf-8?B?WUI5SDU0RkZiSXl5aDFuT3pSeXFKSEFyNGRuUGJwY1ovTXBRVVN2T3htM09a?=
 =?utf-8?B?dFpzZ0FlNXdLN3lRb3VGL2gyQVo0dXZLL09jZlNmMWZhRkpMZmpibXFNb3RZ?=
 =?utf-8?B?eDRRWlIxUGdHSTJNQjRCM1NYVElFLzI5cGwvbDdsUlhEaUdESFFMMVlmVnRY?=
 =?utf-8?B?b2lvS0NDcW1xcERSaThZZnREUDAvOElnMVFCSDFMS3d1VnVqdHR0WWVxOGpx?=
 =?utf-8?B?a010VFlwaHhDaWYzT1hSOXluZXlKSDRkdUhmTWpZR1hkRHlzVit5NlNUU3Zh?=
 =?utf-8?B?UmN0Zk4xSTRlaE9yZXlUV2ROMllKSkVzQzVhRGV3TWh5NzhITXMzaUdrVUFK?=
 =?utf-8?B?R2JwelVIa0kvNUJHUWc5ME5GdGFIem9DTE5jeGFNM0FBK0x3S1Y4Z0UvVFR1?=
 =?utf-8?B?RkhybllpelJ5T3dRaEY0cHpHNEN2anZmajNtL2ZGcDdESjIra2h1U2J6TXNJ?=
 =?utf-8?B?UmJBTy9RM2g2NC9JamswODlCZVpwalJ3M3pzeFQveVRuT0hDaTNyUktSNkpT?=
 =?utf-8?B?UlZRRm9oaXBKa3FIamRMbnRZK0QyeldsVDRTcFRhRElYakRWRVFQUU01cWsv?=
 =?utf-8?B?UFNPZTl2MzE3YkJLRW9seWJ2b2gvbENleklwTHczMXBFZVc5MHpOQ0VIa2k0?=
 =?utf-8?B?dHJMUlhRQUxsMzIwTjl1cW1PL3J0RWppc1N3UWhSV0VOaTdtZC8zVTBqVmlm?=
 =?utf-8?B?ZXVlU3RFaDFlenhheFo3cUtBOWplVUJUUWZUcWk4VHhGanRMWmFhZjYvODlS?=
 =?utf-8?B?OHdGNUFUUk1kdmV1QzllWUJZWGxDSHo0NEdkRFgwbFV6R1NlRHVOUzVxRllC?=
 =?utf-8?B?SkJXQUkvb0dEUmxqMFJOejQxbFJqWkNwUW5jMSsrUVhzQlJBNGh0M2FENDhz?=
 =?utf-8?B?TVRMVU8zOXpPR2xLTk9aUnJpREw2OWxvenJ2YWgvTEozajdrVENYQ2ZySmxS?=
 =?utf-8?B?RWFsQVkzeEVVOVNhVmdXVWRCYzBwRmpqSUltR204VDg4cDhoSEdDNGg5cVBw?=
 =?utf-8?B?NDZIbzI4L2k5aHZFOXU0Q0thNEpkQWZsK0dKamJBTjJTYStmdFBWN2lCQXJw?=
 =?utf-8?B?dXJVbHk3dDFUUnVRMlNsQT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?S0ZERlB3RlBKNUVnODYwU3JmUnJ2alJ6RlJucnArdC93ZUFhVWk0OVQ4OGRH?=
 =?utf-8?B?QlR0MDFlemNvZ1F5THV0UEtTR295N3hLakMrb2lhOUFkT3JWZFVacnYvbTFv?=
 =?utf-8?B?RjVYOElTRGU5S25FTzZoOVQzaTVMZWxEYXltQmlvNGUxMFQzK1lYRk9OZEhH?=
 =?utf-8?B?SitFWFBBeDVKbHZnVGNQZ0xXYm9HNmVxR0M0MUNXMTJybnVFbFNjcVA1TXZz?=
 =?utf-8?B?VGU4dG0wdnF0QUxCcy94OHo3UTZVZWh1eVpXUkgwdHkrTVJ3RVRvRFU4STVK?=
 =?utf-8?B?M1E5ZmxKUEtFQk9wVTRmbEE5aXIySkNkVlZPK0hCQkx1TXJsVS96L09leUNG?=
 =?utf-8?B?dC9lUkUwbEtjWDVuSlRoc0RpWkxSTEVEdEV3bWhBYkZUazFwMWx2WFNkaFhr?=
 =?utf-8?B?VGN4eTJWN0FyTWNwV1drUHdDWlE5Vksxb0N5SEphTHY0WjllZURZZFZxaUxr?=
 =?utf-8?B?OHFXZ2I3UEZvWFBIckR0ZWRvdkwyM09xT2YxUTJOQ2Ivckk0dVA3UURCeDZp?=
 =?utf-8?B?SXc0T3htNFJqSFpiNjFJTzJRN3ZOMDlBNGR4azJ2anB1NWRrNHd0K2JUYjRz?=
 =?utf-8?B?ckNUeFN3Yk1vZVhORDdhRjhrTE5qenI3Slh3TSszYklhcEovZWxPWThhWHhs?=
 =?utf-8?B?ZCtNYWNKSzRlRW1IYU1EVlJFSm0vKzVvTmRDTmx5R3RhUTVjaWZIVWdhR2lp?=
 =?utf-8?B?ME1RSTc2OWxSVWZNZUNLb2p3bFYwc0JUNWtxelczR3paYkw5Zy93UFBrb2Nj?=
 =?utf-8?B?aWdsVjRaYlRJcEkzWmp6VENDdVhiK2xiaHF2V3RlaG9jSkxQUnBqTlZ5NElx?=
 =?utf-8?B?UCtLd3VHendBUVR3bWFrUmVpcUdWMWhVM25acXpMa1FnaVZhR05UdU1SWERX?=
 =?utf-8?B?N2FNenkwZU1XUmFDZ3lrSmZtbFRvTmdJazRiWG9hSDZIT2NMR2NCVlBVMDZh?=
 =?utf-8?B?cXpHZnI3VlZsSHErVzVOWVhaT3R1aW4vV21CbXlhYWVEdFJiWTQzYlRHSmIz?=
 =?utf-8?B?L1lrNDBYWFVqREtYYjRwTE51WFBqdU9IeHJpNDZjcTBsd20ra3Jsb0ZIUUdT?=
 =?utf-8?B?ai9MeUIxUzJjK0FoL1Z5by9MMnN3T1hqVXJ6a0Roc0ZvWGtmNitIc2pDODJm?=
 =?utf-8?B?elZoTk5keHFHSkZTMlppb1pkbHJUTWF6dmxPRGEya3YxbVpIRitCVHZzSzk2?=
 =?utf-8?B?Z2VVWGlXWi9PaEZYYkhVVHhwSXAzVkkxcmk5RDBWcUNQeGk1alZScHEvUEhm?=
 =?utf-8?B?TjNoTG5OUlhKN29BRy9YYjEyY3g2eGFubHU0UVdibGVFckZvT3BDZUpSRm1S?=
 =?utf-8?B?TnZuZXJINHNJM21Pd1A1M2toZDlqS3dWZG1iQm5EZWFLSzM0T0JLMC8wNzRF?=
 =?utf-8?B?ZnJ0SGdVWmhLa24wODF1cGx3bWFFSlJNZHl0QlE0YjBFeWlGQXRZZjhLV2tE?=
 =?utf-8?B?Vk5EaHA1d3FyWVBOWDhBSVYxOTNjcUtSdWh0ZkNDTjlBUHByWTNlak1NQjBG?=
 =?utf-8?B?U1dmOU5maHlsaGp0ZzhwUzl5ZjZiWXF6VVQ0MjJPbTNRWCt1V2doVFFEUHBM?=
 =?utf-8?B?a1pmbHV0U0ZBMFk5QTFWVHU4TlRYbmRZK2ZXSE1tcXJGSWRxaWNLNk5nUDR4?=
 =?utf-8?B?MXY4UFZpTHJMNlEzeGlwakh2dFJPa2NzdHJrRkNtOWRFZENwTk9pM2F0em5T?=
 =?utf-8?B?SDltUUY1UFpWQnRPQW5ETzEzN0hKclRKVU5vQXY3L245MHh0U2tUNVJ3UjVs?=
 =?utf-8?B?ZkFxTnk3ZkRtR1NCRFRSU1d4aklwYmJqWmxLUTJnSHVMTnhnUFc3VW9sRmRa?=
 =?utf-8?B?N2k0dnA0QmhQYllzeGgyb0dFaE91NDlmaWlRVGZRRmhtdGtpUW9vaWdhdytD?=
 =?utf-8?B?bDdmL3BOckpiWXJXTUdyeitjdGpNQm1Zck52eldrN2pyekNwc3AwaVh1YWpR?=
 =?utf-8?B?QXljK2FQSzNLM0FKeS9Ea3VBaUtvdWNYaFJGY1BLTWxUYTNkR0J4c2h1UmxK?=
 =?utf-8?B?dmgrVUdvZ1JqNlU3L21qeTdEck5BNmpTaFYzZ0NnUVlhNXB2SUdabmtKYjlk?=
 =?utf-8?B?ZG14SzVWQ3lrMGtFNnVTS1JLYTRWSjB3eHQrOWNYUyt1MXpYOWYrYlhwUVFC?=
 =?utf-8?B?RVNKaHV0V2tCYVNvUkRGQ09HQXdRSWdOMTBUbDJXL0lwTytXY2FFU3dCaGVL?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5607C8F2A60F04AB323A120FF51F483@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AY+zuVUxI+fv7M9DWo7c7COE6RCl84JB0TQQjXfZ5TFq/Cz0lHaHtlWIm4V+Qk86Rxkvj6zezqR6ibx8Ecd9geaxzuUiiNll/p+l9U+D/V+5g57xzADErhYbUCyYQ4x6+nFcqTCiHnKYj5G1+J8FBkUy1J7ObUKAB5/isdiDo1uiUcgBJnVUMQd+J2pOEhXMEzd0u+RwVtmPOTfnaj5s0jCmNe4tHP0cLiWtgERcGAM/H+H85adpnV4t7h9F+ISjfiNk3gZZ6R18sKunye/IHERhb5a8JzKkNmSZ2ddE8XjmBbjk2Eh9nb5GfJmnPpVItta/k+3VI0BavRSRg4KPiDXexnNRNPhhtrelQiDAzWvqKzB39twksXOn8ZYHP9te77LaXrQSL6by8vxx3tKRWARKl1nM2Stq5T1/ncEw90LLe72uKTJWiCinVWkBh3G3zrlluvgFqr2cA/+Z/7NHjKGHPiuZATfplCNRrgzF7pFrHGCRyrews4wCoPjoqTaOiZc9DKaked7IOrSfi2h3sxJSu6ijM5ov6JJge/+9T7HCVRKfhGt1y1vPw072GFjC700P9SKpLadwV+WkMgnucyhy8ZcmTG80lUnZOP2Otig=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7bb0c0-c7b7-4d10-562a-08dc73709b33
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 17:17:45.6873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lwnaDRgyUEQ+kZSqXlrlRiMwSgC2Ovd4EU9Hh3+fmN5Pp4EPHCPUAQUwrHmDp/EtP7B/F3oxlk1z6bfxxmYzAy74EvAVfLl314+ErELisJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-13_12,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405130113
X-Proofpoint-GUID: 1dOGSArpDgDcBTMEe4NkkE2kEafPUHG8
X-Proofpoint-ORIG-GUID: 1dOGSArpDgDcBTMEe4NkkE2kEafPUHG8

VGhhbmtzIERhdmUgZm9yIHJlcGx5aW5nLiBJIHdpbGwgdGhpbmsgYWJvdXQgaXQuDQoNCldlbmdh
bmcNCg0KPiBPbiBNYXkgMTAsIDIwMjQsIGF0IDY6NTbigK9QTSwgRGF2ZSBDaGlubmVyIDxkYXZp
ZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgTWF5IDA4LCAyMDI0IGF0IDEw
OjAzOjQzQU0gLTA3MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+IEhpIERhdmUsIHRoaXMgaXMg
bW9yZSBhIHF1ZXN0aW9uIHRoYW4gYSBwYXRjaC4NCj4+IA0KPj4gV2UgYXJlIGN1cnJlbnQgZGlz
YWxsb3dpbmcgdGhlIGNoYW5nZSBvZiBleHRzaXplIG9uIGZpbGVzL2RpcnMgaWYgdGhlIGZpbGUv
ZGlyDQo+PiBoYXZlIGJsb2NrcyBhbGxvY2F0ZWQuIFRoYXQncyBub3QgdGhhdCBmcmllbmRseSB0
byB1c2Vycy4gU2F5IHNvbWVob3cgdGhlDQo+PiBleHRzaXplIHdhcyBzZXQgdmVyeSBodWdlICgx
R2lCKSwgaW4gdGhlIGZvbGxvd2luZyBjYXNlcywgaXQncyBub3QgdGhhdA0KPiANCj4gVGhlIGZp
cnN0IHByb2JsZW0gaXMgZW5zdXJpbmcgdGhhdCAic2F5IHNvbWVob3cgZXh0c2l6ZSB3YXMgc2V0
IHZlcnkNCj4gaHVnZSIgZG9lc24ndCBoYXBwZW4gaW4gdGhlIGZpcnN0IHBsYWNlLiBUaGVuIGFs
bCB0aGUgb3RoZXIgcHJvYmxlbXMNCj4ganVzdCBkb24ndCBoYXBwZW4uDQo+IA0KPj4gY29udmVu
aWVudDoNCj4+IGNhc2UgMTogdGhlIGZpbGUgbm93IGV4dGVuZHMgdmVyeSBsaXR0bGUuIC0tIDFH
aUIgZXh0c2l6ZSBsZWFkcyBhIHdhc3RlIG9mDQo+PiAgICAgICAgYWxtb3N0IDFHaUIuDQo+PiBj
YXNlIDI6IHdoZW4gQ29XIGhhcHBlbnMsIDFHaUIgaXMgcHJlYWxsb2NhdGVkLiAxR2lCIGlzIG5v
dyB0b28gYmlnIGZvciB0aGUNCj4+ICAgICAgICBJTyBwYXR0ZXJuLCBzbyB0aGUgaHVnZSBwcmVh
bGxvY3RpbmcgYW5kIHRoZW4gcmVjbGFpbWluZyBpcyBub3QgbmVjZXNzYXJ5DQo+PiAgICAgICAg
YW5kIHRoYXQgY29zdCBleHRyYSB0aW1lIGVzcGVjaWFsbHkgd2hlbiB0aGUgc3lzdGVtIGlmIGZy
YWdtZW50ZWQuDQo+PiANCj4+IEluIGFib3ZlIGNhc2VzLCBjaGFuZ2luZyBleHRzaXplIHNtYWxs
ZXIgaXMgbmVlZGVkLg0KPj4gDQo+PiBJbiB0aGVvcnksIHRoZSBleHRoaW50IGlzIGEgaGludCBm
b3IgZnV0dXJlIGFsbG9jYXRpb24sDQo+IA0KPiBJdCdzIG5vdCB0aGF0IHNpbXBsZSBiZWNhdXNl
IGZ1dHVyZSBhbGxvY2F0aW9uIGlzIGluZmx1ZW5jZWQgYnkgcGFzdA0KPiBhbGxvY2F0aW9uLiBl
LmcuIFdoYXQgaGFwcGVucyBpZiB0aGUgbmV3IGV4dGVudCBzaXplIGhpbnQgaXMgbm90DQo+IGFs
aWduZWQgd2l0aCB0aGUgb2xkIG9uZSBhbmQgd2Ugbm93IGhhdmUgdHdvIGRpZmZlcmVudCBleHRl
bnQNCj4gYWxpZ25tZW50cyBpbiB0aGUgZmlsZT8NCj4gDQo+IFdoYXQgaGFwcGVucyBpZiBhbiBh
ZG1pbiBzZWVzIHRoaXMgd2hlbiB0cnlpbmcgdG8gdHJpYWdlIHNvbWUNCj4gb3RoZXIgcHJvYmxl
bSBhbmQgZG9lc24ndCBrbm93IHRoYXQgdGhlIGV4dGVudCBzaXplIGhpbnQgaGFzIGJlZW4NCj4g
Y2hhbmdlZD8gVGhleSdsbCB0aGluayB0aGVyZSBpcyBhIGJ1ZyBpbiB0aGUgZmlsZXN5c3RlbSBh
bGxvY2F0b3INCj4gYW5kIHJlcG9ydCBpdC4NCj4gDQo+IFdoYXQgZG8gd2UgZG8gd2l0aCB0aGF0
IHJlcG9ydCBub3c/IERvIHdlIHdhc3RlIGhvdXJzIHRyeWluZyB0bw0KPiByZXByb2R1Y2UgaXQg
YW5kIGZhaWwsIG1heWJlIG5ldmVyIGxlYXJuaW5nIHRoYXQgdGhlIGFuIGV4dGVudA0KPiBzaXpl
IGhpbnQgY2hhbmdlIGNhdXNlZCB0aGUgaXNzdWU/IGkuZS4gaG93IGRvIHdlIGRldGVybWluZSB0
aGF0IHRoZQ0KPiBpc3N1ZSBpcyBhIHJlYWwgYWxsb2NhdGlvbiBhbGlnbm1lbnQgYnVnIHZlcnN1
cyBpdCBzaW1wbHkgYmVpbmcgYQ0KPiByZXN1bHQgb2YgImFwcGxpY2F0aW9uIGRpZCBzb21ldGhp
bmcgd2hhY2t5IHdpdGggZXh0ZW50IHNpemUgaGludHMiPw0KPiANCj4gSGVuY2UgYWxsb3dpbmcg
ZXh0ZW50IHNpemUgaGludHMgdG8gY2hhbmdlIGR5bmFtaWNhbGx5IGJhc2ljYWxseQ0KPiBtYWtl
cyBpdCBpbXBvc3NpYmxlIHRvIHRydXN0IHRoYXQgdGhlIGN1cnJlbnQgZXh0ZW50IHNpemUgaGlu
dA0KPiBkZWZpbmVzIHRoZSBhbGlnbm1lbnQgZm9yIGFsbCB0aGUgZXh0ZW50cyBpbiB0aGUgZmls
ZS4gQW5kIGF0IHRoYXQNCj4gcG9pbnQsIHdlIGNvbXBsZXRlbHkgbG9zZSB0aGUgYWJpbGl0eSB0
byB0cmlhZ2UgYWxsb2NhdGlvbiBhbGlnbm1lbnQNCj4gaXNzdWVzIHdpdGhvdXQgYW4gZXhhY3Qg
cmVwcm9kdWNlciBmcm9tIHRoZSByZXBvcnRlci4uLg0KPiANCj4gTm93LCBqdXN0IGRpc2FibGlu
ZyBleHRlbnQgc2l6ZSBoaW50cyBhdm9pZHMgdGhpcyBpc3N1ZSAoaS5lLiBhbGxvdw0KPiByZXR1
cm4gdG8gemVybyBpZiBleHRlbnRzIGFscmVhZHkgZXhpc3QpIGJlY2F1c2UgdGhlcmUncyBub3cg
bm8NCj4gYWxpZ25tZW50IHJlc3RyaWN0aW9uIGF0IGFsbCBhbmQgbm9ib2R5IGlzIGdvaW5nIHRv
IGNhcmUuIEhvd2V2ZXIsDQo+IHRoaXMgY3JlYXRlcyBuZXcgaXNzdWVzLg0KPiANCj4gZS5nIGl0
IG9wZW5zIHVwIHRoZSBwb3NzaWJpbGl0eSB0aGF0IGFwcGxpY2F0aW9ucyB3aWxsIHNjYW4gZXhp
c3RpbmcNCj4gZmlsZXMgZm9yIGV4dGVudCBzaXplIGhpbnRzIHNldCBvbiB0aGVtIGFuZCBiZSBh
YmxlIHRvIC1vdmVycmlkZSB0aGUNCj4gYWRtaW4gc2V0IGFsaWdubWVudCBoaW50cy0gdXNlZCB0
byBjcmVhdGUgdGhlIGRhdGEgc2V0Lg0KPiANCj4gVGhlIGFkbWluIG1heSBoYXZlIHNldCBpbmhl
cml0YWJsZSBleHRlbnQgc2l6ZSBoaW50cyB0byBlbnN1cmUNCj4gYWxsb2NhdGlvbiBhbGlnbm1l
bnQgdG8gdW5kZXJseWluZyBzdG9yYWdlIGJlY2F1c2UgdGhlIGFwcGxpY2F0aW9ucw0KPiBkb24n
dCBrbm93IGFib3V0IG9wdGltYWwgc3RvcmFnZSBhbGlnbm1lbnRzIChlLmcuIGZvciBQTUQgYWxp
Z25tZW50DQo+IG9uIERBWCBzdG9yYWdlKS4gV2UgZG9uJ3Qgd2FudCBhcHBsaWNhdGlvbnMgdG8g
YmUgYWJsZSB0byBkaXNhYmxlDQo+IHRoZXNlIGhpbnRzIGJlY2F1c2UgdGhlIHByZWNpc2UgcmVh
c29uIHRoZXkgYXJlIHNldCBpcyB0byBvcHRpbWlzZQ0KPiBzdG9yYWdlIGFsaWdubWVudCBmb3Ig
YmV0dGVyIGFwcGxpY2F0aW9uIHBlcmZvcm1hbmNlLi4uLg0KPiANCj4gSU9XcywgdGhlcmUgYXJl
IGdvb2QgcmVhc29ucyBmb3Igbm90IGFsbG93aW5nIGV4dGVudCBzaXplIGhpbnRzIHRvDQo+IGJl
IG92ZXJycmlkZGVuIGJ5IGFwcGxpY2F0aW9ucyBqdXN0IGJ5IGNsZWFyaW5nL2NoYW5naW5nIHRo
ZSBpbm9kZQ0KPiBleHRlbnQgc2l6ZSBmaWVsZC4uLg0KPiANCj4+IEkgY2FuJ3QgY29ubmVjdCBp
dA0KPj4gdG8gdGhlIGJsb2NrcyB3aGljaCBhcmUgYWxyZWFkeSBhbGxvY2F0ZWQgdG8gdGhlIGZp
bGUvZGlyLg0KPj4gU28gdGhlIG9ubHkgcmVhc29uIHdoeSB3ZSBkaXNhbGxvdyB0aGF0IGlzIHRo
YXQgdGhlcmUgbWlnaHQgYmUgc29tZSBwcm9ibGVtcyBpZg0KPj4gd2UgYWxsb3cgaXQuICBXZWxs
LCBjYW4gd2UgZml4IHRoZSByZWFsIHByb2JsZW0ocykgcmF0aGVyIHRoYW4gZGlzYWxsb3dpbmcN
Cj4+IGV4dHNpemUgY2hhbmdpbmc/DQo+IA0KPiBUaGUgb25seSByZWxpYWJsZSB3YXkgdG8gY2hh
bmdlIGV4dGVudCBzaXplIGhpbnRzIHNvIGFsbG9jYXRpb24NCj4gYWxpZ25tZW50IGFsd2F5cyBt
YXRjaGVzIHRoZSBuZXcgZXh0ZW50IHNpemUgaGludCBpcyB0byBwaHlzaWNhbGx5DQo+IHJlYWxp
Z24gdGhlIGRhdGEgaW4gdGhlIGZpbGUgdG8gdGhlIG5ldyBleHRlbnQgc2l6ZSBoaW50LiBpLmUu
IGRvIGl0DQo+IHRocm91Z2ggeGZzX2ZzciB0byAiZGVmcmFnIiB0aGUgZmlsZSBhY2NvcmRpbmcg
dG8gdGhlIG5ldyBleHRlbnQNCj4gc2l6ZSBoaW50LiBUaGVuIHdoZW4gd2Ugc3dhcCB0aGUgb2xk
IGFuZCBuZXcgZGF0YSBleHRlbnRzLCB3ZSBhbHNvDQo+IHNldCB0aGUgbmV3IGV4dGVudCBzaXpl
IGhpbnQgdGhhdCBtYXRjaGVzIHRoZSBuZXcgZGF0YSBleHRlbnRzLg0KPiANCj4gVGhpcyBleHRl
bnQgc2l6ZSBoaW50IGNoYW5nZSBpcyB0aGVuIGVuYWJsZWQgdGhyb3VnaCBhIGNvbXBsZXRlbHkN
Cj4gZGlmZmVyZW50IGludGVyZmFjZSB3aGljaCBpcyBub3Qgb25lIGFwcGxpY2F0aW9ucyB3aWxs
IHVzZSBpbg0KPiBnZW5lcmFsIG9wZXJhdGlvbi4gSGVuY2UgaXQgYmVjb21lcyBhbiBleHBsaWNp
dCBhZG1pbiBvcGVyYXRpb24sDQo+IGVuYWJsaW5nIHVzZXJzIHRvIHJlY3RpZnkgdGhlIHJhcmUg
cHJvYmxlbXMgeW91IGRvY3VtZW50IGFib3ZlDQo+IHdpdGhvdXQgY29tcHJvbWlzaW5nIHRoZSBl
eGlzdGluZyBiZWhhdmlvdXIgb2YgZXh0ZW50IHNpemUgaGludHMgZm9yDQo+IGV2ZXJ5b25lIGVs
c2UuDQo+IA0KPiBDaGVlcnMsDQo+IA0KPiBEYXZlLg0KPiAtLSANCj4gRGF2ZSBDaGlubmVyDQo+
IGRhdmlkQGZyb21vcmJpdC5jb20NCg0K
