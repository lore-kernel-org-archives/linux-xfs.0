Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BF4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhKVLnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:43:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11290 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhKVLnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:43:03 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMAkxTt007646;
        Mon, 22 Nov 2021 11:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6nhQyY7zPdtocDgd9lOcanN32XfDGaCIzy+zoNnZON4=;
 b=Ki2lphTQOrfpglZahJmsa1Paj+HrN8ID/ot8x56Hkfk7BJZN7CSNg8muvj1Fdx3NJDae
 JNRaszQIIIxHGa7fLCkIey4f5GJw1ql6Y6wpELl7b80h4vII9UgIVI+yiA6pKV/TyZcN
 J6uoEYKfEBeXpkZ6Cs0qVcLrnTo1jhnvLbiKDpXztp7JuVu73ZBzTmk4zUqNKCJKLgw0
 JcbOKFCUph+HakSg3Ghj+HsLun9nQ3Krt0c1/pFmGaWbQ0eIZX7fTs+w5y1Rjnu3nLEb
 FN/fZ+pXxQrkOto83o6z7mGFrDcubQ2LN2Uec+VccgqosG/CmVAxeNfNx5/00qWESFKb IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg4619k2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBVMn1193556;
        Mon, 22 Nov 2021 11:39:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3cfasqhcuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:39:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8fHbxUU/sNv3nY9vAwv7Ync3hvW7qTQFcnIQ41NuOdZwYugNdLXt3i5N0E7ULqDslUBL5C9o+a/WoF92QiZSkiENyHxVDYWbwEeJ5f6YaOmcqdSm24HfTBF0mnjBvXZugVIIclYiNszJRgpHBAWRYAxTgayM7gGs8+AFfXgJSAEXvGayLCEa+Q4K1+FsxtSGZ53od3k/vr5+EkC4AxggvmfTZ+RCJs0Ib8Mnw8vKuV2O0Nvz5EJlqwZrgkNrLyVSU0/GpW9zkl+11eySi9hBZwdTW6rFE3ECGkvHSKLO0y1Fsj2Qn8woWraA+n7jeFgX00WPE/aAxJcpe2snMBKTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nhQyY7zPdtocDgd9lOcanN32XfDGaCIzy+zoNnZON4=;
 b=bd5N50Xh6xKzIlaFK7IXfVsXnS9Bk1GvpZ+zTbSi9EgNmYacrcEIgXXwo5UXslKmO0Kp70WEKhyTY3pOLdRxbfNyb+T/qN7krDTcG5C1mHUo/XNhZS9+uXyIn0q5wPC7QHWx+Bbac/cSJ937+FuxknhJIzgWwFXuX9MXthIBBK2Al4bCYrNBldGgPi8lQajrBLRQ5tFEIcbQZ6rbHu19zAEFgo4h8jLqfGoF9YJIOQn4U/sQ4nfh5jscChAygvDmPA3wQDwE0RSxQkBbCL23dmAg/sXToYZj/MGUGnS/G/PEs2FG40Gl5tIvLSawgsn0DF9M7KkqqLIZJ+r/JxLAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nhQyY7zPdtocDgd9lOcanN32XfDGaCIzy+zoNnZON4=;
 b=YbaXFib4FgHoxzcp6UcIMTKsxU+On1ADY+GmVcgvvwenNSJvt/08KjReK1wek5MaKMsD9+1rXc9k5/ZmeB8UIH5ckmw23G+CLOjEnPgrYlKfCuEs79e7Qp2sDw4W29pqUYNiYvvTMY8cESG1TESOuvLWwD4BhPyKmWTb3vOMjQs=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:39:53 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:39:53 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-10-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs: pass lv chain length into xlog_write()
