Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C47C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 20:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358434AbiEEUwX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 16:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiEEUwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 16:52:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEAC40A20
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 13:48:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245JT0eh013502;
        Thu, 5 May 2022 20:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rR/6aEE7TV7e0/YuFcX2+HP8N3wcO+oW4G4ytLS3vEI=;
 b=v4B/Sy0LD4HqRp/Kv4Na8bHlkssb/JdnpC5J320ru/glZbVUJadcjTAss98ndTSUSOJc
 XUfyg+V1c2Z2EpA5RVEQWmW2BckCMLljY2w27yTAPfrsZU3GuQvFNsTLIGJp+XhLAGYt
 1Go2cAk8kP001RNHX20gotapLQdkyCLiRZ3yMzg5kDic1cN451BCFVbzYLIsAzmzTxcf
 yuEOQSBr/JALdzEZS5tBgPLeWIu83v4nsSNImop582bhmtKpeRD7Up2TF23U40nk8csB
 4uGz+mrktQaKR90wywL0W07tN10txFC9xF6ptdIwhtehuDsI2ZZYthHnv4FZESFpCUUm Bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsmhmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 20:48:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245KPDOh022416;
        Thu, 5 May 2022 20:48:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujb81f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 20:48:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0xJ4c9fSQbf1f0Hnz/9nef0RZE8dS2hp3BJbbLY8divdDF+8Z7pInOGRc7JJqc8lFu1n5/J8Cl4fmGcTkXgihYXRLf67MpnsVZVVF/SAihSInwNglW+tQ9z05Ps20bmYQf/62XmrCzPC+90wbP9X9tn0bPAMx7tNgS94SSG6YvN0nubCG+vcMdRDNy0jLkNd3nZ8lGGdQwQ/npnlV+yTXS5TZlCneswD401A/k91QJcuxzKj9tz2fjRh3QLpRY6v8mkCZH5gHXRjlqa4F/a44GZm4oaJQ92mI/Ms9i6UU4CO9zorU2ZovqKj3tGO0rlBHriW+F8rzUqLLE4FHs3lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rR/6aEE7TV7e0/YuFcX2+HP8N3wcO+oW4G4ytLS3vEI=;
 b=nIVX3ZSQVgBPnlORwNITCljNvbljyrScB9DV0oi3OaFSNzVoX/Y3GOvim2YGTzci3wE9vZQVFUT3/Dm3+4cMr/e4/SAK7PefLOF/0kQ7nGBMnT/Y4/x2oDMJ216Zcm8XsOYRrbGp6RbLPAzDaAdcpyGk3Ri2z7z/3IoPqpa6fxtLmfR6e7ohnNH4fJlK+hGXCjBTDDzyPJicbMNqA3Zr7Wkc0OntjBNQ4pmDVtCNNooYB1PVEV6GmSHdk79oj0Gr4a33D7mnWlwUsObiE/ZtphgP4Ze7R+3REbT60jMn3OJvMMr5lIElZxbCiAERc4kHdT3km3BwjfDnfUoOhJPKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rR/6aEE7TV7e0/YuFcX2+HP8N3wcO+oW4G4ytLS3vEI=;
 b=kNsct7jWct/ohXhSH/jBG5VH6Amn8dm8XiHaPIFbHnVHmtjpB9ecO8Vc+cIsf0GHVcn9xBR9dOVpCcpXLFwMzzNaumx9qytYSHe4dX12pb+NxO2HpoRvgHi8Fz2iCAtH2lWYhMBIMyPUchsyujNUHmH4SrHoad48dW62GGILbRM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM5PR10MB1353.namprd10.prod.outlook.com (2603:10b6:3:9::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.27; Thu, 5 May 2022 20:48:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 20:48:33 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] xfs: don't set warns on dquots
Thread-Topic: [PATCH v2 3/3] xfs: don't set warns on dquots
Thread-Index: AQHYYMF7GLGAtWFZ5kq6OQBzlEW6+w==
Date:   Thu, 5 May 2022 20:48:32 +0000
Message-ID: <2586AAF3-7E1F-4F7E-B70E-38587782A9C5@oracle.com>
References: <20220505011815.20075-1-catherine.hoang@oracle.com>
 <20220505011815.20075-4-catherine.hoang@oracle.com>
 <20220505161736.GI27195@magnolia>
