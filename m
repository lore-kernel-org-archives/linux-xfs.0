Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E523FE4F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hcjL5wNK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dyb4rXYf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFG477n012227;
	Fri, 15 Dec 2023 17:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=r2Ino9IkdS9dZDemGDNKMtJH4NgZLg4pz0xF8a2eXDU=;
 b=hcjL5wNK7BFd/l3w/AWg0cXZt0WPxZwV5wS11vZst1XTnAcCuoNYJR91h4I5wfKf8YsU
 WCslyPIY4fdXOrrZC9oGOSstU4VBeoIa3HFirPD1H4a4vT8aqjocW4wpNVPEL3CStSJ+
 sz+zjGGOcg8A0V/hOSmy1YnfMyhfbq+3GtB61MZdw6ab5e59R+apEqyQnkntCl10O5u2
 XpKzQGrjL8zbj+ggqLIyN/J+T69g/SfS7D0IUnFKpokcZsBS5mNTcdRazhlpQqw2Y1sY
 9JbhFf/hqHOiTrQLFBvzVrVQSmNMNSHBcZo/Py07seubMENYlckAeLgeLbIlfurhgzJ+ qQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3uwgn3v0jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 17:07:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BFGdTBx024794;
	Fri, 15 Dec 2023 17:07:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uvepc3e47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Dec 2023 17:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrganVFd05Toq/SnaC6jTpNF0YYpUi16zeMEiVqGpwvMMraLEtJJsTuZZa1IIZ8in0rXjrZkcso3tBf8R1DIkrVUwcCj/wiPlUeeLaZ0gMWH6kqBE9Y7RqRrpKbJ4P1WhjQ7VfvYm20C1LxS6udyFcfT8alE95odJQfE8wfW95ken/n3WZDEBzPXIXd457jwI4SdFmuu0Mrdy0GREFRqWO9ALozJDWDwwN/ijJu412K9U/rT81DHspeXfMhS92ZwIaxD8sgNcWE1D5mbO7NxldWsG9ksXHaEqSyNZYWCeB5585IYNhYrz6ee4tSBhMBM+jqbLvsMbFf6JmRHius/kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2Ino9IkdS9dZDemGDNKMtJH4NgZLg4pz0xF8a2eXDU=;
 b=BdVLNXAGyjtewbAVfEPTCpIDGBNPDZzsLmLMrEZrtkAzRfbPMeWddHS/njSpYscgQupO3RrHQXJg/ZyldMTKublRCc7IgP/XGna/1kmgpjSy63DwnxvjjPZD3mb6mtYF/n2Z945Da8kALvtcjGIcox4/O6YcJy+px3j9KwhxJx02D7Be6Hx1NrEF8meW8euUmxfOty7LrTS0H7zBJU7Eu08ZBBAH2T+afWjwMeEGfQAJPISIMwV9mQwElTvbAZhpv4eKlo7ltbWMF2QoFbHOi06Kt347N0PPFYlnZoYYlneQvgY/ogpeOC9KnZWoZ+ZvI02OFIVjCGfSiKZTDcuMsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2Ino9IkdS9dZDemGDNKMtJH4NgZLg4pz0xF8a2eXDU=;
 b=dyb4rXYfh40tjY8aWMVhOwOSmkPUh/fUTWS2ME+ZLsfp2XV5XMXU8Ym9zGlrfiR+R2hRVfowcBE2zwTYOIe2i2maV+dzHR6MklC9cy2To0ShEGmlzwU4ZeuR73Q/39lQ0DbUqDDdQas2xfKoQb9C8s3ihEp7Edu5+b6B2SACCOw=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by IA1PR10MB7357.namprd10.prod.outlook.com (2603:10b6:208:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.31; Fri, 15 Dec
 2023 17:07:36 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.030; Fri, 15 Dec 2023
 17:07:36 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABe/wCAAOiSAA==
Date: Fri, 15 Dec 2023 17:07:36 +0000
Message-ID: <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
In-Reply-To: <ZXvEtvRm1rkT03Sb@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|IA1PR10MB7357:EE_
x-ms-office365-filtering-correlation-id: e78d9dc2-314c-432f-8ba3-08dbfd905649
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 lb/hqRaCy0YlzUW6ZG8eFOSbU+gpgrP3TBQYUfrXabUvJvc0l0BETac4lW9/C7ZB+pXP4GbnQ8HbrRx2tC24/reQFbyfzaaV+dTi40gXM5EQ257gULRESHIg1nCTFghuIraB1SIvR9VJc2A+4SS0NLNt8AQ5ZtW+SuVpM5QBzQncQXviZfE2smX1eyxJyvmEon8bTkYTw4tALv/Geumi6wowv7nbE2Exh4Vjzz50J9DrkX1Yd4AFvh3sPtMOCxJwj1ByZlQ3UX/VW5el3MkmHdW7i9fhBGuoQgZaXNR8zeL649xswIbslXV96blASh4oCuqvcYQiAsFXLQEzTijp1mJK9dKQ9WyYEO6utIDPfK1cHcz57qsWe4FEEACxAf3R+r3glkBRS7szF7GMpjwgLnkbYVQ3NqA63/1CGYN53WIsRSgpbBkEmawldF9yD4VhPdzVz86uo+2HXk7tNquduWepOLT4E7zLzTx5beNo5To5CQ/dOEsk+KcLSmDqWw6b72ZPGacJmQydrT0p9LKrvIPk0oiHYJgYCRhMB4rcYtmwTwp2QaOslVlTac+uQX20KUvAhh5X33p5NvmKVSZzswzjkd7yYT6kmslhW2361dUt8q9LRqb332Oy50kWg+a2qG4S2iAbViJCfno3BHmn4w==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(39860400002)(136003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(122000001)(38100700002)(2616005)(83380400001)(71200400001)(33656002)(36756003)(86362001)(38070700009)(53546011)(6506007)(6512007)(478600001)(6916009)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(91956017)(76116006)(2906002)(8936002)(4326008)(8676002)(5660300002)(41300700001)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?SHE2ZGxKUTRQb0g4dGRNcWpzYU9zQnlnckFvZy9uOHFDZnAwZjB1YlhIeVAr?=
 =?utf-8?B?cFBHYmtNZkVmdmpVK3RMRXZHYk5uWFRHb0lUNmpKWGNxck1iRTNoc2dHUk9v?=
 =?utf-8?B?WVZxVzlHcnJBQ0tyQXJaTWdtYjUxRWRWNEZ2QjFrTUZPOWg4UHVzR0xTWWJz?=
 =?utf-8?B?TldMeUJ5WnJhRmhGNzhBQ2p0WUZtekNQR2V1bFdwZ2JtcnJNRC9KZGloOTgz?=
 =?utf-8?B?dHY4ZFdZcXlvb2EvTUtRU0xVcExtYWFvZXBEWlpGMFprSVhQN09qLy9UVXdS?=
 =?utf-8?B?ZXZEeDJFSEZRZWcwN2VsZ0hMUzNWbTh5RUFNTHB3bnI1R2RHbDJMNjlLd3c4?=
 =?utf-8?B?YUFzZ1pYZDJHWDlXSzhWL0RoTUJkNHhicDcyeVhURHRZS0pVbUxocHREUFNS?=
 =?utf-8?B?Y0FUTGMvMmlZRlFvYzRSdnk3MVk5ZHY2RmJQQ0d2UGh3UFZUMCtYN1RJYW5a?=
 =?utf-8?B?Qm9jUFpvQmZwRUxEdXRoZGEwbnUyU0MzdUJFa1RlMXRBc3BxRTdCZ0d1MnZl?=
 =?utf-8?B?bVBCSHhYSE9HMk12ZWZvd25zS2NsQ2RJeDM4NUVXYTVoelRyaU5IV25ZSHFv?=
 =?utf-8?B?cGdqNG9xa3VhVk9UMSsyRVdrZU1LNUlnSHp2MlJLS1FDeGJoYlVjZ05mN1V0?=
 =?utf-8?B?c3hoeGFEaEN1NkYvcWNMYldvQTFzc2tEUkEwK0xnT0lSTHlpaGVnajljb2ZN?=
 =?utf-8?B?dnVpdjY2TlZrRWo2cHd4SjhJQWMvZkltK1hucEwxeHZJVUQxNEQ4ZUdsQ1k3?=
 =?utf-8?B?VGUyY21Kb0dEZTRkVzFDekg3VDVHbDNXQnI2cldKSytNQTBlMWFxQ1o5a1Jy?=
 =?utf-8?B?aEVaZ3cvaWVmbDByRktPVXZrQndKdGZnYlRmdWFLWTlqYU9UdVdwNFBBak5B?=
 =?utf-8?B?aGhyM0VkNnNWaW0xb1B2NUFLWlJHc1JCeXZSNnFWb0QrN3QxU2lHSmMyeE9v?=
 =?utf-8?B?Yjl4QjNqei8rOXhrRmdXZ2dqOFRGVTFuNG9vS3BldWxVNjVORGxVMGNLZGxF?=
 =?utf-8?B?SVhEOEFQSzVCVW1qVWF2aFpUZjBEaG1ZcjRtZS9wbnpWU0srdmwrck90dVhX?=
 =?utf-8?B?L05zOHVDSVN1eXgxRldOQ2xqS3FacFRqeDkyeE5mRmZNcnBFZU9SY0xEeTVp?=
 =?utf-8?B?YmdtQ01FOVZrVHVJNHljUGdQUnZXa1J4MjZZVXlMd2V3ektReFdWbEViMzVU?=
 =?utf-8?B?MlREVHo3QUROOUQzUEtZQTUvODNIU2hBMEVPa0Z2UU9LM1BFcFFrdVl4VnE1?=
 =?utf-8?B?d0tZdWdySFYzQlN4M2JFd3pBZTFrQis2UGsyaG91Qm13N0d2Zzg2ZzMwVmZ1?=
 =?utf-8?B?RGszZDJMZGRvTm5GcC92MjRzSWs3ZjdmNkhrRG0yQ1pSK3kxVjhCd1NZM1Zv?=
 =?utf-8?B?TEdIZ0hrUzZ0V01Rdlp3bitOaWN2RzdLZHF4alJHRzZ3V1l3WmxKZGlEelVh?=
 =?utf-8?B?VVJ6NXU0dTh3OC9wVG9yNHRkUGFBdmxaZm9UdVQ2Y1hwTnhVVHk1aTRyWDh2?=
 =?utf-8?B?NFFKOFo1dHdXajh6dHcyZWl1MmFPczJkVDlCVTVKcDNWd2huUTB2YzJBSW82?=
 =?utf-8?B?ek5JUWNxSUtwaHFCa2lUK0x0ZElXcWJLK0dPNVU0OXVUWllMMFdvRTJ5S2dq?=
 =?utf-8?B?cFpFSFdjVTJOYUZUenovV051V1p4dFdlNVBraXRNOW9QQUZQUTBMK09Zakl3?=
 =?utf-8?B?TlE2Ujc1Sk5QNDhCQnJIbVNYU2Z4Uk5hWm4xUmJWRmp0RXcwVGY5bWZXSnFH?=
 =?utf-8?B?ZzlXZXhkN3VnazFpL0lXd09aL2Y5TFRycUoyYUpROHdLdmFINWFtUDJUSExD?=
 =?utf-8?B?djduUFVEMGx6akhXcFRHT3ZEV0diWStNQnNQQmRsd0xYeVRhVEVqYThUclZD?=
 =?utf-8?B?RDlRYmdSZ2JRb1d1LzU1S0pubjFMWUVzVVFLRGxkOUQrdEdjYk1odnZpbXBY?=
 =?utf-8?B?OWRNdXcxM1VOVWVNeTVkeGZ2VDh1Y3lLdytQWlhwai9XUWJBcHV6QTU4QmNl?=
 =?utf-8?B?dTM5TXhhV3NrbnVGbjlTMm9JLzFnWlJSMEgyL2N5VGJNL1VVSDZleHRtd25N?=
 =?utf-8?B?MGMvcG9qSkJqRVhkN1ArUGo0OWxSam45b3p6VFhReHRaeWpNRFM4b05IcmJj?=
 =?utf-8?B?RjVFOUpMRzRCbUp0SzJmRE1iN1JRejJpbHQ2Zlk3V3ltTGY0bm4xSEtwaENJ?=
 =?utf-8?B?c0QzaU93V0hqSEFrQkdSM3NOZVo4VU5VQVZpSlRTR3ozR1JmZjBYbVdxaUhZ?=
 =?utf-8?B?dWQ3Nmp1UVJScjFmZ3NNTWxQZTBnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <804F272D6A24CE499E7EB4F2CC0E0676@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Z1MH+2ih0iR14Bs4rQ/14GpuxVxXnS11ANzRnH67JNZ5iSvsBcJh0jx6cLkM4ffnot7hfJ8yEnVEiigmu7AHroEJYaxUYemrIaahZb3u2z8IFwgciPvBPj2myzjD2r64/yUoBbFjfNeKfFTwUMAVhml9WD/TqqDlZU2s7Pn8cWuTpf2Ky4kMhDeswwYPyOi5bTnBq5PMfBTYLHKY+hAdITHvPVxkHzaSTwF2pWTbxQUPIGujjqn9/hfKiX2iaY16aO0xIW/CGvUAQtffJ4zH91qLISl2TY6LCDa5GDZJfEhhkr2c939Rze/aIV08VbTzJM/fCc1kcddGlPyRzR4graVvUVO4wwuJMazHBytbUnvBvQ/VzhL27oX5s1WQYiiHKF9DoWKBRHWt6rSlXsIRQbpPUDMZZdMd8Lx+boiInAMhcuXAvF1fM72Y4AltlFHcAxInwMDH61KY6TXvHqbZQzVweSt3MFIj7EYlN64UH+vhd+fbJIbnAk1ZxLmUCWjJ395T8l4Y9OePdEZGbYsK1ONYG13dZRAkE6ElAI9aXjhkn5jkgGIOxmV2mvaiU0rKDkIUMGmnAb+Sly5c67Nx4R4TWqhy5njxwc2wD3nAA60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e78d9dc2-314c-432f-8ba3-08dbfd905649
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2023 17:07:36.7266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hHBq2WKwJGZbnSz1VKuz+Te9Zk89z0lsNpTDtQ+lU7gIIe2U0Fm7Xw1Gj/8G2VccJzYTwrNUYQk3z4GrrCFkuB15ip+BFmdKeG5lbm5Axpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-15_10,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312150119
X-Proofpoint-ORIG-GUID: Jtc9AILjRey7abzy4zF_2Unqn0Vurz6B
X-Proofpoint-GUID: Jtc9AILjRey7abzy4zF_2Unqn0Vurz6B

DQoNCj4gT24gRGVjIDE0LCAyMDIzLCBhdCA3OjE14oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIERlYyAxNCwgMjAyMyBhdCAwMToz
NTowMlBNIC0wODAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6DQo+PiBPbiBUaHUsIERlYyAxNCwg
MjAyMyBhdCAwOTowNToyMUFNIC0wODAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+Pj4gQmFja2dy
b3VuZDoNCj4+PiBXZSBoYXZlIHRoZSBleGlzdGluZyB4ZnNfZnNyIHRvb2wgd2hpY2ggZG8gZGVm
cmFnbWVudCBmb3IgZmlsZXMuIEl0IGhhcyB0aGUNCj4+PiBmb2xsb3dpbmcgZmVhdHVyZXM6DQo+
Pj4gMS4gRGVmcmFnbWVudCBpcyBpbXBsZW1lbnRlZCBieSBmaWxlIGNvcHlpbmcuDQo+Pj4gMi4g
VGhlIGNvcHkgKHRvIGEgdGVtcG9yYXJ5IGZpbGUpIGlzIGV4Y2x1c2l2ZS4gVGhlIHNvdXJjZSBm
aWxlIGlzIGxvY2tlZA0KPj4+ICAgZHVyaW5nIHRoZSBjb3B5ICh0byBhIHRlbXBvcmFyeSBmaWxl
KSBhbmQgYWxsIElPIHJlcXVlc3RzIGFyZSBibG9ja2VkDQo+Pj4gICBiZWZvcmUgdGhlIGNvcHkg
aXMgZG9uZS4NCj4+PiAzLiBUaGUgY29weSBjb3VsZCB0YWtlIGxvbmcgdGltZSBmb3IgaHVnZSBm
aWxlcyB3aXRoIElPIGJsb2NrZWQuDQo+Pj4gNC4gVGhlIGNvcHkgcmVxdWlyZXMgYXMgbWFueSBm
cmVlIGJsb2NrcyBhcyB0aGUgc291cmNlIGZpbGUgaGFzLg0KPj4+ICAgSWYgdGhlIHNvdXJjZSBp
cyBodWdlLCBzYXkgaXTigJlzIDFUaUIsICBpdOKAmXMgaGFyZCB0byByZXF1aXJlIHRoZSBmaWxl
DQo+Pj4gICBzeXN0ZW0gdG8gaGF2ZSBhbm90aGVyIDFUaUIgZnJlZS4NCj4+PiANCj4+PiBUaGUg
dXNlIGNhc2UgaW4gY29uY2VybiBpcyB0aGF0IHRoZSBYRlMgZmlsZXMgYXJlIHVzZWQgYXMgaW1h
Z2VzIGZpbGVzIGZvcg0KPj4+IFZpcnR1YWwgTWFjaGluZXMuDQo+Pj4gMS4gVGhlIGltYWdlIGZp
bGVzIGFyZSBodWdlLCB0aGV5IGNhbiByZWFjaCBodW5kcmVkcyBvZiBHaUIgYW5kIGV2ZW4gdG8g
VGlCLg0KPj4+IDIuIEJhY2t1cHMgYXJlIG1hZGUgdmlhIHJlZmxpbmsgY29waWVzLCBhbmQgQ29X
IG1ha2VzIHRoZSBmaWxlcyBiYWRseSBmcmFnbWVudGVkLg0KPj4+IDMuIGZyYWdtZW50YXRpb24g
bWFrZSByZWZsaW5rIGNvcGllcyBzdXBlciBzbG93Lg0KPj4+IDQuIGR1cmluZyB0aGUgcmVmbGlu
ayBjb3B5LCBhbGwgSU8gcmVxdWVzdHMgdG8gdGhlIGZpbGUgYXJlIGJsb2NrZWQgZm9yIHN1cGVy
DQo+Pj4gICBsb25nIHRpbWUuIFRoYXQgbWFrZXMgdGltZW91dCBpbiBWTSBhbmQgdGhlIHRpbWVv
dXQgbGVhZCB0byBkaXNhc3Rlci4NCj4+PiANCj4+PiBUaGlzIGZlYXR1cmUgYWltcyB0bzoNCj4+
PiAxLiByZWR1Y2UgdGhlIGZpbGUgZnJhZ21lbnRhdGlvbiBtYWtpbmcgZnV0dXJlIHJlZmxpbmsg
KG11Y2gpIGZhc3RlciBhbmQNCj4+PiAyLiBhdCB0aGUgc2FtZSB0aW1lLCAgZGVmcmFnbWVudGF0
aW9uIHdvcmtzIGluIG5vbi1leGNsdXNpdmUgbWFubmVyLCBpdCBkb2VzbuKAmXQNCj4+PiAgIGJs
b2NrIGZpbGUgSU9zIGxvbmcuDQo+Pj4gDQo+Pj4gTm9uLWV4Y2x1c2l2ZSBkZWZyYWdtZW50DQo+
Pj4gSGVyZSB3ZSBhcmUgaW50cm9kdWNpbmcgdGhlIG5vbi1leGNsdXNpdmUgbWFubmVyIHRvIGRl
ZnJhZ21lbnQgYSBmaWxlLA0KPj4+IGVzcGVjaWFsbHkgZm9yIGh1Z2UgZmlsZXMsIHdpdGhvdXQg
YmxvY2tpbmcgSU8gdG8gaXQgbG9uZy4gTm9uLWV4Y2x1c2l2ZQ0KPj4+IGRlZnJhZ21lbnRhdGlv
biBkaXZpZGVzIHRoZSB3aG9sZSBmaWxlIGludG8gc21hbGwgcGllY2VzLiBGb3IgZWFjaCBwaWVj
ZSwNCj4+PiB3ZSBsb2NrIHRoZSBmaWxlLCBkZWZyYWdtZW50IHRoZSBwaWVjZSBhbmQgdW5sb2Nr
IHRoZSBmaWxlLiBEZWZyYWdtZW50aW5nDQo+Pj4gdGhlIHNtYWxsIHBpZWNlIGRvZXNu4oCZdCB0
YWtlIGxvbmcuIEZpbGUgSU8gcmVxdWVzdHMgY2FuIGdldCBzZXJ2ZWQgYmV0d2Vlbg0KPj4+IHBp
ZWNlcyBiZWZvcmUgYmxvY2tlZCBsb25nLiAgQWxzbyB3ZSBwdXQgKHVzZXIgYWRqdXN0YWJsZSkg
aWRsZSB0aW1lIGJldHdlZW4NCj4+PiBkZWZyYWdtZW50aW5nIHR3byBjb25zZWN1dGl2ZSBwaWVj
ZXMgdG8gYmFsYW5jZSB0aGUgZGVmcmFnbWVudGF0aW9uIGFuZCBmaWxlIElPcy4NCj4+PiBTbyB0
aG91Z2ggdGhlIGRlZnJhZ21lbnRhdGlvbiBjb3VsZCB0YWtlIGxvbmdlciB0aGFuIHhmc19mc3Is
ICBpdCBiYWxhbmNlcw0KPj4+IGRlZnJhZ21lbnRhdGlvbiBhbmQgZmlsZSBJT3MuDQo+PiANCj4+
IEknbSBraW5kYSBzdXJwcmlzZWQgeW91IGRvbid0IGp1c3QgdHVybiBvbiBhbHdheXNjb3cgbW9k
ZSwgdXNlIGFuDQo+PiBpb21hcF9mdW5zaGFyZS1saWtlIGZ1bmN0aW9uIHRvIHJlYWQgaW4gYW5k
IGRpcnR5IHBhZ2VjYWNoZSAod2hpY2ggd2lsbA0KPj4gaG9wZWZ1bGx5IGNyZWF0ZSBhIG5ldyBs
YXJnZSBjb3cgZm9yayBtYXBwaW5nKSBhbmQgdGhlbiBmbHVzaCBpdCBhbGwNCj4+IGJhY2sgb3V0
IHdpdGggd3JpdGViYWNrLiAgVGhlbiB5b3UgZG9uJ3QgbmVlZCBhbGwgdGhpcyBzdGF0ZSB0cmFj
a2luZywNCj4+IGt0aHJlYWRzIG1hbmFnZW1lbnQsIGFuZCBjb3B5aW5nIGZpbGUgZGF0YSB0aHJv
dWdoIHRoZSBidWZmZXIgY2FjaGUuDQo+PiBXb3VsZG4ndCB0aGF0IGJlIGEgbG90IHNpbXBsZXI/
DQo+IA0KPiBIbW1tLiBJIGRvbid0IHRoaW5rIGl0IG5lZWRzIGFueSBrZXJuZWwgY29kZSB0byBi
ZSB3cml0dGVuIGF0IGFsbC4NCj4gSSB0aGluayB3ZSBjYW4gZG8gYXRvbWljIHNlY3Rpb24tYnkt
c2VjdGlvbiwgY3Jhc2gtc2FmZSBhY3RpdmUgZmlsZQ0KPiBkZWZyYWcgZnJvbSB1c2Vyc3BhY2Ug
bGlrZSB0aGlzOg0KPiANCj4gc2NyYXRjaF9mZCA9IG9wZW4oT19UTVBGSUxFKTsNCj4gZGVmcmFn
X2ZkID0gb3BlbigiZmlsZS10by1iZS1kZnJhZ2dlZCIpOw0KPiANCj4gd2hpbGUgKG9mZnNldCA8
IHRhcmdldF9zaXplKSB7DQo+IA0KPiAvKg0KPiAgKiBzaGFyZSBhIHJhbmdlIG9mIHRoZSBmaWxl
IHRvIGJlIGRlZnJhZ2dlZCBpbnRvDQo+ICAqIHRoZSBzY3JhdGNoIGZpbGUuDQo+ICAqLw0KPiBh
cmdzLnNyY19mZCA9IGRlZnJhZ19mZDsNCj4gYXJncy5zcmNfb2Zmc2V0ID0gb2Zmc2V0Ow0KPiBh
cmdzLnNyY19sZW4gPSBsZW5ndGg7DQo+IGFyZ3MuZHN0X29mZnNldCA9IG9mZnNldDsNCj4gaW9j
dGwoc2NyYXRjaF9mZCwgRklDTE9ORVJBTkdFLCBhcmdzKTsNCj4gDQo+IC8qDQo+ICAqIEZvciB0
aGUgc2hhcmVkIHJhbmdlIHRvIGJlIHVuc2hhcmVkIHZpYSBhDQo+ICAqIGNvcHktb24td3JpdGUg
b3BlcmF0aW9uIGluIHRoZSBmaWxlIHRvIGJlDQo+ICAqIGRlZnJhZ2dlZC4gVGhpcyBjYXVzZXMg
dGhlIGZpbGUgbmVlZGluZyB0byBiZQ0KPiAgKiBkZWZyYWdnZWQgdG8gaGF2ZSBuZXcgZXh0ZW50
cyBhbGxvY2F0ZWQgYW5kIHRoZQ0KPiAgKiBkYXRhIHRvIGJlIGNvcGllZCBvdmVyIGFuZCB3cml0
dGVuIG91dC4NCj4gICovDQo+IGZhbGxvY2F0ZShkZWZyYWdfZmQsIEZBTExPQ19GTF9VTlNIQVJF
X1JBTkdFLCBvZmZzZXQsIGxlbmd0aCk7DQo+IGZkYXRhc3luYyhkZWZyYWdfZmQpOw0KPiANCj4g
LyoNCj4gICogUHVuY2ggb3V0IHRoZSBvcmlnaW5hbCBleHRlbnRzIHdlIHNoYXJlZCB0byB0aGUN
Cj4gICogc2NyYXRjaCBmaWxlIHNvIHRoZXkgYXJlIHJldHVybmVkIHRvIGZyZWUgc3BhY2UuDQo+
ICAqLw0KPiBmYWxsb2NhdGUoc2NyYXRjaF9mZCwgRkFMTE9DX0ZMX1BVTkNILCBvZmZzZXQsIGxl
bmd0aCk7DQo+IA0KPiAvKiBtb3ZlIG9udG8gbmV4dCByZWdpb24gKi8NCj4gb2Zmc2V0ICs9IGxl
bmd0aDsNCj4gfTsNCj4gDQo+IEFzIGxvbmcgYXMgdGhlIGxlbmd0aCBpcyBsYXJnZSBlbm91Z2gg
Zm9yIHRoZSB1bnNoYXJlIHRvIGNyZWF0ZSBhDQo+IGxhcmdlIGNvbnRpZ3VvdXMgZGVsYWxsb2Mg
cmVnaW9uIGZvciB0aGUgQ09XLCBJIHRoaW5rIHRoaXMgd291bGQNCj4gbGlrZWx5IGFjaGVpdmUg
dGhlIGRlc2lyZWQgIm5vbi1leGNsdXNpdmUiIGRlZnJhZyByZXF1aXJlbWVudC4NCj4gDQo+IElm
IHdlIHdlcmUgdG8gaW1wbGVtZW50IHRoaXMgYXMsIHNheSwgYW5kIHhmc19zcGFjZW1hbiBvcGVy
YXRpb24NCj4gdGhlbiBhbGwgdGhlIHVzZXIgY29udHJvbGxlZCBwb2xpY3kgYml0cyAobGlrZSBp
bnRlciBjaHVuayBkZWxheXMsDQo+IGNodW5rIHNpemVzLCBldGMpIHRoZW4ganVzdCBiZWNvbWVz
IGNvbW1hbmQgbGluZSBwYXJhbWV0ZXJzIGZvciB0aGUNCj4gZGVmcmFnIGNvbW1hbmQuLi4NCg0K
DQpIYSwgdGhlIGlkZWEgZnJvbSB1c2VyIHNwYWNlIGlzIHZlcnkgaW50ZXJlc3RpbmchDQpTbyBm
YXIgSSBoYXZlIHRoZSBmb2xsb3dpbmcgdGhvdWdodHM6DQoxKS4gSWYgdGhlIEZJQ0xPTkVSQU5H
RS9GQUxMT0NfRkxfVU5TSEFSRV9SQU5HRS9GQUxMT0NfRkxfUFVOQ0ggd29ya3Mgb24gYSBGUyB3
aXRob3V0IHJlZmxpbmsNCiAgICAgZW5hYmxlZC4NCjIpLiBXaGF0IGlmIHRoZXJlIGlzIGEgYmln
IGhvbGUgaW4gdGhlIGZpbGUgdG8gYmUgZGVmcmFnbWVudGVkPyBXaWxsIGl0IGNhdXNlIGJsb2Nr
IGFsbG9jYXRpb24gYW5kIHdyaXRpbmcgYmxvY2tzIHdpdGgNCiAgICB6ZXJvZXMuDQozKS4gSW4g
Y2FzZSBhIGJpZyByYW5nZSBvZiB0aGUgZmlsZSBpcyBnb29kIChub3QgbXVjaCBmcmFnbWVudGVk
KSwgdGhlIOKAmGRlZnJhZ+KAmSBvbiB0aGF0IHJhbmdlIGlzIG5vdCBuZWNlc3NhcnkuDQo0KS4g
VGhlIHVzZSBzcGFjZSBkZWZyYWcgY2Fu4oCZdCB1c2UgYSB0cnktbG9jayBtb2RlIHRvIG1ha2Ug
SU8gcmVxdWVzdHMgaGF2ZSBwcmlvcml0aWVzLiBJIGFtIG5vdCBzdXJlIGlmIHRoaXMgaXMgdmVy
eSBpbXBvcnRhbnQuDQoNCk1heWJlIHdlIGNhbiB3b3JrIHdpdGggeGZzX2JtYXAgdG8gZ2V0IGV4
dGVudHMgaW5mbyBhbmQgc2tpcCBnb29kIGV4dGVudHMgYW5kIGhvbGVzIHRvIGhlbHAgY2FzZSAy
KSBhbmQgMykuDQoNCkkgd2lsbCBmaWd1cmUgYWJvdmUgb3V0Lg0KQWdhaW4sIHRoZSBpZGVhIGlz
IHNvIGFtYXppbmcsIEkgZGlkbuKAmXQgcmVhbGxpemUgaXQuDQoNClRoYW5rcywNCldlbmdhbmcN
Cg0K
