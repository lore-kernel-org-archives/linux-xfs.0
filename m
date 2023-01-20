Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72A9C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Jan 2023 23:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjATXfV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Jan 2023 18:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjATXfU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2023 18:35:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2508089B
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2023 15:35:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KJwrVL019719;
        Fri, 20 Jan 2023 23:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CVMmMMwwBLio4921hIbwUOgz789mwMMJBdo7+1fYGak=;
 b=OmY3979nRvbaWxIlr9hXZn+tjJrnLotBCIUJ+pDXOrrZuIcfIgy837LbfNmtJEsEA7t3
 gwtehnMbNef1+++YenTnHd4s+ZohRfVW0pV7l6UqpjpABNExUB4vVjgk+UPt1nB7Cuxh
 dlTRjvpxc66x2JrXojKA6+YKt98mN0ve8XysX5TGKAR7HAxWB5BejQPrvyfStQ/f/Zxn
 MOitVfsfaagC65/ZQDUCPXRO1LdGm1tI7JsoIrM78aSMSfqLaoUnuUohjZnUFDy2N4vw
 qGAsBIoY9fzvmI1bdgzQbQFsrV6EefGxgqEvpL5HskNkU8OlJgHlhjPSP/oG/dy12lBe Mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3m0twvt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 23:35:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30KLgkl6018674;
        Fri, 20 Jan 2023 23:35:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6qujrffw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 23:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOY3Kfp0YVxv4ZjG6IzBhOLkrvltOy1MMOhwQ8IMJwrYNb36IxMcgU2ZCQFS9VvHS7o1qZRAsr18yWwwXVIChMny9NkBRZvi3HNBn8r5gEdhHOSp6LMlPBoCicEK5mCnEwrmFaO9+b+72+Uc5N966DlfBk/RRvPpEZ/KIiSyuno9PBtWkbRIxXdx/vB3bZvlg+Y9UdekOdVTXrGycjmDhHkdnRKnnLBMQaBCOTTwJ2cj/XoieoDi5V5ELQOf/UDObu7KzRVlYWpNxW7KsWa6OLvp7hdjX94+nDGTyKUZ0ybGhdFpSVsjjPBiTlLP+HUO1z5tcSGhxfZ2gxZA+Ye/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVMmMMwwBLio4921hIbwUOgz789mwMMJBdo7+1fYGak=;
 b=OwOe+z0DVFW7jM+8wHr5TGqPaS/ckTI8gjHpn8KPat5ytAEaMkLt8mKZMZdBwW8VCcq3rW+A+VysPPJ37EzK3rk1S8UZXC2hp9pQUpOkTaPs+RwsBwyGB5Cx78zlTzwSR9GjV3eULSo9bvwlDOPeUbzMH0kLQxJ2iwEE5q2yAUI6HKjPGLxxSEdcSqk5ZwT4KXMD+il5RoJVEn68eeK2QMqVi37zaY9nbfS0Y2/yXcAbtgXYFMMvM+Ebh+QAwrq/M01SLYRGyVmMd5+Kbz18XcRlimAfmThOC+xhzCfki16DJXyGQHe9QuFEhk7iKz5TBOU8j1Uj2cGMktJnwMVong==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVMmMMwwBLio4921hIbwUOgz789mwMMJBdo7+1fYGak=;
 b=Bf8cAkoX8/m+Xm27YZB6O6bTJphjq1Ue4om0eRbt05EDWwiR9zmW0LP37cWqJeWmSONU+it0YyoXDcYuFLEPkt3cSk7WFDYc1S5IPocFnOpi6lyJNlHq+BLQ28ubsxw9Wz3ge7jyIua6AriQ4ovCQXqrhVRzFEvpJFuf8ICJCOM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5892.namprd10.prod.outlook.com (2603:10b6:a03:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Fri, 20 Jan
 2023 23:35:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%5]) with mapi id 15.20.6043.007; Fri, 20 Jan 2023
 23:35:13 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "cem@kernel.org" <cem@kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Thread-Topic: [ANNOUNCE] xfsprogs: for-next updated to d8eab7600
