Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B686C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 16:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhKWQRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 11:17:09 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37034 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235243AbhKWQRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 11:17:09 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANFoo2v010850;
        Tue, 23 Nov 2021 16:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=46nekXZis+3/rrqBd3U/5gdIBk3SnxHGeWsbEQ+mzSo=;
 b=qtggZBOipfORIg+mdC3QDOtyZ2pEChvW8ywPQ8LOBfaqXkKm3HZq9PSxQzPUbsnZtOS2
 c+3Lf6MNvF7wtyek8VEyiADFda17JqJLTtO/dCwPbHkuZTQtomKJCZ+6Bwaf8n1fywLt
 9wLo1cO5Er+f9HXTuXTGK+v+odSBAcZw0MFW0dgxJc0v8NfPQnk1E6wn7HLk3+8QSr2m
 32sk0vf6lBdvjlQ0i5VPDvl/w4UKd1iJpBRFFfpwzz27RGtnWNMQ/CiQ2gFA4W0s40dh
 aGtV0043wGDF2m4b5WKwKYY96Y5y3fHGRMVWFDqVyhHp1KO50ywKHkWFToMfES2grvsB Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55g32rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 16:13:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ANG0go7190209;
        Tue, 23 Nov 2021 16:13:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3cep4ypgt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 16:13:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YySmo66Qe3gUR2XBoVYWplOmRjpndqfXEJpmwe4np5610umUSQ1e9v5HjWo7ogJ+L3jUVAfNlDO5Nq0s2GJ06fJ1OYhf1iw/2VgLpiPPEEDaejjEZ8/BzOr2M7n8TWXpNVa+/K6IoWGwLep39PfHSFr65QgfqmcPRKgKdA9JgTObvohMe0xA2F+n8ZetYvy4KZCXoUmLCkl/wqqAfELQ96HfjyAQANfPWz9ZudhMiDXUvaHkoeI1A3/v3Cd2WKc6cEWsSNv7JrTfJY377+hyMcuW6H1GIpWsunCgXG7SsdZgONfbdp3QcU33l1+58DhEHpWsyT8yBTVSPyvopIZhUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46nekXZis+3/rrqBd3U/5gdIBk3SnxHGeWsbEQ+mzSo=;
 b=QbyTctLISWVk6PnRaE7C/JD5wxQjtbqlZGN1f4xbPGn9/5AwjWXlnxr1eh0ewGjXxQCl1vlRgdvv83ISY0Uwou4DmkdrASCMbPG7HRuEam/JHUuQJPx/dIdfu82jlPn71IPs8cU6mal8lZpGbHeUak+T8B+eu7mh7/Gu1ReS/snc5O7T0N0BISrbZRaW1wY9t+2K4wz/lw6UFf36JfwJd00v8/DWKEhXbCjOi3sIg9O4vp6XosGlaeMBZPQArMHdPDLW9fQEgcqrzFtAAdFnkOKPdaBEVrq8xuHn8HBKnRmpHaNqKFW/WxNjYyNcg5xSxmDgSH9rYtNmSSQLees4ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46nekXZis+3/rrqBd3U/5gdIBk3SnxHGeWsbEQ+mzSo=;
 b=NEV9N7wlkYZzVt7zgBone/cpH65E8vRL6rT0aUcTtSxvpZkhPxKtSRcWgCG5YRALgFH2bGXjOE7IXAP0qggF/YwxBFhS3iUU1z0TxQwO44rTYZjuHGBY9HVHWpgDuLOLPJIXlowxGezE71GYbCWW5qYazCQiQkpSi+kkB2Z+yUE=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB3085.namprd10.prod.outlook.com (2603:10b6:805:da::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 16:13:51 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 16:13:51 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-13-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs: introduce xlog_write_partial()
In-reply-to: <20211118231352.2051947-13-david@fromorbit.com>
Message-ID: <87r1b6j1e4.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 23 Nov 2021 21:43:39 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0092.apcprd02.prod.outlook.com
 (2603:1096:4:90::32) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.15) by SG2PR02CA0092.apcprd02.prod.outlook.com (2603:1096:4:90::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Tue, 23 Nov 2021 16:13:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 874b3625-f528-4094-7321-08d9ae9c3ca2
X-MS-TrafficTypeDiagnostic: SN6PR10MB3085:
X-Microsoft-Antispam-PRVS: <SN6PR10MB308516252F98A71E6EE22A9EF6609@SN6PR10MB3085.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dw47z/gd3kIk0N0Fxybz4ARujRfkjKjeI4tFe8k/EEaa3s0yVLCyxZVOo0YX9NTLsI3ZBCgBUGb/NfvCzz8Hlws2VF8+fXxfk353zMLFhKau5e20+tFv+nDFT/NK9Pd/oRHtEf7jMM157zmIR5rv0I3Zvvj5saNevVo15UvcXdYwehM6Ho5nQm4iEAw65G/m6rC1JAzY9akIHJJ/xKoxj3p3vC1pg7iDXbuJCrpPD7Y6+7yOxPJXnzaYm5zV59Yfrdpua61gMKrru8iFygrn7P2L7h32u2VnZpPlTFFAHI1WWahZ+gZS9ku8tU1I/XQ0q6A+hmZ2snx/mcFKOLx9NJkqsUn5orFJ8P9S+p3h5Hbqe4rfYoTuLqJHzSnONvTXhqFVfe74df4BBej/eAg2a6o4dD6gz5pGdkMcJ0KT7QrR+0eWeoQK07oIL2Mino3cIYJwNQIBSeaqeGoRdK9QXR2zFi9+Rz62DeDBkGlkwfa9aI+SKxRlJuZqB4RaPHsQga1leaDOUIgrJiosUMc3AmA7eYzTQ9yBRlIptQrglbtoxBFdyCLJzSvq8sxDEOqElI9Zp76LxfK2V8qUGTOPv4qPGaEu9/sdseQCT0a/MZWTKRH25Z+bYFNWXHbx2wDpobVXpx+Nz1fL0X9yZ3/JatJmGN+FsJlIPpTJMBo8WMRXEBOaxijRGz9lQryjfXi1VwB6kuQleGgXLuCkZS63kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(956004)(8676002)(66556008)(508600001)(6496006)(33716001)(83380400001)(5660300002)(8936002)(4326008)(86362001)(2906002)(66946007)(6486002)(6666004)(316002)(6916009)(30864003)(66476007)(26005)(186003)(52116002)(53546011)(38100700002)(9686003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iAFEH0OFU8OdTmQkmDRkbQDXhn7L9nxm8z7h1fz7yqBCw6NWzZdGxR3BBoo/?=
 =?us-ascii?Q?3v2CBOppJXu8ghgl2F8GXTa1nJyIq1rp/frQt5bw8aFL4/MTpPJJkmc+jZSK?=
 =?us-ascii?Q?33mV76oEfuX/3uKHtjvTOBQ4FseQ96vl1tUkmtJp8WC2HYhqYNaeJwYwWKgF?=
 =?us-ascii?Q?+xCjdoZU9NaQzs8BNzIrFZZlem0nm58yRLdvjcKM2ZZ9kpYXrhXUJeu95/2E?=
 =?us-ascii?Q?wsHX2Kwr81Cd+BgEelHLzohxsra4uG+hUuTh0HsIVYEXw2ql+oGZT5pPv+rL?=
 =?us-ascii?Q?kb9uU8vHWb+X4z/IbjUIVBkNn9hBfG6qePjHiZ2WG5MQy0qaU1gzockCaSjw?=
 =?us-ascii?Q?6RucutuE+jeTJy93Adn762ono+dMgT2y+pASOXqEyLXG3mCNhKJzFKqrtuyR?=
 =?us-ascii?Q?IF8797bHxbupluPg6rmtZ9zJ7YX1+SATWw56mzIj27/amI2Y5Onvfj6n2yo+?=
 =?us-ascii?Q?6vl4ZvVUQN7YO0pUeFjOcb3ueJFSGhvVsFo07K8ny1x7W+kpGyCUAeMuRAzw?=
 =?us-ascii?Q?qzUdKz7xIEUfhQWekkLxs0xL8ThoWHp3HYjqKGUnbSTSI5lbA6vXdfVTMlLA?=
 =?us-ascii?Q?z6q72G+n+eH7/AOJh5A2VSZH+eJK9DyhRgXYcS6OpDoWFAbM+UN9UAFdPhaF?=
 =?us-ascii?Q?OBVe8FuvH6Y0CRHBVOeC99079Jiao0Qnhd9d9XVdXKs/dR9bJvKPgNCu7Qd4?=
 =?us-ascii?Q?W6cx6t9DY6rMH9PQTDWrHs1j/O793ondJuuGA7MhoCxNFxDA0nGu3GyFqnx9?=
 =?us-ascii?Q?BcAXKe8TvcU12qoF+IQq4CGyuIq18UcWgqtd+aqUqsoCjSg5LhrlVSGvNYaH?=
 =?us-ascii?Q?YtRZXA8h3W/B97NNHkPiO7ApPDnwIvIAEAZFDgoNNIc7WMynKYzbCD+WeZid?=
 =?us-ascii?Q?RtoXulaAuDb85Wfzb/eIWgZjjbYSaIKTJjRqcnn7aSkjXAkmzb3md2D8gXua?=
 =?us-ascii?Q?2s+GaZ15+CwfObuCxjzjXbTZfoWNmDvHNKHU5eCHBhyhHK2nr99TfgkNEI90?=
 =?us-ascii?Q?dd9JDQQgseIYtRA6dVA/pQo/Da6HF2JKTYur6sr5QsvJaVEY9uRhd9YPX/BY?=
 =?us-ascii?Q?0uVIiJDQlwaYtOdQynJY/Ft6IRFPLa9GbvieqBWyV+Tdf3h/7YoF/G6OrDZi?=
 =?us-ascii?Q?+Dyty1RJ09LZIReY+RD33sgtcOokwQsaTkeQXbVRKkfoftBwmu+nI9nCTTEB?=
 =?us-ascii?Q?bhdRw/yjb4m5yPJKqWRJMwMON4chftnSDwqs3W3BIt0oEk0jOoP6vYS077tE?=
 =?us-ascii?Q?Sr0+mRcX7MQNZW18L0VbgYYrf47bkgV++VaojNKmlb5Njw19iEvdp+ZIIMN4?=
 =?us-ascii?Q?erpzjFIO2QLQp1KFko7AEVw51FkZTMiWmogqiN+omzDoQP+rjIQzuqTUtRTw?=
 =?us-ascii?Q?nFT3eGyQzyOpg/uNGgSq3D1y89ksXxI7v3sv4mOaTAuDGnHmUAlZZMQcYUlq?=
 =?us-ascii?Q?yeyRyo3+D8VxOf/y5lzLhzR8Rhqja+3wAn1Tjz/KkKTc1QARjpO/Km3upSwm?=
 =?us-ascii?Q?3ZSJy3Zd4eWNmzCkxncVvhX/NXSH44fn1oRAs4cG918s9jKbeUtA6/jBh2oc?=
 =?us-ascii?Q?9PBdDOT5WfUNfMwuttTY1Llzo0cWYIAz+ttDftRiPIv81suDd+zXofTzzGjq?=
 =?us-ascii?Q?Zje/IJ+ajvFHOlH7gDvZAFo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 874b3625-f528-4094-7321-08d9ae9c3ca2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 16:13:51.4713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7yhGhNdzQJ/fxkYuAowR0rBLJhJb5LJwVChAY1sH3F3oMLvyD416v84K5CQOXmIJ3n1KOd4upMNjACMFXecqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3085
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10176 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230083
X-Proofpoint-ORIG-GUID: bGtZci0996mM8VWjj5z2pe5yICahmAXc
X-Proofpoint-GUID: bGtZci0996mM8VWjj5z2pe5yICahmAXc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Re-implement writing of a log vector that does not fit into the
> current iclog. The iclog will already be in XLOG_STATE_WANT_SYNC
> because xlog_get_iclog_space() will have reserved all the remaining
> iclog space for us, hence we can simply iterate over the iovecs in
> the log vector getting more iclog space until the entire log vector
> is written.
>
> Handling this partial write case separately means we do need to pass
> unnecessary state around for the common, fast path case when the log
> vector fits entirely within the current iclog. It isolates the
> complexity and allows us to modify and improve the partial write
> case without impacting the simple fast path.
>
> This change includes several improvements incorporated from patches
> written by Christoph Hellwig.
>

I have checked the following,

1. op header's oh_len and oh_flags (XLOG_CONTINUE_TRANS for partial writes,
   XLOG_WAS_CONT_TRANS for continuing a partial write and XLOG_END_TRANS when
   ending partial writes) are being assigned correct values.
2. When continuing a partial write, the available reservation in the ticket
   is reduced correctly by one xlog_op_header.
3. The number of op headers and the number of bytes written into the iclog is
   set correctly before releasing an iclog.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 424 +++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_priv.h |   8 -
>  2 files changed, 196 insertions(+), 236 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6d93b2c96262..7dd2bcc7819b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2260,7 +2260,8 @@ xlog_write_full(
>  {
>  	int			index;
>  
> -	ASSERT(*log_offset + *len <= iclog->ic_size);
> +	ASSERT(*log_offset + *len <= iclog->ic_size ||
> +		iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  
>  	/*
>  	 * Ordered log vectors have no regions to write so this
> @@ -2276,111 +2277,177 @@ xlog_write_full(
>  	}
>  }
>  
> -static xlog_op_header_t *
> -xlog_write_setup_ophdr(
> -	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket)
> +static int
> +xlog_write_get_more_iclog_space(
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	**iclogp,
> +	uint32_t		*log_offset,
> +	uint32_t		len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt,
> +	int			*contwr)
>  {
> -	ophdr->oh_clientid = XFS_TRANSACTION;
> -	ophdr->oh_res2 = 0;
> -	ophdr->oh_flags = 0;
> -	return ophdr;
> +	struct xlog_in_core	*iclog = *iclogp;
> +	struct xlog		*log = iclog->ic_log;
> +	int			error;
> +
> +	spin_lock(&log->l_icloglock);
> +	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
> +	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> +	error = xlog_state_release_iclog(log, iclog, 0);
> +	spin_unlock(&log->l_icloglock);
> +	if (error)
> +		return error;
> +
> +	error = xlog_state_get_iclog_space(log, len, &iclog,
> +				ticket, contwr, log_offset);
> +	if (error)
> +		return error;
> +	*record_cnt = 0;
> +	*data_cnt = 0;
> +	*iclogp = iclog;
> +	return 0;
>  }
>  
>  /*
> - * Set up the parameters of the region copy into the log. This has
> - * to handle region write split across multiple log buffers - this
> - * state is kept external to this function so that this code can
> - * be written in an obvious, self documenting manner.
> + * Write log vectors into a single iclog which is smaller than the current chain
> + * length. We write until we cannot fit a full record into the remaining space
> + * and then stop. We return the log vector that is to be written that cannot
> + * wholly fit in the iclog.
>   */
>  static int
> -xlog_write_setup_copy(
> +xlog_write_partial(
> +	struct xfs_log_vec	*lv,
>  	struct xlog_ticket	*ticket,
> -	struct xlog_op_header	*ophdr,
> -	int			space_available,
> -	int			space_required,
> -	int			*copy_off,
> -	int			*copy_len,
> -	int			*last_was_partial_copy,
> -	int			*bytes_consumed)
> -{
> -	int			still_to_copy;
> -
> -	still_to_copy = space_required - *bytes_consumed;
> -	*copy_off = *bytes_consumed;
> -
> -	if (still_to_copy <= space_available) {
> -		/* write of region completes here */
> -		*copy_len = still_to_copy;
> -		ophdr->oh_len = cpu_to_be32(*copy_len);
> -		if (*last_was_partial_copy)
> -			ophdr->oh_flags |= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
> -		*last_was_partial_copy = 0;
> -		*bytes_consumed = 0;
> -		return 0;
> -	}
> +	struct xlog_in_core	**iclogp,
> +	uint32_t		*log_offset,
> +	uint32_t		*len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt,
> +	int			*contwr)
> +{
> +	struct xlog_in_core	*iclog = *iclogp;
> +	struct xlog		*log = iclog->ic_log;
> +	struct xlog_op_header	*ophdr;
> +	int			index = 0;
> +	uint32_t		rlen;
> +	int			error;
>  
> -	/* partial write of region, needs extra log op header reservation */
> -	*copy_len = space_available;
> -	ophdr->oh_len = cpu_to_be32(*copy_len);
> -	ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> -	if (*last_was_partial_copy)
> -		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
> -	*bytes_consumed += *copy_len;
> -	(*last_was_partial_copy)++;
> +	/* walk the logvec, copying until we run out of space in the iclog */
> +	for (index = 0; index < lv->lv_niovecs; index++) {
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		uint32_t		reg_offset = 0;
>  
> -	/* account for new log op header */
> -	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		/*
> +		 * The first region of a continuation must have a non-zero
> +		 * length otherwise log recovery will just skip over it and
> +		 * start recovering from the next opheader it finds. Because we
> +		 * mark the next opheader as a continuation, recovery will then
> +		 * incorrectly add the continuation to the previous region and
> +		 * that breaks stuff.
> +		 *
> +		 * Hence if there isn't space for region data after the
> +		 * opheader, then we need to start afresh with a new iclog.
> +		 */
> +		if (iclog->ic_size - *log_offset <=
> +					sizeof(struct xlog_op_header)) {
> +			error = xlog_write_get_more_iclog_space(ticket,
> +					&iclog, log_offset, *len, record_cnt,
> +					data_cnt, contwr);
> +			if (error)
> +				return error;
> +		}
>  
> -	return sizeof(struct xlog_op_header);
> -}
> +		ophdr = reg->i_addr;
> +		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
>  
> -static int
> -xlog_write_copy_finish(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	uint			flags,
> -	int			*record_cnt,
> -	int			*data_cnt,
> -	int			*partial_copy,
> -	int			*partial_copy_len,
> -	int			log_offset)
> -{
> -	int			error;
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> +		if (rlen != reg->i_len)
> +			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> +
> +		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr,
> +				rlen, len, record_cnt, data_cnt);
> +
> +		/* If we wrote the whole region, move to the next. */
> +		if (rlen == reg->i_len)
> +			continue;
>  
> -	if (*partial_copy) {
>  		/*
> -		 * This iclog has already been marked WANT_SYNC by
> -		 * xlog_state_get_iclog_space.
> +		 * We now have a partially written iovec, but it can span
> +		 * multiple iclogs so we loop here. First we release the iclog
> +		 * we currently have, then we get a new iclog and add a new
> +		 * opheader. Then we continue copying from where we were until
> +		 * we either complete the iovec or fill the iclog. If we
> +		 * complete the iovec, then we increment the index and go right
> +		 * back to the top of the outer loop. if we fill the iclog, we
> +		 * run the inner loop again.
> +		 *
> +		 * This is complicated by the tail of a region using all the
> +		 * space in an iclog and hence requiring us to release the iclog
> +		 * and get a new one before returning to the outer loop. We must
> +		 * always guarantee that we exit this inner loop with at least
> +		 * space for log transaction opheaders left in the current
> +		 * iclog, hence we cannot just terminate the loop at the end
> +		 * of the of the continuation. So we loop while there is no
> +		 * space left in the current iclog, and check for the end of the
> +		 * continuation after getting a new iclog.
>  		 */
> -		spin_lock(&log->l_icloglock);
> -		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -		*record_cnt = 0;
> -		*data_cnt = 0;
> -		goto release_iclog;
> -	}
> +		do {
> +			/*
> +			 * Ensure we include the continuation opheader in the
> +			 * space we need in the new iclog by adding that size
> +			 * to the length we require. This continuation opheader
> +			 * needs to be accounted to the ticket as the space it
> +			 * consumes hasn't been accounted to the lv we are
> +			 * writing.
> +			 */
> +			error = xlog_write_get_more_iclog_space(ticket,
> +					&iclog, log_offset,
> +					*len + sizeof(struct xlog_op_header),
> +					record_cnt, data_cnt, contwr);
> +			if (error)
> +				return error;
> +
> +			ophdr = iclog->ic_datap + *log_offset;
> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +			ophdr->oh_clientid = XFS_TRANSACTION;
> +			ophdr->oh_res2 = 0;
> +			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
>  
> -	*partial_copy = 0;
> -	*partial_copy_len = 0;
> +			ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +			*log_offset += sizeof(struct xlog_op_header);
> +			*data_cnt += sizeof(struct xlog_op_header);
>  
> -	if (iclog->ic_size - log_offset > sizeof(xlog_op_header_t))
> -		return 0;
> +			/*
> +			 * If rlen fits in the iclog, then end the region
> +			 * continuation. Otherwise we're going around again.
> +			 */
> +			reg_offset += rlen;
> +			rlen = reg->i_len - reg_offset;
> +			if (rlen <= iclog->ic_size - *log_offset)
> +				ophdr->oh_flags |= XLOG_END_TRANS;
> +			else
> +				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
> -	/* no more space in this iclog - push it. */
> -	spin_lock(&log->l_icloglock);
> -	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -	*record_cnt = 0;
> -	*data_cnt = 0;
> +			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
> +			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -			xlog_is_shutdown(log));
> -release_iclog:
> -	error = xlog_state_release_iclog(log, iclog, 0);
> -	spin_unlock(&log->l_icloglock);
> -	return error;
> +			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +			xlog_write_iovec(iclog, log_offset,
> +					reg->i_addr + reg_offset,
> +					rlen, len, record_cnt, data_cnt);
> +
> +		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> +	}
> +
> +	/*
> +	 * No more iovecs remain in this logvec so return the next log vec to
> +	 * the caller so it can go back to fast path copying.
> +	 */
> +	*iclogp = iclog;
> +	return 0;
>  }
>  
>  /*
> @@ -2435,14 +2502,11 @@ xlog_write(
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
> -	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
> -	int			index = 0;
> -	int			partial_copy = 0;
> -	int			partial_copy_len = 0;
>  	int			contwr = 0;
>  	uint32_t		record_cnt = 0;
>  	uint32_t		data_cnt = 0;
>  	int			error = 0;
> +	int			log_offset;
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2451,151 +2515,54 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> -	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> -		void		*ptr;
> -		int		log_offset;
> -
> -		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> -						   &contwr, &log_offset);
> -		if (error)
> -			return error;
> +	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> +					   &contwr, &log_offset);
> +	if (error)
> +		return error;
>  
> -		ASSERT(log_offset <= iclog->ic_size - 1);
> +	ASSERT(log_offset <= iclog->ic_size - 1);
>  
> -		/*
> -		 * If we have a context pointer, pass it the first iclog we are
> -		 * writing to so it can record state needed for iclog write
> -		 * ordering.
> -		 */
> -		if (ctx) {
> -			xlog_cil_set_ctx_write_state(ctx, iclog);
> -			ctx = NULL;
> -		}
> -
> -		/* If this is a single iclog write, go fast... */
> -		if (!contwr && lv == log_vector) {
> -			while (lv) {
> -				xlog_write_full(lv, ticket, iclog, &log_offset,
> -						 &len, &record_cnt, &data_cnt);
> -				lv = lv->lv_next;
> -			}
> -			data_cnt = 0;
> -			break;
> -		}
> +	/*
> +	 * If we have a context pointer, pass it the first iclog we are
> +	 * writing to so it can record state needed for iclog write
> +	 * ordering.
> +	 */
> +	if (ctx)
> +		xlog_cil_set_ctx_write_state(ctx, iclog);
>  
> +	while (lv) {
>  		/*
> -		 * This loop writes out as many regions as can fit in the amount
> -		 * of space which was allocated by xlog_state_get_iclog_space().
> +		 * If the entire log vec does not fit in the iclog, punt it to
> +		 * the partial copy loop which can handle this case.
>  		 */
> -		ptr = iclog->ic_datap + log_offset;
> -		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> -			struct xfs_log_iovec	*reg;
> -			struct xlog_op_header	*ophdr;
> -			int			copy_len;
> -			int			copy_off;
> -			bool			ordered = false;
> -			bool			added_ophdr = false;
> -
> -			/* ordered log vectors have no regions to write */
> -			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> -				ASSERT(lv->lv_niovecs == 0);
> -				ordered = true;
> -				goto next_lv;
> -			}
> -
> -			reg = &vecp[index];
> -			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> -			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> -
> -			/*
> -			 * Regions always have their ophdr at the start of the
> -			 * region, except for:
> -			 * - a transaction start which has a start record ophdr
> -			 *   before the first region ophdr; and
> -			 * - the previous region didn't fully fit into an iclog
> -			 *   so needs a continuation ophdr to prepend the region
> -			 *   in this new iclog.
> -			 */
> -			ophdr = reg->i_addr;
> -			if (optype && index) {
> -				optype &= ~XLOG_START_TRANS;
> -			} else if (partial_copy) {
> -                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -					   sizeof(struct xlog_op_header));
> -				added_ophdr = true;
> -			}
> -			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -
> -			len += xlog_write_setup_copy(ticket, ophdr,
> -						     iclog->ic_size-log_offset,
> -						     reg->i_len,
> -						     &copy_off, &copy_len,
> -						     &partial_copy,
> -						     &partial_copy_len);
> -			xlog_verify_dest_ptr(log, ptr);
> -
> -
> -			/*
> -			 * Wart: need to update length in embedded ophdr not
> -			 * to include it's own length.
> -			 */
> -			if (!added_ophdr) {
> -				ophdr->oh_len = cpu_to_be32(copy_len -
> -						sizeof(struct xlog_op_header));
> -			}
> -
> -			ASSERT(copy_len > 0);
> -			memcpy(ptr, reg->i_addr + copy_off, copy_len);
> -			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> -
> -			if (added_ophdr)
> -				copy_len += sizeof(struct xlog_op_header);
> -			record_cnt++;
> -			data_cnt += contwr ? copy_len : 0;
> -
> -			error = xlog_write_copy_finish(log, iclog, optype,
> -						       &record_cnt, &data_cnt,
> -						       &partial_copy,
> -						       &partial_copy_len,
> -						       log_offset);
> -			if (error)
> +		if (lv->lv_niovecs &&
> +		    lv->lv_bytes > iclog->ic_size - log_offset) {
> +			error = xlog_write_partial(lv, ticket, &iclog,
> +					&log_offset, &len, &record_cnt,
> +					&data_cnt, &contwr);
> +			if (error) {
> +				/*
> +				 * We have no iclog to release, so just return
> +				 * the error immediately.
> +				 */
>  				return error;
> -
> -			/*
> -			 * if we had a partial copy, we need to get more iclog
> -			 * space but we don't want to increment the region
> -			 * index because there is still more is this region to
> -			 * write.
> -			 *
> -			 * If we completed writing this region, and we flushed
> -			 * the iclog (indicated by resetting of the record
> -			 * count), then we also need to get more log space. If
> -			 * this was the last record, though, we are done and
> -			 * can just return.
> -			 */
> -			if (partial_copy)
> -				break;
> -
> -			if (++index == lv->lv_niovecs) {
> -next_lv:
> -				lv = lv->lv_next;
> -				index = 0;
> -				if (lv)
> -					vecp = lv->lv_iovecp;
> -			}
> -			if (record_cnt == 0 && !ordered) {
> -				if (!lv)
> -					return 0;
> -				break;
>  			}
> +		} else {
> +			xlog_write_full(lv, ticket, iclog, &log_offset,
> +					 &len, &record_cnt, &data_cnt);
>  		}
> +		lv = lv->lv_next;
>  	}
> -
>  	ASSERT(len == 0);
>  
> +	/*
> +	 * We've already been guaranteed that the last writes will fit inside
> +	 * the current iclog, and hence it will already have the space used by
> +	 * those writes accounted to it. Hence we do not need to update the
> +	 * iclog with the number of bytes written here.
> +	 */
>  	spin_lock(&log->l_icloglock);
> -	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	xlog_state_finish_copy(log, iclog, record_cnt, 0);
>  	error = xlog_state_release_iclog(log, iclog, 0);
>  	spin_unlock(&log->l_icloglock);
>  
> @@ -3752,11 +3719,12 @@ xlog_verify_iclog(
>  					iclog->ic_header.h_cycle_data[idx]);
>  			}
>  		}
> -		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
> +		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
>  			xfs_warn(log->l_mp,
> -				"%s: invalid clientid %d op "PTR_FMT" offset 0x%lx",
> -				__func__, clientid, ophead,
> +				"%s: op %d invalid clientid %d op "PTR_FMT" offset 0x%lx",
> +				__func__, i, clientid, ophead,
>  				(unsigned long)field_offset);
> +		}
>  
>  		/* check length */
>  		p = &ophead->oh_len;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 51254d7f38d6..6e9c7d924363 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -480,14 +480,6 @@ extern struct kmem_cache *xfs_log_ticket_cache;
>  struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
>  		int count, bool permanent);
>  
> -static inline void
> -xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> -{
> -	*ptr += bytes;
> -	*len -= bytes;
> -	*off += bytes;
> -}
> -
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,


-- 
chandan
