Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C72C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 08:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhKXI6N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Nov 2021 03:58:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9884 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234807AbhKXI6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Nov 2021 03:58:09 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8YO98006634;
        Wed, 24 Nov 2021 08:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Od3kunYibtH983sYmkBsLI6gU+CLzOgu+vHEjRnv9X4=;
 b=VyzAgFaKqGUaslIKKj3ZY7L9lr2azvpULMp1Uqv8+ArbO3zsfc3eHo63ivPqGTJr3Uez
 A7G6/IiA24LIVzZGisC4z/3AobnReDY0Pxr9fLiU8CNBtRohosNk7FcrvzvrCvFxc6fW
 rmps/eaVfiuhsT23WeUkkXpfdVWnSEoScjrbZZo/gjweCOH9oAYda4DxHoUt3waqLyXq
 ZDvYX531eg5lMPT4zc8hRy47A+u5QJIoztmOnSztZwNLvUK6GtDZUW1j8dq2YD03g3hv
 1iJMrfziMrm2/Uy+YIPcwT3tgfAvoLu/oDGYw365lLnGsnf0Bxasyo5Fn8cTHV7SBG0s 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69mqsp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:54:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AO8l6DK075022;
        Wed, 24 Nov 2021 08:54:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 3ceru6knht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 08:54:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhnXt1B4pYapw511LRjDwhYc8SvCvm9+rCJK5RMlAYWhnVgdHcfEsOD+aH5Hi1qkxO4mKbFZ6xS6R2GwI8VOheSa8flzuFvgP37a165wRaV7PGtukj9JZSwrU6bTGv/tYIZ6AVB+mzlhqmnWvwc/Kq2Fm2ClqZWlUyaX3L+D0RhKyAE0Fqm5c1SnLehyCLCbwe5YCRm1Zo/QnhCyKHSlGgKZOUXJo4/+u0ZRtkq2T4l6GE4g0HqxEo+XJnpb4fI8AVvzQJ9uBVfYuz7AbYrKYqcunSdE+WvfMWb1vVTtjki++7fMfukgB9kpsUlANST2jas7cIEZkQmz7e5gki0M1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Od3kunYibtH983sYmkBsLI6gU+CLzOgu+vHEjRnv9X4=;
 b=Fyu3zWrkK42+Xjo1YWzre/Zsd4A4RJ0n4omKfnB4m05zp86S8bkzJNenpRVcEzDUDdgN0bPCbaeB0+ChxEXelPmYgWr0VjFTwfSBqI4ZPy7HbQchHQn+6xny67C9DUTooLK8fWdc4IQ/Uh4U99Oz4Sgc91IO2b5NDvX2LyrM1y3s1nrhYBX2PQP3LgbgBBVQRDBbx4UtCDGjl9p3MAyIcxwVGrc75IEXkd/QYZSWR6BZxP1r6ssRpjbB9Nn+wP9l0J4bmmpUHQvc6e18GOmgKz5WTxwrDFXpGMzf3beyfuUlJWqe+5b7kwkwfBAABqp6fU1YxS4EVcqAcDth/h7lZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Od3kunYibtH983sYmkBsLI6gU+CLzOgu+vHEjRnv9X4=;
 b=bkkE3M7OEQRn5RzH4LfogAofUgqOlD6k9i1PWIuFKrcaEloltVM/rCuBao5yVINRTgBPkq1jXWM58Rt/hXrVpvHy62Mdga77asyJeVFb/5X9gsTDeTg87TX8n3bn3GuTosJQ1KIYEioJK//eZBS8t11B3oMInGKiv8vGeDvE+lc=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BYAPR10MB3126.namprd10.prod.outlook.com (2603:10b6:a03:15c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 08:54:51 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::6c4a:b9e2:6c7:cf2%6]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 08:54:51 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-15-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: xlog_write() no longer needs contwr state