Thread-Index: AQHZLOZDfflRa/jmc0W7PSbfidaCua6n9eEA
Date:   Fri, 20 Jan 2023 23:35:12 +0000
Message-ID: <323afbd0338c40d691d79138c1ab93d00074f27c.camel@oracle.com>
References: <20230120154512.7przrtsqqyavxuw7@andromeda>
In-Reply-To: <20230120154512.7przrtsqqyavxuw7@andromeda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4306:EE_|SJ0PR10MB5892:EE_
x-ms-office365-filtering-correlation-id: f592aa88-04ce-48b2-2459-08dafb3efa3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cx0OEPgbypogsJzbqm3JZ5sQgA825qNcJ+UeyNYvwf92yh7FVrI6qge6PjJNTHtNfxP3nP1M0gm5CLHolGnx5/TLmL2mf1nHk6IwNtv+a1BxL0nJje8l1uQhraBw1SlEWDFCHASxxu0VtT9GUgG6zTAe8UrXJS8JGRm/BkBm8TUI+qV+i76rHcD2CIPMWzmf2on2GJvL7MjVshzEiMpEZ/uBv59JAoMZuMQPUlNJISafKtGWUugK6Uo2d6DDBFj+uybJUGcD9uxna6C6W0TyI/bz5DAazer5HyQVGIxPZi4pECO68YIXWntAhRURrm1TvsMy9+chnuqaQ+dLnyYEWQ4+DMxFUOoJw+ua45dnvQnas3sReAoSyaCySMVtaUsvLPrweQedos69IhLMIiE13bWindh9sT4z6LZ3V7xwXA+hHL+x2JjiBd54qkEJz01U7rZiacc7wXHGP2pmL03P+wWOAU62DBSS9YfRa4FR8Wxz7hPPGjl1dZcg6qga8Xzr29NHkwh5+rfN9aXcqeAVcD1csZWN2RTNwRbhUqFAW4ghzvLwfau/FxcCXflCvpVzxBDhwyX/On8F3439Yi15yfsF4j0QgLEG1wx8n2vzsmC3iLHkz7ucP9LngfpRerY6oHp3FA5Yw2FPdRGEdSJNq3fwTXNgBDnORgAbX/K+nXfdLC3fWGD5CJ1hD+C6X14GaHN+rCNKSGfyZ5D4ycWP7pX+WgPX/UkdtxlKPK/zvmU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199015)(41300700001)(64756008)(66446008)(66476007)(66946007)(76116006)(66556008)(8676002)(110136005)(316002)(71200400001)(8936002)(966005)(6486002)(478600001)(6506007)(2616005)(5660300002)(83380400001)(26005)(38100700002)(6512007)(186003)(36756003)(122000001)(38070700005)(15650500001)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1poQzFGenQrQXMvT3pSVCtNYjJWa251aUdzOTBIZjlVYnlyV3RnZ0VHL1NC?=
 =?utf-8?B?RVJOcUdzQ01wd3Vxdm1icWxUZlhxUE5KditYRlpReFNHZDR5UHFYamFoZlFa?=
 =?utf-8?B?SVpSeEJLMGZ6S004bElYZDQ4V0NXaTJ1aG90QnJNb0FaQnJ1UEJsSDdFR1lV?=
 =?utf-8?B?QjJmM0dDenN2UngzZTRmOGEwVnhBNnhIREJTSnlOZ2tPcWdTSnhQazh3VVU0?=
 =?utf-8?B?c0ZuTUJvdlh1akg1ZGpkWTBUbGhUOUloTEk1NmpuRGVpMGdQMktJOGpCbUh0?=
 =?utf-8?B?WHNMTThkdDlMMEdvSy9KYjhJYW03UVE2allweEhKdWRUeUM1aHNkcHRweFJq?=
 =?utf-8?B?aXprWmtFajUwbEQxMUlxbHJkUC84ekxqWjhPM0JuaTkvbHRnNUU3VWRENTVI?=
 =?utf-8?B?ZTFocXZiUWw3L2Z5TTV2YkRhZ2NEMmovMDB4TmVuakhXRFBHcTZwRDBxdEMv?=
 =?utf-8?B?c29CK3ovSTlCSHlCdC84TEloSTFGLzJmdmxqWkJwMkdIenZzUGVEZDFYNVNU?=
 =?utf-8?B?ZUFkanY0OHRsbGUwZjY0NnZxUVA2elJhTk1vWlUyS1BDelFsN290cjdhM1Jz?=
 =?utf-8?B?YlNmTENVaktlS2tkcmNKL3JwZFA4ZDlFaXhQVU15anR4TEI2VWNSWlRFYSt1?=
 =?utf-8?B?VW91UGRiRzIwL1RmRU11ZTNBUnVwcC96cGltQm1qRjBpd2poeUZwemdFQkhZ?=
 =?utf-8?B?eGJqL09QNEEwV01SbnBUZ1dVOHRnbnEzcE1POHVhWG9MWkJIMDNuTDYvcVhO?=
 =?utf-8?B?UlhlNkYwTGkvSXVaZml5T1FpYlNra2toeGRIMmxxMEtMc1F0dHhYQWJsSnE2?=
 =?utf-8?B?Z2hWYklEZ3NKTkltVklvTFdiUVFkZDFIekpJM3pDY0tJWXJUSElBNHpjeE55?=
 =?utf-8?B?aFdGRmF6MkYzbG9HWmJOZEUyMnljRWRyYWplNXN4VGUwbGQ2YzJnMDRqaFVB?=
 =?utf-8?B?ZDNoZ3c3bFhWT3lmQ3ArQ3duUXhzZ2Y4WjRSYVdtUG05ZXEwQ3R5WUhENWRD?=
 =?utf-8?B?RjYvdmtkREpQZjBqTnNwS25ra295RjhQU21zWWpmSERkeEt2OXQ0Q29QUWF6?=
 =?utf-8?B?UnJZRllRME1vc3RjV1JFZWxpTmVVVHNCaThHSnNtYXVuMW1PMlRrZFZoRGhm?=
 =?utf-8?B?ZEVFZS9xOHBzZXZQMUFBSTRJeGtmSGVVVytuTnhBV1g4UzlMNGdSWE1UQlJq?=
 =?utf-8?B?cHBxRVJXNHR3dXg3b3JneXJhWGprV1dJZEE1VXUrdi9EbXVGQ1JVNXRiN1Bn?=
 =?utf-8?B?dmd1RHUrM0FsSk1yWDFnRk9aN21mQ0RxQ0dmeitTNVhxUWhvam1tNE1PZXpi?=
 =?utf-8?B?M2lUd0lxRUFLTFBIZkY1aDUvU1RxNXJYVkNaclljOTVRdUQwTFBWQmtkbXdG?=
 =?utf-8?B?K2pRcHRtZjRsVXY0T1Vra1BGcnp3aitqUDg4NzM3MHp4Y3NoQmJBL3BKZkNG?=
 =?utf-8?B?Q2NKaDRMajBOenduQVlQandLc2xnYXVQUGNmT2paTWc4QW1UYVJ3c01GUERo?=
 =?utf-8?B?R0dRaWY2a2lFUVJnc0lGYkp0Nk1GZG1JTlZLZnVSTXZUTm0xWWtoUnBwZWcv?=
 =?utf-8?B?dVRjcFI2RDZjNXl4dnpjSHR2NjNIRzBJeUQzN0YzUVh6TXZZOVdHUzllcFVZ?=
 =?utf-8?B?b1pjZlVUVWNWWGdFK1VTNHlxQmQxbWM2THpoUENQSlpQS1N0djYyenN2Rml0?=
 =?utf-8?B?WXhLQ0ZIWGJrWFlzK1FkdXlubE9ybnV4QUtKSGF3OWFkUnVYa2F6RVFFdWl6?=
 =?utf-8?B?R1BLVHRjMC8vcGYzRFF5Y1FuYVd0NGsrWFZRYWExclRRQi9NMmtwQmttVElT?=
 =?utf-8?B?Z3FwU3l3dmhoYWtobUtVdmUzWEdHNVlzQ24ybkFSek5KeGhiSjRuWmFJcjBL?=
 =?utf-8?B?QWplZDZ6QmVzNWlJOVpWdGNyQWhmNVdhWFFmT1VmRXowNE9MbUhpZlhHWVVz?=
 =?utf-8?B?RGtYcUF4YzBxTHR1SFhDYVMxdUwyeXp2cTVpbFVqWU1ESEwvR3pSY1RqZ0Ew?=
 =?utf-8?B?N0JWMlJFRzdndHVyK29wK01xbkYySm10eE9hMC9QNE5zU0p3Q2ZrUXhlUFFR?=
 =?utf-8?B?dVZ2T0FaZ1R2ZmZ6eCtMcVhJSlVHMW1Dd08rcnc3d2JNeWFud3ppUzVhV0VY?=
 =?utf-8?B?UkNjMkVLaUVpNHFueEZuR3pxeFZ6Nkd4aVlMNk9veklWYzZyamh2ekdySGtZ?=
 =?utf-8?Q?YZp/8CdR/grwfwL1zLovfAQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18CF324FE741114D9A380EAFA02E0CE0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +GBPjeJkX+P8sUw7/ZNr+ueezv3iGDZqxKfIUGnRDOzrrM/md5TPYqqfbTCS3c5MuQO6YJqumNr30EgsnnECe+rGNOyu/VceoxxcKl8ygi8KKnp2Xm5c212A4S9TGTfcKGtVZWbWsrydSnU2Nt3tKFy0UWJLd/NLRNyr2pxu7FvrTwBXpiwK7uJG2Z5xnDXjNxM7F+1NqiCgIhkho+OLucQxMfrY2Qg5MhPcAdokHNjVt7OAxudIx2MZ1pn3vndQtmKkhERgXp852M1DBdfHQkkrMjzg0FZGuKJPbxOXonj9M+rcHmfzxaBN6h94IfFhn9z9OnjAeelYUggAqv3zxCLPJeZLYmJUn+ZCm4sAeogN9KPjCIVgz3/XtC5c1wSIf5ZzcWwgRctLsi5fycALMXxCUZUfcoZouphn0XXiZf5+5XqFJV8Aw+nmMCtOOSckpr/pAOou6A0TwDaGQwgrNiLwpR0v8MhRL3cO2/Dm4p22att9o4XFxfZRRpcvcwDUThIyKuIluzpYSNMRAkYYQn/93LLJ1IpwYaHNhkeX3bnz6JY/NTk7Sb7+QySt7ZBhYOw8lKHCMT9GPrCbaym+S8VDSzOs/6MszWI9DZ2mkhFsbgzO6jPe/ozaQ0eE7m//HKavgUPN+QFwLK+6W+0uNljp3s1cW9K6nE1qv/Jd7czSNEE4ITAa570VOLohxWNaeriPxcd6w+Ac4hmDli02aQzB41kbcSUu2gDU8U/tgQtVndsDiyt0D/uiDTB5xpm3GZfpE0HWbkdLF1GE3JnSM/C26SZlnGbhXSyW4Vx1Mic=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f592aa88-04ce-48b2-2459-08dafb3efa3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 23:35:13.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lcsm41AZr/ptrO+KXTHUmg6abqP+a96d0Pr7a6yXOCwnJR9w4SMhTm5hDYqgvee5n7pSoOQDk9sPqC/7r8GWiAEQzoVv4LLFqL0Ofalw+9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_11,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200226
