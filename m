Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE94C677F1
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 02:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjASCVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 21:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASCVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 21:21:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D505D108
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 18:21:35 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILnKa9005148;
        Thu, 19 Jan 2023 02:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=h8CnmHTFdYEt9Ny4rMZFij8m3dzZLNPSA+AOaw3kOw0=;
 b=lbFX+qi9iYD9yUOTi6gawNK44OVBO90a0it5pxJHfwVa5vjwr/cukeqpZxagMhA20CQF
 e0S472PdG1+nTbKJojRKBvunw4yjX7SO8natlkBh5PxjbClbl+dQWjTGUoyJ5D5UEK9u
 VIsVkZS3gM5VsB5MeruJeCGajVENQlAe9uJzaFKPn8M/zIdfQ56fi/wyWWGxZYsijQSI
 r+lTcZOw0oYWSZ/fdW7awF/j5U5PqP+rWB+Hqe+97vyURT9/mDeAobcemSxLv1Rxljb2
 FlGXS5X8Rih4ZUPdsQJ8ZePidDTM3gwY0qsKe2/bkTTIl0W+njO7HnA+SKHTqUFRRL7D 0g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k01163t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 02:21:32 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30INWKHS035307;
        Thu, 19 Jan 2023 02:21:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n6rgcfj57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 02:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aytZeTwTetJ3wSILsQmfL8S++WKon3G8DtCAuJRb2dTgjMcHLhq7hSiJ/RikKi086gWAanfTm25r0vYaSslk3OXEL83WCOHEZp7WMVFWkCXZtvIkrfGPRq4NAQZkwfOP2CrLGDHQPHZu093JtXudyJnumWUmoyId9h884MMwUd+2C/TbAHndk4rCieL0tX2KNrG3PczzWq6mUbQqhj+FhPMS3bV1GQus2tTToegFKacHhS0oFOwGNy5/2/tp/fOvju7aRc6WXn29vWsHKmosFqE3ipqTUi3+ifs2ly17637hG7wtQSSc3P30zxrQe5UpUiV2VW/4wBpPLSWj4JsW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8CnmHTFdYEt9Ny4rMZFij8m3dzZLNPSA+AOaw3kOw0=;
 b=AbKp5THLyMkcH5iFWcnw2o7XjD0Xc7e0TBfyznYo7nt1zudvvhNbkqscqn5DihJz++hkmCJtEcpkM7GrhmUpwRrkBmJYbAtyIz3HtvipnqI4WfvVHpy2KgZdSfAbpQIwktetS9YAUqmVH7aZ75nzixpRuHhHfhHEoUPAfVMg989nWcSZfz/mF/mE/Y4kfvM2NeaueZiFuD4tpxjhCE403AOrVa6SW0jTGfHLZbjGyyccijI+oqojKeK91x347nDMUtEFFUiBW76L+efnCozBNROT606eu5RHGp5CtGWm7cz/nt6wT2eINXe+hxrqoW/lt2BTYkuSdZmrpI6T1Ll6iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8CnmHTFdYEt9Ny4rMZFij8m3dzZLNPSA+AOaw3kOw0=;
 b=yrJGZl9RWXDlhUaqQsxifbQwpp0d293WJ3Ty9uLv7WreuJd0u/ggSeRBgnzz9PJr9mk8BPxxZL4gfr5XRHKkONhLVCDSjjzYGj8M5Se94mF2tQtOLvcTLhtgbYmmM+dnp+Zg2QNcSg02GLY3moGzgafpjyPIC3Bx+VeIMtmpE7U=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS0PR10MB6946.namprd10.prod.outlook.com (2603:10b6:8:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.5; Thu, 19 Jan
 2023 02:21:29 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 02:21:29 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Topic: [PATCH v1] xfs_admin: get/set label of mounted filesystem
Thread-Index: AQHZKsRRTYfqr/4hiECcRe8Y78HYMq6ji40AgAF4YwA=
Date:   Thu, 19 Jan 2023 02:21:29 +0000
Message-ID: <AAC756EC-BC4E-40B6-AD8F-40B2C275DC39@oracle.com>
References: <20230117223743.71899-1-catherine.hoang@oracle.com>
 <Y8dtbCouIPhNT1Zw@magnolia>
In-Reply-To: <Y8dtbCouIPhNT1Zw@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DS0PR10MB6946:EE_
x-ms-office365-filtering-correlation-id: d9aa6b52-4b50-4810-621d-08daf9c3dfbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: riDZkJPHEpgKLEZbVLzOEDrXC1ox7pMA9LYHeu89t3l1v7efexSGXoU3xBcyTsrafZ+WyV4AzVVbfzYOImODcMwVJjp0o1uyrLkzru2RENt4lkIGD2bzbKkDyW6qmmeBgomK4Dt7+dI5R5IVCSYCpk9uJy6T5wIJ5u6l8MwSyWRDkviMl/w3q9kopUcEGBbThsrH2CI4AX6Ik2aVhU/78TWOyowQaPe5SgKUwRPEjpagCvqyruWaisjRW2TnH69Ykc+kTxNVjbYMpU+RRMVH3c30JYgxyIz0dqmKwfy55YayZHyO/NLPShpDE4nPlwnTKWv2MHkN2GZzgtSvJzTPsnt+Cd26HHrR12Oxx1h51pJLnLHywBzzXH1ShRHEfI3TTIuDsFjD9yxxMM963lftxdHxEBLfXDhXfkGa7h9S1mj1wH3KlGg0MQ2LHt9cn6LuyncRuIajFY91N5r2rrmLBAAEG57g5Kt/tSucOSzRLiT+Bi5LP5xEz1Ne7z+dvAXVffXgrTZVe/Lw078050LFym7F1RbmQnP2a4wfqARuCqX1VQWWtSj8IoVYxbojbcyvyKn5zudqaaKE4ga+WCA7vRYdfMxAip/9ZhSpJrE9tSH9tvFidRXNBl4/u4IP7VgjVUDLSJoLKAWCAPufWUy/EL+TvS3xW1aVNoyJvj22FgRWFvEGnkqk0nUxaJ5lKmqflsaorBYrpeptYfUHZ1KMQCQw+SxQaMGSYX5MT7l8n/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199015)(122000001)(38100700002)(33656002)(36756003)(38070700005)(86362001)(8936002)(41300700001)(44832011)(5660300002)(64756008)(4326008)(316002)(91956017)(76116006)(66946007)(66446008)(66476007)(66556008)(6916009)(8676002)(2906002)(2616005)(83380400001)(71200400001)(478600001)(6486002)(6512007)(186003)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEV4UU5GK1QwblJLVFJMTExpMVc1OGw5bXlBSXhGdytvYUJ5di90NXgveUxn?=
 =?utf-8?B?WVYwVkJFejBzNE9NOUtORUR4WGJOdFcxN3FXWFhPMXpQRmhaQ3FJYVFEZ2ZV?=
 =?utf-8?B?TldBbW9Kclp2RTRBZmhDTWc1cG93ZU1ZOWhKMVlCM2hXM2gxWlBDWjRCTTd2?=
 =?utf-8?B?ZE92WXhJOVBDSUNRaW9EUHovM0dBN3JPMkMyY1lrcjRrNmFXdWFqRkZqTExk?=
 =?utf-8?B?clE4Z0E2dkJxQXhDRmtOc3pYbGFRd1dwOEU3ZjJwbEhwVUc3L1RRRkJEb21U?=
 =?utf-8?B?ODhnKzJNd3FXQXBWVis4dHVEUloxZVlTcUpvSGxtVXNSS2x3YjAwTmlSbDdl?=
 =?utf-8?B?MjZ0KzRyTVJLdXQ2VkJoZnc5SWdqcWxEUlBic2VjdjU1cmlqVytjRFB4UEFK?=
 =?utf-8?B?UDlxUGZZekhiazU1bjlLQmR1dzJSVkRtaWRMQlVVbnlleGRieXNqbHFXRWR4?=
 =?utf-8?B?ZFhhKzBWZ0NrVnEydkZwTDJ6U0w2ZlBLaFJHcFZRNmx1ejlmOEdOc0xYVnRn?=
 =?utf-8?B?MW1VaHRvRElrOGhiUlFNUXFUcDRCSmtIZ0J2Sk4zTHFXUlJhOUdhZ0gvYTVK?=
 =?utf-8?B?OFZIVDhpVWtsRitwYzhZTWFTMEJqVDRmUEJFdS8zTGxBN0xyWlhZcXVxb1Zs?=
 =?utf-8?B?TUlOUzEzb3RmU0FWVGpaR2N6b0hPZUZETW1pTlRpeUwzT09kbmNwa3RkZStP?=
 =?utf-8?B?dGt6QnFPWFR6K1FuQkpWNTJRNW1JUDIzWjhHMFkwYlFHNk5SMnV5RzJFUHZj?=
 =?utf-8?B?cTBSclBVUkFDbVdPeDdidTFrOStOeGVCUlR2aTE4a3RId0huTU5XVzBjOU55?=
 =?utf-8?B?UTAvQnNhUWtZUTlNV3hXRUdvcnFOLzFoWmhUMWRPcXc3YmQ5WGp0MjNxVllt?=
 =?utf-8?B?UGlPMHA1aUtUdDVBSHFUWlVadEl6dEY2K0FienFwM3hHU0tNeVZuYXN4ZWNF?=
 =?utf-8?B?bzJybHFQQjhmNFhvN3paSzBUZUpYSFhQVUo4NDlIcittR2pEbmtRRFR0bkdC?=
 =?utf-8?B?UytFZzlWYUtSaTFRTm5yWThKMnZ4K3lpQzVzM29UTWR6QUlodlhRYmRLZHVI?=
 =?utf-8?B?SHBPNjV5TkMrUkZOUEpIZzMvR2RpZWNGWmREWkw1UEg4VjQzOHRvenhIM3A0?=
 =?utf-8?B?SmhrTWRsdjJUZ3RZb0E3K2RzNEtQeUZqT0NjNkVmbjJuR1NYWittaDFDVElm?=
 =?utf-8?B?eSs2ZWsrOFBzNmc4U3NxbEhxeVlLNXpTQTl4dFF0Vkl4ZVZ0eE1WaVhtTFlU?=
 =?utf-8?B?cTZtYlRGYWlETGlKK0FqczFUZ2s4VmxMcndnYU15MlJWaVFHT2VvcTlCMG9i?=
 =?utf-8?B?QXkxVkhZMGpDTHdLVldHOUhjbDArU0RYZFRJRVlmbnJpRDNkcWt4QWRPSSth?=
 =?utf-8?B?Nm1hekxISk9WRHpRWmJ6OHUwVE5tUUw2WDU5NlV4TkZDTmJPc1RsaUhTbVdS?=
 =?utf-8?B?eTdjd2RkMXQ2MDlDM3NqcmEzUk5VVmVaK2FzYVFveW4zTzdYTVNRU3VVdXow?=
 =?utf-8?B?SEdtRlEvS3pyV25lZmFhMWdodzlkN0crNGNraStlWnlBMHdwbUhTS3hyR0t1?=
 =?utf-8?B?MWFoZ3F0MDFnOHloU0xHUjZqOG5jbGpGVzdIUkYveWZ0QUlQaHhwRmR2SlMx?=
 =?utf-8?B?akR3OGw2N2FuTGdPQm5qd3duZmdLTFR5NGs2MU9RLzJ2N1hiU2dJN2s5MGFX?=
 =?utf-8?B?QXBCbVhOVkk2VGpjTFhtdDJEVDVORGEvcmZuU2F2cWFKQ2xFVGJ1QjNnSnZI?=
 =?utf-8?B?VnZCMDdMU2hRaU4wekdac3BackU0K0NLa2dZemxlVmdDdHpBUlJudVZETHdZ?=
 =?utf-8?B?NWtSY3MwanFPSzBXSHliNHVVbDBZN3JBY2tGcDZlUWZpYkh2M3RtRFVEUkJx?=
 =?utf-8?B?dlBBTU9VRHZNL055QmVWR2lwM1o5alZ2U2ZXcnlsT1NsWktHTCtZOWRnaTJF?=
 =?utf-8?B?YTRXdVdDbG5iaDU3WUkxdW45MG85TnB2WG5yNldhM0gySlhvQWNLWE5zNXlK?=
 =?utf-8?B?UmNQZWtnb1dsMU5Hb0hYenVQa3BXakg0TFVDWDVRUm5uOHNpakgvcXNYaHlG?=
 =?utf-8?B?S2x3WEFFN1FIWjViMksvMmtkZTlUemE5bmZKSSt4YVo0TjNEZTFDMUNkOXcv?=
 =?utf-8?B?bVpxQjRZc21KQmdXQUlZQURkU1BHckdiMWJCZEx2K3FrejQ5NFh2c1NCNzNU?=
 =?utf-8?Q?Td4LokfDp0yvqbFmuUIjhAEGWAwTtWv1hLrOnVuMoex/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <505BD03074ED8F46B53267031234A11D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5EMjcnqFvFlxU0IJBDaZMCGK8tjx0JBhodpNClsBWZT4JhlkqIaZaXpCAX/10kND4HJkwHxX/N2dhmS+K6nNaMzCRiuwwOwO4BjN/faOZNC5tZ3oKb20amKTZVbOBCaogRFmW/dYdnIvFxTxpGZh4v8HRUpmpvxpSZoNYHhmzWC8CrF/0x1IaDaWQrckh8bg5XZk1S1OgWk63efy5bppArE5v0C9vEIVHhJmVbILLcvg8NpSjF/Vu/D4CmsGM2Sr3HqUI4cXzF5YVL6KF1TPnph3NaFabJURAZgoERGqyTqQD0223cgqTM7LzlSKHccX6cqHRmRmkiNz+vqKHPlE9Et5opqjlxSV/fHkkJqIvlb7a4R8nPFvA+HEzWm+/Htfj2mJ6O5LqVUIF+EVu19PfECG6xUQbHi8ocW1YJv8eQFp13640kBNR+Px+lBptgbwcGisOXBtqnIGik+TthQuUSRapmZPjh4p7NjeSuMRo1G0cytn5IlrAxuI9Gq7tGYYIoaCxymzLhjmup4InZstOsFaZaxj3UgmjqY0t6WjSeDNSZapwIY4XBdGMhHRiu7Mwte4kznvzkmB+ilVgQt3wPcubjsN/xAZmAVl4s5SWQDVquM2oCJA8eOuQlrvSRIfLWR874ynjybtZvnjn/nQIOQoePVmiAUxi8SYrcgnBUqiO0dnDdtZMzMRJEqxrsXUpZd1e7sdg918UoHY5pg0aTNxsrtn3PSw1id9o10F5URoJ8p4EXnRZolhKA4DJ7gnSBUEtQLcTslft7EzohwHxaYDWHTjM4hIlPk5LVIZlUg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9aa6b52-4b50-4810-621d-08daf9c3dfbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 02:21:29.3703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbrs972Y6P/JSnwOrM4aw4uHWbfRmEsaMVrG32XIfos4b4SFzG2Gip+lCRFO06miN3BUkoxZj1uq9TcKB5WbEmSAeLhE+PzxErkW3UpxqcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190013
