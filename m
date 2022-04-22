Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A4AC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 00:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357979AbiDVAke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 20:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiDVAke (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 20:40:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566BB443FA
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 17:37:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLnHDr020622;
        Fri, 22 Apr 2022 00:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DohSPrMFcVjhvZKGc4O7ndNotgxC7fFDtPBzqR9loWw=;
 b=sBnHgMr0ietFVrjCihyOU9JdhHBm9o99UXdKENMImGGZear6Pc/nQTvN6gPTJPZvAQ8j
 gPYu3s8axmuAYNvedj/3R9/KY8+skNnQT+n3wZzm+FZ+v8f2m3Qo6azGnFz/t/W7ggWw
 E0WOY3P0HTcJW3xmuekgHsLc01L18euWTbniv9TVYhTLeDgh6P+Z8icmBjSY2htjOnaX
 UqmHKrf7ZmaiBIKVcMW4swAqGZTbpIkn9ciepl/fQ4URHcLWrxCAa4nkuLKXQ2D5YV24
 AyyPz8BwlOgwQ3KROv5v9iHjgMF8j3Z8YF/kIYYERyXKRVcWJ5gGdc9bThGq+Gwvak2y Ww== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmd1dhec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M0ZvQd031647;
        Fri, 22 Apr 2022 00:37:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8csy8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 00:37:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mULzCM0ZfsM0wsFNS97Q0T+DNjaFo7NQSdHZC9juPWvz4evX0EI/zi1LpKjQw6pg9heQLEaad0UICa+PB5giFh3ylpPYVy397gaQIGFSfjhHtfdqehqy7OVHlG9Jybg0o3UIX5ZWANW44/l5g1lUGXTMdlm0Z76eWvH7Cord78yTGo0pm9p/ZU3AL7TA/D1SgdHcrQHV+LJyRgTneewuVY70dkGJHtE5YxKOUv4FwSxF6x45IVPzB2hSjh58qsP7W3JUjudtLMW/jTe3CcVJIfD5PiTPsD/0XfwznV4Bq6xR8SEw6B/YF9/u9uFuUsXgaAyMg0wrJwLFiAdlh0a3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DohSPrMFcVjhvZKGc4O7ndNotgxC7fFDtPBzqR9loWw=;
 b=Ln/8Ag7Hl0fIEi+/Ub1q25IsBLxcKvVUN3Vt5eamzRXBoHPMrA/oosnOU8DTy8DN8Vm61nICt2nokBgj8P3wkd7EDoh3JuBOIGXor85jp0wP7jo2WWP/uCV3YOqCAqylJiVnGZ533IShY2T2RdmOdxCHgDoB/ucKzGznrZdAhex1cc+JCYHFI/qPAzvCUFRXBY0SvBUeE3stZdgds/qn31SddbNapivPnUXMVSpUFa3a8KZzI9JlSamZOlrgQ232FUihRZfMPLlL+n63l4Su04zkxCiOMb2foBXZIqTnS+rsklPH7Qmzroxkw7YuxbYEOgppc6F7CX9XT0P05yuv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DohSPrMFcVjhvZKGc4O7ndNotgxC7fFDtPBzqR9loWw=;
 b=dEPAOH5k1y7zBHAX/DZhKbYTDJ/EtiKoyhPsa0xcRYGiNTdlRBrF4j7ZWL3x57qMcflRFeg9p/pR1mtnOxmlS8t4k8+z7PCtOF7N/1v7rM0L4JlGCqLUt3+mXQbUjHqDiImGvzjq/9YGPlYHfvtzIrWrqWTTcZA9y7FXE1KrgfI=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH2PR10MB3973.namprd10.prod.outlook.com (2603:10b6:610:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 00:37:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 00:37:38 +0000
Message-ID: <f2e015db33714540b70abdbe63559ce621c50fdb.camel@oracle.com>
Subject: Re: [PATCH 01/16] xfs: avoid empty xattr transaction when attrs are
 inline
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 21 Apr 2022 17:37:35 -0700
In-Reply-To: <20220414094434.2508781-2-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-2-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ff20a24-c1ea-4e6e-710f-08da23f84d18
X-MS-TrafficTypeDiagnostic: CH2PR10MB3973:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3973354CB3D1E3402379567695F79@CH2PR10MB3973.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3LHCC+xZgDpb7ND0KsHTYA/q4VNcRA7iWCaiYOQ68KsaHneXO42IxEGceuNZAVlW/zNkhMZT9CEf93Iy90Hqw2CfC+CF9VaMJrY0LJpa+gleehy3u1M8AjTYv6aQ0uzwNf3rH4Cqxf7dtpEBjKUI8Z7Wk+O4tjcxoMhmXOOhjOAeSW/fZ7QFX5kog8GaDHPW1HoFDkPX1CZ+VfH3KMuCoVrPmSGOyKh3DkpCyXBd98bURDy4Ug4kvhTj6qKbwz3IvRWz/t2Rcu0H7ijodqIkyHDE0R8wpBYAYKveL5o/WhnsGh6zL9wgbSDR1PoInAmhk7jIG2qe0ULFabi7UX06t2OtpZlG3upOamTctb10FPD710zR2ThmSZfpS68ENZqFlpOmKPKRb41yHZKjGFHI+I8qTykLOZnoUPMHOpjhtiKhY1u/ppjpai644ZzHuifjY0KT1HUNDhixDEzmo247xt57korPol5aclNq2UtzH9Qm7npXgpahipg2OfErN4TSRIDDjgTCT68IedFApVsHxMVp0RG8uHuo3dlhR4Wu4rSDNGfFlO+7udz3ixAh3hs4oA74RjDej/8AaRJnUA/t9pnOPeYOVt0uUGVbXCtk0mcnFCCIo1DjWkmSOcbZ+BIM8/R/MCd+riDsHtHcxmlDq3EKzf88mWc74StbIQPimTv3Pj90H55wf51aKWVa9T7w4Trdyd6KHpWnlJfEGZonAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(38100700002)(26005)(316002)(86362001)(38350700002)(66556008)(66476007)(66946007)(5660300002)(36756003)(508600001)(6512007)(8936002)(8676002)(6666004)(6506007)(83380400001)(2616005)(6486002)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnpFZnlBYTNVZDlHTy9tVlhwVW9EZW93QWN1VDdpYlB3d2M4TlJ6Skc1Q3dl?=
 =?utf-8?B?dWx2MlV1Nmx1TG9UOHVVRmVFekNYVkNQamtnR3MxWGNtdEd0a3N1VmRtVlRl?=
 =?utf-8?B?Z0x1S25rMEFPS2pDYW95eHFaUnJDZ0pBajhaNGFhbTVqL2c5ekRGUktNbElo?=
 =?utf-8?B?ZWJyNWxoMk5oTjhMSnBkU2RIMi9wSkF3QzV3OStsVnpZeGV6VjFwZm02UFNS?=
 =?utf-8?B?a0xJcmZnQSt4OGxwVXJLL0x1OHlrZi9PVnZGcTRYMFhieG9CeWVZMis2VXFx?=
 =?utf-8?B?TG1yZGdSc2lyOGwyeVFEaFZsQzBzUDZHdDNJLzN6VGJJMXMxWjJwSE9ocWhV?=
 =?utf-8?B?NmVnaENuaVhmc1ozdkNQaENNL3BheUdhUnYySlJhdVo2MXZHcVFtb3ZNNHIz?=
 =?utf-8?B?eXMzMkJEcWtQNDVjTUV4SmZlTXhmUDJaTUI2YmFOMXE3RG9LeFVrVUNENUJW?=
 =?utf-8?B?YTFrL00wTDgvUmgwelVKaVN0ampIeHk0YmdDeXk0Sk55bWw2dzhjSmNIL1dQ?=
 =?utf-8?B?ZG5BUUJkczN0b2RmRHFwNEg3QWlzTGVramVibVg2VnlROElpZnVIb1NlWEho?=
 =?utf-8?B?TDYwUXNaL1BQVUw3REkwcWNIcUg1cFFFVGZJb28yeXFtZE5yQVlhWjZ2b2RJ?=
 =?utf-8?B?SDQrU2IvYzgxajFMRjRnQlR4OHF2ZE1iVXkzdUlvT1JGMGZUdzU5clRWak81?=
 =?utf-8?B?Vm5CZG5UVFN6WnJYZFB5TnJBRU1mb21wUzRtcS9RUVVZSHlFMGw3NERqZWxp?=
 =?utf-8?B?cCs2KzZSK1FwSHBWK3dQbC9zaWZ4UW5BK2ZLUE1mdEFZRTh1NkxJYTlFV0dJ?=
 =?utf-8?B?SGFJQmhJR1FVcms0dkpJaVVqYmdRZ0tIWVJvcUZ6VGJCQXFZUCtCQ3VFSWFi?=
 =?utf-8?B?bVQzL2R0K1ZRcTVIQVdxSzBZWmp3MnJPSUdsY2NpQlpYSml1TG5hZVVZd3Nw?=
 =?utf-8?B?T1RSNlExSjErTndBZzZmNFVPMjh5dzhkVnZHRVEzcVNvQjdiSUdLR1I3Qk9x?=
 =?utf-8?B?dlp4clFad0h4M2tvSWJNUlJnREVIdVQzS2hoSmd1Rk5WaFFmTUQzTDhmZXhx?=
 =?utf-8?B?NGlRYTZudGZDRHAwTDZyekZtVEZvbSt2VkV1VHpCZ1NWdTZNUHFva3BKVWtO?=
 =?utf-8?B?azcwazVaTUlZbjFkN20wcWNsb3ltRG9ncUhaZ3k4d0R3Q0kzZW9LdDFrdSs3?=
 =?utf-8?B?N3J2N3RrdnN1UldBbDg4Q1JDV0ZiSHZZa0FKY2JUSjNQaDBOVmF0MCtaT1dF?=
 =?utf-8?B?emdkQ1FuU2ZQeEYxL1M5Q3NYSnN2MmcwVWhJdzBqeWxNSnMwdGNCQVJZS3Vn?=
 =?utf-8?B?SGVsVDJ2OU90ZDZFUjI4ZmxGMGQ2MnVIMDRoaE5OaTRGZjROL0NlVk91VDRT?=
 =?utf-8?B?SXcwR2VRK2RRa3dEa3hIb1RKTU53WUhPTm5yNDVGRlpzWWlZR0FOblh5T3Nh?=
 =?utf-8?B?TUpPVmZCU2I2SjhpdFBLdnhhU0hOcGxnd2o0MDRNcUgxY2tBamd6b2owU1BP?=
 =?utf-8?B?VFpaT1pURjdxUG8rQnFNODdLWm9Tb2ErWlBUR3RLNFNVQktuTnNNeW1xTStF?=
 =?utf-8?B?d1kwR05TSFFIa01LTkdDc1lveEIzQUxBL3NxeWkwRER4QVYyd3lXazN0bTc0?=
 =?utf-8?B?MU9COFhkeFhRRmdHVVBWOFYyRS9qTDBSRXA4NmI3RmhFNFo1M25XQmV4bDNp?=
 =?utf-8?B?cVpTY2pIcnJtS2ZDeWlURXdXdG9ETXMrRHRHOHVHZ2RzK1lVdWVhOVpzbm01?=
 =?utf-8?B?UlREYlVKMm5xRHRHdlp0MmREWEVNeVpWNENpSGtjZlpQbnVuWGU5NFo2K2FX?=
 =?utf-8?B?aERjSzRDS29nN1Y2cGo2aVlUUk9PZ09tMm43UjFqMUdBSUpiTlRXV1pZZzRB?=
 =?utf-8?B?YjBZWVR0bTJGSlpIejRZcFlLVVoyL0JLbktDNlp5U3JMYjNPRzZlZ2l2T2ZT?=
 =?utf-8?B?M2l1WmlGZEFwL1JRaWNBMzNpbkxaT2VVdU8wbFZoalpQWlBHRXNvS1hwN2tG?=
 =?utf-8?B?d203L3ljNTVkdTJabHBRMnVMbGZDcVJhWWNCUVBKblZVVnZUZUpFVldjN09N?=
 =?utf-8?B?Y2gxSEhLWjV6NGllamFhZTJKVyszTStYVDBad2Z6bXhvUUsybGUrRVREbmZ1?=
 =?utf-8?B?OWZjcUJFdjhmSDkxamJXUy9JbUhKQTVVc2ZGL0grQndERHFjbjZIamF5aW5M?=
 =?utf-8?B?VWRBd09qQjc1eDZuQjF5VHBBby9jdXlvMHZuY21GM3pEOEoveUtmUGgwcGpC?=
 =?utf-8?B?TitRNUc0UWVnU2puZU9ibFNRQjQwREM2VFQ0aHFSS2lpdUFhTWpmbEV1aWVp?=
 =?utf-8?B?SmtLZHQzVC9MeTZ3ckJTSHkrZVRSSXpQM3QvTHFaUEpoOWRFNzU5bmpoSkJa?=
 =?utf-8?Q?8hl/YvNp3YoKhVG0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff20a24-c1ea-4e6e-710f-08da23f84d18
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 00:37:38.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2+5ShfU538AXyISPI/uT+kqfTyA6L8tnbswyQFIBQunT5NvTUS/CDYwxyLvbYpusIZ3xszvF1bcwUYOLu55rYuQ34jhrWY746C8YP8HwIlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3973
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220000
X-Proofpoint-ORIG-GUID: 5sg4-ITsqGTf8_msGvyFm88maQ84S92w
X-Proofpoint-GUID: 5sg4-ITsqGTf8_msGvyFm88maQ84S92w
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/642 triggered a reproducable assert failure in
> xlog_cil_commit() that resulted from a xfs_attr_set() committing
> an empty but dirty transaction. When the CIL is empty and this
> occurs, xlog_cil_commit() tries a background push and this triggers
> a "pushing an empty CIL" assert.
> 
> XFS: Assertion failed: !list_empty(&cil->xc_cil), file:
> fs/xfs/xfs_log_cil.c, line: 1274
> Call Trace:
>  <TASK>
>  xlog_cil_commit+0xa5a/0xad0
>  __xfs_trans_commit+0xb8/0x330
>  xfs_trans_commit+0x10/0x20
>  xfs_attr_set+0x3e2/0x4c0
>  xfs_xattr_set+0x8d/0xe0
>  __vfs_setxattr+0x6b/0x90
>  __vfs_setxattr_noperm+0x76/0x220
>  __vfs_setxattr_locked+0xdf/0x100
>  vfs_setxattr+0x94/0x170
>  setxattr+0x110/0x200
>  path_setxattr+0xbf/0xe0
>  __x64_sys_setxattr+0x2b/0x30
>  do_syscall_64+0x35/0x80
> 
> The problem is related to the breakdown of attribute addition in
> xfs_attr_set_iter() and how it is called from deferred operations.
> When we have a pure leaf xattr insert, we add the xattr to the leaf
> and set the next state to XFS_DAS_FOUND_LBLK and return -EAGAIN.
> This requeues the xattr defered work, rolls the transaction and
> runs xfs_attr_set_iter() again. This then checks the xattr for
> being remote (it's not) and whether a replace op is being done (this
> is a create op) and if neither are true it returns without having
> done anything.
> 
> xfs_xattri_finish_update() then unconditionally sets the transaction
> dirty, and the deferops finishes and returns to __xfs_trans_commit()
> which sees the transaction dirty and tries to commit it by calling
> xlog_cil_commit(). The transaction is empty, and then the assert
> fires if this happens when the CIL is empty.
> 
> This patch addresses the structure of xfs_attr_set_iter() that
> requires re-entry on leaf add even when nothing will be done. This
> gets rid of the trailing empty transaction and so doesn't trigger
> the XFS_TRANS_DIRTY assignment in xfs_xattri_finish_update()
> incorrectly. Addressing that is for a different patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok makes sense, thx for catching this!
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 39 +++++++++++++++++++-------------------
> -
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 48b7e7efbb30..b3d918195160 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -315,6 +315,7 @@ xfs_attr_leaf_addname(
>  {
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	struct xfs_inode	*dp = args->dp;
> +	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
>  	int			error;
>  
>  	if (xfs_attr_is_leaf(dp)) {
> @@ -335,37 +336,35 @@ xfs_attr_leaf_addname(
>  			 * when we come back, we'll be a node, so we'll
> fall
>  			 * down into the node handling code below
>  			 */
> -			trace_xfs_attr_set_iter_return(
> -				attr->xattri_dela_state, args->dp);
> -			return -EAGAIN;
> +			error = -EAGAIN;
> +			goto out;
>  		}
> -
> -		if (error)
> -			return error;
> -
> -		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> +		next_state = XFS_DAS_FOUND_LBLK;
>  	} else {
>  		error = xfs_attr_node_addname_find_attr(attr);
>  		if (error)
>  			return error;
>  
> +		next_state = XFS_DAS_FOUND_NBLK;
>  		error = xfs_attr_node_addname(attr);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * If addname was successful, and we dont need to alloc
> or
> -		 * remove anymore blks, we're done.
> -		 */
> -		if (!args->rmtblkno &&
> -		    !(args->op_flags & XFS_DA_OP_RENAME))
> -			return 0;
> +	}
> +	if (error)
> +		return error;
>  
> -		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
> +	/*
> +	 * We need to commit and roll if we need to allocate remote
> xattr blocks
> +	 * or perform more xattr manipulations. Otherwise there is
> nothing more
> +	 * to do and we can return success.
> +	 */
> +	if (args->rmtblkno ||
> +	    (args->op_flags & XFS_DA_OP_RENAME)) {
> +		attr->xattri_dela_state = next_state;
> +		error = -EAGAIN;
>  	}
>  
> +out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
> -	return -EAGAIN;
> +	return error;
>  }
>  
>  /*

