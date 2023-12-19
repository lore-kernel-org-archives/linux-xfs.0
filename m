Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80DA3D0A7
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 22:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SKmNmkKO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Jcut/uYe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJLdD3V005709;
	Tue, 19 Dec 2023 22:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ZCBvdGxOKSH5X9csgrrw9C2jXa2nu5uKOW5Rf/o626g=;
 b=SKmNmkKONLjvxYNBjb7ss0psAXwFs0GkZcdiyW0dqf0TXQERTopXHfRgs6ezoEX6foeS
 RthwCrxQvrETUDAQkcDegPOEukrhWDrWkls9MwbSVclncW5iyLz8h96g8mHYePHzwIX2
 FiPaEaHd4/mO7hnIA36T4Aq/GAYzNOCEf5Txi7fV5WyNh63JI8JGm6wJ7PlA3trg9Ola
 eFeJIBUUDekcimx5NopyHq7WR4V8KI7/kATxfiO2pSjT+GfX428ArEYU/1C1EMOEtEO0
 CI7BM2bJp6/ig/OLo21lWXUAcn7sEnPSzP+zR2SmOBkQWWYkU4BrWqmslPQusiEf1ZCA fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3v12g2f42d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 22:23:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJKkQsR027530;
	Tue, 19 Dec 2023 22:23:44 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3v12bdm79e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 22:23:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkTGvsXwHhD2Ou0t0wRoHpj1qoc3/R2zWiQ5vsHGDJ8i2NPm+ashlMj5Wn7GNS9FGz987LVzpBXsr/VoVvZun9kHuqWPSNvQYcur+kFFQjrDtqkfeT9f1TAkzc007xxxClO9/OL4x+BNH8OXfxaoiwmQberWAsHlZpeY+pUCgCQvoT/JLlZw0oVVwfL0rr7Uj9DZc4+MY2bTIBSV6Ae4Tu5xcbf05eVoCmFTAiZxeZEan6IauUgKWNl05BHuzctizB0IzBhz93A0hUKEatjur0LIzkuaqoPp0MzInLhc/wn8pxW3TVxkldzgKbaag5nhNQMzQYFgeRJOQGu8QnOd5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCBvdGxOKSH5X9csgrrw9C2jXa2nu5uKOW5Rf/o626g=;
 b=OxsT+FR+J0okUz0GlcluA+usIaPI20HCFY9mFlZA5JnkXZV13vb/EdqgaMiXJvuNsFm2dAZm09Vnd+vMDdrR50oO3YJXyDsGQ8FmIBEKZYlBhu3Sxj0sXvbFv09A47STNMDykkcxc3Z7KrI1mwilLX6Kf8VNebpWqUTwcvca9sNWQUZAnoG+y0KHrk1NaPxwu98DdzlbmWJZdrW8ljfFcv79U3T0F7f0lJxtbPO96OUk/kEssBQhQ/t6uRkh7+/pSU6l9ir7EQ8A7yKgW/R2F5GADoPTvatTI1BcHq9XGAu8Axp0/Kv7BsDgWWlJRPTxK/Pcedfpu3dgfUoNlfZOvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCBvdGxOKSH5X9csgrrw9C2jXa2nu5uKOW5Rf/o626g=;
 b=Jcut/uYeXbbep7sbRKQL127ykaUjNh6/AgJ+xqtssM285tfZ5OiqOmsn7W4+6gSAqEBZPfQiq1tT8nZGvU/e54D9g6JEQhNxG9aL+vRPVbnj7pnGtdSbV8x1SN5ypLHg9vwW65L8xPgRub3NsiPS9fJs1/R4LiP7nc6br7F/u34=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by PH0PR10MB7100.namprd10.prod.outlook.com (2603:10b6:510:28b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 22:23:04 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::ad52:5366:bcf1:933d%3]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 22:23:04 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Topic: [PATCH 0/9] xfs file non-exclusive online defragment
Thread-Index: 
 AQHaLq/DBPQjWKfW/0yGGD6NwG60UrCpTWoAgABe/wCAAOiSAIAANdGAgAR17ICAAeNngIAAA1IAgAAPAIA=