In-Reply-To: <20220505161736.GI27195@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baf8bc83-3a4a-4a6a-43df-08da2ed89e4b
x-ms-traffictypediagnostic: DM5PR10MB1353:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1353747CA1D4E3455F3795B789C29@DM5PR10MB1353.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TdV2D0sCU6zRSbJIMPcn2cEMbMXzQAJh2XUH66zN3sH9DVK9nsoNsPZB0jMMnLQxzHAmPK/ys4yLp8oqIetXoAkZTcxCRODYzwCzirSn/ZpgIXtE1AKTtI3hb3cKIAzVq+u3R/lK2lh/UPsHE/EAt0EQxLKuNDi72MXoOZGjZoXUXt3yhULLfrMxBVxf+zTaSrUqDKiTo3lBTI/Ft+b7GCiR144imTlP1kaidLX8aEBKpRWlMeCMHFgKEaf5GwH8ETxk1WkAQDsLi5vHjhozcPBihZNaus0rqC2UOEpVOGdc/zS1xGWHgDFYj+LFbzL1H6hzQyohN9brspdgLnGyERdecc9CZ/duQE3V4LvXJkrkC2bWfmZ41DnB3NiAKf6oWZjV5O4Ftq0p5bkkjCHIC16xZ7xilxYYUNBKbD6enAMmYouzXZy/Fb0U5DQHNHjDuKraWi9219+8x78DonLb8qotL7R9Kx8JQq5x5tQ9xaxQBfAprend6p88JH5BH3HtLS5HmXah+viZZv86fXx936vTxyjpI/x4grpgwNaju8UVLJk/yRl2N0NgX73aFLzpGwcizDH7ny/zHL4C9IzauRfLpgMBwH5slsps6c6S8cAVJzgiEKT4kvfq3Mj/NRC+07j4N/yXofZUBsBPSEQ+qmTBakdT85UrAF26VTFLbamn4KtFZwkaqLIbZnHu7f1KIRehvbmAhzJ7CUP17IFwgiiKQqRYz8pKEVscrNuTuLk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(316002)(5660300002)(186003)(8936002)(2616005)(38100700002)(38070700005)(122000001)(6486002)(76116006)(6506007)(53546011)(91956017)(44832011)(64756008)(66476007)(36756003)(4326008)(8676002)(66946007)(66446008)(66556008)(508600001)(83380400001)(33656002)(71200400001)(86362001)(6916009)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGk1UWJjWng2cHdNMGoyV21Jelg0dVN6dEcvREpVVkZVaGcvN0x1eGNqdk5u?=
 =?utf-8?B?aDRMQStWbGM2bTJpOE01bTl2VWNmQXRJQ1dpVGtSV2duUFJPcUNXeHZpT2ht?=
 =?utf-8?B?b0t1a21IMkJvNGZkSDhablVId0F4OHV2ajV4SSt2MkhRbi91WjdvSHJqQzRC?=
 =?utf-8?B?NjdrcmsyR21iOEdQbWRoejBTWUZzaG4raEJycERWQ213bllPK1VMZXNFSjN0?=
 =?utf-8?B?QXhFZUVUQWlnWXVwd0hIQXFRclovOVpTR2ZRb2xrVmJ4MGs1VVEwRjJmS280?=
 =?utf-8?B?YlRqeUQ2SkxzVHE2U3Z0eWt4UVF3SWx0anNnMHJzYktKY0N0bDBZc2dOZlc5?=
 =?utf-8?B?cXAvYW10b2V6S1hxaG1OUTVSdTlveTB2M3lsMHFRSENzVG5VWWZrWGFxMVRm?=
 =?utf-8?B?ZjN0eCtIeGFkVFJQVlJmRThaVEhqOUlINi9GcFUvUlJUOVVGckg1T1Bvb0ts?=
 =?utf-8?B?YXQ5YzRqSjI2TVNRNFpId1gwUlFzT0ovTFVaMndxNG1ZZlE1QVZXd0h3WVAw?=
 =?utf-8?B?L2NOTWhidm1mZDVibUh0V3NLcWZ2ZTh4NVhiMU5Xc1JwdjVhbFNyUkJQdXo5?=
 =?utf-8?B?dSs4KzBiYjZrZjVYS0RQcmw3NFp2S1VWNFl6cy9qSzJYNjZuZlhERTNrRG9O?=
 =?utf-8?B?Nno4SnV3Q2VUS1E1ZWtaSEg4SWlSL2t3bUo4cW0yaTh2V3B3YlFZWnorRjky?=
 =?utf-8?B?SERaT2pnbmhJMjIxMWpPTzF1c3VGNE45NTd0bDhwL2Nndjl5YWtZU1NOaldj?=
 =?utf-8?B?b1pnZ1YxdnFjZHZ2NHpQeHFWQ3RGN2JCVHRORk9OQ3gvRm01TE8zODNFeTFt?=
 =?utf-8?B?VzFaUnZtSS9ESDZXb1ZCY2lvN0ZSYkF6MTV3MC82c1ZoMzBrb0pIOXhoTlRq?=
 =?utf-8?B?UzI3TDdhRmNkTG9EeEtmTWY0ZC9uNy96TmNxY290ZUhReExhVjdMaWRMUDdW?=
 =?utf-8?B?RVJnMmZtZ2t3TmNHVVJiNVdHZDkvSWxQKzVtWFFzMTNGUVFpVlJJV0l0QUxn?=
 =?utf-8?B?b0tWeHNSbWdsTDl2TStxYVQzemxDNDV5VFdYNWJScTh4THRPTkdIZUdHcDUv?=
 =?utf-8?B?WVRQVU8ramY3OWQwVGVmRWtvU1R3WHZTSG1QVVJBS0R0aDJWZGloTlFhdFRr?=
 =?utf-8?B?TFlyYmhZK1dKdUZsZGRDdk1uNGFTbnJWaEduaHI1NGRHODF0V3VpN3VhREN5?=
 =?utf-8?B?aDlWUDgyeXNvTEIwQjBHeEpDMVE4OE9RdkhpcnlIUmtDYll6N1k4YzVrVnVs?=
 =?utf-8?B?cmpJeGZqR0x0b0lxMzlyVFowNU1UM0VsdDA3NDdZVjJ3dEgvS0Y1dHFzakpx?=
 =?utf-8?B?UWd2UUNqS1BGOXlDeWgrbzFlaW9vUjVaZHlUa1FVekp1UmNETzdZVzBHRm1U?=
 =?utf-8?B?eWZMSU1rOXRFamE2Z0tUT3B6WUVlNktkYmNVaWdJaEx5RmoxMzdoTDcxbjBo?=
 =?utf-8?B?WUpQVDJFVlo3ZWpjN2NxVFZYQXdQSnp0YTFHTW4wQThtbU5DRVk4TmExdVZ5?=
 =?utf-8?B?SjcyVnppMjB2UkJyNEh6NjM5SS81NGZ5UUcrU00rbm1hZXdERndac1hCL0Jz?=
 =?utf-8?B?SHNVY1d5MlRGSjVrM01ld09qMlYvRmxZdnJ4WnNaRExjS2lYTExwMlRiV1BU?=
 =?utf-8?B?UnZoRDNJZWFDVHdiRnlOcHZ5Vnp1Y05HQU9UcDFWSzRJQTdGMEdSL2g1MjRN?=
 =?utf-8?B?TnM2cmlRdEc4V2plS2p6U1FNbDQ4MWxqUXFHeEVLdWwyamVtSk9ib3RUcldT?=
 =?utf-8?B?WUQ5Y25LcXNRNWlJV25nRUx0YmNoTkplUWlFZWRFTUpXZGhKb1BZVE9EdnBK?=
 =?utf-8?B?bkJOb2hrVm1ySHRTNllzOXBFWVZtS3VrMUlOY3hJMFRVSGltK3VEbmx1cjRw?=
 =?utf-8?B?eXpGWGx2V200Tm0wWGUxWVFwOVpTNE9DUEpvejJXUVhlUGEzOHhwTGJrR0Ir?=
 =?utf-8?B?Q0hjcnRQc1RHSXRPZUJEczhQR1lYdzdtc2ZwYUIzdHpNRnJ4K2VudDF6QklM?=
 =?utf-8?B?clZaWmRRTGpub1htSUNkTFNTVWJUdHVFMUhBUlJXczZSK0czNnMwSWFEZG44?=
 =?utf-8?B?MUdCZGJRenRnc1JlTHgxeElZRURMV1BKRjkzbFc0bzV5bitzWTcxSHRQbTVN?=
 =?utf-8?B?WTgrd1Q0Ti9heUhjWTR4WGVzQWJxNURnNFZudzBMbTFxMXErakFocWlObi91?=
 =?utf-8?B?bHR0Q1M0UFRyeFdSSGw2ZjdKT2VRZ1lXVlVWUjRpcTRCOTcvVVo5VEVWV0d0?=
 =?utf-8?B?TUdqMjA1NTgzWWlQN2N1cTJSVDdSYVJ6YXkxbTN2SlF1SXZJN2RSYm9CRGhY?=
 =?utf-8?B?akNJRFJWYlliV21aRCsrblp1V09mZWRic3NwQysrSVB4NU45YnRqWk1RQW1D?=
 =?utf-8?Q?tKC4t7ZfaPj6OAo5xxKVu/Iy+zFm56bhW9zova0aRCgPp?=
