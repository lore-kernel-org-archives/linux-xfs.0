Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAA0C38142
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 05:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjAXFcE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 00:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjAXFcD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 00:32:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7EE7D92
        for <linux-xfs@vger.kernel.org>; Mon, 23 Jan 2023 21:32:01 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04fdx022007;
        Tue, 24 Jan 2023 05:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=+4CjvfsvHrS9uvFPb22I0kMOm7ZlC4Lb09lG1hoN0qs=;
 b=SIrP3bEMA627z7uVOM38PKEnMcOjh2+Z/uTDru4VT6x9R4Y/mxSk8UyI8J7yxo23mu5t
 KF0Ht4eOaB7eCN56+5LEe6HaL49PSalS50nXLtUkncGrUlGQDobePG45Z48gaRKtb+UZ
 Gt9s8dvoaa4e/URVU3WnALEJcMAkoCWi97HiSY5xqRgG2/SrgCVbRfnNd35xBNCduzzJ
 dXVcmHgE6RQEQ3hp6pq+6Lgi4NRakd6YkmZhAx07WNIGEEHHJ877WoymesrikdVMIwyO
 V72JrZcRmB5KBsa+F9VfcfmWFcdYHnf90yKiwZXLCjHDDJJ6AkkZolFowqMnAxPV5g11 oA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktvena-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:31:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O3kHX5011778;
        Tue, 24 Jan 2023 05:31:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3yynd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 05:31:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi6wHHlIQJFKBz1K+1G1C/ne+9bsZcKtmU0Q/S9l2miD8d9lh5krlkJYTNme7BPRYcy2SEJrR2AacSc8skP3EEh4z6p+K15CcS+EgrHW9NSFIiDNiqJaW/cttGS+/QC9DHK6fqZqAO03dyLcEZYWFrJfQjg/UpTgvcNwZHuMeGmYxwwze9MKXBhLVnwgtp0ADNimzM58DNafMNyt9VB5bvrMdb6IYY5XW3KgecL33+MewaMw0fN8D0EoZQ9tjdOpXp9lCIAWdlxWRuitHW9yzKihYeRp/aox6f9tq1lI9WCdwA01CpAoViQdt6pnDIERb2pG9OiurPj9meNHkISMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4CjvfsvHrS9uvFPb22I0kMOm7ZlC4Lb09lG1hoN0qs=;
 b=a5QD8senyWlyVG04ObqnPnvBrXdji2EhrHhjoUtfkm29CCm/jlKHj6xx5fTSfbZhfUhsWrFpvQZQRCLgKo3TMDIgL5pNYehdMKw5yc3AsFfk8k5Bz/s36NY+gdv7EKMFAxf59v/+xD3qVTHxcoVIwFJdeU8kNSo7NoDIPOSu5gQ9aDfvVXAfMRc9dEIwUzu+0yUJ7CUbBFCpG3BRfo6SW4kg030CmYTSWF4M7aMZKnkr02lEOst4/17CloEsOBzn9tdOopp59Nq0PaOOBCMbwlMJrT0KnopKYO8IbYQeDftZTpe3BJPoqhRgjZzIJTkN3nF6G/dc0QtqxO4lIYeZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4CjvfsvHrS9uvFPb22I0kMOm7ZlC4Lb09lG1hoN0qs=;
 b=RW1vYfCXMEITDARPJxxbOVMApwF336xl0rlxAAQgweQhklV1ZtIZK5l9awXq6NKxZ6C0/ixy7mC9VZzQ1aOzWUsjMshNTz1bmHjbhwXOSE+xWnqJ+wNjOv7RAhA0OYjYumUcoZrDKxESJ9OmIgisBTtq1g258Sp9CuFGkno2EZM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CY8PR10MB6660.namprd10.prod.outlook.com (2603:10b6:930:52::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.9; Tue, 24 Jan
 2023 05:31:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 05:31:56 +0000
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
 <167400163318.1925795.14365139273911946287.stgit@magnolia>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] design: document extended attribute log item changes
