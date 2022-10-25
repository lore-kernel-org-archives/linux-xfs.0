Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBEEC04A95
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 07:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiJYHBl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiJYHBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 03:01:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFE38769B
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 00:01:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29P1M4bq010282;
        Tue, 25 Oct 2022 07:01:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Kkf+sy4YqPSzlb07ccCfjiJFVwEOwuy2Rl69sBZBego=;
 b=SFBDdtkHiequhq843+FlHowmP4xCMNI5nOMZFFly5gQn1QX6jVfdT7lMiXU3JjBI2/jU
 WpvnaGL9nLaCf7YwMB2xEEehxXnlOE/CsVHWJwSEnHutrg5j1hDc3OSUT+V1SUfGsYUG
 IhlmeHNK629bGNgPqz6cUenOcgWhl+bDIGkH6VQgOOBOK7oS9u0cX7S8hGcXfSmrG79N
 4+xqdYHEhApb7tOCnSvgtUNq7US//Veff3hUDkc3ACBQ46N6G42wLfyaGcJBn5cKmsY2
 duaS6yZHfe4OeturAnnVG7k1znPSL9rkEdHNlelAClbjk75rwTCKHHd45QyZWrsgKmrp Qw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a313g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 07:01:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29P4vkWO012756;
        Tue, 25 Oct 2022 07:01:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y4bs09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 07:01:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9TW7BR2p4WTwfgNjKmCPafLZ2C3u33qSTbDwBaXoKhJdgDN73KEXYIRqAxhActc03CxzjL2AouPM1qY0mhoRuchMIotUNoukjFTtxbHY4AbA7EjLz2oGih/cYP9iqB9SOm1nrprdgzqjezW2nnHtohGtj+CCrKwOzalMbET8kUkQm8g/96PiT1IRkRdgxS11fuAxHyxHTvlvWYfiG+U7ABDOC/FXyGb+3o9SNM34VJqCuI3GPnOKOOwvRwRqQLKxN5zftWxYFUfmsaoxH5Rw1OSnh727uMiZCDW/TY6aApYtkWmAdaXqOrzRattWRk1eSocDMA5TOSBIl+c1kTmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kkf+sy4YqPSzlb07ccCfjiJFVwEOwuy2Rl69sBZBego=;
 b=HREOUNk21V5xIQ5DDBnPSRHGR8EzPKd20AtOZfymnIX6wJeObCAsVwBzazsPFNFeggEOHdouZdIzzTjjtDKKGEX62ZvcQVwojbaQdU1fdKccvgwtg0ypjUZ5fIa1otCklNK5UCKdb373gQ5ogc4ta/i0Pkr5QmAUpyYw4uDR8EBjOElMy2Eb0bgO9FCzjTfDi8WbVVsM77wYO0t1oTfBjibegjHeanMGgx9ZXQpk13abrMnDD2jIBEHT2Tf7oLSF7PPd1jy1s+qKvC/nb2s+f55oZD8OKxmLrYRNrvmWa+yqBmHH8iw/wdjY0my5M9KQvNcuhdwmYRGvYqsaEkDd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kkf+sy4YqPSzlb07ccCfjiJFVwEOwuy2Rl69sBZBego=;
 b=w+QDHDi7ane6RhLHiytRx6pYl7BvQK4NJhzAvmYNSxp3SXdMADwfwhNHEfkM4h+DTo0WO5jmPWejyXH++CQHuUJUC6+BNhIBVHGypK/rA/evx2oVSMwNPvjWlHe2oroIk3qe1XSQa40b4wVtnBmFNsUyR2pUo+fjqWgrgJUnRvg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 07:01:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Tue, 25 Oct 2022
 07:01:25 +0000
References: <20221024045314.110453-1-chandan.babu@oracle.com>
 <Y1cHC/khE7GDesH2@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/26] xfs stable candidate patches for
 5.4.y (from v5.7)
