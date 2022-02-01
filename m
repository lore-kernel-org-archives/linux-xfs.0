Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89078C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 22:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbiBAWJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 17:09:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:22594 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231178AbiBAWJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 17:09:58 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211KTRDR004739;
        Tue, 1 Feb 2022 22:09:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=a/IQwMnSaoOC/VelAKonQ1nea1U5yjwjwNNSTVuy7X0=;
 b=xH2BXMZuQePgy52SOo2pmxxf6kww0PjBwmOfnkAAvBggaUSNEVWQk4/DP/x8tiIdiNst
 jKfsgZCF2ozaA1BGP3mAzyLG9EmHEBDJiOzDfBRajPAt6h4vk8MLQF7sFIGr55UrTfb6
 GGVr/dN4rgtcWDNw4MzC6sRb8eOa3PJBWsFsl5sTv7qoWktrMz7oacWmUCXBPDEQaXy1
 gc4c6FINt/Nhinm8Sb/0QaiFlyHqZlIiwHiHzPQydBWueD5XR+PUIDxa3EV50BjRZvGQ
 c6CqS5Di/cD6/pp/mesjsiOlPpZPQWxZQFT0/8c6YwOYrTaFUPLR+OaBvjWEWSn/H7kz qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac4acx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 22:09:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211M7A3a116697;
        Tue, 1 Feb 2022 22:09:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3dvwd6ykj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 22:09:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKFkV+vLdhzMuZHu/HCEQr4ffgNg5PR5poh59fiH4kCHeONJLzJqrA01OjE5NCDL2CXKCI1MyBopwkvLwtm5radGw5ocuelmgFPl3UNfXCklThc2xPyCOBdBIjLIWbea1mn4MU0mu9e/oD5nbej/mylkWFtS4UhqpiKXw1oF3l20uwIaxNq4jxDNOQlzJEgAqBmXFbilh8lTmY6iLJcbgymGj8vw9DB4shz5LQvDT5CRZ0/g1L/9ny+CKWYov9LWNIrpv1T++sm4UkERCkAsPdEWlj8MffF7JWi8LxYzwseZGHBFWEum02AI0RDBC7tm/gfS9A4uT7SxMu38clkHYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/IQwMnSaoOC/VelAKonQ1nea1U5yjwjwNNSTVuy7X0=;
 b=IrDcoySgQRLe8diVxTauV6EBBLJaVS/v6btw4ZldhOeo27q1IYGngmQPspK0GDPjyIE3Vh6pUGHBAeDn5Qldqc/m82YhDbueACPofdbyeBsNrvRj8pkvZeFSSOQw5VjZ9+2qx0q0kUA0h9ZETcDn8gqQ/oE5CR6wrldczNAkD2xeZeHhWe18Ncemmekczoz88E0W+2b7rMlRy4SdDeAkENW8Yxi9j0uHAOt+PpOMLFJM0q5yTNhz7GCOubxzMd/9OAift7ho67OZeUvS5OZ26xDMTmQ+Wj2LMhhtSeGRtJ5g1hZuDduTkX9lHXRj4Oa7hHoUszG3Q7wE/NpR8gASbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/IQwMnSaoOC/VelAKonQ1nea1U5yjwjwNNSTVuy7X0=;
 b=XY0aWZk8M/DWvVFDVdwt4Y1sK0azIK5R2WYptv+oA3rvyWyk/ooxtKfHoMMZ8N19KpiHC5yxuNiGVmUstQfl888gmONitnjenMq+lH5I+BpT+h5uC8HG/xDQhxbqHvPEYlMeREjbBVTvqtiqD21rgsuBA6aYhQxvcrK60q6RNlA=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 BN0PR10MB5206.namprd10.prod.outlook.com (2603:10b6:408:127::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.11; Tue, 1 Feb 2022 22:09:51 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 22:09:50 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v6 1/1] xfstests: Add Log Attribute Replay test