Date:   Tue, 24 Jan 2023 11:00:56 +0530
In-reply-to: <167400163318.1925795.14365139273911946287.stgit@magnolia>
Message-ID: <874jsglcqi.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0123.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::9) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CY8PR10MB6660:EE_
X-MS-Office365-Filtering-Correlation-Id: aef7fb07-fffd-4036-0b56-08dafdcc4ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qRynz0D2fEbSv9GXZnlOkNeTPnr8pJ5/9MRiRTc0ybjFOg34HJwbxJaW7dgzF4zDHz36IHXaTDYWVNtKLMmOI7yqbRffXHRdkRmEOCKELwzOHN8c9adusdKTFj1z+aw36eF19U4CkejMV8y6SKNkEX9Te6eKngHEGzhKLDtv2tCtnHlh34KBF1c1UWSYy3o1EtMg/PjMejyVFlKhdKGlFIoL9W4SImPhI23jRDd/ag2kYaShyW5/MkKiGeIa2E3M1U9XvWDULI6Hu1han6lAU3Zrq8d8SB+gyvMbRrKTOAXNMFn1+kMB8oPp8ndmhYR6eAbCYFRuguzw4offHobrKAav04bG4QdpVDenUIYCKFxJ5X2GPxivq07PUw6JJ16lkwO6jdLoQe1bIZ73o43IM7EKlhRw6chGO0eSzIrM6EY47Q0EyZtw+mH9bMWQppaKRa37noJh4Q6dGCvVM18aU4JwJv+XwZaXTXCbGmpATO/6ue9wNFF3rtUhkDHpMgCjKyZ5uFb3z9rpQqlb3g9B08HrqJugBQ7hf55J2WCxgLAyba6qKxOEImdgx3i7l3YZfT/H7yxZexRnhI7hfKwJnltAP+ialzOK6Lwm/RIFJZZOpdg/R5XhgLy7T4k8rslfilk6PRwvHE6idLHvgk/Psg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(346002)(39860400002)(366004)(376002)(451199015)(2906002)(5660300002)(6506007)(6486002)(478600001)(53546011)(26005)(107886003)(9686003)(6512007)(186003)(316002)(6916009)(4326008)(8676002)(66556008)(66476007)(66946007)(8936002)(83380400001)(41300700001)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65mcRGESBkPlaXHZquiS4mRzJvkqslcvtYhclfcqjPyYoA7FHz/tbC/Zq2FQ?=
 =?us-ascii?Q?F7B9dgwdUiXLsDvbydREFx6hq2zoAV1jOaLloIsuyHMOsBHVqyvp2BxgS3pZ?=
 =?us-ascii?Q?eUyNNP12KLqUSM3BTJ92QkMycUTE5M0ahwrfRA+ovHrE9GLic6FtdaHf4Vnz?=
 =?us-ascii?Q?PsQUtzdaophdWzlT6bGv8ZsGRlbkZbCEE1Q2hRafZ83HTsCTES6os/+AbNfv?=
 =?us-ascii?Q?SiC7cJM3roWazLeXqz5SJVWiwIOCitoQkwSjW1ET9gLjk2YVDVEKAd5SUYdu?=
 =?us-ascii?Q?tYdQC1EiF/qxRPbwxCkJqXxgS7NMtv8tBACpbxF4K5Iu8B0lxq2ugFSowdbM?=
 =?us-ascii?Q?OKCiHjzRsNCN1SM8Z/FrLmbQUKST/gCsa8cY/JRW3FSsiiPyIR30lMpL1Gu0?=
 =?us-ascii?Q?psFG6D7Cr3vlTVqVLK7TX6nLDCrHjzyTnSggWqSJ2Gdns0BBXC550VKmjUpB?=
 =?us-ascii?Q?hgsK0jRZyC1VPfD2ms8MiRjqCx1kqrxvKqQpWbUmGQj1jj0fmdUIXe4p8eqK?=
 =?us-ascii?Q?iJFvAnnh7ZDYVmf/C8KPN1AXSIs8Lly1sUkR3587l8AR5p/lMz3TNFLahSJk?=
 =?us-ascii?Q?+nEYUAy1JdHEsfEVvdsMrAvlqwAuroLtkAscQipajJfnMnObcaiYDODFuv6e?=
 =?us-ascii?Q?w8IAYTSU45uxtpuljpMNyT6EdQ1YC6aZ9bOwDRSEhAgUpTP8zUbyMUwY4jxr?=
 =?us-ascii?Q?ravccZwPsVxATL8Z7Eu6SkHKWie5Aw0t5JE5/c1Mk0rtBCN/1Lxl49xKk1rc?=
 =?us-ascii?Q?oTKWPA0p3Pdx5yjqYc4gV3ZBK2mpKSMsJ38APJnNBODnSITuLDLBaKXL6RDm?=
 =?us-ascii?Q?08a8idS6DyYh2i6fH9es3+dnnSxAwzZLmg0E/3sPuw7nER/Q71lYPXBYBo+n?=
 =?us-ascii?Q?UV1gyGrvirXXzC6jBJKYCRp5RzIm/I2vkDEmq4PBBRI43FhD7eZ2b/4P3Ps7?=
 =?us-ascii?Q?mQsTTkkjokh18HiPVlTKdkpMcYAg1PeKLy6TnXMugLe6EHSC7kwD9UT8n7HK?=
 =?us-ascii?Q?als9eykoG0QmJo+z7nXhEbFlQKXj9vmYOr/DTY67936CXZ1TdYzz80w3ZTzp?=
 =?us-ascii?Q?ElYDzUUnE4KLV+QD50httV1sSOboFOPuUVjejd3XxBl79xTs7pzwg4kfkhfE?=
 =?us-ascii?Q?3EBahWRCx9Js3t4vSxm/EduA5TgqwkWYGxY5eNaVbfEvCGQ3M2lW7LFh1rlS?=
 =?us-ascii?Q?QjFwO1EHng5beyPR1H9iGc48YWxO0j7NIKFPYPQXyF2Tvnz+qxnHVNWpiJkA?=
 =?us-ascii?Q?NJHahijeuIiwSuC0x+v6MhUizuUvL7EZPRtWtXXf+v3owzTA0WAim9g/TxpH?=
 =?us-ascii?Q?B6PCLkD8RtK0EBve+4RDBh2Zx0opsAdUrEHuoncwUnDjAN9xgElvbPRL1s7S?=
 =?us-ascii?Q?aLtJd6wEjQVuvcNVPS+jvyOh31LmG68AnSScmTt5MC6AwXw9h4kdswEzf4v6?=
 =?us-ascii?Q?rxSxvoKe8E8d++kLCnk1MeWD1rZAFbNur5st2YiVrUDf7bdapdCYiscNzA30?=
 =?us-ascii?Q?efp+pzVZ7+UrPTPv4VuZklIf9x6CUySISjwHiGUeqtcpGrekXaX4QIa/PRLr?=
 =?us-ascii?Q?BjtuHv6Vw5GS+Dm2cWV63qqi7BIIN9I4H4bjQ5Qcd1wxhYxrkyBPFiBwf/OX?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0k5uG1AqZYzuftCc50AJ8oNaFq1mKc1YPq/2Z9RJLACUTb/wmyoOAS498QBTaI1opMW1x6Jxrg80G+5lvgn8XM6aRjZgLkrWeTV+8xUU9MHwX95TfDnmYElE4/L9LLUMWQOLmjZsUmdT6KygOP7wQjcGL4jhgPUVZzolUMbRizhQKyfxxRNauWx/xjb1fQXzrH3rKRwHqNQYnTSvkg9N5mlt5C5H5ef+Vrlv0wghmTkiFIp5yPgHXozEK+eAwPi3KEL7i2HjXGxnTv7mtKrixUQnoDUx8OwarV9ZMZKimvhuHoajtsV3kRVQSfkSWzqK5/bW0ni1VVvKkzTYc9Lq/XWH+j2/VJdkC2umlDrLsMO+G5xB3HtAToJ11sQXxOrsn70lzdTFnzp5htxyGVwyTePjWfVW6KFjOkBE6kdfLWRywXvMne1sT9PWkKAegzLxgLkkK9yDVYNXPBhbwhHPtY7MWkr9DGh4Nox/NtV2I4IYRJl3KM6zywKA50oqDnENMd6zEye3fkB+t8iGM/7klE2k8q3YbVcU4Tm1aCSvSj9TjffYdKwfgQALmyyy2l1HUGc+9yn87AvZ9lAkCJC3Tioi38R03uJ0/agBQSSU3N0Te+tZZvSvD48NWlQNuTWyDlj3grbDSGJ13DLHZAKoQpHZxXoBKG1U5t9DtDpIRkJWHw4Uv2wyWczu2z9NZvh2IIrmQCsUeElCAzhre0/cc3JbtODGOcWan08VXpHI3P6xpBcVqnri4tQNl1EtT8y+t0ZhRoTOQTaJnUUkXvgBu96wzPxVhL14CoHc1XaTVWA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aef7fb07-fffd-4036-0b56-08dafdcc4ec7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:31:56.5825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8z7dVctgKf5A5giSLF04defN6Us6L66kS+emjy/h9fUxCAatWd57Yjpn0Xx5d+cSgtn//vokjzAMGsJrd+oYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6660
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240049
X-Proofpoint-GUID: b-a5bmHfUxUKo5ed-vxbW2zxIfc9zGUn
X-Proofpoint-ORIG-GUID: b-a5bmHfUxUKo5ed-vxbW2zxIfc9zGUn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:45:20 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Describe the changes to the ondisk log format that are required to
> support atomic updates to extended attributes.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  .../allocation_groups.asciidoc                     |   14 ++-
>  .../journaling_log.asciidoc                        |  109 ++++++++++++++++++++
>  design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
>  3 files changed, 122 insertions(+), 3 deletions(-)
>
>
> diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> index c64b4fad..c0ba16a8 100644
> --- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> +++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
> @@ -461,9 +461,17 @@ space mappings allowed in data and extended attribute file forks.
>  |=====
>  
>  *sb_features_log_incompat*::
> -Read-write incompatible feature flags for the log.  The kernel cannot read or
> -write this FS log if it doesn't understand the flag.  Currently, no flags are
> -defined.
> +Read-write incompatible feature flags for the log.  The kernel cannot recover
> +the FS log if it doesn't understand the flag.
> +
> +.Extended Version 5 Superblock Log incompatibility flags
> +[options="header"]
> +|=====
> +| Flag					| Description
> +| +XFS_SB_FEAT_INCOMPAT_LOG_XATTRS+	|
> +Extended attribute updates have been committed to the ondisk log.
> +
> +|=====
>  
>  *sb_crc*::
>  Superblock checksum.
> diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> index ddcb87f4..f36dd352 100644
> --- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> +++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> @@ -215,6 +215,8 @@ magic number to distinguish themselves.  Buffer data items only appear after
>  | +XFS_LI_CUD+			| 0x1243        | xref:CUD_Log_Item[Reference Count Update Done]
>  | +XFS_LI_BUI+			| 0x1244        | xref:BUI_Log_Item[File Block Mapping Update Intent]
>  | +XFS_LI_BUD+			| 0x1245        | xref:BUD_Log_Item[File Block Mapping Update Done]
> +| +XFS_LI_ATTRI+		| 0x1246        | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
> +| +XFS_LI_ATTRD+		| 0x1247        | xref:ATTRD_Log_Item[Extended Attribute Update Done]
>  |=====
>  
>  Note that all log items (except for transaction headers) MUST start with
> @@ -712,6 +714,113 @@ Size of this log item.  Should be 1.
>  *bud_bui_id*::
>  A 64-bit number that binds the corresponding BUI log item to this BUD log item.
>  
> +[[ATTRI_Log_Item]]
> +=== Extended Attribute Update Intent
> +
> +The next two operation types work together to handle atomic extended attribute
> +updates.
> +
> +The lower byte of the +alfi_op_flags+ field is a type code indicating what sort
> +of file block mapping operation we want.
> +
> +.Extended attribute update log intent types
> +[options="header"]
> +|=====
> +| Value				| Description
> +| +XFS_ATTRI_OP_FLAGS_SET+	| Set a key/value pair.
> +| +XFS_ATTRI_OP_FLAGS_REMOVE+	| Remove a key/value pair.
> +| +XFS_ATTRI_OP_FLAGS_REPLACE+	| Replace one key/value pair with another.
> +|=====
> +
> +The ``extended attribute update intent'' operation comes first; it tells the
> +log that XFS wants to update one of a file's extended attributes.  This record
> +is crucial for correct log recovery because it enables us to spread a complex
> +metadata update across multiple transactions while ensuring that a crash midway
> +through the complex update will be replayed fully during log recovery.
> +
> +[source, c]
> +----
> +struct xfs_attri_log_format {
> +     uint16_t                  alfi_type;
> +     uint16_t                  alfi_size;
> +     uint32_t                  __pad;
> +     uint64_t                  alfi_id;
> +     uint64_t                  alfi_ino;
> +     uint32_t                  alfi_op_flags;
> +     uint32_t                  alfi_name_len;
> +     uint32_t                  alfi_value_len;
> +     uint32_t                  alfi_attr_filter;
> +};
> +----
> +
> +*alfi_type*::
> +The signature of an ATTRI operation, 0x1246.  This value is in host-endian
> +order, not big-endian like the rest of XFS.
> +
> +*alfi_size*::
> +Size of this log item.  Should be 1.
> +
> +*alfi_id*::
> +A 64-bit number that binds the corresponding ATTRD log item to this ATTRI log
> +item.
> +
> +*alfi_ino*::
> +Inode number of the file being updated.
> +
> +*alfi_op_flags*::
> +The operation being performed.  The lower byte must be one of the
> ++XFS_ATTRI_OP_FLAGS_*+ flags defined above.  The upper bytes must be zero.
> +
> +*alfi_name_len*::
> +Length of the name of the extended attribute.  This must not be zero.
> +The attribute name itself is captured in the next log item.
> +
> +*alfi_value_len*::
> +Length of the value of the extended attribute.  This must be zero for remove
> +operations, and nonzero for set and replace operations.  The attribute value
> +itself is captured in the log item immediately after the item containing the
> +name.
> +
> +*alfi_attr_filter*::
> +Attribute namespace filter flags.  This must be one of +ATTR_ROOT+,
> ++ATTR_SECURE+, or +ATTR_INCOMPLETE+.
> +
> +[[ATTRD_Log_Item]]
> +=== Completion of Extended Attribute Updates
> +
> +The ``extended attribute update done'' operation complements the ``extended
> +attribute update intent'' operation.  This second operation indicates that the
> +update actually happened, so that log recovery needn't replay the update.  The
> +ATTRD and the actual updates are typically found in a new transaction following
> +the transaction in which the ATTRI was logged.
> +
> +[source, c]
> +----
> +struct xfs_attrd_log_format {
> +      __uint16_t               alfd_type;
> +      __uint16_t               alfd_size;
> +      __uint32_t               __pad;
> +      __uint64_t               alfd_alf_id;
> +};
> +----
> +
> +*alfd_type*::
> +The signature of an ATTRD operation, 0x1247.  This value is in host-endian
> +order, not big-endian like the rest of XFS.
> +
> +*alfd_size*::
> +Size of this log item.  Should be 1.
> +
> +*alfd_bui_id*::

