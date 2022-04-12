Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E477C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 09:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243796AbiDLKAp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359717AbiDLHng (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 03:43:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECC92DA92
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 00:26:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C6x256014133;
        Tue, 12 Apr 2022 07:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gqpUQLtu0UdWTXvIf9i/idMs9w0Nq1DE003bkwhA9CA=;
 b=y8CM/qTyI1+jEY6WFTqeuCR2/gId9itRs/z1jCqcZ4kGvi4qHszle8AHq4QYAR+7SC1b
 HKvNA0x4FsTEYYJ3ByGumbnKMLHY1AS+eUTKRDs8yThEGR+lIyKkCg9GKzS8Xo6d2NYg
 R/aqBoTaOvEO7czagjflZ8CEmVw5xmcUBh1xKhp1A+HavMTT88gL8I2n9dizpCgXfw84
 vI2fHjpjWBG2ZJWvjhXW7FejK6OenApB3L1WxSuFYXX9vWl+NtAQIRi/PYqAO7YmLPFV
 r7JUVZ92tPZgEv+722zIOyBLTWKtVoSMyADHH3v4LlX+uZLiUAm+aReXssc59N+sA3Xa hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwwxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:25:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C77Ji2038752;
        Tue, 12 Apr 2022 07:25:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2vdyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 07:25:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgxDHloy6TIInn0YY/ZYLr3aECsbtW3tnD1Xbg9ArivsgYE2xyDEtYR2TiEC5VQvFlsWVVOM+FXdJx08iMRxj6rOL4LEPgWirCavEewxizVXiDc+cbP8LmdTDL/aAdlFSy3uDFy/6khAdiydp3Jtd6oy0Z8N2T4EG7tDyoIxAO51nLiTHK/N5YtwMlpVK4uExbEeL8ila683QyiAE7sPzjuszeiMLZFTJUHsYa8E/k1IA5pzDsN7dX9ikYQHYF0ABR71KswzkGpYZDuL1Rc2vu1TPXj1gA9aRpNQXSdjMiaaDKB9rOm7tMQxtR1TyPMhlwwdn7ylB2EgEPGIFMSP8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqpUQLtu0UdWTXvIf9i/idMs9w0Nq1DE003bkwhA9CA=;
 b=cml7epKr9/DNR+Mi7K/ovpgQl2TF1WgkR7aNJQHX8QUG39gt2juwy/VDg8HRmJkE9xYwdyXoyyYFwVRp6Fc0G2CsaKTajLbzMH9p/xNoxo9wgVupSUhAN0+OBuXrBXYDPJtrnlUSGaLyF5kJlbhX4gSunW8GqzcH6ZDS0IU2Sv5Dn3UZeKEVYVkYt0d40GvrR7k+qkOWFuwKodLFj5EC/y75ITjjyHo8eEf6DqdP0UaOI9WjkDRhUkANJZx4IPm1F613LAylw2CRvmUgzeMjKc6NstBKwdDpYGUub0SaQX7lVTPxozlHXxNU1d6a4HQ6vIIiIjWTaR8e4uGbT3AHQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqpUQLtu0UdWTXvIf9i/idMs9w0Nq1DE003bkwhA9CA=;
 b=FKrg4M6xO7e5mzt2fexAZKJ+zUcJ8oCNX5LBF8KZD9L9g0RAirqYDVA+6ckezhzkMzc6bfaxgxNe3bj9162GyCjHcVQ3rof1Yj8tXF+u5Qgl19IaXzkd3l/MBNXOV1qn4TuLz59P2uzffcr/JcT74GtYGN2qumTbhqKLPIh5jz0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN6PR10MB1761.namprd10.prod.outlook.com (2603:10b6:405:a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 07:25:56 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 07:25:56 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-11-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/17] xfs: convert da btree operations flags to unsigned.
In-reply-to: <20220411003147.2104423-11-david@fromorbit.com>
Message-ID: <874k2y226b.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 12:55:48 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b3cda1e-fb29-4af4-8d19-08da1c55af51
X-MS-TrafficTypeDiagnostic: BN6PR10MB1761:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1761F3B07359E1A997F91AEFF6ED9@BN6PR10MB1761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtbO8UfeUBK2iz6yOQHx3KmYjZ80VxGbGPoqn03xh+OBcaptLxv/hHGRVn0jx4U0owSypkb0fuQjvJps19hZAUcelLahAAXngwxyhBV6eiXB/45KI0m/+zGJwwln4KT2uAGPjHoMM1mYNOHsv1NNAKHoXTKuTxEpWRoZo3D6omO2/R9C4H+pccNiZ5ZHCw4HHT2D22yGrq4J/LIttGvYA/+D9ME4PGAOBojh29ewePIKoQDimOoAzqGDO8IS7EfPBoFSHYjNSQF43buBmFv4eXYd+uM/3DEKY36flY47Ru3cXTn6nE6UILmdqTN52e4ZCt1M3zCrA+dYKFVdxpSc4iwPE+nRVr+j1uMJez+cSreG59AOS0JnRzSgoro0LaOkAiFPGw2FHpD3/VEB4zw+h+UMCC0VxYQbHGOhOBR0M6E46/C+MI5jrWSSw7X6hvbn8iWngiv/dnPeALfNocgpqaMnQUFJBVUixa2r6cBu8fPR37JvwmTXMt9+gV/7vlPGaZD5cOvRJk/FV1W/SUs9PnBGRJuSPP10mTR+IkRYaza2+zCUpqE8eRd7WvUOtkW3c0Er5O4eqYNYQMuQu+9VgsUoE2RuBoLcE/6pN+KGgkuv0Iy7OuZ01QPv9WzM1yBk5jJUeVobmiuuXPkPTcAjknbAW8DGgQxx8P0IeQPE3Qi/fHSSVLwJnH0zYGhZ0LPLI4XVEF+r5s/WM5/O1BSAMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6916009)(6512007)(316002)(2906002)(9686003)(83380400001)(508600001)(26005)(38100700002)(38350700002)(186003)(6506007)(8936002)(53546011)(52116002)(66476007)(33716001)(8676002)(4326008)(66556008)(5660300002)(66946007)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZHkIC1DGad4OadkgH5VmV2F7EvQIeBhlxg3sqBdnuTkcwdptnfkdp8zd61P?=
 =?us-ascii?Q?FFTlCzioGrenyY/hdKLxuVrtYqF7s8aAv3e2SeY7dTssTys51vDKk25dKsbr?=
 =?us-ascii?Q?KLSvJE5mz61boRgcVtBjSg6GdQjdbfQwFs/JP1DGB/nYp+khR3eWrHAn5yN+?=
 =?us-ascii?Q?lUXYWIf8b9uZpggN3SFpNPpSZBNgAwAtTZd9tD6dOJAuKxFTY6pxtUmB086P?=
 =?us-ascii?Q?B1I9OLXZdEiWUZ6OFUslVFtQCxv/cgjLYNrG6R8WZuEq/H+h8e1kOuZhgLXY?=
 =?us-ascii?Q?gDA/2pw3bbfxK08hpNbbsxbRfUZs/c0/l45fQkNKj2OZHRJ+Vm0G8dXwY+x7?=
 =?us-ascii?Q?uG2Y+1TgZNWKNYW5kbC4n8BvxZivSOOo/MFezYnmCqenBo9EWs4KvwpIy0fa?=
 =?us-ascii?Q?Gj4jc5RBmqBElAUPpFUEd9EH/GPBh9H3t3v+LovSfyXtT/h1vNEbdoCARLme?=
 =?us-ascii?Q?wess8Umncz1ZbkJ0O8QHRZ99J1msbWYDEYPorTk/pfKEjIBWpMvJZ9n1Qpal?=
 =?us-ascii?Q?VEEsDHeDCHGv8aRbWGOJ0ceWCGEdedbgyXefjhIbQQknBjN3fASUjAwxMHgw?=
 =?us-ascii?Q?QJXv5xE1s42RocX2z7FwSSHxe9vHpZyfZ48D0UNX9Sw9f4xQwAa2spYGuWN1?=
 =?us-ascii?Q?AEN7yFWasHseezVwy8S6nn7WsWBXt+TWSIlOPhJJK09YEPm1ZTevv1010PwP?=
 =?us-ascii?Q?wztIY/P+PsuLhzSeFOwcSxl/fPBaoOFl1qdqKtXpI+oJ6OK24kLFCMc4R+Vx?=
 =?us-ascii?Q?l8SqN7NBU+TI5FHK+8WDmR2y6HFLvJF9oPZJOfhKjG0WlkesL7smObSJ+iNX?=
 =?us-ascii?Q?gxh7SHs2Ysv0e1TOVD5Ntb+O/yHHsTe4fQ1754ZvJSSGcgnjn5URVCxokby1?=
 =?us-ascii?Q?NcjDkwCIJLIO1ourdxZnxmuuQ8nA2RWLChS2pI363dXpYb2r3hAjq/fn0rkt?=
 =?us-ascii?Q?qq9vjkF5Mvc8XAk+JWyaBYvnS6IFuqafzQbOiaNzvAKLjXhQsj46wpksepGg?=
 =?us-ascii?Q?oRMBrYBg/8ta1uZ23eMt4josec2s3w34r8ImFvFYYT+kfvvNGIF6wEFphKkv?=
 =?us-ascii?Q?lsV9/iwFrgy2X56RSybUutVzC3c1DcBhYlXl4clyT1TcZQ1grAcnXI9rzJsO?=
 =?us-ascii?Q?soFZMjKJeyzm0B0JgHZuAuoGS/IzXQhxRAHSppxyR7k6+pK8ODooDbwKe075?=
 =?us-ascii?Q?h7ZegXFHVtyKl0RHbkyd9j5ltGm9Lj8JZXc4n1orsUtEpGN+vGBXbkZka7md?=
 =?us-ascii?Q?D7KagMzSZxudAA8qmFz2Zy090SlrHu7FaGq/tUS+AtdVs5OX3IdyOfkR9JQo?=
 =?us-ascii?Q?iIzfTyIYNfo5+6c1tX14KnsLIP0Ognq84e1Ro1+IwksP4128fzl11Dz9o5Mb?=
 =?us-ascii?Q?aUvU1/eqAW/przwzPJ7C5Jifsbo53LNrVLDwqYtRiYckbCA+HMenD3VJltOb?=
 =?us-ascii?Q?oi6C1pMcXaN6RGJ3mYR+QdU7L5ywLuC6IlIEROXzTOY7L5NCZtRAWG8sKPC1?=
 =?us-ascii?Q?xjWVubxvTAOnaAq/Xm1PxwdIzGSc9DKVQQjBT4h5u8Hrr3zy7jvlhMBQbun5?=
 =?us-ascii?Q?WlzZqdkx19YgteOay69kkHpJcYYkEnqDct5cyvsVzI+fqTSDAj7H0YgUrWWK?=
 =?us-ascii?Q?+Nr52rkrw7E1/kzzuhjedXjbBhxk+1t8SgHcGBmwZGGwmPZJa7F83IWJSYx7?=
 =?us-ascii?Q?o/Y8SNXKFPiFA6UJlTSmXqM65irnZZrKtesoSdjCaYzqP1ba0+NZ6rzy9/DZ?=
 =?us-ascii?Q?2i2utK8PHk4psEYInlSnXq8UXq7ssY0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3cda1e-fb29-4af4-8d19-08da1c55af51
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 07:25:56.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGphZm0CE7Kp9cy6yg8bfta88IZXWPQwN1t4cmXTHPKa7pI/tVxaCTz5t6wMDzNSl690ph/QlqtFebpcCwV0/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_02:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120034
X-Proofpoint-ORIG-GUID: Y02iYjeINv-xnp2I1JLiU9A7lRkDmZDE
X-Proofpoint-GUID: Y02iYjeINv-xnp2I1JLiU9A7lRkDmZDE
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h | 16 ++++++++--------
>  fs/xfs/xfs_trace.h           |  8 ++++----
>  2 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 0faf7d9ac241..7b0f986e5cb5 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -76,19 +76,19 @@ typedef struct xfs_da_args {
>  	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
>  	int		rmtblkcnt2;	/* remote attr value block count */
>  	int		rmtvaluelen2;	/* remote attr value length in bytes */
> -	int		op_flags;	/* operation flags */
> +	uint32_t	op_flags;	/* operation flags */
>  	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
>  } xfs_da_args_t;
>  
>  /*
>   * Operation flags:
>   */
> -#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
> -#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
> -#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
> -#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
> -#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
> -#define XFS_DA_OP_NOTIME	0x0020	/* don't update inode timestamps */
> +#define XFS_DA_OP_JUSTCHECK	(1u << 0) /* check for ok with no space */
> +#define XFS_DA_OP_RENAME	(1u << 1) /* this is an atomic rename op */
> +#define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
> +#define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
> +#define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
> +#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -197,7 +197,7 @@ int	xfs_da3_node_read_mapped(struct xfs_trans *tp, struct xfs_inode *dp,
>   * Utility routines.
>   */
>  
> -#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
> +#define XFS_DABUF_MAP_HOLE_OK	(1u << 0)
>  
>  int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
>  int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b141ef78c755..989ecda904db 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1924,7 +1924,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
>  		__field(int, namelen)
>  		__field(xfs_dahash_t, hashval)
>  		__field(xfs_ino_t, inumber)
> -		__field(int, op_flags)
> +		__field(uint32_t, op_flags)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> @@ -1990,7 +1990,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
>  		__field(xfs_dahash_t, hashval)
>  		__field(unsigned int, attr_filter)
>  		__field(unsigned int, attr_flags)
> -		__field(int, op_flags)
> +		__field(uint32_t, op_flags)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
> @@ -2097,7 +2097,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__field(int, op_flags)
> +		__field(uint32_t, op_flags)
>  		__field(int, idx)
>  	),
>  	TP_fast_assign(
> @@ -2128,7 +2128,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> -		__field(int, op_flags)
> +		__field(uint32_t, op_flags)
>  		__field(int, src_idx)
>  		__field(int, dst_idx)
>  		__field(int, count)


-- 
chandan