In-reply-to: <20211118231352.2051947-15-david@fromorbit.com>
Message-ID: <871r36szlb.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 24 Nov 2021 14:24:40 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0011.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::16) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
Received: from nandi (138.3.205.55) by TYWPR01CA0011.jpnprd01.prod.outlook.com (2603:1096:400:a9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Wed, 24 Nov 2021 08:54:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b89299a3-8618-4a45-3fc3-08d9af28134b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3126:
X-Microsoft-Antispam-PRVS: <BYAPR10MB31266086AD9952A4A7797E88F6619@BYAPR10MB3126.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3T6uJVgIYEzhuc8fxYZutOiB78TgVztBOhciAeklQZyMHPl6W/o+Gnvv68ON6I3v5nmrsqlVi1sPBVPNavoVGtD3FPW9ddv5uGegRAfCouAPwzkhfhHUFpwA66NEew+G/i5O0n8fYdaeW6G/OVr/IowoRiA2JiZZ8a2TrGGWnyfc+RiX0QslCq7IWxAf2VIAaCG3MvJ8vIHzMTaIBt8M37VqQ9tJT5P1VceUUtKUrx82XtBYUujVwKxKKEk8obGzAWDzupfEGOMfh6cIIoNhYDN1PLPgOOWfLe3yX4NQvkRZ51ggb+PiNVjh3ATUEC9kaommjOvUMUd5Ccj7AWxHDPzdL4b95uFj3bQYhfI5oy0lIwzl4HhUjx1k0Mn9Gy6y/p7a6PXLJWBT3/ba89fsCf3mqKNY6NI+bmy2lc2DX7TZLpJTLbsN6GFJXftRDUB8HngYrQN7xCS4jUlsanvo9D0RRU9TKdNhD3eXrvGvN1S7/tVEIWppM64uEJznt3Rt3ODQK9nvUfdDoZToiJaVyicpM4fahDWYhERG0elR9O2OWyT7f2qJK/Oy2rfqsncM8Y/3rNcfMC0UYro2Jp+KL7uG40NxZAfKtSsPOm6siZP7gDwQj6fSY4I70E3jP9cVvFG/FtWOqG2kDP+YgHH0w6mX9ESzI//t9dRg2pKxE8zrlevtungnvSjkL6W5QLpea7MUc+RPWjO4CtHxisGkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(38100700002)(38350700002)(186003)(2906002)(6916009)(33716001)(956004)(8936002)(52116002)(66476007)(26005)(316002)(66556008)(6486002)(66946007)(5660300002)(9686003)(508600001)(83380400001)(4326008)(86362001)(53546011)(6666004)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lG+VggQ4dZMXuWsBxS5ILzmq6mJEnREvBz4U9DLUa7+JSKK4BwFj7mIsZE+X?=
 =?us-ascii?Q?Vdlolmcl3OMov4UMpCnbPfR2fuS6UGWFSzi9iLGg1DB3rm3incMr5W0BdZIk?=
 =?us-ascii?Q?WRhKOH540imcyiU/4rqLVqyg6dVqLD402esEiIoDBvLy461a+vgjmDVzwM4w?=
 =?us-ascii?Q?oebwPHbnZA6UvfDV+KsDisXxB0yluBrB0hOAVhVsvxdsZKkc/sC3r7IUpHVK?=
 =?us-ascii?Q?egHWSO+xIBUHdRftwyWLCqF26lLtzSOBJxiZMCwVs4EIXjlCUznpUJy+w6o0?=
 =?us-ascii?Q?X+5gi7m99OfDlKCq9tCNnU+Xmu+vLVyN+U6nmE8UK0THK8p8iae3zCNJW+zI?=
 =?us-ascii?Q?pF3RtIrrwrhudMM2+R+AC/6meRMa2FtRQhB4ukIjSTAYWWHkrqCLqS3ChKCB?=
 =?us-ascii?Q?tLZDUI7BUvmz8fajYllce5pVVyteg2noKxePRvXP425mVC2she1Ad1uuJdHu?=
 =?us-ascii?Q?nbNwuwiFIOmX4UCAVgyFB71kJZNeyyEkYSL6M6fp5dhPzlR4WlrIGYYbVUZU?=
 =?us-ascii?Q?ya4aLTouIidnH2I58Sg6g2O5qFof7qVBdJxWfMocpLgGs5oaw9hPBRo+XI7I?=
 =?us-ascii?Q?0YHAva6I8F95iKo5TToqm7TdxWjChiliZ+WLQBjZJNk3aMEzsETu3afgJWV+?=
 =?us-ascii?Q?iKcH1C0IifpUJzklHVgQIqWGIKPau+MFk0IeKrQitV6Q3/j3lYGHPc3u2+ny?=
 =?us-ascii?Q?4d9ID6BRdMvmRisSTPmw4Y0gn1XNX61MiAHafgAdW6zSNWcBylvGDM868hBy?=
 =?us-ascii?Q?WPBctMkclwvhmSfuaPox6eIMkKhwqIsIeAI7En2CkXRAEGIkqc2MkkqbimOp?=
 =?us-ascii?Q?90rCxfOnwnX0csKbrtLF2U3REoDORUn2MsEHfdIuHdPgbpjsOv6LZsxNwA9r?=
 =?us-ascii?Q?ACk2h7n8wf58t0V/1X3LJat7wn6COTUizgYP8WiE/EGkMZzbo0fTj/X9G1Pf?=
 =?us-ascii?Q?/kPokH3Fz7H4/8eIdcfg0ZdSpbR1fgFnaEMOYURQ3jf+9Vs266BYXrr4RCvD?=
 =?us-ascii?Q?meLcqxoCXak+IHiRAyR/Tdu7BdOIKKpGwiYC+sFcyKcUz3FXxFJarw+ID8Bd?=
 =?us-ascii?Q?eG00KI+YSqspP11+9Tt2CRbgOG4SDeIwmMUjRemP+Q9HkQzYLXlZMYiXnXQU?=
 =?us-ascii?Q?ZJiinffKb+4o+iLP8x8Z+6JXsK9GMuSkYDFF6bL1/bl9Tv0xvYcnQP6zCtzL?=
 =?us-ascii?Q?XWNf17ba+zxviWijn7rrQzd2FZo2Kyu1k2oFIDw81hdbm+/Vy2Boy3t91WMc?=
 =?us-ascii?Q?O1J2eLv2zerAWvvKWBNnfPwqQSe3mMH1ckf37AuVOWGbo/96I8o6ii94wnjP?=
 =?us-ascii?Q?1EKd7HMB6sv++VA3XQO+uHq9pgU+J12VIFwszNXq8IjTvAGfkcxMXKL4ngYy?=
 =?us-ascii?Q?taYLmgqWWcNgCWCtjV/FzxJSl6ZC5tpq9pYUol3wANbwqqzqn5kMfqrqv9Aj?=
 =?us-ascii?Q?Nsgt6PA0XmDIOACJQg/Bf8FLLPRKNd5Hkd+9dtMq2iBW2do7WDXh0hGsAeNq?=
 =?us-ascii?Q?Q1Ug7lJ8wUdTj6g207vXbyF1koGv8Y72dlGJzQt/mskO8fOuSrr0QL3SKwDJ?=
 =?us-ascii?Q?hAwXYoZN59SXc0JorgXVDRZtsqdCxsGez1zk8KNfP12kXHjt+YcGDInZDVuq?=
 =?us-ascii?Q?Qc5I23CjN9sgTSPUW6kwl7U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89299a3-8618-4a45-3fc3-08d9af28134b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 08:54:51.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gyqAn+/zVgma9KOrMMScYMpN1kgoOwq93ldh+Hnumo/B83zEA1SVECfnzHCgXMJA6vqEaKA6wZmEVjqerKubKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3126
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10177 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240048
X-Proofpoint-GUID: 7f_eK9uBd_yI6_nNKx6lpH_TbO0m3fcA
X-Proofpoint-ORIG-GUID: 7f_eK9uBd_yI6_nNKx6lpH_TbO0m3fcA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> The rework of xlog_write() no longer requires xlog_get_iclog_state()
> to tell it about internal iclog space reservation state to direct it
> on what to do. Remove this parameter.
>
> $ size fs/xfs/xfs_log.o.*
>    text	   data	    bss	    dec	    hex	filename
>   26520	    560	      8	  27088	   69d0	fs/xfs/xfs_log.o.orig
>   26384	    560	      8	  26952	   6948	fs/xfs/xfs_log.o.patched
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 28 ++++++++++------------------
>  1 file changed, 10 insertions(+), 18 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ca8a9313d9c5..da660e09aa5c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -49,7 +49,6 @@ xlog_state_get_iclog_space(
>  	int			len,
>  	struct xlog_in_core	**iclog,
>  	struct xlog_ticket	*ticket,
> -	int			*continued_write,
>  	int			*logoffsetp);
>  STATIC void
>  xlog_grant_push_ail(
> @@ -2277,8 +2276,7 @@ xlog_write_get_more_iclog_space(
>  	uint32_t		*log_offset,
>  	uint32_t		len,
>  	uint32_t		*record_cnt,
> -	uint32_t		*data_cnt,
> -	int			*contwr)
> +	uint32_t		*data_cnt)
>  {
>  	struct xlog_in_core	*iclog = *iclogp;
>  	struct xlog		*log = iclog->ic_log;
> @@ -2292,8 +2290,8 @@ xlog_write_get_more_iclog_space(
>  	if (error)
>  		return error;
>  
> -	error = xlog_state_get_iclog_space(log, len, &iclog,
> -				ticket, contwr, log_offset);
> +	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> +					log_offset);
>  	if (error)
>  		return error;
>  	*record_cnt = 0;
> @@ -2316,8 +2314,7 @@ xlog_write_partial(
>  	uint32_t		*log_offset,
>  	uint32_t		*len,
>  	uint32_t		*record_cnt,
> -	uint32_t		*data_cnt,
> -	int			*contwr)
> +	uint32_t		*data_cnt)
>  {
>  	struct xlog_in_core	*iclog = *iclogp;
>  	struct xlog_op_header	*ophdr;
> @@ -2345,7 +2342,7 @@ xlog_write_partial(
>  					sizeof(struct xlog_op_header)) {
>  			error = xlog_write_get_more_iclog_space(ticket,
>  					&iclog, log_offset, *len, record_cnt,
> -					data_cnt, contwr);
> +					data_cnt);
>  			if (error)
>  				return error;
>  		}
> @@ -2397,7 +2394,7 @@ xlog_write_partial(
>  			error = xlog_write_get_more_iclog_space(ticket,
>  					&iclog, log_offset,
>  					*len + sizeof(struct xlog_op_header),
> -					record_cnt, data_cnt, contwr);
> +					record_cnt, data_cnt);
>  			if (error)
>  				return error;
>  
> @@ -2492,7 +2489,6 @@ xlog_write(
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
> -	int			contwr = 0;
>  	uint32_t		record_cnt = 0;
>  	uint32_t		data_cnt = 0;
>  	int			error = 0;
> @@ -2506,7 +2502,7 @@ xlog_write(
>  	}
>  
>  	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> -					   &contwr, &log_offset);
> +					   &log_offset);
>  	if (error)
>  		return error;
>  
> @@ -2529,7 +2525,7 @@ xlog_write(
>  		    lv->lv_bytes > iclog->ic_size - log_offset) {
>  			error = xlog_write_partial(lv, ticket, &iclog,
>  					&log_offset, &len, &record_cnt,
> -					&data_cnt, &contwr);
> +					&data_cnt);
>  			if (error) {
>  				/*
>  				 * We have no iclog to release, so just return
> @@ -2909,7 +2905,6 @@ xlog_state_get_iclog_space(
>  	int			len,
>  	struct xlog_in_core	**iclogp,
>  	struct xlog_ticket	*ticket,
> -	int			*continued_write,
>  	int			*logoffsetp)
>  {
>  	int		  log_offset;
> @@ -2987,13 +2982,10 @@ xlog_state_get_iclog_space(
>  	 * iclogs (to mark it taken), this particular iclog will release/sync
>  	 * to disk in xlog_write().
>  	 */
> -	if (len <= iclog->ic_size - iclog->ic_offset) {
> -		*continued_write = 0;
> +	if (len <= iclog->ic_size - iclog->ic_offset)
>  		iclog->ic_offset += len;
> -	} else {
> -		*continued_write = 1;
> +	else
>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
> -	}
>  	*iclogp = iclog;
>  
>  	ASSERT(iclog->ic_offset <= iclog->ic_size);


-- 
chandan
