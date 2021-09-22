Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B244C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 12:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200046115A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Sep 2021 12:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhIVMJ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Sep 2021 08:09:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10356 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235848AbhIVMJ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Sep 2021 08:09:56 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MBcSZ8013132;
        Wed, 22 Sep 2021 12:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=CQcqpbkT+s+Ry5Ci2iJRIQnLrva68LL+0nJgkHSmbVE=;
 b=dkLmosvghwLVJzvaqYvTQ8Vs1pQt7tHCueRIrUuZvvL6X1ylqmQfbDXHEE2zlvnVs0l0
 8h/MkjVCDM3zV/cwRubncbTcpPA7IRnQbSu5Qab0c3CIiu+XeON7kiDVVOdWJYMsHGlO
 0+Vuj3AYMrXc49uARw9jU21bmCx5booM7giV7yITloSE/BaEoLyrjuXVnD077h2FBopj
 TwOLKxXyoLb7dUSVicT5lfZCCDS6qmJWglAmmdRj5mVYOsuCFMVO2wMsvLYpfVaLuHcn
 kAGK6XDi5PkJD1QLqe4lXwyfnrGjSyN/XaKvSBdEIcSF8KpMgx91B4Y4lQFCVBa7Upg8 Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4qkc0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 12:08:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18MC5dot144214;
        Wed, 22 Sep 2021 12:08:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3b7q5mum79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 12:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha/ArjHT8j4W9dOwE8dwT97sGH2lglkhvceh5KBpuIsb4sbe3hWNtKiQQrL+YU5pgJclKPov802d1rMURlw1+HZNyN9Hhb11OcTndDXZNc80nfhCcEZE3sde0RsPI4VjsIK3WNi1cNr00iWBieuJfWGVNfWeqsZH8s8uD9yyO8TJ7pxLpvBFUd0jQhz9S9JehFC5TRWTqr1IqJ7ADphtSfLw1X7t9oQUtVoARjz6iQJR0dfC2Q2m0B8GNPMhXHMrbw5OyLgsrYQRSNyhxYCLphPwi8Ui8RJESwhgNAlgRRe3Fee/C1Zimjp9yqks/zpu8vapaygUoUITdL6rmydPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CQcqpbkT+s+Ry5Ci2iJRIQnLrva68LL+0nJgkHSmbVE=;
 b=hLZcYee9A7CEB2JnHxf85w5tWH/HgFCOCuHq+ktJ9Kxd6Puzyann4sZa6uZv1lzbY2dQqgNYMzHgJGs1UkMX9JWoKZG8cpRZbDcTi5KtZSQg5nawvSw633QUqoV8gUL3rHdgLQ7M9Dno++vMKGjbI9S5NY7NwlRx1l536ZE9EtbXHw20ejqzqIOKsPSEsGDRLL/kLTFakuJN6hk5CfYnhncztm/9V5Fuy47uREl+GqkLuCiR4TBvFu0KwTkeQdDBGISet0c3C8NhfPY6rhBMze7WBJR2/4sV4voZartrU5aHSg5UNLXe4PVAXM4LR13pzGrWGws79jS3NF492qKI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQcqpbkT+s+Ry5Ci2iJRIQnLrva68LL+0nJgkHSmbVE=;
 b=HnjtuNMS/cyr5ci1DYTCX0dBPALWg01XKX1ZfBU0Mkj2NOsWr4sFPD9Z4dvrWO95lRwDGrEWhP49sX/9uDKCMMY5+WcpR90nZTHZWiX08eUwdhyHcdlej+C0PWeXmckMjaepc/kydjcZRkAZ2h7JtjpC0QoVDtoAj18vUaUzjlQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4505.namprd10.prod.outlook.com (2603:10b6:806:112::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 22 Sep
 2021 12:08:19 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.019; Wed, 22 Sep 2021
 12:08:19 +0000
References: <20210922030252.GE570642@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: kernel 5.16 sprint planning
In-reply-to: <20210922030252.GE570642@magnolia>
Message-ID: <87ee9gdda8.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 22 Sep 2021 17:37:27 +0530
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.32.198) by MAXPR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 12:08:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cb690b8-6b67-43c5-a07e-08d97dc1aa3a
X-MS-TrafficTypeDiagnostic: SA2PR10MB4505:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB45055968F14165E3048C4324F6A29@SA2PR10MB4505.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSXGSmwoeuSJbqa57UM7S8P3htZToXrU8/SNoMoCctr/wvDxlZvE9/e2sXPyUxsTMc1Jkpl2K/rH0YcQEVKOvh9NO7f6eDmNADOpmoQT96Lx488atMbCKmXzVfk3kremzoWyFWzw7s4n372fsBSPUt9WnMAu5RZQZvA47ZJlS5DzqNBUAxf0lWW64Fyac5UKnHWVZDllpPVTmmjGR6n/VcWa/B0fskWzvnebZMwCBbBjgkhqBrOxtf2cfc4dWa3UM/ShdPm6g2oObrGkpVuOJcFKC7r8k+4pNZb9irhkjPrXgK36e05mUp63efrPJIHUYcejlJS63QzscG+32l5g//8Lt/arplCNRDIrZCw8rMsZG9vZDvfKijLOjtHoo6RkPQuZUaChwsw/3TNqqjnd4AgE8dD+CdpU0NgxOxEh/ML0tv7O+DuE31HhN2wzKPKD+nUfvccuAyaOWidlLMuMLt0JoZ2bj6QXuYPQrxaaKXc3nmf9Q3dgwQrG1AMsCZQv1NueGPBumG8vahm7ZR4AnAOz0iHJCvC1MkaGvXFIwlU1aLPdS0niP0bdM/AUMxuZQWHbSf40TY/k7sO5JAFxG5ZulA5tgfY98Q6Y/Y+m3Fcq//SgGIUIOd5V5aLlkiRJSJKdu49nhMMGLXQs3eReaJK38h9p/wL40MvxGM9BDa0mAzdxAJADLdzoqOYTT9fQLL5gKYlaWcj4a4Jfj03CXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(6496006)(66556008)(5660300002)(6666004)(8676002)(508600001)(66476007)(316002)(86362001)(4326008)(66946007)(956004)(7116003)(83380400001)(6916009)(53546011)(26005)(54906003)(8936002)(6486002)(9686003)(38100700002)(33716001)(2906002)(52116002)(38350700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GzxqU2A2vZxA4V6uU6P4r8l1cLPoEdA/OL+hmsuvo8m52rSBbezma8nOpTHb?=
 =?us-ascii?Q?FNHZ4AE/35zjBeReX01mTtn5/unraztCxnepksbvcLXCjmu0/nuRC//8sjnm?=
 =?us-ascii?Q?K7nIfVjtNQOjklG9/wgnTVsTEjurfgJ+0TPQGaQF9gsaA2gbvrDe4vGoat9t?=
 =?us-ascii?Q?KZk+2c+dwXHVKWyJnyhAtcT6hWOkMvjN3Ej3Av/Zamh0bRvsLXvnNv7cLvi2?=
 =?us-ascii?Q?yZw92bgTkyAt1pU67QwHKkUrRsv/k2UTi5o+4V8B9wMBOOrgwS89Ow2IegcG?=
 =?us-ascii?Q?HFAYBJv5BHiqFM02kGWh5ZFHWjC7NRxHT3pWvUhdNY9RJNGsF8n+HRX9blIg?=
 =?us-ascii?Q?Qr61E64xQf1r0o6yvnPnRdPBjXBAo9VmbZZ629wdW5FCmQV21ZDLYEmHGohG?=
 =?us-ascii?Q?nPT+yX75DRfnTfos0nhIMP+ULkjgqQ3peKKU0nQgFpKCFvGMCQZKuYtRXFwW?=
 =?us-ascii?Q?AofGQ/PwjT5E+j2wlFdAOYdmEdcLkfJDliia95sKE1hvoZu/hBoJ3HP+naJo?=
 =?us-ascii?Q?WjkfyTYYPI5TC2AAaG8VxU6+jGTzZVzzT/UT8wopj7smLp/izEaPqD9E5FgH?=
 =?us-ascii?Q?fBnerTbSU4V6Lm7qKvMVjPRhoUUqeWkYj4W7YQm4Qsx1LUWPXBJuEKIoRqE6?=
 =?us-ascii?Q?pfJvkJmIiC1raK0F40ZtlrgSs9czcND/Jn1H/qpry7mJ7zLiTDuSGG772W8w?=
 =?us-ascii?Q?S8mTn/XKJ+d12eG8hiE6++A/exVJ2vJLuhOYX2HtfmgjWuUiePoq2T0myE2z?=
 =?us-ascii?Q?sOX/qL2MV/jHukXz/Pr1FCHSY/rc0aeaAp5CkN/OtqKcMtmH2Q92bvvDC+Et?=
 =?us-ascii?Q?DpbpPj3CKrNilGtceLTPAjSgDuAwrmaByscMn8lt3dFr+VLIWUDsZIB5fByr?=
 =?us-ascii?Q?bstO/qxnAPUPlFgkUieSw+BI1xBD88Vgq0DqS/V3SPPkWrU13ExDOHRF+AaE?=
 =?us-ascii?Q?T1dzTHyDErBojRmShc9/FHGNDGjKwJz6iWFV2LE8UHl1qlzPVYUN6m60gZaS?=
 =?us-ascii?Q?Kp5IfpQ9WPyv9eVbk9AvlIelBsw874ttDYTHYUNLOtxMyEv2jVfXeQrVuk9e?=
 =?us-ascii?Q?gFp1D9IGf2EFz8tgfCAj61OrpoQReu2GCFXLEhDpxf9wJJM/MFbiiuWBj2Ji?=
 =?us-ascii?Q?gD1l0X/5JMh1Fief/eK6eiRJdU1AeQgBM+okmx389WHu2FqdNaXAVWfV5kLD?=
 =?us-ascii?Q?4nDeY+o77PbDDkpeS7Rh52oJkyA5QIi+T8tOrOyPnPIhXTMuSHgKBuPt5ZSV?=
 =?us-ascii?Q?zAeOSpvkD0RL7d5WKTfGlrqf6ndp3NEF8SrfWXkt8ZJCncRLxCqYQWOltevC?=
 =?us-ascii?Q?9gY4tzxrCdsW0NVrybGRcAPM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb690b8-6b67-43c5-a07e-08d97dc1aa3a
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:08:19.1946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZLdwjd36Xq41E4k1XsQLnMY78Eqt9QOAI9hExiCYkWCFkUL0Cc6VXMUf3fpbbVyYWrGnSGnP4kIqxCMcHT+Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4505
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220086
X-Proofpoint-ORIG-GUID: uwQMhcTr-fTq8v-EfYvvyUs7-KNYcLW3
X-Proofpoint-GUID: uwQMhcTr-fTq8v-EfYvvyUs7-KNYcLW3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22 Sep 2021 at 08:32, Darrick J. Wong wrote:
> Hi everyone,
>
> Now that the LPC fs track is over, I would like to take nominations for
> which patchsets do people think they'd like to submit for 5.16, as well
> as volunteers to review those submissions.
>
> I can think of a few things that /could/ be close to ready:
>
>  - Allison's logged xattrs (submitted for review during 5.15 and Dave
>    started playing around with it)
>
>  - Dave's logging parallelization patches (submitted during 5.14 but
>    pulled back at the last minute because of unrelated log recovery
>    issues uncovered)
>
>  - Chandan's large extent counter series, which requires the btree
>    cursor reworking that I sent last week

