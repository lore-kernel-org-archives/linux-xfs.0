Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB1DC3DA7A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Jan 2023 00:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbjAFAin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Jan 2023 19:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbjAFAhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 19:37:43 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247475372D
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 16:37:41 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3060UTso018785;
        Fri, 6 Jan 2023 00:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pOL3FQDvvOU2WJqTlzKpz2GBANQG6cpsiwtHsnSCHho=;
 b=GlmEWO0IyG2s5j+BublICS+onqDR797rO0j8SBHdhK32JxXpjBVbR0TJ7gPIlPY+rhj5
 Rw2V92ZiHOFp/7A3V78+S6kbNenUIFU7lix1Ti9rm/VzOfl/T50wWxXhzaTAs3G8dAhj
 mSyzxc+/qYn457Hs1ybA8vwHmpgMk0aSGgJjuRqWQsmqMQ45PvS8vMv7aDitgFo2h5HA
 JDHvrEGhlHK6NTAhRM0JTKrnqI5qAWVBnkz4kI3WQof04VRKCKzDZHmHcHiYqZS4ITFq
 nwQ2iThKBkWS2ZmgRKEdVWciUucCYfiH12CpkNK2XWZm+KyR9pCLJZvyTv2FzqHFWbxO Bw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtd4ca987-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 00:37:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 305LphkU029120;
        Fri, 6 Jan 2023 00:37:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwevk81mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 00:37:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1aTLT4xXYzbT5qUmRUc7hyoaAZgww8uiu8AveVFB83QegR5bvfJEL5jAWyKxbMSlUosG3viN+5tILopd1Vi/EU+R1cWA1Dqqlmyr/6zZORWqJrfUAb8o54V09FlPaSwL9qPw278U7rpADJa0zx9v2sVtgc55qcJ7Y1YtEhD4KVqzQohgXDxWFe6gm26CRiCofaGXF6Fzz8L/iPpvfg4ssbXStZ9fhQTaojJ+Lmg5/TsQxcDinkR1zDN2c2d3wTIXCDM1E0xmPIeYRJpEmwpLtvCHWF+jRk+oCaV8qc2UYUCNddjf8xwtGM7fUKqBP6GAGjfa3gfodVZa16iHfHFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOL3FQDvvOU2WJqTlzKpz2GBANQG6cpsiwtHsnSCHho=;
 b=RqG65cAsOoHJ6Sq/E3dwfderRErgKbckADPnkov7v8izjTeT9hCj8hpEvvtQ+8/897WSnKZf8Qy7eGt+EBRJB+X7n+0n3mHjIpSmNYXkC65O80AMEAouQ8/YACujoNDEdaVEvTdYL3hJC0I6gBsEC/DxOxgPHDNa5q9b0ov4Rwv2CH8B+OsrgGN3g/SbnLSdRSRzv7+L2Bjj2EbmPs1IQDjrss5QDEZDaOaq4wTj6WZ5Fn1rG70Nh+1y2zLhBuiFcGDKnrN5tOrrKNqxHmM+qJFdxM1yMD4aZnBfD32O35DVCEmEpb/5t95fTbyMUhAOOxdt6omTdwBROq53WlFHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOL3FQDvvOU2WJqTlzKpz2GBANQG6cpsiwtHsnSCHho=;
 b=YY6MFyTgPipYRjcXXSIvzbAH4Tb2O5TIeoUGDRBUHSG08CtJrriB/+2tNTaGtFcuH3NghhW7NXdWDGELRHJQkv5euj4H5gTA1/D9uI2LdREdSkcFXYSZmIQouoj8d0tfHmrHkG23c9Zkhg3PlEUsHIInyAn5u8GLtVxXefy+Hug=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6911.namprd10.prod.outlook.com (2603:10b6:8:101::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 00:37:34 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 00:37:34 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Topic: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Thread-Index: AQHZIWcRiVX1h3sqnkSnETgc8yH1yA==
Date:   Fri, 6 Jan 2023 00:37:34 +0000
Message-ID: <B13E7EBA-C3CE-45E5-8D69-B9B5A1064062@oracle.com>
References: <20230105003613.29394-1-catherine.hoang@oracle.com>
 <20230105003613.29394-3-catherine.hoang@oracle.com>
 <Y7cpVnPqLwBLFHmM@magnolia>
In-Reply-To: <Y7cpVnPqLwBLFHmM@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DM4PR10MB6911:EE_
x-ms-office365-filtering-correlation-id: b250f034-d9aa-4ea9-8dc0-08daef7e33de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F7EUk4bxjeQC+bHBBFHlWML592rFKiNprwqcFoapYC1bPCAgmwdV2OuOIJcQuph1mDIlMinvUOWnJrKiqbdIN3Su8ql46l/+18Wo6H/lrycTx3f9Peb5Sy/j8g0fkPTzYoGy6IZf4t8Hq/D0FmnM/9+CG8SXLN2PEdXFrIuhKvnsXx+rjafU7FdyeXTul1nJAD6FBdiI99OYK2hHSPnNst68VarcUPlSioK3WMBrR0uTrXDbWbCd9615eQyGsmw+LC8jjFKoSksAIAKsmF0RITi7YWVC6NbwRNcEOJwIDv8TcuFlMkebZu7l4KvwhsO5DNh/N+f85dYlCwZkbv3Ww1rJqTyYY3IpRUhylHWn0w2dmKxN+iCs/8io52Hh6F0wjQsHCUozuwZOu8THo38AawZaF5z/j8I+PayvTsk9Aqkmnx0NpkwsDJiKIb5cqN3IM5QTAEZ0BKd+d6G7utG331OaTNPKYPIY16AJQY7ePrjySps0dDpRN+E9PfQxe+A9HBVPWASr9/w4sfXqpFFmGXPTXXoRZY22hYhWNKjx8grVCazQSMamoKDUepWmkY0peP8VKZ3vNidMXpRIAHj6LcJu0A+iVsi1lwSABTrXaZ6blQ9xTt6xBFrkn9hZSkWSgCjnnbcQ+eoFPeFEL5cItYiw7uQ/2eXSWNZSGR7lFPeZDEZY5L00B1tSs1U1Obw5p6gZXdgCQAtTxVrzWvAVRfj0/KJnlMvvVqfIUTbLiKg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199015)(53546011)(83380400001)(186003)(6512007)(2616005)(33656002)(6506007)(86362001)(38070700005)(36756003)(38100700002)(122000001)(4326008)(41300700001)(8676002)(2906002)(5660300002)(66446008)(44832011)(8936002)(66476007)(6486002)(71200400001)(478600001)(316002)(66946007)(64756008)(76116006)(66556008)(6916009)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lXF4Rl3DXpbpW4mJ/i/4mUMus2Ay8uWnOcLL+CeyxEDaNAGR2Y1hGdTLw0si?=
 =?us-ascii?Q?MP2VjcsFBgVDWXnLai18q/a1QSVIhaL0h4bMJdDWhQhfKHNJvHO7kXcXvqvD?=
 =?us-ascii?Q?oQE2IyovNlaVsWesne3Smf9UtVLIpv1acGZJKRe+rdPGqmmc+lrIwd4tGjwb?=
 =?us-ascii?Q?Nnqsrfv1VvUkH9qTs34Xpp5PA7ZuWJSupqQQ64x/SEYpjt1wA9SKy5NVyPkq?=
 =?us-ascii?Q?LAMyBvw73rlU65x+2mmlTguQfO49zmLo7wwZoqrw6FvvtqTUZAG+ODfRcCY6?=
 =?us-ascii?Q?BDjxk7aLYKLp6mfxBoZ8M2EmVNkzktHAL9P1wKQC+ImYhZ5i57Z3NGM27wO5?=
 =?us-ascii?Q?O/w/W43+PLrAQA7TQ0BmpQua7PEysbaxgq6rq+owLJ5NoAztuf4q+wdnqGml?=
 =?us-ascii?Q?MlAehNkXuR3ZkAZTY3JhNlw95ZIUd7oDNVzDTTEDGktJ/HNvfTPcphC26182?=
 =?us-ascii?Q?oICDjiviXidg/2XwCYy4EZqeC0sos8NOk6qpuIaPmTN7xt0tx/DlaqXqwG6h?=
 =?us-ascii?Q?yIi4qNPMxHYwCltHbHVFVOgSX5iStl10YRPZN0eZcgrpp5V6SQFDnNBlO2U8?=
 =?us-ascii?Q?OljmZSDdemgjjeZaVzQO0vi2XAUVn1Yrx9pt2omela5hq+dz2WZb+/T8B6Rg?=
 =?us-ascii?Q?7Ri73XuW75rLRkopE2GKAhK4ymJBrRw4xnKVxt8roCSKDqkacpV3QL/0FGdn?=
 =?us-ascii?Q?MbtMPbwU0qssYHNKcO9+beLLGS/PknzawDxnxCx3RRmfuhQGR0guTojok4k1?=
 =?us-ascii?Q?H5ld3KkM4RW/KsssntshM5OAKESuZV+KnP3/NbD55e5W8RMO7FBPA/rw8A4/?=
 =?us-ascii?Q?2gnmSRfPzV72GML4x9GZU4jvOvxFqDVRd9n5Wu4//7yOh03AhdAL0OIB1G7P?=
 =?us-ascii?Q?o1aFxQeTyiIFeyZGl3ybgk9cjb7/5VUdS9f1s7nIHc5ecs4WaAdml+vB9YZP?=
 =?us-ascii?Q?/kBSopg02zBTt1dtcvO/hi3DdZbiW5JZ/yBXTxXpy6Qiir3hBg0BGWGuuXZd?=
 =?us-ascii?Q?/hUKowsDIDC/+/P2k6Ry9M4iEKA/VRvJ5q7aCZcrYQHQNZHttWnzl9U32olG?=
 =?us-ascii?Q?QJvDTfEdt9dty32gxrICD6qC6ix/Idbbany5ead56MrykRT6GvXwlluVm0yc?=
 =?us-ascii?Q?MeZfOFVe6JsNzoBO4o+fPmEAGvoSP7MyN0Zksa/DpQ/IGLWdVPhraj4SjaLt?=
 =?us-ascii?Q?v+Kog6rYmRhhLnsWE1WTsmdDAlUes+MQL+OiL0lUo0JYkt11jTxEMt9fDtKp?=
 =?us-ascii?Q?xh1TR+xpicAj53FEPt+zpvhc3HJ7+gPbWVapkvNVepfa3RJekhI1cJ7YKcQy?=
 =?us-ascii?Q?3OoukL2LPzSte358zISIYKGWwmx3oy0K+GOvgLtMQiqYcGZ3bJ2mQsPAVG/m?=
 =?us-ascii?Q?v3QuiFWkqhYo3Kgm+VsxU02leG8UABdCWUEGOI7Mb3iJlzGcM8K3+UUZ3WsW?=
 =?us-ascii?Q?+XzZydqmHmbTL2Oi/AqRWxUVIGO+wBjEBUDZyBr5kHdbkda+/VOCCQRkqX64?=
 =?us-ascii?Q?CfGGNA+VzL8CSNR3m4RVgpiZh7awHfDMsI7vwz/dYY8OAmqPzk8PX+SU6L20?=
 =?us-ascii?Q?AOdsG9LsqZG7OHmXHXSpglQrsF3RuNStb5ytx6FQqRsuFIwwRiiWXRfBThHK?=
 =?us-ascii?Q?7E+SadpjyIpQqgppRPm5liEUfllBzEBm7IJOiaG5E+ge/aHOdfqT2BSzycA1?=
 =?us-ascii?Q?JOUV2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6517D4F55A8C0F4285547B3F6DA2AF6A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /lXQX5Kmmc/f0SYWMVKaF/bD1uepBN+8DxiN09vY2cE3uZu/pjVbjDUDsl91UsAqH90OrAaIo7IdHj30rwC00ziWs028rDzv2PuRWdVoy/rAin0pD+lGDXtD36X9bZb2dKosWHKQ7iHOY40lONhW1ZxUqbUEDazxopBCLHvSLAXB26xZ0mP2S3X11D2yfqySogMyUzQwWKjyhdIRD9kMsMblNbwBo1fzC5qVjRI07kOfcldrPVgo7E+IYtS0fMH6mEZFJH9ay99PddX+ezM15QWkU1xCpUlFcfKaokiZxoxKcQLBMXUpdlwcVU6kaxpk5xwmmAjmTICcNoD+q7Btt2LHwIgq3JWFQJLNO8RO4M8t+BzTvHh0MHjFTSJNY26Vd55ccq7X1SGIPh9lMFvo+daso66th9J5n2MHmRMXGVlheQN9kUsE7wAag/SJdsLNtiuk0DK/jYkXCVOAZ7T22f3lOppYpLUJON9T/qO/deiUGtle9Bn0BXVP47lhoMmECSZviRuG0hZTy3hVvuPkpyULm/XrC9RqB7eT63MdDiTmOrWaDvLjmEq1ZTIYU9D3F/qKs1Tc0STcoJokXzAiEVPmcDdRjc6PFYlXFpFjapt581bvOl2NzGXLSk7p+Q6CoZvsoyGGgw1GYlqd7xwpQ6M1Jhlbnc2PZpeZGtHOm4BZVE6xSrskdPoQhGe9FIdQSOLq9KR4t8ndCawbSXxn1mz07n1onB45ZUxzLJmNm2G3JWCQ7QZXlOp9aeFMX94XJCSoDXjRYpqZVPhIb/unNjnIsx8yN5qbKM/JGv+37DY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b250f034-d9aa-4ea9-8dc0-08daef7e33de
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2023 00:37:34.0863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: arJHh4yKZfJVp4ubDgPY4YmYfL0+W/mrk+fjC19MLYwsOTLcx4bEnjbtNXHecH0hCoL/O7WDbNSER0mnIuPKkkGVZ22/F9xcGT/kzN6LHDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_14,2023-01-05_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301060002
X-Proofpoint-GUID: nv43aW4l2lOqSLPcvS19qeqmS3UlGyW0
X-Proofpoint-ORIG-GUID: nv43aW4l2lOqSLPcvS19qeqmS3UlGyW0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> On Jan 5, 2023, at 11:47 AM, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> On Wed, Jan 04, 2023 at 04:36:13PM -0800, Catherine Hoang wrote:
>> Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesys=
tem.
>> This is a precursor to enabling xfs_admin to set the UUID of a mounted
>> filesystem.
>>=20
>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>> ---
>> db/xfs_admin.sh | 61 +++++++++++++++++++++++++++++++++++++++++--------
>> 1 file changed, 51 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
>> index 409975b2..b73fb3ad 100755
>> --- a/db/xfs_admin.sh
>> +++ b/db/xfs_admin.sh
>> @@ -5,8 +5,11 @@
>> #
>>=20
>> status=3D0
>> +require_offline=3D""
>> +require_online=3D""
>> DB_OPTS=3D""
>> REPAIR_OPTS=3D""
>> +IO_OPTS=3D""
>> REPAIR_DEV_OPTS=3D""
>> LOG_OPTS=3D""
>> USAGE=3D"Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature]=
 [-r rtdev] [-U uuid] device [logdev]"
