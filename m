Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B227CC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 21:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiKKVgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiKKVgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 16:36:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C136417;
        Fri, 11 Nov 2022 13:36:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLYveD030173;
        Fri, 11 Nov 2022 21:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CsodGAV8Z8elqtAIMlQo4/lCWUlfVvTdiOSLznAvMhI=;
 b=qo3IS1MzOT1waulXdMsubCQ3l+forIKGPwtTWC3qZaNOrcvJHte0ssxcuNf6PX+k7g7B
 3/5vKSMAwKMMRkr5YTmoNA7mChia67XIJi0PfwfG+RYb25E/x3wPaoAvhSbSVDiUbh8U
 2tNqdFNp2LuBsAHeWlT4sgQfbpiZSRXcMozO4kM6taST6QrmFAFLV6ONU6cbYoBge0rJ
 HuGQZtiGdad6A+8MUh5eWQ9u8GoOMrSEVo1waWovjUAI0O9+tSK3o+06WNSMSk9NST72
 DMkUMDWaL0nZ7Bb9Sy2Agusr+xiXNH7VA5tnXFlljjWp2oG2TfmtwpoU1+gjJAEBukFr 9g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksxea804h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:36:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABKon0G021280;
        Fri, 11 Nov 2022 21:31:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsjf23n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:31:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWSJc7ZupYH0QeF+Uh8i10H3IX5NfIUFES8dxF1/FjgdLobriuMJUZ6MSHmqzRYPe6ma64Da82ugDCKwYC01UVjskXmoYjKckmZkfXJyswVUwumzHNtPR7KVVebcXLBDXg+WLN6M+GHHBrBu294xk4MMnySe/CWBnEC8+wTnkPz1VsPnxgvnAQsN8ZT/g6ulGMFmsyztpNVYqfvDFXT6uBfZE6PfiauMaqxXnE3bAPXdkm4nnzOXJGVplSsYL6YiqkJkVr8RYpXKhzITK9yQoe00c3sPR+k0QXZUXPfTuX3ap1mDz3JyrwJ2jvZpXpjRSouiWs5TQhA4LwjHV+4NgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsodGAV8Z8elqtAIMlQo4/lCWUlfVvTdiOSLznAvMhI=;
 b=WDFfZxbGO8ub6bKaSwTFsMwhLHhsc9CcHMfVJ1tbsMPuWynkbvGCvyI+6p1ujqxAqX5qRia8j7OgRrDbbthg8PHfpy5x/9KCSMme3M+qQ5yGMSe45Vm500IGcPCztwbQ6a4ferT4kts1UkKGpECIFYV3yd+8GqvwVw5aUWlBRGSKyQ61iZQyRImLbKe1jXCBxwVNYAcftbUcXCTiMxS+jYh0STRGvBScHGJGtN3I7mMHvdkTcnOUibF4p+670u6KqWwhEJDIM7ryuMZiL42qElcBtkhAu1DksTIZVK5M7uhF+EOEEbhXLB17ewcKk7O67aUDY0zaksp2f2rO0UrAtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsodGAV8Z8elqtAIMlQo4/lCWUlfVvTdiOSLznAvMhI=;
 b=dg/sg0FQkedTgV+IMaxUSCm2EFugVCfrI+RGwPgzrVkOkF/TzuLykWjROhOl9AzSQkMjjjlvk1TuQudFhQfzjIPiuUDHH+NcR4cWR0QGbZNDJmoRtl4Awc0PBaIRfxCmLljNoGonAdKNOoF9Oa9it9tO78sgCsiLGwTfVPEY+uQ=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 21:31:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 21:31:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Thread-Topic: [PATCH v1] xfstests: test xfs_spaceman fsuuid command
