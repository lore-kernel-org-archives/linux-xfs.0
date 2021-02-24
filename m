Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7CDC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A325764EBB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 05:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhBXFkb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 00:40:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60500 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhBXFk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 00:40:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5cZx7087651;
        Wed, 24 Feb 2021 05:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xY//RszdebQNteQJL7qLL+cTXZ9VLBVTpbeqgGy+8fA=;
 b=FegNay+suAC5Ms+grmbfieWjDvZPtEAjGILTP9ONpf1ec3vWRI8dh/NqzHd4NW1MKipD
 HvL0w2JahQlWJqMIZIUgjnRWTI8mF/QIZ6b/qu13NmrJptNjBlPfMwcpzRKJHUvZ8Wl/
 COjo+n3SNRcNefsHxiZC5v6EWgqq/DJY3yIdIquG5BVrpXQyU9kyqAHkW9zN7RjnzwJN
 WDX41mgw82ydbUxG7dsIk2CniO8bSEeHc+sYBbcrEl3iXFe2VRyloryVFBOOD8MyMzuA
 JD22JnN6vqnYVppQZaKkfi/02LxjgluuJjgCJYkQexdEM29HAOGe08XLVLTyzvgOncvO 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36ugq3ghgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11O5a9Lw031749;
        Wed, 24 Feb 2021 05:39:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 36uc6sp3ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 05:39:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhCdqeB2VzZqD9UojW+pKrk2SEFKnRMZgwLIJL/OzUrt6HPGzP0avQ4iGLzIHSIhXBXWS+qWTy1wOj9lPIhXwD+6z0c1B3VUJ67Liv29RSaLosa53A+eIbd0B2W64+n0nPWM7I7XzyHGEu4nF1e6pAremBmYMAjm582LEKX+UAthEEchqlZ7cof+7co9BOsd9gloSyOxJEyR2qZcupSaWTy+HhYVGaqH2JbSX7VVMZPNgO8MzWiGSZ66cGzy6Iht1R06G02AfWas6Hf/JirwCHOhfxCIU/cHoddISIcQzC/RVAGO3iSs6Ov07bUTvpQNuKwz1xP/+P6d3OXHvjFxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY//RszdebQNteQJL7qLL+cTXZ9VLBVTpbeqgGy+8fA=;
 b=YcRtt3Ilv3EZAASKwGQJjCS0ZrLqkC5+u4ID6oQwytk11YeT1VCGu/44u/Yfl5b6PJRvHUh5jejAR9Va6LIditV25CO1Wk9jGMvxEjjeeYegfFyD3kt3Mc1aNocUqszkZjUVYEORwEupPKCRvUcutSHBnI6eAdxt0zPIPPD3LZNZ2kxyrG9swm6e3zatktNAl1m4Jgtbd3pFH2fCQqx+ycz19Ebt0YBeYyTXc9vEmiRPabTCoVVr3J9SNfzZ2KhFZxVZbjjRbL/ciC30KmmefDENOOkzi4/eTd9I3sBDBoZLBqkdKWmEGOK+GD8m1d2LnBlkwWqeLM6oha32qfYWUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY//RszdebQNteQJL7qLL+cTXZ9VLBVTpbeqgGy+8fA=;
 b=RduokQ1p7di7jBUNcuInWP1T7nhDjnmtdgN3p6E/0Xlp7aReOOrwbuvC5fGcVgaWUXapsepU6FIHd1a9O2PWW/Y9ERQNjKQgBQgcArVkg1SXrYnD1hGOPIfXnY2io37fAiN3JzPJCsYEQxztUWq16DO1ncMrGYjr375vq4guL+0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2437.namprd10.prod.outlook.com (2603:10b6:a02:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 05:39:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Wed, 24 Feb 2021
 05:39:33 +0000
Subject: Re: [PATCH 1/4] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404926616.425602.16421331298021628773.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c5aab6a0-76b2-896d-117b-c2de32bdc593@oracle.com>
Date:   Tue, 23 Feb 2021 22:39:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404926616.425602.16421331298021628773.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:a03:331::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0074.namprd03.prod.outlook.com (2603:10b6:a03:331::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 05:39:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37c20b80-6338-405c-2115-08d8d886909d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2437:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2437384E282EA3E74A419DE4959F9@BYAPR10MB2437.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sFrxqhbbdUkDhyiykR/fXAqBz3ju2hQyE2EZHv5/wIiIFj3cBHvpSZY1yeQlli4PokLWzH6sW8C9qUBmmvHG6XPko3ry428p9TvxQZOmmTJpTrPoJsnv09bErhm9/6DS0yA/rvJ4cudDkg50Urjtf8DTt9VC3bWMOuvk+MuTfeHYPMTlN4tpzw+pwRT0OckdBXKhPxO8bArMcp/0eiOYsV0ExQu5cNlBni6rUkmFtN8IMTlzGW+ye8AUdMH/Q7TzLUeYKsEXIhixQtM/PrAT10M6rihmia78H363Wjd28YZvkbwezFLGEDHVhM29xFiTK9DIcYjTLa1po2l8MVmbvJVuT7dqz3BeEuT/U3GEMoGwwI+t16lDgKajtObv7zoocNR82sjXDnclz1vvpfYcpHB4aZxwOREYOIUGNge/dkiiLv0dctz6qLSeFKwxUnG3TLdo0l8kDFh9GzFYoRWo/zW7sGX189tlFSlVH5ouusr6vgAV/D+B1pJpGn54LzL9YSfjfNx7E0uzTWBiXF+fA/fnH4mXJH5CXwQnYabGLQoFVVcQ8sH4MQxRBT40YRCq1Zmu3ZdFVh7GXzr7l33XGRe1/56huWpoH4NbWnvxPi4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(8676002)(316002)(26005)(66476007)(2906002)(4326008)(478600001)(8936002)(16526019)(186003)(5660300002)(53546011)(52116002)(956004)(44832011)(66556008)(83380400001)(2616005)(36756003)(66946007)(16576012)(6486002)(31696002)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bGRtNDBONlBHdWVHTkhPcG11ZHIwWjlUUU02NFFpUzhrVWsrWjhYUmZ1b2VT?=
 =?utf-8?B?WkhqSVNuT0F4Rjh6NmlzeWE1WDBFd0ZpbzZMTXIyMEdYejlsbnhxeWwwWjFH?=
 =?utf-8?B?YnpFbEltdW4yT3hTL3VpMlVNbnovM1RvK0dLcy94RmRLZTNkVlJyTDhnd01j?=
 =?utf-8?B?aDMyV1poYTlzSzVrMmpyWGtreUMyU0ZUSHQrbDFzdUVvcExyRnU1NGV2NW43?=
 =?utf-8?B?R3MwaVJrVDFDdTkrT0JrK2ZrWldldW9hS0FRb0JtZjhSUkRwYjlmcTUwTXpN?=
 =?utf-8?B?Y2VuQnlmSlo3NGVsRzJVVVhlbFpjcWJKZC9DS3czTjg3YWdmRXlmbVJ1M0xw?=
 =?utf-8?B?QnJodWNpNTNIZnVUS1J5WmI0aUU5TXNPbVlFUzJ0TlBuaDZFeHZ1RFhhTk9z?=
 =?utf-8?B?VVlPZmxnTFhRY3lmenBtbUxUUmxyWXVyTHV4MkVZTHBuMlNrcHY5N21UUith?=
 =?utf-8?B?YTVoNytmZlRKTjU5eDZ0VmRQWGc2K3JmRGN4RFk0T1paUzgwbHZ4RXR0a3ht?=
 =?utf-8?B?VlM2Y1RkU21MdWxXVXl6aXd1NXp0b2NsRmFLN3VkYUtLM2RRSjFlRnV2cThp?=
 =?utf-8?B?U0UzUWsrOGVrbHVjaDVzcWhhek1kZFVRSkEwVHZ0R1V6NDQ2Q21DblpWQ3Y0?=
 =?utf-8?B?QXJOODJJSCs1WU5FbTFYV2pCU3NIa29XTU5UWGtNWlRucnRWUHRhRzFQLzBw?=
 =?utf-8?B?YUVCVjVvdUlVZkdnZm1hQVh4aWhBWDZkZnNoamlLVnJ3amdlVEN3b0JQT2Vl?=
 =?utf-8?B?REIzU2oyVmZIaFVqN1ZRMWptS1lNMm9ScmZuODE4ZHR3K0pzZVhDVFdRR09W?=
 =?utf-8?B?VWI0L1k1Z3FCNUF5d1hDS3l1SHRuMlRoMXhqUVVydXoxaGdDS20va3VXc3ZF?=
 =?utf-8?B?WVdjR2Q2U0N6NFFPUUZ5OGsxWmk5RjZUblFHQUVYbTRiNENqNko1d2hITjE2?=
 =?utf-8?B?WENZd2tMUzhENW9lSFVrcmsyN3dOci9xSmJ4MUsvbUhtQjdlaFNhOWV2cEtD?=
 =?utf-8?B?RFIrYURCMnBhaTFnZzIyNVluZ3dieUtROVV6SVpMaW5oa1B4M2lFekVsNzZH?=
 =?utf-8?B?Q2RVSHFmZXRoUk1zWUJVYVZSd0JMM3U1ZlZZeDBFVE1CbG1uRE1CT29JalVz?=
 =?utf-8?B?V0NGTUZOQ1NleDk5eGVZeGNmNTk3Tzgwc2Y4NkpVUm9ScmRSUEpYZVUxci9K?=
 =?utf-8?B?Q0xIQktzbWhCZFR2UXBqTGNYR2V6LzFUdzNhMFFYWDJPd0I3N25tZXdETmhv?=
 =?utf-8?B?UnNPaFo4c29OWXdtTWZWQ3Z5RWRyNm04YVN5N01IR3Rzb3hjVHIzd3pSU0Rr?=
 =?utf-8?B?cDJEUUd3S21FMW4vUEd1WHVWN2xwK2xIZmV6MU1nWTZpejAwdzlodWNISWg3?=
 =?utf-8?B?OStWNWlIbUMzbHM5VHJ1Q05sYjltUGNVV0RMcXJpYnJ4N2JFanA1bldBNi9J?=
 =?utf-8?B?bXcrKzZhY0Q2MkwzMlN3dkJYTzdNTS9iRkNVZHNzNnBPeWpxU2VGc28rN1Rj?=
 =?utf-8?B?MnE2VW9PQlhhQTBEMkZtWm9pd2p0UHRtMy9PVEJxSTQyd3FuenJKZDZheHUy?=
 =?utf-8?B?TlJXSm84UnVkQkZGYWtHNUxFcUN6LzlNaVIvL0EwdzFGcURGNnFNKzdHSVdF?=
 =?utf-8?B?QUF6Y1pVSHRLQmlOTWtYWU93NGRraG5BV0ZIQVRnSEFVSEcvQjRUcmV1dkpu?=
 =?utf-8?B?aFk4QTcwVU9GZDhoMWZzMm85eE03dm43cnhGSWR5bHdwTW4rdGxNNkRLeEV4?=
 =?utf-8?Q?wHhkGi0S3xZEQv49xVIlqm1pry2t9jXvVaFC7NY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c20b80-6338-405c-2115-08d8d886909d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 05:39:33.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdEoyzfkT0Tjd9iJLaGSi1imCGGsSBHd66cncOZ8DbEbDmgc8SU4K/7jrhulgq+CEv9btraLWHjznwAezZW6epGbqM1AMiohiF0UTsmWQro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2437
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240045
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240046
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:01 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a hook to the buffer cache so that xfs_repair can intercept the
> first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
> event that xfs_repair dirties the filesystem and goes down, this ensures
> that the sysadmin will have to re-start repair before mounting.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok, I think it looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   include/xfs_mount.h |    4 ++
>   libxfs/rdwr.c       |    4 ++
>   repair/xfs_repair.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 110 insertions(+)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 75230ca5..f93a9f11 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -11,6 +11,8 @@ struct xfs_inode;
>   struct xfs_buftarg;
>   struct xfs_da_geometry;
>   
> +typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
> +
>   /*
>    * Define a user-level mount structure with all we need
>    * in order to make use of the numerous XFS_* macros.
> @@ -95,6 +97,8 @@ typedef struct xfs_mount {
>   		int	qi_dqperchunk;
>   	}			*m_quotainfo;
>   
> +	buf_writeback_fn	m_buf_writeback_fn;
> +
>   	/*
>   	 * xlog is defined in libxlog and thus is not intialized by libxfs. This
>   	 * allows an application to initialize and store a reference to the log
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index ac783ce3..ca272387 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -812,6 +812,10 @@ libxfs_bwrite(
>   		return bp->b_error;
>   	}
>   
> +	/* Trigger the writeback hook if there is one. */
> +	if (bp->b_mount->m_buf_writeback_fn)
> +		bp->b_mount->m_buf_writeback_fn(bp);
> +
>   	/*
>   	 * clear any pre-existing error status on the buffer. This can occur if
>   	 * the buffer is corrupt on disk and the repair process doesn't clear
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index e2e99b21..03b7c242 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -751,6 +751,104 @@ clear_needsrepair(
>   		libxfs_buf_relse(bp);
>   }
>   
> +static void
> +update_sb_crc_only(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
> +}
> +
> +/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
> +static void
> +force_needsrepair(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf_ops	fake_ops;
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> +	    xfs_sb_version_needsrepair(&mp->m_sb))
> +		return;
> +
> +	bp = libxfs_getsb(mp);
> +	if (!bp || bp->b_error) {
> +		do_log(
> +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> +				bp ? bp->b_error : ENOMEM);
> +	} else {
> +		/*
> +		 * It's possible that we need to set NEEDSREPAIR before we've
> +		 * had a chance to fix the summary counters in the primary sb.
> +		 * With the exception of those counters, phase 1 already
> +		 * ensured that the geometry makes sense.
> +		 *
> +		 * Bad summary counters in the primary super can cause the
> +		 * write verifier to fail, so substitute a dummy that only sets
> +		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
> +		 * the kernel from mounting our potentially damaged filesystem
> +		 * until repair is run again, so it's ok to bypass the usual
> +		 * verification in this one case.
> +		 */
> +		fake_ops = xfs_sb_buf_ops; /* struct copy */
> +		fake_ops.verify_write = update_sb_crc_only;
> +
> +		mp->m_sb.sb_features_incompat |=
> +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> +
> +		/* Force the primary super to disk immediately. */
> +		bp->b_ops = &fake_ops;
> +		error = -libxfs_bwrite(bp);
> +		bp->b_ops = &xfs_sb_buf_ops;
> +		if (error)
> +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> +	}
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +}
> +
> +/*
> + * Intercept the first non-super write to the filesystem so we can set
> + * NEEDSREPAIR to protect the filesystem from mount in case of a crash.
> + */
> +static void
> +repair_capture_writeback(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
> +
> +	/*
> +	 * This write hook ignores any buffer that looks like a superblock to
> +	 * avoid hook recursion when setting NEEDSREPAIR.  Higher level code
> +	 * modifying an sb must control the flag manually.
> +	 */
> +	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
> +		return;
> +
> +	pthread_mutex_lock(&wb_mutex);
> +
> +	/*
> +	 * If someone else already dropped the hook, then needsrepair has
> +	 * already been set on the filesystem and we can unlock.
> +	 */
> +	if (mp->m_buf_writeback_fn != repair_capture_writeback)
> +		goto unlock;
> +
> +	/*
> +	 * If we get here, the buffer being written is not a superblock, and
> +	 * needsrepair needs to be set.  The hook is kept in place to plug all
> +	 * other writes until the sb write finishes.
> +	 */
> +	force_needsrepair(mp);
> +
> +	/* We only set needsrepair once, so clear the hook now. */
> +	mp->m_buf_writeback_fn = NULL;
> +unlock:
> +	pthread_mutex_unlock(&wb_mutex);
> +}
> +
>   int
>   main(int argc, char **argv)
>   {
> @@ -847,6 +945,10 @@ main(int argc, char **argv)
>   	if (verbose > 2)
>   		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
>   
> +	/* Capture the first writeback so that we can set needsrepair. */
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		mp->m_buf_writeback_fn = repair_capture_writeback;
> +
>   	/*
>   	 * set XFS-independent status vars from the mount/sb structure
>   	 */
> 