>> @@ -14,17 +17,37 @@ USAGE=3D"Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L la=
bel] [-O v5_feature] [-r rtdev
>> while getopts "c:efjlL:O:pr:uU:V" c
>> do
>> 	case $c in
>> -	c)	REPAIR_OPTS=3D$REPAIR_OPTS" -c lazycount=3D"$OPTARG;;
>> -	e)	DB_OPTS=3D$DB_OPTS" -c 'version extflg'";;
>> -	f)	DB_OPTS=3D$DB_OPTS" -f";;
>> -	j)	DB_OPTS=3D$DB_OPTS" -c 'version log2'";;
>> +	c)	REPAIR_OPTS=3D$REPAIR_OPTS" -c lazycount=3D"$OPTARG
>> +		require_offline=3D1
>> +		;;
>> +	e)	DB_OPTS=3D$DB_OPTS" -c 'version extflg'"
>> +		require_offline=3D1
>> +		;;
>> +	f)	DB_OPTS=3D$DB_OPTS" -f"
>> +		require_offline=3D1
>> +		;;
>> +	j)	DB_OPTS=3D$DB_OPTS" -c 'version log2'"
>> +		require_offline=3D1
>> +		;;
>> 	l)	DB_OPTS=3D$DB_OPTS" -r -c label";;
>=20
> Now that xfs_admin can issue commands directly against mounted
> filesystems, I suppose it ought to wire up support for querying and
> changing the label as well.  Doing that should be trivial, and
> definitely an idea for a separate patch:
>=20
> # xfs_io -c 'label' /mnt
> label =3D "hi"
> # xfs_io -c 'label -s bye' /mnt
> label =3D "bye"
> # xfs_io -c 'label' /mnt
> label =3D "bye"

