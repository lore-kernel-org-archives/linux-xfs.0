Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49E8C6FD20
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Mar 2023 21:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCUVOt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCUVOs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 17:14:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F72833445;
        Tue, 21 Mar 2023 14:14:47 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LKxrVT011944;
        Tue, 21 Mar 2023 21:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=FW2DGEUlpBFed7ZKaHQKpaqUZa+sNSU4jlAWL7u8wqA=;
 b=gl55p9qdlUv8L1ZGNgjvTmdZxG5BTHSZ+0uX8K7x+cNE48eEIBpj772e6aVKMc5iZOiG
 Jl7tHJEb5zgBEKkTQrADgTk28MrofSz5uHM6Whxa0xMYD97yTCEdcL4CYvu40nUNjLNq
 nRtaPgfpDJ7OB1NPqXOqVVgFlSdxC5dwM/F1qw1N9/ISDYEZCb6F4cH6BI8kmjXUzgnK
 sU9hDTtJxl8EOQt8eqdfnnvjgxca3g11DHEO8SPm3oLcEr50rgJgotFrb+1oew16KGqc
 TfF+SJrEekNvxpPJmA88dzUcTueRh3zVaWMg5xx0SsnzNa+HW0vWg0p9XMxfGuzONtZo Jw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bcfj05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 21:14:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LKreB0029648;
        Tue, 21 Mar 2023 21:14:42 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pfm130rqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 21:14:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSy30U1VSO6CE3H7hlXzjLBZal5KZsDyd6JfmzdNbugHV7TqaaQW+pVg0upaS45ChM0EkaYmBqxYl67kUcBMfDk+1yLFN9JgvVuZOGATz8AQ2lgxAGvTGPSpB669c2L72b1AB7InwcYANnrDfvsHPynLOJKXZxYPX0D2aYdzNnr6OPquGW+YGvpGdpEylywyYf9o7Lv9F5FhKkqAciWeY1n93X9Cyz68vsdtLGe/c5jw81Z80+w7YwccTaK8Pp7GpcV5qiD1hAUmoQ5up4xZqrjrwb5qB7QBWIee0aIreISfzZfM1N+a+43pc7tZNRB5C+OBl+5fstOQ6wxmzRW7dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FW2DGEUlpBFed7ZKaHQKpaqUZa+sNSU4jlAWL7u8wqA=;
 b=iOYNhjoTV4C3yMCyc27xcImhTsrekZ0/5GNG6SYC3x1VtjYhO27GSfiH7QW6PekD/h5sn7mcfHKX8j3wRrckKDMZcMCJ/1OB50TxsKDuFPqs20pBp1p/cO6o0CYrgxwIGtviBnSPfdFc0eMJhF0t7caQ1WXC60yatGV3A2YszcSMtqlt+LdRFKtE70rmPk2k8JKCvztTigKE7AU/UWkPvBsAU6qgbf5EVTbXPrrZjdXvwWzUaOguCczeHlaqU2Q6lbx4hKCd07q8MnWM26t5bMMXg+uixP8HjTAje0uA/Ye/utHojlncV22Dwx21p0ymJgUFpnpIFn/hYmlLRO4Twg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FW2DGEUlpBFed7ZKaHQKpaqUZa+sNSU4jlAWL7u8wqA=;
 b=QO6J68//VOG86YhwLbbxBaB598SoDGe3S4pNBZGX2Pa3RXFJCt6CG9XfdECzFiRzwUEaxZh4m6UBJCt+9NRwHUPNifCZk5gy7vhjJaRFj9l/SBmeUD4xjMBSKDmqxdqGKOB7X8BBHyTAgS8Cj9F56VbB3HNoBQ5hlTMCbw/4C+I=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5101.namprd10.prod.outlook.com (2603:10b6:5:3b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 21:14:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 21:14:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "djwong@kernel.org" <djwong@kernel.org>
