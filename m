Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D8EC46467
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjASUiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 15:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjASUiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 15:38:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5C780178
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2023 12:38:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JGweGC002361;
        Thu, 19 Jan 2023 20:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QurQtlRmMbt6K9+uE5i7beDOhFJw+NmBIIXbRUTkB10=;
 b=fszaOYJPiRftwMT1GPiIfaU6MOLxKqKs0LKhb9ceoq3KKiKkNZJIdLnmNcKu5mozTDlk
 WosOEQQ7HptnjuVAne7+IuW7YDWozB0qsAbc3AdEpVNzxu7OgzCBgq2xfGZhUMLFc+5v
 ie0LMH7GsfIomT24UCuoYeXZcFGOxqLnrG0dQjTMe0mx+yHioSp7aKmnd0il757uLEVc
 3dN5FCc9/12BVezHK6nBuBC1aS6yz2WWY3RuGi5d1rk6sN7womZt/W+8FuKoqFtxFBGh
 M3gJ5KoEnjANGvPq07oxp8Yn3H2y66rmncVa3oxkAqm1GpuKEsd3vM5Xm3wx7IHY8qpU Uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0tu6nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 20:38:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30JJesAm000984;
        Thu, 19 Jan 2023 20:38:42 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n74d1qf03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 20:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPf27fvaDQe6s+Y+ed08X0DZ29x0zPJsdQAQjKNTefUiSF7ZCn78ILBPMjFSdnSiu6xvxc+ioMYf8d2kQsLrOsouTzScYmFCv4Xd/VGNdhe7iZdH8CVTvLNgxEIqB+Xvj5zLTRcMtl29+ojDKEhq0RVyCSaFdlEdDav804SYiVleTrNKIgmLpsVljzc/qBAlZKn4DL92d3914Vl8dHKES4aLJq8KtaqC4RdfOC+QyTqcuXkp8SEY+nAdSdFhkfOY+mlE7stHVwPRrrR1W825akEzlqEaa543hUmqLqy4DEIIUZ03yooldO0QFk5DsvHJIx80QeHO9kx2KvVc75P9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QurQtlRmMbt6K9+uE5i7beDOhFJw+NmBIIXbRUTkB10=;
 b=Rhcsa7LtNbLSCf7pOy/zABg/fgPjSJAeHQVi6miTeGiDL3jTGaApuLr4AgFApYPkP/x48ljTdre7OkhRD3Dmx69d5/SCxPVUB0JMVowb4tcg0sF67zuL3cO2YB5bMZXp3Siq/RD9RUifqsUJgib/tZzFKZEBxFZi9+l+XhdkzVAxMsayna4Dj/PMAC1cyzuAG4oEbo4qO81hEPBxsHg90w53QgI+MiPAAbCkZLxPkVoncp+DhK9uP5wz0g1MCWZ13G7Ig+dRey2XWj2NicUyB+oo5Cyt0jjGAYQDXekjO5brtgv1JgUBXOtmT/4awv/z/zGJRRGSzYp/h/aTFxmgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QurQtlRmMbt6K9+uE5i7beDOhFJw+NmBIIXbRUTkB10=;
 b=YYp6DAzlLrFNhTWjlwvxrjJkDFxbJw5VIxjR4CbHh69JoKkejIInIrpMZFNr7lZmsccL8YfbnClLZ8rIsspgbGHpM2bnKwSMDDZkegizcOjIs0eWgz+61dawhfxEhFVGd7OUFjbEWDmZJPu+P1kVebTpMffcUFQZCCQWxwWqHA4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH7PR10MB5877.namprd10.prod.outlook.com (2603:10b6:510:126::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Thu, 19 Jan
 2023 20:38:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6002.012; Thu, 19 Jan 2023
 20:38:40 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 03/42] xfs: block reservation too large for minleft
 allocation
Thread-Topic: [PATCH 03/42] xfs: block reservation too large for minleft
 allocation
