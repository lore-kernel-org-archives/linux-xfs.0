Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369204FF9A
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SCYz/ehM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u9BVPPlm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BIEtft9016521;
	Mon, 18 Dec 2023 16:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=f6B/Xyh1rLc+mGHbZOzIiS4BwnfpsWdkLfITDXZbLd0=;
 b=SCYz/ehMAJ37qyehSxgWetz1uh0Ct9Gs6JPDQWV4WyqF96x7ZL+4D2VUyn7v3OogdY14
 oGBoRC1g4zpJrcSJqQgYyZGJBYPQ9LmOc41Mxj1hTaF2C619q6EMQrR2hbQU9JX4TksA
 injLl0yIXHEdZf2nbanYbpcUKrcQ0OUzwUv556BZyIiDbRjTJ5YZgC60Nfk7HILWJlv5
 LixgnVUTu0MaMpKqnbbIr5CgJJN95V08E316dYimVvy7crRT/3Funqql5tTzQegLiQIx
 qZPKVTfd5lYdit6RwLKAWNMgfgH9FX+qBnIlOppnOK+TMMlhAKmXJE2L4m0Uoozaw1XK +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12p43ryq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Dec 2023 16:27:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BIFoq2W020042;
	Mon, 18 Dec 2023 16:27:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3v12bbjpb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Dec 2023 16:27:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P96KZLvtyTetHk80UmLrKC/D/0fucf9ZsB/8vXzJxrOWR29/Mk30FO7s6fXlEM1ik11pKTe7DncIxOd0t4hGrRS3gfs5KtJfeoLKWdXG9jZoIInXTDWRR4Of9udZ+4G/tfZVFSdAoKpBTvEI9q8kz/gA6VayhztqL10hGmtGBKthWaOGo5zQVM+XmQ6kqeed5zRWh4OvIIVEuSCY4OPTAnmBruNTIkxEMCb7P2NqAxNfmtit+X36XDlzXbe2M1kuACkiPZf4nX5KB08rSpz9miQ/XIzMeW04gP9T97kDKg13ghV+sKtZJUEsrvGRoCs5t+n7hmr7juFXrQRtVgTgCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6B/Xyh1rLc+mGHbZOzIiS4BwnfpsWdkLfITDXZbLd0=;
 b=Hasa49oAKL0Z/2bvvyVGDQksJM4wAwG/FBZyZens7QS8n7rVqRNmF6m2YdINYzrlOXd1xt3UaA43zYVMhJE8gzifFcnHEhzKf3VuQ2zZBCndn+on/8/QyohyrO5yNM1ZsAXGczcjXga9gB+aFbjgw1THSvhp1j70OuoOs3wHeTiJjEUX1I8P4JvQRSP4Nr6VIveyTdZbNDXPCyayUWyCl5ywiRnBbZ7HP/qJex6B7AUcjWj3YefUTsSzDAj4mDkNpnCYdp0LvCFgTaFoQ2z0JNWcnrGuPzjyobC8I9IlA8UIyAGDeJyuFC0I8B5C12PedCFmxEf07eJbUdWUUc2fIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6B/Xyh1rLc+mGHbZOzIiS4BwnfpsWdkLfITDXZbLd0=;
 b=u9BVPPlm/lQeqE3T/OU3ZXsEd2ob+uewBAMQwn+3vtxf6eF5dvgCbj4WmnBI46A+AdQNSzS6SoC+9LMMBfa4rx7DfwRGaZOKLIPfDvaWmVXecrzfk6kVhgrY5gTq/BMvsjolBE+GLIGlydOKNe2fR+Zhen1zGi9vF7Y8CKaF+3g=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Mon, 18 Dec
 2023 16:27:19 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.034; Mon, 18 Dec 2023
 16:27:19 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABe/wCAAOiSAIAANdGAgAR17IA=
Date: Mon, 18 Dec 2023 16:27:19 +0000
Message-ID: <D074B518-2C9E-4312-AC31-866AABE1A668@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
 <ZXy08z140/XsCijh@dread.disaster.area>
