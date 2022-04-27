Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F88C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356385AbiD0AgM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356380AbiD0AgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:36:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12FB3465A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:33:02 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QL95Cw025808;
        Wed, 27 Apr 2022 00:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6JY6CKWZYmwDhEQZeRok2S5hn4n961nl7pZHTmgm8No=;
 b=mVb7KOAKZg9C5xqf3vMHmmN0fo3creiQb7ec73rJfhYX0M2xodRjrdfp0D3C/z/J4HGk
 tArAC0hIKPAtsT3iEwUwmN1a1suM7vY4I76FDRBNqvjgU4FejO1vDuok3OovXqamuZRK
 vRbCjgWILNCMfOCbs83/0vyRG9izsIsmVS46sI1bu4l+S/4hCzycoDR/q8T4r9nC11y/
 1MZyDZI8KtqEqpTejeGIm0qmW6pLMR17q8Du6IZGXIsw7fAKJceqOrNB20DjT4VJzcgc
 OKUUGFG8BYVFmQSEXSmN0/kJBkBb40MhvxdXsTYowemosz3fhca3s1LoZTTiyqWhsC/h Mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mqp7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:33:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R0UbUF022909;
        Wed, 27 Apr 2022 00:32:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yk28jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:32:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wnzsl28HDJrCo18tVE0+4ZIwVQ6kJPRcemnTYX3XGeJb3hPjyZKExuZfphBZkjTXEvWpuTKs9IPdQdJTI8vTmk8tMg8q/sL3skrUnzM0uaunjxiBqOAMsAu1AeDMzSeJRMRESNVHXbidMYveftPayMF4i/DX84fVsXd0aT8K2EQUkwHrSfngm+YpfTOzT7UmWhN931IMow1r9QRaT+jAw6qgti5ISacvT9RPEsMOWJVuY7n3vlGowIDod+zI93fvJ8H9k1ijrUkVNpMJPsBwwAFPjqQkvWfMbvV3HGHEuUG36/hlwKXKi68nbwRpf8iR8q9aB5V7GMVD704HcpSqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JY6CKWZYmwDhEQZeRok2S5hn4n961nl7pZHTmgm8No=;
 b=k3IvBHZLdO9zg/NEbOPOZs9/AlMKbeukpa4hoMScdvRbjOjM5/n2qHHybZ0digDD+r1Y8gtr9HhXxt1QGmcD2CwyNMHog75YtopJuSC+ukK2Z4GgLIvYEAs3kxYM94eKeXiqNZVsnas9wLQK7Q3Zf5zfh4fg/364PzZWHqbhIq1U8x13qY9gYbVAwL+g0XiNKMZM9mNO0cCyoNMbxoigsL841/BohDLH2U1eQHjA4058phvcpEkEllcj4p6sX7PC6BvKMSL+fDatzlhaBE7udBwuk27el7Rjm19bXYBWaEpWCoQAEj4k9J8WqgM1Qj7d92zjNaz7JPwMUaa63YFxFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JY6CKWZYmwDhEQZeRok2S5hn4n961nl7pZHTmgm8No=;
 b=tnD3lc70vjripAa2nqA1Nc1inPHASrzBSxKjjNf98FocAU/xKmiRPeAVe3czgoM93QFyofXCxvlTt7e3H+CpjvLovng3/p3/5tluKT7G+l9pnEs30cBvN+e/P2YdikVi1cZkw+moTouHU1WRotaf+7Dvxfl/ocktFSDEh/9BoSc=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3305.namprd10.prod.outlook.com (2603:10b6:5:1a2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 00:32:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:32:56 +0000
Message-ID: <b8e9af0af0a6131e8a81b4d03c1a746e1852e038.camel@oracle.com>
Subject: Re: [PATCH 11/16] xfs: xfs_attr_set_iter() does not need to return
 EAGAIN
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:32:55 -0700
In-Reply-To: <20220414094434.2508781-12-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-12-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0055.namprd17.prod.outlook.com
 (2603:10b6:a03:167::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7b5b50b-bde9-4153-7ebe-08da27e57999
X-MS-TrafficTypeDiagnostic: DM6PR10MB3305:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB330503EF68311798DF2C7F5295FA9@DM6PR10MB3305.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IS9+7VuMbIH6b1BRPkgBrwGqOaPyVG3aCl1qXmpx3VK6c4UxbtHNfZQY6A6BEafW6omKBzffyeRA9yoEahbfQWqKJq9Hux3bKkHlcx1DU7g+E+9r0CUzfgIfbHg2lf95J6NA3qi/i+FEDvdMy/xfZYFPcZrelnhk/LG3vKqfEx2bnlvMLfc9+F05ai49CNrGAjctroWiDYfZ4WWj1qJWAVYG6jCyZBLVa8D2nlAuFsvVBDib7WA7hAm6jTyMa1JXW7fx/ES/H5bzyDi43inylZp3biG7aVdL1/Uo9Q3RKjO9KE2KO+02yfC4FhFxFw5EJv1KlxGIsJEFcM6pabHujajFkIIv7RXzcwYUNpJgJyJC8N/3bbshyY05squLTKJiRQqp0vfSviDjpIJmUeY71U42ArEGZlZVFSucxYyCeQIrqaKMdxA7De4ZAi7oaswKnjN53iug3UgYERR4LppSXQjQH9cSItXKIxbNFSFhru7dcCdauLbntDzDoNr9g/zfTEv58j3TxhL7a21RKe2efSywTRowmAAEH4HjcqJl0q+AebEvzxemn4zpZzP2p9tg7hKw/AvKDe1bVTbhmyUoQ9nHCk9ZhUDv/ehpBkgSL+KDzJ1CZQ5UueZRp4wCzFkfA2o+dopeRyQXi5vC3ydo0MlXTwrfBvxSjmQEv46ttUnQdCqczpPHig0jot9T4bX0nL1sywcVeBnRvP0/z7z5aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(6506007)(6512007)(86362001)(83380400001)(2616005)(186003)(8936002)(66556008)(66476007)(8676002)(2906002)(38350700002)(52116002)(5660300002)(38100700002)(66946007)(36756003)(6486002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUczRkMvSlVkbmRLWnY3MU5mVjNMTzRPeE4wWXZrMHc5NXFFZFczUUlZRFFY?=
 =?utf-8?B?OFJUNHdiYVQySEpMNFFtck9tVEx2Y3R1MHZEcWFaTTlaTnpLdHJScW4zZVVa?=
 =?utf-8?B?ZUFaR2VUTXBBQ0NOOGk0ZGRZZnFmSC9XaXFkbzBoMlFPOXQ1ZzRzOW9VQmpW?=
 =?utf-8?B?NHE1WkFzNCswWkpFanFtam9xMjBST3NMR1FoZS9GbGV0K0swK3NFbkJxdkx5?=
 =?utf-8?B?ZzFmcGZGRlNuVW5qZlBpajNpQXBOOUNHTllESllQQ1prbzltMlViZHBxb29D?=
 =?utf-8?B?WDg0dk5jVzJrbzFxWmlZNGtOMkJPTTFhMlhDNVZtK0JNRXpqL1FIY0RBbEwx?=
 =?utf-8?B?dHpDWklvUld2NmVqeHFseld6cWFubUpiWmowSjEvUjl5NFpnL29Fc2xYZzM3?=
 =?utf-8?B?Q01hOStld01DeTRQeG94NmhxQTlFWFNFenU5WDUyVWNxUU5tN0pIdVI3RCtQ?=
 =?utf-8?B?VnROTjVkNlZ4dWhoV010azFIWHhxenV5K1pzQ3d3dWdJZDYrQlFKMXVIQk52?=
 =?utf-8?B?NXl2UlFvcUFGcGRJc3REZHVZMDJSdGJ1K0QyN2o1Q09KTU1IVDRaRWNxYTRO?=
 =?utf-8?B?bXQvQ2ZxdG9GMGF4NTZVTERhek9zZStFa0ZTcmhvd0hEaTY1Qnd6elJQNWtn?=
 =?utf-8?B?ajhUZGNRVGwvdnNXNEg3KzRrMng1REpHbCt5V1RJWFhsQWhXTG4zNmUrVnJk?=
 =?utf-8?B?QkhQSXliK3ZtNVRtazNlNEU0ZVNxQ294Q3J1cndlMjhXNC94aTQ1QmxhU25X?=
 =?utf-8?B?K0ErUUJUNCs5aHA2LzlGbHlkbVJBbTFrbWlRSG9hYzdSazlHbGx0VkJhV25D?=
 =?utf-8?B?b3UyL1JsQXIzaEY4emRxT3RLTG9RQjVIS29pVDVnM0RQclljOXU3MUMxNHJH?=
 =?utf-8?B?U1BYbkk3Ly95ZlFIZmVsTmJGVlRUQU40MTlUR2RYbTJOVmJEMFNRT2hsQms0?=
 =?utf-8?B?QW93Z0xJbjc0VjFCSVpsYzRjYTNvVEk1Q0NybWxXTlJnL3YrY1NNMlZJQVhC?=
 =?utf-8?B?OGlrcWdRODNrUDRMMzZ1cU5RMTZKNUowaDlxbjh1c2ZXdUZUZGpOWGlUbytk?=
 =?utf-8?B?SWZOSnpHZGNJN1hPOFIyLzlWSG1yUFU0eWNaeDRXanB3VGpIeFNtSTVtK09r?=
 =?utf-8?B?bmFCTWhYb2pXOGgrWGMweisvdml4OXJ0QkZBcnUzZUQ2UWF4WFBwbEwrTDQy?=
 =?utf-8?B?dlhmOUE1eXNab2VWTFo0b1g5eXEvVnNSQ1BQdGEwR01YQi93bTZxZlBGdjJK?=
 =?utf-8?B?ZTJDWmVFNkVWT3Z1RFYwMDRWYnJrSG5hdGNyS2NpMVJRamxKV3hvRUVQczNK?=
 =?utf-8?B?TjMzeHBMQzFyUWZDWElaTk00Y2ViODJyUk9zWTdKOWwwZGMwQjJDam5MaVJr?=
 =?utf-8?B?ZGtEU0xUYUtxZUl3dVVlenFoQnhucjN0dm4zd29ONFFVTHJENzNFZVBKRE9m?=
 =?utf-8?B?eXhiT0JUMHIrT2ZFTlc3WEh6VlBjeWZCcUt3a0tkZGtSREgxQ1k3KzNyU0F4?=
 =?utf-8?B?Y001ZGpxL0kxUkJ4Tnp6OW9vY0NPRDRXS2hVWm4wSG9XYldlK0VRTnJ1YU1l?=
 =?utf-8?B?S29BbXlVdng2M2dBdFZyWmJsT2RQM05SK0NRVVRuekhHWWUwSGhIMHBlaCtF?=
 =?utf-8?B?MEk2WUhNNzA1T1hUSUo5N0hPM0RpSGc2SHQrb01XbmZMUi90T0RvTDA0YnBG?=
 =?utf-8?B?SlRZK2o4eFc5ZlBtYkdMeTQ1alk0ZlM4QitRYThydmFWT0htSzlzL0ZxQzZD?=
 =?utf-8?B?UmlSRGJaUkN5VjRuZW1zM082ZHNTazFheklyNFNIa3pSbTNXZTRqTStHRzhX?=
 =?utf-8?B?bUVHWHpjRThqNE1LRmVoVFVpOWZQK3RmT2ZXOFZsZmViSlZvK1NsaEpleFJ6?=
 =?utf-8?B?aXE4eWU1c1k3cXVUNllKMmU4b05NV2NQTDRHL1pwRkUwbmhxSW9ZY2MrV2hG?=
 =?utf-8?B?SUlBbjNMZks2Q0ZuNGJaK3BzZnJKK3hwNHFmeUcyUjVoZHdHbmdNeVQ0RDF1?=
 =?utf-8?B?WHhuQWpEUGZ4dHUwQTNGTHg2bnBTbmE1NkdVSmdFUVVmcFlDUTk1Y0FOQzBp?=
 =?utf-8?B?U3VZdU0yekJodlpxTHpuQ0JXZWtsWk9YYXRnVW1xaGh5eUpDV3huMWhNb3M4?=
 =?utf-8?B?Skszd2VjOXRhU1p3R2Qyd0VYTHhDOGdFZWE1cFdxMjR1c3g1RjdmVEdvSVg1?=
 =?utf-8?B?b2ZlMnBlbFYwWHpPODlTeUpndWh5VUNCWHBRb05ualppaDg0ZHo2cjdxR25q?=
 =?utf-8?B?c0h3bTFUUVFWeXRJQWdJYmFQbUlILzlMNTNvZWk2bnlCdTlrNjd6UEd1dStB?=
 =?utf-8?B?Sm1EYVZ1enNleHN2bWt4VEZzZFhwdlgwcDRRbEJNZTE4dzNMWXpvdEl1VUE5?=
 =?utf-8?Q?csC1LLD9rPJQqzBE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b5b50b-bde9-4153-7ebe-08da27e57999
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:32:56.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmaDwxAV6nTUBZ2L++j2h+iL13ydDFAZWBEO7r3jDTsrE3MxhP5cIlIUzZboyyQZN1RF7zx6yHdL45DLMrl16hL9F/CSjZhm2PFTLDs5ZWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3305
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270001
X-Proofpoint-GUID: QhoFvJ9A0y-1M1_yxGt5KYr7o0xQWlh1
X-Proofpoint-ORIG-GUID: QhoFvJ9A0y-1M1_yxGt5KYr7o0xQWlh1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the full xfs_attr_set_iter() state machine always
> terminates with either the state being XFS_DAS_DONE on success or
> an error on failure, we can get rid of the need for it to return
> -EAGAIN whenever it needs to roll the transaction before running
> the next state.
> 
> That is, we don't need to spray -EAGAIN return states everywhere,
> the caller just check the state machine state for completion to
> determine what action should be taken next. This greatly simplifies
> the code within the state machine implementation as it now only has
> to handle 0 for success or -errno for error and it doesn't need to
> tell the caller to retry.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks ok
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 83 +++++++++++++++++---------------------
> --
>  fs/xfs/xfs_attr_item.c   |  2 +
>  2 files changed, 37 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9dc08d59e4a6..a509c998e781 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -303,7 +303,6 @@ xfs_attr_sf_addname(
>  	 */
>  	xfs_trans_bhold(args->trans, attr->xattri_leaf_bp);
>  	attr->xattri_dela_state = XFS_DAS_LEAF_ADD;
> -	error = -EAGAIN;
>  out:
>  	trace_xfs_attr_sf_addname_return(attr->xattri_dela_state, args-
> >dp);
>  	return error;
> @@ -353,7 +352,6 @@ xfs_attr_leaf_addname(
>  		 * retry the add to the newly allocated node block.
>  		 */
>  		attr->xattri_dela_state = XFS_DAS_NODE_ADD;
> -		error = -EAGAIN;
>  		goto out;
>  	}
>  	if (error)
> @@ -364,20 +362,24 @@ xfs_attr_leaf_addname(
>  	 * or perform more xattr manipulations. Otherwise there is
> nothing more
>  	 * to do and we can return success.
>  	 */
> -	if (args->rmtblkno) {
> +	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
> -		error = -EAGAIN;
> -	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +	else if (args->op_flags & XFS_DA_OP_RENAME)
>  		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_LEAF_REPLACE);
> -		error = -EAGAIN;
> -	} else {
> +	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> -	}
>  out:
>  	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
>  }
>  
> +/*
> + * Add an entry to a node format attr tree.
> + *
> + * Note that we might still have a leaf here - xfs_attr_is_leaf()
> cannot tell
> + * the difference between leaf + remote attr blocks and a node
> format tree,
> + * so we may still end up having to convert from leaf to node format
> here.
> + */
>  static int
>  xfs_attr_node_addname(
>  	struct xfs_attr_item	*attr)
> @@ -392,19 +394,26 @@ xfs_attr_node_addname(
>  		return error;
>  
>  	error = xfs_attr_node_try_addname(attr);
> +	if (error == -ENOSPC) {
> +		error = xfs_attr3_leaf_to_node(args);
> +		if (error)
> +			return error;
> +		/*
> +		 * No state change, we really are in node form now
> +		 * but we need the transaction rolled to continue.
> +		 */
> +		goto out;
> +	}
>  	if (error)
>  		return error;
>  
> -	if (args->rmtblkno) {
> +	if (args->rmtblkno)
>  		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
> -		error = -EAGAIN;
> -	} else if (args->op_flags & XFS_DA_OP_RENAME) {
> +	else if (args->op_flags & XFS_DA_OP_RENAME)
>  		xfs_attr_dela_state_set_replace(attr,
> XFS_DAS_NODE_REPLACE);
> -		error = -EAGAIN;
> -	} else {
> +	else
>  		attr->xattri_dela_state = XFS_DAS_DONE;
> -	}
> -
> +out:
>  	trace_xfs_attr_node_addname_return(attr->xattri_dela_state,
> args->dp);
>  	return error;
>  }
> @@ -426,7 +435,6 @@ xfs_attr_rmtval_alloc(
>  		error = xfs_attr_rmtval_set_blk(attr);
>  		if (error)
>  			return error;
> -		error = -EAGAIN;
>  		goto out;
>  	}
>  
> @@ -482,11 +490,12 @@ xfs_attr_leaf_remove_attr(
>  }
>  
>  /*
> - * Set the attribute specified in @args.
> - * This routine is meant to function as a delayed operation, and may
> return
> - * -EAGAIN when the transaction needs to be rolled.  Calling
> functions will need
> - * to handle this, and recall the function until a successful error
> code is
> - * returned.
> + * Run the attribute operation specified in @attr.
> + *
> + * This routine is meant to function as a delayed operation and will
> set the
> + * state to XFS_DAS_DONE when the operation is complete.  Calling
> functions will
> + * need to handle this, and recall the function until either an
> error or
> + * XFS_DAS_DONE is detected.
>   */
>  int
>  xfs_attr_set_iter(
> @@ -547,7 +556,6 @@ xfs_attr_set_iter(
>  		 * We must commit the flag value change now to make it
> atomic
>  		 * and then we can start the next trans in series at
> REMOVE_OLD.
>  		 */
> -		error = -EAGAIN;
>  		attr->xattri_dela_state++;
>  		break;
>  
> @@ -575,8 +583,10 @@ xfs_attr_set_iter(
>  	case XFS_DAS_LEAF_REMOVE_RMT:
>  	case XFS_DAS_NODE_REMOVE_RMT:
>  		error = xfs_attr_rmtval_remove(attr);
> -		if (error == -EAGAIN)
> +		if (error == -EAGAIN) {
> +			error = 0;
>  			break;
> +		}
>  		if (error)
>  			return error;
>  
> @@ -588,7 +598,6 @@ xfs_attr_set_iter(
>  		 * can't do that in the same transaction where we
> removed the
>  		 * remote attr blocks.
>  		 */
> -		error = -EAGAIN;
>  		attr->xattri_dela_state++;
>  		break;
>  
> @@ -1200,14 +1209,6 @@ xfs_attr_node_addname_find_attr(
>   * This will involve walking down the Btree, and may involve
> splitting
>   * leaf nodes and even splitting intermediate nodes up to and
> including
>   * the root node (a special case of an intermediate node).
> - *
> - * "Remote" attribute values confuse the issue and atomic rename
> operations
> - * add a whole extra layer of confusion on top of that.
> - *
> - * This routine is meant to function as a delayed operation, and may
> return
> - * -EAGAIN when the transaction needs to be rolled.  Calling
> functions will need
> - * to handle this, and recall the function until a successful error
> code is
> - *returned.
>   */
>  static int
>  xfs_attr_node_try_addname(
> @@ -1229,24 +1230,10 @@ xfs_attr_node_try_addname(
>  			/*
>  			 * Its really a single leaf node, but it had
>  			 * out-of-line values so it looked like it
> *might*
> -			 * have been a b-tree.
> +			 * have been a b-tree. Let the caller deal with
> this.
>  			 */
>  			xfs_da_state_free(state);
> -			state = NULL;
> -			error = xfs_attr3_leaf_to_node(args);
> -			if (error)
> -				goto out;
> -
> -			/*
> -			 * Now that we have converted the leaf to a
> node, we can
> -			 * roll the transaction, and try
> xfs_attr3_leaf_add
> -			 * again on re-entry.  No need to set
> dela_state to do
> -			 * this. dela_state is still unset by this
> function at
> -			 * this point.
> -			 */
> -			trace_xfs_attr_node_addname_return(
> -					attr->xattri_dela_state, args-
> >dp);
> -			return -EAGAIN;
> +			return -ENOSPC;
>  		}
>  
>  		/*
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index b6561861ef01..f2de86756287 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -314,6 +314,8 @@ xfs_xattri_finish_update(
>  	switch (op) {
>  	case XFS_ATTR_OP_FLAGS_SET:
>  		error = xfs_attr_set_iter(attr);
> +		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> +			error = -EAGAIN;
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
>  		ASSERT(XFS_IFORK_Q(args->dp));

