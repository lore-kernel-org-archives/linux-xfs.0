Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D1CEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 04:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjFVEG2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 00:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFVEGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 00:06:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5F32710
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 21:04:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKHJn5029291;
        Thu, 22 Jun 2023 04:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=sXy97w1UW7QaeFaKEmdKHXR+vk2qsgJjIPP56tTbFMY=;
 b=1SnyqwOKEE7ekilIGRgRab3eOzLLGSl5AbKISkZb+6cMUIv6T1Zn7Qccybn4sYvD8G1y
 ieOo9fFCNhGru5bQXL056fx6qn83u5MLJ1eE0VIsQ4lVpLEJw+tJL9zWGscZxuYaBzw3
 5vaLvG6HrPQpmpTrhJTtm46S+kj9591C6DrEaS9H3p2yPw+Lp+zNdJw1B2Uh00YYCIFp
 H8vdHBl/BZ8MXtHfwzTR5relRdMYKXe6L+U28s8ShrCTNZLPc+uctzpIz4BIZ1F5Y4ST
 i3+0l1exzbQImp8YFRIl1Dq0Lqv+Kf0WZQGxLgohqfy9AuQ7jrNScItKb90zLvC6NcaN Lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r938drxdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 04:04:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M2uTkv005831;
        Thu, 22 Jun 2023 04:04:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396q90g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 04:04:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXuDxT7rsiRzHPwy/AZKmldCaj44g1+Zg8OLK5SDZiBOKobvu3sZGNRgLwXPsSxxiBSu60V0VVCPbBp6Dm6CXodcjjouo1TEbhnDxgu5qSiRlFe7VOU7NLc2hk4Sw3pvG1OGXADw0X8mNupgMoCE+4QHTnPV1+ArQtS33GqRnWPk61DiPI8vXHKeozgDK1NlQEfWHu/llYKH5g4dRRoJ9y8dbw0IW9Ir1094o5qQ5ldtO7+6GKeecYahSJN8pDGdn+BUYnCKZymFUWOhakdJbbImvbdA86JW7ShJp5AQIfCQfOsrOjkM2COr3l797Kw1j4PGczo47jOGc2G6maKePg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXy97w1UW7QaeFaKEmdKHXR+vk2qsgJjIPP56tTbFMY=;
 b=a8oRSCdg6rzXwD8AxYMkvQFnhspvWXR7ke3+peyfo0q6EpVWbBHQ/eOXRnl4w4oqCvDNawHFG2IPyZ+l0RvSIcLsDWkAFjpg4uBY1A1j03gfZSvkAmCkOCz0nrDkxwiiJWycFLasQu65seaNBCW10kw24p0/MZOVKDsa0G42pjA5krZu1YoVOn9RqUVndN2/qC7bhg3v3r8DTJI0NityPIqPugdd+gzGmGTj7/OvYOjq/5S5Il4YmZA/Gsrj7lX8uURGyTJCdVRs3YVb68KNk+9zRfD3s1CwXqrV/+xsbyYVIIeyXz0QKFpUQ1FgZjWVHzWA41jOCZs2QLPc497DQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXy97w1UW7QaeFaKEmdKHXR+vk2qsgJjIPP56tTbFMY=;
 b=OdmEQ/Hmh4mEjwKe4EFT/Y69/46cuLgyc8Ne3yum45m6ok1inLMB+fdgX+9f7tuJHNruFjR7c9R+ndU9O9AqGLFZec06ztbZiDD92cJhUZ/WKRkwcSQYtkYm2bGgQqEGhPXjB/YIeHXgb/TXZ8O1rUK3ReyJWljn1yuC436CRzM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 04:04:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6500.036; Thu, 22 Jun 2023
 04:04:40 +0000
References: <20230620002021.1038067-1-david@fromorbit.com>
 <20230620002021.1038067-5-david@fromorbit.com>
 <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZJIlmbuHIhu5BMG+@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: don't block in busy flushing when freeing extents
