Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F073548CF2
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 20:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dk7hsqFv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P9yCeaq0"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFI4ApQ023110;
	Fri, 15 Dec 2023 20:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iviK2KPkXGSvhuco+4nJ1YmXGziIjGkD/dyA8Mi2WqA=;
 b=dk7hsqFvnZbxgSWBHr0e0xPMUqMn0uy1QRLkbX+yDk8mb0xKEWr4n3GVHwfyKleRsSyG
 jQmdYkLpNBkXL9XAKr2XKqNoBqJy0qdxUqI7TqjJKKGvlQ1RVBN5Cdf+wmTeT9AKsojJ
 WtvCmcWPH6e78AX3DRrShDhqSGs5t3dAJvVGKuqHUWhhIdIcKTY5vOgOT1pQhAvxyWuA
 cqxzBH9YRW4OTjHWLv+TUWHMC1JX01CXHVATkd6cqJcF1Xv0J0D8APVzPvBfahaSFLHS
 6rTZLd8+J3cY0FJl75EgHJs2/YlmXGW7Qt5eT6WGgpvHbN1PyYAL/H8U7FWXQokLia2e oA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3vb37-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 20:03:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFIDX0m028292;
	Fri, 15 Dec 2023 20:03:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepjmhgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 20:03:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDAJIn7hVO9+731sd560sYHTApy87Nv4uJB0yQt+GqMdIgBeBgnOj5J6Wu3MmGorORcKCNUzBLMwjlV4XJN9C9NVvlq8wWkAXIdC4UsM4BcL/pzWXdJxxd6OYp5hNcYTuplBMjC7wtuRzKFqTXuNJQd9Do7vVDEc7thpUqH6kjkbEPssX+U1flUYg5NTw6NV8qqmr2x4Hba9iPurJRbPme/2Nai6xfeMl/TAxS4eWkHGMTMhz8SYSs8NrZkv6l+ktthpFiYXaOb9Tn/w7HeAbDVfYBoWt4L2dHrQtz4N4hdRo3w+WPg3H1XZgC/bZ2NS6YZzDU7xOcDxlLIa2HfGdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iviK2KPkXGSvhuco+4nJ1YmXGziIjGkD/dyA8Mi2WqA=;
 b=TUStJhUkeyJWeZZoopxKBMThBQxksKSEcG+UYdIbXXMhtBiqmW/xkZIJCYYn5mTGpC38WLVaASglrixoSvahaLzsgguV7FjjSyzksMi0cCQCoKr9Bzt4TkQUJ7y4Cx1uPbNG+0p6aZYOOypAKkmH8E9d/GfGiLnJaqIsL54HKkxiZOp+rIR7wKG9s8GOXXdmlG88WT9NbK8SmIPhYjpLEDx+t8YZWt1tCtgbKq4BHMhOt/D+EYoEB+Oqdc8aOvCs2bXqhTD3SmI0H50A1ikeCGA34lD/BUpEFU7IcvpftC7glz3jrm5J1TNc90457vmxQgcrJWYWtFjMKWahahIgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iviK2KPkXGSvhuco+4nJ1YmXGziIjGkD/dyA8Mi2WqA=;
 b=P9yCeaq0CmInxPdpM2HICmyzX7+Z5YBLeswdJlUnXq9yI9eqO2WIsrrT5lIIJaPMFvXb2XUOhxR/V4rEWzyT6SAhF16KV2Cce40UPKopl0coND83VUBatChu2O0yoKkvtzvSbFiqqftHBJ8BJpZEWoXM8Oy5rTIaInLf7NR2ffc=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS0PR10MB7221.namprd10.prod.outlook.com (2603:10b6:8:f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31; Fri, 15 Dec
 2023 20:03:03 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 20:03:03 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABe/wCAAOiSAIAABmWAgAAqnoA=
Date: Fri, 15 Dec 2023 20:03:03 +0000
Message-ID: <CF1587E6-E766-4E5C-85C7-3446A540B0E9@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
 <20231215173019.GO361584@frogsfrogsfrogs>
In-Reply-To: <20231215173019.GO361584@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS0PR10MB7221:EE_
x-ms-office365-filtering-correlation-id: 31a39629-38e1-4e5d-8237-08dbfda8d885
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 ZYoaIX3Y33PIsF/ntVk9zlLhdudfq8zc2UMk3jxOZCyo87xEQW6ZRlXgdhioKyG0dJtqGa8sMFGSg6jmv5oAo1BSz3KFGOkBKzi0X8FFyKAJtg3T3bD/CYb7hrIa0LoO5POCGMlFGEvZL8y0KdyQ1WJTBS//Y/uI+o9HOgP4IfydgEg8XzSCdzCCMv76JvgBIY0C1AmKKVX3YWjfDbUZjcLLTZmp/2JQ+BJlnQc6m5bWEjDJu/3Vay2NTuonpugmKaUaG34sDrFWlK4Xkbx3hW1LEG7Fb8HCPgxqrWbT6n8NYc6r6M+UPkFpujierEsqpiRPE3LBhhS6w1l/B43HX5+xVns5PZcld94nuOEPY3FXu+LuePnepi9vlKB/K9TY52OJaltbi1oT8Tpt5370gsFFUnAtutGOo/FrSnxFqRiLJUhsZmji9aTqbEVj5GbfNt2erYQPLv5Fd/BQ7ed7Btj1a8RBiBiBIZTQTwAR2EEh/VO8p8/QSyYam3XWbwwMZf71NsS8uai19T1PrWK1Hbf3ctldXcsH3FZ29E47KQD3PYjf+i52CGQi8o3n2+hpdvQyevId8vRevRAEYSZi7bEUlejwysqe1v7doOKj+JyTm0xYc94ZaqxQUSqv5ulxZEwv2UE2TSae4ZlXVemrbQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(136003)(39860400002)(376002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(38070700009)(76116006)(91956017)(316002)(33656002)(36756003)(86362001)(122000001)(38100700002)(26005)(83380400001)(2616005)(71200400001)(53546011)(478600001)(6486002)(2906002)(66556008)(66476007)(66446008)(64756008)(54906003)(6916009)(66946007)(6512007)(6506007)(5660300002)(8936002)(8676002)(4326008)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Y0R2OVJJcytPR3FxZTczZytjWFpKeFJCbkIxR1ozWEZ6cVJpT05nc2cxUy92?=
 =?utf-8?B?OUdvdjc0US8rL2NSTC9TbHBzcklMZExGUXorSlBwS25EYXdCL2lPZlRPRFVY?=
 =?utf-8?B?SG9RUm9FSXd4N2FyRXJQM2gvOXNrSndTYjh3dXBaVU9IQXhxQzJtd2VHQTUr?=
 =?utf-8?B?QzhkRnZ6SW5JV3RMM09uL0hPMVB6MzVCazJsRjI1NS9ma2F4bzk5d2JSdW9l?=
 =?utf-8?B?OWFOSDJPM29kd3N1V2tWNDN4blBxblhjZW0wMnhyNDlGRk91bVlyNVpTa1VP?=
 =?utf-8?B?cjRVTGVGK3psSEx5cTVIN3JyekVUaVRISmpXU0hxUGticy9hQWxzakF3Y2tn?=
 =?utf-8?B?RkhUYjgzcTRseDBTQ1NnQ3VCbmlFbVNNd3A2V3FacGZBWkVQem4weXJzZE0r?=
 =?utf-8?B?MktPZjZUdmhOcnAwb1pobmVBUjBsR2s3RWZlWnIvREJ2cDFvWjc5Y1NCTWNn?=
 =?utf-8?B?Y2RsTW4xTExDN3dWdUIxcFVQVXJXWWxwVUpSOExKc1A4eWZhTkhtWE03eXFV?=
 =?utf-8?B?VGJST1IvaDR0OFNGWkRtUVV1WUhNNGJ1c0hudUIzVU1pMi9lVTRhUFg2aEFj?=
 =?utf-8?B?ZGwvSW1JSjRneFNFb1R5YVZkUElnZFRBZ1JDQVJsa1NaYXppemtDOC96dGp4?=
 =?utf-8?B?ZCthbmgyVGpzSzljd29BY3B0dmZTUEt5c0pnMXVLd1NSdU9uMDE1ZlY4UXFU?=
 =?utf-8?B?YVJDU1IrY0hkZXVqRHdzM3paU1dQQk1ldDJRUmZXNHFNRVVDZEJvVGh3SWVH?=
 =?utf-8?B?NnJoV2hGb2hKQVl6anVQbld1NjJ6ZjBYQUtVcjgrSzlGY0FoaC9JOTF5TkIx?=
 =?utf-8?B?OVZTMzdQWVRhLzMxSzhremlIc2wrNjFRUmVVUHZOYU90Ry9aWjBtbEFmSUZM?=
 =?utf-8?B?RlFJTjZlRGRUYjhZVWVPK2YzN1BOV3VCOE9vaHc4ejFFNDZKSHZkTk1wUVVR?=
 =?utf-8?B?RkFaVFk0ZEw0WUtXY2ZxUUt3YmVmNC9zbjRaL25GdHVKaUprbFB4NlgzWUJ1?=
 =?utf-8?B?TzhpYmNiazBDNUJwc3ZVMmxoZXBickdCcUdJVXRKbVdEekVYb3gxbW5wcCtW?=
 =?utf-8?B?SDduZmtqbUdaczZNdEVLcGhMVGl3RFBqc2xOM0FTSjFzVDVIcHV6OFI1cnRs?=
 =?utf-8?B?K0g4Tmx3KzREbmdlbVdhTGJMVVE4dTBiYjZTVTJvRTRwVFBWbjV2T3JLRTdX?=
 =?utf-8?B?eGVCSkRxRDVzN1dnT0g1QU11MGlGWlhzZDBNS09qbDJ1ekFFUHBHcDN2VzY2?=
 =?utf-8?B?c3p3dnJBYTdoaGlaTTE3TkZnRUtYUDM5L0tpYVpENnQxWU10S2dObGo1M3kw?=
 =?utf-8?B?eDg1TTNpRlJjRHczYlI2U3BMWEVMV1U1RnFGc3oyNXRmbHRYUCtzMXNrcCtl?=
 =?utf-8?B?OXZpaUdkYS9UZVh6TXVPQmZiSVJsbklrU0lEVjE0QzNqN2FMNE1HYm1YblhY?=
 =?utf-8?B?S3A1OTBWK0NIZUg0ZG1CSmg4VHBQSnZrY2pGVkxNVFBLWmlweUlsUXZ6VDJT?=
 =?utf-8?B?T0VDUlBqZ1JjRjNIbllPWjd5QTdubEthRHpRVUtMN0RZeXVWMTRxaEdUNUN3?=
 =?utf-8?B?b3hPY3BSc3FCUDROaTVIb1JVaS9lNVFKems1NVNoMnRTOE5XdUtEcUYvdDlR?=
 =?utf-8?B?VUtqWEpDVTQyZjhBTkdEVko5ODJWRnB0Y1k3QjFTc3dadHAxekpydCtTVUJE?=
 =?utf-8?B?R2EyaGFVZldqRVVTcHh6dzg2TTRpTjRNbXBXOGpzb3h2SEhiMlFkL2xBVnZt?=
 =?utf-8?B?OWt0VmZxY2kvcUxCVGUwemRMdFkyRVd5RFUrUlBkNGpVR24rS3lrK1ZFOHEy?=
 =?utf-8?B?NFFIS2h0NUt5S1hoc2N0OU1UZ3dRVDZKYnJiQ0ZlSW5lZlRkVkpBNytXdmZr?=
 =?utf-8?B?eFlmK0NPdFcxQzJ2WkxVVEp0RmZzenJGWFVqWFBVNTRqemMvSmVnVGtyRlg4?=
 =?utf-8?B?K3RtT3JKKzdZVXRCRnJhUlhLSHYwMmQ3d3BYUVc1Sks0eUpVV0dzOTZpcXZh?=
 =?utf-8?B?NUd6ZVNlNzZ3S1pmK1lMWlkzYTJnNHlVVXdpU0U5S2owZU5zYU45elhaZ3lu?=
 =?utf-8?B?NTB0S2lTMUJrWHNxa2xGaHR2TWoxVTBTRXNWTFl0SzZiWXVRK2NXSzlKN1RE?=
 =?utf-8?B?bXdYaUtwd0dkQ2ZUVDJOTmc4Zmh0bTB5NEtxTmxTb3ZuajkwaVRFVWJFTFV4?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB4457BA7BF29144A6DC5830F702A628@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KkS2EpSrY2julLWtE5Ky19L5zN2CTwxPBVDObhnsByOK9LeKuGLENm+scRx6oiTXgMx8dl6tu5bOWttJ170unrCulQLo/E5BX4c1dAkJzbZcVzUOBBTCWGXofIibTyN4oRA3Vl00PYvA2J5QDAI5WgpRKOTqGICvwV5yZtC9ZLk5A3CdIBhGWResLWGprnwkmEetbeyFKIzZ+6g1IlvFkErl1A+SmwuIViEyVqACHZ0Xk3lzMyuai0DXwBO8tb4NbFrXQ5GvtcHdOdVYcjMfru99uQz1eq8RlyBoQCaeQeyV2kO8ac2abJG8uc5Wn2d9A5X/pFKmA5KdG3xYGZq7qrareau8TEtEtz3Fcgj2umPehfNZ5i5tCYBa1oHtjhhBbxgO5PCSRKkuNYnedEQrJvTPfCWHUHJmW0PEoLlDW5r4CCnpXgK0PTt6PxbA6YsJaLxiQMFffWEwXMbkaN30VfGOncgTDT/dvYnpPBDz52d01jbDy0sbYOFT7WMZV9OfrLDqbgDg73Oar92ZZePb6BXQwcr7XSO3TY0k5W+zij5a4P18B1wu/oVaOzX0m+w3ws/oHHde/dAPPgrTbt2ToijGdlSvktPO6lwp5tcybIo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a39629-38e1-4e5d-8237-08dbfda8d885
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 20:03:03.1529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nnKJxsFNWVbn251cZao7R1p2B2x6PxcqDGoK97QGnG5JQqeu2yxLLoHo9uBwtQkB0UuU4EqcNsRf8mpQHR9l7ydhcAiDAS+LBzgnPjayMl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7221
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_10,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312150140
X-Proofpoint-ORIG-GUID: sBnpQjUCa93JOhBm81CGikLaa5RVRQdq
X-Proofpoint-GUID: sBnpQjUCa93JOhBm81CGikLaa5RVRQdq

DQoNCj4gT24gRGVjIDE1LCAyMDIzLCBhdCA5OjMw4oCvQU0sIERhcnJpY2sgSi4gV29uZyA8ZGp3
b25nQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBEZWMgMTUsIDIwMjMgYXQgMDU6
MDc6MzZQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBEZWMg
MTQsIDIwMjMsIGF0IDc6MTXigK9QTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29t
PiB3cm90ZToNCj4+PiANCj4+PiBPbiBUaHUsIERlYyAxNCwgMjAyMyBhdCAwMTozNTowMlBNIC0w
ODAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6DQo+Pj4+IE9uIFRodSwgRGVjIDE0LCAyMDIzIGF0
IDA5OjA1OjIxQU0gLTA4MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4+IEJhY2tncm91bmQ6
DQo+Pj4+PiBXZSBoYXZlIHRoZSBleGlzdGluZyB4ZnNfZnNyIHRvb2wgd2hpY2ggZG8gZGVmcmFn
bWVudCBmb3IgZmlsZXMuIEl0IGhhcyB0aGUNCj4+Pj4+IGZvbGxvd2luZyBmZWF0dXJlczoNCj4+
Pj4+IDEuIERlZnJhZ21lbnQgaXMgaW1wbGVtZW50ZWQgYnkgZmlsZSBjb3B5aW5nLg0KPj4+Pj4g
Mi4gVGhlIGNvcHkgKHRvIGEgdGVtcG9yYXJ5IGZpbGUpIGlzIGV4Y2x1c2l2ZS4gVGhlIHNvdXJj
ZSBmaWxlIGlzIGxvY2tlZA0KPj4+Pj4gIGR1cmluZyB0aGUgY29weSAodG8gYSB0ZW1wb3Jhcnkg
ZmlsZSkgYW5kIGFsbCBJTyByZXF1ZXN0cyBhcmUgYmxvY2tlZA0KPj4+Pj4gIGJlZm9yZSB0aGUg
Y29weSBpcyBkb25lLg0KPj4+Pj4gMy4gVGhlIGNvcHkgY291bGQgdGFrZSBsb25nIHRpbWUgZm9y
IGh1Z2UgZmlsZXMgd2l0aCBJTyBibG9ja2VkLg0KPj4+Pj4gNC4gVGhlIGNvcHkgcmVxdWlyZXMg
YXMgbWFueSBmcmVlIGJsb2NrcyBhcyB0aGUgc291cmNlIGZpbGUgaGFzLg0KPj4+Pj4gIElmIHRo
ZSBzb3VyY2UgaXMgaHVnZSwgc2F5IGl04oCZcyAxVGlCLCAgaXTigJlzIGhhcmQgdG8gcmVxdWly
ZSB0aGUgZmlsZQ0KPj4+Pj4gIHN5c3RlbSB0byBoYXZlIGFub3RoZXIgMVRpQiBmcmVlLg0KPj4+
Pj4gDQo+Pj4+PiBUaGUgdXNlIGNhc2UgaW4gY29uY2VybiBpcyB0aGF0IHRoZSBYRlMgZmlsZXMg
YXJlIHVzZWQgYXMgaW1hZ2VzIGZpbGVzIGZvcg0KPj4+Pj4gVmlydHVhbCBNYWNoaW5lcy4NCj4+
Pj4+IDEuIFRoZSBpbWFnZSBmaWxlcyBhcmUgaHVnZSwgdGhleSBjYW4gcmVhY2ggaHVuZHJlZHMg
b2YgR2lCIGFuZCBldmVuIHRvIFRpQi4NCj4+Pj4+IDIuIEJhY2t1cHMgYXJlIG1hZGUgdmlhIHJl
ZmxpbmsgY29waWVzLCBhbmQgQ29XIG1ha2VzIHRoZSBmaWxlcyBiYWRseSBmcmFnbWVudGVkLg0K
Pj4+Pj4gMy4gZnJhZ21lbnRhdGlvbiBtYWtlIHJlZmxpbmsgY29waWVzIHN1cGVyIHNsb3cuDQo+
Pj4+PiA0LiBkdXJpbmcgdGhlIHJlZmxpbmsgY29weSwgYWxsIElPIHJlcXVlc3RzIHRvIHRoZSBm
aWxlIGFyZSBibG9ja2VkIGZvciBzdXBlcg0KPj4+Pj4gIGxvbmcgdGltZS4gVGhhdCBtYWtlcyB0
aW1lb3V0IGluIFZNIGFuZCB0aGUgdGltZW91dCBsZWFkIHRvIGRpc2FzdGVyLg0KPj4+Pj4gDQo+
Pj4+PiBUaGlzIGZlYXR1cmUgYWltcyB0bzoNCj4+Pj4+IDEuIHJlZHVjZSB0aGUgZmlsZSBmcmFn
bWVudGF0aW9uIG1ha2luZyBmdXR1cmUgcmVmbGluayAobXVjaCkgZmFzdGVyIGFuZA0KPj4+Pj4g
Mi4gYXQgdGhlIHNhbWUgdGltZSwgIGRlZnJhZ21lbnRhdGlvbiB3b3JrcyBpbiBub24tZXhjbHVz
aXZlIG1hbm5lciwgaXQgZG9lc27igJl0DQo+Pj4+PiAgYmxvY2sgZmlsZSBJT3MgbG9uZy4NCj4+
Pj4+IA0KPj4+Pj4gTm9uLWV4Y2x1c2l2ZSBkZWZyYWdtZW50DQo+Pj4+PiBIZXJlIHdlIGFyZSBp
bnRyb2R1Y2luZyB0aGUgbm9uLWV4Y2x1c2l2ZSBtYW5uZXIgdG8gZGVmcmFnbWVudCBhIGZpbGUs
DQo+Pj4+PiBlc3BlY2lhbGx5IGZvciBodWdlIGZpbGVzLCB3aXRob3V0IGJsb2NraW5nIElPIHRv
IGl0IGxvbmcuIE5vbi1leGNsdXNpdmUNCj4+Pj4+IGRlZnJhZ21lbnRhdGlvbiBkaXZpZGVzIHRo
ZSB3aG9sZSBmaWxlIGludG8gc21hbGwgcGllY2VzLiBGb3IgZWFjaCBwaWVjZSwNCj4+Pj4+IHdl
IGxvY2sgdGhlIGZpbGUsIGRlZnJhZ21lbnQgdGhlIHBpZWNlIGFuZCB1bmxvY2sgdGhlIGZpbGUu
IERlZnJhZ21lbnRpbmcNCj4+Pj4+IHRoZSBzbWFsbCBwaWVjZSBkb2VzbuKAmXQgdGFrZSBsb25n
LiBGaWxlIElPIHJlcXVlc3RzIGNhbiBnZXQgc2VydmVkIGJldHdlZW4NCj4+Pj4+IHBpZWNlcyBi
ZWZvcmUgYmxvY2tlZCBsb25nLiAgQWxzbyB3ZSBwdXQgKHVzZXIgYWRqdXN0YWJsZSkgaWRsZSB0
aW1lIGJldHdlZW4NCj4+Pj4+IGRlZnJhZ21lbnRpbmcgdHdvIGNvbnNlY3V0aXZlIHBpZWNlcyB0
byBiYWxhbmNlIHRoZSBkZWZyYWdtZW50YXRpb24gYW5kIGZpbGUgSU9zLg0KPj4+Pj4gU28gdGhv
dWdoIHRoZSBkZWZyYWdtZW50YXRpb24gY291bGQgdGFrZSBsb25nZXIgdGhhbiB4ZnNfZnNyLCAg
aXQgYmFsYW5jZXMNCj4+Pj4+IGRlZnJhZ21lbnRhdGlvbiBhbmQgZmlsZSBJT3MuDQo+Pj4+IA0K
Pj4+PiBJJ20ga2luZGEgc3VycHJpc2VkIHlvdSBkb24ndCBqdXN0IHR1cm4gb24gYWx3YXlzY293
IG1vZGUsIHVzZSBhbg0KPj4+PiBpb21hcF9mdW5zaGFyZS1saWtlIGZ1bmN0aW9uIHRvIHJlYWQg
aW4gYW5kIGRpcnR5IHBhZ2VjYWNoZSAod2hpY2ggd2lsbA0KPj4+PiBob3BlZnVsbHkgY3JlYXRl
IGEgbmV3IGxhcmdlIGNvdyBmb3JrIG1hcHBpbmcpIGFuZCB0aGVuIGZsdXNoIGl0IGFsbA0KPj4+
PiBiYWNrIG91dCB3aXRoIHdyaXRlYmFjay4gIFRoZW4geW91IGRvbid0IG5lZWQgYWxsIHRoaXMg
c3RhdGUgdHJhY2tpbmcsDQo+Pj4+IGt0aHJlYWRzIG1hbmFnZW1lbnQsIGFuZCBjb3B5aW5nIGZp
bGUgZGF0YSB0aHJvdWdoIHRoZSBidWZmZXIgY2FjaGUuDQo+Pj4+IFdvdWxkbid0IHRoYXQgYmUg
YSBsb3Qgc2ltcGxlcj8NCj4+PiANCj4+PiBIbW1tLiBJIGRvbid0IHRoaW5rIGl0IG5lZWRzIGFu
eSBrZXJuZWwgY29kZSB0byBiZSB3cml0dGVuIGF0IGFsbC4NCj4+PiBJIHRoaW5rIHdlIGNhbiBk
byBhdG9taWMgc2VjdGlvbi1ieS1zZWN0aW9uLCBjcmFzaC1zYWZlIGFjdGl2ZSBmaWxlDQo+Pj4g
ZGVmcmFnIGZyb20gdXNlcnNwYWNlIGxpa2UgdGhpczoNCj4+PiANCj4+PiBzY3JhdGNoX2ZkID0g
b3BlbihPX1RNUEZJTEUpOw0KPj4+IGRlZnJhZ19mZCA9IG9wZW4oImZpbGUtdG8tYmUtZGZyYWdn
ZWQiKTsNCj4+PiANCj4+PiB3aGlsZSAob2Zmc2V0IDwgdGFyZ2V0X3NpemUpIHsNCj4+PiANCj4+
PiAvKg0KPj4+ICogc2hhcmUgYSByYW5nZSBvZiB0aGUgZmlsZSB0byBiZSBkZWZyYWdnZWQgaW50
bw0KPj4+ICogdGhlIHNjcmF0Y2ggZmlsZS4NCj4+PiAqLw0KPj4+IGFyZ3Muc3JjX2ZkID0gZGVm
cmFnX2ZkOw0KPj4+IGFyZ3Muc3JjX29mZnNldCA9IG9mZnNldDsNCj4+PiBhcmdzLnNyY19sZW4g
PSBsZW5ndGg7DQo+Pj4gYXJncy5kc3Rfb2Zmc2V0ID0gb2Zmc2V0Ow0KPj4+IGlvY3RsKHNjcmF0
Y2hfZmQsIEZJQ0xPTkVSQU5HRSwgYXJncyk7DQo+Pj4gDQo+Pj4gLyoNCj4+PiAqIEZvciB0aGUg
c2hhcmVkIHJhbmdlIHRvIGJlIHVuc2hhcmVkIHZpYSBhDQo+Pj4gKiBjb3B5LW9uLXdyaXRlIG9w
ZXJhdGlvbiBpbiB0aGUgZmlsZSB0byBiZQ0KPj4+ICogZGVmcmFnZ2VkLiBUaGlzIGNhdXNlcyB0
aGUgZmlsZSBuZWVkaW5nIHRvIGJlDQo+Pj4gKiBkZWZyYWdnZWQgdG8gaGF2ZSBuZXcgZXh0ZW50
cyBhbGxvY2F0ZWQgYW5kIHRoZQ0KPj4+ICogZGF0YSB0byBiZSBjb3BpZWQgb3ZlciBhbmQgd3Jp
dHRlbiBvdXQuDQo+Pj4gKi8NCj4+PiBmYWxsb2NhdGUoZGVmcmFnX2ZkLCBGQUxMT0NfRkxfVU5T
SEFSRV9SQU5HRSwgb2Zmc2V0LCBsZW5ndGgpOw0KPj4+IGZkYXRhc3luYyhkZWZyYWdfZmQpOw0K
Pj4+IA0KPj4+IC8qDQo+Pj4gKiBQdW5jaCBvdXQgdGhlIG9yaWdpbmFsIGV4dGVudHMgd2Ugc2hh
cmVkIHRvIHRoZQ0KPj4+ICogc2NyYXRjaCBmaWxlIHNvIHRoZXkgYXJlIHJldHVybmVkIHRvIGZy
ZWUgc3BhY2UuDQo+Pj4gKi8NCj4+PiBmYWxsb2NhdGUoc2NyYXRjaF9mZCwgRkFMTE9DX0ZMX1BV
TkNILCBvZmZzZXQsIGxlbmd0aCk7DQo+IA0KPiBZb3UgY291bGQgZXZlbiBzZXQgYXJncy5kc3Rf
b2Zmc2V0ID0gMCBhbmQgZnRydW5jYXRlIGhlcmUuDQo+IA0KPiBCdXQgeWVzLCB0aGlzIGlzIGEg
YmV0dGVyIHN1Z2dlc3Rpb24gdGhhbiBhZGRpbmcgbW9yZSBrZXJuZWwgY29kZS4NCj4gDQo+Pj4g
LyogbW92ZSBvbnRvIG5leHQgcmVnaW9uICovDQo+Pj4gb2Zmc2V0ICs9IGxlbmd0aDsNCj4+PiB9
Ow0KPj4+IA0KPj4+IEFzIGxvbmcgYXMgdGhlIGxlbmd0aCBpcyBsYXJnZSBlbm91Z2ggZm9yIHRo
ZSB1bnNoYXJlIHRvIGNyZWF0ZSBhDQo+Pj4gbGFyZ2UgY29udGlndW91cyBkZWxhbGxvYyByZWdp
b24gZm9yIHRoZSBDT1csIEkgdGhpbmsgdGhpcyB3b3VsZA0KPj4+IGxpa2VseSBhY2hlaXZlIHRo
ZSBkZXNpcmVkICJub24tZXhjbHVzaXZlIiBkZWZyYWcgcmVxdWlyZW1lbnQuDQo+Pj4gDQo+Pj4g
SWYgd2Ugd2VyZSB0byBpbXBsZW1lbnQgdGhpcyBhcywgc2F5LCBhbmQgeGZzX3NwYWNlbWFuIG9w
ZXJhdGlvbg0KPj4+IHRoZW4gYWxsIHRoZSB1c2VyIGNvbnRyb2xsZWQgcG9saWN5IGJpdHMgKGxp
a2UgaW50ZXIgY2h1bmsgZGVsYXlzLA0KPj4+IGNodW5rIHNpemVzLCBldGMpIHRoZW4ganVzdCBi
ZWNvbWVzIGNvbW1hbmQgbGluZSBwYXJhbWV0ZXJzIGZvciB0aGUNCj4+PiBkZWZyYWcgY29tbWFu
ZC4uLg0KPj4gDQo+PiANCj4+IEhhLCB0aGUgaWRlYSBmcm9tIHVzZXIgc3BhY2UgaXMgdmVyeSBp
bnRlcmVzdGluZyENCj4+IFNvIGZhciBJIGhhdmUgdGhlIGZvbGxvd2luZyB0aG91Z2h0czoNCj4+
IDEpLiBJZiB0aGUgRklDTE9ORVJBTkdFL0ZBTExPQ19GTF9VTlNIQVJFX1JBTkdFL0ZBTExPQ19G
TF9QVU5DSCB3b3Jrcw0KPj4gb24gYSBGUyB3aXRob3V0IHJlZmxpbmsgZW5hYmxlZC4NCj4gDQo+
IEl0IGRvZXMgbm90Lg0KPiANCj4gVGhhdCBzYWlkLCBmb3IgeW91ciB1c2VjYXNlIChyZWZsaW5r
ZWQgdm0gZGlzayBpbWFnZXMgdGhhdCBmcmFnbWVudCBvdmVyDQo+IHRpbWUpIHRoYXQgd29uJ3Qg
YmUgYW4gaXNzdWUuICBGb3Igbm9uLXJlZmxpbmsgZmlsZXN5c3RlbXMsIHRoZXJlJ3MNCj4gZmV3
ZXIgY2hhbmNlcyBmb3IgZXh0cmVtZSBmcmFnbWVudGF0aW9uIGR1ZSB0byB0aGUgbGFjayBvZiBD
T1cuDQo+IA0KPj4gMikuIFdoYXQgaWYgdGhlcmUgaXMgYSBiaWcgaG9sZSBpbiB0aGUgZmlsZSB0
byBiZSBkZWZyYWdtZW50ZWQ/IFdpbGwNCj4+IGl0IGNhdXNlIGJsb2NrIGFsbG9jYXRpb24gYW5k
IHdyaXRpbmcgYmxvY2tzIHdpdGggemVyb2VzLg0KPiANCj4gRlVOU0hBUkUgaWdub3JlcyBob2xl
cy4NCj4gDQo+PiAzKS4gSW4gY2FzZSBhIGJpZyByYW5nZSBvZiB0aGUgZmlsZSBpcyBnb29kIChu
b3QgbXVjaCBmcmFnbWVudGVkKSwgdGhlDQo+PiDigJhkZWZyYWfigJkgb24gdGhhdCByYW5nZSBp
cyBub3QgbmVjZXNzYXJ5Lg0KPiANCj4gWWVwLCBzbyB5b3UnZCBoYXZlIHRvIGNoZWNrIHRoZSBi
bWFwL2ZpZW1hcCBvdXRwdXQgZmlyc3QgdG8gaWRlbnRpZnkNCj4gYXJlYXMgdGhhdCBhcmUgbW9y
ZSBmcmFnbWVudGVkIHRoYW4geW91J2QgbGlrZS4NCj4gDQo+PiA0KS4gVGhlIHVzZSBzcGFjZSBk
ZWZyYWcgY2Fu4oCZdCB1c2UgYSB0cnktbG9jayBtb2RlIHRvIG1ha2UgSU8gcmVxdWVzdHMNCj4+
IGhhdmUgcHJpb3JpdGllcy4gSSBhbSBub3Qgc3VyZSBpZiB0aGlzIGlzIHZlcnkgaW1wb3J0YW50
Lg0KPj4gDQo+PiBNYXliZSB3ZSBjYW4gd29yayB3aXRoIHhmc19ibWFwIHRvIGdldCBleHRlbnRz
IGluZm8gYW5kIHNraXAgZ29vZA0KPj4gZXh0ZW50cyBhbmQgaG9sZXMgdG8gaGVscCBjYXNlIDIp
IGFuZCAzKS4NCj4gDQo+IFllYWgsIHRoYXQgc291bmRzIG5lY2Vzc2FyeS4NCj4gDQoNClRoYW5r
cyBmb3IgYW5zd2VyaW5nIQ0KV2VuZ2FuZw0KDQo=