CC:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Thread-Topic: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Thread-Index: AQHZWDi40PleEnagskq+ctjQXWYsi67/VpsAgABOFICABh8qgA==
Date:   Tue, 21 Mar 2023 21:14:39 +0000
Message-ID: <f571048601445a05043a79ac502261618945376b.camel@oracle.com>
References: <20230316185414.GH11394@frogsfrogsfrogs>
         <776987d7caf645996bea6cdb43ac1530f76c91d1.camel@oracle.com>
         <20230317234533.GR11376@frogsfrogsfrogs>
In-Reply-To: <20230317234533.GR11376@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|DS7PR10MB5101:EE_
x-ms-office365-filtering-correlation-id: 99a969a9-1207-41e7-143c-08db2a514882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pYlMt0UlPBJr4429qjUv0Y1/Wcka1z2rIzG0Z1ddkFxXHW6Is09wzgnKecneoTKzDqaM8JIhJM5kzTvfiziC8oqayA5sZBCiz48RN+kmklHhQ9KVCsw3p9Lbu6Lt/zKEEnwGok+oSm0QuXiYU20yY3jNekxgxlgKE0Qs5/VRuVxjllcSdpBcgy0oXv0CqrTz1l9cHwLOX7CJyEg1Q24IISP4/QGZ9QKVVRlPAc70up1NYnmOoAbhBRIQerjs8ZPYzwo+Va7l0Sqot0JhYmjOk4TSXkpZxA3rgTZa641d9Q1hNCoT/2arllwPp22zSJtxuSKZA91AYCIkxJYR6V3qhg48wDxwFnAje4fUMR3lFIsTOFE9styv1sBFA3TaDWytueA2NlyzMD5ouAJzS1fkJTiGZk+huXwhaZhMnZka4ZmeHyZxgRFy6GpG4AmStxv7yGkH/1HmIHizJ4eHS/mqbpVlbiYWmji7Gnz9kX2PN1CKk82HgBSIQb39W8b9jgA0+PxWX3WKB4lJHuWo0/k0C5dCOgwWGiuoyNBTv+QU9+ZNVl53wZxAm3HD0jPquc9nW3yzWo1OE1XQkIqAIa4DnxzS8PG/p4TvBMhK1BDqmfnSJWf4Uh3FXN6E6GeuSkmapCLFD++QrZaArT8d1GaT32BYXkrdkKfJB+CZ7BrelkcXJ6u9utU3Skh8Kwn/oDDYoS2kCZLNlYDV5xHSm9PZHOsmMiLYfamIDleeczAdkSOwJx/FTE8Xese9gkz/dmfaVcq95IDqplgKByGckZ1IVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(366004)(346002)(39860400002)(376002)(451199018)(66899018)(2616005)(83380400001)(6512007)(71200400001)(54906003)(478600001)(26005)(5660300002)(966005)(6486002)(186003)(6506007)(316002)(122000001)(86362001)(38100700002)(38070700005)(66946007)(41300700001)(76116006)(44832011)(8936002)(64756008)(2906002)(36756003)(66476007)(6916009)(66556008)(66446008)(8676002)(4326008)(130860200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0hkQXh6bW4wbm9nRGNvaXpLOGpUVW5nWE10eEhPOVIwa3k4RHhVRy9XR3BB?=
 =?utf-8?B?M0Z4R2ZXYVo4MVhWMjJXMnRBc3ZOTmNhN0pVQUpQVGZIZVdOb1lDODVOMWgz?=
 =?utf-8?B?S2xDL3J2YkY1YjNVOEV3M1FrZlZzMWJJZ3pUZUxPeU1hd2wreEFhVEJYb281?=
 =?utf-8?B?NURsQXhHTDhzQ2pPVXY5NktrRzlJM2k0bnRKa09PU1FraVV3TW1aNTZncGJj?=
 =?utf-8?B?eVRDNVcveHBkVXZnNytsYnE4cUhaYWZ2aFBxUE9hdW9NbGh3OHlKRncwQko3?=
 =?utf-8?B?N1lxQ1ZPVmRBWjNoZVRWZTF5SXpzS1F6UTFraEp4SFg2Rnh6cTBsUlBqY3ls?=
 =?utf-8?B?TjcyOXdaTEZpWTQ0bXkrUWFVSkVXMVp3Tzh4d1U0SHpQYS9vVW1LZWkrbGFH?=
 =?utf-8?B?UE1OUlNRVnJSMTJZQitJa3ZDbmVzNGUvanMvTkp0cThXQldxRVcxUkdZUmV5?=
 =?utf-8?B?dExCSUVUMXN0Y3N4RVpHVmVQYTk4MlN6RVIrK1ByT0xrKzNVUWhnV3UrWG9P?=
 =?utf-8?B?ZmF0SEE5c1N4bFFVOUhYMzBDZk1CNUxFdU5UeUZkWG4ra2lobHl4b0UwaExj?=
 =?utf-8?B?bXd3RGFDVUxuU2hSZ1hDL0wrbFpQem53aU5TNUozL245eXFFeWNaMUpseGtw?=
 =?utf-8?B?U2trRm1VUGVsTDNKdVNzWS9VWGFXQk0zeTRVeXdDWlFuYm5VMG53dGNTd09P?=
 =?utf-8?B?SUE4OEt0OStkL0cwZWFoMXRyV0VhRFptcHY0WFNLaWZ2REFrb2t2MmdZa0ox?=
 =?utf-8?B?RlRhNUxLRXhZZ0RWSGlpajVWeGpEd2NEbm1aQUxabkJKOGdVZjVNTFhOYkdx?=
 =?utf-8?B?RU5oOUFSbnVIYkhtUzZWMVZoUllDYURpOGR3N3U0R2U4RmNBeDI1eTM4Vm55?=
 =?utf-8?B?eHBmVEI2a2NMTyt4dmdPMFVkSS93TERvYXNlNFV4c2lzRzhuOHdEUHZUVmxn?=
 =?utf-8?B?YzVqMlRyYTRFTVlkL2ZUNERSTS9qRExNM3BMV041WnJDR2RielMwa2IwUGpT?=
 =?utf-8?B?RlNTWi9CK0xmaklucWdpbG0xcUJjc0oxb1hNVSt5RFlOQzhQM3RyMmE0WFY5?=
 =?utf-8?B?bDExZWJPdGJGUkEzKytVRDZKU2hZY2VkU3hUSTQzT29nZ3EyOFFxTXVoM3lQ?=
 =?utf-8?B?cjlPc1VSZFlTZk9ndXZQWHVaWHhXSzdoMDBxMDR0ajVaN2IvU29pMTVGTDhB?=
 =?utf-8?B?Sk51K0VjZkNScWIzZ0pVTFlocUVmZ2hKZEVKeDd4aUU2MjdhelR5eXNYMFhk?=
 =?utf-8?B?Q0xSYnF4d3loWE1TZENSUmxBb2hpNCtWTEc3QXZzbjNlU09iK2EzOUhHSERr?=
 =?utf-8?B?MDRoaGlpdWRBaDJ3ODdyY1phYzRieGNKNzF2ZE5KTDd1VUhpMmNBQWgrMXVj?=
 =?utf-8?B?LytUS2puR1k3WWhSMmx1L0JaRGxWN29RbUtrVFExeGdmNG43Z2hrMTY2L2Rj?=
 =?utf-8?B?cG03Z254V1NGT3JnODRFN1pLWmJoU0pZUU1PbUUwcWJObUhUMjZpVURVbHFJ?=
 =?utf-8?B?TTNaekJROHluTGVnYWRlMkdUdFR5aEtaMlZ3R0diNVJlUFU3VmtQZm1mRWs2?=
 =?utf-8?B?SlRGNktwQXAzSmM5c0lnL3dXc0RtbkQrS1JjRmJ2V1BCdXRlRUR5THMyQTNp?=
 =?utf-8?B?c3k4VUNOMS81SXFrZCtPRW1JYUFramNvWTNrSkxJaTNURWVmeDZCZkdSelpV?=
 =?utf-8?B?eHQ3Ulo1TkliZ051Z2tNdUpqeEQyM0RndDdDMGI5RDBOZFR4TXl4OWtDNVln?=
 =?utf-8?B?K0ZwenN4K1c2OXk0TWVKellBTmxWampNQytSall3QXQwUTl3QlpoeTMxcWNu?=
 =?utf-8?B?c1BOVXZXVWlYMW1uaWE5N0tXN2dmSnlZam03cGtrNG0rd3dZWEl1MCtSckFL?=
 =?utf-8?B?UGVBZW1YU0dHdTNINDR2aCtDckJWSHFlZEg2SVpxdDU3RHBGdmg1eFZhaHpt?=
 =?utf-8?B?OGJnei9zbmJtUDBpNnpTQ2NCdW92dzMzTkNKYnlLa0w5TUFITVBNMHlzT2xM?=
 =?utf-8?B?VjBpcU5xeXBJaWpkZHd1amtCYVhJOFFSRW9Ud2xQc1BUY3dQUWhtRUIrSzYv?=
 =?utf-8?B?UTE2TE04Zkp2cTBZVW4rSnBHV2M5c0VTREluN1B2M0pCZTQrTFd1R3NkRzRC?=
 =?utf-8?B?N3c3WWdja0lBZUFsMjMwY29JdkhXeXdGblJwVjFkK1JodTRCYUx2SnFoWVg0?=
 =?utf-8?Q?Yc6Yzb86O4l1OMb9opaNrIY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5051F9D493DE547AB3808EFF84B445C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Isx5AubUHtlIQi+z4YlP4tnwSKKZ1GHO5Vjo8tROfLbXeZidvucXh20btUTUeYUxPpOCsKIgiM2++SAY05pedpidGxqtidco9Opo8MJZ/Ad/EXotKVwub0Q4zUEq0aBo3BEJMIosWJwa6qfQ8KFkIrlwzFDjQlOnPqu4UGsSy2XsS+VC6UIwcn0Nm+h19HZ71cDuJi9GUh+m1iGgpFL3JvFv6HBLTks3WBvYmmeLCz6wNqECUPcsLwAHbSR9UIVPKryYq5LOVpUpMpk4WHkKpWO8AlOXzXQkTpU++H3JhqpIZN2hRSLeRWatonYPvwvp8dNyuMoJTPmBMgmkTrxJadXCn/e9XYW5XqejBOfks5wMbbd4D6ik+en9XBPNcyJhezwoWkwimHzmpubbVy3b+LPI+B3Y7Lr1JTUYJAafGTW1xPkj7SWHfzxOXiNCvdoPJC7Hj6KkWGTnbnKi92cw5Q2PrgU946PPZEBbGMIaAmAtWk7QvrhPI9+Spc/5iUGf3lc3CKjejZEAL0JA2z6FpdpphENtISrP8r0OvYDS86kXB5dB2ztK0hGC8S61Hd9ekibPQdTrXS0IRjHsuWift0Vgm4/IpbVdR6rIdXbQT1vud/LE9Wmk6ecfjO4+afyg4+dEJXg0kU04FMzVkeV7xy5ZiuvD5AYTz1ivLI+oYQhuZ26HpkuHZz3SCClsRc1cWIJ7RU3WVWdOK+aYhps7BhtjY4XNIJpydQpR6dq0gO2KEF/05rKaGaMPIExE/D4c1y+anUG8DBW/67uZeS4PPLI48F8GnDDmastGX2FFj44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a969a9-1207-41e7-143c-08db2a514882
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 21:14:39.9633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZlpsaVNYHQLIq3J5mB80BwTVEJSPCWGGliXh+CQkL/zqmuvGjDeWCnQK84L41XWajtGKvJLI561YboLboHXXF9YxGyzHj6ObhSPNoB9tVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5101
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210168
X-Proofpoint-ORIG-GUID: buBhPPt6dwiSRYaspusTPaNaSCOW7NAF
X-Proofpoint-GUID: buBhPPt6dwiSRYaspusTPaNaSCOW7NAF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTE3IGF0IDE2OjQ1IC0wNzAwLCBEYXJyaWNrIEouIFdvbmcgd3JvdGU6
DQo+IE9uIEZyaSwgTWFyIDE3LCAyMDIzIGF0IDA3OjA2OjA3UE0gKzAwMDAsIEFsbGlzb24gSGVu
ZGVyc29uIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyMy0wMy0xNiBhdCAxMTo1NCAtMDcwMCwgRGFy
cmljayBKLiBXb25nIHdyb3RlOg0KPiA+ID4gSGkgZXZlcnlvbmUsDQo+ID4gPiANCj4gPiA+IFRo
aXMgZGVsdWdlIGNvbnRhaW5zIGFsbCBvZiB0aGUgYWRkaXRpb25zIHRvIHRoZSBwYXJlbnQgcG9p
bnRlcnMNCj4gPiA+IHBhdGNoc2V0IHRoYXQgSSd2ZSBiZWVuIHdvcmtpbmcgc2luY2UgbGFzdCBt
b250aCdzIGRlbHVnZS7CoCBUaGUNCj4gPiA+IGtlcm5lbA0KPiA+ID4gYW5kIHhmc3Byb2dzIHBh
dGNoc2V0cyBhcmUgYmFzZWQgb24gQWxsaXNvbidzIHYxMCB0YWcgZnJvbSBsYXN0DQo+ID4gPiB3
ZWVrOw0KPiA+ID4gdGhlIGZzdGVzdHMgcGF0Y2hlcyBhcmUgbWVyZWx5IGEgcGFydCBvZiBteSBk
ZXZlbG9wbWVudCB0cmVlLsKgIFRvDQo+ID4gPiByZWNhcA0KPiA+ID4gQWxsaXNvbidzIGNvdmVy
IGxldHRlcjoNCj4gPiA+IA0KPiA+ID4gIlRoZSBnb2FsIG9mIHRoaXMgcGF0Y2ggc2V0IGlzIHRv
IGFkZCBhIHBhcmVudCBwb2ludGVyIGF0dHJpYnV0ZQ0KPiA+ID4gdG8NCj4gPiA+IGVhY2gNCj4g
PiA+IGlub2RlLsKgIFRoZSBhdHRyaWJ1dGUgbmFtZSBjb250YWluaW5nIHRoZSBwYXJlbnQgaW5v
ZGUsDQo+ID4gPiBnZW5lcmF0aW9uLA0KPiA+ID4gYW5kDQo+ID4gPiBkaXJlY3Rvcnkgb2Zmc2V0
LCB3aGlsZSB0aGXCoCBhdHRyaWJ1dGUgdmFsdWUgY29udGFpbnMgdGhlIGZpbGUNCj4gPiA+IG5h
bWUuDQo+ID4gPiBUaGlzIGZlYXR1cmUgd2lsbCBlbmFibGUgZnV0dXJlIG9wdGltaXphdGlvbnMg
Zm9yIG9ubGluZSBzY3J1YiwNCj4gPiA+IHNocmluaywNCj4gPiA+IG5mcyBoYW5kbGVzLCB2ZXJp
dHksIG9yIGFueSBvdGhlciBmZWF0dXJlIHRoYXQgY291bGQgbWFrZSB1c2Ugb2YNCj4gPiA+IHF1
aWNrbHkNCj4gPiA+IGRlcml2aW5nIGFuIGlub2RlcyBwYXRoIGZyb20gdGhlIG1vdW50IHBvaW50
LiINCj4gPiA+IA0KPiA+ID4gdjEwcjFkMiByZWJhc2VzIGV2ZXJ5dGhpbmcgYWdhaW5zdCA2LjMt
cmMyLsKgIEkgc3RpbGwgd2FudCB0bw0KPiA+ID4gcmVtb3ZlDQo+ID4gPiB0aGUNCj4gPiA+IGRp
cm9mZnNldCBmcm9tIHRoZSBvbmRpc2sgcGFyZW50IHBvaW50ZXIsIGJ1dCBmb3IgdjEwIEkndmUN
Cj4gPiA+IHJlcGxhY2VkDQo+ID4gPiB0aGUNCj4gPiA+IHNoYTUxMiBoYXNoaW5nIGNvZGUgd2l0
aCBtb2RpZmljYXRpb25zIHRvIHRoZSB4YXR0ciBjb2RlIHRvDQo+ID4gPiBzdXBwb3J0DQo+ID4g
PiBsb29rdXBzIGJhc2VkIG9uIG5hbWUgKmFuZCogdmFsdWUuwqAgV2l0aCB0aGF0IHdvcmtpbmcs
IHdlIGNhbg0KPiA+ID4gZW5jb2RlDQo+ID4gPiBwYXJlbnQgcG9pbnRlcnMgbGlrZSB0aGlzOg0K
PiA+ID4gDQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgKHBhcmVudF9pbm8sIHBhcmVudF9nZW4sIG5h
bWVbXSkNCj4gPiA+IA0KPiA+ID4geGF0dHIgbG9va3VwcyBzdGlsbCB3b3JrIGNvcnJlY3RseSwg
YW5kIHJlcGFpciBkb2Vzbid0IGhhdmUgdG8NCj4gPiA+IGRlYWwNCj4gPiA+IHdpdGgNCj4gPiA+
IGtlZXBpbmcgdGhlIGRpcm9mZnNldHMgaW4gc3luYyBpZiB0aGUgZGlyZWN0b3J5IGdldHMgcmVi
dWlsdC7CoA0KPiA+ID4gV2l0aA0KPiA+ID4gdGhpcw0KPiA+ID4gY2hhbmdlIGFwcGxpZWQsIEkn
bSByZWFkeSB0byB3ZWF2ZSBteSBuZXcgY2hhbmdlcyBpbnRvIEFsbGlzb24ncw0KPiA+ID4gdjEw
DQo+ID4gPiBhbmQNCj4gPiA+IGNhbGwgcGFyZW50IHBvaW50ZXJzIGRvbmUuIDopDQo+ID4gPiAN
Cj4gPiA+IFRoZSBvbmxpbmUgZGlyZWN0b3J5IGFuZCBwYXJlbnQgcG9pbnRlciBjb2RlIGFyZSBl
eGFjdGx5IHRoZSBzYW1lDQo+ID4gPiBhcw0KPiA+ID4gdGhlDQo+ID4gPiB2OXIyZDEgcmVsZWFz
ZSwgc28gSSdtIGVsaWRpbmcgdGhhdCBhbmQgZXZlcnl0aGluZyB0aGF0IHdhcyBpbg0KPiA+ID4g
QWxsaXNvbidzDQo+ID4gPiByZWNlbnQgdjEwIHBhdGNoc2V0LsKgIElPV3MsIHRoaXMgZGVsdWdl
IGluY2x1ZGVzIG9ubHkgdGhlIGJ1Zw0KPiA+ID4gZml4ZXMNCj4gPiA+IEkndmUNCj4gPiA+IG1h
ZGUgdG8gcGFyZW50IHBvaW50ZXJzLCB0aGUgdXBkYXRlcyBJJ3ZlIG1hZGUgdG8gdGhlIG9uZGlz
aw0KPiA+ID4gZm9ybWF0LA0KPiA+ID4gYW5kDQo+ID4gPiB0aGUgbmVjZXNzYXJ5IGNoYW5nZXMg
dG8gZnN0ZXN0cyB0byBnZXQgZXZlcnl0aGluZyB0byBwYXNzLg0KPiA+ID4gDQo+ID4gPiBJZiB5
b3Ugd2FudCB0byBwdWxsIHRoZSB3aG9sZSB0aGluZywgdXNlIHRoZXNlIGxpbmtzOg0KPiA+ID4g
aHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2Rqd29uZy94ZnMtbGludXguZ2l0L2xvZy8/aD1wcHRycy1kcm9w
LXVubmVjZXNzYXJ5X187ISFBQ1dWNU45TTJSVjk5aFEhTW5rQmJ5REtFZGdRaVhMZm1YWjg3dVRf
al9UQXRRSEhBMVVyYVBmMDFvcDZ3TnBSWmtrMnRnNUNYcnU0ZUw2LXB6SnlVbC11SkFabFNyR1d3
REZwJA0KPiA+ID4gwqANCj4gPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kandvbmcveGZzcHJvZ3Mt
ZGV2LmdpdC9sb2cvP2g9cHB0cnMtZHJvcC11bm5lY2Vzc2FyeV9fOyEhQUNXVjVOOU0yUlY5OWhR
IU1ua0JieURLRWRnUWlYTGZtWFo4N3VUX2pfVEF0UUhIQTFVcmFQZjAxb3A2d05wUlprazJ0ZzVD
WHJ1NGVMNi1wekp5VWwtdUpBWmxTbWpPaDZYNyQNCj4gPiA+IMKgDQo+ID4gPiBodHRwczovL3Vy
bGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvZGp3b25nL3hmc3Rlc3RzLWRldi5naXQvbG9nLz9oPXBwdHJzLW5hbWUtaW4tYXR0
ci1rZXlfXzshIUFDV1Y1TjlNMlJWOTloUSFNbmtCYnlES0VkZ1FpWExmbVhaODd1VF9qX1RBdFFI
SEExVXJhUGYwMW9wNndOcFJaa2sydGc1Q1hydTRlTDYtcHpKeVVsLXVKQVpsU2x1bE9odUokDQo+
ID4gPiDCoA0KPiA+ID4gDQo+ID4gPiBBbGxpc29uOiBDb3VsZCB5b3UgcGxlYXNlIHJlc3luYyBs
aWJ4ZnMgaW4gdGhlIGZvbGxvd2luZyBwYXRjaGVzDQo+ID4gPiB1bmRlcg0KPiA+ID4gaHR0cHM6
Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vZ2l0aHViLmNvbS9hbGxpc29uaGVuZGVyc29u
L3hmc3Byb2dzL2NvbW1pdHMveGZzcHJvZ3NfbmV3X3BwdHJzX3YxMF9fOyEhQUNXVjVOOU0yUlY5
OWhRIU1ua0JieURLRWRnUWlYTGZtWFo4N3VUX2pfVEF0UUhIQTFVcmFQZjAxb3A2d05wUlprazJ0
ZzVDWHJ1NGVMNi1wekp5VWwtdUpBWmxTcWlYYTN4TiQNCj4gPiA+IMKgDQo+ID4gPiBwbGVhc2U/
DQo+ID4gPiANCj4gPiA+IHhmc3Byb2dzOiBhZGQgcGFyZW50IHBvaW50ZXIgc3VwcG9ydCB0byBh
dHRyaWJ1dGUgY29kZQ0KPiA+ID4geGZzcHJvZ3M6IGV4dGVuZCB0cmFuc2FjdGlvbiByZXNlcnZh
dGlvbnMgZm9yIHBhcmVudCBhdHRyaWJ1dGVzDQo+ID4gPiB4ZnNwcm9nczogcGFyZW50IHBvaW50
ZXIgYXR0cmlidXRlIGNyZWF0aW9uDQo+ID4gPiB4ZnNwcm9nczogcmVtb3ZlIHBhcmVudCBwb2lu
dGVycyBpbiB1bmxpbmsNCj4gPiA+IHhmc3Byb2dzOiBBZGQgcGFyZW50IHBvaW50ZXJzIHRvIHJl
bmFtZQ0KPiA+ID4geGZzcHJvZ3M6IG1vdmUvYWRkIHBhcmVudCBwb2ludGVyIHZhbGlkYXRvcnMg
dG8geGZzX3BhcmVudA0KPiA+ID4gDQo+ID4gPiBUaGVyZSBhcmUgZGlzY3JlcGFuY2llcyBiZXR3
ZWVuIHRoZSB0d28sIHdoaWNoIG1ha2VzDQo+ID4gPiAuL3Rvb2xzL2xpYnhmcy0NCj4gPiA+IGRp
ZmYNCj4gPiA+IHVuaGFwcHkuwqAgT3IsIGlmIHlvdSB3YW50IG1lIHRvIG1lcmdlIG15IG9uZGlz
ayBmb3JtYXQgY2hhbmdlcw0KPiA+ID4gaW50bw0KPiA+ID4gbXkNCj4gPiA+IGJyYW5jaGVzLCBJ
J2xsIHB1dCBvdXQgdjExIHdpdGggZXZlcnl0aGluZyB0YWtlbiBjYXJlIG9mLg0KPiA+IFN1cmUs
IHdpbGwgcmVzeW5jLCBhcyBJIHJlY2FsbCBzb21lIG9mIHRoZW0gaGFkIHRvIGRldmlhdGUgYSBs
aXR0bGUNCj4gPiBiaXQNCj4gPiBiZWNhdXNlIHRoZSBjb3JyZXNwb25kaW5nIGNvZGUgYXBwZWFy
cyBpbiBkaWZmZXJlbnQgcGxhY2VzLCBvcg0KPiA+IG5lZWRlZA0KPiA+IHNwZWNpYWwgaGFuZGxp
bmcuDQo+IA0KPiBPaywgdGhhbmsgeW91LsKgIEl0J3MgZWFzaWVyIHRvIGRldmVsb3AgeGZzcHJv
Z3MgY29kZSB3aGVuIGxpYnhmcyBjYW4NCj4gYmUNCj4ga2VwdCBpbiBzeW5jIGVhc2lseS4NCg0K
SGVyZSBpcyBhIHJlc3luYywgc29tZSBvZiB0aGVtIHN0aWxsIG5lZWRlZCBoYW5kIHBvcnRpbmcs
IGJ1dCBpdCBsb29rcw0KbGlrZSBpdCBzeW5jJ2QgdXAgYSBsb3Qgb2Ygd2hpdGUgc3BhY2Ugc28g
bGV0IG1lIGtub3cgaWYgdGhpcyBjbGVhcnMgdXANCnRoaW5ncyBmb3IgeW91DQpodHRwczovL2dp
dGh1Yi5jb20vYWxsaXNvbmhlbmRlcnNvbi94ZnNwcm9ncy90cmVlL3hmc3Byb2dzX25ld19wcHRy
c192MTByMQ0KDQpBbGxpc29uDQoNCj4gDQo+ID4gT3JpZ2luYWxseSBteSBpbnRlbnQgd2FzIGp1
c3QgdG8gZ2V0IHRoZSBrZXJuZWwgc2lkZSBvZiB0aGluZ3MNCj4gPiBzZXR0bGVkDQo+ID4gYW5k
IGxhbmRlZCBmaXJzdCwgYW5kIHRoZW4gZ3JpbmQgdGhyb3VnaCB0aGUgb3RoZXIgc3BhY2VzIHNp
bmNlDQo+ID4gdXNlcg0KPiA+IHNwYWNlIGlzIG1vc3RseSBhIHBvcnQuwqAgSSB3YXMgdHJ5aW5n
IHRvIGF2b2lkIHNlbmRpbmcgb3V0IGdpYW50DQo+ID4gZGVsdWdlcyBzaW5jZSBwZW9wbGUgc2Vl
bWVkIHRvIGdldCBodW5nIHVwIGVub3VnaCBpbiBqdXN0IGtlcm5lbA0KPiA+IHNwYWNlDQo+ID4g
cmV2aWV3cy4NCj4gDQo+IFllYWgsICd0aXMgdHJ1ZSB0aGF0IHNlbmRpbmcgeGZzcHJvZ3MgbGli
eGZzIHBhdGNoZXMgcHJlbWF0dXJlbHkgaXMNCj4ganVzdA0KPiBub2lzZSBvbiB0aGUgbGlzdC4g
Oi8NCj4gDQo+IFRoYXQgc2FpZCwgdGhlIGNsb3NlciBhIHBhdGNoc2V0IGdldHMgdG8gZmluYWwg
cmV2aWV3LCB0aGUgdGlkaWVyIHRoZQ0KPiB4ZnNwcm9ncyBwYXJ0IG91Z2h0IHRvIGJlLsKgIEkn
dmUgYWRkZWQgc3VwcG9ydCBpbiByZXBhaXIgYW5kIHRoZQ0KPiBkZWJ1Z2dlciwgd2hpY2ggbWVh
bnMgdGhpcyBpcyAvdmVyeS8gY2xvc2UgdG8gaXRzIGZpbmFsIHJldmlldy4NCj4gDQo+IC0tRA0K
PiANCj4gPiBUaGFua3MgZm9yIGFsbCB0aGUgaGVscCB0aG8uDQo+ID4gDQo+ID4gQWxsaXNvbg0K
PiA+IA0KPiA+ID4gDQo+ID4gPiAtLUQNCj4gPiANCg0K
