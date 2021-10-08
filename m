Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4D0C43219
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 19:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C228660FF2
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 19:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhJHTIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Oct 2021 15:08:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49602 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231459AbhJHTIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Oct 2021 15:08:48 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198IZET7015902;
        Fri, 8 Oct 2021 19:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eJhVvWBM9+zUile/jhNawcJy+Igihb97mGWxPPMrHcQ=;
 b=LxXuhmNSFKJjdMRgnD6iml/pjOVVVNAIGvIdLHtDC0Q4Plz84yjYPn5tGHqsJwN97NUD
 GDqAz2Os3h4AW81f1SCX4G6IfS0azCNhLKMNX0ssdwFUCX3tKfPUEkay4Wsu4CM22gBN
 G1lHh/1mMt/nLouxfhoa5RJ4GJIExoEdwpj07i365aKYZGn+D+LV9FiQys9+Qp/Ni4hX
 fakqIekd2m1GEiJV8YFmicNneRb+zd3b6MfJmZ7+wUnfKIDMPQHNLIm1QrzCZmMjLwiO
 SEjp4ACP5fsvyiPNZ/OvNqjwFf6d9S5rzUy5fojHUnHErbc8ON+dpS7zQ7nH5K6TkgSI 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bjr7t9j20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 19:06:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 198J4rdH175878;
        Fri, 8 Oct 2021 19:06:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3bf0sc7pyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Oct 2021 19:06:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2jMba26DUn7fJfjVG4apamfICUdshQ6QLWat/zodD6uG8UYua4SLPArfyG7Tc1TQ6OJJQwOCAq7gaE1Jaka4psuKLG5xUnNdQ0D2Lc+oY9mcL2ty5NmwVY47MYFFm10nPdnEHWbtHSAx6XBNQt9lWonw2eDedALS0i3tw+ydrAKfhZsYfoN41mywZANhHaHcnzWpSlw6SUXK7o7JNUpTivf5OxrGjYx7PrrR/FcZ0O+r2Hpw15Pi4zW44k/bx/RlYMJjQL3UhQeAQHWc0yFBKUwUzAixCkA3hFkmc9khtWOg72wkrMu+3USjQSLZkejM1pJfKEMm6knaVzLJ3bNQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJhVvWBM9+zUile/jhNawcJy+Igihb97mGWxPPMrHcQ=;
 b=Oa4H1+my7i5cEoyFXnOJo4E7gFwPKZZs8tNMuAl06GgYUi6+VLQWraZ0B06ZIzODReVDRGiWHKm6f6bjhl3cpOkaAm7W+qn79VC6QdPDmi7t0lphieUmIKD6usG60iTtSXrbetTq3Eh9ugcOcLHMbpFoEUYrQlLAjjQZBtwc6j+a1ZRSxPFp8Kx4iIGNHfGkjm6+axpRCSkgTDrB4JMJpJIvRIdfUBGB1obe8qFwOA9UliDK/PVFA9+ivIQMqB5CtvpHeTH3InfX/PeF0/NLt0dTQKNThL2KfpEa0ku6kbYR0qm4okA32xKfuz0iIj3aPL1fuyoSLp/yGtzNIpj/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJhVvWBM9+zUile/jhNawcJy+Igihb97mGWxPPMrHcQ=;
 b=UYkunlMf4bRhgCPP/byVPRkvtrfUTadQifd3J/+FioukInz/emmte1RDS4jpmTj4vp2+tzCxRPNT2D1ngec2zbK4y3/KfZc45NrfIFfAX15A/DJJA4lso4gCzzHv7PpTBnU6xHwtWrEk3oqCWWbMdFz0UYB2MlBwkAR5AxirtIg=
Received: from BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16)
 by BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 19:06:37 +0000
Received: from BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::8c13:27a8:24bb:723a]) by BYAPR10MB2791.namprd10.prod.outlook.com
 ([fe80::8c13:27a8:24bb:723a%7]) with mapi id 15.20.4587.020; Fri, 8 Oct 2021
 19:06:37 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] common/log: Fix *_dump_log routines for ext4
Thread-Topic: [PATCH v2 4/4] common/log: Fix *_dump_log routines for ext4
Thread-Index: AQHXuxIEIzzvwvY7tUGHhMFYp0RKF6vJY4OAgAAVkwA=
Date:   Fri, 8 Oct 2021 19:06:37 +0000
Message-ID: <AAD602F3-9A9B-494C-A0FE-8BF521271268@oracle.com>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
 <20211007002641.714906-5-catherine.hoang@oracle.com>
 <9046a560-e064-b009-6867-b9e65d7296c7@oracle.com>
