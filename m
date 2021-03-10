Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F95CC43381
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7196664FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhCJXtz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:49:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbhCJXtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 18:49:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANjprQ057643;
        Wed, 10 Mar 2021 23:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JFj1+TK1QM+uMakMKoE07lX8JwzKeXcOIBwNExjusgs=;
 b=iVZ6er2dtiN/g1iLdwx2sSVQJR9W2WXw+JqwqoCBTHuylAv5S+JwbzUvcinLI8kd/NW2
 IaHS5UQOypNvILTHnLdiYoZNmbWCAYxKFUGPBvHsZ0vnG2gi6DUtEkugs9Mx3rdYeVef
 dXFPRwSROVAoyOsQQhz1xzjmzx1xhZ7GOO8VgyfJziy1mhIRlKANwRSKWWHe89wgA2rW
 R4ZuMSyimVSv2GuZ7P42cebDUCSXa23lqi4h7tpQqAcU8Hj/+GdKArJiTqIbZ7hpBdOL
 T0teIBnVHDeQ6iWF1jqI7o+dX2ZTANzXETV2a6nW5YYbhAn1uXp0nFxKauN/E/GSIXrm DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3742cnctm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12ANjcwM043569;
        Wed, 10 Mar 2021 23:49:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 374kn1p6ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 23:49:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ+6YIAefUwrN3OfWlehs0kW9aIF82qkKDDW3NdLXma/w5r8tcjiM5ENvR3iToBu2fRKymCq3Wb9dnDopXCl1gpPn+Nn8iWYCKeoxv7a3Vl7Xp8zkXHbZ61VtN55DpCI7aG+ww1WYVQv58hnTW/NMn9nc+gru+ILUouGUtFK0bApY0suqEnW43Yoz+sWPjr7LfaEprtJfVXxh5DhnYUbqFh0ZPxbFdx0FHnGo777RPlt0KG0BHx26mYcu5wd7HevMnJDmZaXbgPQ6nBeOTQCb/gEkLLpLAuTbcAMvlnTxgfeO4H2LkTY5ytb7Qa3orAD2J9r97MKxlwrcIgchwz6ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFj1+TK1QM+uMakMKoE07lX8JwzKeXcOIBwNExjusgs=;
 b=N6LaBU3pCrKkQFR29KhtdxtiI85o+hC4caPM/V2c560qVJQehdI7WSlVqLhv4I/m5nMkJCxQNfQDfRW6qsXKu5Cb+YHkLxGSQC2MvJBDvkdoBv7bwfBzWcMWq3FcwhnN7fVJyK4dKZzePpfqpdb/Er+J+myNRuyALCmYMkgPSvlHQO5Sb7LEYbKwv1EK9ZOKl/nXGtbKFqovviL73/H7JYp+7WSk/SQB4fbXKOUbvkRC776TU7KjS3Pxqp8XWpnT9exL6IuYYAoSeW0WI/WrfqP2YV6ccBwUWZHhdeDIivaraYKJKKMsZzmQic6ti4Y/TlsIdrjFsO0Frw4glk+XdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFj1+TK1QM+uMakMKoE07lX8JwzKeXcOIBwNExjusgs=;
 b=QC1hv6AcYlYKmOMiXgvejU3v+99iChySDp1Qqg5cRLDhI8lijXQRiVps+e7qOO4G4a4jacDCDGchzelcOamCyMBQ+3DtZERZw0yPUm2LVoFrpzRzP4IcpuRA1niZJ4BwVcUi6utoY5jHRDxRHhLCQFnBWxVqjtJjyqdWekiaa4k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 23:49:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 23:49:40 +0000
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent
 error tag enabled
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-14-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <537dba42-b671-faa0-2bb0-999b2b7e346f@oracle.com>
Date:   Wed, 10 Mar 2021 16:49:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-14-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:332::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0063.namprd05.prod.outlook.com (2603:10b6:a03:332::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Wed, 10 Mar 2021 23:49:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 996283da-1ea6-44df-3c23-08d8e41f2ba3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4177:
X-Microsoft-Antispam-PRVS: <BY5PR10MB417772CE4461871CB8BE5F4495919@BY5PR10MB4177.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zHCf8S3ANb5pjvLpIWB9IxvTglWd/2pvTLtt8/d7K8RpkxuCJdbw37tNcYVla9tpFPv9y4Lr7hVvRsXXIt9lWu3cHtRRN6YIP3wc2QuGQxgMZ6aQ4lWr1PxTnimZw0rtHsJmwcXnARA/plmxOZ3acZ/mBJUpcBzu3kwB7rKm93wsSvdOHBOBdYA3sLpfBnvq4ShnHAEO+9FSXQmG5npv9QB2XHWZ0WrpRVCCorvTgltfaStC6/EP/tu191yjP4yUmTZyRTfqtGWdJWgej1knRA3gnL/6HghO1yzg2VOsydBsCtwAaXlFwSZblcqSQ1vF1c3SuWmkGeb7N3NfFnUK2BPRV3nC/2RynTZtgp+ID03OwE6pCDt83AOI/kauan7JHbH6qd1f6mQCcfvhSPwnzlHKAEZ1QDPFScHa0UmYZoQkB5vogb7vReePYJniF3UDrzZjJDTzXxXikfpQwruwT3vMnQo/+tp4Jv1otOXyeQKysdy2BpP1cCNNR7R//9P6v5IAnYponfG279bLEtFld7MlvzT9Y5Q9aC64n5L59YNGFBvtth2y7um1E7Wojq0Qc7NhtfooUQRKqCc7s3J1D7P8ZlDUxjGytkhnMii2GA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(346002)(136003)(478600001)(316002)(6486002)(2906002)(52116002)(53546011)(4326008)(86362001)(8936002)(8676002)(31686004)(16576012)(66946007)(83380400001)(66476007)(44832011)(186003)(31696002)(36756003)(16526019)(26005)(5660300002)(2616005)(66556008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2hqY2JCcTdsdU1PWmZmL3hqQ2xJMTZTTENRUmtYM0lTcnNId0RUYXlVNUFY?=
 =?utf-8?B?cm93V00zYmYvMWU3YnJEL1c1L3V1S3k1WDZxMldsTXd5WUZZbFRKQ0ZvTDUy?=
 =?utf-8?B?YTZxYVFjaEZlVzUxSUhCcG1pR3BJRVpkOEd6Yzdvd2Y5WThEbmxhRFBDNG8v?=
 =?utf-8?B?eXZ0UkNoUEZjcGVKNVVNc1ZKcm5teDlCdXBWRStNMHRzOXNvVTI5VXBzeGZ4?=
 =?utf-8?B?ZXgvaUluSGFEVUxBU2dQeDRra28wSGdoa1kxOENrM2RnZjRkV2dXT2VmdnIw?=
 =?utf-8?B?UVN6MHE5V2JFU2xlZDN6OHRYL1B2eEJJOEgyUlBMWXhFdUtJMnVzL2RTSkNt?=
 =?utf-8?B?YUlsV1ltRXM4RjI4UmZ3UEIxQkJpbUtYNGRoSVV1bjc2OFg0RUpLbFloYTk1?=
 =?utf-8?B?aVowNWxnMmtWZFIxaVovVEh2SjBTek5uK3hZSTRTclVkME1HejZJL0FJbzA1?=
 =?utf-8?B?V2xhVDE5SlBxNHBPeTlDcFJoMnMxakNVK2pmeHJWL3Y2d1o5bGd2K3F4ZStE?=
 =?utf-8?B?K3hZSy9Ec2J2blZnODBUZ01WSkxmWkFPblFZRnUzZHdXbFBCdFUxbTRSV3Fk?=
 =?utf-8?B?eUJTTFNUVkd6VkVxTEdRQnFGb1Uwb1hNSjlzc3RmdkoyTXR3aVRMQnlGQmpO?=
 =?utf-8?B?VzhIaEw5SDNLM3pwcFhGUlc3dGpXUFo4d1o0NjMzOUJNS095c1FzZS9Ga2Zk?=
 =?utf-8?B?NHl1ODFPUEZQeTRJSERWeVZzcjBNeXJjTFZaZUl3b1lSU3YybEM1QnFEQUtx?=
 =?utf-8?B?Z25JOURaMkZrVG5IS1Fxcm5nYWdGVHpJRTRiT0d5NVhndWRCOEU2bHpSeUlV?=
 =?utf-8?B?bWY4VzZwZ21ySjZ4Q3NEY2taR1ZtWFlnL2tNY0NYakR1ZUN4emNuOTgzbFRv?=
 =?utf-8?B?OXRMYmcwNGZaQlhJU01wYU5tUmZqRHI2R041WHBxRDVXazYxOVVWYTF5em5l?=
 =?utf-8?B?WUdvRjB2YXJzRkptb2VNVEVOK1l6bEhyT2dlcVpnaGNzMjJzK1RKZ3FSbTZY?=
 =?utf-8?B?Tll6Nk12VVZ4cWVzZjBpcmZzMGt1WTg3eE81cVBROWprNG9BanBUd0h4K1RN?=
 =?utf-8?B?cWdTSzJ4SDhldzhlc2sySmNmSVNUbTNqSXRPbGRhRHZXTnNZTG9MWS95SUFq?=
 =?utf-8?B?YnZBd0pmb3ZYdk9WQXlGOTIzMkFYNHRRZ2UwaEYrSmkwakpJNnhHYzk5dDEw?=
 =?utf-8?B?UGdCY1pzQzEwQ2lvUnZBSytjRjlGR3BZUHk4TEtBRTlodytldEFUV2ZYMll5?=
 =?utf-8?B?cnhSc3RFaS9MWW1CemZqeFhGWW1NSCt5YjJOb2ZsRHVBb1lpWEh0RENOTEUx?=
 =?utf-8?B?T1FOcjduNUpnUE1xRFhCY1ZqSTl4T0NHeVFtQ1NGMlRqRFU5VFJ3VThVUnZ3?=
 =?utf-8?B?UmRpbzBLQXQ4elN5Rm9MOExhL0lpZmIzL0tnVmdmalZKYkRIOGFjdk5pbE1z?=
 =?utf-8?B?SGFHYTNHN01IRVQ2Um9NNWFrd0xvV0doTEpKOEhpMFhTQTIwVDBIT1NmSjRE?=
 =?utf-8?B?NHNwWG1BU01NUkQyZjVMRzlGOTFnTngvOEdPVUFVbEtHWXk2K3hqRzF4K2Fy?=
 =?utf-8?B?VVJ5OGJIa0tZM2JHWCtCSVAxYndQRUhXZ01qazQ3akl3ckRsODVSUGtiTWJl?=
 =?utf-8?B?N3NtczU3VW1yeUNlWkRrQkV6bFBBYmxlZDc3Vm1YMUZZcE9GM2lBdkt2QzdM?=
 =?utf-8?B?QW9YSGZEWE82aForVUhVc3o5UzVpclVtZEVXRDRFTlM0NW83eEhCU1o2RnVt?=
 =?utf-8?Q?eFHSckNoJLtEfw2/uRuaTyRaQaKB1LDHCpbf9Ob?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 996283da-1ea6-44df-3c23-08d8e41f2ba3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 23:49:40.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pisa1brBbd7nvkUsDXj7r8JWCksP/Y4SI7ae2wgMS6ba2C7xneh4uw/BanvlnGcP4Nx/cfuiBPOQP6JPI0Qj95ze8if6z5dbbnKUDWndVoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100115
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9919 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> This commit adds a stress test that executes fsstress with
> bmap_alloc_minlen_extent error tag enabled.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/537     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/537.out |  7 ++++
>   tests/xfs/group   |  1 +
>   3 files changed, 92 insertions(+)
>   create mode 100755 tests/xfs/537
>   create mode 100644 tests/xfs/537.out
> 
> diff --git a/tests/xfs/537 b/tests/xfs/537
> new file mode 100755
> index 00000000..77fa60d9
> --- /dev/null
> +++ b/tests/xfs/537
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 537
> +#
> +# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/inject
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_test_program "punch-alternating"
> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +
> +echo "Consume free space"
> +fillerdir=$SCRATCH_MNT/fillerdir
> +nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> +nr_free_blks=$((nr_free_blks * 90 / 100))
> +
> +_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
> +
> +echo "Create fragmented filesystem"
> +for dentry in $(ls -1 $fillerdir/); do
> +	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> +done
> +
> +echo "Inject bmap_alloc_minlen_extent error tag"
> +_scratch_inject_error bmap_alloc_minlen_extent 1
> +
> +echo "Scale fsstress args"
> +args=$(_scale_fsstress_args -p $((LOAD_FACTOR * 75)) -n $((TIME_FACTOR * 1000)))
> +
> +echo "Execute fsstress in background"
> +$FSSTRESS_PROG -d $SCRATCH_MNT $args \
> +		 -f bulkstat=0 \
> +		 -f bulkstat1=0 \
> +		 -f fiemap=0 \
> +		 -f getattr=0 \
> +		 -f getdents=0 \
> +		 -f getfattr=0 \
> +		 -f listfattr=0 \
> +		 -f mread=0 \
> +		 -f read=0 \
> +		 -f readlink=0 \
> +		 -f readv=0 \
> +		 -f stat=0 \
> +		 -f aread=0 \
> +		 -f dread=0 > /dev/null 2>&1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/537.out b/tests/xfs/537.out
> new file mode 100644
> index 00000000..19633a07
> --- /dev/null
> +++ b/tests/xfs/537.out
> @@ -0,0 +1,7 @@
> +QA output created by 537
> +Format and mount fs
> +Consume free space
> +Create fragmented filesystem
> +Inject bmap_alloc_minlen_extent error tag
> +Scale fsstress args
> +Execute fsstress in background
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ba674a58..5c827727 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -534,3 +534,4 @@
>   534 auto quick reflink
>   535 auto quick reflink
>   536 auto quick
> +537 auto stress
> 
