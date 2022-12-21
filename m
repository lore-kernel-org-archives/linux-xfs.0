Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF3BC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 07:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiLUHLw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 02:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiLUHLu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 02:11:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F696209B2
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 23:11:49 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BL0iuEQ015316;
        Wed, 21 Dec 2022 07:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8GAoWdf4/XRky28aHNWvCYM7v4oN3AA5eNSpxoGpANw=;
 b=wWToqez6T8O8+28PHOYo90d+1xDQEKuAWTLU1xnl6kq+WG0QuYLc7Z5NVdIsDzwaXzKz
 uR8jTbYTZA/sYKkdmc9FLGcMu1OGVWBWj82Xic+DRLA/im0jlPp7+4ML+AmKQyxm++nf
 3cNjHgvEwNRQrP0CENb2rI2/bn7ndG7fHCa+5iuuo2QGlLCWhH8d61X/3I/MH6y2YasW
 m8z2T8pe3104ZHZKbFnynWXjexV04MdB12NvKb600srUOS1HCsbuJ4vgQjXcslzMx9Fm
 MF98toF/0adC2Ah45sEV7JhgOL6c3qjYBcp8rJIPNNu4y2GBNvL1oBUVgdG+NHL8e1Ga LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tr090v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 07:11:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BL4fZlI027656;
        Wed, 21 Dec 2022 07:11:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4766r1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 07:11:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIW9i9KsxeKjS4Q8EZCsgPDN439zcMFNIb4D2FA65CmYzhfkAgf/Sr7YeXm7gygro9Bmeu+7M1IfXP/1QezlIXPz9/u9w414j5/Vs2/KwagjucSJulGXKHSLn8lrZ3d+fFCvX5N45+LDkM+qZGiHsDU9dH3mj6r/EtiZXOvT+Ne4+L9i/1yiMguQu8D6JOulaBwppRG+/oUf+U03KzXzT9y9hcIg717Bt7vw0uPCz2FPlxxQlX/1wZByhe5cdjjLrvuu8IIZw6y/PWQ1QPNntx88tRLB5nY5g6Y74JmqtHrOp/0fSiwCsKy2bHBo9JpzVqCYvhJQPuCAKjINj2e1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GAoWdf4/XRky28aHNWvCYM7v4oN3AA5eNSpxoGpANw=;
 b=RhmMXYcp2xCFoN3asfdsb4kXFWXO46dCwC4bw39N2U412JlxhdOg9RZCpJ1k3gLZwOLZwDNx4GwGNONBvNPrfsDu5IwConXSYCHW+z6M8Yh5X8z3mivh6sstDQl90WpIL1PU689iPx7nrRSFcNRtwjwkCt/xVzkW9d2B9Sp7aB5sAi/2+66b1wzy3iuJG9yqqg7QYPJpuLIlTlg2cbwFK5GtsYDSqar81Ss32tqY/OH1614oZJvc9MeR/m/EEJkKZRpwcc8n2iB65S0fVyOBLtZRXxZsJyXaEVD1lCEI7ut5tJLyyt2jWP5j9QOODs6K2GdyJJimkY+ecshfu3yM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GAoWdf4/XRky28aHNWvCYM7v4oN3AA5eNSpxoGpANw=;
 b=OTi9zu95ddUHhF+tTAQYQTfYNFVdMO1DieUqBJsOinA3ciQOOM7sesDkjlohmoLGIqiuR1wTfhLOBhvcV8Y/mNG4+i3aKSTPbWmeXTa1CoJpzHknCjYb0xX7nTxrpyhsguVmiLGc7Rhose1iNwtrfJCTU0YTwooVR2Wo2wx4kKE=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 07:11:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%7]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 07:11:42 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] xfs_io: add fsuuid command
Thread-Topic: [PATCH v2 1/2] xfs_io: add fsuuid command
Thread-Index: AQHZFQt6HKsSLGp0ykCpNG7jkMjSwA==
Date:   Wed, 21 Dec 2022 07:11:42 +0000
Message-ID: <7F927E70-E9EA-4527-BDEC-EE00A2BC6A54@oracle.com>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
 <20221219181824.25157-2-catherine.hoang@oracle.com>
 <Y6IvPpDfS/fmNQTJ@magnolia>
