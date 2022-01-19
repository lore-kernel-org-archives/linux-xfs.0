Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0310AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 21:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357415AbiASVyT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:54:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47358 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343606AbiASVyT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 16:54:19 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JJecQf031235;
        Wed, 19 Jan 2022 21:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=unkcvevkN7lUF3G1oO6+6MARpVL/91Eo8Mo7LQQWhb8=;
 b=y7geTWxdT3TuB/vNVKoCGM4X1JwInqPyXNxrH+vHg4hONmT9yUcN79Bf77PW1dUE61C6
 QV7NYHZ0BsJ2a6O14NRNi1O6qvUndg0pW4vfTd4c6l7wvbgQ6jN2Q50wf6fcLLg/vemc
 tm7HC2M1Ond6SNzzu5cD9KqCD4nkKI6COMxL0gtJprbfKeWqNH9q8IdjNcfsF5IoocjZ
 L/+xgJw6TryPuztVrQn/GdZPnq5WOi6o7pdUq28qfMn1Un7FVt66xXw97CNi600ktcPI
 ZLGctKJwgpK6S1sNF8ifSJauiJkdnx2JALTli7KhJ3rESklaxF8eh6qDf2y3wRO9LX/Q lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnbrnxbrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:54:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20JLauMM147136;
        Wed, 19 Jan 2022 21:54:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3dkmaebkmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 21:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gt/T6ajtX8INslNQ/p5MI3vBU2Y/UtgfnA8Idcb10uxJUewdvAD2s5ABgQtgMx9PoIR4BUh2hIqSa8VSy4r1mDMGuUpYvyX8BD+5CCmuN5VnCUhlhwBeTqMaBQbdPnTicCuyzc5XP8iRrGpbBG4Wy9iNhgSZa8A6TkQi7xkbcMUMPtRAblh8MVry1duC5lSqhWYdUMlDR1n2/bNhB8wtDrLYU2Z81yX2TI5Umc+Pmqei5yUsc37rjcbB9nW7BRrfYAizF88iAhWM3yWYdFOyQAcUGzJRd++FUWEvPHPfi9JS+S7Po9A58ZXNNOg4hLvyT1o+fZKBcghy2Mn9mAs7vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unkcvevkN7lUF3G1oO6+6MARpVL/91Eo8Mo7LQQWhb8=;
 b=ADPClQvQ8r21gEFZXFYyDAm+LV8cmcShZU7AqSjDizI3jIWOMUHpR1VycFwKORJlYAnNlKa0eLa3ojrplKGUgyi9ggZOU3FD/JwS62aR79w0XmI1CbCbnj0ATkPzkse5KHJVgJXmJJ+ay01oDIiC3vjSkBmmloGE8EECFhepB4ePe9thPrW9Ssd9DHFzOfPsoUBVQhsecyxj2Oo2566EA3CHcMzgybHjeyQE7GPtBOzdDI+jUEo5OatAKfT5SAfVSGLP96jbaE/IS+rbOVoAKGGQZqxrKGnFfh+IvC49z/KdcSml1beYGCmfJECFnUUUPm5qAkwNfQnQVyolSwhLAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unkcvevkN7lUF3G1oO6+6MARpVL/91Eo8Mo7LQQWhb8=;
 b=uBO8WiNu2Nc8mdKObfCrWMjuPZdUchWr8qEc9rj+RwVaM99rupVZDAUL97fKOyNIfWvOvgA1OX3TvW7jVh8ufPh8OrWRW5peHuTOVuo8N2atPqOL3aiPA7Mk8w+r8rs/+NYeCos98z9/sgALnrf6NczOss+QA+A734VIAZfCppM=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 BN0PR10MB5335.namprd10.prod.outlook.com (2603:10b6:408:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 21:54:12 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::ad2b:bc5:20b:ee97%5]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 21:54:12 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] xfstests: Add Log Attribute Replay test
Thread-Topic: [PATCH v5 1/1] xfstests: Add Log Attribute Replay test
Thread-Index: AQHYDX8XLMVm7r3HhUibhfP5u6Nm+A==
Date:   Wed, 19 Jan 2022 21:54:11 +0000
Message-ID: <CDA2BC8C-A657-4720-AE11-3127EE30199A@oracle.com>
References: <20220110212143.359663-1-catherine.hoang@oracle.com>
 <20220110212143.359663-2-catherine.hoang@oracle.com>
 <20220119045118.GH13540@magnolia>
