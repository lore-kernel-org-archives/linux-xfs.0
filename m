Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E48DC77B72
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 17:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjDTRKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDTRKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 13:10:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A498A11C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 10:10:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KDtfCs019865;
        Thu, 20 Apr 2023 17:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rs1ITBDgewtttuwuS/+YnzbsUESB6fNq7TeXebOWbA8=;
 b=mztlx6jsZ9oGu6GUByejlKk9xZHqN/xeNMCQfq2UMMRGcEmBthtqzgN2XtFVvUVG2wgZ
 I++NpEw2SYSyo0JVVknQqblOuEBOUxZKWP0TLQS9ESDUaieLAHkv746PFOHDzE9Uq4r4
 EQAPU6upTo25Ao2ONBLR2nDL9vXXQYbXh0wQdKhwJyAisESQd9FfEeXSJJMfMHXkQFMx
 8jxj97s9dVE4x16NQQ+JXnsEWEfGw5ROqWqjLnmnlErVj1vj6amKS5K54m5tl/R5qJyf
 1HD/O4u1F+s1uBll3UtDJ30X4UVgTDQLJO5hQ83n8sP0ebDd4qCJOWZCsPRuTd8WfJVj xA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pymfukdu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:10:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KGLYF8037274;
        Thu, 20 Apr 2023 17:10:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcek450-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSh9zjgTMG2+6kjP1WMDCeyxspeXbmakT9BmEX0XcTbkGw1kH+76Txo/kEL8y/gfaCmC8Uumb9X1l6+TG2SOS0SeiAeJSRi7h6OV35xq0Ur/ABjmIc8JtG/VI6ypMILpPFyvStJ84AdZbnewRjfjo5dJ4AUPjChcSdGpZ5oIA1fILYYB3t1xq9wYcw7LEvz0kzUScDghdLc9TzGPaL9v9kCOWWIoz8GouGJhaxVRpI9eGGBdSR2rJFkwyXONHQidCCKrch03GZ2qQJGMOoS/jtl0ATG+v3jqbvQk12DQXxHBlpcvUp7E6vknblJ0IM4RshzMfQIjl596n7maWWwRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rs1ITBDgewtttuwuS/+YnzbsUESB6fNq7TeXebOWbA8=;
 b=WCXh+OihrSndAcdTVifLE/hS9Bp5VNW4ptV4L5ySG6GlBWQBsCpWXiyx1aUaa7rcIB1J1HSg7abMhaFRrY0FLzHg+Qb7ZZIIVUxWV6uJ15OxJdCqOY37t2rgSNNBxLk9GBbKudWrkFIin1ZhGYHxKwxomM8gfWV9/3Cxxjx2TTI+KzkgPGeYsy/p+ZdAsZFKiKt74bl4ngGG0ITWPctg/oca2FOh9d5sKfur34g4SeoKnR6ZT3FvqQ4vOoZmZ06Yw58SvVgNqNxjR+Mrgi2o1R4piMhQ7xchQ+o5ZSqo+uVm7y6B/hCVUcm9m1yq6dpDgs3C7Eo+1ECvxScgSNLlUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs1ITBDgewtttuwuS/+YnzbsUESB6fNq7TeXebOWbA8=;
 b=wM//U+6cFT9boK/UsayzsuXAu8M0rwStGLx0ghLmNSFcjB7L1V5RlKiBx2AL/5M5SUlR4CPzjXCy6TI/VH9IbIcuS8MKP4iEaSgYYqVbwcmBEi/Rase52UOAhnzcszAyLek4bBEB4A3qyixbphJbmXPdLn96oLGmEALjLs+22bw=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS0PR10MB7362.namprd10.prod.outlook.com (2603:10b6:8:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:10:42 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%6]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:10:42 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Thread-Topic: [PATCH 2/2] xfs: log recovery stage split EFIs with multiple
 extents