Thread-Index: AQHZK46U8X4CfzlMqE6BGnUkY5rY4a6mNOiA
Date:   Thu, 19 Jan 2023 20:38:40 +0000
Message-ID: <091f02410f417008f274da48dc467472e56da5c8.camel@oracle.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
         <20230118224505.1964941-4-david@fromorbit.com>
In-Reply-To: <20230118224505.1964941-4-david@fromorbit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|PH7PR10MB5877:EE_
x-ms-office365-filtering-correlation-id: be8332cd-75a6-4d37-8e6d-08dafa5d25e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5s+C8F1rgBb4Fx5kD/X75ROgboEbRT3b1xrjr6WDNw4UvDl0wXQ38s8ZXWhq2qge/8jQca1oJp7yG7T1e++urOSZSHC1pTWEFYM40df97SgFvbYkaZjpquwF5sxXxiRT741akQjKMTBpu3L8qp0nD7CArOR90ccpFpDvZqENwB0F2zFfDUya+A4Jowab1WPR9t8rOQlZ+cK5+VqxyOBwSB/PcXrnU//ZN8zFbE63ZOUly0imqlsC0YJt5RBrXyb9gjdr1sFOlJEuoFCo4csYTNeZvYPHl/0fq/lSvZHNYx4rQplsPALyoFI/1RHg8OlAnvRlt+jtUpHc94t2junPujGwbmE8keBAI8RTrcEAyJCvFJusmBxb2dYYVuC+njTRG0d9dW6Hf9qjVNQI+PUFwuJIbjRGVkEalh/sOZ/wvKqRscZggO+IHUAz9GL1Bd+Ab/5hA4MVQTGzkhRV4whvVmTvPYIhxntxhJG0uJ2m/FReYnNcqx3tGPnm1oEF/GgF1Q5WZZT6TXIH7yrvGrApqddnuRVpcTnxwuIT+YoqtGGujdQfBdCX4hx67MEqy5PvCwR6XJX4kxbnRGpcl4PWNEgiQ/h3mGrTjWhtAr7KhRSETQfb8j0UR+/7GE+f8E3mpymbMIyhkIJWR3rLn77QMZ3Bno44QPYoQivY8XFuy3+vcxQhJ9oPmsv1EHhpSXfCSnlRbO6H/EuhN1XjNYNDgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(38070700005)(83380400001)(36756003)(41300700001)(44832011)(122000001)(8936002)(38100700002)(5660300002)(26005)(186003)(110136005)(316002)(66556008)(66946007)(6512007)(76116006)(64756008)(8676002)(66476007)(66446008)(2906002)(6506007)(6486002)(478600001)(2616005)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmxTV1RZRUkxR3dZaGVZcWpsT3o2MHh3eEtxcCt0Mi9QWDBLbmphNEVBRFdU?=
 =?utf-8?B?QXZ2R1hidXd0ekNHRWdRVUxxMENTSnBadi9NRmg4UkNSN0FKMGE2QkVKRjQ5?=
 =?utf-8?B?QnJyZE1vQUhmaDdFZm9leURrRDhpai9EZjdhSkYxOTVJdGF5ZENYVnNoKys1?=
 =?utf-8?B?UElkKzRNWmVuYjBnUW5iUEVQV3JSbk5DeTYxRVdyRDN1YjgwRVBpTlRmalBL?=
 =?utf-8?B?SkJSZ05MTExNRTFaVWJCRm44b0VPejNRSTkrVnM5ZzNFcnJJUkcxenJZbWJM?=
 =?utf-8?B?YUlnbWdmTWhycXgvUzR3Mk1wU2liRExleGMya0FWYnVEaTdjamUyVlFJOWNx?=
 =?utf-8?B?dXlzTmhhUDZSNlRvckRWZkxDdjJjR01jUEhqSnRuVmJPdCtwN1huVkRJSDdV?=
 =?utf-8?B?OUMxdHd3bjQ3MmNtRzluMk5mQnpoRXUvZzdISkNPQmhxcEwyZFhCTUdVNDNz?=
 =?utf-8?B?dG85ZmtKTEREUmpBZ3J6bkNMSWp2bVJNekoySmxpR2lnemg4RFlFSEtmOXhK?=
 =?utf-8?B?YllPVExLOGZPalhzNEEvOThCTzdxSURObS83VkovSlhFNkg5SHY2enlCY0NQ?=
 =?utf-8?B?bEdwd2RpQlBOemExZjJXOVlqbUNidHlaS3U0d1RuRFN0dSsxVWJMd2dQYVps?=
 =?utf-8?B?Z2VoTTZGVGkyc2NQYmVxMmtTbW1uQmJhRTdVdkkwMi8ySlZSRzFGekcvWGNa?=
 =?utf-8?B?SHNuY0hsWEJaK21yK0ZIU2FXM3pxZGp6bXNaUkoyLzRUSVhXYjNSeVlsNFJZ?=
 =?utf-8?B?RXI0MER3M21SUlZVV25RYUU2V2xmdkdaTTN2K1l3UWw4N0JLeDZpdFVqVjRV?=
 =?utf-8?B?UGFhbnVQOThVOXJ3cE9PTjFzZ1RrcVdNMkNTZ1ZheGZtTWs0dXRjTlZmYmRm?=
 =?utf-8?B?TkhleXB4dXM4NTFJMzlqUFhudWNnZWh5bUs3TklYSnprNnpLeEs3M2dkVzBV?=
 =?utf-8?B?VUpreWt2bHBBbWZZcURLMEdWRmRraUV6eFJPK0dHV2sxSEgxckdqZzVFcUpT?=
 =?utf-8?B?bTBZeHN3aFZwQThSNVVMN3dCai9VU0NCTjg2ZE5IUVh1UXQ1dWE2N2k4SFZ1?=
 =?utf-8?B?NHlSTXE0TmJkYmEvTVFlUXhpeEZ6Z2FocW90Z0FuM0k3N2pqVE5wVk16NUZw?=
 =?utf-8?B?VUR6bG15T21xSFRROUoydWYvQkllQy90YVFYcVA5WUt3TVJCcnB6bWk3OC81?=
 =?utf-8?B?Slh3UVJqQ241ZzFSQkFuVmdoOHg4VDVTOHh4c2lteEtvSTl0VXYreGNqWVVR?=
 =?utf-8?B?Zi9JWGl3cklhMFVoQVlrMlVlT1BXS1pVYkRJL2c2Rkt1dlNpYmpBenU3a3BK?=
 =?utf-8?B?eTIyMUtSQTdqT3VWdWwvWlBLTDF1RmZFUTdlZHN4SWdXUUtpL1M3dC9CVE5Y?=
 =?utf-8?B?ZUdOYmVzUW51TWpid3ZuSlBKVFdrcmtwalYvdUYwYjRIZUZ5RVIreEMrS2Ur?=
 =?utf-8?B?MkpQVXVzZ0NjandObzdRVGVLU0lZK1FZU0EvVlBFbEp1UEc0cFFZZ0NzUjR2?=
 =?utf-8?B?OUk3Zm8yblFzNStpV05mZXRXUG9yUzBEcXUwSEgvNG1UUEdWTnJsSmJia2pQ?=
 =?utf-8?B?SU9hUnFrK1FNSXlhckhFTks3VWt1T21zclh5bjZhTzkwWkZiWHV6YWhUWUhT?=
 =?utf-8?B?WXowb0hTb1dtd0tZK2hqM1crdXFMUW1VbFdiOTRsdm1rNHVNRzBQQVhNWDZM?=
 =?utf-8?B?Ti9jNmQ3OHk0QzU3dnE2MU5MSUhhWk9ValNLQ01yc0FCVERFM05XTDJZMkZ6?=
 =?utf-8?B?cjR4ZkwxQVJlVnp1bU1UYlBqK0pXbFdteHlYMTdrcm1uSGJPVCtVc21oZFMz?=
 =?utf-8?B?cXBoS3hBWDkyVUs5SEs3ZG4raVdHOG84bHBiZFUxN01CQklVNEFXenNVa1BG?=
 =?utf-8?B?UnRWRUprSjdZeGpWMThjdDlnNlJjQ2lmL1Z1Z0w1emlHYVFVMW5FQk5kQ0lu?=
 =?utf-8?B?eTV4ZTErOWp4bHRaajJMUVVLZWNVMDJ3bnB3ejJndTZJdmNuQjhZTm9sUUpC?=
 =?utf-8?B?YjE3VHhvemxNY2pQTEtOTFpyWGlldnZTTzdqN0psY0JHNUFWMTBrQUpYdldR?=
 =?utf-8?B?Q3BWQ0JEMkI1THNZSURHNDh5YkxXWEtkZTl3TGsvZHBqd3F2Skl2UVBBYysv?=
 =?utf-8?B?VTRreDlhbzJNRnJQcDZBMnEySTREbkxGZ29MZzJIZldOSGtqVnU3K2VKTU1h?=
 =?utf-8?Q?jRo+C3gh/SHHF2rUp3qcOIY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7DD49150B4BAF42B897BC42F5C51CF8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h9FuAgqz8bM8VOTQUrCR7E5E3bOsMXH/bTmZ+HbO3NQivO6Uf2QzvQgKEq57KpvVhTGbvUZUgDgMbY8lZ2tqPVcbULIxCYQPjRWeSq9RSYc3ZbLBRBCyT4rTLg5k4hGOMXkrccafwG00fczFRF7tLM/joVSXyfJb4ngGxBlZUEYgV81TzV6a+aAw4VgKVVanKKIoDU55jstBMWkLmumCyL4q1r3BqH4TyC1h1XzCAlXX8tt1Wf9s9JCasJ7S9Eqrtd2Bht3SuaFuGo5azyspfSOoZGKG1wnX5rg1FP7D75+kN56wWbafzkrDi+5pQc6o3A9WSC/qNRYzaNhVkwXpXXeNuftInGhJMZqKIzTWhDWnayca0uxekavVtHO6Kue26gfkIWPNwcIab4sMeBArGDONc+kQRz10HM5ptSCZw3UH44RZt4S4pl28+bIH6S+QRti4QjMfNqroxqKZ9GSJ5r7G+5tRSe7b7HUPXUBpQm/zKYbEQstuW5aPxAzT/gzaH0X8bBgyqto7m/IhxEe14c4QGeSHQBh4cXCLMDCASNtudEQ+ZSYpZXgN+eMM38ZHaEAmxeoYbXXXOeb+a73MlQN+IJRlNuuLyC5YBOQ1uJye8v4ZEMOoa+Ekcl5o3i07uwnlAePri5kCv/52vfSbHI96rYd8S1NV3sX1T2MJ1aCuR9SP66V6xkv2TQQDFM7oHkqKdKGE4KXqqZkj4k3QNv7dd4MCSkhB0sgY3JwnEKwLTmC3wOOUqq/qPZS/iL5KtRkn3WatYnjehPZ2yPJAVLEjbJZ/7DQJAQP0wbWKY2k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8332cd-75a6-4d37-8e6d-08dafa5d25e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 20:38:40.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: texwkxaESIDhK1/A5YscJthVgUHKD8X0ICJV4ou1+A0PHiJ63GM9ecu2VQO9afWXNLKIxdf19HRRtQAj6fLVlN+6qTgQjM11SyXM5udMQc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_14,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190173