Date:   Thu, 22 Jun 2023 09:29:46 +0530
In-reply-to: <ZJIlmbuHIhu5BMG+@dread.disaster.area>
Message-ID: <87h6r0nnvy.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:404:f6::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: 43b408d8-0a3c-408a-901f-08db72d5cd33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zcDHxZiIkoQNUhdCARxh4D9ESFX9Z1H08p5hJ3ZsVvNVOA9qlGwCqnvhdmgr4DZTQmpU92niv/goP9Xbwrc7jFsq2cZ+VkM8pEmGfMQCie3Wy51P3o+gax8lQhN4HAzfkvv+57sKXIuEoRL0k4OD65DMgFmY5NV8l2RLyXfadzJ8LIEN8xFWJ6HGLvCQ0c04KyKyUYUy9uOEg1qXe6oEwi5AKUgvFQQxv9EXNu6p+YGn7tSVwzWsn+6CRazkxFKIUqfvRSJ5Ljd2xDbeQ68Hb9Ix9cobbvnj5W8MbhcTNoreV3SYK8gqGwq8Ie3RTepIxFVuNYQOVWpAxTAooh5jO0UVFW41PutZTKm/cMYWoYA2+DBCrO/ed0ZorymsBNlDfUUDW1zNka9q9/a2UwAwzQlJGa0SeS/6NJCvdFmkPPcAZE/UMN6FzyT9V++18KsGyj+hrjubDAK6R+0qSIcP/M1WtkUAHmvwyLa7TRGtFDFTrfKsPJO2L8TKVBVPAqQidzbW1zguxzHo3rQwVKzyKlKdNG5B7TmTGD7VHfYqHcEnc2enlcj19MCdujt2W26P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(86362001)(38100700002)(83380400001)(6486002)(33716001)(66476007)(4326008)(316002)(66946007)(66556008)(6506007)(53546011)(6512007)(8676002)(8936002)(6916009)(26005)(186003)(9686003)(41300700001)(2906002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJIWd3PtwssOcnHKPLyZG7B7TimBJUor91e+2LRMO2Lvq4tLx3s/RMfMMpfl?=
 =?us-ascii?Q?nmXGjslJVGuBm3axo4UAEuI8nCGfPhnOF4FzQW8LkcGOhjXKRaWVX1UOegOH?=
 =?us-ascii?Q?JIkFjJ1Zg90/QItoy/1MycrtGzyBlkXqZxfI1OdXaJczQuPm/cuHfgZlq7mW?=
 =?us-ascii?Q?XsVRFJpsWc2eqCUI6ZxN5HcmXoWMxaQ5YfkNbfSt1PWLWGmmbIDteIpGWnpe?=
 =?us-ascii?Q?e2ZuhusIVhUPztz9ySU9B4E8Io+g/Da5zYHtURUCRtLMqOgv0pxA0pm6y+LX?=
 =?us-ascii?Q?LGWEWnzZMAsn68gTjrt8/7lBXBNu0WUOLcNlOCalzR251e7fdVL+3uvEMLc5?=
 =?us-ascii?Q?PK/CQNKMickc4supZMorYM/9Xob9i91TZ5qY0h1KTE24nEG5HyjLaOOdSXVY?=
 =?us-ascii?Q?+tRQmwRLO3xihk3sy/XQE3xgy1JW89OmshjJ2MsCfshDlTrUS7F6gLR4L3eB?=
 =?us-ascii?Q?L0+arIlDWu6aHzpcVMY27UVfeI0m3Cue9t1FHJRsIBdT2JGRI/fTEdNsHmwZ?=
 =?us-ascii?Q?7s1iOt2jaoJr0O1UCf24WNn+XpRKrYhzFcKvgSkucLkm3i4G+VLTtNeBmyVD?=
 =?us-ascii?Q?9Uc2cMzba/rdxflKS2m8Ik1fNQhZ4f7n0U9It+7jet5yDJsJDNOmNDwnVwuA?=
 =?us-ascii?Q?r30uAn7junnt5IMlmwLLY1Rx04ZpsuEFwzUtgSqKo8/7rcB5brIv2I7l9isl?=
 =?us-ascii?Q?h3JtI8KdMk2RAGLAgoueJEdjmCZDzkoGuikEMSJoYuIHXreYK2UEzZxFYruF?=
 =?us-ascii?Q?UJZDQ2GZTdomxXnOiJzwUx+F0RI3nRggD6+0Qm10ERkG3KZ+okvgxj7YwEKO?=
 =?us-ascii?Q?dM6vMHoS7URa23ky3WQuQXsRHpnmESGTf8fhw7UNIHEqvG88ROu9bdDUj+mw?=
 =?us-ascii?Q?37K/UTDmErYLVYEvL5uxVPTPnx6BnGMlWb215hVq7ijT+jVKad7HdxZ2UhwQ?=
 =?us-ascii?Q?Iiqq9uFYST5otd3/uEpK7DFmms9VwZ1UyYdUBYHoQoDRt3M4TpUcMlysJdXT?=
 =?us-ascii?Q?UIweGBs4wzURMV/zWsQEYytKAW/5E2ELoBUGyYesVKgaIxf7PYWPxh6tiP5n?=
 =?us-ascii?Q?ayE+parwTg65zln5SrYQSufv4eQ4PSY8WhlAt5DYT0KKoVJW/KswEurR3OCK?=
 =?us-ascii?Q?kraGuLz6E9ZW6a0xo1i4iZT5xB6ldk00zrxMhpy9YADNCaqhaaB004EMg0fF?=
 =?us-ascii?Q?H+en7pFnr9JOzelQzobGV3QwUgVhetcs6mxJLnkI3ZbK+J+Z4YAJjfeVVQiz?=
 =?us-ascii?Q?adxnJBQjgny82NmtEZM3QHOR6kHVUOQmT07KN8/8eEhlPhVKmF3kZJdE12DO?=
 =?us-ascii?Q?vLFrjJXwi4/Mu4sT4N042+qnMfOW4l/S+7WkAU27NQVjos8BjbF9szWGNu/m?=
 =?us-ascii?Q?d0tbUBJVMPKjf8H5Mze3fcqPKZxh3so0ecNTONc5ZF+cpSzKN1qCCkPCXrcE?=
 =?us-ascii?Q?RsoxHDMXhMg2tdVNbjMC0L/qjCKSoENmbeYOB2Vcxd2PcjDK+Q9Sos2jTxrr?=
 =?us-ascii?Q?HkoGeMhNbKxfFmsL8j+kQnIbZpRlDKB81mvhBD0PsvjM6Rjiwz/UZTdLMqrR?=
 =?us-ascii?Q?bLy4ql1dlxHua1kr54qhjmIw/8JjWSV+2LRA1bT0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vZRZld0vqeytj0nfauJLrbjSjqeFFCzAMU6VuCFEN83WpxcxcB5qgzu7JIMiNgyhqtl79OBVuE0yQkKRgLnn2pf9jIEi4F2qRf8qhqBQ37X5j21Fa7339qjoC8BqKEL+A/bKWHpwOfiOZPg+l8lgOtNxs2HCFTsRgHr+wph570XhkdK01B+Im1c+WIvvunjrmUwzgjWNQimVGFo3ebAzbpmr02u8DLnmef4wPck9tzeet5PtZubF0/OnM7zqZ6BxzGs3zZMKkH1U1RmzWe2WT5s9ff3XpvxPHyGqcWFLKs4E1UAZgbqzvvoC90LB+caWWMvQmSZHskM47i6u+NBldcrVyxbcz/Q1OcgzjYSz92ROkVH72TiWXu1akAXtS2ChxQbgTSCo7V5AeFHExpVPcDj6c8P4Vfc4vXA3nrespllTIEfCnihryFNLtBDW+gCNjS5ryGvOOHKiG7E5uufSZaivgzgkA+UUDM3Pb+FXNYy4i76Wy2wXWrvQGVwSBg2U6V30XxnEoQN+PhIewZUbTLTvYYeD98pdhyCttzHGc7Xw4xVfqwiiL12G+FXeuI9YIZ62DudfwCwdKFM8sB2NSWDq5VQlWmbDFJubfBfu7XgLmmoSX4QvI180BWizXb4dV2DtFbmEdkgrKF+sX8wHEODjg30sStn3CFx7MqYGYx8OmKqtTga7d5aV2YKrvMi3t73trc21ZToONqxvYFokX9QnKfnWJajZtulGpBUioWuFcj9Q4Zcnajsnl7B9bOlr+2pzOwZDCnDH6xe/zIEK6giQng4ATf3wF8fzGaDJC0Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b408d8-0a3c-408a-901f-08db72d5cd33
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 04:04:40.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmKro0d3HQE6d3j8D/r/j7qCnYJmF9bIMCZyu8guWa0ZF1MBwJHbciM0R0sKrEr2St+yaDTGGM/F5E3lErEtXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_01,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220032
X-Proofpoint-GUID: O60BXPRuF8CeSe55bUqE217bpKJpsanZ
X-Proofpoint-ORIG-GUID: O60BXPRuF8CeSe55bUqE217bpKJpsanZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 21, 2023 at 08:18:01 AM +1000, Dave Chinner wrote:
> On Tue, Jun 20, 2023 at 08:23:33PM +0530, Chandan Babu R wrote:
>> On Tue, Jun 20, 2023 at 10:20:20 AM +1000, Dave Chinner wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > If the current transaction holds a busy extent and we are trying to
>> > allocate a new extent to fix up the free list, we can deadlock if
>> > the AG is entirely empty except for the busy extent held by the
>> > transaction.
> ....
>> > @@ -577,10 +588,23 @@ xfs_extent_busy_flush(
>> >  	DEFINE_WAIT		(wait);
>> >  	int			error;
>> >  
>> > -	error = xfs_log_force(mp, XFS_LOG_SYNC);
>> > +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>> >  	if (error)
>> > -		return;
>> > +		return error;
>> >  
>> > +	/* Avoid deadlocks on uncommitted busy extents. */
>> > +	if (!list_empty(&tp->t_busy)) {
>> > +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
>> > +			return 0;
>> > +
>> > +		if (busy_gen != READ_ONCE(pag->pagb_gen))
>> > +			return 0;
>> > +
>> > +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
>> > +			return -EAGAIN;
>> > +	}
>> 
>> In the case where a task is freeing an ondisk inode, an ifree transaction can
>> invoke __xfs_inobt_free_block() twice; Once to free the inobt's leaf block and
>> the next call to free its immediate parent block.
>> 
>> The first call to __xfs_inobt_free_block() adds the freed extent into the
>> transaction's busy list and also into the per-ag rb tree tracking the busy
>> extent. Freeing the second inobt block could lead to the following sequence of
>> function calls,
>> 
>> __xfs_free_extent() => xfs_free_extent_fix_freelist() =>
>> xfs_alloc_fix_freelist() => xfs_alloc_ag_vextent_size()
>
> Yes, I think you might be right. I checked inode chunks - they are
> freed from this path via:
>
> xfs_ifree
>   xfs_difree
>     xfs_difree_inobt
>       xfs_difree_inobt_chunk
>         xfs_free_extent_later
> 	  <queues an XEFI for deferred freeing>
>
> And I didn't think about the inobt blocks themselves because freeing
> an inode can require allocation of finobt blocks and hence there's a
> transaction reservation for block allocation on finobt enabled
> filesystems. i.e. freeing can't proceed unless there is some amount
> of free blocks available, and that's why the finobt has an amount of
> per-ag space reserved for it.
>
> Hence, for finobt enabled filesystems, I don't think we can ever get
> down to a completely empty AG and an AGFL that needs refilling from
> the inode path - the metadata reserve doesn't allow the AG to be
> completely emptied in the way that is needed for this bug to
> manifest.
>
> Yes, I think it is still possible for all the free space to be busy,
> and so when online discard is enabled we need to do the busy wait
> after the log force to avoid that. However, for non-discard
> filesystems the sync log force is all that is needed to resolve busy
> extents outside the current transaction, so this wouldn't be an
> issue for the current patchset.

Are you planning to post a new version of this patchset which would solve the
possible cancellation of dirty transaction during freeing inobt blocks?  If
not, I will spend some time to review the current version of the patchset.

>
> I suspect that is why I haven't seen issues on v5 filesystems,
> though I also haven't seen issues on v4 filesystems that don't have
> the finobt per-ag metadata reservation nor the space reservation at
> transaction reservation time. I know that the fstests enospc group
> is exercising the busy flush code, but I doubt that it was exercised
> through the inode btree block freeing path...
>
> I note that the refcount btree block freeing path also call
> xfs_free_extent(). This might be OK, because refcount btree updates
> get called from deferred intent processing, and hence the EAGAIN
> will trigger a transaction roll and retry correctly.
>
> I suspect, however, that both of these paths should simply call
> xfs_free_extent_later() to queue an XEFI for deferred processing,
> and that takes the entire extent freeing path out from under the
> btree operations. 
>
> I'll look into that. Thanks!

-- 
chandan
