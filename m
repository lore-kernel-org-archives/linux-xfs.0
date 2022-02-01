Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FD8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 22:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbiBAWFL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:05:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54340 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236920AbiBAWFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 17:05:10 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211KSs9q026579;
        Tue, 1 Feb 2022 22:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ySWELj5ET03F3B5Lp4JEEnbrqimDtF+movljSHGgJl0=;
 b=o8N9yTOupj2+pTlo8VdbopbkGh20zIX23o7yuUdk26yl60bonsqB/7YPfuyGvEKi7vjl
 U0rpkgu6C3mf6szS9CwFIa+Vg1TBnPKjIVNgOqQNRhujESUiCGKr/PiVBXsXtYTntC7q
 5e2Kgexjpg1hHYwcFdcRCpzdBEcY8wE387hP5c5gd+8E1pVaFF5pMB9hAliWftVUV3Ix
 JKBl86gp4kSzkrXumqriN/Kg0OfQClut7cUGGALNU5C9UboYL/GsYg2xcYileGWp3PFS
 RCLWWDbYB+BpxC0O+0h2hHXlt6YNE+iek1+IJC88+WuBu4S1UrxBDuTThBMpVxD6uYQb tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9vccdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 22:05:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211LvOXv027527;
        Tue, 1 Feb 2022 22:05:06 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by userp3030.oracle.com with ESMTP id 3dvtq17s67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 22:05:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8bpffgJ0T+KIpGe1V71ADVWi5pD+DcywBVUDbilTtTu9D2TPPfHC1/UH9TZa/dPeU/JGHn/A7KtDDNsi/moAuOcBA9S9xGEW7fplUIrypvST1JXJbBshFJjybta/yMgpbJfgEMwGlGBWvtnDLzq21Qmc4mRHFTwXDTQQ2OU0/mIHPHTohCLROJgcif2uWfk285B5/ZKFlHaRi5IknD8AqNKulO/FvQgkpaSZjYynRNMVbQMWKT4jWE01zRfYa9hPBbuQ3tRge1EsI/hrQMXdsaWszCzvNb7Vq5vO1Xe2vjGz5qNmsMPLSlsy/7AcfgDaglnv9zoLCDS1ZZ1VdjWZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySWELj5ET03F3B5Lp4JEEnbrqimDtF+movljSHGgJl0=;
 b=aG1HXomaR6kGNjskm0Z4Rrop7TWBY+B5zsqy4ooEOsrH9W5wdjkr5IdRRYd4gmbelAc5mZD/bgGpDOmU9tGmVgLqhYoGl00bWsDyEi57ZnffqiL4PqVL9zMYf7e7u33iS3D1pQ/+c0QKv5WcvSdWuxiU2AmBIED60YdJ3BWRG2Zx/FoG/o7e+mCVHLUri56yq+7dQr+Kf3a3SpwGkOKae2TT/N3mJzKqTIR1cDZj+dCutd9QJZb6B+k3MPx7XQAeM1GV2X9kPoVyB1xzVVanR1Rao2RkBdA0tSq7Vr9MelUqsxh06JvNPelSVFK2HNjRLdwiuGFY74PUBw81sP7qJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySWELj5ET03F3B5Lp4JEEnbrqimDtF+movljSHGgJl0=;
 b=LbEyk9iPCHVKyxOlEl4+VmEfGolM1F0RZgvro3OayFECsZrwz0psP0B91EtzqthzmzI/F6pdJBaBPZeUstTm/oYhiunhcjC16wcMsjaxWdTQdvNgBmcU2iNpf7/EM9oBqOpfL1AptVVOJ+Ku3VC2DPX0sbLiJykrFyCkf3Kk3Gg=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 MWHPR10MB1423.namprd10.prod.outlook.com (2603:10b6:300:23::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Tue, 1 Feb 2022 22:05:03 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 22:05:03 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/2] xfsprogs: add error tags for log attribute
 replay test
Thread-Topic: [RFC PATCH v3 0/2] xfsprogs: add error tags for log attribute
 replay test
Thread-Index: AQHYF7fDgBoYWm3WoESuyA7a4c29Ng==
Date:   Tue, 1 Feb 2022 22:05:03 +0000
Message-ID: <C835D05B-E08E-441C-A5B2-C24FFFBB51EE@oracle.com>
References: <20220201171755.22651-1-catherine.hoang@oracle.com>
 <20220201200632.GP8313@magnolia>
