Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0185FEB64D8
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 23:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjFPXO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 19:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjFPXO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 19:14:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE65D3A8C
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 16:14:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GLf7fu026801;
        Fri, 16 Jun 2023 23:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8jkAYgss0oWD0/OboJKXZVW8PTB7ZyeR6fryEuXw2iA=;
 b=FLExl81Z+vJSc12Z5ziyM5hBxObcyeUv1qtiCdrqk/LYD20Hz1tE8uSnY1W7688R1Bod
 E4q0YhE6iQkvyCKnIxIolJMp6TjcNOrOTFV5oo7mvdrOYOQ0fneFCFzH3wLTeP/OzLgg
 C8PkiphbAMUtqR8xkS5Y9pHvH06a7eoEuiZU4RhYDVKfssK/p5G87iVqQeRsGFvNialh
 hzCgB8ZgMULzOeXNvmgy4Rvj/qfer5w6NwTBjIx7M9jYUmj84xOZwn2lWYn+5B9lnsHH
 1yRAAum7Bj5XBwEqm40VsYqmQRgbWZds9hWC/pG1qUcJaOsNSTZK+S+nCCM9cWBRTq9E uQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2aw3xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 23:14:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GKjtDD012374;
        Fri, 16 Jun 2023 23:14:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmf2a5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 23:14:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xgh83gZ4Ks7zRmS87VxfZNI+cUl2KKSbJ7mRy5UeVS5n+DlunWChi24VmthZtVqPZWInrJAlmeEQML/dQ5wcZpBuqCEWQYDNsJfqu23cTh4F2/AwVp+tneZONAs2uG/PeiAUcRpMTKD5cvmqkwwgzEzhOfkjAdzJpgZmGJf5IOWmvBiD17lUyXoGqw4MPMHD1SVVKI1F1OaehCxd+8rukbHmMTZKNVugPz60k5/vdGEyPRl9DHtp/q6SH/wkT7dIofDaQEZrqwXPmvJEZKhnCaFpd0s0Ks45NJ5uYTRIDi5FnC5ebeiA5saWNuU04tzJ1yaUMFedEo3snZ5GTVFpoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jkAYgss0oWD0/OboJKXZVW8PTB7ZyeR6fryEuXw2iA=;
 b=CcHGyj127ZlNzL2goEEcOj6dDzz3lIfwDqk6GHOsfCt1q0TitADt2YjxH66LUDFWfcJliDPkvwKwb2Db/50Xy2alFrXRq43aO+QGslRDtTTEhfNdaVeKyGWcJ/nk2dd+0Da8mmC2sZohgCHTaARDg3d4yx1aSW4kbYLNAbSBrvVp/It2LOchMqMtW10GsmhzE1v9Jkba4BCcQdyr177bX1K9zBZfnX6tSz23SrK0FeNBbGvSvfajGH9r+NSDDsNdalCmk8j5kx9ZJJ6rOL6mFxor6MeE0l84dvSuahdDSFVu6pGKPgPMUNkOA5I4clNsuRxrVLRYEJpac+zYgTxnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jkAYgss0oWD0/OboJKXZVW8PTB7ZyeR6fryEuXw2iA=;
 b=Vtn5gqTrFRqjU3xTq6MH3LIRBLLdurSKYHJYvmQ/4xs7T61gejOUX23h/QmM0tgkJt11RrOuRAFKIN1W7TaEFbxcY0TWuqz5++AV6cg6sOpBHvRWLq/c68jszWZTCmtOEf8ogT54aWRuBosOx9wzIIOm9yWtdZvV8vm5s6whPSY=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by DS0PR10MB7319.namprd10.prod.outlook.com (2603:10b6:8:fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.30; Fri, 16 Jun
 2023 23:14:50 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::5f1f:6ddb:112:a1a1%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 23:14:51 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Topic: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Thread-Index: AQHZnyqiJVfvBqN/ZEat6GgWNoCKPa+MalAAgAAE8YCAAASYgIAACrOAgAAGmoCAAAT8gIAAB3wAgAAGxICAAD73gIAANOaAgACpiwCAAE/wAIAABrIAgAAF5QA=
Date:   Fri, 16 Jun 2023 23:14:51 +0000
Message-ID: <DBE6AA99-C1F7-4527-BAAA-188EAA29728F@oracle.com>
References: <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
 <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
 <ZIwRCczAhdwlt795@dread.disaster.area>
 <B7796875-650A-4EC5-8977-2016C24C5824@oracle.com>
 <ZIziUAhl71xz305l@dread.disaster.area>
 <B8A59418-0745-4168-984F-5F9B38701C1E@oracle.com>
In-Reply-To: <B8A59418-0745-4168-984F-5F9B38701C1E@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|DS0PR10MB7319:EE_
x-ms-office365-filtering-correlation-id: 76eec648-a711-455c-bd13-08db6ebf7cb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lhD70P+UVv1vmDGAHWINf/X9kjgvPAj0iZ2Q3jtyvNmIyp3BgTDIC+YQLJPc6X2fM7JQMXGNYWNC2+sNdwdegS0iQ5wZOWOkX/9DSLqYS6QqMf6YrQt0RQ7I2NIzqayzIVgWs08KVy4y3c5TZEHpujXYxA/oqpkW14cLYjCvwNQGMVmxK+wPYO4dHuXJ95Q/aDXFMDawAyAw/p5DeHHwZxFpRVGO7nw7bsP70hZ0icJo750eTsbuL72+EY2tZx872mlBWh9ffIgTORK8ajYgl4He8rUf5qo74yWiHYJgfA7KzNtUfppaKhvDJeWL9tyPv+o/AKNddGND2QuKtrCCvLl8pjW242syynut9NJYaBXOjh0A2ysbaz01ByAyjabWY0ztu3urONN6xKlU5kemIg5N+g18jH7rk881Jmi20m8nkLWvPjrWajS8O+BauLhyDjoo09YpLFx5ScEK/IRl510iwmrHpBkzXNbdwv6XCVOv58i77eGovaR7c8IKrxz5VANS+c9B9xWjsoIAx7xLoGfnue6QEMaVCn84Z6t+dkaYDdDDWdGY9oNK0f1L5E1jnZtW+FEcEoe4ZoXk/C9pbOfuoxjC9juVva0gaZFXRfiWtWaYbxe7V1G8dE3kLR67xTTTPBPKYBOMwjvJMqIyog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(2906002)(2616005)(36756003)(33656002)(558084003)(38070700005)(86362001)(38100700002)(122000001)(8936002)(8676002)(478600001)(5660300002)(71200400001)(6916009)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(54906003)(4326008)(41300700001)(6486002)(316002)(186003)(6512007)(6506007)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1jeWmUpnp9os0TIwDypDZNxexkJO4YCz0PYh4NHZNXqxffAq0rzDmbI+/s7E?=
 =?us-ascii?Q?Fo6pA8xMcJ6LEB6EwUj8s3m+LUAvxYEIoC367r0zujwGB6WulW0O/JNGu4xp?=
 =?us-ascii?Q?TApdO/frQnjiQ+zTwJhxXcZtoWU8TCaXRolhH0gvXF6KN7x3dL+LCOxCA76y?=
 =?us-ascii?Q?1mOJ+k9xkpGNN0TSYHiJ5sQm8D6TY494NxSBZGKrE2rZUrKlblsVOlOt33zA?=
 =?us-ascii?Q?Sh2kPY/pMAEr5bmyJ/o/UI7bQLWZuVuwbbLz+hKUBpXuHdoTIvxJ54b1Mfzr?=
 =?us-ascii?Q?JNIfW3vGqjyMHiGdWPwCBqeEy74lmKz3FeAZQknC+GCTNMVq6ebS4JlQ+UbI?=
 =?us-ascii?Q?wp27XX4TrLgWKYkVeODCU4whBbFo4jNAzpsjSRBYQ6ACk6oMXAcuUYfoXann?=
 =?us-ascii?Q?XBXb3G5ViUgay7g19Ax5aZLYeDqzluoFw8JtDZYcVrSjSVI9C97EEVkxLU1A?=
 =?us-ascii?Q?N1CxOmRMGTj4voLFP/r5BBnDTXvC+Y2XfgV/jnSHy9Uy6cLWStTH6btmqcMd?=
 =?us-ascii?Q?bUjRs0RVvK4PinkCqJLBEgX509j+gS/eWzQOMKdrYaXL1+PVEXtRb2pSFOHO?=
 =?us-ascii?Q?Pk9mw0MtS/KxrlTSFVz3R+0kGVuye/2wPGAzulOt+seb8d944mxaunvvJWyU?=
 =?us-ascii?Q?cyX2hZPvsbGgwz3lLZHjB/rPdHSkhvmadSb2BK2r4kzMU9EcpHnZfFB9IvoE?=
 =?us-ascii?Q?34FAxEaMixA4UkITodK1j3xhOY7sVkwz9URh6s0JdkQWAePDMwhSrhg90Gn5?=
 =?us-ascii?Q?+pyDALw+NqYik61lGaqsMqu/8GB+o9a8B5oFIIDcP4MzeE5gnfeI+A+ySLtx?=
 =?us-ascii?Q?QRlQto6M3JxLmFFT5GAgBFVtJe9RZpmB3gvIfAmdA8v+r8vhTDk7/RdwbjKm?=
 =?us-ascii?Q?f8251xe9xOBFV2dJkGjamZ8fQOhOf0V2fOTTfBFHJRwjQPbQuFax6oISOHOW?=
 =?us-ascii?Q?zvYtmUB8+fMNXBu4kaM1RmmoVRHhxXir5JN0l4tc4fZP4PU1FGv4zGozhg9E?=
 =?us-ascii?Q?JQFOL92dwpcJwHSWEHpTn38bpUL7gj7pIKhAkzytSS7Vk2fK/VeZ3RUeor/C?=
 =?us-ascii?Q?aIplZCuOgosP7cV/aRh7mZi8ID9BZPUP1pq7/iI+d5BxO6E15wX/QdUANXeS?=
 =?us-ascii?Q?VU1WuXV44IcuqwNzTs6D+RcZiTOMYyev8cOiZvkgBchGg4cqkw/0Oa0+RJXW?=
 =?us-ascii?Q?v5LumGuc2ZFHL5Y1mcFZ1mjaH6nhBwLoCROfcVzc6c1V08QtOW2NPWVZNyRk?=
 =?us-ascii?Q?h4BzJaaQhDJwgclZMDS1k3RYoF+MHM7brArA0EQZHDUn923HRH/H9YqAwGfY?=
 =?us-ascii?Q?s+ChUdBVKUEvHrBcNqo/xkybP66PVHgY2BKMR0/5xvUFqgkWtyzL+Br/hjy7?=
 =?us-ascii?Q?qw76y+u1tcay0+uCfP7hT/hs92ffqQeiitDmKkud51JMowir4LgZPMUvQszV?=
 =?us-ascii?Q?DRjQHhZ+k11YUFg7/1F01nB5mV6+26ZXSF7zdb+1oHhLCf74PV7s5VTRvBUc?=
 =?us-ascii?Q?yH6VVjqfzgKRdBEaK3QsPisCxGVLrY4bHb+W+amFZVhIEeTudWKuTCWPlZuG?=
 =?us-ascii?Q?GIu9ISmZVYyaf1QqtHV52kI8vC1/QDHPnGUbC2EHk/Aevt134R0gx/Js9goy?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24A517F529E8F448A25572A95F82802B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VKz7jQ3IHJHoPfTDkGzQJdsZV+LOP3fjMU4DAX/dKmHgOfL5hGJIvyB8QgFskXVXhPiTzCbUGOL6EokUuHgLX69U7HMo0DdBo255zzmzdhbhwsl+78Ey0Jo5bc9ESFtWZCG0tZ+JC9uR3GqpoOmHRZzJNF4/a0Fs7qiWBZMa/b30yT6cQoy8KVC3CkwHb5AtpqtbMNHdWQi5CY4gXAwpKtoxqXqmOuyP1l3IHGZBywXM7PGn2jBaASAGeuxFKLx/777aSqO/s4xkTlcsj2TSZ/M8naRHSwjMPp7k5dFJW5tIIdXDqIX+j7awf6x/JZ4gus0AYLHjpP5nttaUjw7eY2jBh8MiZKe38Vqn+Bssiwj6kWAYTEBgNjvhE0SH9jWkIRowLx1e+8dei2hgBVSbftadjs2kFMkv8B5/wKBcirveQO/IrouQOFo0pnWOAFW5tkZZ2KySsoYYw+thW/NRiRBeUOk3IikYpgE6yIgH6InNk7wEznV+EEvL4wU10WRPokMnSv9lCiTbraAonhQBApuDR0APYHdQPeKReQKAsNfGfg4OpsxzFMkr+cbTDRqfOHv2iz2Zre9+Mecy9qkVciuCIsawJj0AplqaI2VD8MFHncn2w3/UIWadtbVjhwh1vFhf67aVfSCMWorFy2YzzTgpmughYOL9tvz23ylMTMuEKDlYYb8Jg6uX/tCX3eFY9yX8Oj/syPM9C6rQKahnN1EKEM9g0+mJu9w6yrDFjKB2rtT8kLUV1DJMGdQnjCoqwDSiOq7rMgp+VnYegCeldnpbhw7SpOY39haqdBIYFkMDcjpyCGfbcL7rWpIAMOtoXO/g6MfBIKj7D4frbJBLWA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76eec648-a711-455c-bd13-08db6ebf7cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 23:14:51.2637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gaPTGBgD1732Yjqq/B+GZ4IT0MeNiW368QSfaMo+c9cUTtZvP3MslVbONO5upaLo/nAC4UkRVX1lzjvDqMBNXRe95BzpPidK/NT9bEqTI/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=767 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306160211
X-Proofpoint-ORIG-GUID: Gj8YuQZ3NBzzSK7OnNbAN3tpOriyt0H3
X-Proofpoint-GUID: Gj8YuQZ3NBzzSK7OnNbAN3tpOriyt0H3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>>=20
>> So, can you please just test the patch and see if the problem is
>> fixed?
>=20
> Then OK, I will test it and report back.
>=20

Log recover ran successfully with the test patch.

thanks,
wengang