Date: Tue, 19 Dec 2023 22:23:04 +0000
Message-ID: <54663D29-4900-47CC-8756-CFFA43DE6C7A@oracle.com>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
 <ZXy08z140/XsCijh@dread.disaster.area>
 <D074B518-2C9E-4312-AC31-866AABE1A668@oracle.com>
 <6480D0D9-7105-41CB-8B6D-1760DE26DDE4@oracle.com>
 <ZYILKEu7c/R5zY1S@dread.disaster.area>
In-Reply-To: <ZYILKEu7c/R5zY1S@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.200.91.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|PH0PR10MB7100:EE_
x-ms-office365-filtering-correlation-id: 9d9837a7-3d49-4d52-05e8-08dc00e11180
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 hCztaCZV5/DKye+D7wXjC6c8ibqVLako9SSKkzC/I3GSb3+Rj5iy+zRq0pnSWhBEW0RiRwd1mMRNgS3fIPAtymVx+c//VX6DoaUguNXsBnVd09bAHn88pqu1KGoXJXxBoW/pY50FR6kotwLgIhhIRRcEdm5uB3cC1CVntLhazyWDoAY0Gt9BU5AmZFYEc8NQbqDCv/5fooQRVe6x3LwYa6bX1nueDcJoDkes1Y/C5fGB7IQtVgt+pis7aS4wvoJfrMNh2XTSMlAKzjm9Okhy1nkeMzzLKPPWMUiwGbNEx5bfBFDsPjJBvmNWxLhqRFkrDP8IhcFpzgYrzHalHFpOMZ4aYr/d/BRLqCzRnOd2TnD3qXvzAuL7n1Q4rPlG4F9XxkdNIIOfgQD7DacGuuet2zO9HGROkGATAyZcNuU45RIMfxo2Hq/U/ttSb9v9TfH1IANRrTfWd7JcDRu5BX4agdt+K5B47sPZYsnvorHmO7v2I/2Q6XQ61WbGBI/0yV0EyYMXXL68Nlu58bCOfTuvEqUZk5WX/rdATRZYw4byYJLXa77hWhtfEE51yDk7ga7PUI1ptW5FnSH7r+FDV1wZukeL7LQgbI9dux9xkC3fJMe1Cbemno/MUw9y79c/b45G0J3Vhy+4sXcjrEDUNHXb3w==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(366004)(396003)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(36756003)(38070700009)(66946007)(66556008)(6916009)(316002)(66476007)(91956017)(66446008)(4744005)(54906003)(76116006)(64756008)(122000001)(8676002)(4326008)(8936002)(38100700002)(5660300002)(71200400001)(6512007)(2906002)(53546011)(6506007)(6486002)(478600001)(86362001)(2616005)(26005)(41300700001)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?aHRhdkwwcldBU0daTURuYkhmNzdjUHgyVyt5Zm9nTjl2VEkvOXJoZ0ZFOVdm?=
 =?utf-8?B?TldySHRaQ1QzcmZGMExYT1RoanZIc3JXSFovMS9ZSjZscDBzWmlIQ2hVT3hR?=
 =?utf-8?B?S0N0MjlDUzcrU2FCUWVqQlJhNUdaL3NGa0RScERjREZBalFDQWpDV3YwME91?=
 =?utf-8?B?N2lXT1VId1lhZkVvbDFQL2VzSXVGVUhMRGFRZjhDNXlQeEc0L1kzaTR3ZS95?=
 =?utf-8?B?Ym9NbHBTUDh0UG9qYzErR0VoNVlqUFJ2YXgvTGNGanlNWHhBOWZZSWVieUQz?=
 =?utf-8?B?cUJsWjJRS2h5dGc0NU1qY3VHREljck9PYVZhV2srZFhhckhEbTVWai9hZWx3?=
 =?utf-8?B?d0NUVFBEOC9JRVF6TUFtQ2dxaGw3WFRJM29namJuRUxuU09wTUZ4R3g5a1Q3?=
 =?utf-8?B?OVBhSU9GOXZIQWxxN3dFUVV1VkFlWGJlZi8zWnBJT211L1o5SjArcFVGUm1a?=
 =?utf-8?B?RXFlRWEzcFFBN2kvK3dLSEVXTDg2Q1FkbGZqUmVFblQ1aVFuSmNaNjlWdTZR?=
 =?utf-8?B?c0ZBOTJ5U1IvM0N2NldmdDBDd25jTlEyQ3lFVWJRbitXV0NDV29oMFBMQW5o?=
 =?utf-8?B?YmpoZm9YNnFHbkpXL2NaTHd5VTc1WWhmRDc1ME9pc3oyb2lXYnZ0Z0dWTWE1?=
 =?utf-8?B?UHVzVDdGZ3Q0SW1BcmZqalJQUEZvVUVwNUtnb2tYSmZ4a255QlBLNjRLQy9U?=
 =?utf-8?B?U0kraWkxNjEvMWJCTnRpcWYrL290VmZoSDQyMzkxWGxWR0ZJUndSeVZkR0kv?=
 =?utf-8?B?bEI5ZU9Ub3U5ZFA0KzFWT3BjTXN6cURqSW94WTh6QUhoclRFNzQzdm1VenQx?=
 =?utf-8?B?YU9YM3JsdUIwVlNhUUJJN2toRndCVHJweWZVQmpETEYvS0h1OGFONnJ2Tm9s?=
 =?utf-8?B?MWtZSWhCaHdsalBINUtlbWc4bGNwTWFYblJuWDJveklORE5oVVNzcDM2ZnlH?=
 =?utf-8?B?OUpSTFhITHZndmtOZTVudU1Ta0JKOEYxT09NYWFnb3lsTmJRV3YwendQalpa?=
 =?utf-8?B?WXlOd0hVOU8xQ2dzTUk2QjJIbnFhcEo0bGxJQkxjMmhMbG1wSU0rMW40aFI4?=
 =?utf-8?B?UjU3UkFJaGJTRGJ3N3J0VEtkVVB1QURvaUF2QkJiZm5SOFNzbXVabCtDaVpa?=
 =?utf-8?B?OGUybjhSd011TUQ2SHVOU2dSS1hSQWpFeWN1VlEwUkkwa3QwaVRuZWlVN05w?=
 =?utf-8?B?NWZ4Mi94b0w1YzY1cTNpd3pxOEFOcEpVczZjbjJMMFVOSmthZXV2SlNIYTJF?=
 =?utf-8?B?RUxzUnBNY2pzVUxKcW45Zk82WFNld0hLazh5MmhCV1c4TThCSDdFNEloYmtP?=
 =?utf-8?B?K1NJdDNWd1F1aTFFNEJ0a0ZQblo5TTEwdVlUZTI0dndVeWNRWXhhR0VmR2FU?=
 =?utf-8?B?ek9LRlJtN2x2N3k1UGdkT0VHTUdqejVneEtIaUhVTVBIY3U1RXdSNVlPd21z?=
 =?utf-8?B?M2RwcEhJcEd2OVFxOEdzRzQ1Wk5XS1l5aFNXRzdyK0tvamRoWjdhdVVUMmQ3?=
 =?utf-8?B?TG0xNDNDMzRaZ2twdXZLSlV0ejRZZWthSHZZcUJISk82RzFLSDFFZHc2bEEr?=
 =?utf-8?B?b2lsV3F2VjFaU1NRRHBDMmZSelc5ZTRRMDVOYmM4amc0YWh0TURWYkpmYWpB?=
 =?utf-8?B?SnBBZXk0VlJNa0Q1eElaZGRnam9KdnV4T3B6N3FVSWEzQUpiV2pTbG1wdFhR?=
 =?utf-8?B?YVBmYUxQQ29pTFhhZVNSZXlIbXBwcTBEcUVHaDR2YUt6bzkrcXZCeUdkL09y?=
 =?utf-8?B?RGV6QTZmZzBEMXZXVUtEcUxYdGFEeCtSaVVWM3NJVnhsU3VlQUxsQlgyWVhT?=
 =?utf-8?B?cEFERzg3cUVjdmJKYmFYd09aZktOejU3WEgvZHhsenl5UEIwK0VrV2xKbDgv?=
 =?utf-8?B?ZFpqL3dRL1NVajRjNFNDYzRSUVllS1NWZ2dzTm91S3dQSHdhMjYvbTVwQVk2?=
 =?utf-8?B?c2JsMk0yUVNFYmhPZmw3U3UzdHlXemxVT3lYS0R5QXNnQWVrUUhIbXp3aTA2?=
 =?utf-8?B?NzA2RFVJQUNZMjhsQjF4WkFQZENMY3hwclFzM0RnU1RLZVRqZE93R0hlZk5C?=
 =?utf-8?B?OVBHWlZiWFYyc2p2NEdleGFrN0pZMlZaK1YxU01CQktHdklzZjZ1dGZ1c29M?=
 =?utf-8?B?T1R6VTFsaVpqblNMdHBnUERxNFNRb1pNTTMwNkVzMU9wYkV6S3B2dWdDdkZY?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BDC9D5F775BD446BAC773195F73E26D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tmcWhXEK/uR/58V/DGA3O25pI1W2MjdRkSzwQytzcNJczH33Fj3g9oY5kKnfAv2hIJTWdtoeenbK+pAEqDw5/NXGjjIRrdks4Er+FVyl58B5tCCWpFyNZjU0yn64HoJwBgkf6+BrUZ0uaU8eVecSX0SrnXQHcvwxJZCftruW4AZ+Mdf9DbEzzVpK+EDrUec4kI2oMDrchyuHeogUY2g6vLWMHT8Ad01NN1QenIqlkywH70Elg1sWBxEC1K6BsPJjUwqARgOCxZnFvoFM5H/FS8nJ7CtlvpiyyOirRzIbbplfxxBXh5Aqz1LE8ihEMkRM1a0cAg8S+NP/lFcjGO7275288wb4IHd3bFzJMHOfREDZRj0yrQw/ezC3ENjtn38rTDYARFKZ+c+Z3PQif5GwgUwBQSSeD/tfnNWcCYhvfO4nosP2qeH/YJL8UKxTpAC4CoWL3bYYx5/3ejqv2O+2UEr6VPCKQuCVCZfOJ6bjQfOq02xU9EQsbXc1EryQa+bGMEb64RAtf6ek6k+sO2xpEuAnjPfQmvhhWpD5eAlFT548LIntKBYVkQ2Ovq39myK+aDVXnaebC1LNZG8+L7/a1YNCU1aEWFLnbHuYoSMoITU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9837a7-3d49-4d52-05e8-08dc00e11180
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2023 22:23:04.0647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zFESI6izk2cZEpeDknQLRxsce8m0AIzYvnm092oR/4YRN1fD6sRvUrSO8L/l3Nd/OKd3btdTwwEU2k2yIbPCfn7jqQzPtsL5MObQuPctrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7100
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_13,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=934 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312190166
X-Proofpoint-GUID: Iw5v61YEqleEK4zjjsfsW_pF7lAnQVfH
X-Proofpoint-ORIG-GUID: Iw5v61YEqleEK4zjjsfsW_pF7lAnQVfH

