Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894DDEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 23:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbjFOXvS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 19:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjFOXvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 19:51:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62E1294E
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 16:51:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJfrm020988;
        Thu, 15 Jun 2023 23:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0pkHqIIaF6il81WBiF8vSjlETk19EHMCH56TlcARTYM=;
 b=qB4whXU8ghqX6n7XAR6Xd5oIy5/ynHufvDgmE/NWR/Lqi85S3lPY0z/UdwZm/dvPa8+R
 PGIC0I2J6tTiTtVj1h+vYIR6yHlChqA26eP0hImNSn+cSRdysOQFJmrAnsDzCHcTCPzL
 UBysqgBQ2JjXOdrSXhXXPhR45yqo22dkxofswbKJG7pEqoITSvxIkrdMImdrX+qHhVME
 rT2h7VwJhz0gFsgS15UdiTlHoo7zpz+lzxiHnUprL4POcszzmIzp2B1hYQw6n8SeSCOm
 9Gd8VQ0Vdjy7KpnXoahZ5XvZmo1wj2jQMMhe2pWw6JDbc9FPAMU35ovNacQ848sOx9D3 bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hquu79x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 23:51:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FMabmx011370;
        Thu, 15 Jun 2023 23:51:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm7m9ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 23:51:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmmU52T6SY74n/8XgNffqokoLvgzKtbb2MjS/ARJ9jFkTlJFySKHCwftVjfL3MCUiS1i5uwY2yisSbmGq+ag1MBmFAG8W3NxPOD08ytYIsHWJHNzewuuorHYQfRUT6lhRKKVL0jBpkj4GJ8boiqHU4qm4yrjcg9T/TyPljNEmPnH8xuUvJ4hWWlmqjwyP/AuDN+eu6LstyLuVNDjL3DsMTkwINomWhjar2cDBwcBs3kC69u5V1DjHNe4Al7h4wQbXG0ORdmnU697LjI58GrPC+ptTg66MG9nRhuCUoOZO97YOX56uao9DSHZNegWxYVs9tiub1TrN2WRz5S6IKNn0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pkHqIIaF6il81WBiF8vSjlETk19EHMCH56TlcARTYM=;
 b=FMV3ZICkxHkvprn36oxCiQIaTrUuOcpXJp2eHpXw6r7LpasrHznzALeCger7d4vorzzci19A8igOY3eW1QVWMYbyxLioz4jOWafVvIszjkMOCTfF+OnNjROdk3rsZmY4t6wmJnpZnq8wQG5VjM8AKOGMWuzz1O9hrOwb2EJE36E58050WeMCVEDebPYT7gdsJWzlhDlSf5eAGuu1bOQMeVoehWr1t7aBXcrZdnou7o87vhj9UR93/rrMiW2Ya9xtgWtKyili0YLQyB3wDZvSqPKrT/LCpYmaKAnUbWDa5tm4/vW6kX92dYJiACwFyz4bZfYoT1J+UJFdLiR48TDr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pkHqIIaF6il81WBiF8vSjlETk19EHMCH56TlcARTYM=;
 b=BerTlvDNKogrSX6nf9yQ+TFxWkFKQH94s2hCa1FpjO5iEH9MVxP4r+p2XP/Oj+aDgZarpqHU5Dz/txN1dHopAQEuMm/RWCSe474C3PlgUkXv9DABhrFoy7ByU3kiKHLLpwN8hgDLLYWJlagEH5ptiGYaqGPcCQJGQpa1gdCATgM=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BN0PR10MB5383.namprd10.prod.outlook.com (2603:10b6:408:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 23:51:09 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6500.029; Thu, 15 Jun 2023
 23:51:09 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOAgAAGmoCAAAT8gA==
Date:   Thu, 15 Jun 2023 23:51:09 +0000
Message-ID: <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
In-Reply-To: <ZIuftY4gKcjygvYv@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|BN0PR10MB5383:EE_
x-ms-office365-filtering-correlation-id: dba5f101-a022-48d6-81ae-08db6dfb64c5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kgm9UZPq6M8qbqj6eIYesJzzfiW6mEdT4sMjfX8UopOMTOWdZXzye1qZDlcOj1ueHa9vuxMkEoHvY3SkAfueqOgapUE+BuweOuRsU6VBkWn1Foh/OJ1H5i3NRfaINgbfLRaYdAKE43MGoWzGB74e6C/h76dHO+Pq3K2NiBpFkGtP8U00pWHbt7HAlkQI6qss8F5yt0BW0OJ9tTsqu45yPJxpbT4nvQnWjbVtyV/HzeXjtreoQ9BGoLrMfRtEj238kHMvUx+OA/wB0wRJOn72yztBR3eLtVvaWnwAw2q0TY1prylsRF4rZ84hFYriLOGS7OJ98Q9vFbeAK/muXp9HeX2rYi2GUZVDbPob9i5gF2LGamob3/yzPdaaG80mAs8XJ62g1uIdpz44RcEn3svP+eivq5oXQlGU9AaPQi5AVeUVpqUo3eUBi/YFe6u5939jy5Xt2uxpoxckwSUc+0xSgu4GufaHKroU6Eyye75xUGNVPUTNdspA6t6tQRWgGcqjwiQ6JsAyufL92PLHpQrhtc2DVDmEE9f9VclbpQWJJzsYMfJ3Sdd50GgCu0+MWuwFEBHCDIVvFBGpimFI/5ZGOgR0gCIiWrPYKd5OOLMUkKscIchp4u5szTY8I3Ut7CgYjEebyYg4arQBazZtzYm1hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199021)(36756003)(38070700005)(86362001)(33656002)(2616005)(2906002)(5660300002)(186003)(53546011)(6506007)(26005)(6512007)(83380400001)(478600001)(6916009)(76116006)(91956017)(54906003)(4326008)(66476007)(8936002)(966005)(71200400001)(316002)(66446008)(6486002)(66556008)(41300700001)(8676002)(64756008)(38100700002)(122000001)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEtPZVpWK0RXcXlGZzFkVTRXVmxBVzdsSzBhRmZXTWlrdkR3MWV3UkE2cHVn?=
 =?utf-8?B?R0pialg0SG1CNWl0cXlicDVCblpKMGhONHBkRjkvNEtNdzQwNVZJY2NwVTFB?=
 =?utf-8?B?cWpUMjlUSktEVU5pZHdoMjRVSVlmSGtnV2llVmFtUm96ZHF4bnRIUEE3M2xB?=
 =?utf-8?B?NVBLRjdIWGVuUk5TK3hNT1ByMDhwMVVEQnRCRUxPVitDZm4yM3FKU3FOSmIz?=
 =?utf-8?B?UHRTeVJWRjczVW94M2VYUWo1bHJ2T25waUpqVk9seTVjQWR2VEZDSnpnWFlN?=
 =?utf-8?B?bXlGNGoxRHdZR3lvejZDdlk5TWZNMWd1R0ZVTGpZQVVmS3pWbHNJWkRsWHBU?=
 =?utf-8?B?ZlF2dStyYzNtTU83RnFzYnFSWnFlcmtZUE1nc3hyNDBoZFpqb3FMZGpKcStq?=
 =?utf-8?B?UlpPamN0U1VRV2hWSDI0dU9Rc2ZsMWRHZUJmUkhxYU9wS3pJelMzNW1sT0pX?=
 =?utf-8?B?Q21EdkEyWGdOU00vOEZRUkdacGNYbXA3Yzg0Zi8vNGRQUHM3OGl0b0dIbS9l?=
 =?utf-8?B?SUM5YTdzOUVMS2Q4dW5POGNKUFJRMEpwSTg3QlRPYkR4ZWQrbDhXbklDb3k4?=
 =?utf-8?B?M2wzYzZ6WW5PS0J6cmZ6VG1RZGQ0YmJLZjVWRXU1cnU5bVU2NlBoUTRMclBP?=
 =?utf-8?B?dDEzVnZuSlJHM0kvVE1nQkhmUmU2OW5KNUo3eHk2MStlVlNSL3hqekZlTVJQ?=
 =?utf-8?B?cHBTNFVQUTJvNkR2M05aV3hIL0t2ZG1BUmlCbFQzTC9zY0t4bUdaTHh3NGhr?=
 =?utf-8?B?Q1ZtdFFERmdRUFBzUS81cW1oanBHVkFGbzgvbUlUOTB5Q3p3WjFWUi9tM0JH?=
 =?utf-8?B?SzJVbGNjbWR1aFMxNS8vL2tSQ1lHN211YTFIYnZMblhLanZpZi9pbG0wb2lG?=
 =?utf-8?B?T2l5cERGdzcrM2Z2cUhkRWdsUHZYcFczRHRSa0Q0OGJZUmx3MDlUK0FiZEw4?=
 =?utf-8?B?MEs3b3grZDBKT0FPalFJTmlISGlhQm45dFlrWHNieWk1OVRwYkJNbFNtRElz?=
 =?utf-8?B?bkNNTENDZ3ZWMFlJWFV4L21wY0J0M0RUbCtVQU8xYml1cTVCY0VmdldZUURK?=
 =?utf-8?B?c2M0dVBrbTU2V2dIcmVnSXozN3N4V3BBSzVKelZuR1lXeTcwM25QZmU3TmFi?=
 =?utf-8?B?TVM4Y2Rua2JWUmMzSUEyQTI1YXhndGQ4VVVqR0ZxeVg0ZmtXeVpNeHdkeDEv?=
 =?utf-8?B?ZllvdktlY0ZoUXp2U2R5aXg0aFNrMS9hMWQ3K0F2cE1DM0xoMEVqQ1lSR1E4?=
 =?utf-8?B?blRKSFV0SzAzaS90cm9tcDlTdEEvU0paRXc4L0VTWjl6VG1WSHk0by9tN2V6?=
 =?utf-8?B?a1pkMUhJMFRpakdHc3ErTlJ5eTUzSkVheXQ4TVNxVTVWTy80eGZFZFZaNVhB?=
 =?utf-8?B?blhyUGpFQmt1Zk1KT0M0UGllemhUbHJGKzBGcHA3NlhlRHhDTTlpSzFGK3dH?=
 =?utf-8?B?Q0xBZXV6WnFQalZRdnpQZXI2SlNwSGNNT2ZlU0trL1NpWmFUQU9vcEFKUVRa?=
 =?utf-8?B?dkV1Q2JQREdZK3VId0hDdWc2RzdmODBHYlFWNzhxTmpKQTBYazRRVnFTWkJM?=
 =?utf-8?B?azZjWDE5WnBlcUtIczBEMkR1Tk8rSk5aS2dOdWlBV0xTS3FUU29Bbk1WeVpB?=
 =?utf-8?B?d2E5c1VjUGdBY2ZlSVk5OHFGM2FaQWtmbDdaclMzYThGY0FnbkYvYkhSVktr?=
 =?utf-8?B?K3JRSExkTWdON2RjYTZabmpkZE81SExGdmduUEhhblF3V2dUZnNER3h2UTVw?=
 =?utf-8?B?NTNVVXZFYVczR0ltZjRaSUpUTnRRbmNiVHhtZ2NVbWxESnZIaWo3NGVOekZH?=
 =?utf-8?B?MzlQcEVvWTJnS21QUUtSa2owVU1RdVNDZlNjbGlRVTB6QWxRUmxlRUdvU2pk?=
 =?utf-8?B?MktjdFZyTUpJL3E0ZXYxR2VRQ0syY0Fqeng5SVp2eUlqcmtKdys0dyt4R01G?=
 =?utf-8?B?UCszUVJuRTlGRFJGY0MzdHM3aHJxdWEwbEh1ZGVGZjdKVWZ5VXhEcUpxRzVN?=
 =?utf-8?B?VEhUVDhBclpEY1FLSUxBbzlMZXNqTHhWYkg3Z3hXZ3l2MGM0YjgvQTBNNXpI?=
 =?utf-8?B?MnVLcnJxZnQzQ1ViU1pCVVlzWFAvZGppbXBBMXpjN1d6MGk0U1VmMWF5KzQv?=
 =?utf-8?B?RzRvUUVWRHBVbWorZktHZFdTSC9vY3ZjMFhtY0VxVWpLYVlmeE5LNnI3anRq?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C8F054F5A2DF94792D9383F5CF3C254@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jT/VXQqlgg0n9VyS+TtewraTEOMCCdKs0C5UuVTAlvsxQMMmUzifHmX7n/osgUOkK1+p3CxIgXUNVqadJFS44ODRhl07id/5JoaAC1M/QMueuRbGhvO89f+0lJhDvQnObUU6Bugnjn1T/lh1kMSiNm5jAEiMnb4Bln9BoHPi7ul9GHTJOEbTy+nyyPL/ysbZ4VWs1lct2nr5LEF8sscs5etuy3fiGd2e0LjH4OM0+1ILfc8JdGw0BjqJRyvYGxLo1Q04zngsKVO+4HitycaQgYco3ZTRMIqQzFCopW4hXnQBAEyiW4f+DU2MTreaijnpuhXDDN9wmTzDEsrrwLpfzPkBMGmwzLqkruZw0guG1w11MNVVsuA0aBkXPSAXWw5dL0ENYmzD4fALyJ6uEc7eQnCIakMniG0xnLtn2ZI5IJQRb7CW4zMf2CTapfJ4tfNaHXd36tjNYpOicN1Qasy+sdVvze30fBEH7NDgIcfIK/A+B8MvkCwbP7U3WC+mAG7oxp8Vy8MVSY6GtFsDRvxpivrWbGeIwFODxq4+/k1Km4HOo1cs8Njb6B0Y6Y91yBv01WmqbGVtyV51DbgEi9iwTa7etSV3D0BxiIA942lhNTI9QFEqqLjK3y6Xs72Hw2++296KCbbamKt5wseZfQZf80LnwyrXi/oJSTYe3lSzXXWIzLv0GRnPCGocxLIqxHpLp/YDyGQwxPN7JGaTHSByk828Vv98aCTDKt4UsqHip9+6vGd0W1c7qyCObQYjH2FQdOBJkIwPjX027MSnSm7wWO7gcPV0lGaxOPgXi+KBmXyqcPmOlMWDo5l/tS7VaOQrPcCWO5tTlrFf6uijljP9gQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba5f101-a022-48d6-81ae-08db6dfb64c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 23:51:09.7329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 72byEeY2DQuUPzJiSyHzZci4tiMRdf1GsGFDWEyjtKnVRi6zEz21Oczrzw7fpxOgc0j8VYXFWKhijraqUO/SWJppc9FF42eyvyOYUDX8ZrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_17,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150203