Sure, I can do that in a separate patch. Thank you!
>=20
> *This* patch looks correct to me, so
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>=20
> --D
>=20
>> -	L)	DB_OPTS=3D$DB_OPTS" -c 'label "$OPTARG"'";;
>> -	O)	REPAIR_OPTS=3D$REPAIR_OPTS" -c $OPTARG";;
>> -	p)	DB_OPTS=3D$DB_OPTS" -c 'version projid32bit'";;
>> -	r)	REPAIR_DEV_OPTS=3D" -r '$OPTARG'";;
>> -	u)	DB_OPTS=3D$DB_OPTS" -r -c uuid";;
>> -	U)	DB_OPTS=3D$DB_OPTS" -c 'uuid "$OPTARG"'";;
>> +	L)	DB_OPTS=3D$DB_OPTS" -c 'label "$OPTARG"'"
>> +		require_offline=3D1
>> +		;;
>> +	O)	REPAIR_OPTS=3D$REPAIR_OPTS" -c $OPTARG"
>> +		require_offline=3D1
>> +		;;
>> +	p)	DB_OPTS=3D$DB_OPTS" -c 'version projid32bit'"
>> +		require_offline=3D1
>> +		;;
>> +	r)	REPAIR_DEV_OPTS=3D" -r '$OPTARG'"
>> +		require_offline=3D1
>> +		;;
>> +	u)	DB_OPTS=3D$DB_OPTS" -r -c uuid"
>> +		IO_OPTS=3D$IO_OPTS" -r -c fsuuid"
>> +		;;
>> +	U)	DB_OPTS=3D$DB_OPTS" -c 'uuid "$OPTARG"'"
>> +		require_offline=3D1
>> +		;;
>> 	V)	xfs_db -p xfs_admin -V
>> 		status=3D$?
>> 		exit $status
>> @@ -38,6 +61,24 @@ set -- extra $@
>> shift $OPTIND
>> case $# in
>> 	1|2)
>> +		if mntpt=3D"$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
>> +			# filesystem is mounted
>> +			if [ -n "$require_offline" ]; then
>> +				echo "$1: filesystem is mounted."
>> +				exit 2
>> +			fi
>> +
>> +			if [ -n "$IO_OPTS" ]; then
>> +				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
>> +			fi
>> +		fi
>> +
>> +		# filesystem is not mounted
>> +		if [ -n "$require_online" ]; then
>> +			echo "$1: filesystem is not mounted"
>> +			exit 2
>> +		fi
>> +
>> 		# Pick up the log device, if present
>> 		if [ -n "$2" ]; then
>> 			LOG_OPTS=3D" -l '$2'"
>> --=20
>> 2.25.1
>>=20