X-Proofpoint-GUID: VPeLXiOvKIY7QJIg_k54Jcr7RrRBCi2U
X-Proofpoint-ORIG-GUID: VPeLXiOvKIY7QJIg_k54Jcr7RrRBCi2U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBKYW4gMTcsIDIwMjMsIGF0IDc6NTQgUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBKYW4gMTcsIDIwMjMgYXQgMDI6Mzc6NDNQ
TSAtMDgwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gQWRhcHQgdGhpcyB0b29sIHRvIGNh
bGwgeGZzX2lvIHRvIGdldC9zZXQgdGhlIGxhYmVsIG9mIGEgbW91bnRlZCBmaWxlc3lzdGVtLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBDYXRoZXJpbmUgSG9hbmcgPGNhdGhlcmluZS5ob2FuZ0Bv
cmFjbGUuY29tPg0KPj4gLS0tDQo+PiBkYi94ZnNfYWRtaW4uc2ggfCA5ICsrKysrKy0tLQ0KPj4g
MSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+IA0KPj4g
ZGlmZiAtLWdpdCBhL2RiL3hmc19hZG1pbi5zaCBiL2RiL3hmc19hZG1pbi5zaA0KPj4gaW5kZXgg
YjczZmIzYWQuLmNjNjUwYzQyIDEwMDc1NQ0KPj4gLS0tIGEvZGIveGZzX2FkbWluLnNoDQo+PiAr
KysgYi9kYi94ZnNfYWRtaW4uc2gNCj4+IEBAIC0yOSw5ICsyOSwxMSBAQCBkbw0KPj4gCWopCURC
X09QVFM9JERCX09QVFMiIC1jICd2ZXJzaW9uIGxvZzInIg0KPj4gCQlyZXF1aXJlX29mZmxpbmU9
MQ0KPj4gCQk7Ow0KPj4gLQlsKQlEQl9PUFRTPSREQl9PUFRTIiAtciAtYyBsYWJlbCI7Ow0KPj4g
KwlsKQlEQl9PUFRTPSREQl9PUFRTIiAtciAtYyBsYWJlbCINCj4+ICsJCUlPX09QVFM9JElPX09Q
VFMiIC1yIC1jIGxhYmVsIg0KPj4gKwkJOzsNCj4+IAlMKQlEQl9PUFRTPSREQl9PUFRTIiAtYyAn
bGFiZWwgIiRPUFRBUkciJyINCj4+IC0JCXJlcXVpcmVfb2ZmbGluZT0xDQo+PiArCQlJT19PUFRT
PSRJT19PUFRTIiAtYyAnbGFiZWwgLXMgIiRPUFRBUkciJyINCj4+IAkJOzsNCj4+IAlPKQlSRVBB
SVJfT1BUUz0kUkVQQUlSX09QVFMiIC1jICRPUFRBUkciDQo+PiAJCXJlcXVpcmVfb2ZmbGluZT0x
DQo+PiBAQCAtNjksNyArNzEsOCBAQCBjYXNlICQjIGluDQo+PiAJCQlmaQ0KPj4gDQo+PiAJCQlp
ZiBbIC1uICIkSU9fT1BUUyIgXTsgdGhlbg0KPj4gLQkJCQlleGVjIHhmc19pbyAtcCB4ZnNfYWRt
aW4gJElPX09QVFMgIiRtbnRwdCINCj4+ICsJCQkJZXZhbCB4ZnNfaW8gLXAgeGZzX2FkbWluICRJ
T19PUFRTICIkbW50cHQiDQo+PiArCQkJCWV4aXQgJD8NCj4gDQo+IEknbSBjdXJpb3VzLCB3aHkg
ZGlkIHRoaXMgY2hhbmdlIGZyb20gZXhlYyB0byBldmFsK2V4aXQ/DQoNCkZvciBzb21lIHJlYXNv
biBleGVjIGRvZXNu4oCZdCBjb3JyZWN0bHkgcGFyc2UgdGhlICRJT19PUFRTIGFyZ3VtZW50cy4N
CkkgZ2V0IHRoaXMgZXJyb3Igd2hlbiB1c2luZyBleGVjOg0KDQojIHhmc19hZG1pbiAtTCB0ZXN0
IC9kZXYvc2RhMg0KdGVzdCc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4gDQo+IE90aGVy
d2lzZSwgdGhpcyBsb29rcyBnb29kIHRvIG1lLg0KPiANCj4gLS1EDQo+IA0KPj4gCQkJZmkNCj4+
IAkJZmkNCj4+IA0KPj4gLS0gDQo+PiAyLjI1LjENCj4+IA0KDQo=