IMHO the following are the dependencies w.r.t large extent counter patch
series,
1. Any objections towards the approach taken by the patchset to allow
   upgrading older V5 filesystems.
2. "Btree cursor rework" patchset on which large extent counter patchset will
   be based on. If you think btree cursor rework patchset can be completed
   quickly enough to give me time (which shouldn't be more than a week) to
   rebase the large extent counter patch series and test it, then I think my
   patchset can be considered for merging.

One of the things that I missed was that bulkstat ioctl calls made by libfrog
had to check for the presence of XFS_FSOP_GEOM_FLAGS_NREXT64 before including
the newly defined XFS_BULK_IREQ_BULKSTAT and XFS_BULK_IREQ_BULKSTAT_NREXT64
flags in the bulkstat header. I have fixed it now.

>
>  - A patchset from me to reduce sharply the size of transaction
>    reservations when rmap and reflink are enabled.
>
> Would anyone like to add items to this list, or remove items?
>
> For each of the items /not/ authored by me, I ask the collaborators on
> each: Do you intend to submit this for consideration for 5.16?  And do
> you have any reviewers in mind?
>
> For everyone else: Do you see something you'd like to see land in 5.16?
> Would you be willing to pair off with the author(s) to conduct a review?

I can work on reviewing delayed xattrs and associated patchsets (e.g. Dave's
intent whiteout series).

>
> -------
>
> Carlos asked after the FS track today about what kinds of things need
> working on.  I can think of two things needing attention in xfsprogs:
>
>  - Helping Eric deal with the xfs_perag changes that require mockups.
>    (I might just revisit this, since I already threw a ton of patches at
>    the list.)
>
>  - Protofiles: I occasionally get pings both internally and via PM from
>    people wanting to create smallest-possible prepopulated XFS images
>    from a directory tree.  Exploding minimum-sized images aren't a great
>    idea because the log and AGs will be very small, but:
>
>    Given that we have a bitrotting tool (xfs_estimate) to guesstimate
>    the size of the image, mkfs support for ye olde 4th Ed. Unix
>    protofiles, and I have a script to generate protofiles, should
>    someone clean all that up into a single tool that converts a
>    directory tree into an image?  Preferably one with as large an AG+log
>    as possible?
>
>    Or should we choose to withdraw all that functionality?
>
>    I have a slight greybeard preference for keeping protofiles on the
>    grounds that protofiles have been supported on various Unix mkfs for
>    almost 50 years, and they're actually compatible with the JFS tools
>    and <cough> other things like AIX and HPUX.  But the rest of you can
>    overrule me... ;)
>
> Does anyone have any suggestions beyond that?
>
> --Darrick


-- 
chandan
