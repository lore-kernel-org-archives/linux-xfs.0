Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1723C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhKVLn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:43:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42626 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231697AbhKVLn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:43:26 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBaViP029237;
        Mon, 22 Nov 2021 11:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=W1y4nJGrweG4TpUVjUxRXakbgHtfhiIeVj1Nn3VnIBQ=;
 b=Gj2FZWcPzbyip+8410toPMF9eUqezeX9UO0TC4cWvieisjNUI2BwWnb03iS/VCALc+Sc
 wftzA5SsM8X54CsJQCPsXBV5a5gz32A/MXEfA2kQdf0rqbLAl0SANQbkqjM/EssCxy10
 qVeXQFFdxm/OGzJe3Bk7Z160pi/q7uoiHmZgmwC+cWF7J6qKpvxcqwjgNe5Vf9MIfqKa
 cXySSLbtIXFtcL2Cm8z1ZNgbHOONlw+VNy6NOBa72Pcsa7+E9mObcugmBCXhGjcz6yKw
 hxxV0LQjv1GwzpNsRreukSpI9TbKcLze10XPxIIHbLxKIp0kncAm9ghlauDVyYTOQ4uh 3g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg5gj1d0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:40:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBVMnj193561;
        Mon, 22 Nov 2021 11:40:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3cfasqhdp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:40:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9tkb33hcxzavPW0svADQvpea/h1hRp5cmM0+w1GvQ821qs6gq1tJxUO/JvqajDoi+lZpCMxfKligIGvZ9N9aRDvR30HNbSJkPzTj5UbsUIwVJx3zv5DQUKJnZDK4xIQLK6LqbR94TBSe9xz+W7LHmkc2oFVHd7jXP92g2bi9Ps4T5LEN5fOCq7n1h0T4UB9ZXu39bhkaxRs+1j8vrolYZ7s/57SVXD6tpEoNJILc8dWghb1z4sZhhGjNxOiJBjFban0gUNd9zpEgSZx4OC/jM2yxuBptrh2tQUWHvY06Qa+HVMFTy67oqEUjyXvsfyiDgr94INyo/n+jC8eavEM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1y4nJGrweG4TpUVjUxRXakbgHtfhiIeVj1Nn3VnIBQ=;
 b=JS7qYVkMKiRizCHiuFMSPC79LjkNoc92BGnqpTfTu1YXdpGCDiPKnYDi/ugqrde4QbIVV4iZMRTxfqxAAeAQVsT2T26kHmWmo2e8QicRS0h5uOXtglc2rtN2ydipgbQpH50h27zvgN0P5n2JSWbwZYLGrjgzpUBcfDnQNXt4kNc2NI3dd++8yYWEGTTokdePnyWLVmB2clE6SQya/HLVqyj2GS73weUUoI7GyF/XhhTZ0rXzkl4MKTdqnl3xznx04edmeHXRpPgw5ukQtvyvxX3BqtjrNnMip5lX4HGtEDuhSZNIenPgKhxuzEUDoHcAac0RSIJNiu+uZejyh/0Kcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1y4nJGrweG4TpUVjUxRXakbgHtfhiIeVj1Nn3VnIBQ=;
 b=gWxonKMjoWeCFxcuS8NtQxpnUFm9pGGpmgcj/cjnZA8symHU7a5goOnCawxtulAa62aLVPcCUi59xPDaR5a5Vs4OAMCXN1cnA8rUn5QTC4dlQjCXKhqmczaWNgmGE4CFBILqu2KkWVJFJyym2z3pbUequfKqNxILJ7OOfVTkxV8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2496.namprd10.prod.outlook.com (2603:10b6:805:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Mon, 22 Nov
 2021 11:40:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:40:16 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-12-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/16] xfs: introduce xlog_write_full()