Thread-Topic: [PATCH v6 1/1] xfstests: Add Log Attribute Replay test
Thread-Index: AQHYF7huNpBsrovp5Eq6HafpbW4QBw==
Date:   Tue, 1 Feb 2022 22:09:50 +0000
Message-ID: <127C86E0-011C-403D-8A7F-340BD6625D42@oracle.com>
References: <20220201170952.22443-1-catherine.hoang@oracle.com>
 <20220201170952.22443-2-catherine.hoang@oracle.com>
 <20220201201315.GQ8313@magnolia>
In-Reply-To: <20220201201315.GQ8313@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9db1aea0-69fe-417a-98f5-08d9e5cf915d
x-ms-traffictypediagnostic: BN0PR10MB5206:EE_
x-microsoft-antispam-prvs: <BN0PR10MB52064246BAA4DE284B688F6189269@BN0PR10MB5206.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6b38d8LgpWSFyBJx4u0R9VGjvbFvDL8YgMJE1wQSR9px4wHLoPovAtCjFlDP3RMTiEmF9ucgwqdjyiGUTlIIhqWs5pLAlVYDlRiKyApUSpwhxXbanAH1iajHutqCC33MBF96bMY/zKR2YQ+rtax0hMlZmbvDOjAIhKsPmhfgCoeaHJmWidZo1BTlm1ji3l146+Hb97GuWFRIkHQGFb+u1Wz4qUP8a+KxznTiUaVc+ZrI/8X0VOXOm27zUqzKAK4ItfxaFottkwF3SofdsCgbGho1S8ePndY10deFaHfJbC0B6EWH3zLOzWIa6sYa4muAepVXY36I8F74VrDyet/DAk2kfe0JaJJnT+s7ezBhUMbpC2KSufyeHkiox9F70JfB3C8ZQ42jxEAo1QWcMlJRXlx+uD81qmq08k/BBZqlVToPwAk01K0XGz/3ZjcSWavD84q6i9Ex/5ZacmmrDpUGtAoW/4m/bTodzSrKwG8l+N9Be0GwmiXYLWy1UGzgqNCHT8YAW59xJHD7ErnMNZ71GfCBvgpXs6C027ZtFMdLlAf7L4QtKmjyK8RlF42A2yqS5tGzVbIniSu+0WiRmoOgshLpeh8hG3HYY1tn6afGlS0OITy6QPdilFTIAs3NE9EuBPcSNbj4/H4bxKKEl8OiwAjTaDX2Z3VMvJz0YECxq7WDtFLvyTi89FTVE5ul2uJP/fZMdf5oZe7X1/EJz4LbAu88o+9xe6nkL9JYl/RWklLA+/Nv71orWh/wO+NSPzg1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66556008)(66446008)(66476007)(186003)(76116006)(8936002)(66946007)(86362001)(91956017)(8676002)(38070700005)(122000001)(64756008)(71200400001)(53546011)(6506007)(6486002)(508600001)(38100700002)(316002)(33656002)(6512007)(2616005)(6916009)(36756003)(5660300002)(83380400001)(44832011)(2906002)(30864003)(54906003)(45980500001)(357404004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SWLG45/608xu/4oT8+XUWB6KimWMJOQhFQ8k525iIwE9GvcoV23qKTHXT/wB?=
 =?us-ascii?Q?sJZblZE2J64RWWAlgXxaklDl3InoUFhMQjZoR+/vnYFGktwQ2mMh4k7QfSmK?=
 =?us-ascii?Q?JDb2+iGZfM0qmqyNcuKMdGWhq1UX21OFMDgw+KKQoVY6v82rxAwVjZtPIvM3?=
 =?us-ascii?Q?QhG3hgt9W4w/0YoKNufQXACBIMWfaRBHfLVspJY0fYqj21fSDfoUv5vBMe8V?=
 =?us-ascii?Q?eiifQvM4R1IsVRtG1/E6XuHaqse4JWluY64x1uCGvpihqP/15vV/k1S4jn9k?=
 =?us-ascii?Q?iw9DAgp9+J5exhCxdyUnNEol28ZTMALWXvg8SJ0bjVYpvy6a3nB4/q2l8a8T?=
 =?us-ascii?Q?50o2oK7lQPGrR3nmUvuQ2NNAxJzEW3F03UUnWsY8bJG1zr9xuFKiZCUPLzZK?=
 =?us-ascii?Q?HSJ/5IlBKjLUL77ZrVx7cKStpHHNQhQR8nfBcilyWQoRCXBUsF+iA4kpDFhk?=
 =?us-ascii?Q?GOfZAf06HgVSbVdQK0O2xq2eq8XGOCoSvZs4mkWm20Ttm3M/x34btA0z03Qi?=
 =?us-ascii?Q?T7baGuBamCXk7qtDcjsnX1RQzK0N+qe4Yr431p+/52pMgU5tyCd2ZtLeXCOG?=
 =?us-ascii?Q?IxqNwZumKPLbufMkkkkyQxX4XfFDYMPoLb0pmsDN6PdSl5A44rds1MUfJfFi?=
 =?us-ascii?Q?jKQH07pwtfDB3BWjgZzgulDGwRzbjs2QRAdI++6P+6Es/fnlyCBDfhyWBNl3?=
 =?us-ascii?Q?6VI+mLcwcaDfWKQjcf1GV3yVKcpgOsddU3O4BnazhI4bRPYUQAbWHgjYsWmx?=
 =?us-ascii?Q?Ds4JTDPwRmQSLVuAzxakNA+CqT07n2QuCQl1HnL+7wHcCs20xLe9SO46Y5sc?=
 =?us-ascii?Q?QWrj0pIdiPtZpgK9QyuAupLC2VvuZhTDi1jCHh944uxNYt8jQQx3wriD343c?=
 =?us-ascii?Q?jglyFfPbBTMFuTbAJ/eR0lSvUGpTXXp0b42XXTLpxALJRhqxphd8jGubOTvP?=
 =?us-ascii?Q?DQgpC7/nasu1nSXbu/c0fh7xt1eM4HEPDeE2COnGfhZnVsvLj4eHKwkNAgLJ?=
 =?us-ascii?Q?gNE5a9MVf4D18HkR/8MV4jZNPgoveccsGL6p3Km5/aIxuwreLS02e+2wo8fi?=
 =?us-ascii?Q?aV1kb230C9HEz6C4/x4et1cGenyOM2CE8BP3K3mmKxU9XrnHRn6kKOs8oo47?=
 =?us-ascii?Q?W6nNRiB8eCwRqBNFx1MGMuFIYOvnUdyI4TihOmmnXCkZxg8EQL44aG7/FLTr?=
 =?us-ascii?Q?FBqSEuD6+MaA93vwGdQk1f09FAD2B5FzULcKsUqVynCjV3sctV1kPb4NIgq0?=
 =?us-ascii?Q?k556aoROvkqsuFZ0nFtWPgGvmmVO5y4nwODHovCVuhOoNGZfgkEMgLuTNpUZ?=
 =?us-ascii?Q?Whg8sNmxO7EkLXATMBV422yjKzL4pyOLMUwpQzQYvW8FZ0jDYYXVfbD+HR4k?=
 =?us-ascii?Q?O5aeaMuOa3qP0w4G4DsQvb8+axkb3swEwyxBDzmEU+757X1hTkLw3WwNlxak?=
 =?us-ascii?Q?nCylviEfIqRvCubKvB3kkyhUGOn0NhZ7iz1v7Q3XQnnWNVzq46xcrIMF/bDD?=
 =?us-ascii?Q?08Rx12SuLoWzxqqrGfnELIObqBjkmSkdhAUfPogn6j3QHAQfSmhg2aHODnBT?=
 =?us-ascii?Q?FCqtWExxQ7pATX+9dAAqlBocPQXxyzCAbtcH4d/Xb6y5Zda/zenw5uJ28q2R?=
 =?us-ascii?Q?x5AIVoZw6myaJFsri9+8f9UTyZd25YHzz0ee6LV33drLeJlVKIziB1Weoc3O?=
 =?us-ascii?Q?trySNZ2jZQlVnbEQjBdzkIbTk+UxdKIqDObHjgdcc5HLHbLfmMbol2PboMbb?=
 =?us-ascii?Q?u4o/vNNzhqQ8yS6DQ3VDH9j5pq5FDQs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B0473337459C504E9A5C5166D479CA8B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db1aea0-69fe-417a-98f5-08d9e5cf915d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2022 22:09:50.8207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LBK7iWQhRhptidR0AdPWX8xZzzvoHhYSIRPJ2LTy0voRZlc/ZVViyl0BKW+2mMn+D/3B1tTSXLU55REV6SSKE7sYKAlkd4u88iSjRuimMoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5206
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010121
X-Proofpoint-GUID: pE8mAbeEdXZSQdArhfFjUHMweO1hAymz
X-Proofpoint-ORIG-GUID: pE8mAbeEdXZSQdArhfFjUHMweO1hAymz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Feb 1, 2022, at 12:13 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Tue, Feb 01, 2022 at 05:09:52PM +0000, Catherine Hoang wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>=20
>> This patch adds tests to exercise the log attribute error
>> inject and log replay. These tests aim to cover cases where attributes
>> are added, removed, and overwritten in each format (shortform, leaf,
>> node). Error inject is used to replay these operations from the log.
>>=20
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>> tests/xfs/543     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>> tests/xfs/543.out | 149 ++++++++++++++++++++++++++++++++++++++++
>> 2 files changed, 320 insertions(+)
>> create mode 100755 tests/xfs/543
>> create mode 100644 tests/xfs/543.out
>>=20
>> diff --git a/tests/xfs/543 b/tests/xfs/543
>> new file mode 100755
>> index 00000000..ae955660
>> --- /dev/null
>> +++ b/tests/xfs/543
>> @@ -0,0 +1,171 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserve=
d.
>> +#
>> +# FS QA Test 543
>> +#
>> +# Log attribute replay test
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick attr
>> +
>> +# get standard environment, filters and checks
>> +. ./common/filter
>> +. ./common/attr
>> +. ./common/inject
>> +
>> +_cleanup()
>> +{
>> +	rm -f $tmp.*
>> +	echo 0 > /sys/fs/xfs/debug/larp
>=20
> Cleanup functions can run even if the _require functions decide to
> _notrun the test, so I think this ought to be:
>=20
> 	test -w /sys/fs/xfs/debug/larp && \
> 		echo 0 > /sys/fs/xfs/debug/larp

Ok, this makes sense
>> +}
>> +
>> +test_attr_replay()
>> +{
>> +	testfile=3D$SCRATCH_MNT/$1
>> +	attr_name=3D$2
>> +	attr_value=3D$3
>> +	flag=3D$4
>> +	error_tag=3D$5
>> +
>> +	# Inject error
>> +	_scratch_inject_error $error_tag
>> +
>> +	# Set attribute
>> +	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 |=
 \
>> +			    _filter_scratch
>> +
>> +	# FS should be shut down, touch will fail
>> +	touch $testfile 2>&1 | _filter_scratch
>> +
>> +	# Remount to replay log
>> +	_scratch_remount_dump_log >> $seqres.full
>> +
>> +	# FS should be online, touch should succeed
>> +	touch $testfile
>> +
>> +	# Verify attr recovery
>> +	{ $ATTR_PROG -g $attr_name $testfile | md5sum; } 2>&1 | _filter_scratc=
h
>> +
>> +	echo ""
>> +}
>> +
>> +create_test_file()
>> +{
>> +	filename=3D$SCRATCH_MNT/$1
>> +	count=3D$2
>> +	attr_value=3D$3
>> +
>> +	touch $filename
>> +
>> +	for i in `seq $count`
>> +	do
>> +		$ATTR_PROG -s "attr_name$i" -V $attr_value $filename >> \
>> +			$seqres.full
>> +	done
>> +}
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +
>> +_require_scratch
>> +_require_attrs
>> +_require_xfs_io_error_injection "larp"
>> +_require_xfs_io_error_injection "da_leaf_split"
>> +_require_xfs_io_error_injection "larp_leaf_to_node"
>> +_require_xfs_sysfs debug/larp
>=20
> This only tests that the sysfs control file exists, not that it's
> writable.  Granted, debug knobs are writable by default, but we should
> be careful here and:
>=20
> test -w /sys/fs/xfs/debug/larp || _notrun "larp knob not writable"
>=20
> So this test won't fail if (say) someone has chmod a-w the debug knob
> since the module loaded.
>=20
> With that fixed, I think this test will be ready to go the next time
> around.
>=20
> --D

Ok, will add this on the next one. Thanks for the feedback!
>=20
>> +
>> +# turn on log attributes
>> +echo 1 > /sys/fs/xfs/debug/larp
>> +
>> +attr16=3D"0123456789ABCDEF"
>> +attr64=3D"$attr16$attr16$attr16$attr16"
>> +attr256=3D"$attr64$attr64$attr64$attr64"
>> +attr1k=3D"$attr256$attr256$attr256$attr256"
>> +attr4k=3D"$attr1k$attr1k$attr1k$attr1k"
>> +attr8k=3D"$attr4k$attr4k"
>> +attr16k=3D"$attr8k$attr8k"
>> +attr32k=3D"$attr16k$attr16k"
>> +attr64k=3D"$attr32k$attr32k"
>> +
>> +echo "*** mkfs"
>> +_scratch_mkfs >/dev/null
>> +
>> +echo "*** mount FS"
>> +_scratch_mount
>> +
>> +# empty, inline
>> +create_test_file empty_file1 0
>> +test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
>> +test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
>> +
>> +# empty, internal
>> +create_test_file empty_file2 0
>> +test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
>> +test_attr_replay empty_file2 "attr_name" $attr1k "r" "larp"
>> +
>> +# empty, remote
>> +create_test_file empty_file3 0
>> +test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
>> +test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
>> +
>> +# inline, inline
>> +create_test_file inline_file1 1 $attr16
>> +test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
>> +test_attr_replay inline_file1 "attr_name2" $attr64 "r" "larp"
>> +
>> +# inline, internal
>> +create_test_file inline_file2 1 $attr16
>> +test_attr_replay inline_file2 "attr_name2" $attr1k "s" "larp"
>> +test_attr_replay inline_file2 "attr_name2" $attr1k "r" "larp"
>> +
>> +# inline, remote
>> +create_test_file inline_file3 1 $attr16
>> +test_attr_replay inline_file3 "attr_name2" $attr64k "s" "larp"
>> +test_attr_replay inline_file3 "attr_name2" $attr64k "r" "larp"
>> +
>> +# extent, internal
>> +create_test_file extent_file1 1 $attr1k
>> +test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
>> +test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
>> +
>> +# extent, inject error on split
>> +create_test_file extent_file2 3 $attr1k
>> +test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
>> +
>> +# extent, inject error on fork transition
>> +create_test_file extent_file3 3 $attr1k
>> +test_attr_replay extent_file3 "attr_name4" $attr1k "s" "larp_leaf_to_no=
de"
>> +
>> +# extent, remote
>> +create_test_file extent_file4 1 $attr1k
>> +test_attr_replay extent_file4 "attr_name2" $attr64k "s" "larp"
>> +test_attr_replay extent_file4 "attr_name2" $attr64k "r" "larp"
>> +
>> +# remote, internal
>> +create_test_file remote_file1 1 $attr64k
>> +test_attr_replay remote_file1 "attr_name2" $attr1k "s" "larp"
>> +test_attr_replay remote_file1 "attr_name2" $attr1k "r" "larp"
>> +
>> +# remote, remote
>> +create_test_file remote_file2 1 $attr64k
>> +test_attr_replay remote_file2 "attr_name2" $attr64k "s" "larp"
>> +test_attr_replay remote_file2 "attr_name2" $attr64k "r" "larp"
>> +
>> +# replace shortform
>> +create_test_file sf_file 2 $attr64
>> +test_attr_replay sf_file "attr_name2" $attr64 "s" "larp"
>> +
>> +# replace leaf
>> +create_test_file leaf_file 2 $attr1k
>> +test_attr_replay leaf_file "attr_name2" $attr1k "s" "larp"
>> +
>> +# replace node
>> +create_test_file node_file 1 $attr64k
>> +$ATTR_PROG -s "attr_name2" -V $attr1k $SCRATCH_MNT/node_file \
>> +		>> $seqres.full
>> +test_attr_replay node_file "attr_name2" $attr1k "s" "larp"
>> +
>> +echo "*** done"
>> +status=3D0
>> +exit
>> diff --git a/tests/xfs/543.out b/tests/xfs/543.out
>> new file mode 100644
>> index 00000000..075eecb3
>> --- /dev/null
>> +++ b/tests/xfs/543.out
>> @@ -0,0 +1,149 @@
>> +QA output created by 543
>> +*** mkfs
>> +*** mount FS
>> +attr_set: Input/output error
>> +Could not set "attr_name" for SCRATCH_MNT/empty_file1
>> +touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
>> +db6747306e971b6e3fd474aae10159a1  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name" for SCRATCH_MNT/empty_file1
>> +touch: cannot touch 'SCRATCH_MNT/empty_file1': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name" for SCRATCH_MNT/empty_file1
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name" for SCRATCH_MNT/empty_file2
>> +touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
>> +d489897d7ba99c2815052ae7dca29097  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name" for SCRATCH_MNT/empty_file2
>> +touch: cannot touch 'SCRATCH_MNT/empty_file2': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name" for SCRATCH_MNT/empty_file2
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name" for SCRATCH_MNT/empty_file3
>> +touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
>> +0ba8b18d622a11b5ff89336761380857  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name" for SCRATCH_MNT/empty_file3
>> +touch: cannot touch 'SCRATCH_MNT/empty_file3': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name" for SCRATCH_MNT/empty_file3
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/inline_file1
>> +touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
>> +49f4f904e12102a3423d8ab3f845e6e8  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file1
>> +touch: cannot touch 'SCRATCH_MNT/inline_file1': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/inline_file1
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/inline_file2
>> +touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
>> +6a0bd8b5aaa619bcd51f2ead0208f1bb  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file2
>> +touch: cannot touch 'SCRATCH_MNT/inline_file2': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/inline_file2
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/inline_file3
>> +touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
>> +3276329baa72c32f0a4a5cb0dbf813df  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/inline_file3
>> +touch: cannot touch 'SCRATCH_MNT/inline_file3': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/inline_file3
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/extent_file1
>> +touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
>> +8c6a952b2dbecaa5a308a00d2022e599  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/extent_file1
>> +touch: cannot touch 'SCRATCH_MNT/extent_file1': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/extent_file1
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name4" for SCRATCH_MNT/extent_file2
>> +touch: cannot touch 'SCRATCH_MNT/extent_file2': Input/output error
>> +c5ae4d474e547819a8807cfde66daba2  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name4" for SCRATCH_MNT/extent_file3
>> +touch: cannot touch 'SCRATCH_MNT/extent_file3': Input/output error
>> +17bae95be35ce7a0e6d4327b67da932b  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/extent_file4
>> +touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
>> +d17d94c39a964409b8b8173a51f8e951  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/extent_file4
>> +touch: cannot touch 'SCRATCH_MNT/extent_file4': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/extent_file4
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/remote_file1
>> +touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
>> +4104e21da013632e636cdd044884ca94  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/remote_file1
>> +touch: cannot touch 'SCRATCH_MNT/remote_file1': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/remote_file1
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/remote_file2
>> +touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
>> +9ac16e37ecd6f6c24de3f724c49199a8  -
>> +
>> +attr_remove: Input/output error
>> +Could not remove "attr_name2" for SCRATCH_MNT/remote_file2
>> +touch: cannot touch 'SCRATCH_MNT/remote_file2': Input/output error
>> +attr_get: No data available
>> +Could not get "attr_name2" for SCRATCH_MNT/remote_file2
>> +d41d8cd98f00b204e9800998ecf8427e  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/sf_file
>> +touch: cannot touch 'SCRATCH_MNT/sf_file': Input/output error
>> +33bc798a506b093a7c2cdea122a738d7  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/leaf_file
>> +touch: cannot touch 'SCRATCH_MNT/leaf_file': Input/output error
>> +dec146c586813046f4b876bcecbaa713  -
>> +
>> +attr_set: Input/output error
>> +Could not set "attr_name2" for SCRATCH_MNT/node_file
>> +touch: cannot touch 'SCRATCH_MNT/node_file': Input/output error
>> +e97ce3d15f9f28607b51f76bf8b7296c  -
>> +
>> +*** done
>> --=20
>> 2.25.1
>>=20

