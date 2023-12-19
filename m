Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8103BB2D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 21:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GCD5fmrD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ze1cfp/o"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJIn0o9016010;
	Tue, 19 Dec 2023 21:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ibMzi3gP+1CuNs1GjQGDpXbQKR/R0uY1eWqVaiqBxEo=;
 b=GCD5fmrDProIx2KtRUhqz/qGF7OTJVe3lcgZdYAnB+H0M0AGVifm2C8i5R4Y0N5cr/hw
 s577jETy3ENUCxC/QkFQ1ww8jLzxE8dM48ekc3ZRuIyNFAMeXcdm9DVHT9CKDoAT/r8V
 9SzgNjiAZxBu4hxJ+9Hmk/2ghMbXjeZg4823bJd5gEdjT9cD9uSVYjkwO4d07CRZL/QK
 xF6kPj0Bk+CQkqPH9x41K6zL5ZrruPk3lRJqAz6c5YCRjjjyT9qqvb2w92xsjK/RMj4D
 rPBPQCP211Ix4TNmMxnHAR+hrb96ZrHxygrbLq/N1eAGl+oULAiyB9tdfiT09n+slgb2 3Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12aeewqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 21:17:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJKTK8f020909;
	Tue, 19 Dec 2023 21:17:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3v12b7pc5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 21:17:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGxXYi/zJVBud9xpspxPWWyyC/XG+XAfv9M1Jttqt4RJqxfGKAI59ACCghUw17ewBGWhaysCTPOzAM2gGEqnrVkHCbnCg1iDiXpZV1s3bjiife0Sq6mI/j6COdXcbJVZ3d9aodmbPqxeJrEHB9pzZkSj0VGTeLd1wXmqzVJc7WhDvZ2AS28Z6FpR6lq8bMVYg8siQRcdGWUhudRRY1N7dROeSBbSei7a9ikSUMdiK9qg2sn5b+puYYgpuW/CAhI6K9x4y1qjYgppL7CSkTuL5IPRe+svlREPdmxsuRz3ngu8qOX1nY/rYb9qxD6lmuAkwbyk8lzHWdq7K9ApFI18yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibMzi3gP+1CuNs1GjQGDpXbQKR/R0uY1eWqVaiqBxEo=;
 b=N6aKe7HLJ5nXELspBsqNVBRO7pMIQs7fODYgzXnw9ojQtNbu9QjTU9m+4qgJsih9upYYhFRrJOBxDerCWCBOlPybwa3/FnvVSy7skkf9nn6QLkx7RSPHJkzBA4JibIuzDoSc7qcCjPK5CaTSKnCrXsCHyT3yOZdlwRC3twMeUR3LFis6G5IUPhZ/2LPcYYBNAA6KztKTRFx+ioSL71TarNfUXPKJbNLxkmYnBLGINzUtmTAmYzkXAAmH1xLxjlpWH8228plDOzTlKqzfg4WviT0fgJ1or18Bn27qVY2SAUJdaIgk3bjRxRYyx3ZmIoG9un4qixyYTKQdxq7EM/+kKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibMzi3gP+1CuNs1GjQGDpXbQKR/R0uY1eWqVaiqBxEo=;
 b=ze1cfp/oLuKgUy/7uHl3ThpFb6Z7dS6tRGzAIxVORAx3pH+DaGh/3x4Jt/ys5Z5riOgeof3xO1HGsKn4M5wLS+e/iMJ/CP54gmqQI+u7GtPucABFVB6zYNfjZA1O65ZFFmWEqfiZOWOfzZuwSZLjbFyasaJISbN17yPRSduBA2Q=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by CY8PR10MB6564.namprd10.prod.outlook.com (2603:10b6:930:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 21:17:31 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 21:17:31 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: 
 AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABe/wCAAOiSAIAANdGAgAR17ICAAeNngA==
Date: Tue, 19 Dec 2023 21:17:31 +0000
Message-ID: <6480D0D9-7105-41CB-8B6D-1760DE26DDE4@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
 <ZXy08z140/XsCijh@dread.disaster.area>
 <D074B518-2C9E-4312-AC31-866AABE1A668@oracle.com>
In-Reply-To: <D074B518-2C9E-4312-AC31-866AABE1A668@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|CY8PR10MB6564:EE_
x-ms-office365-filtering-correlation-id: c96914e1-394c-4ba3-b978-08dc00d7e9b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 hdOSAQaOSRj1aTs2wq880ilTc3e0GMU8Y0ukxZbC8pqV7k+f541uKNYeQQ5y4x8vuZKa2X7x+ZTZy3vImqztRa6Pjz+/rCTlFtwu/zCvPp+UoIAp3g3odeFuwrqYCyM9XDtqeHkhaXxWyG1DfLylB1S6uHccDq4MimNYKVQBjGtkSH5Es69B/fVwpQ9doJwVNVBA/S02FkRG1OI4+w57ZsUMPb9iI1ON9JHAUWOgc7MDcw6vqdV+0u5m1Fhp6373mwm4mxorfeoj1bKxS8WShNJOBkd16TvPOA7LDD51MPsAW1LTIMgUynEIrI/PIZYsrv+AFPCE30kNmh0BdauMFyR+7wONwEArS/MHihgRZOYtknv0F+Dta7zNwyZ/x79pQTcIncDjweXnMjKPmalpVQADKeGTfEp30RrNURQ+RbKKbSWRCxh3R7avLKH0GZInPnon7IoQ9pB95sNn8/C5rZ/R61/ksmEl9HgEC0AmhLAUMPLDUjeElAObqDwHoRcD/arbddlJHnoCOHgLktkgo7B7KzxkH1tVbipGf8Cn2g0gwrjJmh6R+M1wzTq1fqrc0ODCswDJ3i0yVu3C/q89/qVqzgt3jJ+yBKNE+eihQE5p6NwgJOBv8qQnd/4+hnYFjziDgZ47TvHgZWw87fKDLA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(366004)(376002)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(2616005)(26005)(53546011)(5660300002)(83380400001)(6512007)(8936002)(8676002)(6506007)(478600001)(66556008)(6916009)(316002)(6486002)(2906002)(66946007)(76116006)(54906003)(64756008)(66476007)(4326008)(41300700001)(66446008)(36756003)(71200400001)(33656002)(38100700002)(122000001)(86362001)(38070700009)(66899024)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?SWs0cndmOCt2YUxLNDFNcnRVc1psTFVzZ3UybFNKbXMybVpSbndjb0lzMVhQ?=
 =?utf-8?B?Z0Zsb0lIaGw4SkhORENNQkNjTTcxaTl0N2hCdW5YQWlLSmlzL3VsNlpaUjFa?=
 =?utf-8?B?ZGhRdWN4dHEzOUdIOSsxZDRmdFVmQlZUeURwa29JR3Rudm8xcmFTYTF4clFt?=
 =?utf-8?B?eFNpYVFUbUU1YytHVjI3OTcrUlVzR1lrWkZKYWx0MWwvQVFObElnQXRIMllm?=
 =?utf-8?B?TytGbFFiWlpyZkJiUVZSTkVDS2ovZ243bUM3bGRQVTVuTWFBWDJ4RXdmSC9t?=
 =?utf-8?B?NlpaaWFheWIyVlZGNWxWd1g3QW1GY3ExbndTTWJGb2xwaXlJeGxHdHB5a2E2?=
 =?utf-8?B?TmlQampCWDlZdlFTTGNOeFZMdVlvWDlXV1c0S2g2MlViMzIrU3BWTnJTR2Ir?=
 =?utf-8?B?QzFGRURqRVgzWUpzaWszcFF1N0hOWUQ4WFlYUVBDak0wR0NkZGsxNDhOTFN6?=
 =?utf-8?B?clhlSDd2QmxRNkE3QjFkTGZkY3RIQXo2S1hJV2g4eTNQWkJZTUdJdHlBMExV?=
 =?utf-8?B?S3B5SXNNWkpwMWZqNm1JUjZCUFlzVlcxQUQ3TU0rOU9BWTBOWitKZ2sySDFs?=
 =?utf-8?B?NEJLWFBFMWI4WlFmempRZWk4NVZORDA0T0tTcU9DNnJhbUZaR1lvN2toVWo1?=
 =?utf-8?B?dE1YK1ZhZXM5WDBjTTF0bW1LOXBiQ29Qa1N4K1lmUkFNUS8xMXVPamhaUStz?=
 =?utf-8?B?dEViL212a2cvdkpsN1EvNzRoRGt5alRhTUVoQmk1Mk5lZE9tNFVwM0tjdW05?=
 =?utf-8?B?TWVCUVdyaEN3V0UvZS9GWkhXN0RJMHU0azJCZ3lEQWVBL1F5L3o4RkFLMVAy?=
 =?utf-8?B?citxcTdabmF4K0laRmxGcmJrem5DUkc2NThTYldXMFpzRmFpdGo1UE8zVHFl?=
 =?utf-8?B?MUFrUW5NNlRCMFRjdm9vR0FSeElURXUvRnp2QThxTExkb3Qxa2hiMlBFMWMx?=
 =?utf-8?B?ZVdVdGJYUmxOYmxwYVlwUXhvU0VrQ3JnS2ZHQnZUKzNxOGVJNUorOGV5akZC?=
 =?utf-8?B?TUFtSkxzYnRwR1N3TGoycisvajlWT0g4VEVXeUZWMDVsTFUrRWhtRm1Edk1D?=
 =?utf-8?B?R3MzdDg3K3JPMU5YWG5ab0VpRXdzYW9TU2xkWm5XMTdFZDh5SjhYZkY0WHN5?=
 =?utf-8?B?d3BURWV6cTdsTE1QbjNKYitnYVZPK3JSMVlDeHZwc1Jra2t0bzF1QXorTHlj?=
 =?utf-8?B?MG5PaXpYbVZYWTc1QlkrNFAybG5NeW5FdUx5RWVhR0tEVkw1aGVETWhTSXZa?=
 =?utf-8?B?cnhWUHgyTHAvcHFJSDJCcEdXZ2MycEpXNlZQekRsMEh4dXdRY0hXb2ZKS3dD?=
 =?utf-8?B?R21qclNPZGNmRTZITTB4S2V6YWJNMUxLN0k2K1JIOHJURHJ4L2dJTWdLZkJn?=
 =?utf-8?B?ZkdYdUZQYmVHSUNDUHR1alpHNVY3dWhOVWMrTThOK0luQnZuQWlxZTZqTVow?=
 =?utf-8?B?SXFtUUZ2R0VYSUZJVTNNU0hXMDVPMkJPSmI1b3g0ZDJ5bFBKbVhYZHZSYzdC?=
 =?utf-8?B?RkFOblBIeC95eDZ4Q1hnZ3luSnJ3Y2pFdVU0ZHMxbW9KZ05IR3FFNzU4OHpQ?=
 =?utf-8?B?SWlzR3c5TW5kQ2MrczRCdlU3OU16d242aXJRNi9jcEMxd3BQWnptaFZ2QzNC?=
 =?utf-8?B?aFE3NzMwT2FlZHBML2MyWlVzcmNKdG9uREVnRVVHNFRUaTlESXlnVUJWR3d2?=
 =?utf-8?B?YlJGNmFBMEVKZktBbDBIYzM0di8wYThOcXBjdnhJVVRuQXBkYkxYNE92QWh6?=
 =?utf-8?B?V1NVbUVCNm4rK1FYQm80RTBVTXpDYklvc2IxNzFYdlNJckJqbktCdUlCelZx?=
 =?utf-8?B?Njl4dE0wMEFzSmZMZ1RDNjB1SndEaklEYm1oKzZmWjdveUwvb0tlSzBrN2VG?=
 =?utf-8?B?UUlDYmE1SGR3Zy9MNzhDYSttMlVCNVhrTUxWYWJGWWtxVmk4TlNaUlJHb05X?=
 =?utf-8?B?NEJtR0ZRa0dyTnI2NndLM2VScmJab2wyaFVObVJlS283dHZLb3VGdXdwanZa?=
 =?utf-8?B?OG9ZQTFRaHZFWk5hYkxhZGVjMVRiRkhkeEhwL3kyQXpiaVZsaWZyem9mYlNp?=
 =?utf-8?B?Q1FVT1dCWUt5ZStLSWh6RktaeXhRenYxNno4dXBDRTZRRXlpVEtZampTL0ND?=
 =?utf-8?B?RXRyaEF0Tis4RDM1VFNsTnVSTi9JVXJ4WFhaRXI3ZnY4V3NVVWFCOVVwcTZq?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21D86551410F4C40AE9A0AE7A113F4D6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BtvOzF3tPVYIFq8dnzabYCfjGXTaoMIHJGHZ6iUTK4T1JLoVuS1jU2EpM/Pt8efensssLH220EZqhd2VPKuPJiRAaxocKy05HNuatamXlVfXeYGrSFQX+7LuF3kZ5muu2i+hpOHKeCApPJSDAe0sB2xeupmpE8T6sNBXI2RmUQgs8tbXUdrcvmrDqTBUsJJ0DOYsi4+I2avWIrMibXOl0TFWtaFpeYUghOA774agYuLCNG9MwPrFdDxCSAMTqsKgjayanHgrHwy0FhJg/ceUQrt9kZj4ybVJ3O+MU7gcvgEUT1dAyolbrzndPrdI8ruzreA3VKyKt1CIZEejdrPAwb2kKfuF/2XW5i5fw3ezDvU5acP0gPJLRR6+05Brt4SgZyOtXJANmQUhLV8KUFVUGFmMteDsDESyAWZWUxy9PcbNEgShKeOzORZp9XzsOK102KedGYuYCUbJhrECbl7knFim0mVg/vvxOJWjfRaJw6X8jUkODupHCU8/lIGDJtHH8Z3x1u+rTmXjM3nlo0bToUKYPZ3y/zL+2OIdROVWUSbW/AbeLmIYKNd6y4qQovkid7SErJMC1Ak9eve69O2pz1AcywWCe/bTorBdWQJsBgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96914e1-394c-4ba3-b978-08dc00d7e9b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 21:17:31.8156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JRl6WWjg6ITdEqZYQN7Kz9X2vMIrHAPWJAhUPl3H0xT+3mGqR2Y6t/UwQ10VX79GpIpos9SbZKBD+12rDY+2NAwA4uiYA+9mJ9QvPzKHd1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6564
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_12,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190157
X-Proofpoint-ORIG-GUID: Y3IeVTkj2gXUjPkDNA2Si5iX0_HlP8IK
X-Proofpoint-GUID: Y3IeVTkj2gXUjPkDNA2Si5iX0_HlP8IK

SGkgRGF2ZSwNClllcywgdGhlIHVzZXIgc3BhY2UgZGVmcmFnIHdvcmtzIGFuZCBzYXRpc2ZpZXMg
bXkgcmVxdWlyZW1lbnQgKGFsbW9zdCBubyBjaGFuZ2UgZnJvbSB5b3VyIGV4YW1wbGUgY29kZSku
DQpMZXQgbWUga25vdyBpZiB5b3Ugd2FudCBpdCBpbiB4ZnNwcm9nLg0KDQpUaGFua3MsDQpXZW5n
YW5nDQogDQo+IE9uIERlYyAxOCwgMjAyMywgYXQgODoyN+KAr0FNLCBXZW5nYW5nIFdhbmcgPHdl
bi5nYW5nLndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBEZWMgMTUs
IDIwMjMsIGF0IDEyOjIw4oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4g
d3JvdGU6DQo+PiANCj4+IE9uIEZyaSwgRGVjIDE1LCAyMDIzIGF0IDA1OjA3OjM2UE0gKzAwMDAs
IFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4gT24gRGVjIDE0LCAyMDIzLCBhdCA3OjE14oCvUE0s
IERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+Pj4+IElmIHdlIHdl
cmUgdG8gaW1wbGVtZW50IHRoaXMgYXMsIHNheSwgYW5kIHhmc19zcGFjZW1hbiBvcGVyYXRpb24N
Cj4+Pj4gdGhlbiBhbGwgdGhlIHVzZXIgY29udHJvbGxlZCBwb2xpY3kgYml0cyAobGlrZSBpbnRl
ciBjaHVuayBkZWxheXMsDQo+Pj4+IGNodW5rIHNpemVzLCBldGMpIHRoZW4ganVzdCBiZWNvbWVz
IGNvbW1hbmQgbGluZSBwYXJhbWV0ZXJzIGZvciB0aGUNCj4+Pj4gZGVmcmFnIGNvbW1hbmQuLi4N
Cj4+PiANCj4+PiANCj4+PiBIYSwgdGhlIGlkZWEgZnJvbSB1c2VyIHNwYWNlIGlzIHZlcnkgaW50
ZXJlc3RpbmchDQo+Pj4gU28gZmFyIEkgaGF2ZSB0aGUgZm9sbG93aW5nIHRob3VnaHRzOg0KPj4+
IDEpLiBJZiB0aGUgRklDTE9ORVJBTkdFL0ZBTExPQ19GTF9VTlNIQVJFX1JBTkdFL0ZBTExPQ19G
TF9QVU5DSCB3b3JrcyBvbiBhIEZTIHdpdGhvdXQgcmVmbGluaw0KPj4+ICAgIGVuYWJsZWQuDQo+
PiANCj4+IFBlcnNvbmFsbHksIEkgZG9uJ3QgY2FyZSBpZiByZWZsaW5rIGlzIG5vdCBlbmFibGVk
LiBJdCdzIHRoZSBkZWZhdWx0DQo+PiBmb3IgbmV3IGZpbGVzeXN0ZW1zLCBhbmQgaXQncyBjb3N0
IGZyZWUgZm9yIGFueW9uZSB3aG8gaXMgbm90DQo+PiB1c2luZyByZWZsaW5rIHNvIHRoZXJlIGlz
IG5vIHJlYXNvbiBmb3IgYW55b25lIHRvIHR1cm4gaXQgb2ZmLg0KPj4gDQo+PiBXaGF0IEknbSBz
YXlpbmcgaXMgImRvbid0IGNvbXByb21pc2UgdGhlIGRlc2lnbiBvZiB0aGUgZnVuY3Rpb25hbGl0
eQ0KPj4gcmVxdWlyZWQganVzdCBiZWNhdXNlIHNvbWVvbmUgbWlnaHQgY2hvb3NlIHRvIGRpc2Fi
bGUgdGhhdA0KPj4gZnVuY3Rpb25hbGl0eSIuDQo+PiANCj4+PiAyKS4gV2hhdCBpZiB0aGVyZSBp
cyBhIGJpZyBob2xlIGluIHRoZSBmaWxlIHRvIGJlIGRlZnJhZ21lbnRlZD8gV2lsbCBpdCBjYXVz
ZSBibG9jayBhbGxvY2F0aW9uIGFuZCB3cml0aW5nIGJsb2NrcyB3aXRoDQo+Pj4gICB6ZXJvZXMu
DQo+PiANCj4+IFVuc2hhcmUgc2tpcHMgaG9sZXMuDQo+PiANCj4+PiAzKS4gSW4gY2FzZSBhIGJp
ZyByYW5nZSBvZiB0aGUgZmlsZSBpcyBnb29kIChub3QgbXVjaCBmcmFnbWVudGVkKSwgdGhlIOKA
mGRlZnJhZ+KAmSBvbiB0aGF0IHJhbmdlIGlzIG5vdCBuZWNlc3NhcnkuDQo+PiANCj4+IHhmc19m
c3IgYWxyZWFkeSBkZWFscyB3aXRoIHRoaXMgLSBpdCB1c2VzIFhGU19JT0NfR0VUQk1BUFggdG8g
c2Nhbg0KPj4gdGhlIGV4dGVudCBsaXN0IHRvIGRldGVybWluZSB3aGF0IHRvIGRlZnJhZywgdG8g
cmVwbGljYXRlIHVud3JpdHRlbg0KPj4gcmVnaW9ucyBhbmQgdG8gc2tpcCBob2xlcy4gSGF2aW5n
IHRvIHNjYW4gdGhlIGV4dGVudCBsaXN0IGlzIGtpbmRhDQo+PiBleHBlY3RlZCBmb3IgYSBkZWZy
YWcgdXRpbGl0eQ0KPj4gDQo+Pj4gNCkuIFRoZSB1c2Ugc3BhY2UgZGVmcmFnIGNhbuKAmXQgdXNl
IGEgdHJ5LWxvY2sgbW9kZSB0byBtYWtlIElPIHJlcXVlc3RzIGhhdmUgcHJpb3JpdGllcy4gSSBh
bSBub3Qgc3VyZSBpZiB0aGlzIGlzIHZlcnkgaW1wb3J0YW50Lg0KPj4gDQo+PiBBcyBsb25nIGFz
IHRoZSBpbmRpdmlkdWFsIG9wZXJhdGlvbnMgYXJlbid0IGhvbGRpbmcgbG9ja3MgZm9yIGEgbG9u
Zw0KPj4gdGltZSwgSSBkb3VidCBpdCBtYXR0ZXJzLiBBbmQgeW91IGNhbiB1c2UgaW9uaWNlIHRv
IG1ha2Ugc3VyZSB0aGUgSU8NCj4+IGJlaW5nIGlzc3VlZCBoYXMgYmFja2dyb3VuZCBwcmlvcml0
eSBpbiB0aGUgYmxvY2sgc2NoZWR1bGVyLi4uDQo+PiANCj4gDQo+IFllcywgdGhhbmtzIGZvciB0
aGUgYW5zd2Vycy4NCj4gSSB3aWxsIHRyeSBpdCBvdXQuDQo+IA0KPiBUaGFua3MsDQo+IFdlbmdh
bmcNCg0KDQo=