X-Proofpoint-ORIG-GUID: y7XLasluDxJa7A5z79VjOvE5Fbb63ysf
X-Proofpoint-GUID: y7XLasluDxJa7A5z79VjOvE5Fbb63ysf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gSnVuIDE1LCAyMDIzLCBhdCA0OjMzIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBKdW4gMTUsIDIwMjMgYXQgMTE6MDk6
NDFQTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gV2hlbiBtb3VudGluZyB0aGUgcHJv
YmxlbWF0aWMgbWV0YWR1bXAgd2l0aCB0aGUgcGF0Y2hlcywgSSBzZWUgdGhlIGZvbGxvd2luZyBy
ZXBvcnRlZC4NCj4+IA0KPj4gRm9yIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgdHJvdWJsZXNob290
aW5nIHlvdXIgaW5zdGFuY2UgdXNpbmcgYSBjb25zb2xlIGNvbm5lY3Rpb24sIHNlZSB0aGUgZG9j
dW1lbnRhdGlvbjogaHR0cHM6Ly9kb2NzLmNsb3VkLm9yYWNsZS5jb20vZW4tdXMvaWFhcy9Db250
ZW50L0NvbXB1dGUvUmVmZXJlbmNlcy9zZXJpYWxjb25zb2xlLmh0bSNmb3VyDQo+PiA9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+PiBbICAgNjcuMjEy
NDk2XSBsb29wOiBtb2R1bGUgbG9hZGVkDQo+PiBbICAgNjcuMjE0NzMyXSBsb29wMDogZGV0ZWN0
ZWQgY2FwYWNpdHkgY2hhbmdlIGZyb20gMCB0byA2MjkxMzc0MDgNCj4+IFsgICA2Ny4yNDc1NDJd
IFhGUyAobG9vcDApOiBEZXByZWNhdGVkIFY0IGZvcm1hdCAoY3JjPTApIHdpbGwgbm90IGJlIHN1
cHBvcnRlZCBhZnRlciBTZXB0ZW1iZXIgMjAzMC4NCj4+IFsgICA2Ny4yNDkyNTddIFhGUyAobG9v
cDApOiBNb3VudGluZyBWNCBGaWxlc3lzdGVtIGFmNzU1YTk4LTVmNjItNDIxZC1hYTgxLTJkYjdi
ZmZkMmM0MA0KPj4gWyAgIDcyLjI0MTU0Nl0gWEZTIChsb29wMCk6IFN0YXJ0aW5nIHJlY292ZXJ5
IChsb2dkZXY6IGludGVybmFsKQ0KPj4gWyAgIDkyLjIxODI1Nl0gWEZTIChsb29wMCk6IEludGVy
bmFsIGVycm9yIGx0Ym5vICsgbHRsZW4gPiBibm8gYXQgbGluZSAxOTU3IG9mIGZpbGUgZnMveGZz
L2xpYnhmcy94ZnNfYWxsb2MuYy4gIENhbGxlciB4ZnNfZnJlZV9hZ19leHRlbnQrMHgzZjYvMHg4
NzAgW3hmc10NCj4+IFsgICA5Mi4yNDk4MDJdIENQVTogMSBQSUQ6IDQyMDEgQ29tbTogbW91bnQg
Tm90IHRhaW50ZWQgNi40LjAtcmM2ICM4DQo+IA0KPiBXaGF0IGlzIHRoZSB0ZXN0IHlvdSBhcmUg
cnVubmluZz8gUGxlYXNlIGRlc2NyaWJlIGhvdyB5b3UgcmVwcm9kdWNlZA0KPiB0aGlzIGZhaWx1
cmUgLSBhIHJlcHJvZHVjZXIgc2NyaXB0IHdvdWxkIGJlIHRoZSBiZXN0IHRoaW5nIGhlcmUuDQoN
Ckkgd2FzIG1vdW50aW5nIGEgKGNvcHkgb2YpIFY0IG1ldGFkdW1wIGZyb20gY3VzdG9tZXIuDQoN
Cj4gDQo+IERvZXMgdGhlIHRlc3QgZmFpbCBvbiBhIHY1IGZpbGVzeXRzZW0/DQoNCk4vQS4NCg0K
PiANCj4+IEkgdGhpbmsgdGhhdOKAmXMgYmVjYXVzZSB0aGF0IHRoZSBzYW1lIEVGSSByZWNvcmQg
d2FzIGdvaW5nIHRvIGJlIGZyZWVkIGFnYWluDQo+PiBieSB4ZnNfZXh0ZW50X2ZyZWVfZmluaXNo
X2l0ZW0oKSBhZnRlciBpdCBhbHJlYWR5IGdvdCBmcmVlZCBieSB4ZnNfZWZpX2l0ZW1fcmVjb3Zl
cigpLg0KPj4gSSB3YXMgdHJ5aW5nIHRvIGZpeCBhYm92ZSBpc3N1ZSBpbiBteSBwcmV2aW91cyBw
YXRjaCBieSBjaGVja2luZyB0aGUgaW50ZW50DQo+PiBsb2cgaXRlbeKAmXMgbHNuIGFuZCBhdm9p
ZCBydW5uaW5nIGlvcF9yZWNvdmVyKCkgaW4geGxvZ19yZWNvdmVyX3Byb2Nlc3NfaW50ZW50cygp
Lg0KPj4gDQo+PiBOb3cgSSBhbSB0aGlua2luZyBpZiB3ZSBjYW4gcGFzcyBhIGZsYWcsIHNheSBY
RlNfRUZJX1BST0NFU1NFRCwgZnJvbQ0KPj4geGZzX2VmaV9pdGVtX3JlY292ZXIoKSBhZnRlciBp
dCBwcm9jZXNzZWQgdGhhdCByZWNvcmQgdG8gdGhlIHhmc19lZmlfbG9nX2l0ZW0NCj4+IG1lbW9y
eSBzdHJ1Y3R1cmUgc29tZWhvdy4gSW4geGZzX2V4dGVudF9mcmVlX2ZpbmlzaF9pdGVtKCksIHdl
IHNraXAgdG8gcHJvY2Vzcw0KPj4gdGhhdCB4ZnNfZWZpX2xvZ19pdGVtIG9uIHNlZWluZyBYRlNf
RUZJX1BST0NFU1NFRCBhbmQgcmV0dXJuIE9LLiBCeSB0aGF0DQo+PiB3ZSBjYW4gYXZvaWQgdGhl
IGRvdWJsZSBmcmVlLg0KPiANCj4gSSdtIG5vdCByZWFsbHkgaW50ZXJlc3RlZCBpbiBzcGVjdWxh
dGlvbiBvZiB0aGUgY2F1c2Ugb3IgdGhlIGZpeCBhdA0KPiB0aGlzIHBvaW50LiBJIHdhbnQgdG8g
a25vdyBob3cgdGhlIHByb2JsZW0gaXMgdHJpZ2dlcmVkIHNvIEkgY2FuDQo+IHdvcmsgb3V0IGV4
YWN0bHkgd2hhdCBjYXVzZWQgaXQsIGFsb25nIHdpdGggd2h5IHdlIGRvbid0IGhhdmUNCj4gY292
ZXJhZ2Ugb2YgdGhpcyBzcGVjaWZpYyBmYWlsdXJlIGNhc2UgaW4gZnN0ZXN0cyBhbHJlYWR5Lg0K
PiANCg0KSSBnZXQgdG8ga25vdyB0aGUgY2F1c2UgYnkgYWRkaW5nIGFkZGl0aW9uYWwgZGVidWcg
bG9nIGFsb25nIHdpdGggbXkgcHJldmlvdXMgcGF0Y2guIA0KDQo+IEluZGVlZCwgaWYgeW91IGhh
dmUgYSBzY3JpcHQgdGhhdCBpcyByZXByb2R1Y2luZyB0aGlzLCBwbGVhc2UgdHVybg0KPiBpdCBp
bnRvIGEgZnN0ZXN0cyB0ZXN0IHNvIGl0IGJlY29tZXMgYSByZWdyZXNzaW9uIHRlc3QgdGhhdCBp
cw0KPiBhbHdheXMgcnVuLi4uDQo+IA0KDQpTbyBmYXIgSSBkb27igJl0IGhhdmUgc3VjaCBhIHNj
cmlwdC4gVGhvdWdoIEkgY2FuIHRyeSB0aGF0LCBJIGFtIG5vdCBzdXJlIGlmIEkgY2FuIGZpbmlz
aCBpdCBzaG9ydGx5Lg0KSSBhbSB3b25kZXJpbmcgd2hhdCBpZiB3ZSB3b27igJl0IGhhdmUgYSBz
dGFibGUgcmVwcm9kdWNlciBzb29uPw0KDQp0aGFua3MsDQp3ZW5nYW5nDQoNCg0K