x-ms-exchange-antispam-messagedata-1: TkOiycdfn/d+Yg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5E9D28FBF89F242BAA54A032AEC3B64@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf8bc83-3a4a-4a6a-43df-08da2ed89e4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 20:48:32.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uP5Q+OQxMp1V29Hh0AZLom+nrhOVlPSZ6otKld4jons3pl1Cou4h32SOb7k75v+Z17P471F71/Qq6DiH09UsGABDaZaRW5njCsaD5YFqqNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1353
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_09:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050133
X-Proofpoint-GUID: Bo5KmIlSIcxvAcjQkLm328Oj5AXNkmBt
X-Proofpoint-ORIG-GUID: Bo5KmIlSIcxvAcjQkLm328Oj5AXNkmBt
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBNYXkgNSwgMjAyMiwgYXQgOToxNyBBTSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAwNCwgMjAyMiBhdCAwNjoxODoxNVBN
IC0wNzAwLCBDYXRoZXJpbmUgSG9hbmcgd3JvdGU6DQo+PiBIYXZpbmcganVzdCBkcm9wcGVkIHN1
cHBvcnQgZm9yIHF1b3RhIHdhcm5pbmcgbGltaXRzIGFuZCB3YXJuaW5nIGNvdW50ZXJzLA0KPj4g
dGhlIHdhcm5pbmcgZmllbGRzIG5vIGxvbmdlciBoYXZlIGFueSBtZWFuaW5nLiBSZXR1cm4gLUVJ
TlZBTCBpZiB0aGUNCj4+IGZpZWxkbWFzayBoYXMgYW55IG9mIHRoZSBRQ18qX1dBUk5TIHNldC4N
Cj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nIDxjYXRoZXJpbmUuaG9hbmdA
b3JhY2xlLmNvbT4NCj4+IFJldmlld2VkLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJu
ZWwub3JnPg0KPiANCj4gU2xpZ2h0IG5pdCBJIG5vdGljZWQgaW4gdGhpcyBwYXRjaDogSSB0aGlu
ayB5b3Ugc2hvdWxkIHJlbW92ZQ0KPiBRQ19XQVJOU19NQVNLIGZyb20gWEZTX1FDX1NFVElORk9f
TUFTSyBhbmQgWEZTX1FDX01BU0suICBUaGUgZmlyc3Qgd2lsbA0KPiBibG9jayB0aGUgc2V0dGlu
ZyBvZiB3YXJuaW5nIGNvdW50ZXJzIGZyb20gcXVvdGFjdGxfb3BzLnNldF9pbmZvLCBhbmQNCj4g
dGhlIHNlY29uZCBibG9ja3MgaXQgZnJvbSBxdW90YWN0bF9vcHMuc2V0X2RxYmxrLiAgV2l0aCBi
b3RoIHRob3NlDQo+ICNkZWZpbnMgdXBkYXRlZCwgSSB0aGluayB5b3UgZG9uJ3QgbmVlZCB0aGUg
Y2hhbmdlIGJlbG93Lg0KPiANCj4gLS1EDQoNCk9rLCB0aGF0IG1ha2VzIHNlbnNlIHRvIG1lLiBJ
4oCZbGwgYWRkIHRob3NlIGNoYW5nZXMsIHRoYW5rcyENCg0KQ2F0aGVyaW5lDQo+IA0KPj4gLS0t
DQo+PiBmcy94ZnMveGZzX3FtX3N5c2NhbGxzLmMgfCAyICsrDQo+PiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX3FtX3N5c2Nh
bGxzLmMgYi9mcy94ZnMveGZzX3FtX3N5c2NhbGxzLmMNCj4+IGluZGV4IDIxNDljMjAzYjFkMC4u
MTg4ZTFmZWQyZWJhIDEwMDY0NA0KPj4gLS0tIGEvZnMveGZzL3hmc19xbV9zeXNjYWxscy5jDQo+
PiArKysgYi9mcy94ZnMveGZzX3FtX3N5c2NhbGxzLmMNCj4+IEBAIC0yOTAsNiArMjkwLDggQEAg
eGZzX3FtX3NjYWxsX3NldHFsaW0oDQo+PiAJCXJldHVybiAtRUlOVkFMOw0KPj4gCWlmICgobmV3
bGltLT5kX2ZpZWxkbWFzayAmIFhGU19RQ19NQVNLKSA9PSAwKQ0KPj4gCQlyZXR1cm4gMDsNCj4+
ICsJaWYgKG5ld2xpbS0+ZF9maWVsZG1hc2sgJiBRQ19XQVJOU19NQVNLKQ0KPj4gKwkJcmV0dXJu
IC1FSU5WQUw7DQo+PiANCj4+IAkvKg0KPj4gCSAqIEdldCB0aGUgZHF1b3QgKGxvY2tlZCkgYmVm
b3JlIHdlIHN0YXJ0LCBhcyB3ZSBuZWVkIHRvIGRvIGENCj4+IC0tIA0KPj4gMi4yNy4wDQo+PiAN
Cg0K