Date:   Tue, 25 Oct 2022 11:14:53 +0530
In-reply-to: <Y1cHC/khE7GDesH2@magnolia>
Message-ID: <87v8o8l740.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0184.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::28) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 696eb858-6300-4053-f566-08dab656baf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FP2aqEgCCisE+vY1OKp8QLvmPKzMKU2Y92lH+0yy1vp/f+f2tdfOErdiGM/gcckEdf9C3QqIVrwnCaLnme95D32eK9tBpzhSe5bfRU+Zg/C0YheTRbqVzeQ9svahqDz7KZ9Y5P59KSUYFt4eAUmoUNcAcpUMzxcgxLCfKswbg9DH8TS/52rMFlpEpQiYx7o3++yH/Xhgkin+Vx/q5YTf4s+B3wtgdJM0RfUQyQcWf7RrGelLxm+ZLlFQ/9MFeBMYVqMkC+9O1zcnKW9lnkHsUlhDvWrmG6SrgyRl4loQxqq03hq+a9kuM7bR9trvpwLBnFVkUk+B3n5Q/UwCulO6tx3BTsZyDmO/fq/iaTmetRlxrKfRli5eniG/r7YxupWYPn4D7RqDYL2TRzedIFcv5xWen178IJatUGlAQAxSh37ahirvdbG/wnbN/N/CRAQrxSENkxaA/8tp3GqaT5dGPD2LIq1pV+TZ1qZAkqB/x0FoNEH1HSyrgqZcoWa+hGA/3Nl7HCpafSsAwVNjtmJnX3CPVFvRX75STob3R0k+z1cxxjxtQ0BPaUHLC87b+kQjz57JXbfJMwm7tI9C2hr70x2XFYTE3x2nWtT2xjkMhbvBBTMo3Q4YBc5Iaszs2KwkXALywnayk5S4ozzc2PDF10wMXVBENs6N+VO61X2O2JIayYmtYUGGR4pfbaIYW3D8yg10PzH18nAIXhtA9cLo0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199015)(41300700001)(2906002)(316002)(66946007)(66556008)(66476007)(8676002)(4326008)(5660300002)(478600001)(6486002)(8936002)(6916009)(83380400001)(38100700002)(6506007)(53546011)(86362001)(26005)(6666004)(6512007)(9686003)(186003)(33716001)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCaTqVyfZ2dYzzIx/QGqK5FW6TT9QVCAXwT5eYmknusoQKg4dgT8qFI1KSCS?=
 =?us-ascii?Q?ZZ1x78CT68YexHMv1Eqb4SB2/fy1pE0SeIKSh2Ku8TDK3j9jrLLA/exR/dXR?=
 =?us-ascii?Q?h/fI3QU0bHwuNUbNn0UTXGKz+qnZeg8CSmUjpAlifycW74WmRojmqfqwhipJ?=
 =?us-ascii?Q?G87Nx66sNlAMLT2lBkcOSCgUo/WhfH4DgCjLZWu3qw/a4KNckpKkz9RY4EUA?=
 =?us-ascii?Q?vhBWLR3zCpPaklnpHtMGX8i0p7NiDY2nxNXYzs9iFh/v+EshcylgY1Mg9t11?=
 =?us-ascii?Q?6ldJnwzVP8ba7BWDTL32OsimiNaF0NH9+YPUoqTXERNzjXqd5MW3/3AoKm+x?=
 =?us-ascii?Q?TtETJOAKIsRLPKquCIcCA369jDWv1YyNJSvxdTlxGKrttkHPiMHEoFJrlkDG?=
 =?us-ascii?Q?QHBzmxwlnIBTgE+E1ytgbs5qXEtJlrQY1FPJXh0ZSlGgdma7xdKcb+l1jVD6?=
 =?us-ascii?Q?gSblOs/+I4SynH04SMNX/1k1U0yesc9O4YELk9ojg/069xAaTpyp9ksIZk4z?=
 =?us-ascii?Q?JGwL3liJ67ZHdpyh2U5mBTSSGWcBuU8SIm+ND2l0M0T5uzMY/iH7C/3C/RoH?=
 =?us-ascii?Q?Ma5KfwPQKkZPtHKKpPPzucSuUv+bBheXKcOGu4O4WEsgXw0pokBgYlWmB5OR?=
 =?us-ascii?Q?SjrygwGy9jITDClbgJrhYcq+jKqndkaq2NH3IhmLq97yx4YsnGDZNXCtj7/T?=
 =?us-ascii?Q?IdSKnuh6m1gHX/tTOAzHysZVabziiGXPNkEOsPKyBb3Fyyr3i10bKtO0Q6Is?=
 =?us-ascii?Q?g6if45MxENYz8RsEjxosYPmyl/5u9lu0EYvJm3uzdimZIVwK1eyCxlTTLh0q?=
 =?us-ascii?Q?C1xnjcJIciLRphl15c3G5CVA8qeM7GQWpqZOA7nA68Z2OyyEneAZQKDo4xBb?=
 =?us-ascii?Q?P52sB/vuFopDvrrfhYp+YocMpjV6q0ObG11D+P7Yu9z5AEZH1E1dnp+PmMov?=
 =?us-ascii?Q?yMZkE8DouD3uSMvRHa50oQMqV73bx0arFqYpSy2nlrG6SiNTS7hH0sOFUw3V?=
 =?us-ascii?Q?eUvoVP2L2kslHukLHJefVMlL1YYmvASaDjGG7IxMAGWJsRhuNBsAeqDYwpDm?=
 =?us-ascii?Q?GzB+lX/Dh+rTXX7f55TD1eHQPGk+Y1TZSqvuDBEntyvpCDSEqCsRS3VxBVLI?=
 =?us-ascii?Q?g9iLFWM0KRBfdOci2XfLRbfCX9CRptBMCwPa+XdcRKlY2zSaE/Qs3XwJsKmy?=
 =?us-ascii?Q?FVRyScYCIgVzDEwDWs5kYlX8y8nOjcEP7B8ipYTfNALPs2vCr86NF/c5Ftbi?=
 =?us-ascii?Q?zjQj6vCyUypd1eIMNb8GNpbkO+79Gwp/qXuOU1T4Z9tcrDXg2lxIXhSslodr?=
 =?us-ascii?Q?VAkXw0MyLp9aqhhg97zRLDXfgNVQbKDtxxecNA23xqA9AZDHsfqYrY34bm+r?=
 =?us-ascii?Q?iVMgUIYCmYbtxny0jp71ySa0s5XBgswT5/AH5PFgpeM6FR2UerOcf6Q/kxUr?=
 =?us-ascii?Q?ihrReAiecVZ08VifjOsqtirz1FQ0ZBdsOKaxde2COshKqUYqyfsFQmvdssJB?=
 =?us-ascii?Q?3/SQLpNZKESERZohtjTMEPdA8GlXWAI7knxOvxx3uecXhGe7sMIUd4eNuBsF?=
 =?us-ascii?Q?l4E5QeczL7/12jGR/X47VXCDjkjFOe24XnyKq3O5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696eb858-6300-4053-f566-08dab656baf8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 07:01:24.9635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qc/2LHcSdd8NgiBh9mgLywg/NAy2ILtW9czKXp5dxij1Phn+tRsp+GIp1lIs9M8ubXvD7ga4GMk8DdOLsQIsWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250040
