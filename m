Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47A0C77B75
	for <linux-xfs@archiver.kernel.org>; Thu, 18 May 2023 01:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjERBZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 21:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjERBZX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 21:25:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31BC30E4
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 18:25:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HIH42B002521;
        Thu, 18 May 2023 01:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/JO4AAxBi3UywU49jRfPZ67VF09HN/QmZCdraq4xFjY=;
 b=akOqBN+QWCyvKKs9IZF6eA+Ux6nCnMhFcXSijY7HaA8+IFn6zhQERN4F2TBXU/mCyZ/G
 pwmB0ZZEuDICFxrdQXRCMvCAs8fbDPHjnjajlkcKenKmu48L0iGcFQhJ+pse6J827ZWl
 q7YHT1Y0JYmcCtKCjI28czuop4U8Q7Jft5EBdfqLkFCnERCg/sJY0k/3vdNReMNs8bY2
 81cDUDKq7vvegph+lqjOQ+Y+tPHpKw+/vLB6KZeE0pt6wh4/n8d54pX9eChBIpxR959k
 pQZHCsB2k2rSQhOibgJvy+1bo+NAfZvidVphVTyOZSJ9n1MbkNHZV9dCUwawpsqlCC0P 8g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxps1gmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 01:25:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HNM7p3039990;
        Thu, 18 May 2023 01:25:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj105wfst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 01:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcpjyWtRqlFJ6SLwKKYM9Oas/BhWTL18yD+XFDc3TZ65tHXT6cfLKw2n5HYJkRpCoxqI/w9HKg/Fg/WPhvtxssBiSEYPkbBNgxTYZarSvJ5NXUwZbZbsr/lWfNwlQ7MhEKysEERCdFVgLURjV6K3PZbCgXsO/m2kuYT/BWgHJjNz8EXcR70njODMFMyLxvpA/czgONqwlGYVHcD2F9VFy2hEWiiLRbgOaEdFYBkveBlJ4JAtnCH7AwAz9/pJIPQ8h38CAotswLP67zeZ1Ld4Gtwc4nBVJPufCK+/Vq6kbjX4buJnQOw1dtCu4F2DjwGDBBG/Ksz2pKcjQuBUWhxpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JO4AAxBi3UywU49jRfPZ67VF09HN/QmZCdraq4xFjY=;
 b=JKN5SHrfimw+j2G6r64amtz3/MqthufuwACTGyDjGOi8GX8NVWW+CDotNEq8nJ2E4pg6h0NUJftpO4KgB3qGGAXHPq39Q2n3g1x4ll7vAQTk4sGWwimUMI68E81bq3fKmVr6rCF4ay8A6kL0xpDNbHLT0/p+GVVtTwfL2L+VeYk3l+KGWbj5XKfCsSXeqT+JfEpQ/uV2jvmgj3kgFicne1M9oQHaHgb/FECnLDbVJZZ1uHwwkIbSo8GR8HvUgec5eTBP2T4TAO5kvYAm3erdFnu90YZjo+ahb7EAmQ6tRQYbq0ChO7pWtlILTEu9S+CxpNUCZS2Fm/tOubt7vO1tmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JO4AAxBi3UywU49jRfPZ67VF09HN/QmZCdraq4xFjY=;
 b=w7ijyKHQ7crcMrAOig4HHL0IsDYTfE149Zj48C9LjW2FbN93nvr+xtdzAJimFAwwvNfIUj2JpOUZ09g+dNaVd9NusQBZtQ3beQK0/Q/jFGzof6iiYvpW5o371uGGZ4Q1BF/mGPLha6jAVtB5pSluiJFvw61SP846Id37nDpqdVI=
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
 by BLAPR10MB5251.namprd10.prod.outlook.com (2603:10b6:208:332::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 01:25:10 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b]) by SN6PR10MB2701.namprd10.prod.outlook.com
 ([fe80::58cd:8b89:f285:ca2b%7]) with mapi id 15.20.6387.035; Thu, 18 May 2023
 01:25:10 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
CC:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Topic: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Thread-Index: AQHZdv9AR28b2kBDxE2gDgdaeEYEXK9XEBuAgAAZP4CAABXWAIAAEsyAgAXgZgCAAJU2gIAAC2uAgAEmj4CAADwYAIAAFrUAgAAOEYCAAAavAA==
Date:   Thu, 18 May 2023 01:25:10 +0000
Message-ID: <AEACD4EB-89E8-45C8-AAF6-2CBB5A674E14@oracle.com>
References: <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
 <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
 <ZGVZ9o1LIkZ5NPAo@dread.disaster.area>
 <51550386-87D3-4143-9649-04E69CC178F8@oracle.com>
 <ZGV4z5TwbUVaHqeC@dread.disaster.area>
