Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647D1C43460
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28FE36101E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 00:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhDVA37 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:29:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65476 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234856AbhDVA36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 20:29:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M0SuDc030361;
        Thu, 22 Apr 2021 00:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kt2DWkqwdkpwQz0j0nfdZsGTwuHW2R9bgrPW4Yo/MiQ=;
 b=ZI9VK9NYbZlbZEyOyKLGS40p21sYKqbIAjCceFjvnz2DV4zHxYzKVK4x8LGR+ls0HHIb
 /Nz9RJKu43R4HdQxz0hIOd3n5jRfOOFpXzav8U5El7dp7DjyXfE69tUi+wG04RfhUC9n
 1mjC9k37Hhi52uNk2YpYBP0Gv+ceGqAtf0Ig+HUNr4fRthCwVDiMIp6etHcBz7IHt3/q
 oNRD4M3rHoNQunDukPBW7CPkEZvcU2m/FPJgYg/kxUOoHLwzRZYoOdgIxKiaVMUMo0HN
 zQw90qhKw872GtOmjHGqB0kHvjnyWhbNcx8Mz7uwuNC6L9WVMv6NgfXe14HSYplzw0xg Kw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 381tw0grnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:21 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13M0QWFK165567;
        Thu, 22 Apr 2021 00:29:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3809m1cyjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 00:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgM92pK48XDvxySMsvC4XD+R0Rl09sWwAxDyTXbHNwu6wnCmD9S3qOmILm6Nhq/TQGx3PeiqbmqHtNrKneD9cqNktG0JYZ2veQjO/Wf2mi4hVo7v5c8FjwCE+103IgYTcNgBu5KNU2btq9gbYc2rnKjjaEQ1sJ3QbSqrNWaeQAh1VqWGtX0tpn7C/FnIphFg6QFVnfnDKk8K3aMnP0ezvPxDOsSTLBnz95fh0QKK+wb7qU2kq4QTEiczwaAxzdFcu1zo2NFZGEiNFuCBp4B8mXehnbisn9R1Af5lJugifAYs7Af6d37kqFPg7hpM16v4XW58WaFjlQ9ldeVVDFXgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt2DWkqwdkpwQz0j0nfdZsGTwuHW2R9bgrPW4Yo/MiQ=;
 b=UMuR8t2OP2ojyheQDpJYNzLYgUOOAJky4ocvKNtdUTr0fGN/gVMme/+nL2pJthHmITl3JR6CXNcBnvjPZDKQEZllCvlLbo6ib/Gws11QLLoWH6ChB3kc1cvSEuiQUOwlouh30zI+yMDB2fE5wdf7YX0+APjNERsCYBklnsH0VZwVLxpxVLG4OSWcoD3ktSPjdtZjjgS5Qu70zu6TY6lx9WVEHz8s+VLeISkOOct04XEyU0N/x6OGCnkFS/ZjhIp8hGQU1Oje2/JlIvCCdA+MXSkMqrHOmfK/9WIcsU1RVTZrYESQ7NlvVI9jzxoB8HO1bbblyUR6cPC/eDUoHdIVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt2DWkqwdkpwQz0j0nfdZsGTwuHW2R9bgrPW4Yo/MiQ=;
 b=FnaVoBtJelIyhaZeRZpuVAhiUo9wdOkRP50iP1VtPI+qokZHZ4Wuij4CNu5GNQ5GSk9LphHYXbeh+2BG6V09Di3FMzvyU8KjNF/XLKVCVmz0ucrIu8J3HokxTb7eFpSnQ12zhcIe1xcv5GcNUhgSMEN0/1y72kVPp8BptUFwnSM=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2517.namprd10.prod.outlook.com (2603:10b6:a02:b4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 00:29:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 00:29:17 +0000
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <161896456467.776366.1514131340097986327.stgit@magnolia>
 <161896457693.776366.7071083307521835427.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <358fe855-c59c-3599-4a20-e299a1cf08f6@oracle.com>
Date:   Wed, 21 Apr 2021 17:29:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896457693.776366.7071083307521835427.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR07CA0006.namprd07.prod.outlook.com (2603:10b6:a02:bc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 00:29:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33cf15a9-3693-4326-b816-08d90525a9eb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2517:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2517E5FDAF142F144E9F812795469@BYAPR10MB2517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:112;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3vkV2CSzSDUI1bRtTPLmanPsZ/gNc5wv81VXLJV8PBbteVU9BAI//wvF4yEQ6blI4MfohNOUdgtcw1kB9QmLkQr4W7gRbf6+7MV2rb8uFRSRFLpUCFv+DRvoF5D1meNOFd+u1yasqMtdPl7AbdhbIbxWd98e5yHelMqSeISZ2z+rKFJvrE+McpScFJBGCRLqD6NVjKXg/KOpnNgh2Ja2Af4ZIhUTvbi2+au0gKW9dvpPDMH8B83+cH5yMAb95X1TokN+VEphenjTXhd85lkFcC9B/KE0aB9djOpgGau31M/xN2hxf8jO6Rxkr7i38YY16aLH9Ezt2IlIewv3/evqlyRGsWuBcp6nu+6+VQ2WvF1hYeUFwJnJgzdBKLALdHi0BOftR23sm9kwA7qP5SZ9TymoPbehZzuDhK+z28Wo80iHqbxrTqZmYYv7TCikt+hzfrwDozOn/tHp+fG9440Xe0ONL4KFi+8KsMXbaf4NH8i/BNdItwEDrBmhH6ZYUTuJLzsOjwVjYbBFJ5gUrhvmONKriiIyYfoFDsAIGQk2JTxXcmcY6JmInH6TtRZoRfPjUR0J7fQRSdwe2B6C7exko9siay/t9vUofm1RRyvhAlE8l1GWYEJdNo9WOYtRA1kJL1yUF8Gt3DIeTp+ItfIgFwaUcEvlOFAy5b7uYAb0sWIz2+Xz1XPzg/Lzskca6yHCptoZouzny6SzTGWPpHRTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(6486002)(5660300002)(478600001)(2616005)(4326008)(38100700002)(16526019)(38350700002)(83380400001)(86362001)(31696002)(52116002)(66556008)(53546011)(66476007)(956004)(36756003)(316002)(8676002)(44832011)(31686004)(2906002)(186003)(16576012)(8936002)(66946007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TkdLcS9PM2JvUmRZR2lib0gvam9UcU00eFhPSjJCWWhoTFdLSXU1U09xRm92?=
 =?utf-8?B?dkZJQ1N1aEYzZmZ3OVBVczJJOFdwNzNEb2dtTEJDQ2pDb3pydmNpd3l4YkNk?=
 =?utf-8?B?bHFsZlNJSzlRR2ZHd1FvcEszaitRYVhLcGNMME1CWnRLd2NnQlNmWmgzaTRR?=
 =?utf-8?B?QXdNa2l1cVRwdVdESGRQRlZOcEo0QTRUSkZvdm9NQ0owS05FZGtwRTdKWFNp?=
 =?utf-8?B?K3NRMWptd3QvOC8wTjhJMFppM2NXdTVUaVMrV0VpbjFWMVh2N1hiYUw4Y0F4?=
 =?utf-8?B?NWEyVHBBQzBVRVZPekNSamxhMWttbkc1alpzNExUSnZtam9rblh4Vkk5TDlM?=
 =?utf-8?B?L0o2VWlpM0JTNE5lSXliN28xdHdDQTBPYXVUNFgxa1VjejA0T3FFREkycEl1?=
 =?utf-8?B?enlrbHVLUlQ4K1ZGa2VBWmVqMEtxNXFXNll4NWlJdWJZdTB3YkNyOTB5R3d2?=
 =?utf-8?B?ZzhTRTBPWTBvR1hBYXI1RzRNcWdMb0k1VnpCMHJTTTd2QXJzdk85ZWM3eFUz?=
 =?utf-8?B?Vm9IN1VxWCs3ZG1zaVlOeDhDN291a1RrNDREWmJrM21pUkNhdGNDRkhVWmFm?=
 =?utf-8?B?TmVRcnJQeHNyUHJLQjl5emVaT0RqZHkxdkx5WWdTVjRjWmJ0cVBjdWFub1hB?=
 =?utf-8?B?ZDJKajdEQjVXNnNVbFJpT0Y1M1hBcnFCMTE3amFJMHZTYmpqSVZ3ZTM1MHBn?=
 =?utf-8?B?U2FRUW9pQjJGVmI2WVV5ZFFCY01NVTF4TlRiZ2N5MkNIVVZPNHNvME1CTG1K?=
 =?utf-8?B?ZkhmejQ3dTdNVmZFbmcvWDYvUGtIcDFCRnBBeklSenJ6YWFjTWNjZGNOTlVs?=
 =?utf-8?B?SWd2eGF1cHZrS0hZbHJHKzFWYlVFMEJUSmNhYjgwRlZjMXlNNE41QXZDcEVm?=
 =?utf-8?B?SXFnKzRNTDZwajllSVVMdEk0a1IyOS9nZmIzT2NKcnhsVTZvV2U0Z0RXWDJZ?=
 =?utf-8?B?NnJKdFM0anN6NDRiUXBLc3dXdFZIdVErR25BSDBaWUx4Y0c0a3Vza0Z3am9K?=
 =?utf-8?B?YzgxSVNvZFlyV3hnY1VEb1hwRjFUK2hkWW1ldGg2VmcyRHpZSllwMnhyTGJX?=
 =?utf-8?B?QUgrK056QzZGN1FiNGJna1hzMFdWV0MvRHgxbDF6dzJuUXUzN0tsYXBlMi9T?=
 =?utf-8?B?WFc3OGJGREtNakYxa3gzdWlOdDFPanAvNkx5YVg4TDQwVCtETVVYNU04cVhz?=
 =?utf-8?B?bDdINE1MSzVVbTlqbnRYUkx2enZESTlFYzVseDB0UVI3MjA4SHNtZytPK3Na?=
 =?utf-8?B?N0RkQ3U4b3pHNmVaWHJ6T2hLK2E3MjdaS3FuYUFMRGt2TExLWnZ0TzcvaVov?=
 =?utf-8?B?c05ydDljSmczb1A4VWU0cUg1YzQrWXcyMTl4TmNuM3pGcFpIWEhZUVBlSHV2?=
 =?utf-8?B?VnhZU2svelFqL1p5ZDhuQ1hzMnc5NzBML1o0OXVKR2x2NkFjWmxYTEdKUUZ1?=
 =?utf-8?B?ZHpNODduTFViQUR6NUpCV25abVlncWZESkk3STRDOC8wOXBsMUFtTm5GdlFS?=
 =?utf-8?B?L3QxWENmNVJYbXVBc3huQ2g0Vi9YZGcvcDQzWTNqQ25RSlZUS2oxMHV2anBE?=
 =?utf-8?B?MnFKNXpYWnFxQ2JLKzFjVTRsMTJBSHJybnNJdXZ5MzhadlI2RlNISnlKMFZn?=
 =?utf-8?B?ZG50QWZTSy8vb2Mra2VHYmtoYWRZaXZkVytqcHVtUkx4SmdlbmgwUG1GeHFz?=
 =?utf-8?B?KzQ2NE1neVhDUGdmeTlRMVdmVXN1VzBEZ3psOFU4ZjdtTVRyRFZ5a3JyTnEy?=
 =?utf-8?Q?Rc+St5YQMp+pmcweKCxAiGPXrU65L6lGHBXt7hj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cf15a9-3693-4326-b816-08d90525a9eb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 00:29:17.4024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgwkBT+bGco7kaLb7es7UVTgvI5QeJIqXVPOYgNDXSXt7NUd3cOnnbkbhSHwgIrgfGgmViSfnoVetyGikSfPl+jPAaEImHDpOGOS4Icmp2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220002
X-Proofpoint-GUID: 6ITgZe4JD6sUvmqwM5patAfhMAcpTaTO
X-Proofpoint-ORIG-GUID: 6ITgZe4JD6sUvmqwM5patAfhMAcpTaTO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we can actually upgrade filesystems to support inode btree
> counters.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Seems ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/xfs        |    8 +++-
>   tests/xfs/910     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/xfs/910.out |   23 ++++++++++++
>   tests/xfs/group   |    1 +
>   4 files changed, 127 insertions(+), 3 deletions(-)
>   create mode 100755 tests/xfs/910
>   create mode 100644 tests/xfs/910.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 5abc7034..3d660858 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1153,13 +1153,15 @@ _require_xfs_repair_upgrade()
>   		_notrun "xfs_repair does not support upgrading fs with $type"
>   }
>   
> -_require_xfs_scratch_inobtcount()
> +# Require that the scratch device exists, that mkfs can format with inobtcount
> +# enabled, and that the kernel can mount such a filesystem.
> +_require_scratch_xfs_inobtcount()
>   {
>   	_require_scratch
>   
>   	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
> -		_notrun "mkfs.xfs doesn't have inobtcount feature"
> +		_notrun "mkfs.xfs doesn't support inobtcount feature"
>   	_try_scratch_mount || \
> -		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> +		_notrun "kernel doesn't support xfs inobtcount feature"
>   	_scratch_unmount
>   }
> diff --git a/tests/xfs/910 b/tests/xfs/910
> new file mode 100755
> index 00000000..237d0a35
> --- /dev/null
> +++ b/tests/xfs/910
> @@ -0,0 +1,98 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 910
> +#
> +# Check that we can upgrade a filesystem to support inobtcount and that
> +# everything works properly after the upgrade.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_xfs_inobtcount
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_repair_upgrade inobtcount
> +
> +rm -f $seqres.full
> +
> +# Make sure we can't format a filesystem with inobtcount and not finobt.
> +_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> +	echo "Should not be able to format with inobtcount but not finobt."
> +
> +# Make sure we can't upgrade a V4 filesystem
> +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +
> +# Make sure we can't upgrade a filesystem to inobtcount without finobt.
> +_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_check_scratch_xfs_features INOBTCNT
> +
> +# Format V5 filesystem without inode btree counter support and populate it.
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/stress
> +$FSSTRESS_PROG -d $SCRATCH_MNT/stress -n 1000 >> $seqres.full
> +echo moo > $SCRATCH_MNT/urk
> +
> +_scratch_unmount
> +
> +# Upgrade filesystem to have the counters and inject failure into repair and
> +# make sure that the only path forward is to re-run repair on the filesystem.
> +echo "Fail partway through upgrading"
> +XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
> +test $? -eq 137 || echo "repair should have been killed??"
> +_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
> +_try_scratch_mount &> $tmp.mount
> +res=$?
> +_filter_scratch < $tmp.mount
> +if [ $res -eq 0 ]; then
> +	echo "needsrepair should have prevented mount"
> +	_scratch_unmount
> +fi
> +
> +echo "Re-run repair to finish upgrade"
> +_scratch_xfs_repair 2>> $seqres.full
> +_check_scratch_xfs_features NEEDSREPAIR INOBTCNT
> +
> +echo "Filesystem should be usable again"
> +_scratch_mount
> +$FSSTRESS_PROG -d $SCRATCH_MNT/stress -n 1000 >> $seqres.full
> +_scratch_unmount
> +_check_scratch_fs
> +_check_scratch_xfs_features INOBTCNT
> +
> +echo "Make sure we have nonzero counters"
> +_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
> +	sed -e 's/= [1-9]*/= NONZERO/g'
> +
> +echo "Make sure we can't re-add inobtcount"
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +
> +echo "Mount again, look at our files"
> +_scratch_mount >> $seqres.full
> +cat $SCRATCH_MNT/urk
> +
> +status=0
> +exit
> diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> new file mode 100644
> index 00000000..1bf040d5
> --- /dev/null
> +++ b/tests/xfs/910.out
> @@ -0,0 +1,23 @@
> +QA output created by 910
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature only supported on V5 filesystems.
> +FEATURES: INOBTCNT:NO
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature requires free inode btree.
> +FEATURES: INOBTCNT:NO
> +Fail partway through upgrading
> +Adding inode btree counts to filesystem.
> +FEATURES: NEEDSREPAIR:YES INOBTCNT:YES
> +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> +Re-run repair to finish upgrade
> +FEATURES: NEEDSREPAIR:NO INOBTCNT:YES
> +Filesystem should be usable again
> +FEATURES: INOBTCNT:YES
> +Make sure we have nonzero counters
> +ino_blocks = NONZERO
> +fino_blocks = NONZERO
> +Make sure we can't re-add inobtcount
> +Running xfs_repair to upgrade filesystem.
> +Filesystem already has inode btree counts.
> +Mount again, look at our files
> +moo
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a2309465..bd47333c 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>   768 auto quick repair
>   770 auto repair
>   773 auto quick repair
> +910 auto quick inobtcount
> 