X-Proofpoint-GUID: Xuvxb_Z5I34tH6i-BOXsym7H5mLKKw-i
X-Proofpoint-ORIG-GUID: Xuvxb_Z5I34tH6i-BOXsym7H5mLKKw-i
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:43:39 PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 24, 2022 at 10:22:48AM +0530, Chandan Babu R wrote:
>> Hi Darrick,
>> 
>> This 5.4.y backport series contains fixes from v5.7 release.
>> 
>> This patchset has been tested by executing fstests (via kdevops) using
>> the following XFS configurations,
>> 
>> 1. No CRC (with 512 and 4k block size).
>> 2. Reflink/Rmapbt (1k and 4k block size).
>> 3. Reflink without Rmapbt.
>> 4. External log device.
>> 
>> The following lists patches which required other dependency patches to
>> be included,
>> 1. dd87f87d87fa
>>    xfs: rework insert range into an atomic operation
>>    - b73df17e4c5b
>>      xfs: open code insert range extent split helper
>> 2. ce99494c9699
>>    xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
>>    - 8d57c21600a5
>>      xfs: add a function to deal with corrupt buffers post-verifiers
>>    - e83cf875d67a
>>      xfs: xfs_buf_corruption_error should take __this_address
>> 3. 8a6271431339
>>    xfs: fix unmount hang and memory leak on shutdown during quotaoff
>>    - 854f82b1f603
>>      xfs: factor out quotaoff intent AIL removal and memory free
>>    - aefe69a45d84
>>      xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
>>    - fd8b81dbbb23
>>      xfs: remove the xfs_dq_logitem_t typedef
>>    - d0bdfb106907
>>      xfs: remove the xfs_qoff_logitem_t typedef
>>    - 1cc95e6f0d7c
>>      xfs: Replace function declaration by actual definition
>
> For the patches necessary to fix these first three problems,
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>
>> 4. 0e7ab7efe774
>>    xfs: Throttle commits on delayed background CIL push
>>    - 108a42358a05
>>      xfs: Lower CIL flush limit for large logs
>> 5. 8eb807bd8399
>>    xfs: tail updates only need to occur when LSN changes
>>    (This commit improves performance rather than fix a bug. Please let
>>    me know if I should drop this patch).
>
> Are there customer/user complaints behind items #4 and #5?  If not, I
> think we ought to leave those out since this is already a very large
> batch of patches.
>