In-Reply-To: <20220119045118.GH13540@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a78da7d5-5d82-4949-c51e-08d9db963a65
x-ms-traffictypediagnostic: BN0PR10MB5335:EE_
x-microsoft-antispam-prvs: <BN0PR10MB533578F79780E4818BED45BA89599@BN0PR10MB5335.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NdxpxvCoq5NKMMavKCq6D2Y1uhfDbKxBB6XPlTCYx7cG5mJBT0EtbfIEA9eX46+3AMECYikU5nsE0FS0/NQzICte+MyEyk1mSo2wQUpKcKoPknDAxqbxsTK4tDKxGCxGMJ/YC2s9juHzI62qhc1IP7MCK7TnlSgQ6HJoyCEkkNNBHa/IIlM0rvSFwun6eQOxqHxuc3dZEMNYYmqk+ac9hfUb5q8pteId/zr2Q5w3OTwzmsFNkpAR1moSeYOjCZE0TbC3l59nIX8vFcOGRHwjhYqVy5HVR79LVn5olzC90gdeOJAzvWeQEOVVmMR5OONNZeroiaf2nFzVxc7LIkgjnde+73fD855IwWqk0RFG+h6sTNHbDzPK9NP2T7DUCi9miO3pRQQ4EpFoLSHZ1d9/KLJ77RQEYgEfM1kT4IFyBWEs4E/szZePgKPM4S7jCyNcfDZ63dzQGWxGmo+oOTRsxetxr3gtTDs2UKfZXRbVbL38jDl4rzp3vEHwDTu/oUhdPWa8HcAGDBRdmdy7SZioJGlVN/WVcULfkYdWHk8iamoONrsIWHshOBJMhHPKq5VJcNo7mIq0/8xbUsfXOvlGJREROVzpqscHabauwuydw3OvHq8/Vj4nE7rp04U+aQjN7aAI5DigpoQzDwYzTBp15ceMWbiIISP7l8dYrVN8cPsH60kDhY1/PVs5iq/nKG/SLujgR6l5xGjOJBkbEOmA2Dk36u/m9UHmKhT6R1HAG4uVDiMKqK5ohZrXx5K/aRQfaK2F7uEzsOuwpS4I0O2sbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(5660300002)(53546011)(508600001)(8676002)(33656002)(66556008)(6512007)(186003)(6486002)(71200400001)(30864003)(64756008)(38070700005)(44832011)(316002)(122000001)(2906002)(83380400001)(8936002)(6916009)(66946007)(91956017)(54906003)(86362001)(76116006)(4326008)(2616005)(38100700002)(36756003)(66446008)(66476007)(45980500001)(357404004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0syfV79BUtSC5YQZHYc7hMq4gDSJVeLw9yHBbrciZi0b6925nZNqOCbOpsBn?=
 =?us-ascii?Q?aZ/hHSFDifCWOwA9DvjIdXX4Ekj9yUWSHCJUIAb1wGXoNrXBFYTUheJ3MVz4?=
 =?us-ascii?Q?n/yzvDoq04genO0CW4/YKfeqMcRKrlCInDKMLRcRUKxYPV913NADboLPTjxC?=
 =?us-ascii?Q?Bfn+FzQY2DYE/Bd5JEpgDC6wXgT6ALCtD58vFKMKK44HMZzAaCuxwgjyHiQJ?=
 =?us-ascii?Q?UxvICqKL5h8WZjsowq8e8kOnHoi4msCMzM2QkJFuLq2Yg9uUXjMPWWb/E6b1?=
 =?us-ascii?Q?W2hW+gjz3hOVV2VjOaoTkMgaBqQi+pULIW9xg1dnJiaS2mFZQGHMdjo0YBHM?=
 =?us-ascii?Q?ofZ1mgULBDL3sr/5Lwz/0y6N/Tzt36hAIP1Y4NNCdfNBKbbZeKhztxiaxWgd?=
 =?us-ascii?Q?OSCiIef9b8l4fqm/eo3rjCJpl0Fm6PqqHSuC3CidAZlR59z0LrwaZ10MEKW1?=
 =?us-ascii?Q?DM8wEd38Nl/fxN0u/Fx8MCAr1sK9QIuSPZ86RkWwaWdiQiZ0f3irvRGW4haB?=
 =?us-ascii?Q?P/ZF1Tq3KtvX8atA7BG3eHv66W5gBvjTC6XSnS6BtzWt1aSTlz2DXP4yk/9X?=
 =?us-ascii?Q?BVm7ZodZAEamqNDS21QuwIz4zowXC7sZ5BiPRcwsQH8T+TAryzzzqQytc8f+?=
 =?us-ascii?Q?iQNLRmjnqPifT7RPlrIxVoZwjxQYCQRQdk0AaLb6IL1c1BA2ERFHNMijtVG5?=
 =?us-ascii?Q?7J5tpFNgC61UIjMqM5K+IvsQRZHI4UFRADplRg6HE26stug/GOcL1uuHCast?=
 =?us-ascii?Q?+MuaUX6oUut1vNMIefuHP0hT+9RMwoU6LvK14VsGug5seDNQOqvdnuzcex+T?=
 =?us-ascii?Q?rrcaTzsG/GFIlOyFBEXXW4cTTWXQGuki6yKqm8c+fds+ToKlCAufMJBuuK0V?=
 =?us-ascii?Q?eSD6FgZ0FoVfbtdLyiwIH9HZCDj9/KOHSPZX/b8ApkJZWHJOLFh3xnoqnU0n?=
 =?us-ascii?Q?/sS65KNu900CBQnhL4rSkXwIquvvc8LqjOmambvGKODf18NWhYIQMaaoVQ37?=
 =?us-ascii?Q?tluQMLQLnBAh1nkqanAuZcjwj6eJy9IcPr4c6v3TjWguvtwJiE5LAs/ymZjk?=
 =?us-ascii?Q?6QV0+xhTtAi2BPm3Fpuo05rl0IQXtxqjNQIpQ65b315gQKIx1k5mEWjJBOmh?=
 =?us-ascii?Q?poMlCfck33eq4Atm8fVhG5r5HGtEwdcJJZQ8voHBIjbaBaMrFmWKp1KzI8cj?=
 =?us-ascii?Q?YswxBQvk5ZesYcfiDwNqnKTPogV6xUdEwoW0sMVziZvstS148SgE9upgG6Zw?=
 =?us-ascii?Q?eyf7mFhfKcfuLWuUlX36l6u3kX0tPBRKU+AJGMJVu8wzGxv6YBW0CLoR1njw?=
 =?us-ascii?Q?6PN6bhLvjIG2RikD13iwcOrbdfAxtLr2Vr4WT6qlUj2h5y0sOWIY7H7/dKsJ?=
 =?us-ascii?Q?SS4OupxqCb/XpbSGXUa9fN7VVz3kFhmIxPEhkFUu2Sf4f/TlVJs3lbz5jTtt?=
 =?us-ascii?Q?HdryhVgfs3l73zFLejRHjE0R4QhluRG1oJTMSfYCHN6RsMRvR2t8BBNBe4t2?=
 =?us-ascii?Q?CnSnPf7/rRMvCxZo9AcnwIaLpvy9zLgMG2LT7aPA6zfLoB/Ags7UegC0FJpz?=
 =?us-ascii?Q?RyHuRsO4Mf7t/AvOrlAIG1Pp8atq+83elupQGQ71aBCaUYCj8iHLJPs4xqhw?=
 =?us-ascii?Q?3NChO7PGmKNZ6bSFzxo/dGfz9e2zQAfw06yVvqCtdv39NIZZLx/ERzN++FZ5?=
 =?us-ascii?Q?4CnDdI0Ri3kX0LZIT+Zm5Pqy4e1rZQ03fOHcqKyjlXoAURXPFJeZp/MXgVWu?=
 =?us-ascii?Q?oc4oIjPZfQUHHCWwAGeT7GuskInZyds=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4835232DADE8D24593320BC1A20C529E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78da7d5-5d82-4949-c51e-08d9db963a65
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 21:54:11.9921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ryfTrDz7jx9dvPoMDUNyp8rrBO5W8L/G7enQqSckfbYkM2iyIu2GcjsOT9aSJL3VVTovpSRjiFT+Nx1KWYhbCQjny+rSq2Df5wfwUU82OwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201190117
X-Proofpoint-GUID: wCx4em5LJErdvEJH0cXGT6DhjFWwWb_q
X-Proofpoint-ORIG-GUID: wCx4em5LJErdvEJH0cXGT6DhjFWwWb_q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Jan 18, 2022, at 8:51 PM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Mon, Jan 10, 2022 at 09:21:43PM +0000, Catherine Hoang wrote:
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
>> index 00000000..29bd5b77
>> --- /dev/null
>> +++ b/tests/xfs/543
>> @@ -0,0 +1,171 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2021, Oracle and/or its affiliates.  All Rights Reserve=
d.
>=20
> Silly nit: please change the copyright year to 2022 for all the
> patches sent this year.
>=20
> --D

Will fix in the next one, thanks for catching this
>=20
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
>> +_require_xfs_io_error_injection "larp_leaf_split"
>> +_require_xfs_io_error_injection "larp_leaf_to_node"
>> +_require_xfs_sysfs debug/larp
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
>> +test_attr_replay extent_file2 "attr_name4" $attr1k "s" "larp_leaf_split=
"
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