In-reply-to: <20211118231352.2051947-12-david@fromorbit.com>
Message-ID: <87r1b8v2p2.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 22 Nov 2021 17:10:09 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0005.apcprd06.prod.outlook.com
 (2603:1096:404:42::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by TY2PR06CA0005.apcprd06.prod.outlook.com (2603:1096:404:42::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 11:40:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10cb5b69-1b9a-412f-3a8b-08d9adacda91
X-MS-TrafficTypeDiagnostic: SN6PR10MB2496:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2496D871549720BD84728436F69F9@SN6PR10MB2496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3xJW3SfyPwW7y0gN8d5QxzwWgRKAfVx2LH+trzXqiJg3JR5uAuw0J5CorFZuzjt7adk27KclhStEkwGja2Pz388PlsDZAF0qnvAC3BRRKn3lk7v4TcMry3mVmQXsyOOkHGC3GaSNLgQ2Ny6unxt+Sl0FRoBy0TGtooFdWn8NxfQvysZG49/TiH2lyOcPbuzPLWNPvb3+I8snq6Rn85CZazPTC7Npq7/BnURY9Pf2ET89xXg5hfhTMzEjJzwfM6b+4ta6oictikXWz0aQCJ0xRlBPuyu2dtzdhXYPp2NuAo/SprzuuO/pttm9M6cwSojaxf3QTiDhvY+oAsr0CPEp1WvWKgNXAFWWlG5aRfv4Cb1gx8lu7fnXwijMVKjO3z/YivU1L42TFORZ1Eihh3lI5XFP59GWRCsMs8k/iqTiBAx4vcEICNfFxkgW/F8UVKBEfUNxSkgfCOd7PLv7gGG4DWFMK93PW1TCgSjZg+BKY1Ihscm+/Mfyy2dX4TfDY3T4ir2rHz8KVgDdZdAR32k/AfjT3kFZ3XKrXoxuDxZZVM1Sjg3Y/gxwK/Mr4axAmkfJ2I7wcj71Ij4iUG+e/N7SluNtlbfREBJI5QnML+yzFZibyRMdMc3x14VkvWlnKH+2lY8FB++wXc0iGjCijx9mHIFfnq3KtibOSsvuXV8rqgkmzRKrxJDKO1YwBEVEI0ivn1NcvcUAtJDU7Y1ofFbqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(9686003)(38350700002)(8676002)(6486002)(52116002)(316002)(86362001)(6916009)(5660300002)(6666004)(83380400001)(4326008)(6496006)(38100700002)(66556008)(66476007)(53546011)(66946007)(956004)(186003)(33716001)(8936002)(508600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rcYVhozCSM2arX1hf/FCXVYLb74fwgTlR8E+SurvX9D4pEEk9zg9ab2v81aI?=
 =?us-ascii?Q?iOWP7y+YM1NzkX4tMD58Ghe6XaZy6S2z8fixLIj/zfSCSkLfppZreKHrvwv/?=
 =?us-ascii?Q?F5a4PpUZqhc4A4h5OI1lZNANo9WsTSfcIXYeIgp8tRlQ+XNZmj1Agq+mxJwd?=
 =?us-ascii?Q?Sjye5KcZ8gxOlK3/Ub4Rzf8A/5fSYnwNPJue0dJkYZPhD6ue8Lu6bElL8R1/?=
 =?us-ascii?Q?gBmyIOdXwZRpDti06DcREaW/luGCGeybmKyPxDOF/HQmPLbMieTn0j0yXO7q?=
 =?us-ascii?Q?oV6skdiLQ7tymy6ZdxW3849hE/Ef/UR+x5XegyTlLoThbOwzv6s8Zcxmfhj2?=
 =?us-ascii?Q?CwP+Ikb7GS1J27ZVelxOSoOVOBKKpepO92d8aS55HSWgBymlSGS0uY2rGUjb?=
 =?us-ascii?Q?7VF9zugxE/Q6jfhsRtTD3h0gcNLOCM4kQEZzp5aPuePVemjbsyaRI8OFF1nV?=
 =?us-ascii?Q?KLJ93JQpiSjz3C5n6BuQg0x/Mgo5O12OiJQE6OxDZreSd9BRa2AX1+spjHRA?=
 =?us-ascii?Q?9N8ETgTvcXvUsDHVS+17/H53F8lqc2hSwvg/HyItCtYzBOcdn6toMD+cs7Ww?=
 =?us-ascii?Q?t7uMjHutRpi/mhflgJDSe3mgdLipQWC/b+Zs+QCBVfnX+Mxs4S9e4ixgxnyY?=
 =?us-ascii?Q?BQ/4JgOgG1G8mxektWTEAo9YRWZzlA3Ol3rTQvuHMrAQMB188/CZ2Gpm63YG?=
 =?us-ascii?Q?6opHZYUNawlUrYyIDw7YTsnb5cjzuYgqMERTfzPx4HfFR/Hz6BR9AWFx7LJr?=
 =?us-ascii?Q?X6CkMosq/nfR2fzJgi4ZtuByzGP+P1vPcWRZC5pxJsUXInQ1HIGTuMS36Sy0?=
 =?us-ascii?Q?sBB1Qs7uuCNNCV6WY0b8Jv0w2FBtOgHoukQMxd37hN3l9IE4kU99W1ZBaqNr?=
 =?us-ascii?Q?gL6eXg+KrKbV/t76ksUT3TLQEKqtGGuJK2ETaPRMdd+Ml7Cy4oGaEDqfN/8J?=
 =?us-ascii?Q?ZVg3KHQKF3JYQDXZxU9Cjrgh1Y5bZPCb8uHhLObH3wnFvoPJ2Krtf1FEq09Y?=
 =?us-ascii?Q?Muks46vv/s1oN1UkZ7yAQ8sVrpZy/we+eYSMrwqPhwh2OiqXZNGnRqHgi3jp?=
 =?us-ascii?Q?JdVLRziakLSyACNvspC0D5Ntli+zvqUfb0JEJWSBkHKP+co7n1oOe75C/COV?=
 =?us-ascii?Q?e9EyCd5bcJBw7VcHijKztmwzx+Gun8LBaW7i/kjM/FJJTd30FG1sAV1C7CBx?=
 =?us-ascii?Q?dqe/Oo1D9XqG2MW3RX0WzRbgD2Z/Jmw/0PiatJVMv4DcliA/M8BmMqZY0Fmj?=
 =?us-ascii?Q?pwyl+fhFOJpLbif7UNTvlPStvJ8GAZZYNEivru0ltYhxwVo7oPz/biLzC9m0?=
 =?us-ascii?Q?usZvc3tMjeehC1B9oWTno6vn3NhdsfZWkm0nzbT83vTg6e057TlIIiVvH11J?=
 =?us-ascii?Q?poCabtg7r7D2D1M8VxKC7l1GPrmGFacTR5XbrTK4MFwJ6o3gUdwp2spaxSx2?=
 =?us-ascii?Q?qp0xN8iYCfybnMqMYU9lpi4N6lnfpF79+GsfbGIkLTtk/JG9CtlHzWD/rZ3W?=
 =?us-ascii?Q?aD+DZP7gI4wiU5t3/LzeCaeRWsW6MYQFVeDBH8Dv5OimuXrzvdZTYzerTRsy?=
 =?us-ascii?Q?rilfTwiFNjgyZmJZdwzeVYQxvpvDF4qdQXdzuQbiL3/ttzzkr07irKzi35cD?=
 =?us-ascii?Q?F1WnkNO9m/7PUiCI9BCFbJQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10cb5b69-1b9a-412f-3a8b-08d9adacda91
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:40:16.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCHHy7wYunZNaUNV7LaBVuE3muizYtktjLDr5/4GgE8m80/gmj+phqqu/j8w+JgLyb2t2hjVWBvG0GvyRsW99g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2496
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220060
X-Proofpoint-GUID: qRxF37F95HEBg-Kkdo4hvijw2QUUn5zZ
X-Proofpoint-ORIG-GUID: qRxF37F95HEBg-Kkdo4hvijw2QUUn5zZ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Introduce an optimised version of xlog_write() that is used when the
> entire write will fit in a single iclog. This greatly simplifies the
> implementation of writing a log vector chain into an iclog, and sets
> the ground work for a much more understandable xlog_write()
> implementation.
>
> This incorporates some factoring and simplifications proposed by
> Christoph Hellwig.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c | 69 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f26c85dbc765..6d93b2c96262 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2224,6 +2224,58 @@ xlog_print_trans(
>  	}
>  }
>  
> +static inline void
> +xlog_write_iovec(
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	void			*data,
> +	uint32_t		write_len,
> +	int			*bytes_left,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	ASSERT(*log_offset % sizeof(int32_t) == 0);
> +	ASSERT(write_len % sizeof(int32_t) == 0);
> +
> +	memcpy(iclog->ic_datap + *log_offset, data, write_len);
> +	*log_offset += write_len;
> +	*bytes_left -= write_len;
> +	(*record_cnt)++;
> +	*data_cnt += write_len;
> +}
> +
> +/*
> + * Write log vectors into a single iclog which is guaranteed by the caller
> + * to have enough space to write the entire log vector into.
> + */
> +static void
> +xlog_write_full(
> +	struct xfs_log_vec	*lv,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	uint32_t		*len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	int			index;
> +
> +	ASSERT(*log_offset + *len <= iclog->ic_size);
> +
> +	/*
> +	 * Ordered log vectors have no regions to write so this
> +	 * loop will naturally skip them.
> +	 */
> +	for (index = 0; index < lv->lv_niovecs; index++) {
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr,
> +				reg->i_len, len, record_cnt, data_cnt);
> +	}
> +}
> +
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
>  	struct xlog_op_header	*ophdr,
> @@ -2388,8 +2440,8 @@ xlog_write(
>  	int			partial_copy = 0;
>  	int			partial_copy_len = 0;
>  	int			contwr = 0;
> -	int			record_cnt = 0;
> -	int			data_cnt = 0;
> +	uint32_t		record_cnt = 0;
> +	uint32_t		data_cnt = 0;
>  	int			error = 0;
>  
>  	if (ticket->t_curr_res < 0) {
> @@ -2409,7 +2461,6 @@ xlog_write(
>  			return error;
>  
>  		ASSERT(log_offset <= iclog->ic_size - 1);
> -		ptr = iclog->ic_datap + log_offset;
>  
>  		/*
>  		 * If we have a context pointer, pass it the first iclog we are
> @@ -2421,10 +2472,22 @@ xlog_write(
>  			ctx = NULL;
>  		}
>  
> +		/* If this is a single iclog write, go fast... */
> +		if (!contwr && lv == log_vector) {
> +			while (lv) {
> +				xlog_write_full(lv, ticket, iclog, &log_offset,
> +						 &len, &record_cnt, &data_cnt);
> +				lv = lv->lv_next;
> +			}
> +			data_cnt = 0;
> +			break;
> +		}
> +
>  		/*
>  		 * This loop writes out as many regions as can fit in the amount
>  		 * of space which was allocated by xlog_state_get_iclog_space().
>  		 */
> +		ptr = iclog->ic_datap + log_offset;
>  		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
>  			struct xfs_log_iovec	*reg;
>  			struct xlog_op_header	*ophdr;


-- 
chandan