In-Reply-To: <Y6IvPpDfS/fmNQTJ@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|SJ0PR10MB5741:EE_
x-ms-office365-filtering-correlation-id: 501e4961-3af1-444a-a02c-08dae3229d07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 36UHFzWSGjVnD5yGfd8gqE2nlNuBLBoGkA/rPDYqAJE5D7W59nQJGWkUKIwAeDiMgPWiJ0yNXuTIjgc/vpTaLgPdBZw06axO1QBRfZNfXCdbLre1s5n/eRuvbafmhHVLuLXlBb8AiWxSwdX0B3pqLQeXWa6wl+FfqeZKaDm6QQWdzCgDHP+bfcEq0myIbFcS5m6vbOyC96FsM8RiDtlzFfCFfW72k6Huqkm7cqglXUoG2nGEKexyQ698U7HcSdggpadKKOutr592MEpTm/n4Doa+o77SGAitGB34YCWVXin+AH9w8BGVW+Zh2GLSbnu35m6iQF8jCQeRoac0mjrjJblcyvF7uz3ZNOvpGO7DLEqiq15zS8wQWj4LcbriTUCe+eqSzlvMNTpAtxtnwmRRvp0SoWgHPBYpiSjGzVqfAgjYNQRvpNmz2imifgUrb7C6haMGdG4Qb8v2bbTug8nAuPpglpHNTc82Bvk/OEhA0ROye6eoq79aU7vv8vVJ53obp/4+Iqmv00vJQ/qYfDgLmny+NBrtV1kM9lQv5jT88BNq5xwsFHqh3eYUTiA651MrUuRHjMcvhqh7Lw3lolQkI6qQqENYoQXc/WnqfKwSvKGo/GGvgDhVETqHhFe2jwx+ZQpGSZqT0BdentOby73blU8JCpRG4YaTRug14qvvMMKH3MPDE9SRCrXevL8MTfChNUwytAGvwpxYzOAu2WFZhG2M5ivtva+ODnlHVcnuE9lUvyBdVvCjCIWqaUx/5sx2OeYi4tonJe9+bwYedSnXfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199015)(38100700002)(41300700001)(122000001)(66556008)(66476007)(5660300002)(76116006)(66946007)(66446008)(64756008)(91956017)(8676002)(4326008)(8936002)(83380400001)(478600001)(53546011)(6486002)(36756003)(2906002)(44832011)(6916009)(38070700005)(186003)(316002)(71200400001)(6512007)(86362001)(33656002)(6506007)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkFjb3BwOXRTVmRXem1yNnJURXU1OExhcEZZdWNRU3ZOTmYyUFdieGhhTHp2?=
 =?utf-8?B?eTUwYmZqUFp6OFZEdnpWRktHSFlocWJQL1ZHK2lCTUtuekMzazhKdHNSSzIy?=
 =?utf-8?B?WXNPY0E1ZjRwY3EvczdsTllpL0FEMzZrZkIyK0JqQlhmOEppVURrYTZzMC9h?=
 =?utf-8?B?N3ZYdDBZRnhMWWxNRWR1ZDdNa0pIZ3BqOTlDbzZqTGtWZlg1WFN1WmF3alhL?=
 =?utf-8?B?emNWYWlGOWRrTWZZQTJENnNZdS9vSnRlbDRpZHpuTTZtK2NrWjA5KzMwYytr?=
 =?utf-8?B?Qm8vc0haTzN5SkFDVDFuSHlhbnZ6Z0lQdk00VXFnUDhicmtiR1NjN3pPbEdJ?=
 =?utf-8?B?RFgxdnBCMTlYU2k5ME9ZeElhZVlyNFovZ0orZi9TUEJScUlFVXFKVEk5WDM5?=
 =?utf-8?B?WUl4YytBZ0dJRHE2UHlabWgzNXBtVnRYeXM2dUpKYkQvcURoc044cFhEYnh5?=
 =?utf-8?B?T0x4S2RxVjB4ZkxjL3hzU0hnSk5Sa3RYZGZaUjBVeVY1WDZ5cGV6bG4yUTRv?=
 =?utf-8?B?NmExbkR3Ym85MFpwa3Z1QUtoWU1lTFNoVWM3MWRYdkFTaUEyeXNjSEtNL0Y3?=
 =?utf-8?B?UUxIbkJWUlJwU0VwcklZUUVQaGdyTjJFbjhBK3N2bG5yTndnTm41WmgvVGVi?=
 =?utf-8?B?eTRORHhqYlF0UmlsNHJIa0FrL1FGcER1L3ZZY3A2RUtLN2JEVGplVllQV2c3?=
 =?utf-8?B?am5wS2RGSWVwYURKQzYzUXEvc1FkUHZIMjdpY3h1blhUekFQWGxTM3lNNGxm?=
 =?utf-8?B?Y3FxZEYrZlNjeDRteFpGaUx1QjllWUppRU1Dby9LcENzTmZPME1vS1o2UVdD?=
 =?utf-8?B?NjEyUnVTK3pwYkcrZ0pUb3VPYko2SVdHRTZDUjFoendVc283ZHJBWjV5TnJ4?=
 =?utf-8?B?Sk41YzQ5NzRvazlOR2FYQmNiUmM0ZWwzS0JoT2dHQk00c0E3RUgrOGU4SkRv?=
 =?utf-8?B?Q0t5bXM1U2c5L0NZU1JsdW84RjlXK240Q2dtd3Y2am9Cc1BGZWFtZW8rWlZJ?=
 =?utf-8?B?MWI0WWVCVkVub0x3eGNPSjRTRjZzV0NqK0o2bHVJOEdqdWx6d0dOekZQN2VH?=
 =?utf-8?B?UGFWaGxoV3ZrQ0RGR2tobDBZQkpMTW1pNE5oSWZnNGQyYldkY2Z1MTN4ODFi?=
 =?utf-8?B?ZUtNaUY1RDRta0tSOFZEZ20zUk5PWktFNXo3SEN6NmUxdTlSWmhQR3QvWXIw?=
 =?utf-8?B?czBjZFgvZHlNWmNValg2Q3dza25IN2JVSUVFTXovZ09QZ2VkbklFZ1h6cjdo?=
 =?utf-8?B?citjd0F4R3lkOTNuNEV2TytBbkNRMG5Xd1BqNEtqaFRSMEYvaEpWWmVzWXBq?=
 =?utf-8?B?dTIwT0hUeHFHcWgrcHNYeU1iS2h6bCs5UVFZTWIxVXd3YmlsTU1rRWxsS1pZ?=
 =?utf-8?B?S0gzc0l1cHNEZTBvcFZXOXB0L0tCOC9oWGZQV1ViZ05Nd2pOQmhyK3d5RkRm?=
 =?utf-8?B?ZFhQQWo1MEdaVXFSaTVFeDh6MVpPVUgwZmVwaFlLZUJUTGpTVE5WYUpwRUxU?=
 =?utf-8?B?M1prSlgrdTJkYUtmZ0dlcG4wZHlwZGZ6TFZ0OE9URGIzYmV5TnJsUk9JeC9q?=
 =?utf-8?B?U2JNUSt2eGhXczdGanA5RHVDNnhEVnZHeGhuNlZYN1FTeDd0SWhQQkNGaXZZ?=
 =?utf-8?B?anFtd3BqR1hidCtOVlgzSWRxTHRXNEpESlh2QTl1ZHhacU1DYXpCeUVCcDJZ?=
 =?utf-8?B?MnNkNHM0OG84bCtER0ZncHFpN2FYaVdMNTVXODZDY2tKcWI4OTEwNnlXc3Jx?=
 =?utf-8?B?QTB5L3haOU4wOXFteThaT01VUGRucXpMQzZicnhWK3hNQ3RsTXBMb0FoSHBD?=
 =?utf-8?B?YzBZYXFGN2loVGxmd3pmelVlZTcwYXhzSUROaW1McU5NZTNkWng4N0o4eDdv?=
 =?utf-8?B?YUZpNHlUWlB3a0hxNFluVm9tSjR4dncyVHZMWCttMjVEQ0p3ZW4rWXJuR21t?=
 =?utf-8?B?L0ZJRFJ4YUQ5L2dSNDNEZzdQQkN4YzZMTGlpaGdRVi9NV244K1ZleW9QaDRo?=
 =?utf-8?B?aXM1c3F5VWpOK1pmcmlHN1djdGFiV1EyU1RCVFRQNWluZjl3R2owRkozZ2g2?=
 =?utf-8?B?RmE4K0E4TERWOG8vV2RSSy9laGZqem8wUHUzQzJ5TFVSZmtYL2xmUnZ1c05J?=
 =?utf-8?B?MHBxQjNCSVEyL0UzaG9LYXA5cGpFbDZUZmpxYmdBUHlsVytyaVc3TUV5MmxP?=
 =?utf-8?B?K0Y4c0pheVdvMmFLeUw1QXRsQnl0MjZwaVlvem1uZWZ3V2ZQa05NaXJ5djBE?=
 =?utf-8?B?MEx1TWxaNzdhcS9uSFZ2U0lsRUtnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86BA5BB52FADFC41987ACA55ED7AC262@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 501e4961-3af1-444a-a02c-08dae3229d07
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 07:11:42.9262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1hIN9iQoThKNsvfYwcv2QsT+tS3iRzT0ieiVs3kx7u9Qbbvwu6tYdh6v5Q76SQvD6eRcCIOhZB3niKBrLqmZGgYiJ+QDRjzMqVnzCm+G+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5741
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_03,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210054
X-Proofpoint-GUID: -o9HfI_8NILtzctKvSCQu7LaMPYYQWVX
X-Proofpoint-ORIG-GUID: -o9HfI_8NILtzctKvSCQu7LaMPYYQWVX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