X-Proofpoint-GUID: lNxYghSBDKlQQ_ne5QLhZG71OSkQ0QPh
X-Proofpoint-ORIG-GUID: lNxYghSBDKlQQ_ne5QLhZG71OSkQ0QPh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTE5IGF0IDA5OjQ0ICsxMTAwLCBEYXZlIENoaW5uZXIgd3JvdGU6Cj4g
RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgo+IAo+IFdoZW4gd2UgZW50
ZXIgeGZzX2JtYnRfYWxsb2NfYmxvY2soKSB3aXRob3V0IGhhdmluZyBmaXJzdCBhbGxvY2F0ZWQK
PiBhIGRhdGEgZXh0ZW50IChpLmUuIHRwLT50X2ZpcnN0YmxvY2sgPT0gTlVMTEZTQkxPQ0spIGJl
Y2F1c2Ugd2UKPiBhcmUgZG9pbmcgc29tZXRoaW5nIGxpa2UgdW53cml0dGVuIGV4dGVudCBjb252
ZXJzaW9uLCB0aGUgdHJhbnNhY3Rpb24KPiBibG9jayByZXNlcnZhdGlvbiBpcyB1c2VkIGFzIHRo
ZSBtaW5sZWZ0IHZhbHVlLgo+IAo+IFRoaXMgd29ya3MgZm9yIG9wZXJhdGlvbnMgbGlrZSB1bndy
aXR0ZW4gZXh0ZW50IGNvbnZlcnNpb24sIGJ1dCBpdAo+IGFzc3VtZXMgdGhhdCB0aGUgYmxvY2sg
cmVzZXJ2YXRpb24gaXMgb25seSBmb3IgYSBCTUJUIHNwbGl0LiBUSGlzIGlzCj4gbm90IGFsd2F5
cyB0cnVlLCBhbmQgc29tZXRpbWVzIHJlc3VsdHMgaW4gbGFyZ2VyIHRoYW4gbmVjZXNzYXJ5Cj4g
bWlubGVmdCB2YWx1ZXMgYmVpbmcgc2V0LiBXZSBvbmx5IGFjdHVhbGx5IG5lZWQgZW5vdWdoIHNw
YWNlIGZvciBhCj4gYnRyZWUgc3BsaXQsIHNvbWV0aGluZyB3ZSBhbHJlYWR5IGhhbmRsZSBjb3Jy
ZWN0bHkgaW4KPiB4ZnNfYm1hcGlfd3JpdGUoKSB2aWEgdGhlIHhmc19ibWFwaV9taW5sZWZ0KCkg
Y2FsY3VsYXRpb24uCj4gCj4gV2Ugc2hvdWxkIHVzZSB4ZnNfYm1hcGlfbWlubGVmdCgpIGluIHhm
c19ibWJ0X2FsbG9jX2Jsb2NrKCkgdG8KPiBjYWxjdWxhdGUgdGhlIG51bWJlciBvZiBibG9ja3Mg
YSBCTUJUIHNwbGl0IG9uIHRoaXMgaW5vZGUgaXMgZ29pbmcgdG8KPiByZXF1aXJlLCBub3QgdXNl
IHRoZSB0cmFuc2FjdGlvbiBibG9jayByZXNlcnZhdGlvbiB0aGF0IGNvbnRhaW5zIHRoZQo+IG1h
eGltdW0gbnVtYmVyIG9mIGJsb2NrcyB0aGlzIHRyYW5zYWN0aW9uIG1heSBjb25zdW1lIGluIGl0
Li4uCj4gCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29t
PgpPaywgbWFrZXMgc2Vuc2UKUmV2aWV3ZWQtYnk6IEFsbGlzb24gSGVuZGVyc29uIDxhbGxpc29u
LmhlbmRlcnNvbkBvcmFjbGUuY29tPgoKPiAtLS0KPiDCoGZzL3hmcy9saWJ4ZnMveGZzX2JtYXAu
Y8KgwqDCoMKgwqDCoCB8wqAgMiArLQo+IMKgZnMveGZzL2xpYnhmcy94ZnNfYm1hcC5owqDCoMKg
wqDCoMKgIHzCoCAyICsrCj4gwqBmcy94ZnMvbGlieGZzL3hmc19ibWFwX2J0cmVlLmMgfCAxOSAr
KysrKysrKystLS0tLS0tLS0tCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyks
IDExIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9mcy94ZnMvbGlieGZzL3hmc19ibWFw
LmMgYi9mcy94ZnMvbGlieGZzL3hmc19ibWFwLmMKPiBpbmRleCAwMTg4MzdiZDcyYzguLjlkYzMz
Y2RjMmFiOSAxMDA2NDQKPiAtLS0gYS9mcy94ZnMvbGlieGZzL3hmc19ibWFwLmMKPiArKysgYi9m
cy94ZnMvbGlieGZzL3hmc19ibWFwLmMKPiBAQCAtNDI0Miw3ICs0MjQyLDcgQEAgeGZzX2JtYXBp
X2NvbnZlcnRfdW53cml0dGVuKAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiDCoH0KPiDC
oAo+IC1zdGF0aWMgaW5saW5lIHhmc19leHRsZW5fdAo+ICt4ZnNfZXh0bGVuX3QKPiDCoHhmc19i
bWFwaV9taW5sZWZ0KAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX3RyYW5zwqDCoMKgwqDC
oMKgwqDCoCp0cCwKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19pbm9kZcKgwqDCoMKgwqDC
oMKgwqAqaXAsCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMveGZzX2JtYXAuaCBiL2ZzL3hm
cy9saWJ4ZnMveGZzX2JtYXAuaAo+IGluZGV4IDE2ZGI5NWIxMTU4OS4uMDhjMTZlNGVkYzBmIDEw
MDY0NAo+IC0tLSBhL2ZzL3hmcy9saWJ4ZnMveGZzX2JtYXAuaAo+ICsrKyBiL2ZzL3hmcy9saWJ4
ZnMveGZzX2JtYXAuaAo+IEBAIC0yMjAsNiArMjIwLDggQEAgaW50wqB4ZnNfYm1hcF9hZGRfZXh0
ZW50X3Vud3JpdHRlbl9yZWFsKHN0cnVjdAo+IHhmc190cmFucyAqdHAsCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeGZzX2lub2RlICppcCwgaW50IHdoaWNoZm9yaywK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCB4ZnNfaWV4dF9jdXJzb3Ig
KmljdXIsIHN0cnVjdCB4ZnNfYnRyZWVfY3VyCj4gKipjdXJwLAo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHhmc19ibWJ0X2lyZWMgKm5ldywgaW50ICpsb2dmbGFnc3Ap
Owo+ICt4ZnNfZXh0bGVuX3QgeGZzX2JtYXBpX21pbmxlZnQoc3RydWN0IHhmc190cmFucyAqdHAs
IHN0cnVjdAo+IHhmc19pbm9kZSAqaXAsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGludCBmb3JrKTsKPiDCoAo+IMKgZW51bSB4ZnNfYm1hcF9pbnRlbnRfdHlwZSB7Cj4gwqDCoMKg
wqDCoMKgwqDCoFhGU19CTUFQX01BUCA9IDEsCj4gZGlmZiAtLWdpdCBhL2ZzL3hmcy9saWJ4ZnMv
eGZzX2JtYXBfYnRyZWUuYwo+IGIvZnMveGZzL2xpYnhmcy94ZnNfYm1hcF9idHJlZS5jCj4gaW5k
ZXggY2ZhMDUyZDQwMTA1Li4xOGRlNGZiZmVmNGUgMTAwNjQ0Cj4gLS0tIGEvZnMveGZzL2xpYnhm
cy94ZnNfYm1hcF9idHJlZS5jCj4gKysrIGIvZnMveGZzL2xpYnhmcy94ZnNfYm1hcF9idHJlZS5j
Cj4gQEAgLTIxMywxOCArMjEzLDE2IEBAIHhmc19ibWJ0X2FsbG9jX2Jsb2NrKAo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAoYXJncy5mc2JubyA9PSBOVUxMRlNCTE9DSykgewo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgYXJncy5mc2JubyA9IGJlNjRfdG9fY3B1KHN0YXJ0LT5sKTsKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFyZ3MudHlwZSA9IFhGU19BTExPQ1RZUEVf
U1RBUlRfQk5POwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qCj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIE1ha2Ugc3VyZSB0aGVyZSBpcyBzdWZmaWNp
ZW50IHJvb20gbGVmdCBpbiB0aGUgQUcKPiB0bwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKiBjb21wbGV0ZSBhIGZ1bGwgdHJlZSBzcGxpdCBmb3IgYW4gZXh0ZW50IGluc2VydC7C
oAo+IElmCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHdlIGFyZSBjb252ZXJ0
aW5nIHRoZSBtaWRkbGUgcGFydCBvZiBhbiBleHRlbnQKPiB0aGVuCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIHdlIG1heSBuZWVkIHNwYWNlIGZvciB0d28gdHJlZSBzcGxpdHMu
Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqCj4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIFdlIGFyZSByZWx5aW5nIG9uIHRoZSBjYWxsZXIgdG8gbWFrZSB0aGUg
Y29ycmVjdAo+IGJsb2NrCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHJlc2Vy
dmF0aW9uIGZvciB0aGlzIG9wZXJhdGlvbiB0byBzdWNjZWVkLsKgIElmIHRoZQo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiByZXNlcnZhdGlvbiBhbW91bnQgaXMgaW5zdWZmaWNp
ZW50IHRoZW4gd2UgbWF5Cj4gZmFpbCBhCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAqIGJsb2NrIGFsbG9jYXRpb24gaGVyZSBhbmQgY29ycnVwdCB0aGUgZmlsZXN5c3RlbS4KPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSWYgd2UgYXJlIGNvbWluZyBoZXJlIGZy
b20gc29tZXRoaW5nIGxpa2UKPiB1bndyaXR0ZW4gZXh0ZW50Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAqIGNvbnZlcnNpb24sIHRoZXJlIGhhcyBiZWVuIG5vIGRhdGEgZXh0ZW50
Cj4gYWxsb2NhdGlvbiBhbHJlYWR5Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IGRvbmUsIHNvIHdlIGhhdmUgdG8gZW5zdXJlIHRoYXQgd2UgYXR0ZW1wdCB0bwo+IGxvY2F0ZSB0
aGUKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogZW50aXJlIHNldCBvZiBibWJ0
IGFsbG9jYXRpb25zIGluIHRoZSBzYW1lIEFHLCBhcwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKiB4ZnNfYm1hcGlfd3JpdGUoKSB3b3VsZCBoYXZlIHJlc2VydmVkLgo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGFyZ3MubWlubGVmdCA9IGFyZ3MudHAtPnRfYmxrX3JlczsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgYXJncy5taW5sZWZ0ID0geGZzX2JtYXBpX21pbmxlZnQoY3VyLT5i
Y190cCwgY3VyLQo+ID5iY19pbm8uaXAsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBjdXItCj4gPmJjX2luby53aGljaGZvcmspOwo+IMKgwqDCoMKgwqDCoMKgwqB9IGVs
c2UgaWYgKGN1ci0+YmNfdHAtPnRfZmxhZ3MgJiBYRlNfVFJBTlNfTE9XTU9ERSkgewo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgYXJncy50eXBlID0gWEZTX0FMTE9DVFlQRV9TVEFS
VF9CTk87Cj4gwqDCoMKgwqDCoMKgwqDCoH0gZWxzZSB7Cj4gQEAgLTI0OCw2ICsyNDYsNyBAQCB4
ZnNfYm1idF9hbGxvY19ibG9jaygKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IHN1Y2Nlc3NmdWwgYWN0aXZhdGUgdGhlIGxvd3NwYWNlIGFsZ29yaXRobS4KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgYXJncy5mc2JubyA9IDA7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGFyZ3Mu
bWlubGVmdCA9IDA7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBhcmdzLnR5cGUg
PSBYRlNfQUxMT0NUWVBFX0ZJUlNUX0FHOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZXJyb3IgPSB4ZnNfYWxsb2NfdmV4dGVudCgmYXJncyk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAoZXJyb3IpCgo=
