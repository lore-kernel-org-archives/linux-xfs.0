Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B98EC48BE8
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D271613C3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 05:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhFNFkv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 01:40:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29692 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229696AbhFNFku (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 01:40:50 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E5bEcH013748;
        Mon, 14 Jun 2021 05:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IdYstGrWyHp8eqQKhh51er/802rDdazmTlwe2r5vKtU=;
 b=fINmA0NTw+xlM2nU75F+3KMDrrZKvQn+4ba7tYWGmqsbWaVAZvjW9U2VkjHaUiWnQJz3
 mCzY+8cZ8q3QfauB2lUO1AfHECZ1bIOO+B1xR3HXacGt6vH2hGjGENGXIWwpQqeXnYlN
 VfSyWeoLr71Sia26MDklB4lrQ2+nbAyie08S2AqfOLK3eYB/za7BdZUry3Aes2KM9lnC
 cGb6ChXcSKYYkhpXC+c3GemY6UcclLM2WcxjDt00NzftSf+PHxT9D28M9H17pSEj+P2I
 g6ee7AHJzLL2BGjZ4ns9sn2HAP++r3jI7DDIkHnLMkuPypsJ/5UhHDFLp6Ssrf5G/fQM Tg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06g1g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:43 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15E5cg9i025341;
        Mon, 14 Jun 2021 05:38:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 3959chvs82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 05:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7kdDhf3L1ii9t9/J5uxa9qRA/bIk41jXMyMgvU1SgqZr62JAve0I3rA/Isdm5LUjE0qie0TX8O0/I2fbCGtr2vcWXevzDVEwEJQSSZRRGXUsFlkk28k5NXh3HBgsPRjJNbWI26hjEg4/J/aF3lNnuewMJ16He2wAch/wQlTHO8TKnC+6OvsrascGkpU7sxWPIZQGa8e1OTLZFUr9cuW087gVEtFCIVv5LzHFTPmFoTCZyE1cZ6mQHPhpQz6dobRHyRwRuIXx4+nIKlJn6ddEM1K4NCXSGcZ+e+THhCHEOArfRAy2RnHy4nSyl4fHpAHWoWslK3K5wrlxlu245kh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdYstGrWyHp8eqQKhh51er/802rDdazmTlwe2r5vKtU=;
 b=DL9q69Qn7rky5T7xzIUQ8DjpucUsnjeWDUFxsLvsa+Pu1EBm1YM/oXWFUB5P2mSb/qWnQwhZAZIXOg11qt+RLjv+29/6hRuejjf0tpPoplj6VZ3qt2+GsEx0+ILZXYUjhWdvxUuNlY/rCqhnXP35ObTCOgQ5frLp9KEMuNj+c+q8R3G8aWcRrxrJsMXXLwt/c/iV8Ky81ZkG/GKb0qe3kicHQAb8+9tYRinasv4h79SIC0BmGQs9sr+eAnMqDFt5pD2dF3ja72pKyWURp5RcZOrPQdLWzmBpwUncUiw7tscmF/Li0wq4dstt/jXcYrj+64kYoW97WB3aQq7z41Nq6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdYstGrWyHp8eqQKhh51er/802rDdazmTlwe2r5vKtU=;
 b=rN97YZchtAEnuc0JbcL0M63wvGLtXe8RoW1PMUo6UXnnucquhr3JKFYtYLymOAbK/x07RuPakACKs3HBnftzl1x+oGSbT4Z/Zl32Zna0XVsGoiMVVlS8+3j7snxY9RAYU1YtX7YKUxOS+7SqvHLJGQHkNDcTQUE95xMGIifAWeQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2485.namprd10.prod.outlook.com (2603:10b6:a02:b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 05:38:40 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 05:38:40 +0000
Subject: Re: [PATCH v1.1 07/13] fstests: automatically generate group files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317280046.653489.3322406175723320960.stgit@locust>
 <20210611233703.GF2945738@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ecc57e27-d5f7-b01e-76ae-dc962f456040@oracle.com>
Date:   Sun, 13 Jun 2021 22:38:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210611233703.GF2945738@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0067.namprd13.prod.outlook.com (2603:10b6:a03:2c4::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 05:38:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ad6d356-c2e2-4639-4b52-08d92ef6aa2b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2485:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2485A1D6BAE4E5697121B7AB95319@BYAPR10MB2485.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RTcWS2MHCpMXO6NDJ4PiNA4Z+qTmQyet+oznLonYVvalukdelBXW1SSdTfgsXzHL+1MnvMyBGxm5lC9AmsiEDF+P8sEsXLnPNyZT4JEbHgnjH+OURI7chRjgkje5cZrKmFj17EYAXvGZD4lwe/DvuEgmpi4PEFDzakHk8Umhh67sCCUdr2USUBWxK4fB2e9dkr7ddM8EKNEdJXu/rq1sJ6mdgFrz1Mbmgbx+Pf+p+SA40pz9tuPxvjn/K9zfGviOqE3XqtXadte7P5l/8tPWsY7Iclp1vZG6cKgkCQTFrdQhh1wGW/Sgjl/lo4l5BPH68axTzIloOqf7awn/u20JpQAEJkIb95f4qN3VkFVByhlMIRlvfCVcF/fiRWuqfvJ727TsIs9VtUNyqo/pgSTBQo5QCbalasFIqmu64F49uJoI8EC47q7Z1VuHbFnwa+IkZ/v8AsCzER9mNw6AtdS1xw0cly4pa2KUBa5HvITYitxR4sqwjijzMMRljmSnSbCVYrLMD0rlO5r52dWVcjfbCdLPdZ1h3zu46oU4XSDtGs1Z3zbyoPA1uCNyjWqGYJczOKc4ffa3rH2b7HFIiDMEdXjRNNTMrAAnJfaGRQle9YJnSfmqd2egmPJWKjdJOEvZsoKDhP8X8bMy5bXRSTvE8203QYZ3TSGsqFjBLf6xdV97z3+b6CybDvlJ0TgmBgFGMjtRa2dsfoEchdWB0uesZTUcXxjb94x+M6cRfqXenY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(366004)(39860400002)(186003)(16526019)(5660300002)(31686004)(83380400001)(8676002)(53546011)(44832011)(478600001)(2906002)(316002)(86362001)(8936002)(30864003)(66946007)(4326008)(38100700002)(38350700002)(66556008)(52116002)(66476007)(956004)(31696002)(16576012)(26005)(6486002)(36756003)(2616005)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzNpWHpOWTltUC94UThnRmRSZWRYVGRtU0VmWWt2TEFIUEttdGdLYUlzUDJp?=
 =?utf-8?B?d2FYaGUvVFF5N0VYeVpwRElPazU1ZWVIa09mNFptZzZDL2lHaHdFTmpxbFNu?=
 =?utf-8?B?MW1rT2RmWm93Q0RhWkRNNUp3WHlCRWRPTHRHVFllcTFNYVpmZmZtUGc5d2Ni?=
 =?utf-8?B?c3c5ay9ZZHo0dnBBdkswYVhsN2tGMWE3bk1leFFjWCtJdndQRGUyckVSZjlq?=
 =?utf-8?B?TG05N2tpdDRaYXNCVDBkSmdsTHdGZjhLL3VlaDZqN2FKSVVOSEYveEZHQUxz?=
 =?utf-8?B?cGw2dGpuMVY4bXY4Sk8rOGFGbmFpdnRKYXJONVU1U0Z3QUpiM0QzRUZxdTla?=
 =?utf-8?B?Q0VoQ3VJblh1dWczOTNWL1hETU94MlpPUXBtWVBPSmY0QTJINmQwZWlnV21X?=
 =?utf-8?B?R1BubnhaczBhMjhUNkxZdzVUTmhuNzl2L3VaWEpybWVsdzBRU0dxS0MxUlMy?=
 =?utf-8?B?ZUdyRC94TnNKcGoybUh2VFByZ0Z4Znp0NmRNVkgvWm00MWtvdTJGcjJ3dmRL?=
 =?utf-8?B?eGVGdCtTTW43THlqVE95MWQ3V0MyenlWZUJ3cWtZSmtOSnAxc0RnUUZVTXJt?=
 =?utf-8?B?YUR5UndQODVmaml1VU5pY3I2S0w2YS9Wc05NUHRSdW1hYnFSZm5seVVRdmVv?=
 =?utf-8?B?Sk9laEVlKytDSE0vaEtiSTdkUGI1TWhPVlZHSmxHVzA2dmMzd0FvemRQcW5z?=
 =?utf-8?B?ODhuT2RlREZtaElJYzNWWENoOHoyZGpOeFhBOVNkU1MzVis5cTk0WGNsbkpN?=
 =?utf-8?B?Vm5Oc3dOOUJkZDlXdC9KbHYxWEx1TzRXVGdpcXhSNTFJSW9zWHhJcHJhMUcw?=
 =?utf-8?B?Nk1PaVA4YjVWTjVjZ0VadjZadEREeGxRZ25Td0Nab2NhRDdiY2c3YTl4Y0lK?=
 =?utf-8?B?VkNzMFdYVFpJRGRyWWJRUDNTRmVmRHRYdHY5Z09rTlJXaG1PaTZTeGJNdDg1?=
 =?utf-8?B?UDFlM0tJV0RjMFFDdWYrQVhqRmt3b3hqNWVGU1hCOWlrOW43akdMVS9nS1pS?=
 =?utf-8?B?S1NyZ2U2alQ3UTJhODF4M2o3MXhSSGZhMDdDV3lZZGhPRmw0bG1VL001N05X?=
 =?utf-8?B?c1NLNGxLWmRjSjEvT0Z0SDBGa3pmMmc5SVNDQUw0QWE1clNTenFER25qRnhT?=
 =?utf-8?B?UlkzVFBHeUg2S0xoY3ozODg0MHFCeUdiT3NzWmVpMllXYUVVTzhsUWljcGpD?=
 =?utf-8?B?MFVHaVorTlVnRU53c09qUzd1ckFhV2FMdTRGK0pSMGsvZHV1R0ZObkJwR3Fo?=
 =?utf-8?B?cmY1cG15YzJKVmlKUHVBQno0VXNTS2twd3EyamQvK1hxQThnTkhFbU8rSzVi?=
 =?utf-8?B?NkhNdVdrRkxPQUJYZThiVnlycHJjZnpNZVdObGhYdUJvVDR6eFdoOFFLRzRt?=
 =?utf-8?B?dnNVb2JLVXM3U3JNRGp2RmQ3YW1iWTIzclQyR2E4UFVSdVdOM2svUDVqR3Fx?=
 =?utf-8?B?eDFPU2JHVWZQL2tjbXdUcUNjV2NrbndvTmxlQ3VRRTFMZzhIVjlTbmx0dm55?=
 =?utf-8?B?ZllhOEl1WEREeGlDd0Q2NExmbnBRaSs4a0lKSDlvT2FrKzhGcVE3ZEY1Wmt0?=
 =?utf-8?B?MnZkR0ZTc2gwZlJOZEpYK1NEb1lFMkZEb2gzcExzL2pNSVFmeWFFS0grTzhI?=
 =?utf-8?B?K0JUV0VxY1Ara1pGZ3N0ckIraXBld211R2RLa2JIMmkvS0d6bHVDb0Vab3Y0?=
 =?utf-8?B?WkxQaXlxZFRCam5xSWNzN0NoVllRblh1NlNiMjZod2FlOGt6NnJXSGlJdDA2?=
 =?utf-8?Q?goeUurUMbXoOJYG6Uru59KxRh7k9xiOeKsZBLna?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad6d356-c2e2-4639-4b52-08d92ef6aa2b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 05:38:40.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMoe3Oik3QfAPHsfCXogj9LV4gIPUDIU/T0yaYFi2zHa9xnPjE+WOXVdVBqymlTrLuaXgE00DAKAJ7WQ6ApBx5ywykXXgVD3VjP0LClrfPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2485
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10014 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140041
X-Proofpoint-ORIG-GUID: 8jqQ1HpbPbr7Su3N--fBLuFasfaoW6Xb
X-Proofpoint-GUID: 8jqQ1HpbPbr7Su3N--fBLuFasfaoW6Xb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/11/21 4:37 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've moved the group membership details into the test case
> files themselves, automatically generate the group files during build.
> The autogenerated files are named "group.list" instead of "group" to
> avoid conflicts between generated and (stale) SCM files as everyone
> rebases.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> v1.1: fix make install
> ---
>   .gitignore             |    3 +++
>   common/preamble        |    8 ++++++++
>   include/buildgrouplist |    8 ++++++++
>   tests/Makefile         |    4 ++++
>   tests/btrfs/Makefile   |    6 +++++-
>   tests/ceph/Makefile    |    6 +++++-
>   tests/cifs/Makefile    |    6 +++++-
>   tests/ext4/Makefile    |    6 +++++-
>   tests/f2fs/Makefile    |    6 +++++-
>   tests/generic/Makefile |    6 +++++-
>   tests/nfs/Makefile     |    6 +++++-
>   tests/ocfs2/Makefile   |    6 +++++-
>   tests/overlay/Makefile |    6 +++++-
>   tests/perf/Makefile    |    6 +++++-
>   tests/shared/Makefile  |    6 +++++-
>   tests/udf/Makefile     |    6 +++++-
>   tests/xfs/Makefile     |    6 +++++-
>   tools/mkgroupfile      |   42 ++++++++++++++++++++++++++++++++++++++++++
>   18 files changed, 130 insertions(+), 13 deletions(-)
>   create mode 100644 include/buildgrouplist
>   create mode 100755 tools/mkgroupfile
> 
> diff --git a/.gitignore b/.gitignore
> index c62c1556..ab366961 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -11,6 +11,9 @@ tags
>   /local.config
>   /results
>   
> +# autogenerated group files
> +/tests/*/group.list
> +
>   # autoconf generated files
>   /aclocal.m4
>   /autom4te.cache
> diff --git a/common/preamble b/common/preamble
> index 63f66957..4fe8fd3f 100644
> --- a/common/preamble
> +++ b/common/preamble
> @@ -32,6 +32,14 @@ _begin_fstest()
>   	fi
>   
>   	seq=`basename $0`
> +
> +	# If we're only running the test to generate a group.list file,
> +	# spit out the group data and exit.
> +	if [ -n "$GENERATE_GROUPS" ]; then
> +		echo "$seq $@"
> +		exit 0
> +	fi
> +
>   	seqres=$RESULT_DIR/$seq
>   	echo "QA output created by $seq"
>   
> diff --git a/include/buildgrouplist b/include/buildgrouplist
> new file mode 100644
> index 00000000..d898efa3
> --- /dev/null
> +++ b/include/buildgrouplist
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> +#
> +.PHONY: group.list
> +
> +group.list:
> +	@echo " [GROUP] $$PWD/$@"
> +	$(Q)$(TOPDIR)/tools/mkgroupfile $@
> diff --git a/tests/Makefile b/tests/Makefile
> index 8ce8f209..5c8f0b10 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -7,6 +7,10 @@ include $(TOPDIR)/include/builddefs
>   
>   TESTS_SUBDIRS = $(sort $(dir $(wildcard $(CURDIR)/[[:lower:]]*/)))
>   
> +SUBDIRS = $(wildcard [[:lower:]]*)
> +
> +default: $(SUBDIRS)
> +
>   include $(BUILDRULES)
>   
>   install: $(addsuffix -install,$(TESTS_SUBDIRS))
> diff --git a/tests/btrfs/Makefile b/tests/btrfs/Makefile
> index 2d936421..1b72a1a1 100644
> --- a/tests/btrfs/Makefile
> +++ b/tests/btrfs/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   BTRFS_DIR = btrfs
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(BTRFS_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/ceph/Makefile b/tests/ceph/Makefile
> index 55e35d77..2761e1e9 100644
> --- a/tests/ceph/Makefile
> +++ b/tests/ceph/Makefile
> @@ -2,16 +2,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   CEPH_DIR = ceph
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CEPH_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/cifs/Makefile b/tests/cifs/Makefile
> index 0c5cf3be..62c48935 100644
> --- a/tests/cifs/Makefile
> +++ b/tests/cifs/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   CIFS_DIR = cifs
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CIFS_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/ext4/Makefile b/tests/ext4/Makefile
> index beb1541f..a2a0d561 100644
> --- a/tests/ext4/Makefile
> +++ b/tests/ext4/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   EXT4_DIR = ext4
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(EXT4_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/f2fs/Makefile b/tests/f2fs/Makefile
> index d13bca3f..9d1ed3c6 100644
> --- a/tests/f2fs/Makefile
> +++ b/tests/f2fs/Makefile
> @@ -5,16 +5,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   F2FS_DIR = f2fs
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(F2FS_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/generic/Makefile b/tests/generic/Makefile
> index 3878d05c..b464b22b 100644
> --- a/tests/generic/Makefile
> +++ b/tests/generic/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   GENERIC_DIR = generic
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(GENERIC_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/nfs/Makefile b/tests/nfs/Makefile
> index 754f2b25..128d2a3a 100644
> --- a/tests/nfs/Makefile
> +++ b/tests/nfs/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   NFS_DIR = nfs
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(NFS_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/ocfs2/Makefile b/tests/ocfs2/Makefile
> index e1337908..260ad31b 100644
> --- a/tests/ocfs2/Makefile
> +++ b/tests/ocfs2/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   OCFS2_DIR = ocfs2
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(OCFS2_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/overlay/Makefile b/tests/overlay/Makefile
> index b07f8925..de3203c2 100644
> --- a/tests/overlay/Makefile
> +++ b/tests/overlay/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   TEST_DIR = overlay
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(TEST_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/perf/Makefile b/tests/perf/Makefile
> index 620f1dbf..0c74ba39 100644
> --- a/tests/perf/Makefile
> +++ b/tests/perf/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   PERF_DIR = perf
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(PERF_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/shared/Makefile b/tests/shared/Makefile
> index 8a832782..f3128714 100644
> --- a/tests/shared/Makefile
> +++ b/tests/shared/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   SHARED_DIR = shared
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(SHARED_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/udf/Makefile b/tests/udf/Makefile
> index c9c9f1bd..ed4434f0 100644
> --- a/tests/udf/Makefile
> +++ b/tests/udf/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   UDF_DIR = udf
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(UDF_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tests/xfs/Makefile b/tests/xfs/Makefile
> index d64800ea..5f413e67 100644
> --- a/tests/xfs/Makefile
> +++ b/tests/xfs/Makefile
> @@ -4,16 +4,20 @@
>   
>   TOPDIR = ../..
>   include $(TOPDIR)/include/builddefs
> +include $(TOPDIR)/include/buildgrouplist
>   
>   XFS_DIR = xfs
>   TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(XFS_DIR)
> +DIRT = group.list
> +
> +default: $(DIRT)
>   
>   include $(BUILDRULES)
>   
>   install:
>   	$(INSTALL) -m 755 -d $(TARGET_DIR)
>   	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
> -	$(INSTALL) -m 644 group $(TARGET_DIR)
> +	$(INSTALL) -m 644 group.list $(TARGET_DIR)
>   	$(INSTALL) -m 644 $(OUTFILES) $(TARGET_DIR)
>   
>   # Nothing.
> diff --git a/tools/mkgroupfile b/tools/mkgroupfile
> new file mode 100755
> index 00000000..0681e5d2
> --- /dev/null
> +++ b/tools/mkgroupfile
> @@ -0,0 +1,42 @@
> +#!/bin/bash
> +
> +# Generate a group file from the _begin_fstest call in each test.
> +
> +if [ "$1" = "--help" ]; then
> +	echo "Usage: (cd tests/XXX/ ; ../../tools/mkgroupfile [output])"
> +	exit 1
> +fi
> +
> +test_dir="$PWD"
> +groupfile="$1"
> +
> +if [ ! -x ../../check ]; then
> +	echo "$0: Run this from tests/XXX/."
> +	exit 1
> +fi
> +
> +generate_groupfile() {
> +	cat << ENDL
> +# QA groups control file, automatically generated.
> +# See _begin_fstest in each test for details.
> +
> +ENDL
> +	cd ../../
> +	export GENERATE_GROUPS=yes
> +	grep -R -l "^_begin_fstest" "$test_dir/" 2>/dev/null | while read testfile; do
> +		test -x "$testfile" && "$testfile"
> +	done | sort -g
> +	cd "$test_dir"
> +}
> +
> +if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
> +	# Dump the group file to stdout and exit
> +	generate_groupfile
> +	exit 0
> +fi
> +
> +# Otherwise, write the group file to disk somewhere.
> +ngroupfile="${groupfile}.new"
> +rm -f "$ngroupfile"
> +generate_groupfile >> "$ngroupfile"
> +mv "$ngroupfile" "$groupfile"
> 