In-Reply-To: <20220201200632.GP8313@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2131a85-9e45-4d39-14bc-08d9e5cee63f
x-ms-traffictypediagnostic: MWHPR10MB1423:EE_
x-microsoft-antispam-prvs: <MWHPR10MB1423939E64A1D268CCEACA0589269@MWHPR10MB1423.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prp4j7oToAd0xh20vO8vEdB/LljlTxWFyA5KJRBn4mpliMVLxYfB4U4kYWUNW2yvuOGtt68Gys0L5HShKv/Fc0ljyaPIHzqaRP8Xa49Ko2Rp8JNoMCj/rY/letKqPpM2bmnCnq6wX6/zi/mkzXvuvA1iCPSgF0CfmiAu8lC2I3QMrRY0sHRHjvsInWW04qKVmKa+/Q/NJRnNTx9t7bixFkFdID8cZKbbam1P/AmN0LLP23fts2+wv6iKspN9IVeVnp1UKdAm2/8d5PQRwNfyBqOI3y+r5YYmY/Xcz3rQuUAfv+qHBTuhIYFpH+S7P2tACOP8u5h+MYHPloOximsiQL+jATzeUxjG0+YSTESmWJkSwcnsy8vVos2YBU5b1QlNDTjH28b3sqW3plO+Vt9NuX5YgKtAuEvgbOExCChVuVu9dLnwpF4p1gEGPmruuxYFECAVIUaRNYTrQiXARL7jCri40R6OUlVosjIESMa/nBrWCzG/bDnpvKt0fvSXdQNGRmBUS9smc8vWHptdN756bwrQVesCenyGEVrWUkINb0Hk2d+zZdpd3y+JHQwemXbg8yKS/EH9m6jWDXyCjp2G8vJngxJR6mzi9DrT8LuZWKh84OmWsoN6gmDJm6AQisy2h5z42ZS+TUh56Aioak5UJOMhB5kymwoiMS3yEGZvIzVt6fCD1ZFcE/odIb+JiyFiGONbrAUQDZqQQhntF8c7i5hRlZBXqf0uCNF2pbyGSOnJMaN31pJyTaptAlEiIy1K1oFU3ohIBHgGi3YO6DIJ0ZTVWa9YQK01nxZFQaMs250B2WNpe3g2xXU7+PkanvmE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(316002)(2906002)(83380400001)(508600001)(36756003)(6916009)(53546011)(6512007)(6506007)(6486002)(5660300002)(4326008)(8676002)(966005)(8936002)(44832011)(71200400001)(86362001)(64756008)(91956017)(66556008)(76116006)(66946007)(66476007)(122000001)(38100700002)(38070700005)(33656002)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFQxSm50c0lOQ1NDOEoycG1pc3ZNTmozQ1E2ekFQTDh3NnFKSXdLM2M3TkNG?=
 =?utf-8?B?TEgzZ1FrV05PZTVBWnRNUzZnUlVmcEliYzRkRDYvVWoxV2QrUk4raG1HbHBJ?=
 =?utf-8?B?Tndlbnd4dG1XQitWUG1Db1hDV09YV3FWU1N4WGFORVhzbEtNYWs5Y1FqOGF1?=
 =?utf-8?B?YWZlRUFOOEMyK3E2bkVCZlBXaHZMRW1hNWRWM3Z0WFBwM2U2VTFVNzhzQ0dl?=
 =?utf-8?B?cGUrVkZPMnJnMFJLRmNFcW1GSzhCYTcwMHcxNmo0WVpvdXJaNEdaTXdHbUtz?=
 =?utf-8?B?TElWVDhBVjc5STZsay8rTzhEajlTS1dBQng3WnMwRTJLTVNMZzcwOUVLTUVn?=
 =?utf-8?B?RXZpa2R2czh0Skt6cHdYNUlUOHJuL0ZXU3BlNzBjeVZjTVFVdVdKQ1lEQWJV?=
 =?utf-8?B?Y1JlYWxLZ2duSGMzYWJCNVNUckRtVW1nblVRK2xKWjZwcGhsUmhuY0ZHUjNX?=
 =?utf-8?B?dENva094TDdoUTJMQ0hCZlA5MEFreUtESUdUUUdweFFCZ1BwZDFIUWdlV0Iw?=
 =?utf-8?B?UEZRTXZ4Z0tCV2h1bFB5R3dOV3pvQStmYzAwZDl6SXpDS0ZjQ2tIelQ2akJu?=
 =?utf-8?B?dklhQVk2WDlFT3QxcWFhZzNiWFUvVzFXTndmV0N6eXRkYy92YjFKSGg5ejhJ?=
 =?utf-8?B?THh1c1VJb2tyd3d4RHpDU1RtdGVoWm8xWjZCMVZGczJFT0xsZ3pMYVcvMWk1?=
 =?utf-8?B?cEwvWTNWSFcvUzVmd281bWFzRlFmME1ncjlkckhqZ2RldXNtdk1GSkIxeDJL?=
 =?utf-8?B?aFNYSjdFcjFKWkltY1M2YzZIUXJDK3VyM1pXa2VxeUNSSUl2VFBJTUh1c0Uw?=
 =?utf-8?B?aUJYQmVwMytuME11QmFCQVhIQUhmSUNNTks3ZEtTTk14L0x1bkZNMytTMlo5?=
 =?utf-8?B?UnRRVmNMbGZGbDNhaUI4SmRHWUlsa0hkQUFPWVNNa1U4a0dlK0pvc2t0NWpk?=
 =?utf-8?B?ajBQekcrTmtFWU9TNzVaTi8rclBhdEFPUmtKMWdBdEg1bXRlTDN2b2pWWkU5?=
 =?utf-8?B?dDZQRlhJNi9jTlVZd1d4di9SVXQzT1ZIODFRTmFRcml2OGplV24zVWxyR0Zw?=
 =?utf-8?B?cWxDQ3RsSGdPKyswcFBIRDVocmt5b3R2SDYzc1AzNmNhcW0rWnZhQmVxdnNO?=
 =?utf-8?B?TTFJSGJ0NllmRUQrTVNqYW1VQVRlRkNUT2dXR3Z3a1hIM0pMblBpVUdvaTgr?=
 =?utf-8?B?ZWlSMFB4YURWRHBWc3YxcE8zU1lqVzlTZ0lPakZ2TWYvSFRaM2dmcTB6OGV5?=
 =?utf-8?B?Q29WTjlNcDFVdDIzbkkrOXNCbHpjWmsyaDJYK0t4bzVPQkxRd0t5bHRsVEtu?=
 =?utf-8?B?WEQ2RGIxeWlNeXV3dUdCSlQwZGovbWtVVDVSYmdPR1dJWjBQS2Z6MjRtZ1NM?=
 =?utf-8?B?WGk5Z0dITmRWTUVQZ2ZiYTR2dDFIZkl1L0R6QURBaGthbWNtQXF0bGVvcE55?=
 =?utf-8?B?TTBPazFrelpMRHNabDYyOUhFRHkxcUdBSmthZFZSTkRqSFpjWW14QzRWd3cz?=
 =?utf-8?B?c1VFMXB4a3ZmazNaT0hlT2c4Mk4yNjl1R2NmdDlzTDFqcC9hd3QySnN0VFdR?=
 =?utf-8?B?Slc5dXpBSk9FeVdZcWpQSWx1cXhsZDlZdWFwR2tXaFVrSmhxMWNHUlRhK1h1?=
 =?utf-8?B?SEpsT0VJQ2EyeEVFQ1Zmbk81dmNGTEdQcEZYaG5aVWlxZ2dRWWxoR2FkL3gr?=
 =?utf-8?B?MWV1MXlxZnMzNEhPSkpITTZ5aVBjeDRRbUp1a1Nub0sxU2dTb0FOSHFGMTgy?=
 =?utf-8?B?YS9HdksyMXpNUjE4UTBQUGlQTnRZVURNd2ZyOG0wZUJqblZHWjZSUWVqV2dU?=
 =?utf-8?B?Qm9pS2NZQmdYbklKRmhXRlNua0c0d1lNVmZMR3A3aVA3QzdUbDljanNCeHFy?=
 =?utf-8?B?YmtTUXhLWkxIN1l4NmRzZFJyNC9uY3EwVnFYN3JiNml4bmRuV1dLQkNOTmpJ?=
 =?utf-8?B?UXA2eW1vK0pqcGpjdkd4ZitPTm13YWdDa1I4TC9LaXBrNFNGL240REhFanV3?=
 =?utf-8?B?N3I3Sm1vcTBUaFJpRTF5VHBURW04OU42TU1ENGo3dUJITFJ2L1ZBNmFLNGtw?=
 =?utf-8?B?cElzV0JxUTIrYzNtSyt4OUt5TGVFcVc5b0hmemRYeE9TNmUrZ1pQUDR3NktB?=
 =?utf-8?B?TWRmQTU4WmkwTUI0Q2NncTY4VGRpYnUwNlRYM0pSd0RuTXY0bVJjMm1lcjdQ?=
 =?utf-8?B?SkRxbi9JRytkL0dNaEVGdXYyd09uK1k1eUhvd0tBOVZhNlBiTjRtYy9KY1ZQ?=
 =?utf-8?B?eHIzeFgvT1U1VGtqWXVZVlNHUUVIajNYTDJFWDJDOGRlN0QxS0NrVTR5VDJT?=
 =?utf-8?B?cHBnRVcwdy9DN1N6WEtTRG10SWVZcVhLWG0rMFR4cVBKb21VOGtNd2VDN1Ay?=
 =?utf-8?Q?DWgYX45TCp+PfDYM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A797B66B1CEA7847BE0C56D033762919@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2131a85-9e45-4d39-14bc-08d9e5cee63f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2022 22:05:03.7772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nZ4XdsIL19lsevAQIhtR9/PQhpYQ4mUmOw866aYotn7sen8LY6yr2R7cvpZZj75yVDdi+ofStBt9JyY0Z6cQoocmaghwN1EfIE+ybBFdiU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1423
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010120
X-Proofpoint-ORIG-GUID: I4VuzV4qsooMCGRL24OopktIGtCchQH6
X-Proofpoint-GUID: I4VuzV4qsooMCGRL24OopktIGtCchQH6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBGZWIgMSwgMjAyMiwgYXQgMTI6MDYgUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBGZWIgMDEsIDIwMjIgYXQgMDU6MTc6NTNQ
TSArMDAwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gSGkgYWxsLA0KPj4gDQo+PiBUaGVz
ZSBhcmUgdGhlIGNvcnJlc3BvbmRpbmcgdXNlcnNwYWNlIGNoYW5nZXMgZm9yIHRoZSBuZXcgbG9n
IGF0dHJpYnV0ZQ0KPj4gcmVwbGF5IHRlc3QuIFRoZXNlIGFyZSBidWlsdCBvbiB0b3Agb2YgQWxs
aXNvbuKAmXMgbG9nZ2VkIGF0dHJpYnV0ZSBwYXRjaA0KPj4gc2V0cywgd2hpY2ggY2FuIGJlIHZp
ZXdlZCBoZXJlOg0KPj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vZ2l0aHVi
LmNvbS9hbGxpc29uaGVuZGVyc29uL3hmc193b3JrL3RyZWUvZGVsYXllZF9hdHRyc194ZnNwcm9n
c192MjZfZXh0ZW5kZWRfXzshIUFDV1Y1TjlNMlJWOTloUSFlMldWTklha0RvaGlaUGRQS2ktWXpT
anVrZDk3QWNMLVBBR0J0ZVh3cVRndnoybXRuMGpBRHJBUWJxLUpzN2o4QTFFJCANCj4+IA0KPj4g
VGhpcyBzZXQgYWRkcyB0aGUgbmV3IGVycm9yIHRhZ3MgZGFfbGVhZl9zcGxpdCBhbmQgbGFycF9s
ZWFmX3RvX25vZGUsDQo+PiB3aGljaCBhcmUgdXNlZCB0byBpbmplY3QgZXJyb3JzIGluIHRoZSB0
ZXN0cy4gDQo+PiANCj4+IHYyLT52MzoNCj4+IFJlbmFtZSBsYXJwX2xlYWZfc3BsaXQgdG8gZGFf
bGVhZl9zcGxpdA0KPiANCj4gV2l0aCB0aGUgWEZTX0VSUlRBR19MQVJQX0xFQUZfVE9fTk9ERSAt
PiBYRlNfRVJSVEFHX0FUVFJfTEVBRl9UT19OT0RFDQo+IGNoYW5nZSBtYWRlLCB5b3UgY2FuIGFk
ZDoNCj4gDQo+IFJldmlld2VkLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3Jn
Pg0KPiANCj4gRm9yIHRoZSB3aG9sZSBzZXJpZXMuDQo+IA0KPiAtLUQNCg0KU3VyZSwgd2lsbCBj
aGFuZ2UgdGhhdC4gVGhhbmtzIQ0KPiANCj4+IA0KPj4gU3VnZ2VzdGlvbnMgYW5kIGZlZWRiYWNr
IGFyZSBhcHByZWNpYXRlZCENCj4+IA0KPj4gQ2F0aGVyaW5lDQo+PiANCj4+IA0KPj4gQ2F0aGVy
aW5lIEhvYW5nICgyKToNCj4+ICB4ZnNwcm9nczogYWRkIGxlYWYgc3BsaXQgZXJyb3IgdGFnDQo+
PiAgeGZzcHJvZ3M6IGFkZCBsZWFmIHRvIG5vZGUgZXJyb3IgdGFnDQo+PiANCj4+IGlvL2luamVj
dC5jICAgICAgICAgICAgfCAyICsrDQo+PiBsaWJ4ZnMveGZzX2F0dHJfbGVhZi5jIHwgNSArKysr
Kw0KPj4gbGlieGZzL3hmc19kYV9idHJlZS5jICB8IDMgKysrDQo+PiBsaWJ4ZnMveGZzX2Vycm9y
dGFnLmggIHwgNiArKysrKy0NCj4+IDQgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPj4gDQo+PiAtLSANCj4+IDIuMjUuMQ0KPj4gDQoNCg==
