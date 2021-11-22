Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DA2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Nov 2021 11:29:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhKVLcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 06:32:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2434 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236312AbhKVLct (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 06:32:49 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMAYEHo017084;
        Mon, 22 Nov 2021 11:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=hzCtjbhKEwUT6obkclhm3MrExAr9NXlT1ZmEhs83iWI=;
 b=nH/M4L5TFK95e/LU6MV38B14t+ZkpgQqfDlwop82OTRgJRLL1qSJZFqs5CZ2jTSqjCXa
 nBg+G9qXZj4LZDrH31xhcclNjePz+rmYdZhEAD/BrcM1BZ664yVET7zPIwNg5nI3uChY
 RcveYAaxvPbv8hBZmeTG6CUq1rQ80OBq6Cqcu3crxscArlh5RptjIeB3Bhzugj6GwObB
 Ije220xOt7d6/fCd1rq2jwEGkWP+lRZ2zVrkeLLqFJRTax3j9yALbNadzMeQEttHWwZ/
 Q62ucsG12lF06XBNFUbh4JxQDlpuRinY45I1ROJetfGpiH7lEOHv4afsSIoO36foBc7Z pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46f1ks5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:29:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AMBAXbA173743;
        Mon, 22 Nov 2021 11:29:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3cep4whtu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 11:29:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJUKCNBB4H8sHH6HtCYPqN72RnbFaDfFZDqlKZMz+l51y3mkhZRfKl3YSY1fsgK6rPj7mJrXLOETybv+Pgq/LE6TgrrMTB4ZgD9Kxj9bWsM4DnBAfy1Z3azX7xz2WIL3Sprh+vsyeIQeL6/a+1ns9+3/dsduAT+zaXhy0EXcZyf60rgQ/ajdKbl7HLnbpfQUac9pu7Vdnxgct5jmlKH7nUgQrNFhMfr0Ql/elhX4v5ns2e8Ty/pwSLuKDDtQ1IIwqoFEWMKvkF//lKZP8DMsn1+xIEIGvyPxClKuZ5WHuinAQ0eFU/tR3nuJfcqL+/9D2GFMXvB9Xx5rtMir+kdI7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzCtjbhKEwUT6obkclhm3MrExAr9NXlT1ZmEhs83iWI=;
 b=ehYNfPXe8jW+m8LqIpL4wzlGrnJxVo3MUMsfFdCYn/yfP/uKwYxSipFcYBte/ihiwDchtZ3I30FEcaT0xvFDn0KmQB9Q+OzMte5zgIC1a7gsEnAOVP7vZUAuLdOsB2FtWJvtRUnUV8GjmI6eR+ByBtHzLNnK10gsPopJ0hrsH7RoWKqtim5Q/4DLderXtlxZVWZ8KGyB0wkYWo4d53Epu6WnT4Ymt0MkOiREJjObtZpK92YoT6bE6DsDGvE9UECPeeSKRpB6UK6L2ZThiLFo/574KKiI7agGC2fz+Y/JuWKBAAHIIFZRPXXu2mXDqimsYKhBZlf0oA3ejHw5i8vy6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzCtjbhKEwUT6obkclhm3MrExAr9NXlT1ZmEhs83iWI=;
 b=MoXSNX8Q7N3oxqoyK0ejnBD/KkR+70/DVQNyhQVKChoyj1sPOa5J1wihjWawMkrvFEO0Mi4N/k388Wh97vOhO1bWa+HRmDpInjG69Q7OT3tPNT31Gtu4ZUf4n//2Y1Vu1S8+ltQ38hdAt7Z5gN4uBQkjmHQqs7jc/zlShSW/0Cw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2877.namprd10.prod.outlook.com (2603:10b6:805:cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 11:29:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%9]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 11:29:38 +0000
References: <20211118231352.2051947-1-david@fromorbit.com>
 <20211118231352.2051947-3-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/16] xfs: only CIL pushes require a start record