PiBPbiBEZWMgMjAsIDIwMjIsIGF0IDE6NTUgUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtl
cm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCBEZWMgMTksIDIwMjIgYXQgMTA6MTg6MjNB
TSAtMDgwMCwgQ2F0aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4gQWRkIHN1cHBvcnQgZm9yIHRoZSBm
c3V1aWQgY29tbWFuZCB0byByZXRyaWV2ZSB0aGUgVVVJRCBvZiBhIG1vdW50ZWQNCj4+IGZpbGVz
eXN0ZW0uDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0aGVyaW5l
LmhvYW5nQG9yYWNsZS5jb20+DQo+PiBSZXZpZXdlZC1ieTogQWxsaXNvbiBIZW5kZXJzb24gPGFs
bGlzb24uaGVuZGVyc29uQG9yYWNsZS5jb20+DQo+PiAtLS0NCj4+IGlvL01ha2VmaWxlICAgICAg
IHwgIDYgKysrLS0tDQo+PiBpby9mc3V1aWQuYyAgICAgICB8IDQ5ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+PiBpby9pbml0LmMgICAgICAgICB8ICAx
ICsNCj4+IGlvL2lvLmggICAgICAgICAgIHwgIDEgKw0KPj4gbWFuL21hbjgveGZzX2lvLjggfCAg
MyArKysNCj4+IDUgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4+IGNyZWF0ZSBtb2RlIDEwMDY0NCBpby9mc3V1aWQuYw0KPj4gDQo+PiBkaWZmIC0tZ2l0
IGEvaW8vTWFrZWZpbGUgYi9pby9NYWtlZmlsZQ0KPj4gaW5kZXggNDk4MTc0Y2YuLjUzZmVmMDll
IDEwMDY0NA0KPj4gLS0tIGEvaW8vTWFrZWZpbGUNCj4+ICsrKyBiL2lvL01ha2VmaWxlDQo+PiBA
QCAtMTAsMTIgKzEwLDEyIEBAIExTUkNGSUxFUyA9IHhmc19ibWFwLnNoIHhmc19mcmVlemUuc2gg
eGZzX21rZmlsZS5zaA0KPj4gSEZJTEVTID0gaW5pdC5oIGlvLmgNCj4+IENGSUxFUyA9IGluaXQu
YyBcDQo+PiAJYXR0ci5jIGJtYXAuYyBidWxrc3RhdC5jIGNyYzMyY3NlbGZ0ZXN0LmMgY293ZXh0
c2l6ZS5jIGVuY3J5cHQuYyBcDQo+PiAtCWZpbGUuYyBmcmVlemUuYyBmc3luYy5jIGdldHJ1c2Fn
ZS5jIGltYXAuYyBpbmplY3QuYyBsYWJlbC5jIGxpbmsuYyBcDQo+PiAtCW1tYXAuYyBvcGVuLmMg
cGFyZW50LmMgcHJlYWQuYyBwcmVhbGxvYy5jIHB3cml0ZS5jIHJlZmxpbmsuYyBcDQo+PiArCWZp
bGUuYyBmcmVlemUuYyBmc3V1aWQuYyBmc3luYy5jIGdldHJ1c2FnZS5jIGltYXAuYyBpbmplY3Qu
YyBsYWJlbC5jIFwNCj4+ICsJbGluay5jIG1tYXAuYyBvcGVuLmMgcGFyZW50LmMgcHJlYWQuYyBw
cmVhbGxvYy5jIHB3cml0ZS5jIHJlZmxpbmsuYyBcDQo+PiAJcmVzYmxrcy5jIHNjcnViLmMgc2Vl
ay5jIHNodXRkb3duLmMgc3RhdC5jIHN3YXBleHQuYyBzeW5jLmMgXA0KPj4gCXRydW5jYXRlLmMg
dXRpbWVzLmMNCj4+IA0KPj4gLUxMRExJQlMgPSAkKExJQlhDTUQpICQoTElCSEFORExFKSAkKExJ
QkZST0cpICQoTElCUFRIUkVBRCkNCj4+ICtMTERMSUJTID0gJChMSUJYQ01EKSAkKExJQkhBTkRM
RSkgJChMSUJGUk9HKSAkKExJQlBUSFJFQUQpICQoTElCVVVJRCkNCj4+IExUREVQRU5ERU5DSUVT
ID0gJChMSUJYQ01EKSAkKExJQkhBTkRMRSkgJChMSUJGUk9HKQ0KPj4gTExERkxBR1MgPSAtc3Rh
dGljLWxpYnRvb2wtbGlicw0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvaW8vZnN1dWlkLmMgYi9pby9m
c3V1aWQuYw0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwLi43ZTE0
YTk1ZA0KPj4gLS0tIC9kZXYvbnVsbA0KPj4gKysrIGIvaW8vZnN1dWlkLmMNCj4+IEBAIC0wLDAg
KzEsNDkgQEANCj4+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPj4gKy8q
DQo+PiArICogQ29weXJpZ2h0IChjKSAyMDIyIE9yYWNsZS4NCj4+ICsgKiBBbGwgUmlnaHRzIFJl
c2VydmVkLg0KPj4gKyAqLw0KPj4gKw0KPj4gKyNpbmNsdWRlICJsaWJ4ZnMuaCINCj4+ICsjaW5j
bHVkZSAiY29tbWFuZC5oIg0KPj4gKyNpbmNsdWRlICJpbml0LmgiDQo+PiArI2luY2x1ZGUgImlv
LmgiDQo+PiArI2luY2x1ZGUgImxpYmZyb2cvZnNnZW9tLmgiDQo+PiArI2luY2x1ZGUgImxpYmZy
b2cvbG9nZ2luZy5oIg0KPj4gKw0KPj4gK3N0YXRpYyBjbWRpbmZvX3QgZnN1dWlkX2NtZDsNCj4+
ICsNCj4+ICtzdGF0aWMgaW50DQo+PiArZnN1dWlkX2YoDQo+PiArCWludAkJCWFyZ2MsDQo+PiAr
CWNoYXIJCQkqKmFyZ3YpDQo+PiArew0KPj4gKwlzdHJ1Y3QgeGZzX2Zzb3BfZ2VvbQlmc2dlbzsN
Cj4+ICsJaW50CQkJcmV0Ow0KPj4gKwljaGFyCQkJYnBbNDBdOw0KPj4gKw0KPj4gKwlyZXQgPSAt
eGZyb2dfZ2VvbWV0cnkoZmlsZS0+ZmQsICZmc2dlbyk7DQo+PiArDQo+PiArCWlmIChyZXQpIHsN
Cj4+ICsJCXhmcm9nX3BlcnJvcihyZXQsICJYRlNfSU9DX0ZTR0VPTUVUUlkiKTsNCj4+ICsJCWV4
aXRjb2RlID0gMTsNCj4+ICsJfSBlbHNlIHsNCj4+ICsJCXBsYXRmb3JtX3V1aWRfdW5wYXJzZSgo
dXVpZF90ICopZnNnZW8udXVpZCwgYnApOw0KPj4gKwkJcHJpbnRmKCJVVUlEID0gJXNcbiIsIGJw
KTsNCj4gDQo+IExvd2VyY2FzZSAidXVpZCIgdG8gbWF0Y2ggdGhlIHhmc19kYiB1dWlkIGNvbW1h
bmQuDQoNCkkgbm90aWNlZCB4ZnNfZGIgYWxzbyBwcmludHMg4oCcdXVpZCIgaW4gdXBwZXJjYXNl
LCBzbyBJIGRpZG7igJl0IGNoYW5nZSBpdA0KPiANCj4gV2l0aCB0aGF0IGZpeGVkLA0KPiBSZXZp
ZXdlZC1ieTogRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4NCg0KVGhhbmtzIGZv
ciByZXZpZXdpbmchDQo+IA0KPiAtLUQNCj4gDQo+PiArCX0NCj4+ICsNCj4+ICsJcmV0dXJuIDA7
DQo+PiArfQ0KPj4gKw0KPj4gK3ZvaWQNCj4+ICtmc3V1aWRfaW5pdCh2b2lkKQ0KPj4gK3sNCj4+
ICsJZnN1dWlkX2NtZC5uYW1lID0gImZzdXVpZCI7DQo+PiArCWZzdXVpZF9jbWQuY2Z1bmMgPSBm
c3V1aWRfZjsNCj4+ICsJZnN1dWlkX2NtZC5hcmdtaW4gPSAwOw0KPj4gKwlmc3V1aWRfY21kLmFy
Z21heCA9IDA7DQo+PiArCWZzdXVpZF9jbWQuZmxhZ3MgPSBDTURfRkxBR19PTkVTSE9UIHwgQ01E
X05PTUFQX09LOw0KPj4gKwlmc3V1aWRfY21kLm9uZWxpbmUgPSBfKCJnZXQgbW91bnRlZCBmaWxl
c3lzdGVtIFVVSUQiKTsNCj4+ICsNCj4+ICsJYWRkX2NvbW1hbmQoJmZzdXVpZF9jbWQpOw0KPj4g
K30NCj4+IGRpZmYgLS1naXQgYS9pby9pbml0LmMgYi9pby9pbml0LmMNCj4+IGluZGV4IDAzM2Vk
NjdkLi4xMDRjZDJjMSAxMDA2NDQNCj4+IC0tLSBhL2lvL2luaXQuYw0KPj4gKysrIGIvaW8vaW5p
dC5jDQo+PiBAQCAtNTYsNiArNTYsNyBAQCBpbml0X2NvbW1hbmRzKHZvaWQpDQo+PiAJZmxpbmtf
aW5pdCgpOw0KPj4gCWZyZWV6ZV9pbml0KCk7DQo+PiAJZnNtYXBfaW5pdCgpOw0KPj4gKwlmc3V1
aWRfaW5pdCgpOw0KPj4gCWZzeW5jX2luaXQoKTsNCj4+IAlnZXRydXNhZ2VfaW5pdCgpOw0KPj4g
CWhlbHBfaW5pdCgpOw0KPj4gZGlmZiAtLWdpdCBhL2lvL2lvLmggYi9pby9pby5oDQo+PiBpbmRl
eCA2NGI3YTY2My4uZmU0NzRmYWYgMTAwNjQ0DQo+PiAtLS0gYS9pby9pby5oDQo+PiArKysgYi9p
by9pby5oDQo+PiBAQCAtOTQsNiArOTQsNyBAQCBleHRlcm4gdm9pZAkJZW5jcnlwdF9pbml0KHZv
aWQpOw0KPj4gZXh0ZXJuIHZvaWQJCWZpbGVfaW5pdCh2b2lkKTsNCj4+IGV4dGVybiB2b2lkCQlm
bGlua19pbml0KHZvaWQpOw0KPj4gZXh0ZXJuIHZvaWQJCWZyZWV6ZV9pbml0KHZvaWQpOw0KPj4g
K2V4dGVybiB2b2lkCQlmc3V1aWRfaW5pdCh2b2lkKTsNCj4+IGV4dGVybiB2b2lkCQlmc3luY19p
bml0KHZvaWQpOw0KPj4gZXh0ZXJuIHZvaWQJCWdldHJ1c2FnZV9pbml0KHZvaWQpOw0KPj4gZXh0
ZXJuIHZvaWQJCWhlbHBfaW5pdCh2b2lkKTsNCj4+IGRpZmYgLS1naXQgYS9tYW4vbWFuOC94ZnNf
aW8uOCBiL21hbi9tYW44L3hmc19pby44DQo+PiBpbmRleCAyMjNiNTE1Mi4uZWY3MDg3YjMgMTAw
NjQ0DQo+PiAtLS0gYS9tYW4vbWFuOC94ZnNfaW8uOA0KPj4gKysrIGIvbWFuL21hbjgveGZzX2lv
LjgNCj4+IEBAIC0xNDU1LDYgKzE0NTUsOSBAQCBUaGlzIG9wdGlvbiBpcyBub3QgY29tcGF0aWJs
ZSB3aXRoIHRoZQ0KPj4gZmxhZy4NCj4+IC5SRQ0KPj4gLlBEDQo+PiArLlRQDQo+PiArLkIgZnN1
dWlkDQo+PiArUHJpbnQgdGhlIG1vdW50ZWQgZmlsZXN5c3RlbSBVVUlELg0KPj4gDQo+PiANCj4+
IC5TSCBPVEhFUiBDT01NQU5EUw0KPj4gLS0gDQo+PiAyLjI1LjENCj4+IA0KDQo=