In-Reply-To: <ZXy08z140/XsCijh@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|PH0PR10MB4776:EE_
x-ms-office365-filtering-correlation-id: a4216d1a-6d8a-4766-718d-08dbffe634ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 IDuUADwIFeeVIoQIGabZdWtFD2AvzLdlWD3nxozP9nWrll48z+OtWZiNZa3lnBhgRj2CsUdP6GFLP2MvROd0jiuvHpqg11Fvl4x6GB7n0acgXT4m/f8XASiEjchJgE9XBDrAUIlxFHdcbucFk/a7rARqftdebgoCK8S3ODE8Zr0n883kGlbkaqYzUwJ3oSYsd+yT5lAKhNMJfLNBsyNUzsxxItVIX04RUryzqb3Ubq2ljNtRFGTHjOCBpNjXAQhGYm37etVblP4setHWVpTyRNH926wZ2e81Bgr20roA1lJICoUR3EIC6lAHjuPpzvnPKSWGsm9yzJgbNyHNmQPKWr+s8rDWfKvpNN+PzMtRC7o/F57cNq1IhLAOoPDt8nVmtfLqhumnduIJ6dQL2NupnMZASQU5CtQ+L9o3r8eVDYoLeshPW1t0LYTiOQM+OBt+Lrc++8FiuRecc4jP9dRITIQmQZOzUu9sxXikqXQY3lNurRqLIrNT2n1TjpczPyaxbAS84ibn3jD6FKdaxXthwBSUI8zH02sHLcdmmp2F3v9e1aaF/1+PDTcVJYIgaF2xbKAVGHwGUaatusm5IjtCH31ui1/HgIg1uQfpA0QE3h+rLssZOkG419cIO1iSXyzuEBiwI0dAI00pvQ8Nd8AZDA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(26005)(83380400001)(6506007)(53546011)(2616005)(6512007)(4326008)(5660300002)(41300700001)(2906002)(478600001)(71200400001)(6486002)(316002)(54906003)(8936002)(8676002)(91956017)(66446008)(66946007)(66556008)(66476007)(6916009)(76116006)(64756008)(36756003)(33656002)(86362001)(122000001)(38100700002)(38070700009)(66899024)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?VG81eVBlbWhoMmowUmNWd3RRdThwQkdnYkVQYkg2T20wa05NRmlkRi9UY3Rl?=
 =?utf-8?B?R0Z6QmZkeU02QmVyWG5FQ3FKdmJTYnpoVHJyTlZnV29RUTFHb2Zna1gvRnln?=
 =?utf-8?B?NnZsWE5rU09SbEZYaUM0d3JRd3JsRlNxVWkzeVdNM1lhejBWZS85cmg5MXdE?=
 =?utf-8?B?ek4xcDU0RzBtN0c3eldFVkx0V003cno0NUhQTk90Z2JrTENpOWxGTXROMmdy?=
 =?utf-8?B?NEJCTDdvOXduTklHeFlCeWVVNjRaT1JaeU1nSXFsRGpsOHMyS3d0Q3RndTJK?=
 =?utf-8?B?OGt6em1Ybm4xOHU2MGg3Nm9SVGxtTFB1b3MxZlhCL1Y2VEUrSDJwRWxLQWQy?=
 =?utf-8?B?b2ZZdUcweGlaQ2hGNUlOV01XWitGamlybTlpSmRXR2ZtM3dMTE1zZ3pOS1k0?=
 =?utf-8?B?bzFsZUo4V2ZCNGVUdjhNc1JZd25BeXlFeHkxbWk1SU9OM3JBeWsxcDJlZUta?=
 =?utf-8?B?TjEybnBqRlc2RS8wd3ZUQUdKdWg5MnVtcVBHMDcvNGlMQkpJengzRFdQYSto?=
 =?utf-8?B?a0VraktwNmd6a3R4M0NhYk5iRTFWUG5NRHpHWS9DNXg2YzhZeEIxWTVPanFs?=
 =?utf-8?B?eHd3SlJyZWNXYmM0NElkTkoybmhxWUo0SE1sZ1BON3liLzJwRXlRZTRObHNn?=
 =?utf-8?B?emdDNmJPTnJ6WngxajJvYytBT2gxWG9nMmxQVjRjMlQxbW1rWldwS0ROQjZU?=
 =?utf-8?B?a1JoZjlmYTk1Q2ErcENBRzkxV1ptNUp4Z0JsYXpRUEZSZkx3bTJEY1NacDZC?=
 =?utf-8?B?bmNza2U5QW9ldFdsUmZwRkRXVVFBZTdtN0JkYXBza091Z3drTTlzQkdsd1BM?=
 =?utf-8?B?OE96UkhqNG42T3Qyakw0VnRrWWhycFgyWmVjbTdnUTdPWGk1ZFE2aUF6bVZK?=
 =?utf-8?B?RktSdEowSHhHSVo0ZnFJVWxiMmc1Zldyc0FlYVdPejZybVV1bWZ0aVVUMFlZ?=
 =?utf-8?B?aFo3ZDRzdGZjYkVZNFBxaW9NbGJuc1dxaXlTU1U0RGdzcklXT2NXQlNVNFBv?=
 =?utf-8?B?SldLdXJCUHZQYkJjOWw2S3JkT1poWTFRRS9JbmdtVzBvK1RXb1NrS2hrR04z?=
 =?utf-8?B?NTdYUVNIcGxvWWN0NyszWnVPSFphL0kzRDVRS2JaTjdObEdRMlk1ZGtHNjY3?=
 =?utf-8?B?cnk1Z0E1U0t5amZwaU03RE01U1RycTdIeGdrUkdEVGQ1S25OTS9tZDNEbzRE?=
 =?utf-8?B?YWJ6ZXgzMGVaVkljcnpocUlSV0VwaURrdmpVYncyd1NpTjBGSXhhTFRna3RB?=
 =?utf-8?B?ZTAvMGNkWHAwRXR2U2JsaFFaSHFORmhSVi9TbE1QOURzZ1BEUGJEZVg0UjYz?=
 =?utf-8?B?THpERE50RFJXdGk1b25ZVjE2bXg4YnJ0MVVYMUlvMEh0NUlRY0hFbnZHdkgx?=
 =?utf-8?B?VTcrMVI0azVtbU5qTDhsSWRyQ1RUeFg5QmNrZ2NhaVhrNVNXSndZc3p6U28r?=
 =?utf-8?B?MVIrbVdiSGtCbVJ0d1R1YWNZeDMycEpRRTg5NFJXRVFBejM2WWpra3A1SFN3?=
 =?utf-8?B?OWJIRW1DSHJKMis2V243b3JvL242Z2d5c2tSNGFXOGlidGVaamY5ZzhvZHRj?=
 =?utf-8?B?OGlHY3RvdysyMjBuZldqM1pNTG9paDRGMVRIUjN6a216UlNVMEhwZGZkNHRK?=
 =?utf-8?B?alF4MUE5dU95UmVXYjdpNnFESFVJOXZvUG5CMkxNekxlS1VZazhyWTRRVFhN?=
 =?utf-8?B?R0lwVy8wTWlEVGpPZ3NuU05oYkZwOHQwckllMXZQWURIYU5lckVuZDljWFlQ?=
 =?utf-8?B?VXVoRHlSM3puTU5pa0svckZxakVZTHA5WDJSVTNQOFUxWjJWb0U3ZW1DU2hp?=
 =?utf-8?B?QzhBd3ZZY3BlZitma1FlWUR3ZmlrOTRaVlVxL2Q5ZXJRQUFPQlhLemZ2WTdn?=
 =?utf-8?B?czRNRnBzU0hLREd2bDhMK210dVF5UndkeS9aUWdRck0yN3dqQmlBem5aUE9K?=
 =?utf-8?B?QjcrcjZocGZoNnpBU01CN3B0b3pNRjhVY2g0MkhGUEN4dmpXckFDVjlVYllS?=
 =?utf-8?B?VGw1aTFwWDI3NHM3MkRCQXlsSis5Vmc0TVVuTXl5cHd2N25ETkpVQTFaSThm?=
 =?utf-8?B?TmFsaCtQa0g3VFJTSFdWSVJ4UUk0bnlFRjMyTE1mRGpuWEp3TUZNNEtkQklZ?=
 =?utf-8?B?aGFETlovVUliL1RrU09hUTg1aFJNbWpiWG1sYW5XWjMrM0V5TnNVY09Dd1M5?=
 =?utf-8?B?eHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <734137026E61BB4ABD1D5741BCAFC1D7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	qtHlmnCxl996xFTnAEsazdLZ7GtK47kdNXAkZGhPItpHoVCAZPzpVWjzmzP/tgMxn4PZvI++yK2pOPgaTnOO8c3UU3MVyrSlLpoIuMoxpR3U/vtuJNAwPRt6E55lihtEAGh0RAq/jdsLYZQIAQ64qeD2SMGDGOsY2rGrMN72HDziw9FXrrz/puTz6u3Rgxufxu0lU+PaBvLKiPj/qmkANjzu2h3gQMfoPJV/U4NjdUx/fKsLDz8H29KwFRntNeS36ATFtNyiCDzyH/IPElghw6d8mZLpl+8qMnmWeZQjcb9xa2rHZAoevfUHwpUNetkaIafbUv3Bz5PujHFSsE7uP3SwxE0nU63xXO7uFfDbOQZ7t5pqV0CC1K7/QdpeyPH3y5KC0xLmRnlqen9zqF6BFcADoWMR6PN3Up/Ox952gdbWFT/XaqwjH6itxM6H7ixem87UXcfOGjP8hsnHOCDfxMI4vQYEQ4zuuouNV5ZvvzGrpD2QU/EbEchSEYfEEku5UcRGi2v+C8RP062i7KiW1fNRbHkaYeQfFMRORiyn6gg/P4fSr/3XaYrT0SAiaxI9X8V6fMDM2ttqKbRTHQlUt4t9pqbvpa8co8QGpP/IaRo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4216d1a-6d8a-4766-718d-08dbffe634ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2023 16:27:19.8435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpglP9YAJgOtHHwE6PovI+wcOk4FS9MynUZukDAuo3Kli1tzhtZtNnm2tPYWsDyPPsAHU/Q0Olh97mpyQTXCD5tspnCRuQtxtxAeVzbsr2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-18_11,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312180120