Ok. I will drop them from the patchset.

>>    - 4165994ac9672
>>      xfs: factor common AIL item deletion code
>> 6. 5833112df7e9
>>    xfs: reflink should force the log out if mounted with wsync
>>    - 54fbdd1035e3
>>      xfs: factor out a new xfs_log_force_inode helper
>
> That said, item #6 looks good to me since they strengthen xfs'
> persistence guarantees, so for these two patches,
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>

Hi Darrick,

Please let me know what you think about the following patches which didn't
have any dependencies and hence wasn't part of the above list,

xfs: trylock underlying buffer on dquot flush
xfs: check owner of dir3 data blocks
xfs: check owner of dir3 blocks
xfs: preserve default grace interval during quotacheck
xfs: don't write a corrupt unmount record to force summary counter recalc
xfs: move inode flush to the sync workqueue
xfs: Use scnprintf() for avoiding potential buffer overflow

>> 
>> Brian Foster (6):
>>   xfs: open code insert range extent split helper
>>   xfs: rework insert range into an atomic operation
>>   xfs: rework collapse range into an atomic operation
>>   xfs: factor out quotaoff intent AIL removal and memory free
>>   xfs: fix unmount hang and memory leak on shutdown during quotaoff
>>   xfs: trylock underlying buffer on dquot flush
>> 
>> Christoph Hellwig (2):
>>   xfs: factor out a new xfs_log_force_inode helper
>>   xfs: reflink should force the log out if mounted with wsync
>> 
>> Darrick J. Wong (8):
>>   xfs: add a function to deal with corrupt buffers post-verifiers
>>   xfs: xfs_buf_corruption_error should take __this_address
>>   xfs: fix buffer corruption reporting when xfs_dir3_free_header_check
>>     fails
>>   xfs: check owner of dir3 data blocks
>>   xfs: check owner of dir3 blocks
>>   xfs: preserve default grace interval during quotacheck
>>   xfs: don't write a corrupt unmount record to force summary counter
>>     recalc
>>   xfs: move inode flush to the sync workqueue
>> 
>> Dave Chinner (5):
>>   xfs: Lower CIL flush limit for large logs
>>   xfs: Throttle commits on delayed background CIL push
>>   xfs: factor common AIL item deletion code
>>   xfs: tail updates only need to occur when LSN changes
>>   xfs: fix use-after-free on CIL context on shutdown
>> 
>> Pavel Reichl (4):
>>   xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
>>   xfs: remove the xfs_dq_logitem_t typedef
>>   xfs: remove the xfs_qoff_logitem_t typedef
>>   xfs: Replace function declaration by actual definition
>> 
>> Takashi Iwai (1):
>>   xfs: Use scnprintf() for avoiding potential buffer overflow
>> 
>>  fs/xfs/libxfs/xfs_alloc.c      |   2 +-
>>  fs/xfs/libxfs/xfs_attr_leaf.c  |   6 +-
>>  fs/xfs/libxfs/xfs_bmap.c       |  32 +-------
>>  fs/xfs/libxfs/xfs_bmap.h       |   3 +-
>>  fs/xfs/libxfs/xfs_btree.c      |   2 +-
>>  fs/xfs/libxfs/xfs_da_btree.c   |  10 +--
>>  fs/xfs/libxfs/xfs_dir2_block.c |  33 +++++++-
>>  fs/xfs/libxfs/xfs_dir2_data.c  |  32 +++++++-
>>  fs/xfs/libxfs/xfs_dir2_leaf.c  |   2 +-
>>  fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
>>  fs/xfs/libxfs/xfs_dquot_buf.c  |   8 +-
>>  fs/xfs/libxfs/xfs_format.h     |  10 +--
>>  fs/xfs/libxfs/xfs_trans_resv.c |   6 +-
>>  fs/xfs/xfs_attr_inactive.c     |   6 +-
>>  fs/xfs/xfs_attr_list.c         |   2 +-
>>  fs/xfs/xfs_bmap_util.c         |  57 +++++++------
>>  fs/xfs/xfs_buf.c               |  22 +++++
>>  fs/xfs/xfs_buf.h               |   2 +
>>  fs/xfs/xfs_dquot.c             |  26 +++---
>>  fs/xfs/xfs_dquot.h             |  98 ++++++++++++-----------
>>  fs/xfs/xfs_dquot_item.c        |  47 ++++++++---
>>  fs/xfs/xfs_dquot_item.h        |  35 ++++----
>>  fs/xfs/xfs_error.c             |   7 +-
>>  fs/xfs/xfs_error.h             |   2 +-
>>  fs/xfs/xfs_export.c            |  14 +---
>>  fs/xfs/xfs_file.c              |  16 ++--
>>  fs/xfs/xfs_inode.c             |  23 +++++-
>>  fs/xfs/xfs_inode.h             |   1 +
>>  fs/xfs/xfs_inode_item.c        |  28 +++----
>>  fs/xfs/xfs_log.c               |  26 +++---
>>  fs/xfs/xfs_log_cil.c           |  39 +++++++--
>>  fs/xfs/xfs_log_priv.h          |  53 ++++++++++--
>>  fs/xfs/xfs_log_recover.c       |   5 +-
>>  fs/xfs/xfs_mount.h             |   5 ++
>>  fs/xfs/xfs_qm.c                |  64 +++++++++------
>>  fs/xfs/xfs_qm_bhv.c            |   6 +-
>>  fs/xfs/xfs_qm_syscalls.c       | 142 ++++++++++++++++-----------------
>>  fs/xfs/xfs_stats.c             |  10 +--
>>  fs/xfs/xfs_super.c             |  28 +++++--
>>  fs/xfs/xfs_trace.h             |   1 +
>>  fs/xfs/xfs_trans_ail.c         |  88 ++++++++++++--------
>>  fs/xfs/xfs_trans_dquot.c       |  54 ++++++-------
>>  fs/xfs/xfs_trans_priv.h        |   6 +-
>>  43 files changed, 646 insertions(+), 421 deletions(-)
>> 
>> -- 
>> 2.35.1
>> 

-- 
chandan