Message-ID: <87bl2dvoy7.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20211118231352.2051947-3-david@fromorbit.com>
Date:   Mon, 22 Nov 2021 16:59:27 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0097.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.57) by SG2PR01CA0097.apcprd01.prod.exchangelabs.com (2603:1096:3:15::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Mon, 22 Nov 2021 11:29:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f78bc5eb-1c8d-4aea-7f38-08d9adab5e1f
X-MS-TrafficTypeDiagnostic: SN6PR10MB2877:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2877DB53CF459AD3FE94BB90F69F9@SN6PR10MB2877.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bkSjbCqiaV7SzRcpr6RT/FdvWeI4hX5VGPc1i9mplKFJiqgGeOMjQst35arBlzg1Z00PigXmxmre4ZWFb3tA6xT6gt9q+uF7NtGm/J2TSOWrz+OEDPYskLbEtftMTDQb3PfaskN3bi5YjyeSgZu6D7TVzAN3pji5IE92Lupj/zffL1N/lD22LyitEKzm86tpY36iGs7Mon/jXXS9azyMx0j7YjQtw7+XyLbm6HXjR7/7p8u9BJnta/S1Rxud56kh0taJVVUFyO82fp8dgk74AWcjM4hGDkYh/BnHaRNkJyK6llK9npbFEVHXC75gc9jEUS2JJtqGfgBDDPFpW38nx+mHvOpPEoJ0PEK0+hBK0m6VXQ4yHtYfHMjGH17ZDECp9D8rMnqtHNLHiZPE89+esGdulb5df0d7OIa8E6FSuCJ6vEwz5tI28lvzVk3sS73nq38FSZQNeqXx/3HS9h8Ek/TrmorQpvJhGuiFGR0yz7O2zlJ9MSzRQpbXpAGXlFaQsvFjns3l2ybOVOPfG+O+pmOHKFSpnBbkV9FRJRpBZ5yeypZOlpS/50+oACFgx7vhOlT3SN/sHEnDrk6C9dpSDDCuiWFYcn2AS1POwXlvyXKktCXyrh7bHBmQtpRQ7aszqvhrZn6kJsvbj8mmoIxPbxHzbgz+WHTuqJN0+7klATKyFKA3elyR8bGJzagFCOxT0GLF0r4Mlr1w4AUP3clxAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(2906002)(66476007)(5660300002)(6666004)(9686003)(4326008)(33716001)(508600001)(83380400001)(8676002)(316002)(53546011)(66556008)(8936002)(66946007)(6496006)(956004)(6916009)(52116002)(38100700002)(38350700002)(6486002)(186003)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GWdFouvNv+ZsnBZfJJ8G2S8cs+2wzRTqyw614960/WVExAM9F5bFncrqiQGQ?=
 =?us-ascii?Q?JSSTsrGfTbSIbf2ZEhHPHoWgRW4Dm5yjvST2E2adlFlkp0+DoCKEUFqCjV+x?=
 =?us-ascii?Q?OiQIZY+iTPk1LAmCv8Tl95pHqIpMnxuG9QrMRuTRiXpzyVe1wDSkySIA+fXF?=
 =?us-ascii?Q?6THom6FH2RIm8edWD/8FCF1V6GI1Y/KjlPjkYVxHBBkNeXPxb0oKMGqSSkiJ?=
 =?us-ascii?Q?LYc1CCFjZ5R6cV+wBpzzoXFx0qrAhlIcmXlLHCcC96unRzDUNvgCagFjX5Yp?=
 =?us-ascii?Q?rsMSaXp5I8zQajaBJRFXSAR4v+Oun2Q+7PA3s7k+YCioiqn2iyjFqxARFeaE?=
 =?us-ascii?Q?UyGL6oxbzMxMnDIZxtwkZ1MxHspOLVXgRuGGQ4YkqS83eBw88nsFK59UMONx?=
 =?us-ascii?Q?taeBav62GA5MaYGQjTpbGEuo2E2Ts35LLx17JSFRv2fRvCvye+i2HlGHr+gh?=
 =?us-ascii?Q?ZHtCm/0xdwSPpSzJESTpW/w4VFdZG32dtiF/VsWetFdxdUX3+DBE27ckiCt/?=
 =?us-ascii?Q?iru0usVf+7y7NjrcLKOV068dNc4yLd0tv9U53Yq4A6MZrbR5flhf2nEIktIZ?=
 =?us-ascii?Q?COmYUx+8G8G+luPShDAQhjxy58VjdjmqejAoeuiPMZmL5TzZo8l7hR4CMKiD?=
 =?us-ascii?Q?OsgKam+VeORat/3weuw/t+zhDIBo+Mu/0Rio7pbqD7vq81KhCQoybod/yjts?=
 =?us-ascii?Q?+TGU+e4BMg0N2qIal2DEU1DhG7KJ2ddg/vEe2WZ5xnKbbu5qZLadSl1EPhp6?=
 =?us-ascii?Q?m0JQnioVAu9TQxVMw7naQjm5O2c67Iq4/TiYCsV41QGef+KkVtx9SNVfXIwK?=
 =?us-ascii?Q?94LVV2WuzhGs+Bkocjv2Lb63F8yXeIm+UM/UpAmiiw/LdFfTdejId7PmtyFG?=
 =?us-ascii?Q?jvRLSP2n9nGde1jRRnZUdn9h+SNkX7T5B41FBtSrOqQonGGaMnGCXb6VttVv?=
 =?us-ascii?Q?q6sQuZYfzviMa+3uV6nAogkGsja8DonBzpZOsdYCJam/SXdfpt0geCajZIbp?=
 =?us-ascii?Q?L7WlzG/ba+HuJC/Z1VIaRYpUK1mM5Yud9fiAKOJ6kMihKUi40E3OfsZQW3MH?=
 =?us-ascii?Q?g5Haz3qqCkNIwI8Tc7SvMME9hG8Ru0f3sxtqqpPyRNZJNOTVcePxOZXUBIXT?=
 =?us-ascii?Q?xtoGSS1wNWuS6G0p8Z3rYviOqlcqYIvidMI/gax5fYTnaSWsHSyX6evj9zaZ?=
 =?us-ascii?Q?hy2Znke6tMajmSRK0J3xt48O4/hvZKyDYMlj1hbRsKyiSfIAfx9nCrGE3ef3?=
 =?us-ascii?Q?KnT2wK1d99IzAQMs+T36r9dhXqff9Wh+9Eu3sothSu95S1+lttkp9w+ax9I0?=
 =?us-ascii?Q?0kdD37Crtde4h00ue2jCEMvfA+jI1V8yy/dHEauk9zdXtQSx4kOzv7cNOo+q?=
 =?us-ascii?Q?GVcOZ1VBpuOfd4YDhZu9gCBxgSkxgienLCyCAE09hpHkFpZ473uj43iHtAuC?=
 =?us-ascii?Q?bowF6oORVKSVPcGHHDhlHDhemF9AOFanQIDRnu184z5NA8JZvYkKDgLeJZKK?=
 =?us-ascii?Q?Y6EULJoh+JLxHf4YxlWAomvUoCkFqrYx7o3909wdNZ8GBUc1d4HdH0dve7kl?=
 =?us-ascii?Q?lYZfKzCy90bgNM41Tignel3NAA9VwqhpZpc4aFHD46lgYn5nFXAYLXoBR8uT?=
 =?us-ascii?Q?elAhJ7kHLmD6uU4oSqPwdwE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f78bc5eb-1c8d-4aea-7f38-08d9adab5e1f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 11:29:38.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJaikC5CWnNOhj0GGHBTAMOLcK9L4f5dxubpj3vG5g+GviToPxQIqSdV2O0hV2DmPZcnv+5kqWVnp3n0laqCjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2877
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10175 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111220059
X-Proofpoint-GUID: 0dcDT5hx7FP6qufRNRl5zZjwAud-WM4o
X-Proofpoint-ORIG-GUID: 0dcDT5hx7FP6qufRNRl5zZjwAud-WM4o
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19 Nov 2021 at 04:43, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> So move the one-off start record writing in xlog_write() out into
> the static header that the CIL push builds to write into the log
> initially. This simplifes the xlog_write() logic a lot.
>
> pahole on x86-64 confirms that the xlog_cil_trans_hdr is correctly
> 32 bit aligned and packed for copying the log op and transaction
> headers directly into the log as a single log region copy.
>
> struct xlog_cil_trans_hdr {
>         struct xlog_op_header      oph[2];               /*     0    24 */
>         struct xfs_trans_header    thdr;                 /*    24    16 */
>         struct xfs_log_iovec       lhdr[2];              /*    40    32 */
>
>         /* size: 72, cachelines: 2, members: 3 */
>         /* last cacheline: 8 bytes */
> };
>
> A wart is needed to handle the fact that length of the region the
> opheader points to doesn't include the opheader length. hence if
> we embed the opheader, we have to substract the opheader length from
> the length written into the opheader by the generic copying code.
> This will eventually go away when everything is converted to
> embedded opheaders.
>

I verified the following,
1. xlog_write() assigns correct values to oh_len field of embedded op
   headers.
2. Regions with embedded op headers don't end up having an extra op header
   inserted.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 90 ++++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c | 43 +++++++++++++++++----
>  2 files changed, 81 insertions(+), 52 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89fec9a18c34..e2953ce470de 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2235,9 +2235,9 @@ xlog_print_trans(
>  }
>  
>  /*
> - * Calculate the potential space needed by the log vector.  We may need a start
> - * record, and each region gets its own struct xlog_op_header and may need to be
> - * double word aligned.
> + * Calculate the potential space needed by the log vector. If this is a start
> + * transaction, the caller has already accounted for both opheaders in the start
> + * transaction, so we don't need to account for them here.
>   */
>  static int
>  xlog_write_calc_vec_length(
> @@ -2250,9 +2250,6 @@ xlog_write_calc_vec_length(
>  	int			len = 0;
>  	int			i;
>  
> -	if (optype & XLOG_START_TRANS)
> -		headers++;
> -
>  	for (lv = log_vector; lv; lv = lv->lv_next) {
>  		/* we don't write ordered log vectors */
>  		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
> @@ -2268,24 +2265,20 @@ xlog_write_calc_vec_length(
>  		}
>  	}
>  
> +	/* Don't account for regions with embedded ophdrs */
> +	if (optype && headers > 0) {
> +		if (optype & XLOG_START_TRANS) {
> +			ASSERT(headers >= 2);
> +			headers -= 2;
> +		}
> +	}
> +
>  	ticket->t_res_num_ophdrs += headers;
>  	len += headers * sizeof(struct xlog_op_header);
>  
>  	return len;
>  }
>  
> -static void
> -xlog_write_start_rec(
> -	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket)
> -{
> -	ophdr->oh_tid	= cpu_to_be32(ticket->t_tid);
> -	ophdr->oh_clientid = ticket->t_clientid;
> -	ophdr->oh_len = 0;
> -	ophdr->oh_flags = XLOG_START_TRANS;
> -	ophdr->oh_res2 = 0;
> -}
> -
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
>  	struct xlog		*log,
> @@ -2481,9 +2474,11 @@ xlog_write(
>  	 * If this is a commit or unmount transaction, we don't need a start
>  	 * record to be written.  We do, however, have to account for the
>  	 * commit or unmount header that gets written. Hence we always have
> -	 * to account for an extra xlog_op_header here.
> +	 * to account for an extra xlog_op_header here for commit and unmount
> +	 * records.
>  	 */
> -	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> +		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -2524,7 +2519,7 @@ xlog_write(
>  			int			copy_len;
>  			int			copy_off;
>  			bool			ordered = false;
> -			bool			wrote_start_rec = false;
> +			bool			added_ophdr = false;
>  
>  			/* ordered log vectors have no regions to write */
>  			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> @@ -2538,25 +2533,24 @@ xlog_write(
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
>  			/*
> -			 * Before we start formatting log vectors, we need to
> -			 * write a start record. Only do this for the first
> -			 * iclog we write to.
> +			 * The XLOG_START_TRANS has embedded ophdrs for the
> +			 * start record and transaction header. They will always
> +			 * be the first two regions in the lv chain.
>  			 */
>  			if (optype & XLOG_START_TRANS) {
> -				xlog_write_start_rec(ptr, ticket);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						sizeof(struct xlog_op_header));
> -				optype &= ~XLOG_START_TRANS;
> -				wrote_start_rec = true;
> -			}
> -
> -			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, optype);
> -			if (!ophdr)
> -				return -EIO;
> +				ophdr = reg->i_addr;
> +				if (index)
> +					optype &= ~XLOG_START_TRANS;
> +			} else {
> +				ophdr = xlog_write_setup_ophdr(log, ptr,
> +							ticket, optype);
> +				if (!ophdr)
> +					return -EIO;
>  
> -			xlog_write_adv_cnt(&ptr, &len, &log_offset,
> +				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
> -
> +				added_ophdr = true;
> +			}
>  			len += xlog_write_setup_copy(ticket, ophdr,
>  						     iclog->ic_size-log_offset,
>  						     reg->i_len,
> @@ -2565,13 +2559,22 @@ xlog_write(
>  						     &partial_copy_len);
>  			xlog_verify_dest_ptr(log, ptr);
>  
> +
> +			/*
> +			 * Wart: need to update length in embedded ophdr not
> +			 * to include it's own length.
> +			 */
> +			if (!added_ophdr) {
> +				ophdr->oh_len = cpu_to_be32(copy_len -
> +						sizeof(struct xlog_op_header));
> +			}
>  			/*
>  			 * Copy region.
>  			 *
> -			 * Unmount records just log an opheader, so can have
> -			 * empty payloads with no data region to copy. Hence we
> -			 * only copy the payload if the vector says it has data
> -			 * to copy.
> +			 * Commit and unmount records just log an opheader, so
> +			 * we can have empty payloads with no data region to
> +			 * copy.  Hence we only copy the payload if the vector
> +			 * says it has data to copy.
>  			 */
>  			ASSERT(copy_len >= 0);
>  			if (copy_len > 0) {
> @@ -2579,12 +2582,9 @@ xlog_write(
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  						   copy_len);
>  			}
> -			copy_len += sizeof(struct xlog_op_header);
> -			record_cnt++;
> -			if (wrote_start_rec) {
> +			if (added_ophdr)
>  				copy_len += sizeof(struct xlog_op_header);
> -				record_cnt++;
> -			}
> +			record_cnt++;
>  			data_cnt += contwr ? copy_len : 0;
>  
>  			error = xlog_write_copy_finish(log, iclog, optype,
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 28f8104fbef1..9a810a2c92e9 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -835,14 +835,22 @@ xlog_cil_write_commit_record(
>  }
>  
>  struct xlog_cil_trans_hdr {
> +	struct xlog_op_header	oph[2];
>  	struct xfs_trans_header	thdr;
> -	struct xfs_log_iovec	lhdr;
> +	struct xfs_log_iovec	lhdr[2];
>  };
>  
>  /*
>   * Build a checkpoint transaction header to begin the journal transaction.  We
>   * need to account for the space used by the transaction header here as it is
>   * not accounted for in xlog_write().
> + *
> + * This is the only place we write a transaction header, so we also build the
> + * log opheaders that indicate the start of a log transaction and wrap the
> + * transaction header. We keep the start record in it's own log vector rather
> + * than compacting them into a single region as this ends up making the logic
> + * in xlog_write() for handling empty opheaders for start, commit and unmount
> + * records much simpler.
>   */
>  static void
>  xlog_cil_build_trans_hdr(
> @@ -852,20 +860,41 @@ xlog_cil_build_trans_hdr(
>  	int			num_iovecs)
>  {
>  	struct xlog_ticket	*tic = ctx->ticket;
> +	__be32			tid = cpu_to_be32(tic->t_tid);
>  
>  	memset(hdr, 0, sizeof(*hdr));
>  
> +	/* Log start record */
> +	hdr->oph[0].oh_tid = tid;
> +	hdr->oph[0].oh_clientid = XFS_TRANSACTION;
> +	hdr->oph[0].oh_flags = XLOG_START_TRANS;
> +
> +	/* log iovec region pointer */
> +	hdr->lhdr[0].i_addr = &hdr->oph[0];
> +	hdr->lhdr[0].i_len = sizeof(struct xlog_op_header);
> +	hdr->lhdr[0].i_type = XLOG_REG_TYPE_LRHEADER;
> +
> +	/* log opheader */
> +	hdr->oph[1].oh_tid = tid;
> +	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
> +	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
> +
> +	/* transaction header in host byte order format */
>  	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
>  	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
>  	hdr->thdr.th_tid = tic->t_tid;
>  	hdr->thdr.th_num_items = num_iovecs;
> -	hdr->lhdr.i_addr = &hdr->thdr;
> -	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
> -	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
> -	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(struct xlog_op_header);
>  
> -	lvhdr->lv_niovecs = 1;
> -	lvhdr->lv_iovecp = &hdr->lhdr;
> +	/* log iovec region pointer */
> +	hdr->lhdr[1].i_addr = &hdr->oph[1];
> +	hdr->lhdr[1].i_len = sizeof(struct xlog_op_header) +
> +				sizeof(struct xfs_trans_header);
> +	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
> +
> +	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
> +
> +	lvhdr->lv_niovecs = 2;
> +	lvhdr->lv_iovecp = &hdr->lhdr[0];
>  	lvhdr->lv_next = ctx->lv_chain;
>  }


-- 
chandan