Thread-Index: AQHY9JDzxJG8qWqsNUaNzqqd9uE1GK46QNkA
Date:   Fri, 11 Nov 2022 21:31:42 +0000
Message-ID: <c46cc760f74bf4e3bc2c25683dfd7fc89f7cef2b.camel@oracle.com>
References: <20221109222630.85053-1-catherine.hoang@oracle.com>
In-Reply-To: <20221109222630.85053-1-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH7PR10MB6652:EE_
x-ms-office365-filtering-correlation-id: c1dc4f01-8ee9-45e0-231c-08dac42c203d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9QTWtzU1m41uJ5rLEW58zSIeekAyi+s0i4zC6w+nhYyA69FaJZ6CPUm6qxiBsQeijMnMF5J3VDwFvLehmXL/auvGpdV1IgjxJGxoUQRvjNkR4yQtiqOuTG1zkxUOA3avBqUAu6YpHwTpFtJ+CrKSqER+ybPVLzPNXqELnlQ/3JAR2cUL9TsvMh+JUSCRq2nfiLFa7bO68ODAIezxwO+hT5ydyxQD/T8l3Ns5BlH1PIuiThz/PFoC+R+AS3kbWBjiODCaXpLvOHKN1NPO6HRwss7+fR/1YqAjg08W1T0JFp/FMw/chWxfGS5jmg06NHnpYgyX9ywPoX/0voTeIt6tRjDgYTXU3SNnPAjk9iAUAjHRLBdySayjQCGge3vHVro3I7+J2WH/E1/UOLJvWAN7SH2BkktmiMVbOWDyHofhY33rlqH6L8IC8f6+r/a9uKU32jP/zK29NI1k9ATLsdPaA4D6dLDXRN84o5JAkKaa4b6QzPIMznKb9rpGpf4bi1xX2c+gHsrvmr9pmG6oxKCpX/wF1UbzDaKU3ffUdxTdQFmjSptq4MOjXa8n5EP9EPt51OADriB8yA8GytNDqxUxOjfb7wdks3lQsnOJelGTqKp/wQHq+RsKYz+SvPG5YA3z2lzWst4yCvGwN0Cto3T4uhJxQ0BkvYLJJqckOpoJ18LZ5UneqntbAqqGKhUvM7bmmiNT+bK1KbIchvM1YES+9ClojckNGdw0soO5z+WWa7pHQ1jIm2UHPs4LmwHU6TQRnJVF/rS2NtRs3X/A5S86RA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(186003)(6512007)(110136005)(26005)(38100700002)(122000001)(83380400001)(71200400001)(6506007)(2906002)(44832011)(2616005)(76116006)(316002)(478600001)(5660300002)(6486002)(41300700001)(450100002)(8936002)(66446008)(8676002)(64756008)(66476007)(66556008)(66946007)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1BBZHhLOXVqUUNYSks1RVFrbmY5UFY4SUZ6czdhVldoUlVSajEyV0hGTEM4?=
 =?utf-8?B?eXFka1RiOUxHdWZTcnpRbldxaVNqaDBXZWFaa0VsVVZHSmlEQ1pmL0JVYjF3?=
 =?utf-8?B?OHJ2bkxiVjM0RUFybGFXa213NHR2QkJxSjE2M3ZKMzRPNDdEUmU2d0M1Q3lG?=
 =?utf-8?B?OVJPa3NOYW96L2VEUG1iSXl0UHA1ekdmalN3NVhudVZudDdvV3BiKzVnaEpP?=
 =?utf-8?B?bkNrOEpncHJUeEY0SlNNR0x0eVZxNUtZNWkwQ0JCdVBhbUU2Wlh5RFdoUFNZ?=
 =?utf-8?B?M1NkcE1VQUJqMTV1L0I1ejNteWF4ZkE5QTdUY2RCS0Y3TmpmRjdEU0M5SnMx?=
 =?utf-8?B?bGRJL25aS1VXek91alZZRjBraUhPMVRzUHJDWTJQUzh0SThmM1NBSnNGY083?=
 =?utf-8?B?WDdLT2NRWVdValhmbklTTERPUWJxN2QzS2g1RTdicFRHS21ZN2s0SGgvbE8r?=
 =?utf-8?B?dmNDbG1NdXhDbzJRZnlhODRIS1RlS1BQOVRqb1Q4WThocysrWnN0M3Fqc0to?=
 =?utf-8?B?R0FaWWc3ZVV5Q3B6dlJRVlMxVjN5RTlueGdpaFhUeXlkZzdra0xsWXZHbzBv?=
 =?utf-8?B?VE51eWJiOHlwb0Fjd0kxR2VNQTFFN283MTV1THZVaTlXeTlIK2x4bG8xV1Fs?=
 =?utf-8?B?YjVoczg1YjZBRU8ydG83aVhCdndnM1JtVzdlM1VQRGhGdW45eTQreStkUEp0?=
 =?utf-8?B?UDRZWUp5UFNQZS9tQm5BTlR6dng1MERlUXVXUXIvckxjRkJHMENJeEt3dVE2?=
 =?utf-8?B?STRrWHNsS3ZXaTQ2ZnYreTdsbC9GUWp3b2ZtZ2haOXJEVnk1UzBKUWkxYndx?=
 =?utf-8?B?Q0RUTnVKazcwVEx2MDB2UWR1OEdmbnE2S2VRMFlodW01QUpvdFQ0blh0NTh6?=
 =?utf-8?B?eWw4R1hoc1NTRk1QLzU4N1RuOXphVnplQVlmL1hTZ2tqTnJVbzJZM21yT0gz?=
 =?utf-8?B?QzhLZ0srellhdUsvZXhkUmlkUTltL1E3emlWUlEwamtnOHNaalhsNzBxUUdI?=
 =?utf-8?B?QzZPT2tEdE5oU0p0aDF3K3NGMzNzWHJLeHN3MmdKbDZrVSszbnFzTkZOWjV0?=
 =?utf-8?B?Mk5Wd3lITnJpTmJKUDVxUXovKzNrYVd5Nkl3RFRqNzBia1RYbmdTZmJ2cFhr?=
 =?utf-8?B?R3d5R1NUeDN3YnYzZ2tXVGV3eExxanAvZVB3UTdtbWFXTHFuUUVkMEpNRnBT?=
 =?utf-8?B?R091YUNkWDhTTE9VaXhSbG9yYlVrcTlJYkdzNmI2QVg5SWR0RFRJSU9rZlM0?=
 =?utf-8?B?ZHNidDM0QVU4aWgwMmVqUzVJcEVDTFBZQ3o0dGZxSURsVkpLblJtM2RZRHhk?=
 =?utf-8?B?aTVMR1dseG9aSzF3a011Um42RWk0bWZ5YkcrQlFQQ2FabDk3NVNtWU9oclJU?=
 =?utf-8?B?UWlGcWlzUHZZWDhPRXhVSDAzU1F6TmNlc3BKc29xbGxzdEZqOUEwUmN6aDlk?=
 =?utf-8?B?UDk0Kzh3bGp5MDE5MG9NeW1NamwxWnNmRWh0bVVFdFZMTHdVd3NjOWtUWlAr?=
 =?utf-8?B?dVR2N0tXamRlT1lES3FxbkpwQTBTRnIzWWRKbHFJd1pMU0ozMFpYWjkvak8y?=
 =?utf-8?B?NkJDeFRUTnRyNFlQSnJ5TEtOT1V2TnllbUllMW4vdldEVjdteEVxU0pKUVZO?=
 =?utf-8?B?QWdiNWdPMHovU0NMNk5kS1U0LzNQR2wxWURKcldNMkhnZ1lrcHVzM1pjZUVQ?=
 =?utf-8?B?c3lUb3d1SmhGMlFDR0tLVlN1SG15cmdEUFR6MTFkalo5NEpmK2JzRmVwM040?=
 =?utf-8?B?eDhyc2pQTmFwUlRYRXV2RERvcEJ6SmV5cXRzL1hZaFJBNy8xNCtUOVlldSs0?=
 =?utf-8?B?YlV1UEtyOG96T1p0Z2JKVVQ3OG9HcUhGQ1lKZ0RTS0JmdS84V2tEclVWelFT?=
 =?utf-8?B?Vm8rdUVvZ3RmUm5zaFBkSDFCd2U3ZldXZ1ZrejFZWVpBNTdKa05GSDZXQ2pT?=
 =?utf-8?B?MFJycy9LM0EySEE5M3VhUXdUcTBUN2RSM1dZOFJJUTZQb1FObmZMOEljbmw4?=
 =?utf-8?B?cVlma3RMS1hRUVUvS0lqQ0FBUU1SL1JXM2FRVWc4TGxuZDhlQ2ZYekdsbEVH?=
 =?utf-8?B?SE0wTkdHTmp0TUcydmtDNGlDVllXMGRQMUlwd1pBVzZ4TzZycWgzMXFvSHZW?=
 =?utf-8?B?ZWtLWGNWYWIzc0tZYXBQSXorN3BIZmNrR1ZKQ1FTWS9zV1JjYUtXNlk5ZFcw?=
 =?utf-8?Q?pS/barFk3XQ/54tb046u0ok=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEAA252C41DA2342AC6836404F001B86@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rHhYpNdoIKICHClq/nnak+q8yW+vuXFZDRRaWw8Q7/IdKnnpvxdpS/apLvn3nBe7yklqw2qHyhzDtGxWom8Mybxpf9ACo+ifAmUNV6WNfbur3QFy4r/tJlnSeXZTSVZ0uqgSHbFm/Z3ay8jDa7/n6jJJlTC7iWJcRqDjBU+MH/PADl3aBCi/JsY3qjguEvJOUtMQz9Bdn5bW0pkf88g5ltbgR3KmEOHWEBbBouATlrVu/5a8QTF0KwaNhvUIRsOj2Y+nWDRDmO63kzDxbRhhkG/MfYaH1/KdUCDEJywwDBg8nbm4mJZ76Fuww1EYM/CorXTKQOWAzQ1/SbLDXCphjJE8tUSpWOVD8Yh1S0ptQJYlOZO+AVX6Q8psyzK06tWoqED74VpSY1U0LxoBZKJ3MEzhNkjK5SzsupAV0xpdcuCgVAvxFLluBbF9I0bTQw669Sn8z7BoIAiPYm0xZG1UuBKcso5/nZGmqxyxGY1dv3QcNRaXhX+lCpEqH4GuwKmecAUOuSd4/XkDEX8l9pLsF6EI6uJkIAXM+xyROiia72e+xNHCTGNR2VFz8Pi5fbgmHRGZcQFsYOAk3QNJI9gZX9jWZz93xlMekNlRoS/TgEtvDCHi/glI/vDIUFBq0HM1GDC9EdU6pU74Wx9+kL+l/WgtpodRy1bLWm4pcQh65soZ+iNNtV23HKJWWJ/4tOIrR78aZ5lAJGKKRVTJHTYuJW5uiYF3sFzaLLuqU7/3BgBPhDJ9keiXZifwVWjpXmexxPzFwFfLFdi9xta90O9ldsxSm7HXF/sb/uUCtkd0KKlAVgR9PI+opGixbZDPircZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dc4f01-8ee9-45e0-231c-08dac42c203d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 21:31:42.4361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +u7OjIBJ/svH9+VQYLLML1xt4iyH3umgwj/Q5alV9ZzHEI3bOl9yJGcFJ5+6zujlaSVPS5+LNuPuYFUqJYxIy1Z6RcZunt3yvgX7Q/yHf/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110145
