Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42055C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 17:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28491610D2
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 17:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243738AbhIMRnM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:43:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40378 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242563AbhIMRnL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Sep 2021 13:43:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DG6jMI029752;
        Mon, 13 Sep 2021 17:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=l4QsSySbkILxEoT/ueCt0HMBgqPTRbhUKk1ILV+UQ0E=;
 b=YT5Gj4/O6olj4DBO77iMhp4whFS6dVTSNn0UQwAQDTpG1si7Eym80MrqMRCQQG82NgAR
 gleWkktLZvTSb9bs8yComaivem0hK1VYN2X/W/K92H4XK37WB1gZ/YFkVc1hp0KJrdWZ
 Gw7Ubk79AsPbeoW7V+CFKevnQon1ocp7Hj3a8GKkzuxblIptSXzvuiUpSGJsMpyJuSdd
 JH15MlrOvDmJmEmeIAzfQgD8RgE/ixu7urg3Ip8/Zl+BZQeXigC/dT3eshZGkFqREJ4n
 cUXfbyOdsZJpx/sakVl4epdalYzfonn3AOgW/gW23t2GjP8QWPoV97elXZj5c+Ae9BY1 Fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l4QsSySbkILxEoT/ueCt0HMBgqPTRbhUKk1ILV+UQ0E=;
 b=nv6zKu+r75E8vCh1jsjF9zFROOP1UFPOv9BsBQxQsmm3dluMYUQDx+EC4bJBuj2NRtgL
 4xuzLxrkEv+cT5j6MDwIpYzJGbpSNussO8B0hyGy8NCQSsuZ3Zt4hjW58dBqB3nZySZj
 IaHJVOeaWndXXfMnFGLp+CeQLyfbiDX1B62MeKey98V2Wwz1hsYiPg8KuXdkpq4Y1Rko
 vNj1FIGCMIczw/z4dTW+Q9fe9qXBC+vDTxPA4xWf0zG7s73ncPS047VBZXaDqm65BSOM
 I3Nlbz6s65UlTMtXDpmnMTRwCL+TsiKAvwCeLQpjHlgHyPDgigTVqskJrsCtH/OH01R/ Mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9ruj20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 17:41:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DHLbuu060775;
        Mon, 13 Sep 2021 17:41:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3b167qs62c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 17:41:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzKu1xOo9VSiHFVPMKvT7RNIHsVtT5Vg79EFe9qNnIBZ6mFaAnh8sMg2Ub5MmHhzyN9f4VSD11M2g6Yb7H5320u0/qZy+erHC7b0ogLCLMbhW+gFs3g4sGnjsQ+bxeYXCsI6fJ837KzXEprT9FuLoey7txeBAl8Kw6+qkTObJuCmi/OwLP1/DCJkb9nAxVU6gz/Gi3ajoMtTZg4rRCRYNqFMOWRILwGn6LjbAQPheVJG48tdeiylxV7PgFfN1mBLdIrOAAIJN7yC+1UgqOBiAmWnw+oc93TColwwzYVh6RGO4XKtTXb3gpLz6zYQmh0UjpO1j9HvZ8cRwcroJDp3DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l4QsSySbkILxEoT/ueCt0HMBgqPTRbhUKk1ILV+UQ0E=;
 b=cmLaW00Ff8kf1390CWdBiGMd3mgpMqyLIQUKqfgoikPg/YlsXZVhvC8xxVbCx7G3/HAzcn2GyqXIWHTZrNT7WrP9PFfi4Ag0bxvo8Z1EGbm6sOJa2Wok7mHLqT09K0wl3a3YFfat+0LofQJb2SoS0crgkikLX3Sq6hWfAHLIvmM165Yk0Nh4FPJTlXbplnL/VAMqQbWhDRxCAIZY8dYYSzJ1g0WISGTWU8GT/uU5MO1zTZlhZG0xTy9z5IxzNGQsbAlD1Xxdx9Qhaw1Mp6ED39M8eW01gCSuLKLhNM1Bf+qXxpBb8QyDq5GHYe+sGmMRFYRq3nIPu+7oANx99UjXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4QsSySbkILxEoT/ueCt0HMBgqPTRbhUKk1ILV+UQ0E=;
 b=vORdIihDq9yIXswmqbLpLcLovCxjDmnEfPCGXtFAxA9gyhv/lTX6EH2m0cTNWV13+dP5HJbkY5P5JG6Fa1eNYHUtN+SJqLtAk/AEwghOF+8DvGxHmRe1QXO4jXjL/SUXOeo3vYPjxNz4ssNTylQ21c3nDDoGtNRfl9ldFBAiY3Y=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1788.namprd10.prod.outlook.com (2603:10b6:4:8::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Mon, 13 Sep 2021 17:41:49 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 17:41:49 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     Eryu Guan <guan@eryu.me>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [External] : Re: [PATCH 3/3] xfstests: Move *_dump_log routines
 to common/xfs
Thread-Topic: [External] : Re: [PATCH 3/3] xfstests: Move *_dump_log routines
 to common/xfs
Thread-Index: AQHXpaH5MGcejf6xmkGdqNAmQCIJmKugEOOAgAIxGgA=
Date:   Mon, 13 Sep 2021 17:41:49 +0000
Message-ID: <5C50E492-45A5-40D2-B315-EC1AA5136B2B@oracle.com>
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
 <20210909174142.357719-4-catherine.hoang@oracle.com>
 <YT22rajMLkNyhKyr@desktop>
In-Reply-To: <YT22rajMLkNyhKyr@desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36e2986d-5eed-4cac-b657-08d976ddc3ca
x-ms-traffictypediagnostic: DM5PR10MB1788:
x-microsoft-antispam-prvs: <DM5PR10MB17886BEE8075CF3CC9030CAB89D99@DM5PR10MB1788.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /oZymjGDtO5Z9MLU6tPLPvuP+58LKhNp/NM0QEWK2J1HYVBhl4gvQ563tqkzVgbbczfmwA1tTJvAB1/S4I/FL2hpz+N+v+CGzyI7SKi6kfEHLhAAdQ8FX71Ylwig8Ww6FNUZ6m3SS8bq0NxCoAV9a00K5p3XkxesT5DyyXLEHxifvzheyGm6+Ox6IN7SY6/IJlw8cOjM57UUES6oKYfro4NzUFtIaVdbM2jo6DB6i0kNtuD6K/SkSZJgKaK4aZl/awpfJ0kh/009FzIR2wJ15s2wODQgtKB5UffGjefeHrqdzFWhCJsoK75hjgdFRQAoarnvQauj932Qjr9KoDvSNtTK9WCSUGSe8TJglLRtDA/rPRH9VpvRv6C9lNeLsll9AYMB+yTghz014nZK/hgFfSkhaQgqWtWNx+Q/JvPgO5YTK231pMEHNC+Qv1QTVEJaPEZ9FnI2jHYh2/6gHLN5KW45bEDW4o3o9UMhV0dfereG7stVqTKNH0ILlKIwKhsUo4Ne7dCOl95kYaX0lmsItPUn0pgDAxE/tCyD+eKGr96EfM/Qn0jhhA3dOpTFfIa7mjioz0QCuQd9DUahpKLEOJKrXea9fvCWRKNpe2xVa32KZ/vZ30G5+/RB4CEYhuEljMydBPbNgjSxCEliMVmPHzjKfFvVL16tVnvWVxNYKP13Q8NIKldKMzdna1cBiQm/Kf7tyZR5AoUD5zlrQso/svs3EyTzehTTPxzygcpMbjM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(66946007)(6512007)(66476007)(64756008)(66446008)(71200400001)(76116006)(66556008)(5660300002)(316002)(44832011)(8676002)(478600001)(36756003)(83380400001)(91956017)(2616005)(33656002)(86362001)(2906002)(53546011)(4326008)(8936002)(6506007)(186003)(6916009)(54906003)(38100700002)(38070700005)(6486002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V2pyC23Pomc+yfEYwP77ISdQEeFgr88G/eCoeAe7qH3mwJqzyiUgA04Gyd5E?=
 =?us-ascii?Q?fH4CPF6brzre53hhITyYRMNyBH+dY9JcFjqS20mQYzapVlGk+gtZSdvU+El8?=
 =?us-ascii?Q?UqmRFAmuQVMIUGQyCa4guVyVNhy3uB5UqSbkVyvzATydYMUGkFFeXLdnfkAt?=
 =?us-ascii?Q?1cWcRdeGuycItVKMuILqVyt14kHPUps9fl68s9XqUX7KhNoON187dpBR1LhM?=
 =?us-ascii?Q?rzH+QZqoNiL2yHsIHj7ytEi8vbVLAGWL8TqCk8PEW8ipYdZVzTUcoNHcfWP5?=
 =?us-ascii?Q?WUk0mLXXCrBivq2DomZPc/94lqEZcBraFgCzH4w8/LJibBrnncKule9FV45B?=
 =?us-ascii?Q?VHatzDbgSGZqizhKbASc3G6HrCSuK5fx7laCZbLkO7s0BxYpm6zazeGx63DY?=
 =?us-ascii?Q?GVf1SGKjnb7iszZb39QCCsztNEtbEIwvlHBJo0oFOHo64eE/Oh7nJ6Lsq+56?=
 =?us-ascii?Q?PoYzWLWqrg1c9TLCzQD6mkIkBf6WUNDKqSNPqJn8Ux/XcVFilLM+58HmIhai?=
 =?us-ascii?Q?3BryJQxrLqX7TTTE3L6uEKLgklZu9XarMdsmngoBKpnYpmGMV4dgILGqkoex?=
 =?us-ascii?Q?ta8L2m1tO+kb9G8eYlB9zN+kPV3rUnP6yzRVxLviKNbYAlpJOGsRf/fkqZAU?=
 =?us-ascii?Q?lq5R518mrvJkju7WwRTbRu7xTQZuluKEk6pq0C9HC6JMNGKssJc+ZWLXvqrJ?=
 =?us-ascii?Q?trvvME1ZBG3z4+wF/4V4AxgXhOvsROp+cWCtqCV8yi9WTK6Vz8A7mJ8tNWWC?=
 =?us-ascii?Q?tZWh3KUJ4yrLiIfWFDrL9YYGtpU8s6sLhzXBVMPpH3KCTgIKnlDovhF1ODYR?=
 =?us-ascii?Q?i4I7D6Kcth1+nfTkpQl2/+eFcpV94UQ374rL7KdZtp+fGdQghC+BQw6rSdYi?=
 =?us-ascii?Q?Hi21eJAJUYTtIIwK7VxVRcSzXpx8NiH/O1hR+Aqkb55i9qqvnAt5mLhi/G+s?=
 =?us-ascii?Q?mZiIrh18sULIv7vSYmP4gKJmVhXmj31tfXzK37tiTy2YcxyLIuDAW5Jqtpos?=
 =?us-ascii?Q?P7ptDaeAfoOpQZpQI9yFH/FcWtruD5OB3mnIOfeU0SdFdXNl60wOY6/g0k08?=
 =?us-ascii?Q?kMm2u626K+jbJ/QrW8d93DuBpREeG7G/IFxU6nTZJsDuypIlnfL7h2YluSoX?=
 =?us-ascii?Q?QGQv3Xrbhj5xvu0h2beQ+aEjJyxAJJUlIiyXlaweKpUhtNRWDm3mzR1flRFf?=
 =?us-ascii?Q?9Khc8etqjBO9L0mtqb57/jYjCGiJu0qiz32kSc9h0yirtLRsQmhBWegcOzL6?=
 =?us-ascii?Q?HzF8M8uYKNYvLMtUMnRLnaSfXCna370ocnmrrQqzGBe8ogcNoDS1drEXr4Gd?=
 =?us-ascii?Q?7XHJhWr74Ymk4QCtMiKP9mxZ5EiZoYk4rxEkiewBX9aQLOwM7t+O2mBjL6U9?=
 =?us-ascii?Q?j6KOK4M=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40032F600C179E409AEC42142FEDC073@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e2986d-5eed-4cac-b657-08d976ddc3ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 17:41:49.3108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SwLSk2EBjDlAk7VEw0kgUgASAG6AgE8Y1US7V1fbqN8MhWJ5Fq/KESOeulLLwsiP0UN0kSilHuco2nY+gnOmbNi09eSdlWQQpKAIKZAsF8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1788
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130111
X-Proofpoint-ORIG-GUID: Dbz6FICHCsTEBp936xP-qT6XoegdtS9x
X-Proofpoint-GUID: Dbz6FICHCsTEBp936xP-qT6XoegdtS9x
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> On Sep 12, 2021, at 1:13 AM, Eryu Guan <guan@eryu.me> wrote:
>=20
> On Thu, Sep 09, 2021 at 05:41:42PM +0000, Catherine Hoang wrote:
>> Move _scratch_remount_dump_log and _test_remount_dump_log from
>> common/inject to common/xfs. These routines do not inject errors and
>> should be placed with other xfs common functions.
>>=20
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>> common/inject | 26 --------------------------
>> common/xfs    | 26 ++++++++++++++++++++++++++
>> 2 files changed, 26 insertions(+), 26 deletions(-)
>>=20
>> diff --git a/common/inject b/common/inject
>> index b5334d4a..6b590804 100644
>> --- a/common/inject
>> +++ b/common/inject
>> @@ -111,29 +111,3 @@ _scratch_inject_error()
>> 		_fail "Cannot inject error ${type} value ${value}."
>> 	fi
>> }
>> -
>> -# Unmount and remount the scratch device, dumping the log
>> -_scratch_remount_dump_log()
>> -{
>> -	local opts=3D"$1"
>> -
>> -	if test -n "$opts"; then
>> -		opts=3D"-o $opts"
>> -	fi
>> -	_scratch_unmount
>> -	_scratch_dump_log
>=20
> This function is a common function that could handle multiple
> filesystems, currently it supports xfs, ext4 and f2fs. So it's not a
> xfs-specific function, and moving it to common/xfs doesn't seem correct.
> Perhaps we should move it to common/log.
I see, I will move this to common/log on the next revision.
>=20
>> -	_scratch_mount "$opts"
>> -}
>> -
>> -# Unmount and remount the test device, dumping the log
>> -_test_remount_dump_log()
>> -{
>> -	local opts=3D"$1"
>> -
>> -	if test -n "$opts"; then
>> -		opts=3D"-o $opts"
>> -	fi
>> -	_test_unmount
>> -	_test_dump_log
>=20
> Same here.
>=20
> Thanks,
> Eryu
Sure, will move this too. Thanks for the feedback!
Catherine
>=20
>> -	_test_mount "$opts"
>> -}
>> diff --git a/common/xfs b/common/xfs
>> index bfb1bf1e..cda1f768 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -1263,3 +1263,29 @@ _require_scratch_xfs_bigtime()
>> 		_notrun "bigtime feature not advertised on mount?"
>> 	_scratch_unmount
>> }
>> +
>> +# Unmount and remount the scratch device, dumping the log
>> +_scratch_remount_dump_log()
>> +{
>> +	local opts=3D"$1"
>> +
>> +	if test -n "$opts"; then
>> +		opts=3D"-o $opts"
>> +	fi
>> +	_scratch_unmount
>> +	_scratch_dump_log
>> +	_scratch_mount "$opts"
>> +}
>> +
>> +# Unmount and remount the test device, dumping the log
>> +_test_remount_dump_log()
>> +{
>> +	local opts=3D"$1"
>> +
>> +	if test -n "$opts"; then
>> +		opts=3D"-o $opts"
>> +	fi
>> +	_test_unmount
>> +	_test_dump_log
>> +	_test_mount "$opts"
>> +}
>> --=20
>> 2.25.1