In-Reply-To: <ZGV4z5TwbUVaHqeC@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2701:EE_|BLAPR10MB5251:EE_
x-ms-office365-filtering-correlation-id: d7d4bece-c252-4d03-6ca4-08db573eb8b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PFgjU+5D6chf+vM0KrJeP5aAfJCXnC7oTeDzTxJoLUDZBMVTCW+kO3C57lfOztgI86d1fKpoke00RqvuMoEphv3SRB9C2gdi6/BkMUZ2gyO/hj/V7UCE8FH0tyaU+IbcGX+3/53OTQ/jVIGB0CoswQh075hPLoRBllFl811c2E1E2qrEydVN780F+5G5kB2NsGqFriT8T9JDPDvaC8a4tvG+H3GerN/CIIDFb7rbc4gAsaZkiiWRxAUd06Dx4/r8ziURoGdMZXwZUt57ONZHT5ApvtiTTyS/Rvrde98Yi9+RA1uZiGeKL9L7iBPq9eMTz7fG15iYfFPbPVRXqpJpFTK4w6P2/+11Q0iP0sthvIwvCxjrIy/lGHJB1C3Rhx9OBPjq9SlQNPXnmKXh5VWuBA+dDMoiXWOrskwDiVrz0gbdoDuWX2gXg8FIDihpY5On0bdLTF72R+XDJcchlyVACRb4BJfIamNbBtZ/hcYoF5sXo6D1ICDMDIatZs6wg6K70uTodYmtD1cpvRomJIGnwbvjMsmIYN9h4EDeVV5nCEbUkTwrNH46P541OyK/bMBGSKZAqoSgRXq+XCy1bB40qpr8Vf+WKvwEk0sG/jyLFNb7++qfYFa6RWo8kM+75EazzMVwUEXc/NZCHWa/Qp1EGa7zPdPT7IqSqNwnGH7k79nuvEtawQqk5Etc0MZVQgA+A+bSSjL0aWr0hpRnxqIrNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2701.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(6506007)(6512007)(53546011)(26005)(36756003)(83380400001)(2616005)(38100700002)(33656002)(86362001)(38070700005)(122000001)(186003)(54906003)(478600001)(2906002)(316002)(6916009)(4326008)(8676002)(8936002)(41300700001)(5660300002)(64756008)(66446008)(66556008)(66476007)(66946007)(76116006)(71200400001)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkR5M1o5cmczZ2QrYmloWjJ1azdxYVU4WGFkeFcyUDA0YlRxSE9XSEowdEJk?=
 =?utf-8?B?ZEpOVzltU2x1cGx1dFdaam1CeHl0VDJoRExNUS94LzZVdFlWRmx6ME9lTXo1?=
 =?utf-8?B?WHJ4M1l1OXdFUWJTWHl2Q1JacG54c3U3cmc3ckQ4NkZaUmdrZGZhTlhINmpR?=
 =?utf-8?B?N2Y3cTZ6ZmFKOHFLWTdBUEVYYnR4YzkrNnFiRmVPWkc1VzRhVWhGNk9RT2tt?=
 =?utf-8?B?MXJiQ1NzZVREeTZzN1RSdHZEMUVYb0NhWUhJWi9tUnVYR01Ca2c3NGFBY2pp?=
 =?utf-8?B?MFpXaVVLK1ZRVFJwcEd5Vnk0cmI4bGN6MnhDaHppdmU1bEpNTjB6bTJxK0Ev?=
 =?utf-8?B?eDVscUkxVTZ5SXR3ODQxQkFLN2c5dTZpdzhCQ1hKaGtWd2NmVk1KNkRYRWV6?=
 =?utf-8?B?U3phbktnd2VSdWtJRi9RZldqUHU4MmZVbDlCTVprV0dUNEZzWG1HK0hNL042?=
 =?utf-8?B?eWRvYmpnYTV6N2gvZWthUFpZTDlYcDNZcXd5Mk1SNVBWckN3cmVNbFZKM09Q?=
 =?utf-8?B?Z2dGQ3pDWEdzYTQ3VG03RWZIdWh6bnVDRWg1dmpyamVLRXgwMnJMdWtqNmZ5?=
 =?utf-8?B?WnZiOHNGcXhHazBJSTd4MzNKOUVWUEpuL2x0b1JSS2tGRG9lK2t0SHNPcVR3?=
 =?utf-8?B?eVp4RkovVVFMVk1tQXNaTVNjNWV1L211dk5KTzlTeVEvZnhVR3k1VWZIYVlw?=
 =?utf-8?B?L1UzOVQydFJ2QmkvTTVyOVRDUkFxcmo2dm90c0h2OC8xSHh1cUFkZ3lodFRw?=
 =?utf-8?B?Y3MyQW45RjBRL1RZdUdhNnhJZkkwRTdZOWRIZXM1UXpadUk1MkVOZ3Z0TDB2?=
 =?utf-8?B?MlJjaHFhdk80NnlUTmp1WlpLaFZiejNaUlNUSW1qZnFINVhDcEdqN2xTUmNT?=
 =?utf-8?B?NElxZ0lacmY0OVVOSy94YTg5bENhRXByR3lRRTV4S3p4d3lsWXBCZVRkRFEr?=
 =?utf-8?B?OVBOR2QzS3VBUC9iQi8rS2tGYTFQNmhTOU9jV2djRncrSklmR3pYdlVkRjd2?=
 =?utf-8?B?USt1RjNQT3J2V3RUelQ1eWNoTFZnK25LdHgreTBVS1FuVGVwMGJkZ2NLZHVm?=
 =?utf-8?B?cmNHN2o1NjI5M1YzYWNYUklmS3pqNzRKbFQvai82Y2FOM0szTGV1ak4xZGk2?=
 =?utf-8?B?VTQvczd4VEc2dWxVenNiNGorTFVSSk8yczhkUTRmSnZmUHp3NVRsZWZjZGJ2?=
 =?utf-8?B?d0FpYyt6TWM5Q0pRWlhRS1c2WjZMMTlEUUo3L2dvRDhJMDA2UzFZQlphekRy?=
 =?utf-8?B?Wk0vS2RKOGtERG5LT1l3SWRoRkNoNzJrQU5Oand1NW5JTXExZE1pWC9udjJN?=
 =?utf-8?B?VFhkZEllaU9aOUJlMmFadllubGxuRWVwTy9EMy9rSFExTkFVenJybHpNam5j?=
 =?utf-8?B?eFY4VG5XdkRCTi9ldzJXL1k1NHlFbDZKSUdGUm1ZSzRwZFROdU53VzNKQjFM?=
 =?utf-8?B?cllFS0VQeHV1ZjhSOUFaMmxxNTk2Lzdwd01HYWxObHhVTlB1aWo3TmNDNEh1?=
 =?utf-8?B?R3d2TG1ndVY3UVZxdUNoZ3ZKUWIxQWJIOEI2c1huaUxnb3RXWktsWXN4YUpH?=
 =?utf-8?B?dTd6Rzd3ZTRBTzd5Zk1zZVpIU0lpOTVlb0RmQ2hPZkY1aGIySTBuSlIwZTZp?=
 =?utf-8?B?LzBhNFIraTNQY25QcW1JcU94dzZ2cW5hVExDNC9oQ0h5MWpiU3NrZzZGYU9a?=
 =?utf-8?B?NkNhUFVkQXpvYTFGdERJYktzL0FhQnlJTExTM1htNmxvL0R6M3N3YU4vNzNr?=
 =?utf-8?B?Y1Z5eVcycDJpS2tDWkdWNFBReHRKSEg4YWVaQ2lhTnZIQ0NucTNVcnNNc3Bh?=
 =?utf-8?B?QXU0NHp1Sm1IKzZCZFFCTmhZY25nS3U4aEpPYlM4cVFML1ZRb1N6ZVN2bTB1?=
 =?utf-8?B?WWhwdjZETmVXTHhkMERzdjJiSnRPZ1QyamZSYUt2WW9FbGQweUx2RFc0NzhD?=
 =?utf-8?B?Q1hiZjNHQnJTc2p0ZFhrMlBKV05XQ0RHVGJMZE95MndLKzJLVjB3RWR4SFZD?=
 =?utf-8?B?c2ZQU2pna3JXaHJsL29sWENXSDlQNExUcExGRlVuajNYOW9wYmo4Y3Vibm42?=
 =?utf-8?B?Z3MranVxUlRYeUorN1FrZm8vZk40Z21BcHg5aU5oSitWNG83VnRpQldqWGhn?=
 =?utf-8?B?c3h4aTkwVnJmK1J1aDJ1aWQrSEFkZTE1eWZHZWJFZ08rM0NaNThXZjAxWU5z?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8273E3D7BC1D6042AD99EEDE5DCFC185@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ex5iZaFk5zJWovZ8iw+00la8ijBBHz5fh+5nHUUGUi3lGUNnyNLtGdgy0Vzr6OFkhX63wRugahpGinvVybNpl7A6yTDQUpt+AusXAyo0ggVAjPLU8S3nFuaWfxiPOSXcRBHv0+G0ufhht6PMXbEHgblzW7nDFAmvqlx0j7f26SFfDvSg9vP7F/IPkDabR6g7Fk2MI+CuU5w37eQaoQywWLjgbkdwLiRYM8h4E7CdVYEwoSqJc/7OJKYsGho41aE/SDbKW2aSLTsEp+jLaqnHfTn4SXVYAStO778XtbQ+wYiEA0Gs8aXFvKDqLPO3xlgtyZDnH83/kMz6JsF7v8DF1YL5DFcGOBQjge44ZBP2B05a3rK/20iyDzxTQKJ5tgyhS6Ds18wh0BKdKnnRpK8w+x7esfhVpqcmzeuq7hbq/AguJkq9Y8Ov0jMo9AKufiKm2Q/Rg5TmRb6RSasqdl0HOoXq6pKpnqIeiLWj602usVM8tk1GnwrOPuio1C0HJ7BjV7wTlkdMrx8xS/4rNF3g3I8qY49bLd16SnBTFLfocb7FGcxZowxnp0rR3mKjuztb39pbzVAfWYzJRklyxay/bE1d6UmywUGwyTAVEiF0Jgpwtzj92IFnDWR03psnIujWmJnXjsLm7JyfUsMJN0VZVhr1k9nUOZ/rv0px5tSvWmsBfWvNrd2MjusDk+BU/QOgp8WCMNQawWtQJmmvtEMiImMsq/3uco2gOLVaMtnXyTvHXT5DMjgbDqZ64S93+XDBlzEYFCITQ9SmBnq4Q7zgduqKiQof5EUZjHHcb1jCusKGqKNvr890ltkRS2aQq3TgFojv7ULSaUG5J1KG2RziKw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d4bece-c252-4d03-6ca4-08db573eb8b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 01:25:10.0692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmu1UtMZURcNaBEaFfzZcc6q6MmHtFGOL8EBrDJc1O3cORn/eOLVAoQUoy4qHMB8/LqgWZGjSEulU/LYDKRUgOqqAPiQGgsD8eTa/8DFBzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_05,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305180007
