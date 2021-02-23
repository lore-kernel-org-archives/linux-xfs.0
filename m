Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF73C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5DB64E6B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhBWUTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:19:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhBWUTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKDwrA110554;
        Tue, 23 Feb 2021 20:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KetcY/+OzEpgBEJp1cuGlf9cEu8svAlsYGnrnSpq3uI=;
 b=oMSnaoI/wcJXXm9vxoccZc/mg8bvgalN9RUoI+JIWBjw9icOnVx3c94XlkOQ3AHG8Hzv
 sofqSD/cqas78H66JGHfvgDEHG+sEIgWMrmjaC0fRg88/x3TmaWuAp8R9LenRhdkix34
 +h3XCCDBTdSB4Z8lNo32NSoP0j12TpRPWxw1jZ00eI6UGAr4BJBjXOJDc7Xm3FDTH5Cd
 MmPysSwUaeQFipISAC8IaaUjMGRYCJkIcWpYh7siW39Xy32zaCNN8l40ZHhdOyFpzuun
 PV8NJfumMeT13pjTKAJ4E/LvGc1g9EKDFiOIdJyb53lUCmHH5HjUGnRs6pRTAQ12BMfJ MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ttcm8qe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKARNt185800;
        Tue, 23 Feb 2021 20:18:48 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2058.outbound.protection.outlook.com [104.47.37.58])
        by aserp3030.oracle.com with ESMTP id 36v9m52y5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx08xOt0p5oeLhra5OIkcFeBwUfi7uXYNr0W37i0IphgvSukxujGCUfem/Bti9PEZgdVUTg0eGqIUXaEdAiSJ5luAdeSmFKs/gUzLTYhfdMfKdfSh/RTE/e503dwbXw4M6Ea4kccqClBdpV21E4gi2SGJnp9mTmFLULCNllJAH93LJUv48gpWzII2OurCxLv7lc/+dVO8ckGQ+fKY0TcenGBLRT3McVLLZ4Ft771OgI4RoXA4MkwVUbC0eCW1eoukFSYUlyuWjcYuXA31Fokta+WZctW0TXhIKXoO2dsEux2Um1zlsd+/zyQ/bSzqFq3bqjvFXtixMAdHh4fLQC5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KetcY/+OzEpgBEJp1cuGlf9cEu8svAlsYGnrnSpq3uI=;
 b=gf+drt9RUlk7gXCJLOeBHFRJm51NPfVvhMAQW1CXOezZCbzgwiVodQ3okum7qy55zpiWasQHy5/FmDe+KqD/wPTvhOoyYmoqACqxSPHZBpX1pQLXlQYfTdw4QXvJaaU9zyqB9zjJsnwLsWYtqZqMjFPK/FWEOC79bk9tgsswyB6hFlGJHESrqNj7G7j4hw2MLmwK9YtZs4S1hupp3o5m9jkoVdqCT+hb38ShlImVBeDP+82RLNJGKKPSt7xqb1PMPvLK7fGEWNwspHniaBm0sVIlLRlsCqTVPJDGk02NyEBXuMEKG20iiFz3Gr/nxcZTjHX3yo3pMpbOgaZQ+JlFSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KetcY/+OzEpgBEJp1cuGlf9cEu8svAlsYGnrnSpq3uI=;
 b=mODKh/+i9YDfMl4IfNojREkn4Mam97onJWGvUgkeUxu+NdaZs6FYHhrl3DX9r8qvK7vlF2GbZrBF0qJyFAwGEi9zjprEKqAQ8z4HZnt8gaJy+mHU512rGgkbIR07gZrD2vJha6S1itv7X9tpgkCww11/hx04VO/sz54bdGOx/N4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB4876.namprd10.prod.outlook.com (2603:10b6:610:c9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Tue, 23 Feb
 2021 20:18:46 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:46 +0000
Subject: Re: [PATCH 5/7] xfs_repair: fix unmount error message to have a
 newline
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404924715.425352.7240443385329836467.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c9bf34fe-730b-65d9-930a-f58d2a1abde1@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404924715.425352.7240443385329836467.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:1e0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 20:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06ac292e-41f3-4269-f7ba-08d8d8383958
X-MS-TrafficTypeDiagnostic: CH0PR10MB4876:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4876B0DA10828FDEF86CB53C95809@CH0PR10MB4876.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:74;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBjJ8l+h58UUxQxN1sq86IGxmsbQkbwDclZyakiULT4u0SUi94U09LB2SY0xmoq/Yf7l7v+JQKUHEgwyMBkHF1MWyqurTTr6D2K45aRqQW/tO+cTJrB6kk7nW1bWb0wiCSm/VUIvxhnue07Ft20qYE2dLb6pLT1PuyuCTRDKu+A0Seo5zDxJ6fzswtVLF4YlRBXpERDKjoOtC8tF5h/A0i0N2lXb73R8O9Mu/TjihIH4kJOdnshffumAzBP64bkrR7njcw1nkgPSyXpNpX0bwyCoUm7D7EJrp2HXcdlgNByTis5isa596uAztRy/LgzRnutl+1BQPaEBXQ2I7UvImbn1qheIGqsovoDTXH0bCgLSWdG4cSYh4M3DYAenrUNAzFHKiQ5BjM1aR+ZKJYSTA0Eo99d3zuXAor4k57fZ49kBbbDprs3vawUrWr8syNNX/JyDVnG7QmGg5lhOjo2RZxoBqP7Q3q46NqZ2ksPhAxRJ3xw1+nboxxKgYrn3LGpqTfxLw2KuM+WQ6BMayjjv2q4jJBZYFlq5oi7rVv3iDMxIjt5cU+z7t2eVPuMvvqanvXLuyoeJB9Oegu17zuLWSco3R2aGseC5apA+6S4Azuo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(396003)(39860400002)(86362001)(4326008)(6486002)(83380400001)(2906002)(478600001)(15650500001)(31696002)(31686004)(44832011)(66556008)(5660300002)(16576012)(316002)(66476007)(66946007)(36756003)(54906003)(8676002)(53546011)(16526019)(8936002)(186003)(26005)(956004)(52116002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y25DZG5hVTM2SkozblBGclI4WitWdXV0dGtMOWtzcVl6Z1l5dzBIRlRscE5T?=
 =?utf-8?B?bFJVMXZ3SWFucXYvZWJXc2QvMVdmaXF6OFI4T2R2bXo0K2JJR2pVMENwcHdP?=
 =?utf-8?B?UW1qZWxYTmt1bVpscHVNdHNHTFdXS2YrT3JCajlwYXdhUHNvdlNhRFoxVTZu?=
 =?utf-8?B?SWdnZTBaTGhBeVM0ZVJuTzA5NWZZekhYVVJRTGVkNmErV044VFpxaENGUlJL?=
 =?utf-8?B?NTlINURCc1lRbVprNWV2NUxFME1pZzBOeWRiZXNCVWhBZHcwS2YvcGJ0RWE0?=
 =?utf-8?B?Q2x5UERXTVNJa2l4dHZqWEdOTVlvV3A4dklSSlZhdjhxOFZuL1JJUXgwYWx5?=
 =?utf-8?B?UEx1VWV1SEIzRndPeE5xU3lBNXdrRHNxSXplWWt2bUVVVnEySE4reVVPTkhw?=
 =?utf-8?B?bW9kS1UxT0d0eVgzWG5NcldNVkJuOTY2dFVKUE0yQkV1b2JVNlBtdGZSUkdB?=
 =?utf-8?B?Q1V1aFFvbG1nMXpJdm4yc1p4TE5NVU5aZHM5cTR3NCtJZU55NXQyVnlRZklB?=
 =?utf-8?B?cldZZlJaRFAyRHpFN01VZnYwbldBOVN3cU53V0FFVEZqRHMrbzgxbFR0MzFF?=
 =?utf-8?B?SmV2ckxCQ3BxMzBpelB1eHBFUWlXclpHbTFaRXU0eTRFUWtiemZHdDVCQUUx?=
 =?utf-8?B?MFZHSVEvMm90OU5lWUgyZm03M1lhbldvWkM0S2ZYN2pJQkNDWHFCVmhNN2dh?=
 =?utf-8?B?ejYwYk9pd1dZNXNqZjcrblQ1VUhycVg4ekRPbXpPKzVPUk1tN2FFVlZqZ0xQ?=
 =?utf-8?B?N3Vwak1LRmxwN1AwdmcyRUw4NFBxd2pxcXNCK21YTjFURlI4WG5MZHRlQ0Rm?=
 =?utf-8?B?SldRYVN5WUxjK0xPZzBDWWRTWmh6YUxIMGJoa05udTVGUDE3cmtZcHQzb3Bs?=
 =?utf-8?B?bXg2cENONVdycFcvMExueWV0S0tSUFFiMnpRb3I2WW5WVUdPZURKb0ltcHBB?=
 =?utf-8?B?cWcwajdRY2c1UnJ3OE1LQ1FmUWE5cnpaaUFibENPSWYxNjRjUnk5Umtvd2N0?=
 =?utf-8?B?YTgvcGkvSlZ6ZUJBOTBlYlgyYlJ2bjRGZHRYSjQwZ0x1WHZ2U2p2bWdqVW9P?=
 =?utf-8?B?WXV0MmRqUzFCYXNDT04zdFUrcXRCMlFKbUdmQS9JemFBeXp3elVCV1phQnE3?=
 =?utf-8?B?OFkrSUpJcEZaMERxTCtYQ1dzWG5OQ1VybFRiQi9LMlJuWUxhaUNVeTA3ZHVa?=
 =?utf-8?B?Tjc0TVE0cWN0eTNqalJrbkJhMkp5eEpMZGRaRE02cUx6cnFIWnA5QzN3Q2R6?=
 =?utf-8?B?Q0o0UVM3QTRiL2JWRXhHMnI1alhsSEF0Qm9XQU1GU3dSeEhYNG0xQXArVkUx?=
 =?utf-8?B?b2lnN2dlZjVtbU04VndhZmpkK1piTStnMlJjZDQ3dlhUWFdGamxoT3FSNDdN?=
 =?utf-8?B?YkF5WVkyc2ZVNDVITWlvWEludmd6NERPcGxJRmN2VzZqME5wOWhOWkxndXRi?=
 =?utf-8?B?bHE2L1FnMFl3cEErcll5Vm5qQkFJVS9nMitYTWZHTzB4TmVKUXoySkxGZnY1?=
 =?utf-8?B?K3pZZ3Y2MGNPQXkwanIyOG5VKzk3MkppaUZ0dlRYZkpkVE1lMUh5ZEI5NElI?=
 =?utf-8?B?eTF1bWhScWRWczJOczFlSkk4Z3lJS1pFSGNodjg1SXJjZTdadU83WFlCTHpD?=
 =?utf-8?B?VnEwT3hqaytpY082b0tvV3QrWW5ObHJVMlBnL2kvOGsrMk1hSEgzb1oxMStk?=
 =?utf-8?B?TFBZZHhNUEhFa1Fha3lHa3lMNUhleGI2a09WZmVsMENOOTNQUnhNcTlaWUZK?=
 =?utf-8?Q?Y8VVgbq/oi70+/ke80aVWZpnqYmc338t7vVkdn9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ac292e-41f3-4269-f7ba-08d8d8383958
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:46.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rInsrE8KnIaLyjuLlc4lGdj01qXhBiiJZO2xROa+wwclupqUY0wiqvK7d01KYJ8Oy5eR1ZZMok02Th03Cb3lHL/AwuaPl1fFIvz3L6rmXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4876
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a newline so that this is consistent with the other error messages.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   repair/xfs_repair.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 724661d8..9409f0d8 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1136,7 +1136,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
>   	error = -libxfs_umount(mp);
>   	if (error)
>   		do_error(
> -	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
> +	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
>   				error);
>   
>   	libxfs_destroy(&x);
> 
