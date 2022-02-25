Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8111EC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 14:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiBYOCR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 09:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiBYOCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 09:02:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659A8FD08
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 06:01:41 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PDIngg014031;
        Fri, 25 Feb 2022 14:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=ObyCKY9Rb48QwkpQhuU0GHMEEsRoomuGqpLYkAvVkt4=;
 b=hJihF8ypxwZCjCyei7PQPhsUg3LuFLIBVPgEjglq8s9U3OuTDanX0SX5j3dS5morZuLp
 7WKXvi9q5TW7dqA3jvEBPhBu+Lz4NAtmqjFih22KtfcaD6Di5a7VgF/BuNzqAIAzCfbJ
 gp+JVCOUeWsdv3IdQq2d2pyQfYOLTo3jJLM09gHgl+CTM3D/tO5DkC2qmVMKFc/6q3EN
 1xD7jE4YTHAQ+RiL0OsnbqlGNGplI9lbWwhW9wCTy5u99wAv6mP6HdCrIdzxRwKsbN08
 D3iZKPsJgEGc0yRKWj+eOKKvPf0fa7vruzzM/H86q54a/gsuJ2gv979L3g1Dd8WfY7hF 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eey5dgqhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 14:01:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21PE0b4C175928;
        Fri, 25 Feb 2022 14:01:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 3eb484wd78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 14:01:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ujj5K17eaDkUT2tY9zJ8fkWeyqyqxHMEUN4XG2akeIqtKuG3bJKSTGdcAaNYV60t/FuEnMX3TZSSAVOfCKM4cbeQUsZe5y3P7hrI2VbdNydLbcvD2cgP/147uoI7RE4m50kSyNHLUSISsDwf6zolAGNqP9DS1lsVKi1+rHBAeDIiJROmoRttmVHeNBCm41zkigSTwOnB4ihiypOUC7UWix7sdPsYEWODrCAzu9tKVIo+TpJlJJpEZUuiy9finMBtOjegtPIhs+pbcVmr5XgSaehR3z9OLxuHEZJsGdVmOUA1J3gHWHMVE8jBBvqkaE0xm0CO2egLZzVqpN60GabEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObyCKY9Rb48QwkpQhuU0GHMEEsRoomuGqpLYkAvVkt4=;
 b=NRK+LyYkYr7UD5hfhPA71qqtan4nK/xPqXZAwynfm1evGe+8U4OOJjSlqOH3dL/u6WhNlV42ZSequxKJZdSdOQF+ewx8pq7DMmy7OKuQGkcQJUXGdJ23FitpXt0LDXrTtORJi8H2gphSJw5L+jwPBlgHuVR0/okWY0EeUi193D+UFtEamZyJxoEZTbKoB6+qqoGhOHeaISSJOKaKSJYKmx+JZ7yPFjCcqY5hi8ew/aARC4r3T11TyK3bXlARLekuPWEELbgts8HT9y047Vevq6yE/C5ZCn95gX6WJ9BOiI3E8boH6Z6ILQOcE4ptd2bk0czwmceiTvY5mb1HxJgqtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObyCKY9Rb48QwkpQhuU0GHMEEsRoomuGqpLYkAvVkt4=;
 b=RGNLvwgyBz6xwl6VaFa1P0wcWyKI5grmxBLGIWWn0UvGAo8PI2l4jzuOsNtXObqy4UcPGP7DsnJ033NjP25wKnDhZIbOJgYqILZQkyeUJ6Aq/gZjRgeLNHbOND5q0IgcNEy52C+YBLYdKd3uio6zyVhpkxxojevGUjKayujStIM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1780.namprd10.prod.outlook.com (2603:10b6:405:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Fri, 25 Feb
 2022 14:01:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 14:01:27 +0000
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Performance regression when large number of tasks perform random I/O
Message-ID: <87czjb9haq.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Feb 2022 19:31:17 +0530
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SGXP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::22)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c804d6e-bca5-4e9e-85ce-08d9f867509b
X-MS-TrafficTypeDiagnostic: BN6PR10MB1780:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB178075EF1064C3E41EE8028EF63E9@BN6PR10MB1780.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RQNTGXpxiU7BsEUTaqeIjwlxx1eQPYy8EKiir5vZzsuOrtoQDsvbrgLCYDtUr02sCYfyJkc/RhboI+NzxlnK8/jx22Oc9TDPqVxEegW3VZaBLMF84863gUnjov28E7G9omnW5UrjDv5fUyi9l4VtBW/RdAGD8vVjFo4lSgk4CA+e3B3MDqEFJ5iptdjvOGmsIFjBEDpdadZmTIkOF15R5D9tKrPf8aPHmtzXxfGObcg7XfpurhwbsbhtA+Bm2iHvITL8/gFr0Zz3GjzD+P3YSaLKZmZeQsimpEU8RLRwViJP0NZ05JTirGXqhAL8oAP/QlfouT2uhpUwHR/DCLP8Mkg1zxfmvLVFC8sT0/fR7PNW3Dx9T5gvzWh1l0QUIDz7+CCPMfWgTl3kgDB4YAfzPKyRlvEOOaKoM0M0+cTGqbkNu3MLAYBmY5nERNLic2uO3+BA9uGF91JNk01rzHeAk4cTziXV1GvZHZcs7q+l+da+5p0l++sPz1urf9dltpSiSKikIsunltirTiCrPj1uBZ52a2TYHUFdWdSOBGL0jpjHQKy35oKvIxG1d/FMLh0r0e9RW3jlbS5muUjXys+QCcE2ou+R/P6OwHqHrJP2HZtlfynyXTCOTU7P3Ym3ih9xeX85vuoPAF04bf5fnAUP7xEFTrVGQMTxQkGcyfgmgoYvxaM61tJ5s3p8aEInaarvxyvBdNWELvCsV3JPk856N4ERolOASOht2BODQdWsbLa3VkjBn84mM1KCpPjRirz8UJGyqKPnqe3avnIkJZlKSdRT2ekWJngsz291q4ji74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(6512007)(508600001)(6486002)(966005)(186003)(9686003)(2906002)(316002)(38100700002)(38350700002)(26005)(33716001)(86362001)(5660300002)(6916009)(66946007)(66556008)(66476007)(6506007)(8676002)(4326008)(8936002)(6666004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHJ4NS9UVUtsRTl6TGtsWlFNUVJsT1R0bS9qYnY5dTVHQ3ZVdmR0UjJIcksv?=
 =?utf-8?B?dGg1YWtzN3h1QmU4YmdtYjBPVnRid2t0ZUFjcHlmcTRFQ2Y2eGMvMmRzSkZl?=
 =?utf-8?B?Uk91YzNvOGJuREllcCtEYnJUeTZkeHhRM1o2dzdpSjZuYkJxRHJWVDR6aW9X?=
 =?utf-8?B?VERqclRSaTlPaW15NCsyTG9yMlIwbzZMYTlHcEVLcG1kdnZjSGQrOGgxcGc4?=
 =?utf-8?B?NVhoZGhXTDdEeUZOUS82MUVSajlGN2ppejhCT20yd0VNNHBhVzAwQVE2bjMz?=
 =?utf-8?B?ZFdBL0RaZitvZ2pFZjllNjVKWEF1a2hraDRKK1dQZDdyNU1vd0E4N1YveXNB?=
 =?utf-8?B?QjlvMW9zWTU0Tk51czhpVTYxQVNYcHNISURHYmdFRTZZaGxNeUZIbHh3NGt0?=
 =?utf-8?B?bnRBUVk5ZU04YlgreGJrUThDQjRxaHhMbmw0a0JmQXlLWWpIVU1kNHBkN2V2?=
 =?utf-8?B?S1EycVUrazJ3SEk5ZHkvRzB4NXJNQmdrbGdjcyt5bXYveE1jY25pUE1RT0t6?=
 =?utf-8?B?T1NhSU9BWFJGd1c0b2JpWTVwckwybkQvcUYva0RFcnpDbUJrSVozbVBKZnAx?=
 =?utf-8?B?Vjl1bjBPQWhRVGpEWVpaN0JHSjhVcnJWTjYrdEZ1eXBsQ3RFbW1zV3ViMFNJ?=
 =?utf-8?B?ZTNKNXJFK1BudS9zaHhHNDhvTkZ3aUtWU1JzQWZRL0w4TXdtVlROTm4rVk1t?=
 =?utf-8?B?YVBrc0RJUW84K2t4Q1phdnBrNXBnMEg3NEFYc1hKcURLSVRLL09pT09jb3NS?=
 =?utf-8?B?OHBhbFUzNWE0aVVkb0dpeGl0RkdoWU42TW9tTUVEa0N5R0tCS2JNK1FpOEhH?=
 =?utf-8?B?Zy96Y0U4bGwveXVXeGNQaUt1TjVnRXptYk1qNGpjUyt6K25idFkwWXBGTkNy?=
 =?utf-8?B?YyttdlMvMUVkT0JRTUlFOUJ3T2tsZ2JJQVZPUEkxTFhFRVlXYVUzWVBKZVVt?=
 =?utf-8?B?Qm1IZCtsSnE5NzJ5VXhsS2tJY0h3VmNHWGdNTWFRVmVLalZxZTFnczZRRFNB?=
 =?utf-8?B?OS93emxiVHJTUHNYZDlPM1ZRYmhZSW4wbVVJWkc2bitjc2k2VldBa1lwTEN1?=
 =?utf-8?B?dnhpK3AwVlgvTUtUQ1FSSStwV2V3Wk91UkIwMlBXaW5LM1BGS0VqVmtEV2Ry?=
 =?utf-8?B?YUtpbW5teFE3QW55WFAraCtjNmsvZTdDMjhrQkZ5Y05MQmtBU1dndS9MWjMx?=
 =?utf-8?B?RlNyYWlZUU5iOHFxM3plQWtIV2VKNk5BVCtNM2hiZzFpZWNEaFp2ektpbXVX?=
 =?utf-8?B?WE5hK2tGUXFva2VyQ3FoMUNudnFRR1V3bitjT3dIWXgxZjB3aHpOOGZHdXZV?=
 =?utf-8?B?d2hJZkVuNUJaQVZkb3Q4VzBaMXdqeU9JeXVYV3FOQ3M5Y2lPam9veEdUaDdz?=
 =?utf-8?B?cmxoMVdSMHVoTjJDSEEzb0ZMeUVYTFJOdVk4ajF0SjBqNks0THd2cXhGMlZB?=
 =?utf-8?B?T1NkckN0Y1dtNXRCK1dCRFA3M2pyWEZUMVdGN2lGbDh0YTNDa2JXQnFsR1Zs?=
 =?utf-8?B?MysrTjZkcHd4b3hzbTZuTWNSaXR5R2JKTWsrYXFlSEMxYUJGSWFiSUFaS01q?=
 =?utf-8?B?UTF4WDF0ZFFTUXVpK1FNSjBwTXZ2aFp2SUFFT0tDNlo3Wmw0d2xYNE95VE5z?=
 =?utf-8?B?OUlrUVpyR29CWWJ4VGxUc1BpMjJ3dzBkYkxONkRLaEpES3kxZWQ1SHY5Q09h?=
 =?utf-8?B?aTllVDV4d3U4REFicUJteGxia0hveHJDdDBGQ1pxY1VMNUtVSlRFMGtFU1JI?=
 =?utf-8?B?Q2FDQXB5OVF0R25TZUJTRCttMW5SZjl0S0NlOXJoT0M5blU1ay9tTk1jQk1k?=
 =?utf-8?B?WGIrU0xuQXZCaGF5SDZxMWZSY3phYzdBdk4wcy9UZWYwRytMUkRiWDluSXAz?=
 =?utf-8?B?YnJSYzhRVmtYUElHaFkrSmozclljOE9sYjBWck0rZnpYZXFqaUZmRnB5ZXNM?=
 =?utf-8?B?NkY2UXE0SmEwMm5MNURKUmxSeTdwSnI0OTJWUkpUSXl2OVJTQ2hLeDVoNmVU?=
 =?utf-8?B?TkQ1Q0llYzhOSFBybWFGeEY4aXJOTyt6a3ZYbmVoeEhla2Fhd0xIdU5VbDI4?=
 =?utf-8?B?bm5IWlBYL1RONnhVREdxWEN0OE4wajZwc2tNNTJpTElCd3RhMWdtYnJiRW4z?=
 =?utf-8?B?ZTAwL0VxRFpZL2lmc2Zoanh6NUQySVFyNys3Nm5jb2hzTjNXRlRYREJybHFx?=
 =?utf-8?Q?QYZvMDEPKPZAQU3ygaT1Xbg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c804d6e-bca5-4e9e-85ce-08d9f867509b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 14:01:27.0762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJyr5cRjgwGkWHUdPlNvtZGgyE/SHENM7GmeD8SJrd7VRQcebHav5A0mMJfAoHs5NXLxCpiTHTTMBu724IRXWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1780
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250082
X-Proofpoint-GUID: OpOKg7q8pHLw5dB5nW9fJjXggWrxga5p
X-Proofpoint-ORIG-GUID: OpOKg7q8pHLw5dB5nW9fJjXggWrxga5p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

When the following fio command is executed,

fio --eta=3Dalways --output=3Drunlogs/randwrite4k_64jobs.out -name fio.test
--directory=3D/data --rw=3Drandwrite --bs=3D4k --size=3D4G --ioengine=3Dlib=
aio
--iodepth=3D16 --direct=3D1 --time_based=3D1 --runtime=3D900 --randrepeat=
=3D1
--gtod_reduce=3D1 --group_reporting=3D1 --numjobs=3D64=20

on an XFS instance having the following geometry,

# xfs_info /dev/tank/lvm
meta-data=3D/dev/mapper/tank-lvm   isize=3D512    agcount=3D32, agsize=3D97=
675376 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1
data     =3D                       bsize=3D4096   blocks=3D3125612032, imax=
pct=3D5
         =3D                       sunit=3D16     swidth=3D64 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D16 blks, lazy-cou=
nt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

# dmsetup table
tank-lvm: 0 25004900352 striped 4 128 259:3 2048 259:2 2048 259:5 2048 259:=
8 2048

# lsblk
nvme0n1      259:0    0   2.9T  0 disk
=E2=94=94=E2=94=80nvme0n1p1  259:3    0   2.9T  0 part
  =E2=94=94=E2=94=80tank-lvm 252:0    0  11.7T  0 lvm  /data
nvme1n1      259:1    0   2.9T  0 disk
=E2=94=94=E2=94=80nvme1n1p1  259:2    0   2.9T  0 part
  =E2=94=94=E2=94=80tank-lvm 252:0    0  11.7T  0 lvm  /data
nvme2n1      259:4    0   2.9T  0 disk
=E2=94=94=E2=94=80nvme2n1p1  259:5    0   2.9T  0 part
  =E2=94=94=E2=94=80tank-lvm 252:0    0  11.7T  0 lvm  /data
nvme3n1      259:6    0   2.9T  0 disk
=E2=94=94=E2=94=80nvme3n1p1  259:8    0   2.9T  0 part
  =E2=94=94=E2=94=80tank-lvm 252:0    0  11.7T  0 lvm  /data
 =20

... The following results are produced

------------------------------------------------------
 Kernel                                    Write IOPS=20
------------------------------------------------------
 v5.4                                      1050K     =20
 b843299ba5f9a430dd26ecd02ee2fef805f19844  1040k     =20
 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b  835k      =20
 v5.17-rc4                                 909k      =20
------------------------------------------------------

The commit 0e7ab7efe77451cba4cbecb6c9f5ef83cf32b36b (xfs: Throttle commits =
on
delayed background CIL push) causes tasks (which commit transactions to the
CIL) to get blocked (if cil->xc_ctx->space_used >=3D
XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) until the CIL push worker is executed.

The following procedure seems to indicate that the drop in performance coul=
d
be due to large number of tasks being blocked.

1. Insert the following probe point (on v5.17-rc4),
   # perf probe -a 'xlog_cil_push_work:29 dev=3Dlog->l_mp->m_super->s_dev:u=
32
   curr_cycle=3Dlog->l_curr_cycle:s32 curr_block=3Dlog->l_curr_block:s32'
   --vmlinux=3D/root/chandan/junk/build/linux/vmlinux

2. Execute the following command line,
   # perf record -e probe:xlog_cil_push_work_L29 -e xfs:xfs_log_cil_wait -g=
 -a
   -- <fio command line>

3. Summarize the perf data using the python program available from
   https://gist.github.com/chandanr/ee9b4f33cb194d61fe885bc7b4180a9b

   # perf script -i perf.data -s perf-script.py
   Maximum number of waiting tasks: 83
   Average number of waiting tasks: 59
   Maximum waiting time: 1.976929619
   Total waiting (secs.nsecs): (38.550612754)

--=20
chandan