X-Proofpoint-GUID: PzQia8zTqoQ2dRnmzHzC_Z5OWsHMJJ7L
X-Proofpoint-ORIG-GUID: PzQia8zTqoQ2dRnmzHzC_Z5OWsHMJJ7L

DQoNCj4gT24gRGVjIDE1LCAyMDIzLCBhdCAxMjoyMOKAr1BNLCBEYXZlIENoaW5uZXIgPGRhdmlk
QGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBEZWMgMTUsIDIwMjMgYXQgMDU6
MDc6MzZQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+IE9uIERlYyAxNCwgMjAyMywg
YXQgNzoxNeKAr1BNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0K
Pj4+IElmIHdlIHdlcmUgdG8gaW1wbGVtZW50IHRoaXMgYXMsIHNheSwgYW5kIHhmc19zcGFjZW1h
biBvcGVyYXRpb24NCj4+PiB0aGVuIGFsbCB0aGUgdXNlciBjb250cm9sbGVkIHBvbGljeSBiaXRz
IChsaWtlIGludGVyIGNodW5rIGRlbGF5cywNCj4+PiBjaHVuayBzaXplcywgZXRjKSB0aGVuIGp1
c3QgYmVjb21lcyBjb21tYW5kIGxpbmUgcGFyYW1ldGVycyBmb3IgdGhlDQo+Pj4gZGVmcmFnIGNv
bW1hbmQuLi4NCj4+IA0KPj4gDQo+PiBIYSwgdGhlIGlkZWEgZnJvbSB1c2VyIHNwYWNlIGlzIHZl
cnkgaW50ZXJlc3RpbmchDQo+PiBTbyBmYXIgSSBoYXZlIHRoZSBmb2xsb3dpbmcgdGhvdWdodHM6
DQo+PiAxKS4gSWYgdGhlIEZJQ0xPTkVSQU5HRS9GQUxMT0NfRkxfVU5TSEFSRV9SQU5HRS9GQUxM
T0NfRkxfUFVOQ0ggd29ya3Mgb24gYSBGUyB3aXRob3V0IHJlZmxpbmsNCj4+ICAgICBlbmFibGVk
Lg0KPiANCj4gUGVyc29uYWxseSwgSSBkb24ndCBjYXJlIGlmIHJlZmxpbmsgaXMgbm90IGVuYWJs
ZWQuIEl0J3MgdGhlIGRlZmF1bHQNCj4gZm9yIG5ldyBmaWxlc3lzdGVtcywgYW5kIGl0J3MgY29z
dCBmcmVlIGZvciBhbnlvbmUgd2hvIGlzIG5vdA0KPiB1c2luZyByZWZsaW5rIHNvIHRoZXJlIGlz
IG5vIHJlYXNvbiBmb3IgYW55b25lIHRvIHR1cm4gaXQgb2ZmLg0KPiANCj4gV2hhdCBJJ20gc2F5
aW5nIGlzICJkb24ndCBjb21wcm9taXNlIHRoZSBkZXNpZ24gb2YgdGhlIGZ1bmN0aW9uYWxpdHkN
Cj4gcmVxdWlyZWQganVzdCBiZWNhdXNlIHNvbWVvbmUgbWlnaHQgY2hvb3NlIHRvIGRpc2FibGUg
dGhhdA0KPiBmdW5jdGlvbmFsaXR5Ii4NCj4gDQo+PiAyKS4gV2hhdCBpZiB0aGVyZSBpcyBhIGJp
ZyBob2xlIGluIHRoZSBmaWxlIHRvIGJlIGRlZnJhZ21lbnRlZD8gV2lsbCBpdCBjYXVzZSBibG9j
ayBhbGxvY2F0aW9uIGFuZCB3cml0aW5nIGJsb2NrcyB3aXRoDQo+PiAgICB6ZXJvZXMuDQo+IA0K
PiBVbnNoYXJlIHNraXBzIGhvbGVzLg0KPiANCj4+IDMpLiBJbiBjYXNlIGEgYmlnIHJhbmdlIG9m
IHRoZSBmaWxlIGlzIGdvb2QgKG5vdCBtdWNoIGZyYWdtZW50ZWQpLCB0aGUg4oCYZGVmcmFn4oCZ
IG9uIHRoYXQgcmFuZ2UgaXMgbm90IG5lY2Vzc2FyeS4NCj4gDQo+IHhmc19mc3IgYWxyZWFkeSBk
ZWFscyB3aXRoIHRoaXMgLSBpdCB1c2VzIFhGU19JT0NfR0VUQk1BUFggdG8gc2Nhbg0KPiB0aGUg
ZXh0ZW50IGxpc3QgdG8gZGV0ZXJtaW5lIHdoYXQgdG8gZGVmcmFnLCB0byByZXBsaWNhdGUgdW53
cml0dGVuDQo+IHJlZ2lvbnMgYW5kIHRvIHNraXAgaG9sZXMuIEhhdmluZyB0byBzY2FuIHRoZSBl
eHRlbnQgbGlzdCBpcyBraW5kYQ0KPiBleHBlY3RlZCBmb3IgYSBkZWZyYWcgdXRpbGl0eQ0KPiAN
Cj4+IDQpLiBUaGUgdXNlIHNwYWNlIGRlZnJhZyBjYW7igJl0IHVzZSBhIHRyeS1sb2NrIG1vZGUg
dG8gbWFrZSBJTyByZXF1ZXN0cyBoYXZlIHByaW9yaXRpZXMuIEkgYW0gbm90IHN1cmUgaWYgdGhp
cyBpcyB2ZXJ5IGltcG9ydGFudC4NCj4gDQo+IEFzIGxvbmcgYXMgdGhlIGluZGl2aWR1YWwgb3Bl
cmF0aW9ucyBhcmVuJ3QgaG9sZGluZyBsb2NrcyBmb3IgYSBsb25nDQo+IHRpbWUsIEkgZG91YnQg
aXQgbWF0dGVycy4gQW5kIHlvdSBjYW4gdXNlIGlvbmljZSB0byBtYWtlIHN1cmUgdGhlIElPDQo+
IGJlaW5nIGlzc3VlZCBoYXMgYmFja2dyb3VuZCBwcmlvcml0eSBpbiB0aGUgYmxvY2sgc2NoZWR1
bGVyLi4uDQo+IA0KDQpZZXMsIHRoYW5rcyBmb3IgdGhlIGFuc3dlcnMuDQpJIHdpbGwgdHJ5IGl0
IG91dC4NCg0KVGhhbmtzLA0KV2VuZ2FuZw0KPiANCg0K
