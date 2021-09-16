Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54F1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 12:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADD460F38
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 12:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhIPM00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 08:26:26 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11914 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239539AbhIPM0Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 08:26:25 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GBUCYr008855;
        Thu, 16 Sep 2021 12:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=T6f6OBGJb/u5Xkz1AddpZpUI5BuTL17zkggywICM6OU=;
 b=kHCh1zxZ9PIJg+YKLnCNSXGhsf2mi+OqbbhjDMDgkIDc9GD9Nw6bQ2dB0gQSlW31lWkd
 gbK/QiTJEQyofo1bFzRRpYIeE0OnkL6yYSrbuYm8uvoFvnzgCeuMrJl88elLhPXW06S3
 +vL3tZ9kyLxf3mBrDQJZO5NZGu6AYm503ZPYraNGM5bE/6TCSYjNRx0bbbEHnUoKdFf3
 /W0qvIqTWkap2D7npb+wN2YGKXCi9EwI9Fsl43t3BIJ2nFSJ7G4SHpOyDFlVgO7qj5tB
 vyy1LIjGTMYQO+j989uyl+nLUFFjjin2UR53arFS+VSj49m6sthrwnJHkWeGHAdZfjtO Zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=T6f6OBGJb/u5Xkz1AddpZpUI5BuTL17zkggywICM6OU=;
 b=fP1rCebi9GrooE2GxxM0o/IKB/Of001eKO4zVi5sM+iZOsnVDN9NEEQauFKo56Wt3eBA
 lco7zzflXqOVspdpgFYU9TXPcwXfzGza+S3OGJnn0Mtr+/8x6bHWIQAjfALpExuP79su
 C+aJnP2C9WlH1JZLmIxtVKafEB/yEuAuoYtqMEZFt9Uwqz7pRpZ/zeX0mI6RN1PT6CGr
 Ss4hXyQI1mr/dRIwY7XL6J3c2/+B5LOQW1PSTY2Ce1Hqe51D41u69NFFy4pV7XtP6DBg
 BiM5ajiBK+Ny+BJF2ULykgZHlgudsvG+k580V19hBn2aqPj2nQyPh2FCWtBrBxx3odrq 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3vj11kgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 12:24:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GCFhgF078540;
        Thu, 16 Sep 2021 12:24:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3b167v4b0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 12:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWLMQEjJ9gyISHZ4tLF4otqsOEoDqKSKE31s+faS7ZAkPvY0gaHZmcHN6k00qufr3k7idq/GG8IxnmWBqA0/RHk6SPZZT3nzi8ANhPB+NE/4X04kqKHoSibpxRdtRYE+2lm3D/E70ruRdHpst8h730f/37/fNqI7D9cWFLixvvOwrY168FC66PWaYw6INIXv7til/vssH7orQEjMmPQXZdZtAnxrN0ksqBOgIbRm/tUUy4g4jfuEVY7T7WTBYwpJIZDSuyqvYpmaJ/O9KAtQG72CQ19b3rQk73stgEc5FpI3nUqFGZ/NhjZ+mVuY1/W5U9W5E2W+XrSMT4GMtcDeeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=T6f6OBGJb/u5Xkz1AddpZpUI5BuTL17zkggywICM6OU=;
 b=KHE7OfGXBpNcbfqAUWk85oeWkmMDZY7YqhMDIcaHn0C9B2tFvhvKmoRANfQFD4bs4XISA3uLJQmE+saeO4clI9ZABU++gVJeK4o/m/asb4Rlx0WWjFtz95W6PglQl4c1JwxSfAEWmn48wN5BxFoKEZGlmlRlotz6ttXzc8BUEkbIDpPtagvt7OqWSjQ4eISumXhAcpJwhd+E6hCwl7lTBiyoYAHEn2Di6p5PFXtYe77YL/eb4rzuWfdEUscUan5tAlmoRtEFWRIinMr/mNExxleWjZL5hqMqnBDA1JeIME+A15G8h0inQuTRNjnjt8sN/f1Yu8on5cWfd5XJ1AOzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6f6OBGJb/u5Xkz1AddpZpUI5BuTL17zkggywICM6OU=;
 b=Lz+ORReXmhHrS9+3xYZYKM/dzgtN2TLBRRvgRTDE3QKaMpxZQfkFNorcmQDz3fk2H8+KwsQPqfhgEWErvtFzjVlTwiJMgnLdD/h+QeAP/p75Zvj4qqXVilke8lECl7mB6OB4PQijUs1uHvVgyEreG0QzEicSeYV74nUDK0OykoY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4620.namprd10.prod.outlook.com (2603:10b6:806:fb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 12:24:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 12:24:16 +0000
References: <20210916023652.GA34820@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Bill O'Donnell <billodo@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [External] : XFS Sprints
In-reply-to: <20210916023652.GA34820@magnolia>
Message-ID: <87ee9oaeu4.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 16 Sep 2021 17:54:03 +0530
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (122.171.167.196) by MA1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 12:24:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d12d3d0e-70b0-48d8-6b3f-08d9790ce664
X-MS-TrafficTypeDiagnostic: SA2PR10MB4620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB462050A08524A7C29074E94EF6DC9@SA2PR10MB4620.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fj093OoFmLZQVoz+XrQaF8c+USXmnorGI/w0hbscbCCQQZwCDjykvJwcLSj96I+2N+rjuvW9XBTY3gfUVEHYaLRhpSMAtvi8tU6xTEyJYJjhxU+u6VEJc7bDMyHcqY7BioJ6Cwesm3i30UhDuw8kiXlJcp53sXzdrTdY34FxbMZMnJComgYdhYiHFFSUotIE7H1rUAD15Q/3sk0S6qW1QxQkNF8pi2rwbgoZN8FiTtRHto9skXU0byzjZosPyK6IHmqfbaRg4xyBGbYK5vQpmVViW5DlplK8DBjhQ9EakjS7GHRxIz4JCOZ9R4bmAGyuv2bizVJqtB9I+gIUIg0wM7ezLZtzoerP58pJybyS0vYnDwNYo8G4mOUMg/2GIMqtr7n9352i4131eKNuGLE+F6CY5xtRQUcnQiPkUKAizHIZ2lyiZ4glFrEDEh6UObj5I44Y1xj5st674bogpETQ2U9SXsrgmWc7/DuiOgpiudCvSqF3bNVT9tiP0r0kWTTd4tn5FxsAmyUPP6GqgrrwJk8WzOacB5gDlpzJAf/nUMDLZucJPA2vr82NAG9gkq88QbuHGos278xHjtC5RZpkfjkVXWcVmDMMEKHkJX8gTp8QJE+HfU+Y3RARzqucueamveXNVU7J9jrA+CivoK3zpqiFt4ZPT5HYXMJYDMfae2rgl5LG3oF1UyLy9uTxOXqI/xa6KOz0CAdM3Fbbz7V/Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(186003)(8676002)(66556008)(8936002)(83380400001)(66476007)(6916009)(4326008)(86362001)(52116002)(9686003)(6496006)(316002)(508600001)(6666004)(54906003)(2906002)(26005)(6486002)(5660300002)(7416002)(38350700002)(66946007)(38100700002)(33716001)(956004)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hevA7egJJCh9gV8kzIcE5LeuUnU98qzOq6PvZt5qW4tyCGFmQ3JG1OmeISpg?=
 =?us-ascii?Q?vZ06TJqmMgy+XoSJirSeGEY7vhQQsuEfPZcf49RC3/AAp+w7L/57unE96XqD?=
 =?us-ascii?Q?16/9Cym+FK1X6jfHXUwHydtOMkSehveL6Js6WbTmDUOvC4hsuDY8Dksw9Fa9?=
 =?us-ascii?Q?fojgvNrYvPDW4EWInm/i6+ZUiv9qlSBPWR5umGy9WtWQgfI2EFEzVcDt5url?=
 =?us-ascii?Q?APkW+YZSYo1ZLbxYhErjwXLvqZxHdSQywI0QgNtkdIN4TTwIpI5ta6QXfto6?=
 =?us-ascii?Q?A0rfA8hAfj/9OUQCVUDD9isocNEt2bLFTs0piyID8Fcdfeu8qrXg1IBFdShK?=
 =?us-ascii?Q?zSxA5Kef+wADLQ2AIXqtmqGkCjXH1Fd5FyZMiC5UfkjENqyPiOdn0kpy1H9H?=
 =?us-ascii?Q?jgukhUc2GYi9dmQ8AFvDuwB+kj70bHuPEyRnnDV9iWLaUDqZoM8vQYO3RZvW?=
 =?us-ascii?Q?j/dG2d9BuZxrk7eAfVEonbsjNLUDf5+RJuNZ01Qc30416Vwz4BDJkmauEa9o?=
 =?us-ascii?Q?qWakqrH9t1ahbG5xUFUx/Z9BFAlGEW+s3Xa4bXeBJqznZURw2c96ZBfQoTm2?=
 =?us-ascii?Q?KU+m4JPeLFkMhpzjwEbwc+prWQS6qsUcjB5ch/zIYgRqGVJ5MDn96Kr4LxOL?=
 =?us-ascii?Q?WR3BPvODXygUU23Tpz+wXSRtiDtbntv2WGgTjtRmTMMUABxB6ra2MGXSe7Gc?=
 =?us-ascii?Q?psgvWGrFMHDXZfDKKq5TmGGUrIAW3RKcBcNBDRfkBAWRWAO80qcOz7V7ToGa?=
 =?us-ascii?Q?7emD/GauEpgFFap80wuB8pTRNNSbVNV99+vAFduhjcl1btTFTM3Ja6X03vba?=
 =?us-ascii?Q?6c67ZfzK1Q9Bag5cZw+16t6TJDzuDVlnfTC2yFZv160bOgB2rTAXX2/PHnGg?=
 =?us-ascii?Q?FjTHwo9v/H2PM2Q405ArODEmFnPMwxhxqR/cAUbj50IWVzwcliilK5X0vq7i?=
 =?us-ascii?Q?NpF1RWtAF0jWrtu8LaYYcVPPs3u7ajpOCYLYqNwSeUpAHsvnJMqNRn7Wmsy2?=
 =?us-ascii?Q?VRblRLyQhon8BmycbpSineqqmeAHoglqhTxnIQEFpMXLnRoF11ebhYVnrFJf?=
 =?us-ascii?Q?GyOsLlrgw9gSSlqXu5hHGQnw2nTKImd390qN+nK5ydWzeZaYVJpSMo14qX85?=
 =?us-ascii?Q?0gOElMtE3skGcquKln48hF4+s89ZZdLHLk2aDD+RjiNyFxwuOreUNMkTB15W?=
 =?us-ascii?Q?6Ze70E3jKmrM0mUj2u1RoO66wBG2LjeQHvEEpNI103HM8x+M6H18gzaavEBZ?=
 =?us-ascii?Q?8O/J6bSb2uTT5qIVJr+4N1wG5hwSX+SlBY8PPA5pQbOxoirxwiiOaKpdkZsJ?=
 =?us-ascii?Q?Trmp7/C4EnZZy8hP8xPPYrOXYQqrLUSEv0k8Wcj5lU+qEQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12d3d0e-70b0-48d8-6b3f-08d9790ce664
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 12:24:16.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjSSIe8NO6Eq0SUDmXSDV+qmiZ8YQPpunumY9QTYmd7VGZ+P2mVGJ2hkVV4pJBx5Tx4udHMUOTvW7shGYg/Gng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4620
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=739 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160079
X-Proofpoint-ORIG-GUID: qKdvSZrSKPOW8bYMyJinIAUgAd9ITNri
X-Proofpoint-GUID: qKdvSZrSKPOW8bYMyJinIAUgAd9ITNri
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Sep 2021 at 08:06, Darrick J. Wong wrote:
> Hi again,
>
> Now that 5.15-rc1 is past, I would like to say something:
>
> I've been reflecting on my (sharply higher) stress levels in 2021, and
> realized that I don't enjoy our development process anymore.  One of the
> nice things about being a co-maintainer is that I can take advantage of
> the fact that suggesting improvements == leadership, though that comes
> with the responsibility that leadership == actually making it happen.
>
> The thing that has been bothering me these past few months is how we
> decide what's going into the next merge window.  People send patchsets
> at various points between the second week of the merge window and the
> week after -rc6, and then ... they wait to see if anyone will actually
> read them.  I or one of the maintainers will get to them eventually, but
> as a developer it's hard to know if nobody's responding because they
> don't like the patchset?  Or they're quietly on leave?  Or they're
> drowning trying to get their own patchsets out to the list?  Or they
> have too many bugs to triage and distro kernel backports?  Or they're
> afraid of me?
>
> Regardless, I've had the experience that it's stressful as the
> maintainer looking at all the stuff needing review; it's stressful as a
> developer trying to figure out if I'm /really/ going to make any
> progress this cycle; and as a reviewer it's stressful keeping up with
> both of these dynamics.  I've also heard similar sentiments from
> everyone else.
>
> The other problem I sense we're having is implied sole ownership of
> patchesets being developed.  Reviewers make comments, but then it seems
> like it's totally on the developer (as the applicant) to make all those
> changes.  It's ... frustrating to watch new code stall because reviewers
> ask for cleanups and code restructuring that are outside of the original
> scope of the series as a condition for adding a Reviewed-by tag... but
> then they don't work on those cleanups.
>
> At that point, what's a developer to do?  Try to get someone else's
> attention and start the review process all over again?  Try to get
> another maintainer's attention and have them do it?  This last thing is
> hard if you're already a maintainer, because doing that slows /everyone/
> down.
>
> (And yes, I've been growing our XFS team at Oracle this year so that
> this doesn't seem so one-sided with RedHat.)
>
> I've also heard from a few of you who find it offputting when patches
> show up with verbiage that could be interpreted as "I know best and
> won't take any further suggestions".  I agree with your feelings when
> I hear complaints coming in, because my own thoughts had usually already
> been "hmm, this sounds preemptively defensive, why?"
>
> Ok, so, things I /do/ like:
>
> During the 5.15 development cycle I really enjoyed going back and forth
> with Dave over my deferred inode inactivation series and the log
> speedups that we were both proposing.  I learned about percpu lists, and
> I hope he found it useful to remember how that part of the inode cache
> works again.  This dialectic was what drew me to XFS back in 2014 when I
> started working on reflink, and I've been missing it, especially since
> the pandemic started.
>
> So the question I have is: Can we do community sprints?  Let's get
> together (on the lists, or irc, wherever) the week after -rc2 drops to
> figure out who thinks they're close to submitting patchsets, decide
> which one or two big patchsets we as a group want to try to land this
> cycle, and then let's /all/ collaborate on making it happen.  If you
> think a cleanup would be a big help for someone else's patchset, write
> those changes and make that part happen.
>
> There's never been a prohibition on us working like that, but I'd like
> it if we were more intentional about working like a coordinated team to
> get things done.  What do you all think?
>
> (Small changes and bug fixes can be sent any time and I'll take a look
> at them; I'm not proposing any changes to that part of the process.)
>

Apart from patchsets associated with implementing new features, small changes
and bug fixes for an upcoming kernel release, may be we should also allow
developers to post RFC patchsets to obtain an initial high-level feedback
for a design that implements a fairly complicated new feature?

-- 
chandan
