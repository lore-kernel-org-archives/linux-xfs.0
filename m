Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E37C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 21:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiKKVgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 16:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiKKVge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 16:36:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26646417
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 13:36:33 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLMeWJ024497;
        Fri, 11 Nov 2022 21:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JNJiMR4kZ8Hq80SxPcqkY2ItX480QcA0nGdJDh1ZY0g=;
 b=zs0KoE4Kv2r236AfKWzYhR5tpomMRQ0q4iXLJgMQdv9pnc/pWr1ru399GGr/w1oq03rk
 M55SwHXLUTFA0p6S/geF69SYmN88tKvmTQ4zJpDBlLSRDC7dt7WLSjzuyuqwtbM3hPtT
 +pa3hD9j2D2LweeczWiClUIjm1o879SaVWSWyCiUeGV5lPBpsSxYhDwGlA+nMTHt5ECy
 1YA/AkkUb7lQFW2U1rbQ6nRhnHeq+lRyJZW0YUAQzQsbPwVk9305joxM4GTERWHPuTQs
 O4ov5arzGLX7VfJB8cxuOFA7clTl2ct/SfSQDZ+eCMKX5eDy0m/glV7HASicSqglX5z+ Bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksx8k80jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:36:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABLTF2n021300;
        Fri, 11 Nov 2022 21:31:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcsjf1x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 21:31:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqMcqmqyHvKOYfjnWfcj8tZZO3y3dGlGuRM5vcGuOHIJyHGsbVPD+qAkCzmfM2r0eAR7Flq3J2LMZj+hW1H1AuG/uctiXtWWEN1cvovVKyGACeuivgugPbHF1A03d5miOTPQxA/dicFwZkfIpk40RIsyFY/zZ3elCW0xtOvSuYe+UrTpce6FseOy06JtgUe/HO/oKQF/YU1raIPyUch4bqzhqZ3eKOWpZJrBdmnwKQTJMsuOVWdxo/1vEA4XiBDxnAtmFUgvI5siRInSm3GkBjgSkRmm9k9U2T/ib1rchIjCF5qh3pE3p8PITYiuA9zboFco1BHkhXuOg/Dl42W+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JNJiMR4kZ8Hq80SxPcqkY2ItX480QcA0nGdJDh1ZY0g=;
 b=fil/sjgOOUfn+z1qgjQTy7dCXkE6mNEIOvRMaUQHkVUj3iUmr76zkrUvgHmfLVygkx1+MdWmIljQs4+NEVZctBXuOyKgMkgOg8TcOx6dMuJ9+152pM1zxmD2RD8SkD9s3VPCtwE4B06JhZe8V/f55yGhLEuVwPRb38vUfZOJDcgfde9cd6zB1GgEIavVizx04SJjHgqDLDaBYjlUhGqO8peHfVtIFjbfKgfuG0G/f1tXLpEiXuRj/y7fyOwMc++GQhLD/QqCYUeuXEiH/c80iHrZeNFeDRKUJ2U78mu9MGuRoyDA2208EbmIGz34knuNq70X35o3Oi6FuL/H47u8RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNJiMR4kZ8Hq80SxPcqkY2ItX480QcA0nGdJDh1ZY0g=;
 b=xg1FwfIjQIy+meRHZ0HE0r28PaOSuOEwSYibkJmZ/aKIiJX/TgSOdmT1bC9RLx5AsmmvGVuyorrl2/KslyvyQIN6b2NlW4JbUcg/tL6HreHfn/RyTWbjvoMV6g5Hv47C28k92dqMDmCt8tqC+mcuM5TxYWXIYvHtqCohDwBVMuk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Fri, 11 Nov
 2022 21:31:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5813.014; Fri, 11 Nov 2022
 21:31:28 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     "tytso@mit.edu" <tytso@mit.edu>