In-reply-to: <20211118231352.2051947-10-david@fromorbit.com>
Message-ID: <87tug4v2pr.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 22 Nov 2021 17:09:44 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0106.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by TYAPR01CA0106.jpnprd01.prod.outlook.com (2603:1096:404:2a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 11:39:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b6a1e7e-9cf4-4fb3-c4e0-08d9adaccc94
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2496E08683B5A2ED67FD5D17F69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lkUK73nW+/KYb5Tw2qJnU+kXn+mD+LShGZpC0alkXg1tdgQmB9NUDMzXU7/YYPLWPwWWbE/LxRhb09oDPwZMBy8WwHwmRK7aBW9zxgrsCUOnFftZRc5dTKyPCIaIrLWhL5flYfoEaSNEOSX5HeySVFOVcQscCelzChtMIYbXZTyRakxOfQYBLhJdulU/SkRD8hmHscthwj1mGnaHv4Yt1DuMMy6S5D73N3kK5xX9cFXCFzDfWmLWADXD5/ju/Rw5u6yLG+Wm5UJJFYfbbWgGwp6kF3DHUgGyU6oR5xaamd/Q4lCoNtXJF7LINjANhIv5Sn/pdUWYNJ4z8m2Dfkif7g76aWZ/ue/2aRXfeXUs+ajm3XfTwQZ5bMOkREk38hwXv8e3tkeataRCNxjPmjZirUwpNx+9fkYVtSr+bLRra6f3yWDiA8kWQ1wqHgIytf/t5TYDGMoFPvSVNft7ddg1fZtFxcoIdXHGd3xPFRZ8S4GoKdmonB9itl8zbD30srMlxm4GLOraSxf2leHj5GYVzc2s779ar/zJEMpougRu/uLqqZwVIdjUkDtMdN2xXpZsxL7yoOAvnIBodYIwlBZnJEd3rhDtZCrJuTN3pl2HYqF1Uhkh2bG/fmWDpUULu+lbQZ5p8caC1manQwwUbk/zMhj8ixrOdohk3kxMLfCC4UtQ3zL+KrjtlyKVF2itirocdzATVlX2TVFBaLvF9XLMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8afZi/1Ndstp1b2XtHHoJ+Iq6kyhY5HW+sFJU6K9j+8Ana0bOxiRrC5dP0E1?=
 =?us-ascii?Q?rDoJIIwB3lEgl8SoKS4XMpoOhz0/thhoCiG7GJmtNWgxZ+7qOql91yD130uU?=
 =?us-ascii?Q?LumoPfbAlNB4Ka6z7qg53sErZqdimN8FG105wUo0crSYs41kXItjg0V6Iotk?=
 =?us-ascii?Q?MaGaPPwQ/OWuMgoLmMMKyAMSAq8M4R3qie41Od+9b3UTUhQIWga09thqHHWO?=
 =?us-ascii?Q?5He33EAX6KJPP5OE6LdVb2uP9lx0W1u3iyqL+JaHAvzLGgDI6TEHNuQdhkjv?=
 =?us-ascii?Q?S0DnOUHLTYWxR+eZqQPmaexan0yFq2owvttS6mm0lO7W93ExSkL63igryVyr?=
 =?us-ascii?Q?ebkoL5EHDQOKhwj0gRdm4v3fiG3rOsI3bBtVBpmHjCFan+lYhsQqXa2SCZVZ?=
 =?us-ascii?Q?zRZaB7xKd4P0YZJSyMUZ0C58SmtMLSlu23A212khcGXCwmDlx4jXAOBZlbZp?=
 =?us-ascii?Q?2fS+iDTvfyLBfVgTiIHlQai04jpLkXnh9iQcnpFz7tZD57GdvhFi6cPUGQoO?=
 =?us-ascii?Q?6iHeFx7CjzrqNheYjMvXtd8/Pv3dNn0lFu/3cUkUNF7hsa+NQbeHbtsp8nhP?=
 =?us-ascii?Q?kilsQV49HdQP7vz8zzGXOTNiu3nMchGakRnFkbMrWpgKrH3TQOWN4/WRC0du?=
 =?us-ascii?Q?DWbf56Bm0SBFHK08MN7b+rvcLvPIPx8wteoSQGwwly9z24GnOMnRA8TdA2Uy?=
 =?us-ascii?Q?/zg7ciFukcNvtOHYlPBvXmQjXD56pvty2LTk5MYL5WQwfeO1X4MoKHl/X5qT?=
 =?us-ascii?Q?TU2B6XA1kzylrD44geYZgtbmdOk6Tk8W9DKwnNGUkiZpECwtYlJHn8XPT3zl?=
 =?us-ascii?Q?4M1Zxs9VY6Xs5S98Q7rDpVkV8Cv44XF5KYpG7SkwtByNJvSYsh6UVUllfdLG?=
 =?us-ascii?Q?e81EKqbBEgchCRsR9dbMiYFWX7fFzZavGZN1UMw34yTe2CBnWr8F0P+/XVbN?=
 =?us-ascii?Q?mRV8G79JCLOrTLhL5kg2ItgZTnIyAZMutNsFkoqWTwPfW33P0c3QpHhbEmij?=
 =?us-ascii?Q?tyXSjU9oTPfrZ/AnDINGzvA89WxoLObbLhgoJOgO/UMM5C3ea0bjc859zuQm?=
 =?us-ascii?Q?C4ZJrNDepi9J+HId7sCULgQJ8EdCO8hdWBuJTNMMo8nIcWznqHNNeeIKs+V6?=
 =?us-ascii?Q?xumHBoXe006FX1R0pwWaVdTZlMElQ7G1PU7hF1UEh8U5Frtx1ld6KSlpiM+R?=
 =?us-ascii?Q?8z+2N2yOqujFVCM8jIsJzzLxaGsQ8rOlUeJx+bXdAavwrjdBzprsKbyTaIjH?=
 =?us-ascii?Q?zgJq3H0HeGHrvwVclBxI08ok1aNE77uuvCXAy4UPAsJPSuLkBBvY/thTVq2F?=
 =?us-ascii?Q?z2SIU5BlZ/iZrOo2V5jPWNsfib3KG8rE09K3QoM76x9ArY5p+1/q6GG77dTp?=
 =?us-ascii?Q?C4xVvsllCSEX6Jl1I2hae+3Yt+nsn/TeXAQYWwKsMlHtiZkz7j14+y6IwJJW?=
 =?us-ascii?Q?4eAY1k2HxDfx1705no2sZBv2fISJnYV0bnhLembEuUznOwEEhFlpJ4AGEXcF?=
 =?us-ascii?Q?qIftPIuBJAtMWSBknUYTs+Wp8KP2alv5zuEU7/SbJ6zQQqUazTj3opBe5gnm?=
 =?us-ascii?Q?XcC1PuZo3b+MOtgxff66Q5Ij2YF3Ww/IjRc3SMMJvUqfja45LOD0w00vY25L?=
 =?us-ascii?Q?kxAki83S5/lWaPmG/u/uWWg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6a1e7e-9cf4-4fb3-c4e0-08d9adaccc94
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:39:53.1412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v18igzLG8SDnxmgt0tU/YoJJ1MOeY+meji6qtyJ6uYa+SWUv27HC7yC8SjPG6RQtrSQbC1tpXs+BsSXE+yNoqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: OSuouaqhx2OVyDULfki2ZmTeNaotVB4M
X-Proofpoint-ORIG-GUID: OSuouaqhx2OVyDULfki2ZmTeNaotVB4M
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> The caller of xlog_write() usually has a close accounting of the
> aggregated vector length contained in the log vector chain passed to
> xlog_write(). There is no need to iterate the chain to calculate he
> length of the data in xlog_write_calculate_len() if the caller is
> already iterating that chain to build it.
>
> Passing in the vector length avoids doing an extra chain iteration,
> which can be a significant amount of work given that large CIL
> commits can have hundreds of thousands of vectors attached to the
> chain.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 35 +++++------------------------------
>  fs/xfs/xfs_log_cil.c  | 25 +++++++++++++++++--------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  3 files changed, 23 insertions(+), 39 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bd2e50804cb4..76d5a743f6fb 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -972,7 +972,8 @@ xlog_write_unmount_record(
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= sizeof(unmount_rec);
>  
> -	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS);
> +	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS,
> +			reg.i_len);
>  }
>  
>  /*
> @@ -2223,32 +2224,6 @@ xlog_print_trans(
>  	}
>  }
>  
> -/*
> - * Calculate the potential space needed by the log vector. All regions contain
> - * their own opheaders and they are accounted for in region space so we don't
> - * need to add them to the vector length here.
> - */
> -static int
> -xlog_write_calc_vec_length(
> -	struct xlog_ticket	*ticket,
> -	struct xfs_log_vec	*log_vector,
> -	uint			optype)
> -{
> -	struct xfs_log_vec	*lv;
> -	int			len = 0;
> -	int			i;
> -
> -	for (lv = log_vector; lv; lv = lv->lv_next) {
> -		/* we don't write ordered log vectors */
> -		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> -			continue;
> -
> -		for (i = 0; i < lv->lv_niovecs; i++)
> -			len += lv->lv_iovecp[i].i_len;
> -	}
> -	return len;
> -}
> -
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
>  	struct xlog_op_header	*ophdr,
> @@ -2402,13 +2377,14 @@ xlog_write(
>  	struct xfs_cil_ctx	*ctx,
>  	struct xfs_log_vec	*log_vector,
>  	struct xlog_ticket	*ticket,
> -	uint			optype)
> +	uint			optype,
> +	uint32_t		len)
> +
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
>  	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
>  	int			index = 0;
> -	int			len;
>  	int			partial_copy = 0;
>  	int			partial_copy_len = 0;
>  	int			contwr = 0;
> @@ -2423,7 +2399,6 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> -	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
>  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  		void		*ptr;
>  		int		log_offset;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 90a0e9b9d3e0..99ef13f1b248 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -791,7 +791,8 @@ xlog_cil_order_write(
>  static int
>  xlog_cil_write_chain(
>  	struct xfs_cil_ctx	*ctx,
> -	struct xfs_log_vec	*chain)
> +	struct xfs_log_vec	*chain,
> +	uint32_t		chain_len)
>  {
>  	struct xlog		*log = ctx->cil->xc_log;
>  	int			error;
> @@ -799,7 +800,8 @@ xlog_cil_write_chain(
>  	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
>  	if (error)
>  		return error;
> -	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS);
> +	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS,
> +			chain_len);
>  }
>  
>  /*
> @@ -838,7 +840,8 @@ xlog_cil_write_commit_record(
>  
>  	/* account for space used by record data */
>  	ctx->ticket->t_curr_res -= reg.i_len;
> -	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
> +	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS,
> +			reg.i_len);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -901,11 +904,12 @@ xlog_cil_build_trans_hdr(
>  				sizeof(struct xfs_trans_header);
>  	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
>  
> -	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
> -
>  	lvhdr->lv_niovecs = 2;
>  	lvhdr->lv_iovecp = &hdr->lhdr[0];
> +	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
>  	lvhdr->lv_next = ctx->lv_chain;
> +
> +	tic->t_curr_res -= lvhdr->lv_bytes;
>  }
>  
>  /*
> @@ -932,7 +936,8 @@ xlog_cil_push_work(
>  	struct xlog		*log = cil->xc_log;
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*new_ctx;
> -	int			num_iovecs;
> +	int			num_iovecs = 0;
> +	int			num_bytes = 0;
>  	int			error = 0;
>  	struct xlog_cil_trans_hdr thdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
> @@ -1033,7 +1038,6 @@ xlog_cil_push_work(
>  	 * by the flush lock.
>  	 */
>  	lv = NULL;
> -	num_iovecs = 0;
>  	while (!list_empty(&cil->xc_cil)) {
>  		struct xfs_log_item	*item;
>  
> @@ -1047,6 +1051,10 @@ xlog_cil_push_work(
>  		lv = item->li_lv;
>  		item->li_lv = NULL;
>  		num_iovecs += lv->lv_niovecs;
> +
> +		/* we don't write ordered log vectors */
> +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> +			num_bytes += lv->lv_bytes;
>  	}
>  
>  	/*
> @@ -1085,6 +1093,7 @@ xlog_cil_push_work(
>  	 * transaction header here as it is not accounted for in xlog_write().
>  	 */
>  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> +	num_bytes += lvhdr.lv_bytes;
>  
>  	/*
>  	 * Before we format and submit the first iclog, we have to ensure that
> @@ -1092,7 +1101,7 @@ xlog_cil_push_work(
>  	 */
>  	wait_for_completion(&bdev_flush);
>  
> -	error = xlog_cil_write_chain(ctx, &lvhdr);
> +	error = xlog_cil_write_chain(ctx, &lvhdr, num_bytes);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 47165c4d2a49..56df86d62430 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -492,7 +492,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
>  		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
> -		uint optype);
> +		uint optype, uint32_t len);
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);


-- 
chandan