The above should be "alfd_alf_id". Apart from that, the remaining
changes appear to be correct.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

-- 
chandan

> +A 64-bit number that binds the corresponding ATTRI log item to this ATTRD log
> +item.
> +
> +=== Extended Attribute Name and Value
> +
> +These regions contain the name and value components of the extended attribute
> +being updated, as needed.  There are no magic numbers; each region contains the
> +data and nothing else.
> +
>  [[Inode_Log_Item]]
>  === Inode Updates
>  
> diff --git a/design/XFS_Filesystem_Structure/magic.asciidoc b/design/XFS_Filesystem_Structure/magic.asciidoc
> index 9be26f82..a343271a 100644
> --- a/design/XFS_Filesystem_Structure/magic.asciidoc
> +++ b/design/XFS_Filesystem_Structure/magic.asciidoc
> @@ -71,6 +71,8 @@ are not aligned to blocks.
>  | +XFS_LI_CUD+			| 0x1243        |       | xref:CUD_Log_Item[Reference Count Update Done]
>  | +XFS_LI_BUI+			| 0x1244        |       | xref:BUI_Log_Item[File Block Mapping Update Intent]
>  | +XFS_LI_BUD+			| 0x1245        |       | xref:BUD_Log_Item[File Block Mapping Update Done]
> +| +XFS_LI_ATTRI+		| 0x1246        |       | xref:ATTRI_Log_Item[Extended Attribute Update Intent]
> +| +XFS_LI_ATTRD+		| 0x1247        |       | xref:ATTRD_Log_Item[Extended Attribute Update Done]
>  |=====
>  
>  = Theoretical Limits