X-Proofpoint-GUID: WxLWxnFlyPRhIsmYmTq0hFrkUDAXrkoi
X-Proofpoint-ORIG-GUID: WxLWxnFlyPRhIsmYmTq0hFrkUDAXrkoi
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

T24gRnJpLCAyMDIzLTAxLTIwIGF0IDE2OjQ1ICswMTAwLCBDYXJsb3MgTWFpb2xpbm8gd3JvdGU6
DQo+IEhlbGxvLg0KPiANCj4gVGhlIHhmc3Byb2dzIGZvci1uZXh0IGJyYW5jaCwgbG9jYXRlZCBh
dDoNCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9mcy94ZnMveGZzcHJvZ3Mt
ZGV2LmdpdC9yZWZzLz9oPWZvci1uZXh0DQo+IA0KPiBIYXMganVzdCBiZWVuIHVwZGF0ZWQuDQo+
IA0KPiBQYXRjaGVzIG9mdGVuIGdldCBtaXNzZWQsIHNvIGlmIHlvdXIgb3V0c3RhbmRpbmcgcGF0
Y2hlcyBhcmUgcHJvcGVybHkNCj4gcmV2aWV3ZWQgb24NCj4gdGhlIGxpc3QgYW5kIG5vdCBpbmNs
dWRlZCBpbiB0aGlzIHVwZGF0ZSwgcGxlYXNlIGxldCBtZSBrbm93Lg0KPiANCj4gVGhlIG5ldyBo
ZWFkIG9mIHRoZSBmb3ItbmV4dCBicmFuY2ggaXMgY29tbWl0Og0KPiANCj4gZDhlYWI3NjAwZjQ3
MGZiZDA5MDEzZWI5MGNiYzdjNWUyNzFkYTRlNQ0KPiANCj4gNCBuZXcgY29tbWl0czoNCj4gDQo+
IENhdGhlcmluZSBIb2FuZyAoMik6DQo+IMKgwqDCoMKgwqAgW2Q5MTUxNTM4ZF0geGZzX2lvOiBh
ZGQgZnN1dWlkIGNvbW1hbmQNCk9vcHMsIENhdGhlcmluZSBhbmQgSSBub3RpY2VkIGEgYnVnIGlu
IHRoaXMgcGF0Y2ggeWVzdGVyZGF5LiAgRG8geW91DQp3YW50IGFuIHVwZGF0ZWQgcGF0Y2gsIG9y
IGEgc2VwYXJhdGUgZml4IHBhdGNoPw0KDQpBbGxpc29uDQo+IMKgwqDCoMKgwqAgW2U3Y2Q4OWIy
ZF0geGZzX2FkbWluOiBnZXQgVVVJRCBvZiBtb3VudGVkIGZpbGVzeXN0ZW0NCj4gDQo+IERhdmUg
Q2hpbm5lciAoMik6DQo+IMKgwqDCoMKgwqAgWzBmMTI5MWMzYl0gcHJvZ3M6IGF1dG9jb25mIGZh
aWxzIGR1cmluZyBkZWJpYW4gcGFja2FnZSBidWlsZHMNCj4gwqDCoMKgwqDCoCBbZDhlYWI3NjAw
XSBwcm9nczoganVzdCB1c2UgbGlidG9vbGl6ZQ0KPiANCj4gQ29kZSBEaWZmc3RhdDoNCj4gDQo+
IMKgTWFrZWZpbGXCoMKgwqDCoMKgwqDCoMKgwqAgfCAxNiArLS0tLS0tLS0tLS0tLS0NCj4gwqBk
Yi94ZnNfYWRtaW4uc2jCoMKgIHwgNjENCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiDCoGlvL01ha2VmaWxlwqDCoMKgwqDCoMKgIHzC
oCA2ICsrKy0tLQ0KPiDCoGlvL2ZzdXVpZC5jwqDCoMKgwqDCoMKgIHwgNDkgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gwqBpby9pbml0LmPCoMKgwqDCoMKg
wqDCoMKgIHzCoCAxICsNCj4gwqBpby9pby5owqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDEgKw0K
PiDCoG1hbi9tYW44L3hmc19pby44IHzCoCAzICsrKw0KPiDCoDcgZmlsZXMgY2hhbmdlZCwgMTA5
IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQ0KPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCBp
by9mc3V1aWQuYw0KPiANCg0K