Thread-Index: AQHZbySnyB0tBYYonkGJ9xOudd8YMq8zYG0AgAEXTYA=
Date:   Thu, 20 Apr 2023 17:10:42 +0000
Message-ID: <C92853D7-A856-4BCC-880E-6DE6D3CC4EF8@oracle.com>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-3-wen.gang.wang@oracle.com>
 <20230420003050.GX3223426@dread.disaster.area>
In-Reply-To: <20230420003050.GX3223426@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS0PR10MB7362:EE_
x-ms-office365-filtering-correlation-id: 20064487-f851-4efb-8590-08db41c22c01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1yDg0DDpwEk/T2MsoYvY3wEhSKH2ozZ2z5gG3zNpLkDo+AmhTMV1LOzzYxrwk8xh8UrTE/PIkU26SpfkePB0qMH4WvmhzPhCrSk6zJigZ7BjxCSGcN4uSpNafXhadZ8xvnF7E8dg9D+ZKlOHNaxpKEoz4oFUJszSIwsAa3gwjMhELhfs5pgj2g33iT+sGucbUac+gmlclCl3FwpqfDCZFHF8A+bO+fbL19q4NsM4NXEi7RajpUQvorrvA6Axl7Ht5TVXq1WIq5AxE43sf5m4JELdN5hC/uJzS/9fhIDuIxKRqd7sF+/n25gXbnJ4INkONT8WljrkQGucO9syzmOSQ8gqIYDYen+6vbm07aoIaD6AjIXW6D+xE8yJC4fNDCLN2IhM1II712C5qrZ/SqXlfKog/Si84aijmriE1RDrE2mGHutJf9FeF2ozCAG1lgfUTQ7l4yRFynMg2Bgn5UBMHaRSHV/ZstMvy/ipdAi+E0ga3Ondwot2CklNtpZeFL5n62PDtwRgEgceNyStELkXAbevkIXISZrW8RVhfm4gHe1vgmrFxketc2O+f7yiOLkH1CnLhhyOl0p/KrDR42QHGadvffs+3eWQIQ+gLUNhCwKVBo8F0I6FIUv2irZrTmx2rqXS7ZCxSWxBnB2gtbWAPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199021)(122000001)(38100700002)(6506007)(6512007)(186003)(86362001)(6486002)(66556008)(66946007)(76116006)(66446008)(66476007)(6916009)(41300700001)(64756008)(36756003)(478600001)(91956017)(316002)(4326008)(83380400001)(71200400001)(38070700005)(53546011)(33656002)(2906002)(8676002)(8936002)(2616005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTlOMyt1eHVMQ0VEa1BFbUJGcDRRNmE2UXNHNmZiVEpkMUZyYjdmd2FnWGph?=
 =?utf-8?B?Y2dxY3VKZ2swWUFmaGUzMXFuc2k2WndQMzh0T0FnWmd6bDhiZlN3Y2l5cEY1?=
 =?utf-8?B?MnpSRk1TL0FCc0ZZelkvVFNnZWtyd0MyU0xsdHEvek9IM2NWWmoyUEVUeFlE?=
 =?utf-8?B?REVHWGxEWWtWSG1QU3VuLzBoL2VTMXJBZ0xSRjllSDgvVmJOVnExZEJ1Z1Mw?=
 =?utf-8?B?OC9NWlVxeEFvN2VraFhoVjRPZFV4MXFTeCtuYlNWR0V6NkkxWWVheDBBNTZG?=
 =?utf-8?B?MG93WkFWRXVFNGFjL1V0NGFEc0MxR1dCeWl4RE55R00rRkhheGJwSWwxWklo?=
 =?utf-8?B?aFlBV1FUaGhkYWJLbWpyUWJJSXRjV0tLSFpWcGV2T1BtWXp6K2UxZjRldFpU?=
 =?utf-8?B?alVOd1QrS2pFeWZDZThCaVd3UjJ1WFMwVzdhcCsxSUFER0ZOT2U3VGR4MlFu?=
 =?utf-8?B?Nll2K1JXdVU4Sm9zSWRCdVd3OFVBOHBqWTk5emJwMVB1eDNYaDIzT1hqZm9G?=
 =?utf-8?B?OWFMaVg2OFlVQkZZeWdRbnRyOTVJL05ZOXJkako4NjhrSGZFc1FHZWNPek16?=
 =?utf-8?B?U3ExS1pIb0h0RmFUMGFQVG9QUGJrZVNueFBtWG5qdnlKMnpWQnVRbVVoZmhH?=
 =?utf-8?B?d1F6UHNmNzFaOEVJNWs5b0dDU3E3aTVFcEtvbkI5ZWdZK1h6QTl0eStzR080?=
 =?utf-8?B?MmxUWnF1N3VTTEVHcE9XUzZWMmtENkUrZFlnamtrWVhqZG1KdlBHZ1pHcmlR?=
 =?utf-8?B?V3BGYXhyUm9xSUxYT09uN1Exd0tndkZobWg0WTNsc2c4M2RvOU1xeXowN2Ir?=
 =?utf-8?B?eVVOUlN4ZGxaT0h4Mkw1ZlZ5T3g4RnFoelE0MDlLQUZ6a1pVbjRZNXdFZDlD?=
 =?utf-8?B?bzZGTGhTOWNmSldRNlBuMVNhZUQzYkRUWGpzM0Fac1M1TEo4NWZHRWo3RjMv?=
 =?utf-8?B?dXlmY3hNanlqTXZTa0g5WWREOGNSWUlWTDk1bzR1NkI0SWp6MVdVZE1wS2Z6?=
 =?utf-8?B?eS9xZ1FVWHU2ODZEdHlaeFZXQVhhdUJYS1dBMjBFQWhOYysxWG12TkR4ajkw?=
 =?utf-8?B?TWs3bnMrci95MjAvZWhvSUVYVGpZNnhFajc3ZTRlaXRYL1ozZS93K1VkczB5?=
 =?utf-8?B?azJrMFF1aUcrcDQrL01UMnEyNHVVRkRpNkZ0ZlFyUVpsd2pSWTl2eTB0dTdD?=
 =?utf-8?B?YmhHM2JOaDZwemZNOXhMb1VvK2Z3ZVJ1TitSWHVpWU5MOFlIS3BubDVkdmtO?=
 =?utf-8?B?b3F2Sys0ZStwRGNCcFFXTnI2M0FzdGtib2hwaVcwRFd5Sy9lNDlRODA5ZG92?=
 =?utf-8?B?Vy9nVzlHSm9hakNGT0Fpc0RrNHBXZE9KWXZwa2lzallWZjBXcFBFS2tQd3VL?=
 =?utf-8?B?dmxlMWk0dmlHbGJTMEdtUW9yWHcvNjJBVXBpOXhuZmJMbE1PVVhMbldPSElV?=
 =?utf-8?B?RW4rd3I1dURmVjY0bjNxdGQ2RHlPVklZbXp4bU5nMUpKa1FpK2kyOWV0RFRY?=
 =?utf-8?B?SWJyQzZ3Q05vN0s4b2N5V2djYkRkN2xneVRFcWZPRGYwTDFneVhiejM2TXdP?=
 =?utf-8?B?WWkxcThhdU9XUzNNc2hOWTVTcXc1Z2RhUzFsRkh2Q3N4WjZLd2p0dXkvckNr?=
 =?utf-8?B?bVZaYjdDWnpUTWMzUm5wYUxTaTdlTDFXaVM0YjIxNDJBdjRqSmZyS2hIdE9v?=
 =?utf-8?B?ZTdNTXBVWlc0K09PQlYyNHdMNHN1c0VCY2NPZ1FGbkFrTHUzbjBNWlBHN1kr?=
 =?utf-8?B?aW52bXh0b0ZIak1XU1FEdmh1L0NodG9Ca05JWVJYWFBWOUlyQlVkeGxQSUl0?=
 =?utf-8?B?bXkxMm8rOUkvT2lBcW9FWFpVSm4waTcvUmhROVJXSGo2cmdocXJKalh0VGxs?=
 =?utf-8?B?a0NWb3cxN0s3ZFNObDVhbVlsS1ZQL25BeFpqa1BzaGl1a1NZOUkweS94eXlB?=
 =?utf-8?B?blpLKzIzWVFiWFE2NjBuR1JiTkRHK3ZEUmpqTHVQbjFXcVRuNG9ZR1NveFpV?=
 =?utf-8?B?NkZ2OFByN2JFZVZiMWdDcmNaYUMyU0F5YTBRUjRXSHYvZ3B6Z2VSdllaVit6?=
 =?utf-8?B?TXkzK3lvZkpJei8yNTVXK2FZWDZmTkprZVNMeXJGTHlLYlhhV1pQTW1yQXVW?=
 =?utf-8?B?WnBZNXdkaDEyc0tWb0MxY1pYT2tmQW5iYk96TGpuYzdCSTd0VjF5Y2loT1F6?=
 =?utf-8?Q?SpDEDNdfF5Mp/ZHYJJFWXVLroQZ03Om9ejWyoqXVET9f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC41DFF7395BAF4B8E797B82F1907164@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OVeC3SPQMeBwr431lSnJQmCbZZdAaf+Xa1beC4D4qceKOJK9SOIm1MDpqRC5ajLAmC16qJMm6YY1MoJaovjldMh3eEWyrRVeat0kDVzIEuX8lz6HfCM96z3ccm7eXIvWNxeICqhpEHOZEvvSXP3MeBxrG16UUivQy7oeVufXDe8jKFZiRU3YHOXn6P4R0nNdljhs7vrMyVLdKOVee9rjd05WbwgHqG4OjdVi1HHBSCdETVsLN/lVo06tUMEYntJBTD6/5bjT2jo9eZET7UC0OGsEbTzbSm2htPZFDOKVUEa7sm49iVwusfZza/mHxgI91hhb2sAz2dcovOQMV7w9W144GCZnBYl5SwuYGS4o8p3xtqycn7vQc6/2YD4+VlLgIQre4ymPzsIWtMR3aXWGmCGlGSthc6/5i9pHg9oQnkv/lPz0baeVLmvlhvLBED5HF8Zq95QZtGFF61Q01bU5yW5cpdemk54mtJg2UkLrOavUS20ZTMPcoaBQHJfAYT/iUGw9n3+IWj/P1PyA1x6Zmpn8qzM26AiJkatTMZjHplrMdWGzzErhwmGFlH3/lX2rvzcGQ8WTO0Lo4HKcnO6KosOY87IgaCpskBs8ivSMBHG7697tG/49Wgdnr5a+Dn83PfrzGudZ6HhqpfYuW02emEjoqk8lzjMxR9c78tTwK95VECHcHgeVPUOTIeWu5Cvby+4cfJnpMdvpi5HfZnmPidzArqMZsfOoW0Pf/i+MW+RR7qsOmJ+/IEKwF2igByvKY3tePAfv4rxLi5Gd7X5qNuSIN7KB5j9adTZc04QTO+M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20064487-f851-4efb-8590-08db41c22c01
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 17:10:42.0689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EJ9fMdwh/bCr4e0YFDEWI/xVPY71Kf8hsE18XI3M3ZOpjCBrbaNUZmbgNqGfnwYBNLWfR9jYolDnEinLEPSnlaxnYfiiT2o+3SYFhC5ICb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7362
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_13,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200143
X-Proofpoint-GUID: usavAiCUTB_yJhk0TNNwK-OuIaCBgS8I
X-Proofpoint-ORIG-GUID: usavAiCUTB_yJhk0TNNwK-OuIaCBgS8I
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gQXByIDE5LCAyMDIzLCBhdCA1OjMwIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBBcHIgMTQsIDIwMjMgYXQgMDM6NTg6
MzZQTSAtMDcwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gQXQgbG9nIHJlY292ZXJ5IHN0YWdl
LCB3ZSBuZWVkIHRvIHNwbGl0IEVGSXMgd2l0aCBtdWx0aXBsZSBleHRlbnRzLiBGb3IgZWFjaA0K
Pj4gb3JnaW5hbCBtdWx0aXBsZS1leHRlbnQgRUZJLCBzcGxpdCBpdCBpbnRvIG5ldyBFRklzIGVh
Y2ggaW5jbHVkaW5nIG9uZSBleHRlbnQNCj4+IGZyb20gdGhlIG9yaWdpbmFsIEVGSS4gQnkgdGhh
dCB3ZSBhdm9pZCBkZWFkbG9jayB3aGVuIGFsbG9jYXRpbmcgYmxvY2tzIGZvcg0KPj4gQUdGTCB3
YWl0aW5nIGZvciB0aGUgaGVsZCBidXN5IGV4dGVudHMgYnkgY3VycmVudCB0cmFuc2FjdGlvbiB0
byBiZSBmbHVzaGVkLg0KPj4gDQo+PiBGb3IgdGhlIG9yaWdpbmFsIEVGSSwgdGhlIHByb2Nlc3Mg
aXMNCj4+IDEuIENyZWF0ZSBhbmQgbG9nIG5ldyBFRklzIGVhY2ggY292ZXJpbmcgb25lIGV4dGVu
dCBmcm9tIHRoZQ0KPj4gICAgb3JpZ2luYWwgRUZJLg0KPj4gMi4gRG9uJ3QgZnJlZSBleHRlbnQg
d2l0aCB0aGUgb3JpZ2luYWwgRUZJLg0KPj4gMy4gTG9nIEVGRCBmb3IgdGhlIG9yaWdpbmFsIEVG
SS4NCj4+ICAgIE1ha2Ugc3VyZSB3ZSBsb2cgdGhlIG5ldyBFRklzIGFuZCBvcmlnaW5hbCBFRkQg
aW4gdGhpcyBvcmRlcjoNCj4+ICAgICAgbmV3IEVGSSAxDQo+PiAgICAgIG5ldyBFRkkgMg0KPj4g
ICAgICAuLi4NCj4+ICAgICAgbmV3IEVGSSBODQo+PiAgICAgIG9yaWdpbmFsIEVGRA0KPj4gVGhl
IG9yaWdpbmFsIGV4dGVudHMgYXJlIGZyZWVkIHdpdGggdGhlIG5ldyBFRklzLg0KPiANCj4gV2Ug
bWF5IG5vdCBoYXZlIHRoZSBsb2cgc3BhY2UgYXZhaWxhYmxlIGR1cmluZyByZWNvdmVyeSB0byBl
eHBsb2RlIGENCj4gc2luZ2xlIEVGSSBvdXQgaW50byBtYW55IEVGSXMgbGlrZSB0aGlzLiBUaGUg
RUZJIG9ubHkgaGFkIGVub3VnaA0KPiBzcGFjZSByZXNlcnZlZCBmb3IgcHJvY2Vzc2luZyBhIHNp
bmdsZSBFRkksIGFuZCBleHBsb2RpbmcgYSBzaW5nbGUNCj4gRUZJIG91dCBsaWtlIHRoaXMgcmVx
dWlyZXMgYW4gaW5kaXZpZHVhbCBsb2cgcmVzZXJ2YXRpb24gZm9yIGVhY2gNCj4gbmV3IEVGSS4g
SGVuY2UgdGhpcyBkZS1tdWx0aXBsZXhpbmcgcHJvY2VzcyByaXNrcyBydW5uaW5nIG91dCBvZiBs
b2cNCj4gc3BhY2UgYW5kIGRlYWRsb2NraW5nIGJlZm9yZSB3ZSd2ZSBiZWVuIGFibGUgdG8gcHJv
Y2VzcyBhbnl0aGluZy4NCj4gDQoNCk9oLCB5ZXMsIGdvdCBpdC4NCg0KPiBIZW5jZSB0aGUgb25s
eSBvcHRpb24gd2UgcmVhbGx5IGhhdmUgaGVyZSBpcyB0byByZXBsaWNhdGUgaG93IENVSXMNCj4g
YXJlIGhhbmRsZWQuICBXZSBtdXN0IHByb2Nlc3MgdGhlIGZpcnN0IGV4dGVudCB3aXRoIGEgd2hv
bGUgRUZEIGFuZA0KPiBhIG5ldyBFRkkgY29udGFpbmluZyB0aGUgcmVtYWluaW5nIHVucHJvY2Vz
c2VkIGV4dGVudHMgYXMgZGVmZXJlZA0KPiBvcGVyYXRpb25zLiAgaS5lLg0KPiANCj4gMS4gZnJl
ZSB0aGUgZmlyc3QgZXh0ZW50IGluIHRoZSBvcmlnaW5hbCBFRkkNCj4gMi4gbG9nIGFuIEVGRCBm
b3IgdGhlIG9yaWdpbmFsIEVGSQ0KPiAzLiBBZGQgYWxsIHRoZSByZW1haW5pbmcgZXh0ZW50cyBp
biB0aGUgb3JpZ2luYWwgRUZJIHRvIGFuIHhlZmkgY2hhaW4NCj4gNC4gQ2FsbCB4ZnNfZGVmZXJf
b3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpIHRvIGNyZWF0ZSBhIG5ldyBFRkkgZnJvbQ0KPiAgIHRo
ZSB4ZWZpIGNoYWluIGFuZCBjb21taXQgdGhlIGN1cnJlbnQgdHJhbnNhY3Rpb24uDQo+IA0KPiB4
ZnNfZGVmZXJfb3BzX2NhcHR1cmVfYW5kX2NvbW1pdCgpIHdpbGwgdGhlbiBhZGQgYSB3b3JrIGl0
ZW0gdG8gdGhlDQo+IGRlZmVyZWQgbGlzdCB3aGljaCB3aWxsIGNvbWUgYmFjayB0byB0aGUgbmV3
IEVGSSBhbmQgcHJvY2VzcyBpdA0KPiB0aHJvdWdoIHRoZSBub3JtYWwgcnVudGltZSBkZWZlcnJl
ZCBvcHMgaW50ZW50IHByb2Nlc3NpbmcgcGF0aC4NCj4gDQoNClNvIHlvdSBtZWFudCB0aGlzPw0K
DQpPcmlnIEVGSSB3aXRoIGV4dGVudDEgZXh0ZW50MiBleHRlbnQzDQpmcmVlIGZpcnN0IGV4dGVu
dDENCkZ1bGwgRUZEIHRvIG9yaWcgRUZJDQp0cmFuc2FjdGlvbiByb2xsLA0KeGZzX2RlZmVyX29w
c19jYXB0dXJlX2FuZF9jb21taXQoKSB0byB0YWtlIGNhcmUgb2YgZXh0ZW50MiBhbmQgZXh0ZW50
Mw0KDQpJZiBzbywgSSBkb27igJl0IHRoaW5rIGl04oCZcyBzYWZlLg0KQ29uc2lkZXIgdGhhdCBj
YXNlIHRoYXQga2VybmVsIHBhbmljIGhhcHBlbmVkIGFmdGVyIHRoZSB0cmFuc2FjdGlvbiByb2xs
LA0KZHVyaW5nIG5leHQgbG9nIHJlcGxheSwgdGhlIG9yaWdpbmFsIEVGSSBoYXMgdGhlIG1hdGNo
aW5nIEVGRCwgc28gdGhpcyBFRkkNCmlzIGlnbm9yZWQsIGJ1dCBhY3R1YWxseSBleHRlbnQyIGFu
ZCBleHRlbnQzIGFyZSBub3QgZnJlZWQuDQoNCklmIHlvdSBkaWRu4oCZdCBtZWFuIGFib3ZlLCBi
dXQgaW5zdGVhZCB0aGlzOg0KDQpPcmlnIEVGSSB3aXRoIGV4dGVudDEgZXh0ZW50MiBleHRlbnQz
DQpmcmVlIGZpcnN0IGV4dGVudDENCk5ldyBFRkkgZXh0ZW50MiBleHRlbnQzDQpGdWxsIEVGRCB0
byBvcmlnIEVGSQ0KdHJhbnNhY3Rpb24gcm9sbCwNCnhmc19kZWZlcl9vcHNfY2FwdHVyZV9hbmRf
Y29tbWl0KCkgdG8gdGFrZSBjYXJlIG9mIGV4dGVudDIgYW5kIGV4dGVudDMNCg0KVGhlIHByb2Js
ZW0gd2lsbCBjb21lYmFjayB0byB0aGUgbG9nIHNwYWNlIGlzc3VlLCBhcmUgd2UgZW5zdXJlZCB3
ZSBoYXZlDQp0aGUgc3BhY2UgZm9yIHRoZSBuZXcgRUZJPyANCg0KDQo+IFRoZSBmaXJzdCBwYXRj
aCBjaGFuZ2VkIHRoYXQgcGF0aCB0byBvbmx5IGNyZWF0ZSBpbnRlbnRzIHdpdGggYQ0KPiBzaW5n
bGUgZXh0ZW50LCBzbyB0aGUgY29udGludWVkIGRlZmVyIG9wcyB3b3VsZCB0aGVuIGRvIHRoZSBy
aWdodA0KPiB0aGluZyB3aXRoIHRoYXQgY2hhbmdlIGluIHBsYWNlLiBIb3dldmVyLCBJIHRoaW5r
IHRoYXQgd2UgYWxzbyBuZWVkDQo+IHRoZSBydW50aW1lIGNvZGUgdG8gcHJvY2VzcyBhIHNpbmds
ZSBleHRlbnQgcGVyIGludGVudCBwZXIgY29tbWl0IGluDQo+IHRoZSBzYW1lIG1hbm5lciBhcyBh
Ym92ZS4gaS5lLiB3ZSBwcm9jZXNzIHRoZSBmaXJzdCBleHRlbnQgaW4gdGhlDQo+IGludGVudCwg
dGhlbiByZWxvZyBhbGwgdGhlIHJlbWFpbmluZyB1bnByb2Nlc3NlZCBleHRlbnRzIGFzIGEgc2lu
Z2xlDQo+IG5ldyBpbnRlbnQuDQo+IA0KPiBOb3RlIHRoYXQgdGhpcyBpcyBzaW1pbGFyIHRvIGhv
dyB3ZSBhbHJlYWR5IHJlbG9nIGludGVudHMgdG8gcm9sbA0KPiB0aGVtIGZvcndhcmQgaW4gdGhl
IGpvdXJuYWwuIFRoZSBvbmx5IGRpZmZlcmVuY2UgZm9yIHNpbmdsZSBleHRlbnQNCj4gcHJvY2Vz
c2luZyBpcyB0aGF0IGFuIGludGVudCByZWxvZyBkdXBsaWNhdGVzIHRoZSBlbnRpcmUgZXh0ZW50
IGxpc3QNCj4gaW4gdGhlIEVGRCBhbmQgdGhlIG5ldyBFRkksIHdoaWxzdCB3aGF0IHdlIHdhbnQg
aXMgdGhlIG5ldyBFRkkgdG8NCj4gY29udGFpbiBhbGwgdGhlIGV4dGVudHMgZXhjZXB0IHRoZSBv
bmUgd2UganVzdCBwcm9jZXNzZWQuLi4NCj4gDQoNClRoZSBwcm9ibGVtIHRvIG1lIGlzIHRoYXQg
d2hlcmUgd2UgcGxhY2UgdGhlIG5ldyBFRkksIGl0IGNhbuKAmXQgYmUgYWZ0ZXIgdGhlIEVGRC4N
CkkgZXhwbGFpbmVkIHdoeSBhYm92ZS4NCg0KdGhhbmtzLA0Kd2VuZ2FuZw0KDQo+IENoZWVycywN
Cj4gDQo+IERhdmUuDQo+IC0tIA0KPiBEYXZlIENoaW5uZXINCj4gZGF2aWRAZnJvbW9yYml0LmNv
bQ0KDQo=