In-Reply-To: <9046a560-e064-b009-6867-b9e65d7296c7@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abffe697-46ba-4435-47b3-08d98a8ec0c4
x-ms-traffictypediagnostic: BY5PR10MB3828:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR10MB382820ED9DFB8DFBFFCCB70589B29@BY5PR10MB3828.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lxj9YOFc5tQ+MnV1dj5q95lB1qXx5vggP4ci4F7wnQA0v4zg6HFl/sUQWfeEepDKJzJL6zzG2cwcqovhKw+dLbzSGSLGW+px/rrfxW9uF8B1WpzYi/oAxEbUK0j5YMtc3BKyxv4YpJdFkyGkjj7owpnUV5JrdVr0lLbM3nU830+P5ZlrELef1xad9+tmUre4Qy1X3cSNhuPusDQRkcG24WCAsj8Jy859URme8QBhltQIq61QXf37v8KEFiGG95YlBncCEgBQWHxQf75mBrY6hCgMn7vW2e6mv31iYAt5iGC/6i41f2g8V7mbG8FsknU/QCsjNHbOU42pNWD8G5I8VGEr8kE4Wi0zbQf3LsQSaeai61KtB6zPbj63EDQ/8Gw+P1ssLbGIx2kv6lGMA4CCgrn5RDYEn+Dg0eQ7hSQrp7nwqaL+O7KXWtJ2/W2eVvT/NdorayzjAgHCygABQYrXEA2/X9iGK4/T8swTncOVN4R1s5BmWgK1JIwrkSFaXngr8N4WufMYK7QhsFGTEHdNUjL9CldzgEhlO/fRVpOaaF6qTwRCKsHup+uKn5u62JQ3Aq8BDOkBGF098S+01j4m9ZGgrZqIgL0DvN9X2SuLVp4vPy4ICvigO9qnVtxdKTbeo56zUS/X5OOAFS11q7l1CE2VOdFrwHTfPi5GwK7lQs7XqITaJri9FvLUFnsSnGiBRCUPWl5V2iKupIec7TDhcftbcWp3N8OPAmnU9s5ZedA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2791.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6862004)(44832011)(83380400001)(86362001)(2906002)(36756003)(186003)(6486002)(6636002)(71200400001)(53546011)(6506007)(38070700005)(508600001)(54906003)(33656002)(5660300002)(37006003)(8676002)(316002)(6512007)(450100002)(38100700002)(8936002)(2616005)(122000001)(66476007)(66946007)(66556008)(66446008)(64756008)(76116006)(26005)(4326008)(4744005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eCLsMIv2OE0mnOIb8qKL7DeQf8zSr8bjqW4FnUEJG2T0iAMfdJjVbqrco5Z+?=
 =?us-ascii?Q?UDsP9coGp3dsrDkX28BqwzqidM9O2JG25lrD0PPnwxQR6Ap6CaWmhdWOmv5m?=
 =?us-ascii?Q?qEND3yHU9rR30CgxBt63ZcxTikpAhYLanzsZdM6waruHh/RtyaGfHSp+b/bv?=
 =?us-ascii?Q?86Z6tF5I7q4YftOIdBTIjOdB8ndRwNBCXjBxKkfUelE0DcJEIOsgDlq9Nxa8?=
 =?us-ascii?Q?+PVyrUnIdCCxZjzd7F4f7+xaROyxGyQPZvibMHAJC9QdEGLiN3rITToq4K81?=
 =?us-ascii?Q?ldHBvJOeu7466UAsRcTsmqQHaaGIZPVupE+HcnbzzqqVYg/Eb7MgBic5+Odp?=
 =?us-ascii?Q?FoMQfl5QKzTFHMvbpMU49NwOlSEy81KZvw2GCTRMrgn/9Ln4AI+tjU5YRmWo?=
 =?us-ascii?Q?FA8QEPJreRMHwMm1cZMEHZSBPcXRwuOajLUGAdfcOz0nlq03FNpMlgO9cHUU?=
 =?us-ascii?Q?nj84rnpBjQBMtjCW/p8YSr2g4+5F4rb8gESsQyajPc2ryN06vKDYxcfWlaVo?=
 =?us-ascii?Q?Nv/VvLRngM/EJTgP0KkyF78uBHDtKuW1YeNNxPLPw2XleetOoRPJL0Ys6dYm?=
 =?us-ascii?Q?XNaGMToumzH0IrnOVspK+z/0U+LTdCSUHC04YS2027UkW7hH+Eu+2DPDUZkJ?=
 =?us-ascii?Q?TsL6mDkgRNY+iwk4POLxhy7yXtO/M87g9F5aV3LlCbgvwiz7v8AXMc+/HrK6?=
 =?us-ascii?Q?j5XzTrHkJCDJbnpLLCxgO609FDqXzjk4HCosOXzYnmtO5PujPURWGmnHmOF3?=
 =?us-ascii?Q?toZhBrO6Na0k7ey1/OiFpMaUTA+rLACc7U2OFmFcurXb1s5dVKQDYcF7CUws?=
 =?us-ascii?Q?RWx+XIKx2oN8oCQccEXgzo+NPI/Trfdi7GX8zpXREDgsa6OG131z0CD2WtlZ?=
 =?us-ascii?Q?odL9wK+k21ssxi0Qz9JEbWrVOOrYiU/zoF/Lq8q6+iDMv2uo4Z50f99611xl?=
 =?us-ascii?Q?KqfpKjLEXj26yuYN/S5UYQS/uzaylaIDu9jqYw5XeyEJrYr/XrcC9qs9mztZ?=
 =?us-ascii?Q?ul4BTCVeky/rVD072K8xrWBQU+ZQ9UzUAxb7D6Bs6Qf3c84sNo1389QyDj6O?=
 =?us-ascii?Q?lVMxiSWDKotzJXZAUf2sE6NZvkiAVLvwlmS4W2b7zSbk3ATa22NDdEByFuUt?=
 =?us-ascii?Q?mb6kiIF1G0ovOT1oJ2JontELrvB6wH5dCkaNRkOIH51ZcCuUTuYd86HsCfHp?=
 =?us-ascii?Q?J8N0dXGWlI2HCMotHAIFpJXyV3hkcWEPbK0IZL4QNEcbS81SylkzpbA2hVwV?=
 =?us-ascii?Q?OiXMLceaJWOmg5RUbvmsMfBg1J5J2OeVqhG6g3qcaY+jEgIXHjs/i01BY4vq?=
 =?us-ascii?Q?QaFgtCiUZ5cClsApW3XpVIv5?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1ACA02692856EF4BA0C6D342F30B4CF6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2791.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abffe697-46ba-4435-47b3-08d98a8ec0c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 19:06:37.2654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iEUMxfs8nvnbilPqRUzMhC0QOAhfT3tcqJYw+cZkG4Tl0z8Do184ujhAJFpx5KigU6GF7cLj94e9ZTH3Pf45BIPFmcQQIAXHCneiizePeeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3828
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10131 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110080107
X-Proofpoint-ORIG-GUID: kZFkri4T9wp3WPniAeae8tmnRgGHAZq3
X-Proofpoint-GUID: kZFkri4T9wp3WPniAeae8tmnRgGHAZq3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Oct 8, 2021, at 10:49 AM, Allison Henderson <allison.henderson@oracle.=
com> wrote:
>=20
>=20
>=20
> On 10/6/21 5:26 PM, Catherine Hoang wrote:
>> dumpe2fs -h displays the superblock contents, not the journal contents.
>> Use the logdump utility to dump the contents of the journal.
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Looks good to me.  Thanks for the fix
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Thanks for the review!
Catherine
>=20
>> ---
>>  common/log | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/common/log b/common/log
>> index 0a9aaa7f..154f3959 100644
>> --- a/common/log
>> +++ b/common/log
>> @@ -229,7 +229,7 @@ _scratch_dump_log()
>>  		$DUMP_F2FS_PROG $SCRATCH_DEV
>>  		;;
>>  	ext4)
>> -		$DUMPE2FS_PROG -h $SCRATCH_DEV
>> +		$DEBUGFS_PROG -R "logdump -a" $SCRATCH_DEV
>>  		;;
>>  	*)
>>  		;;
>> @@ -246,7 +246,7 @@ _test_dump_log()
>>  		$DUMP_F2FS_PROG $TEST_DEV
>>  		;;
>>  	ext4)
>> -		$DUMPE2FS_PROG -h $TEST_DEV
>> +		$DEBUGFS_PROG -R "logdump -a" $TEST_DEV
>>  		;;
>>  	*)
>>  		;;