DQoNCj4gT24gRGVjIDE5LCAyMDIzLCBhdCAxOjI54oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIERlYyAxOSwgMjAyMyBhdCAwOTox
NzozMVBNICswMDAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBIaSBEYXZlLA0KPj4gWWVzLCB0
aGUgdXNlciBzcGFjZSBkZWZyYWcgd29ya3MgYW5kIHNhdGlzZmllcyBteSByZXF1aXJlbWVudCAo
YWxtb3N0IG5vIGNoYW5nZSBmcm9tIHlvdXIgZXhhbXBsZSBjb2RlKS4NCj4gDQo+IFRoYXQncyBn
b29kIHRvIGtub3cgOikNCj4gDQo+PiBMZXQgbWUga25vdyBpZiB5b3Ugd2FudCBpdCBpbiB4ZnNw
cm9nLg0KPiANCj4gWWVzLCBpIHRoaW5rIGFkZGluZyBpdCBhcyBhbiB4ZnNfc3BhY2VtYW4gY29t
bWFuZCB3b3VsZCBiZSBhIGdvb2QNCj4gd2F5IGZvciB0aGlzIGRlZnJhZyBmZWF0dXJlIHRvIGJl
IG1haW50YWluZWQgZm9yIGFueW9uZSB3aG8gaGFzIG5lZWQNCj4gZm9yIGl0Lg0KPiANCg0KR290
IGl0LiBXaWxsIHRyeSBpdC4NCg0KVGhhbmtzLA0KV2VuZ2FuZw0KDQo=