X-Proofpoint-GUID: NaRToLlph5oG-FVedIp-AFkr-w0ZYvOO
X-Proofpoint-ORIG-GUID: NaRToLlph5oG-FVedIp-AFkr-w0ZYvOO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

DQoNCj4gT24gTWF5IDE3LCAyMDIzLCBhdCA2OjAxIFBNLCBEYXZlIENoaW5uZXIgPGRhdmlkQGZy
b21vcmJpdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBNYXkgMTgsIDIwMjMgYXQgMTI6MTA6
NTNBTSArMDAwMCwgV2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBNYXkgMTcs
IDIwMjMsIGF0IDM6NDkgUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3Jv
dGU6DQo+Pj4gDQo+Pj4gT24gV2VkLCBNYXkgMTcsIDIwMjMgYXQgMDc6MTQ6MzJQTSArMDAwMCwg
V2VuZ2FuZyBXYW5nIHdyb3RlOg0KPj4+Pj4gT24gTWF5IDE2LCAyMDIzLCBhdCA2OjQwIFBNLCBE
YXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+IHdyb3RlOg0KPj4+Pj4gT24gVHVlLCBN
YXkgMTYsIDIwMjMgYXQgMDU6NTk6MTNQTSAtMDcwMCwgRGFycmljayBKLiBXb25nIHdyb3RlOg0K
Pj4+Pj4gSSB3YXMgdGhpbmtpbmcgdGhpcyBjb2RlIGNoYW5nZXMgdG86DQo+Pj4+PiANCj4+Pj4+
IGZsYWdzIHw9IFhGU19BTExPQ19GTEFHX1RSWV9GTFVTSDsNCj4+Pj4+IC4uLi4NCj4+Pj4+IDxh
dHRlbXB0IGFsbG9jYXRpb24+DQo+Pj4+PiAuLi4uDQo+Pj4+PiBpZiAoYnVzeSkgew0KPj4+Pj4g
eGZzX2J0cmVlX2RlbF9jdXJzb3IoY250X2N1ciwgWEZTX0JUUkVFX05PRVJST1IpOw0KPj4+Pj4g
dHJhY2VfeGZzX2FsbG9jX3NpemVfYnVzeShhcmdzKTsNCj4+Pj4+IGVycm9yID0geGZzX2V4dGVu
dF9idXN5X2ZsdXNoKGFyZ3MtPnRwLCBhcmdzLT5wYWcsDQo+Pj4+PiBidXN5X2dlbiwgZmxhZ3Mp
Ow0KPj4+Pj4gaWYgKCFlcnJvcikgew0KPj4+Pj4gZmxhZ3MgJj0gflhGU19BTExPQ19GTEFHX1RS
WV9GTFVTSDsNCj4+Pj4gDQo+Pj4+IFdoYXTigJlzIHRoZSBiZW5lZml0cyB0byB1c2UgWEZTX0FM
TE9DX0ZMQUdfVFJZX0ZMVVNIPw0KPj4+PiBJZiBubyBjaGFuZ2UgaGFwcGVuZWQgdG8gcGFnYl9n
ZW4sIHdlIHdvdWxkIGdldCBub3RoaW5nIGdvb2QgaW4gdGhlIHJldHJ5DQo+Pj4+IGJ1dCB3YXN0
ZSBjeWNsZXMuIE9yIEkgbWlzc2VkIHNvbWV0aGluZz8NCj4+PiANCj4+PiBZb3UgbWlzc2VkIHNv
bWV0aGluZzogdGhlIHN5bmNocm9ub3VzIGxvZyBmb3JjZSBpcyBhbHdheXMgZG9uZS4NCj4+PiAN
Cj4+IA0KPj4gSXTigJlzIHRydWUgdGhhdCBzeW5jaHJvbm91cyBsb2cgZm9yY2UgaXMgZG9uZS4N
Cj4+IA0KPj4+IFRoZSBsb2cgZm9yY2UgaXMgd2hhdCBhbGxvd3MgYnVzeSBleHRlbnRzIHRvIGJl
IHJlc29sdmVkIC0gYnVzeQ0KPj4+IGV4dGVudHMgaGF2ZSB0byBiZSBjb21taXR0ZWQgdG8gc3Rh
YmxlIHN0b3JhZ2UgYmVmb3JlIHRoZXkgY2FuIGJlDQo+Pj4gcmVtb3ZlZCBmcm9tIHRoZSBidXN5
IGV4dGVudCB0cmVlLg0KPj4gDQo+PiBZZXAuDQo+PiANCj4+PiANCj4+PiBJZiBvbmxpbmUgZGlz
Y2FyZHMgYXJlIG5vdCBlbmFibGVkLCBidXN5IGV4dGVudHMgYXJlIHJlc29sdmVkDQo+Pj4gZGly
ZWN0bHkgaW4gam91cm5hbCBJTyBjb21wbGV0aW9uIC0gdGhlIGxvZyBmb3JjZSB3YWl0cyBmb3Ig
dGhpcyB0bw0KPj4+IG9jY3VyLiBJbiB0aGlzIGNhc2UsIHBhZy0+cGFnYl9nZW4gd2lsbCBoYXZl
IGFscmVhZHkgaW5jcmVtZW50ZWQgdG8NCj4+PiBpbmRpY2F0ZSBwcm9ncmVzcyBoYXMgYmVlbiBt
YWRlLCBhbmQgd2Ugc2hvdWxkIG5ldmVyIHdhaXQgaW4gdGhlDQo+Pj4gbG9vcCBhZnRlciB0aGUg
bG9nIGZvcmNlLiBUaGUgb25seSB0aW1lIHdlIGRvIHRoYXQgaXMgd2hlbiB0aGUNCj4+PiBjdXJy
ZW50IHRyYW5zYWN0aW9uIGhvbGRzIGJ1c3kgZXh0ZW50cyBpdHNlbGYsIGFuZCBoZW5jZSBpZiB0
aGUNCj4+PiBjdXJyZW50IHR4IGhvbGRzIGJ1c3kgZXh0ZW50cyB3ZSBzaG91bGQgbm90IHdhaXQg
YmV5b25kIHRoZSBsb2cNCj4+PiBmb3JjZS4uLi4NCj4+IA0KPj4gU28geW91IGFyZSB0YWxraW5n
IGFib3V0IHRoZSBjYXNlIG9mIOKAnHBhZ2JfZ2VuIHdpbGwgaGF2ZSBhbHJlYWR5IGluY3JlbWVu
dGVk4oCdLA0KPj4gSW4gdGhpcyBjYXNlIHlvdXIgbmV4dCB0d28gbGluZXM6DQo+PiANCj4+ICBp
ZiAoYnVzeV9nZW4gIT0gUkVBRF9PTkNFKHBhZy0+cGFnYl9nZW4pKQ0KPj4gcmV0dXJuIDA7DQo+
PiANCj4+IHdvdWxkIGNhcHR1cmUgdGhhdCBhbmQgcmV0dXJuIGltbWVkaWF0ZWx5IHdpdGhvdXQg
d2FpdGluZy4gU28gVFJZX0ZMVVNIIGlzIG5vdA0KPj4gaGVscGZ1bCBpbiB0aGlzIGNhc2UuIA0K
PiANCj4gRXhjZXB0IHdoZW4gcGFnLT5wYWdiX2dlbiBkb2Vzbid0IGNoYW5nZS4gSWYgaXQgaGFz
bid0IGNoYW5nZWQsIHRoZW4NCj4gd2UnZCBpbW1lZGlhdGVseSByZXR1cm4gLUVBR0FJTiB3aXRo
b3V0IHRyeWluZyBhZ2Fpbi4gVGhhdCBpcyBub3QNCj4gd2hhdCB0aGUgYmVoYXZpb3VyIHdlIHdh
bnQ7IHdlIHdhbnQgdGhlIGFsbG9jYXRpb24gdG8gYWx3YXlzIHRyeQ0KPiBhZ2FpbiBhdCBsZWFz
dCBvbmNlIGFmdGVyIGEgZmx1c2ggaGFzIGJlZW4gcnVuLCBiZWNhdXNlIC4uLi4NCj4gDQo+Pj4g
SWYgb25saW5lIGRpc2NhcmRzIGFyZSBlbmFibGVkLCB0aGVuIHRoZXknbGwgYmUgc2NoZWR1bGVk
IGJ5IGpvdXJuYWwNCj4+PiBJTyBjb21wbGV0aW9uLiBpLmUuIHdhaXRpbmcgb24gdGhlIGxvZyBm
b3JjZSBndWFybnRlZXMgcGVuZGluZw0KPj4+IGRpc2NhcmRzIGhhdmUgYmVlbiBzY2hlZHVsZWQg
YW5kIHRoZXknbGwgc3RhcnQgY29tcGxldGluZyBzb29uIGFmdGVyDQo+Pj4gdGhlIGxvZyBmb3Jj
ZSByZXR1cm5zLiBXaGVuIHRoZXkgY29tcGxldGUgdGhleSdsbCBzdGFydCBpbmNyZW1lbnRpbmcN
Cj4+PiBwYWctPnBhZ2JfZ2VuLiBUaGlzIGlzIHRoZSBjYXNlIHRoZSBwYWctPnBhZ2JfZ2VuIHdh
aXQgbG9vcCBleGlzdHMNCj4+PiBmb3IgLSBpdCB3YWl0cyBmb3IgYSBkaXNjYXJkIHRvIGNvbXBs
ZXRlIGFuZCByZXNvbHZlIHRoZSBidXN5IGV4dGVudA0KPj4+IGluIGl0J3MgSU8gY29tcGVsdGlv
biByb3V0aW5lLiBBdCB3aGljaCBwb2ludCB0aGUgYWxsb2NhdGlvbiBhdHRlbXB0DQo+Pj4gY2Fu
IHJlc3RhcnQuDQo+PiANCj4+IEluIGFib3ZlIGNhc2UsIHlvdSBhcmUgdGFsa2luZyBhYm91dCB0
aGUgY2FzZSB0aGF0IHBhZy0+cGFnYl9nZW4gd2lsbCBiZQ0KPj4gaW5jcmVtZW50ZWQgc29vbiB3
aXRob3V0IGFueSBibG9ja2luZy4NCj4+IEluIHRoaXMgY2FzZSwgaW4gdGhlIGFsbG9jYXRvciBw
YXRoLCBzdGlsbCB0aGUgdHdvIGxpbmVzOg0KPj4gIGlmIChidXN5X2dlbiAhPSBSRUFEX09OQ0Uo
cGFnLT5wYWdiX2dlbikpDQo+PiByZXR1cm4gMDsNCj4+IA0KPj4gVGhlIGNvbmRpdGlvbiBvZiAi
YnVzeV9nZW4gIT0gUkVBRF9PTkNFKHBhZy0+cGFnYl9nZW4p4oCdIGNhbiBiZSB0cnVlDQo+PiBv
ciBhIGZhbHNlIGFjY29yZGluZyB0byB0aGUgcmFjZSBvZiB0aGlzIHByb2Nlc3MgVlMgdGhlIHF1
ZXVlIHdvcmtlcnMgKHdoaWNoDQo+PiBzdGFydCBjb21wbGV0aW5nKS4gIEluIGNhc2UgaXTigJlz
IHRydWUsIHRoZSBjb2RlIHJldHVybiBpbW1lZGlhdGVseS4gT3RoZXJ3aXNlDQo+PiB0aGUgY29k
ZSBydW5zIGludG8gdGhlIGxvb3Agd2FpdGluZyBhYm92ZSBjb25kaXRpb24gYmVjb21lIHRydWUu
IFdoZW4NCj4+IHRoZSBxdWV1ZSB3b3JrZXJzIGluY3JlbWVudGVkIHBhZy0+cGFnYl9nZW4sIHRo
ZSBhbGxvY2F0b3IgcGF0aCBqdW1wcw0KPj4gb3V0IHRoZSBsb29wIGFuZCBnbyDigJQgdGhhdOKA
mXMgcGVyZmVjdC4gSSBkb24ndCBzZWUgd2h5IFRSWV9GTFVTSCBpcyBuZWVkZWQuDQo+IA0KPiAu
Li4uIHdlIHNhbXBsZSBwYWctPnBhZ2JfZ2VuIHBhcnQgd2F5IHRocm91Z2ggdGhlIGV4dGVudCBz
ZWFyY2ggYW5kDQo+IHdlIG1pZ2h0IHNhbXBsZSBpdCBtdWx0aXBsZSB0aW1lcyBpZiB3ZSBlbmNv
dW50ZXIgbXVsdGlwbGUgYnVzeQ0KPiBleHRlbnRzLiAgVGhlIHdheSB0aGUgY3Vyc29yIGN1cnJl
bnRseSB3b3JrcyBpcyB0aGF0IGl0IHN0b3JlcyB0aGUNCj4gbGFzdCBidXN5IGdlbiByZXR1cm5l
ZC4gVGhlIHBhZy0+cGFnYl9nZW4gdmFsdWUgbWlnaHQgY2hhbmdlIGJldHdlZW4NCj4gdGhlIGZp
cnN0IGJ1c3kgZXh0ZW50IHdlIGVuY291bnRlciBhbmQgdGhlIGxhc3QgdGhhdCB3ZSBlbmNvdW50
ZXIgaW4NCj4gdGhlIHNlYXJjaC4gSWYgdGhpcyBoYXBwZW5zLCBpdCBpbXBsaWVzIHRoYXQgc29t
ZSBidXN5IGV4dGVudHMgaGF2ZQ0KPiByZXNvbHZlZCB3aGlsZSB3ZSBoYXZlIGJlZW4gc2VhcmNo
aW5nLg0KPiANCj4gSW4gdGhhdCBjYXNlLCB3ZSBjYW4gZW50ZXIgdGhlIGZsdXNoIHdpdGggYnVz
eV9nZW4gPSBwYWctPnBhZ2JfZ2VuLA0KPiBidXQgdGhhdCBkb2Vzbid0IG1lYW4gbm8gYnVzeSBl
eHRlbnRzIGhhdmUgYmVlbiByZXNvbHZlZCBzaW5jZSB3ZQ0KPiBzdGFydGVkIHRoZSBhbGxvY2F0
aW9uIHNlYXJjaC4gSGVuY2UgdGhlIGZsdXNoIGl0c2VsZiBtYXkgbm90DQo+IHJlc29sdmUgYW55
IG5ldyBidXN5IGV4dGVudHMsIGJ1dCB3ZSBzdGlsbCBtYXkgaGF2ZSBvdGhlciBidXN5DQo+IGV4
dGVudHMgdGhhdCB3ZXJlIHJlc29sdmVkIHdoaWxlIHdlIHdlcmUgc2Nhbm5pbmcgdGhlIHRyZWUu
DQo+IA0KDQpZZXAsIHRoZXJlIGNvdWxkIGJlIHN1Y2ggc2l0dWF0aW9ucyB0aG91Z2ggZG9u4oCZ
dCBrbm93IGZyZXF1ZW50bHkgdGhhdCBoYXBwZW5zLg0KDQo+IFllcywgd2UgY291bGQgY2hhbmdl
IHRoZSB3YXkgd2UgdHJhY2sgdGhlIGJ1c3kgZ2VuIGluIHRoZSBjdXJzb3IsDQo+IGJ1dCB0aGF0
IGxpa2VseSBoYXMgb3RoZXIgc3VidGxlIGltcGFjdHMuIGUuZy4gd2Ugbm93IGhhdmUgdG8NCj4g
Y29uc2lkZXIgdGhlIGZhY3Qgd2UgbWF5IG5ldmVyIGdldCBhIHdha2V1cCBiZWNhdXNlIGFsbCBi
dXN5IGV4dGVudHMNCj4gaW4gZmxpZ2h0IGhhdmUgYWxyZWFkeSBiZWVuIHJlc29sdmVkIGJlZm9y
ZSB3ZSBnbyB0byBzbGVlcC4NCg0KSG0uLiB5ZXAsIHRoaXMgY291bGQgYmUgYSBmdXR1cmUgZW5o
YW5jZW1lbnQuIA0KDQo+IA0KPiBJdCBpcyBzaW1wbGVyIHRvIGFsd2F5cyByZXRyeSB0aGUgYWxs
b2NhdGlvbiBhZnRlciBhIG1pbmltYWwgZmx1c2gNCj4gdG8gY2FwdHVyZSBidXN5IGV4dGVudHMg
dGhhdCB3ZXJlIHJlc29sdmVkIHdoaWxlIHdlIHdlcmUgc2Nhbm5pbmcNCj4gdGhlIHRyZWUuIFRo
aXMgaXMgYSBzbG93IHBhdGggLSB3ZSBkb24ndCBjYXJlIGlmIHdlIGJ1cm4gZXh0cmEgQ1BVDQo+
IG9uIGEgcmV0cnkgdGhhdCBtYWtlcyBubyBwcm9ncmVzcyBiZWNhdXNlIHRoaXMgY29uZGl0aW9u
IGlzIG9ubHkNCj4gbGlrZWx5IHRvIG9jY3VyIHdoZW4gd2UgYXJlIHRyeWluZyB0byBkbyBhbGxv
Y2F0aW9uIG9yIGZyZWVpbmcNCj4gZXh0ZW50cyB2ZXJ5IG5lYXIgRU5PU1BDLg0KDQpBZ3JlZWQu
DQoNCj4gDQo+IFRoZSB0cnktZmx1c2ggZ2l2ZXMgdXMgYSBtZWNoYW5pc20gdGhhdCBhbHdheXMg
ZG9lcyBhIG1pbmltdW0gZmx1c2gNCj4gZmlyc3QgYmVmb3JlIGEgcmV0cnkuIElmIHRoYXQgcmV0
cnkgZmFpbHMsIHRoZW4gd2UgYmxvY2ssIGZhaWwgb3INCj4gcmV0cnkgYmFzZWQgb24gd2hldGhl
ciBwcm9ncmVzcyBoYXMgYmVlbiBtYWRlLiBCdXQgd2UgYWx3YXlzIHdhbnQNCj4gdGhhdCBpbml0
aWFsIHJldHJ5IGJlZm9yZSB3ZSBibG9jaywgZmFpbCBvciByZXRyeS4uLg0KPiANCg0KT0suDQoN
Cj4+IFNvIGNoYW5nZSB0aGUgbGluZSBvZg0KPj4gDQo+PiBmbGFncyB8PSBYRlNfQUxMT0NfRkxB
R19UUllfRkxVU0g7DQo+PiANCj4+IHRvDQo+PiANCj4+IGlmICh4ZnNfaGFzX2Rpc2NhcmQobXAp
KQ0KPj4gICAgZmxhZ3MgfD0gWEZTX0FMTE9DX0ZMQUdfVFJZX0ZMVVNIOw0KPj4gDQo+PiBTb3Vu
ZHMgZ29vZD8NCj4gDQo+IE5vLiBUaGUgYWxsb2NhdG9yIGl0c2VsZiBzaG91bGQga25vdyBub3Ro
aW5nIGFib3V0IHdoZW4gZGlzY2FyZHMgYXJlDQo+IGVuYWJsZWQgLSB0aGUgd2hvbGUgcG9pbnQg
b2YgdGhlIGJ1c3kgZXh0ZW50IGluZnJhc3RydWN0dXJlIGhhbmRsaW5nDQo+IGRpc2NhcmRzIGlz
IHRvIGFic3RyYWN0IGRpc2NhcmQgZGVsYXlzIGF3YXkgZnJvbSB0aGUgYWxsb2NhdG9yDQo+IGl0
c2VsZi4gVGhlIGFsbG9jYXRvciBvbmx5IGNhcmVzIGlmIHRoZSBleHRlbnQgaXMgYnVzeSBvciBu
b3QsIGl0DQo+IGRvZXNuJ3QgY2FyZSB3aHkgdGhlIGV4dGVudCBpcyBidXN5LiBBbmQsIGFzIHBl
ciBhYm92ZSwgdGhlDQo+IFRSWV9GTFVTSCB0cmlnZ2VyZWQgcmV0cnkgaXMgbmVlZGVkIHJlZ2Fy
ZGxlc3Mgb2YgZGlzY2FyZHMgYmVjYXVzZQ0KPiBidXN5IGV4dGVudHMgY2FuIHJlc29sdmUgd2hp
bGUgYSBzZWFyY2ggaXMgaW4gcHJvZ3Jlc3MgaW5zdGVhZCBvZg0KPiBiZWluZyByZXNvbHZlZCBi
eSB0aGUgbG9nIGZvcmNlLi4uDQoNCk9LLCB3aWxsIGJlIHdpdGggVFJZX0ZMVVNILg0KDQp0aGFu
a3MsDQp3ZW5nYW5nDQoNCg0K
