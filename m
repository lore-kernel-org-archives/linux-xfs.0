Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6144C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 06:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiBOGtS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 01:49:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiBOGtR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 01:49:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8924F13DD7
        for <linux-xfs@vger.kernel.org>; Mon, 14 Feb 2022 22:49:06 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21F6jB9H014935;
        Tue, 15 Feb 2022 06:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=KAlza++HZkyQzsvgq8JmNDGY3rE8oT4bP7t0+qvfJJ4=;
 b=PlEAmY2KMgJoXlG4W/xQLQn8H8/ZhjOwdVpW8BC2tlVoLRRqR2RNtPBo+DE1QOyTb97M
 PtiG997RwtcFHmUddJymekIs06SziZ854U/DtxhRH+dd8OEBlxtNaAovmaCxl5/EcLrQ
 6tuOguL308yv+c+ovH+3T9enIGY0m/oqmZnyCWQWpR6/ucMaz9I7fVGp6YWSKMScgB1D
 7FEjnKCHL9YAWF8dcR+3zaN1/1kAvMErX223yK+LLodppqxKNikO1IiMvcP+W5pt69QL
 zrGVvUpKstA4ohSqkaT7ci6hQZvyaAGNFjhNPjfVMDGMmUSWA/BAUQzDq+m+cw6s0oWn ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt6tr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 06:49:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21F6jPME124797;
        Tue, 15 Feb 2022 06:49:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3e66bn3h9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 06:49:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghHgGiYs9VUbiEBV0h55INPuF0azIdOngOeH4xtckZj8IRgltx04gXiJvNznnPSCHMbY+vQ90GjIETwHvx9mzEEMdACmkpH69sAtz9Z6qHCUu5KO+ZnWYdTksMpwTwGaRbATW6epGgzEF/34c8hE/AcMJDqoN/y+5n4X2OomzNka3wJfyeisCRLUVqzEXZdQen+ydkQBcvEvskpuk610S6meP86xYC8ZCJGEMgCIuyDZHlJ9OhBWNYaimDYyZn7+r/zqp3n1N+W2h+DDPiX/S/2PLHQXDVVx6PWs4+dBoixk81FMAlNnRn8pUcFC8BS+ceE+7RgG0sJTQWNh782+DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KAlza++HZkyQzsvgq8JmNDGY3rE8oT4bP7t0+qvfJJ4=;
 b=hvEDtgMNIonsgVjglBO56/OXe18Wr16hMUuRbbDqXDfAtOtjMCLCVUpcOULl/ZqOTHAwq9cCzq7bQheH2En1FJKrtuRrteVjbGNwjNQ+imIJMFi0uU4qghhySVqAn/DdjVtfUpVM71AWRLf/RwB9agtA+YHVNaHLSm3xx1LDd5tyeKXxk2zun7wTsDbFnJ2H/buAoO7U+KYwQkt1Zklm7MkKmFodydsnVMZ2nlw0neEVdkT61Uvkt+uJ2gyUKntZtb4UO//BXymaGPiueMVk98KaG8xAJqcPnHjI9z9+YOlxaNAa+8+xXHmCOBCV2mnNrBXqgeVsoiP5N6QbVkH7wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KAlza++HZkyQzsvgq8JmNDGY3rE8oT4bP7t0+qvfJJ4=;
 b=XSQbB19GKLTu1w6szKE7qlghz6NO8Y9azRdaWEdx6o7PKipvDzqg8D/JUT4eYHkgVSi51TY8sn8Un8EV3IFA5VXuT4jxrl6Yb7ImID5OlAha6A1x7EDVDQJhGNmqZvsMB6DsVTWIBbdsr6Dl116QTpPvF5L6Eu6hBqTKIx1s0L4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN8PR10MB3090.namprd10.prod.outlook.com (2603:10b6:408:cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 06:48:59 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 06:48:59 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220214170728.GI8313@magnolia>
Message-ID: <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Feb 2022 12:18:50 +0530
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0009.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::21)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 255fcd93-1b51-42bf-ab40-08d9f04f3df4
X-MS-TrafficTypeDiagnostic: BN8PR10MB3090:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB309050CA9DF7FFFDF9E751CFF6349@BN8PR10MB3090.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xgkxxU3HwWWaqXZOBySxfdNXkumIlqROlddKaQqRo0xL5WGlb/mpoGlCdVfkj9ysQ4FtknBbX1ATkJjMNJ8Uhn+y556pNtRgt9DHWIkIHiUnwPVmJ7fIdFyYhRYifyVU89Mdo8QhL3tPKaZNw5RDUCarSpEaDWVtO6yHCNgRCpBs/0ol7GyUKAhxz82yhJ2i4CgB3qJsyWP70rWPXdT8X4n4vqTTMkoFRL7+oOUfKJd3TJhndRTk/2ixdJh94oPV51f7z3r39TA1H+TUsmC3gIgyujOzQDAH9uDMFyXzzBhng8igxQDALUrvh+uZDEJWlOUXQyTPrZAHFoaGtO1m74Fsp5dJVkW1m211dhHDxfsIrp40dEvIjElJt8lUEsO5FjPCoqePwj9Sf3UVrXzfjUtvASHaiMvGF0auylzl+gTPERyj8/CnMT8GE5m3jchERRMAoNElFGH/qaEtXGfnvxcw0JyQIakgkvLWBGijrm6/IQPs0W4n3DHonadkhalxu5UESECSwOlDFJjpRlfmkIjJa4Z2rugEVS/0/gfOaQBEkVgo80MVJlDgFFoWBy18IErtAW0IIUQ5AA8f5wzV+rlzFHYAoPrbjQHy4uFgJ89UKuZgKeFOLR6zFMYla7W10yPaqSjDBFpVMSG8QBqHf1c0QWYccdu572F8EePUFClCkP05PkN/gT6GpYe2pokwc9IHkBuL+l6zfSpGPgHacg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6512007)(9686003)(2906002)(52116002)(53546011)(6506007)(83380400001)(33716001)(26005)(186003)(508600001)(4326008)(66476007)(66556008)(86362001)(8936002)(6486002)(8676002)(6916009)(6666004)(66946007)(5660300002)(38100700002)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fumvfjty3jGS7BwqZm2GDjoa5EyJTFr5oUefahdO7KrYSVoCtS6UVmmJyyGG?=
 =?us-ascii?Q?w5hCqRL1Pu360peizwziN14wiFIkcsWxNranxZ1JSCkfrYMcl6TqhTi9tJSA?=
 =?us-ascii?Q?KzB4tWGmXPxhfo6nXmfXfKVn160x0qxytPavgxGknkS2BnHc6E74QnnnfSLW?=
 =?us-ascii?Q?GQhxFX8xKYqhJNgb+VByYdEbWxLVX6XKspbJJwNC4oRcGEJSGISlFVu5qtK3?=
 =?us-ascii?Q?TT0fz8VbwejPlotx8OELoeKlYkgyd43YWR6y5ZuLvPqLDmagWckbWA5+ajeo?=
 =?us-ascii?Q?eFlfXTfQdsgV807Y/nIdg5Yc9BVkwXWX1gaRpEWV0BRT+EyRqMhXMES11krZ?=
 =?us-ascii?Q?39NhYdDvGVJB9OUF6mEcZU4jybE3n09a+8VhbbJOqOhtIiTb2yAphPVcWYSI?=
 =?us-ascii?Q?iV9JT7rDjuMKbdhu/uqDxrDM9aFGkJCSsn8iCQwHTPlxG0Ecwn3YpLHhtSbV?=
 =?us-ascii?Q?ABnBHNjInIxjhjucQDfoaZoOzVP/o0RbBNfPRRRMH4Vb5iL9DP5kOCmFVRik?=
 =?us-ascii?Q?ihcdN66tM8SUPJjltZOYvUro8zz+XZvmJyQI55l9Pdlj5CCM5zRjNCHvpbOB?=
 =?us-ascii?Q?eCtX22NdGA85v9ZZZfwxkeWAwD8hrmbTJUim9L+9Ssu/d5KbgW5L5F/hdLfj?=
 =?us-ascii?Q?OTB0V7/Ppp5jzhb5HaBPyS7zOfDGcO+El7ws45qVpAX1f0XVBLgy6Qg327sN?=
 =?us-ascii?Q?7f6BBqaKxR62MrpPKWIqPyvAmB3wIXaho2zb4XajQPtymEVNmbXsmQhL8dI3?=
 =?us-ascii?Q?JEd5o1tQGdjE7q8RvLGbZQI5z5huycRc39DjfG1B+3/botM3IbAd121uSgwI?=
 =?us-ascii?Q?KKEhic8gTs3Mzs/qvcd8WN/N/qWBP3DXrYpV3EguNoKMjPGWtTJXvKGDX2Ap?=
 =?us-ascii?Q?QDvJnfK2LQzFLiz+/1rTPyzHRsxfL90byFBY001wb4WhBEb2MgXYZLHoJp1T?=
 =?us-ascii?Q?gHSe8rsYtWgfFjqxWreeJECoquCghlyH0dVIDHFgUgJ7F1gTE7wVYr8pQw+r?=
 =?us-ascii?Q?+jK0cd/62cgnEgJ+tw3WO9JG6uc+mDx80LcXO6x7tciEBZVBuPkr0AnP/VKP?=
 =?us-ascii?Q?hsL/JozgyBpgI3BeHZwq1NOJYnahWeb3pEdcrOOxXENoiCQOnc5iS+AskDqH?=
 =?us-ascii?Q?tDHEmXL4wJZyRW7+dm1v++cTEkX+MD4qGUg0XQ4F+aLrAyjrtffcUUFyc0Au?=
 =?us-ascii?Q?xMi6eXZAq/8TxWqjKwX0lAPkQJsrswfUguBQABgYbZqgW+YpVLleU87R5fcV?=
 =?us-ascii?Q?pNKBupcsarr9D3eBRWpuIAgiy0dGh/0gxhycBD0zltK7lz7aROfnkH5OITrw?=
 =?us-ascii?Q?y4+YIvBJBV4XW4K36sOuH/FmZIUEy9QeqgOSNsLvMl0bnC9nS2BQjjTHOKfp?=
 =?us-ascii?Q?5PUrGq96i6NP5nvSTIKN/xnfncolAUZAv3Zg7FpYqzIF7nbOVakjgHUFVKPF?=
 =?us-ascii?Q?ktvvDP4RLsCMKVm1z3GTYbxLQO0Yg3UngrGqhZJn8E3cO2o32c23S9SIif5i?=
 =?us-ascii?Q?5QPxfTHzSfwdZjhuKYUQi+0lFzXupZWasWiAUUvGZL5zFnme8mzRoxH8jmvf?=
 =?us-ascii?Q?3QpxbKtvk5JX3eGTnyPfi1b6M9Es1ao6bVK+cdA6hc9RQXAGgRhEkk4R2fnj?=
 =?us-ascii?Q?1tL7GG7H6pUpqu+7yr7j9N0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255fcd93-1b51-42bf-ab40-08d9f04f3df4
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 06:48:58.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8Eje+FUdtZ3dxfOea/iOCfeMFO1acVlE4szFXnN8pNqqhGNHTyorpajqipcoMA/9BGnoRCOdM1bEzdOlW4X1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3090
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150039
X-Proofpoint-GUID: OA0rat7N-bZ5OB8iBbsBNwAK-stmavvh
X-Proofpoint-ORIG-GUID: OA0rat7N-bZ5OB8iBbsBNwAK-stmavvh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
> On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
>> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
>> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
>> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
>> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>> >> >> This commit upgrades inodes to use 64-bit extent counters when they are read
>> >> >> from disk. Inodes are upgraded only when the filesystem instance has
>> >> >> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> >> >> 
>> >> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> >> ---
>> >> >>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>> >> >>  1 file changed, 6 insertions(+)
>> >> >> 
>> >> >> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> >> >> index 2200526bcee0..767189c7c887 100644
>> >> >> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> >> >> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> >> >> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>> >> >>  	}
>> >> >>  	if (xfs_is_reflink_inode(ip))
>> >> >>  		xfs_ifork_init_cow(ip);
>> >> >> +
>> >> >> +	if ((from->di_version == 3) &&
>> >> >> +	     xfs_has_nrext64(ip->i_mount) &&
>> >> >> +	     !xfs_dinode_has_nrext64(from))
>> >> >> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> >> >
>> >> > Hmm.  Last time around I asked about the oddness of updating the inode
>> >> > feature flags outside of a transaction, and then never responded. :(
>> >> > So to quote you from last time:
>> >> >
>> >> >> The following is the thought process behind upgrading an inode to
>> >> >> XFS_DIFLAG2_NREXT64 when it is read from the disk,
>> >> >>
>> >> >> 1. With support for dynamic upgrade, The extent count limits of an
>> >> >> inode needs to be determined by checking flags present within the
>> >> >> inode i.e.  we need to satisfy self-describing metadata property. This
>> >> >> helps tools like xfs_repair and scrub to verify inode's extent count
>> >> >> limits without having to refer to other metadata objects (e.g.
>> >> >> superblock feature flags).
>> >> >
>> >> > I think this makes an even /stronger/ argument for why this update
>> >> > needs to be transactional.
>> >> >
>> >> >> 2. Upgrade when performed inside xfs_trans_log_inode() may cause
>> >> >> xfs_iext_count_may_overflow() to return -EFBIG when the inode's
>> >> >> data/attr extent count is already close to 2^31/2^15 respectively.
>> >> >> Hence none of the file operations will be able to add new extents to a
>> >> >> file.
>> >> >
>> >> > Aha, there's the reason why!  You're right, xfs_iext_count_may_overflow
>> >> > will abort the operation due to !NREXT64 before we even get a chance to
>> >> > log the inode.
>> >> >
>> >> > I observe, however, that any time we call that function, we also have a
>> >> > transaction allocated and we hold the ILOCK on the inode being tested.
>> >> > *Most* of those call sites have also joined the inode to the transaction
>> >> > already.  I wonder, is that a more appropriate place to be upgrading the
>> >> > inodes?  Something like:
>> >> >
>> >> > /*
>> >> >  * Ensure that the inode has the ability to add the specified number of
>> >> >  * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
>> >> >  * the transaction.  Upon return, the inode will still be in this state
>> >> >  * upon return and the transaction will be clean.
>> >> >  */
>> >> > int
>> >> > xfs_trans_inode_ensure_nextents(
>> >> > 	struct xfs_trans	**tpp,
>> >> > 	struct xfs_inode	*ip,
>> >> > 	int			whichfork,
>> >> > 	int			nr_to_add)
>> >> > {
>> >> > 	int			error;
>> >> >
>> >> > 	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> >> > 	if (!error)
>> >> > 		return 0;
>> >> >
>> >> > 	/*
>> >> > 	 * Try to upgrade if the extent count fields aren't large
>> >> > 	 * enough.
>> >> > 	 */
>> >> > 	if (!xfs_has_nrext64(ip->i_mount) ||
>> >> > 	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
>> >> > 		return error;
>> >> >
>> >> > 	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> >> > 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
>> >> >
>> >> > 	error = xfs_trans_roll(tpp);
>> >> > 	if (error)
>> >> > 		return error;
>> >> >
>> >> > 	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> >> > }
>> >> >
>> >> > and then the current call sites become:
>> >> >
>> >> > 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
>> >> > 			dblocks, rblocks, false, &tp);
>> >> > 	if (error)
>> >> > 		return error;
>> >> >
>> >> > 	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>> >> > 			XFS_IEXT_ADD_NOSPLIT_CNT);
>> >> > 	if (error)
>> >> > 		goto out_cancel;
>> >> >
>> >> > What do you think about that?
>> >> >
>> >> 
>> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
>> >> that your suggestion can be implemented.
>> 
>> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
>> xfs_symlink().
>> 
>> Just after invoking xfs_iext_count_may_overflow(), we execute the following
>> steps,
>> 
>> 1. Allocate inode chunk
>> 2. Initialize inode chunk.
>> 3. Insert record into inobt/finobt.
>> 4. Roll the transaction.
>> 5. Allocate ondisk inode.
>> 6. Add directory inode to transaction.
>> 7. Allocate blocks to store symbolic link path name.
>> 8. Log symlink's inode (data fork contains block mappings).
>> 9. Log data blocks containing symbolic link path name.
>> 10. Add name to directory and log directory's blocks.
>> 11. Log directory inode.
>> 12. Commit transaction.
>> 
>> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
>> occur before step 1 since xfs_trans_roll would unlock the inode by executing
>> xfs_inode_item_committing().
>> 
>> xfs_create() has a similar flow.
>> 
>> Hence, I think we should retain the current logic of setting
>> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
>
> File creation shouldn't ever run into problems with
> xfs_iext_count_may_overflow because (a) only symlinks get created with
> mapped blocks, and never more than two; and (b) we always set NREXT64
> (the inode flag) on new files if NREXT64 (the superblock feature bit) is
> enabled, so a newly created file will never require upgrading.
>

The inode representing the symbolic link being created cannot overflow its
data fork extent count field. However, the inode representing the directory
inside which the symbolic link entry is being created, might overflow its data
fork extent count field. Similary, xfs_create() can cause data fork extent
count field of the parent directory to overflow.

>> >> 
>> >> However, wouldn't the current approach suffice in terms of being functionally
>> >> and logically correct? XFS_DIFLAG2_NREXT64 is set when inode is read from the
>> >> disk and the first operation to log the changes made to the inode will make
>> >> sure to include the new value of ip->i_diflags2. Hence we never end up in a
>> >> situation where a disk inode has more than 2^31 data fork extents without
>> >> having XFS_DIFLAG2_NREXT64 flag set.
>> >> 
>> >> But the approach described above does go against the convention of changing
>> >> metadata within a transaction. Hence I will try to implement your suggestion
>> >> and include it in the next version of the patchset.
>> >
>> > Ok, that sounds good. :)
>> >

-- 
chandan