X-Proofpoint-ORIG-GUID: 5EXkN8zbirCrF0k00ihEz8C1BipkxVMb
X-Proofpoint-GUID: 5EXkN8zbirCrF0k00ihEz8C1BipkxVMb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTA5IGF0IDE0OjI2IC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
DQo+IEFkZCBhIHRlc3QgdG8gdmVyaWZ5IHRoZSB4ZnNfc3BhY2VtYW4gZnN1dWlkIGZ1bmN0aW9u
YWxpdHkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmluZS5o
b2FuZ0BvcmFjbGUuY29tPg0KTG9va3Mgc2ltcGxlIGVub3VnaA0KUmV2aWV3ZWQtYnk6IEFsbGlz
b24gSGVuZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPg0KDQo+IC0tLQ0KPiDC
oHRlc3RzL3hmcy81NTfCoMKgwqDCoCB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gwqB0ZXN0cy94ZnMvNTU3Lm91dCB8wqAgMiArKw0KPiDCoDIgZmlsZXMgY2hhbmdlZCwg
MzMgaW5zZXJ0aW9ucygrKQ0KPiDCoGNyZWF0ZSBtb2RlIDEwMDc1NSB0ZXN0cy94ZnMvNTU3DQo+
IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3RzL3hmcy81NTcub3V0DQo+IA0KPiBkaWZmIC0tZ2l0
IGEvdGVzdHMveGZzLzU1NyBiL3Rlc3RzL3hmcy81NTcNCj4gbmV3IGZpbGUgbW9kZSAxMDA3NTUN
Cj4gaW5kZXggMDAwMDAwMDAuLjBiNDFlNjkzDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvdGVz
dHMveGZzLzU1Nw0KPiBAQCAtMCwwICsxLDMxIEBADQo+ICsjISAvYmluL2Jhc2gNCj4gKyMgU1BE
WC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjANCj4gKyMgQ29weXJpZ2h0IChjKSAyMDIyIE9y
YWNsZS7CoCBBbGwgUmlnaHRzIFJlc2VydmVkLg0KPiArIw0KPiArIyBGUyBRQSBUZXN0IDU1Nw0K
PiArIw0KPiArIyBUZXN0IHRvIHZlcmlmeSB4ZnNfc3BhY2VtYW4gZnN1dWlkIGZ1bmN0aW9uYWxp
dHkNCj4gKyMNCj4gKy4gLi9jb21tb24vcHJlYW1ibGUNCj4gK19iZWdpbl9mc3Rlc3QgYXV0byBx
dWljayBzcGFjZW1hbg0KPiArDQo+ICsjIHJlYWwgUUEgdGVzdCBzdGFydHMgaGVyZQ0KPiArX3N1
cHBvcnRlZF9mcyB4ZnMNCj4gK19yZXF1aXJlX3hmc19zcGFjZW1hbl9jb21tYW5kICJmc3V1aWQi
DQo+ICtfcmVxdWlyZV9zY3JhdGNoDQo+ICsNCj4gK19zY3JhdGNoX21rZnMgPj4gJHNlcXJlcy5m
dWxsDQo+ICtfc2NyYXRjaF9tb3VudCA+PiAkc2VxcmVzLmZ1bGwNCj4gKw0KPiArZXhwZWN0ZWRf
dXVpZD0iJChfc2NyYXRjaF94ZnNfYWRtaW4gLXUpIg0KPiArYWN0dWFsX3V1aWQ9IiQoJFhGU19T
UEFDRU1BTl9QUk9HIC1jICJmc3V1aWQiICRTQ1JBVENIX01OVCkiDQo+ICsNCj4gK2lmIFsgIiRl
eHBlY3RlZF91dWlkIiAhPSAiJGFjdHVhbF91dWlkIiBdOyB0aGVuDQo+ICvCoMKgwqDCoMKgwqDC
oCBlY2hvICJleHBlY3RlZCBVVUlEICgkZXhwZWN0ZWRfdXVpZCkgIT0gYWN0dWFsIFVVSUQNCj4g
KCRhY3R1YWxfdXVpZCkiDQo+ICtmaQ0KPiArDQo+ICtlY2hvICJTaWxlbmNlIGlzIGdvbGRlbiIN
Cj4gKw0KPiArIyBzdWNjZXNzLCBhbGwgZG9uZQ0KPiArc3RhdHVzPTANCj4gK2V4aXQNCj4gZGlm
ZiAtLWdpdCBhL3Rlc3RzL3hmcy81NTcub3V0IGIvdGVzdHMveGZzLzU1Ny5vdXQNCj4gbmV3IGZp
bGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAuLjFmMWFlMWQ0DQo+IC0tLSAvZGV2L251
bGwNCj4gKysrIGIvdGVzdHMveGZzLzU1Ny5vdXQNCj4gQEAgLTAsMCArMSwyIEBADQo+ICtRQSBv
dXRwdXQgY3JlYXRlZCBieSA1NTcNCj4gK1NpbGVuY2UgaXMgZ29sZGVuDQoNCg==