Subject: Re: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Thread-Topic: [PATCH v1 1/2] fs: hoist get/set UUID ioctls
Thread-Index: AQHY9ImnAkutFP57yUeUSjehzkcPLq46QNWA
Date:   Fri, 11 Nov 2022 21:31:27 +0000
Message-ID: <44f8399605af828fbb75d67677717aebe0efba81.camel@oracle.com>
References: <20221109221959.84748-1-catherine.hoang@oracle.com>
         <20221109221959.84748-2-catherine.hoang@oracle.com>
In-Reply-To: <20221109221959.84748-2-catherine.hoang@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH7PR10MB6652:EE_
x-ms-office365-filtering-correlation-id: 78889eaa-4aa0-4e97-cd65-08dac42c1797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OJoetMHzQrPpFJlxwFwBi/aEtw9eTjucdduw672CFDhecCkrF4M5/2cX2qS5hUtSWXk8IivcgZ3rSj8aCLWNlFUouWr5tWrX5/2JlxLfcc16b5BzLMdoVcImMpXMVAsUG5dTh0t+XlTqa4isB5fPVii6emu+1iIH1A7D08W4I9bPlUrDe5mZB5G5FK+JLvozMv9Yf9ZspvRxqewHD6pnBFPv2lR8HYmpNZ3huch5X0DMAH3iYJvpeYQYkoPO4kvIjWjVJQ8x7VdRq3he0D4ABMh/Y/FAIL0w6qiFjj8dehwdgBDjB2k2BDZc/zMPy1nio0JdZd6KXs5GxXkQHAhcNfGU+AlQtoj0qAz+xeJnkpGnV8MEY6aX9+NG+GtvmSzhvWvqmTVRwX47xyP65TNzbeoNHMwJ1WP7qlT5gWQnBrVZddjtH4m/rbTcqPNPZSzH525yRpzAPhAT89sCsDtUVkgHRorUHMxEX7Qh2yAuvB8x+GC6E+ILnxZ5xVx1kkiNf4Ox+KzrvB/PG7r/U8hKuVkO322I97lZA6Q9aCoFnUVDLdSBAavzHG4QdUnpzbKVYNkPsn1pPZZEa7pSdJnHT6Wx4X7bcqJOtBuuhZaJULOSc0WjT93GaPm7a4gG+gdu8Zc9bGVAQUndE9ZvsSTB2mYBI4qmYOg13/kNw7MGZbny3hENAxsdMZ9gkAbBjwJdcw1Yq4OZDOeY0hizZyxqldsm9PJIMapDAn9XE+At6mbXUxMTXZ0K4aNggFwvmFuo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(186003)(6512007)(110136005)(26005)(38100700002)(4326008)(122000001)(83380400001)(71200400001)(6506007)(2906002)(44832011)(2616005)(76116006)(316002)(478600001)(5660300002)(6486002)(41300700001)(8936002)(66446008)(8676002)(64756008)(66476007)(66556008)(66946007)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXVPUjNneGY4MjVkYi90c2hRUWY4bVR2elZZalpaZkd3bGJ2OENPN1REd0dJ?=
 =?utf-8?B?Z1RGaFp4NUhRQml0a1RNbENlYnJ6UTBEakpIbjh0aDdIZ0dXOTVWSng2TG5i?=
 =?utf-8?B?bzdmTmhidlNxdFpzaEN2OTdiWGRhRmZBWG54dXFjY1hhclVsV2VEeXdrVTNU?=
 =?utf-8?B?T2hUbmt5OVIwQkNqTE8wYTFnWGVUNUhkbW5QZzMzY1R2L29yMVI1ZXprYnda?=
 =?utf-8?B?QTRyZU1pQmg0ZEp1bXlDK3FWR0ppbmhwTEhGYlBETWlRd0hmck5QRXo0bFJO?=
 =?utf-8?B?VjBFVE4wZ1BzV21UVE5KRTNjejM1OE9vNThBbGs5UFZ2M29jd05YOVhQR2t1?=
 =?utf-8?B?eW1WajJDYjJPektLZVd5VzRDK0daNE84VjBBWXk2NWZ0SmttWVBjbUY2RGtC?=
 =?utf-8?B?Z1Jld3oydEpoKzVrZkNEODhQWkxWMDcyc3AzMk90QUNMeEJLT0NHSTFTbFBR?=
 =?utf-8?B?c2RFKzVuYU5zUyt6OThYNkY3T3p0cXpsaFZoRjljNHNnZi9ONjZsUTV6ditW?=
 =?utf-8?B?YzNBRGFiSmdja09yazFNa29XYlZDdTJjSzRRcytOWGU0MlNwNjBkeE03U2tG?=
 =?utf-8?B?eEp6ZEc1cFM4WEgyZndrWFVyYW0zenpvaVpJZHVIVTB1ZWdTZitzRGR2Q010?=
 =?utf-8?B?dmJBN1JsdWJjTWtjU0NoVDlFaG5KWWhnYWlaMUNtN2dEZVdLWm84cUNSL2xk?=
 =?utf-8?B?SG9QRysvUjgzVUFrNWZ2aGtlaEpGK1NUVWVLMUxjQy8yWlNlbU91STQ2Y3pK?=
 =?utf-8?B?N09NU1orRU12bktoUmNNSHV6Rk1iWi9LZ1ZDallISjRtdHdCcWR6ZkZ2WXBj?=
 =?utf-8?B?amFaZWVMSUdvWHE5aVlhNGV3MktYUmF6dFdHVUl0d0UyMmg1dUlCQ0pqQysy?=
 =?utf-8?B?SjdMaUNvbzRNSlJaWkh6WUNxWHc1Uy82SUhzUy9GdTRqbGY3UHB6VklEeW5M?=
 =?utf-8?B?VWJLQVRNa2NFQktLM0dRWkN3RHNRbW9VVGxIR3YwSm1nY1BtWWdQVmxuNWpQ?=
 =?utf-8?B?QWpCNWsvSkpkNVU1eUVCazF4Tk9KNGVJQ2NzNlRtemtnWGU4UGxna1o4Rm9Y?=
 =?utf-8?B?Y2VXQ3ZMRGF6cFo5YVJtU2ZYdFBvV0x0R3pzbG1kVERDRGNlMVNOeFZnaElS?=
 =?utf-8?B?K0JPZGc1VkVHaXpTNUFiK056ZFVnOEF0OThPYkI3VmN2VWFSOEhnR3NCWito?=
 =?utf-8?B?TXNiQnhpejZSVkZobjg0eFkxdHJ6emNyemxva2lhSnFWeWlwcmtoOFZkUEI3?=
 =?utf-8?B?K3oxTE1pK1JCVzhhWllUTGlOb043SEVlTXBHYnNTU09TekJjWVduaThaRG1M?=
 =?utf-8?B?WGlDc1JVc1hncjN1WnU1cjVua29WdUpYZmJpcmRudzl0QkttSFZRN2VJUDJU?=
 =?utf-8?B?SUtTc1hWNmU0a2N4OXIwOVNmK1RRelhPbEttNVcxVVNRcEJVWTBWV2hBcU1B?=
 =?utf-8?B?SVRuTVl5OTRVOHJaTVIyZ1F0TFJ3L1U0N0lPZ3RIWDJVTlo4L0pWeG5pamZw?=
 =?utf-8?B?elQ2b0FNcWpac3JOT3IrN1BHenF6MnV4YmxjNk1XSzJTdkMzdy9HKzRSTXBI?=
 =?utf-8?B?cmRaSkp2dmp4Ky9pd2RWWjJ5a3Rzb0F0NzRzYXdNaU1RNHBSQytpV1kwa1Ev?=
 =?utf-8?B?ZGNkam9jdVNUVm5YVXc4dzhhNk9JeFRxUVhpdzRxN1dpWFlxMVI0OHZ3N1Vm?=
 =?utf-8?B?ODBVNUowdEZGVnZLSmVqTlMvQUpjb2Mva2R2UExacjd1TjVZRHhMdmFMeGNj?=
 =?utf-8?B?ejVHM0s3YkkyS2xzcXNMdFBwK0R2c2pTbmNaSVd1SC94SzQ5OVRZUTlOd1Nq?=
 =?utf-8?B?aTJod2FMeHNEeTFlR2hvcmxQam5sVXBMTEZFalI4UkdNaHZKb01lUDVCTDN6?=
 =?utf-8?B?MEJpQVc2c3VYWHJEMlcyUDc4N2ZVUzFPS09rSk5XV0tKdWFVUXNwSHBzdlNW?=
 =?utf-8?B?MDB0L0R0QmlCNksxUitQK2RrUnJocGg4V2k3c3ZYUTlXTlJwTER1dklyQnNE?=
 =?utf-8?B?Z2t6U0pmdWhmM2taYlZTZWdzZFRDaEJqZndVM3BVQiszamtVQ09aT3NDWWcy?=
 =?utf-8?B?M0xQS1ZZeWZRSktRM3JsM3FzdG5EZ0pEeGh1SjRhLzlhaC9zdXJPMkxESTlM?=
 =?utf-8?B?dkQycXAybU4wTmt1ZjRpL09xWjhuNFJsS1NzcmtYQldMZC8yc0hzYWhCUG9n?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <240E9F1A446E37418D42C8400BBE6496@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u6R+ad5LI/m7jsJZDJErvhyRc6/pqq16CLdptn+d25XDDqjKWOHammGtOypSrdv0fjCOomAo4isQP1L2X+dxyydX0l4+2Ld8MYhUzsOwcF/FOddgniJye8L/CQk+nbatYBrwb4iUDS8JaaJs0EpOzdG64vTna3Vh2tqsZIM/jR4XQ3iFOtpPX4RZX9DwP20HpAX0Y2jtSC/Mzm8QvZ/scvfz5riwqGNG2/bfG/PBpQ21b4gOhDmcNJcTBw6NSFHhiSAFi/S/E8/xOwkLqV6El2+Pt5DlpCW8AhagxkfNRAUCBDXzUNoGOEJ5K/GdyA+yJ0aizVTuf2FZE0cytOB1GyXzm6CAievQKnWdx1RCoHDITH5070ltiVxyFxdEccFiNgVI54mZKshYifrkcZsa5Ghwu/g4OiYT5JQt786mHyVqq50c+JdGx1gLKW7LS/ohhVSVnGAhSDxnrKOX9ts26+7HLzkcgcEJUb/Xz64a+2PU5sUrRvzQL2rysMFiKWelQWSq5+EIbKtOWx5Bleg9ks8Vl9UNcJdBFKXTJOrm/jX2TfJDkEk1k+AEqQJREXqN00TQHvV1x7MsmpLsM2m7VPhbwhi60QHJwXC2ikyC1MvCUvV6x/6W+RTCqs73HYh/AmEnWP6YWelof6RJlwLZ/a6HSy61AvViaAE6LK7Ao5iuh9nXtC/GMYS+It/GOZWSD27uZsM0NckwuQeuZyIReHzGlvjLhXJ6hbuCWRVJ++M8c54ok4SySwtGhIa9aNchHxBTJdO0BD9RBC/XXfcr/PhZTWdRGSeBELlvEyvHoGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78889eaa-4aa0-4e97-cd65-08dac42c1797
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 21:31:27.8995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KiYvSgdOKgB9Kladthf7Zhwmz5o1aqFN+i5YBb1IbXvO/MgjwbbfJfdQtzFiAHM4AYOJJg2nkP3dV+9ibNYm18sUdfR8nCsvX+TtP8Q1jcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110145
X-Proofpoint-GUID: amH7Gqg47Sw0gH1QriEwhiTruAM-fPc8
X-Proofpoint-ORIG-GUID: amH7Gqg47Sw0gH1QriEwhiTruAM-fPc8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTA5IGF0IDE0OjE5IC0wODAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6
Cj4gSG9pc3QgdGhlIEVYVDRfSU9DX1tHU11FVEZTVVVJRCBpb2N0bHMgc28gdGhhdCB0aGV5IGNh
biBiZSB1c2VkIGJ5Cj4gYWxsCj4gZmlsZXN5c3RlbXMuIFRoaXMgYWxsb3dzIHVzIHRvIGhhdmUg
YSBjb21tb24gaW50ZXJmYWNlIGZvciB0b29scyBzdWNoCj4gYXMKPiBjb3JldXRpbHMuCj4gCj4g
U2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxjYXRoZXJpbmUuaG9hbmdAb3JhY2xlLmNv
bT4KCkxvb2tzIHN0cmFpZ2h0IGZvcndhcmQgdG8gbWUKUmV2aWV3ZWQtYnk6IEFsbGlzb24gSGVu
ZGVyc29uIDxhbGxpc29uLmhlbmRlcnNvbkBvcmFjbGUuY29tPgo+IC0tLQo+IMKgZnMvZXh0NC9l
eHQ0LmjCoMKgwqDCoMKgwqDCoMKgwqAgfCAxMyArKy0tLS0tLS0tLS0tCj4gwqBpbmNsdWRlL3Vh
cGkvbGludXgvZnMuaCB8IDExICsrKysrKysrKysrCj4gwqAyIGZpbGVzIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy9leHQ0L2V4
dDQuaCBiL2ZzL2V4dDQvZXh0NC5oCj4gaW5kZXggOGQ1NDUzODUyZjk4Li5iMjAwMzAyYTM3MzIg
MTAwNjQ0Cj4gLS0tIGEvZnMvZXh0NC9leHQ0LmgKPiArKysgYi9mcy9leHQ0L2V4dDQuaAo+IEBA
IC03MjIsOCArNzIyLDggQEAgZW51bSB7Cj4gwqAjZGVmaW5lIEVYVDRfSU9DX0dFVFNUQVRFwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoF9JT1coJ2YnLCA0MSwgX191MzIpCj4gwqAjZGVmaW5l
IEVYVDRfSU9DX0dFVF9FU19DQUNIRcKgwqDCoMKgwqDCoMKgwqDCoMKgX0lPV1IoJ2YnLCA0Miwg
c3RydWN0IGZpZW1hcCkKPiDCoCNkZWZpbmUgRVhUNF9JT0NfQ0hFQ0tQT0lOVMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoF9JT1coJ2YnLCA0MywgX191MzIpCj4gLSNkZWZpbmUgRVhUNF9JT0NfR0VU
RlNVVUlEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBfSU9SKCdmJywgNDQsIHN0cnVjdCBmc3V1
aWQpCj4gLSNkZWZpbmUgRVhUNF9JT0NfU0VURlNVVUlEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBfSU9XKCdmJywgNDQsIHN0cnVjdCBmc3V1aWQpCj4gKyNkZWZpbmUgRVhUNF9JT0NfR0VURlNV
VUlEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBGU19JT0NfR0VURlNVVUlECj4gKyNkZWZpbmUg
RVhUNF9JT0NfU0VURlNVVUlEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBGU19JT0NfU0VURlNV
VUlECj4gwqAKPiDCoCNkZWZpbmUgRVhUNF9JT0NfU0hVVERPV04gX0lPUiAoJ1gnLCAxMjUsIF9f
dTMyKQo+IMKgCj4gQEAgLTc1MywxNSArNzUzLDYgQEAgZW51bSB7Cj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRVhUNF9JT0NfQ0hFQ0tQT0lOVF9GCj4gTEFHX1pFUk9P
VVQgfCBcCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRVhUNF9JT0Nf
Q0hFQ0tQT0lOVF9GCj4gTEFHX0RSWV9SVU4pCj4gwqAKPiAtLyoKPiAtICogU3RydWN0dXJlIGZv
ciBFWFQ0X0lPQ19HRVRGU1VVSUQvRVhUNF9JT0NfU0VURlNVVUlECj4gLSAqLwo+IC1zdHJ1Y3Qg
ZnN1dWlkIHsKPiAtwqDCoMKgwqDCoMKgwqBfX3UzMsKgwqDCoMKgwqDCoCBmc3VfbGVuOwo+IC3C
oMKgwqDCoMKgwqDCoF9fdTMywqDCoMKgwqDCoMKgIGZzdV9mbGFnczsKPiAtwqDCoMKgwqDCoMKg
wqBfX3U4wqDCoMKgwqDCoMKgwqAgZnN1X3V1aWRbXTsKPiAtfTsKPiAtCj4gwqAjaWYgZGVmaW5l
ZChfX0tFUk5FTF9fKSAmJiBkZWZpbmVkKENPTkZJR19DT01QQVQpCj4gwqAvKgo+IMKgICogaW9j
dGwgY29tbWFuZHMgaW4gMzIgYml0IGVtdWxhdGlvbgo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3Vh
cGkvbGludXgvZnMuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9mcy5oCj4gaW5kZXggYjdiNTY4NzEw
MjljLi42M2I5MjU0NDQ1OTIgMTAwNjQ0Cj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2ZzLmgK
PiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvZnMuaAo+IEBAIC0xMjEsNiArMTIxLDE1IEBAIHN0
cnVjdCBmc3hhdHRyIHsKPiDCoMKgwqDCoMKgwqDCoMKgdW5zaWduZWQgY2hhcsKgwqDCoGZzeF9w
YWRbOF07Cj4gwqB9Owo+IMKgCj4gKy8qCj4gKyAqIFN0cnVjdHVyZSBmb3IgRlNfSU9DX0dFVEZT
VVVJRC9GU19JT0NfU0VURlNVVUlECj4gKyAqLwo+ICtzdHJ1Y3QgZnN1dWlkIHsKPiArwqDCoMKg
wqDCoMKgwqBfX3UzMsKgwqDCoMKgwqDCoCBmc3VfbGVuOwo+ICvCoMKgwqDCoMKgwqDCoF9fdTMy
wqDCoMKgwqDCoMKgIGZzdV9mbGFnczsKPiArwqDCoMKgwqDCoMKgwqBfX3U4wqDCoMKgwqDCoMKg
wqAgZnN1X3V1aWRbXTsKPiArfTsKPiArCj4gwqAvKgo+IMKgICogRmxhZ3MgZm9yIHRoZSBmc3hf
eGZsYWdzIGZpZWxkCj4gwqAgKi8KPiBAQCAtMjE1LDYgKzIyNCw4IEBAIHN0cnVjdCBmc3hhdHRy
IHsKPiDCoCNkZWZpbmUgRlNfSU9DX0ZTU0VUWEFUVFLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgX0lPVygnWCcsIDMyLCBzdHJ1Y3QgZnN4YXR0cikKPiDCoCNkZWZpbmUgRlNfSU9DX0dFVEZT
TEFCRUzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX0lPUigweDk0LCA0OSwKPiBjaGFyW0ZT
TEFCRUxfTUFYXSkKPiDCoCNkZWZpbmUgRlNfSU9DX1NFVEZTTEFCRUzCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgX0lPVygweDk0LCA1MCwKPiBjaGFyW0ZTTEFCRUxfTUFYXSkKPiArI2RlZmlu
ZSBGU19JT0NfR0VURlNVVUlEwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgX0lPUignZics
IDQ0LCBzdHJ1Y3QgZnN1dWlkKQo+ICsjZGVmaW5lIEZTX0lPQ19TRVRGU1VVSUTCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBfSU9XKCdmJywgNDQsIHN0cnVjdCBmc3V1aWQpCj4gwqAKPiDC
oC8qCj4gwqAgKiBJbm9kZSBmbGFncyAoRlNfSU9DX0dFVEZMQUdTIC8gRlNfSU9DX1NFVEZMQUdT
KQoK
