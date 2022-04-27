Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5286C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbiD0AiD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356380AbiD0AiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:38:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75C835DC2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:34:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QNZGGp003693;
        Wed, 27 Apr 2022 00:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fOZkrnrHi+14r0QH7Oed18/6J/gSajp/GjNDHsyyTZw=;
 b=C4BFzBnN5zutvDu5WrnmTdHKnvwDVDuJA52JZjFWRcW5Gp0HkSRvj7H/dXHCI+KH5Xzn
 8Bk8phcFJtDq7J40boNF/MK20qmwcM819aWbP/MQmz57wI/fqfIlmvTUqc+OxyNFB3Gs
 g4K5TpJfSfwQlWRK0F8GmPD0p6JwA9ehQWwinI2S5kip3VZyrkQlBM8HpmUziIO3kaZB
 3kCTP/rfbqevTsWvBFkwthKcwRS9WWbz/a6QIRLevV6ghZSOzyLFXxIerFpXSPpqmUHI
 ZPU8uS0VXBn2hZFyYmukOLJk7hLI7biojeQGX8qwf6fghY2cVsCwV3vuV+JrKeMa/Gc+ yA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4qc8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:34:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R0U4e1039203;
        Wed, 27 Apr 2022 00:34:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3y3ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 00:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sa8npfqjmTZb87Mx27Bl07LZ/ClESX3803NfWTo50wL5X1WnlgGpUKo27iJJcojtQ4SgKrUt+zh6ry/Z3fsg1H9GNsphIS6yppgme8NC7xViPNHUfJjkUIub3fla0wvia5ulG9F5gPGSA1hT7shX+5aMnWzmwFX1PXrKtvzsEuBba5cJF4uOaYapvP4+6UBN70nWt3ItDhMcicMb3jB+Y1iTv9qUeaChQYOyLF3Zket+wtyljD1hpgTUc1DPy+PkHt8XR7sTgCeRIIZZaqxA6m4sLITqzUiTAR+/AMbnSblhZeDzwcjr4GmQQnU2xqJF7O3prtM7n8mp2rI3fVXEmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOZkrnrHi+14r0QH7Oed18/6J/gSajp/GjNDHsyyTZw=;
 b=YuQC//YfMyY0OWL0b/GJzW7vZmZtRXQ56F6/Wy8dlDaONeAiXCknxwngGYII1DLxCDFs6GFRdmLMs8rImF0zOADoUacGTBcTnqaAzKzPUOCy6yJu8ALOStFANMCDN6tNcu4pjusNK3Ct59zFF775CIpTFp9pKDmqb/XXyuWiAr0Na1RqAr7FZbbe3oYeK5PkVJ19y/crsnRaHaYDznTZl0VTXiJBIiUmHKYFsJi94Fs8+u9bbL2s5qU3qGiqRWw6tgsj8EcvQP7J5Al8DXtMi7R+KNZ0dhDEvygEfSkB+xg3GcUTO+zViB3BuE3JILHQ6s2NA2gLUkqXJnRV0AZ61Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOZkrnrHi+14r0QH7Oed18/6J/gSajp/GjNDHsyyTZw=;
 b=qqY4pYdmea5NssZZWizGQO2pZVRWBc+EyfkqQaRbmBwDxyU8qj58avscTSCqRDCRljLS9+9+CYH4tzLBaXjjVzbcLJdqMMJgIzabbyYZ6XRBv/zEnOjwiRFfzJb2mISwr/UvZTDR+3dHRJ7/vvvlds20rjRuPXcF0Hna+4m17kE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3305.namprd10.prod.outlook.com (2603:10b6:5:1a2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 27 Apr
 2022 00:34:48 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%9]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 00:34:48 +0000
Message-ID: <77c71042835cc77e5d9cdd506142e6b4ac7998ca.camel@oracle.com>
Subject: Re: [PATCH 14/16] xfs: remove xfs_attri_remove_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:34:47 -0700
In-Reply-To: <20220414094434.2508781-15-david@fromorbit.com>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-15-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:40::36) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 028f22fe-6ae7-4a98-83b4-08da27e5bbcd
X-MS-TrafficTypeDiagnostic: DM6PR10MB3305:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33052A4D79646DF869ADCBA795FA9@DM6PR10MB3305.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K//tUbiQl/2Cf36RyQb//AVauc+OY4Rkju52fl3kwXWXFMPROzq44Q7zKv1WpR9lH4mmOnhVRAHAYb3EGHZGjZDuoeo6kSo7gWRhBBTlUONDVqwpf9/d6ZN/DpyCIetrSUe29ya3Rwxq7ZH4gsn/coZf2XJx3WGXVrAnXnOtgWTwEvq/BZD3eo1Yl33kjEOgehaoSQJJTIkQpvZVfxb5A1aEQo9gEoZvdyMRbv5NYiE2oY/GV4Y0Kt9bbpMuGThSLbQ4o7WpzQb4WV2iZE60RDMDZdC27qdceJjwFeLIU4no0lxJ8SGE3YQC8AlIOFXqSC/OHu1ctR1gbg4AHnIS/E4tI9rLVfoy9YbYVbVyKyMmknZFhf8CNkdT9cjTEEGxPjdWEK75wRcF8Yc41c5UwLXSDCC2e1SBP4+PoADxvFbg3YiHXBtM4+PFBzzKnpwRmM5aIz4qIyJQODcAeDYm2W/Vce5HHxR8G1ucgCPGt2fEskQF5XGzixnCHJFeA2lVlsYhcFS0nsqNSUVv0zUL1IF8jthhVcj7OPoZUExRH6NrtHh+SUDl8abyuLGk3F74cJk5KpQPHCJg1c6QCioW2YikvSCOvs5WLEWEOVA1HtwpwQOSo6HHUYRtEd5oa8hJdVkizUsFZPd+PZFap5H5EyqmUAlqjpEPs6PUMcKCU2W+Z1LnzJcRLnSzMU3IT9+htfbUM0WCiqZdVcacJa3IrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(6506007)(6512007)(86362001)(83380400001)(2616005)(186003)(8936002)(66556008)(66476007)(8676002)(2906002)(38350700002)(52116002)(5660300002)(38100700002)(66946007)(36756003)(6486002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sk11U3lOTEx4bmdOSWJVdXFuYTJ0aForOTR6QjlYMkpBcnRWbHArRWJheTN0?=
 =?utf-8?B?ZnNodzdBeWxUR1cvcFphZ3lhTzVrV29yRXZhWnMyaEgxWFJSSmkvQ2xQaDdq?=
 =?utf-8?B?elRlZnNFRTN0c0J1bFRKK1UwZVdER0RnOTgvQkZHMDQ3aDFSZ1RXcE9XMXJw?=
 =?utf-8?B?SUs1dEpPOVNzUy9NQnQwRW5zRnNTa0l1ck9XSm0zWFZQbmtEeFJtZ2M4TDJi?=
 =?utf-8?B?aHcvVTVRWDBsblQwMUFISDRxL2FKZXd5ek1JRmNNZnFFTXNpTXhhQUlyL0VV?=
 =?utf-8?B?MFhYd295dXkrek9KOW1pK2dENGtxRjBtZ21rWmh0V2QyYVkvbEdValExZ09h?=
 =?utf-8?B?UVlHNytVVU4rMFZSZElHSjhPNy9GckRrSFBVSEEvNlVyR3BEK3M1UmN1TlZH?=
 =?utf-8?B?OHhmTU8xS2NSYVl3UE5pYk5Lc2tKVkk2VVFlRDFDMk9IZ1E5NUI4RWdIYnY3?=
 =?utf-8?B?ZzdaUjJrOGRtMDVPOU1wcmNYTmw2Zit0bExtek83QXpyQldPR1RzcERtbE9W?=
 =?utf-8?B?MHZuMTlEaHAwR0lVTzZvZis0Y3pXQTV6VmZJdTFmNTdRUEF1alptRU43QUNY?=
 =?utf-8?B?OURaUmZkM3RPUG0rbno5aEhmYlRzU2l5Kzc1NUxmODJEMk9reVpNbjB0NWhw?=
 =?utf-8?B?bE5PVFNnZXFnUHN4ZEsvWXc1S3JUdFhJUnQ5d0dTNjZDeTI5MENFeElsejlj?=
 =?utf-8?B?eUxPaGhPYTdIL1ZvQjJKOXk4b1d2MmV4ZEZKL2lLQVFWSDZEcXRpaWxMY0hq?=
 =?utf-8?B?eS9qNVFUSlA5OGhSdDdQQ3B0RTRSVlBiRW9GUDVzMWlEQ29CM0Nmdzk3M1ZV?=
 =?utf-8?B?bVBIQWFFbkZjT3k0cTYrZ01LR01ROWVhOGdrdkFFUEplM0oyMm5ka1Bpc2x3?=
 =?utf-8?B?SlJObEVSK0tOTWJMMG1aRWVPU2tFTEMrdTZaSkZHUkk1UlNFaFNFU1ZBSEVY?=
 =?utf-8?B?S01lVmUrUmIwRmpIOFJrU2JnUDRhVkIxOGZFYzFnMSs1NmVQMUpoSlZFRDlj?=
 =?utf-8?B?b2JvbE5mWUFpaHN4c29yYkZQN2V2SFN3TCtSdE1RbmJkSjhmUmZtdmtXWFEz?=
 =?utf-8?B?Sm5oYWhPZTZXbnFoZlYwaWI1VjRycnZEWkpOL0NMQlExSlBDdTkwaHFKNzZs?=
 =?utf-8?B?a1NqRmtUT0NmYTUwZWZyOGNSUmtlRVZXZExxWXYyZkpZYkI2WCtpVDJKd3ZL?=
 =?utf-8?B?eXhlZDRyWXRwNXFVRU51TGdwbi9rSklJZ0ZYZ3pNQTdGMkp6VS8zUmN5T3BG?=
 =?utf-8?B?NFBjdGdnK1FrMGFOTXdlY004Y2xhRTFXYzdWdXh0cFhLK2haMGtOalZSakhG?=
 =?utf-8?B?SzA2Wnp5R1p4Y29WSFI5S1NmY3VRQmViTDRCMXdqVENKWFhSZWdXamtrYmw4?=
 =?utf-8?B?elpYb0hTVzRMMkdhVmxrcmMzdEU5VEtwYTh2WUxFRVZVTnh6QzBYYlRINTdP?=
 =?utf-8?B?WmFnQ0hicWlMZHZ2SnJTY3U1RzJCenlEYnFnUVM1SXRCWkFIUDh6RE8vYk1v?=
 =?utf-8?B?K25lYTZQemlzZmVVc0s2bjFPRis4dUpBcjhmU0tYOTJab2hRNUF5dXFhcWM4?=
 =?utf-8?B?M29DZ2Z1VGJ3MEQvc0FDS2NZdUZ0NmN3UGFDRlNIS21TV0Rkc0ZIdVpmNmJD?=
 =?utf-8?B?OTYyN3VtOXZtNWJPNEtCdG5qNklLRjJWTlkveFhneTE1TkMvbDJhcHF6ODZn?=
 =?utf-8?B?MWtWUGpqMjRqbk1iMHFvdnBmdUZvUXpMd092MHFXeXA4QXVXYXVCeHhFd2hX?=
 =?utf-8?B?RDgwR2o0bDkvZEVnZGFZeXhWNVhGSmlBOG9ha1A2TWRuQmtoKzhwYzhlV0JH?=
 =?utf-8?B?MTR3WDhyM3BydzNIRGxNMVNxQ1YrZzF1L0xjb3czTENEc0U3cVpUSm1TNDMw?=
 =?utf-8?B?RkFzSU91YUJLOGxOUGdHMU1KZE5rdnQ5RUFKYXRBNUpwaE9na1I5T1NRWU05?=
 =?utf-8?B?RWxyM1NibDVkOGFWeEtoTk1KWkkxWU1rYzZnRnhpSEJONm1xZUorekhmcUl3?=
 =?utf-8?B?d2pNemxiSmdJVVNtdEdQclUweVNPOEIvYlpwaGN3OU5CL2UvcWVTK3BKM21L?=
 =?utf-8?B?QzVLcG1neUtTdHBkWm5NMUVyWUYxNm5TUjhRd2Y3TGJnWm4vOU9jVCtEMVFk?=
 =?utf-8?B?ZkxKWnFGbzRXM2xFRHRwY2Noa3RLcVFDeFh0eFVJZE02YW9IR2tNcE5aa2R5?=
 =?utf-8?B?bnZYcVhxeW5yYzBzUjZkVGJSUjJjQnhLTTVWRW12d0RzTGRzTGVDL3lvRnRl?=
 =?utf-8?B?a2RiWkxRTWtlZG5DQytiYmcyTzVOQ2J1YSthZzh3QkNPUmRhYUVJNTlLZkxW?=
 =?utf-8?B?M214QmZuR3k5dklnNU1ReTl5S3B2USt4b0lMVWc0MzQ4TWd5cnNHV1FKMjVM?=
 =?utf-8?Q?IyIYxK4YHfIsynbw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028f22fe-6ae7-4a98-83b4-08da27e5bbcd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 00:34:47.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gzgYmRV0A75LcLc36TsiQC4TfSKHoisRrOJC95mtJsQuXL4AWH+SZHRW7uu8Ngt+vuiYynJ+UVO8Ma9WwOVlQgPk9ggntc6JzJ/PIQMZo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3305
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_06:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270001
X-Proofpoint-ORIG-GUID: zbF7IrubzioXdCQNH617slbX1RCsiQzO
X-Proofpoint-GUID: zbF7IrubzioXdCQNH617slbX1RCsiQzO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_attri_remove_iter is not used anymore, so remove it and all the
> infrastructure it uses and is needed to drive it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 210 ++++---------------------------------
> --
>  1 file changed, 18 insertions(+), 192 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ccc72c0c3cf5..34c31077b08f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1340,6 +1340,24 @@ xfs_attr_node_try_addname(
>  	return error;
>  }
>  
> +static int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	int			retval;
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
> +
> +	return retval;
> +}
>  
>  static int
>  xfs_attr_node_remove_attr(
> @@ -1382,198 +1400,6 @@ xfs_attr_node_remove_attr(
>  	return retval;
>  }
>  
> -/*
> - * Shrink an attribute from leaf to shortform
> - */
> -STATIC int
> -xfs_attr_node_shrink(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     *state)
> -{
> -	struct xfs_inode	*dp = args->dp;
> -	int			error, forkoff;
> -	struct xfs_buf		*bp;
> -
> -	/*
> -	 * Have to get rid of the copy of this dabuf in the state.
> -	 */
> -	ASSERT(state->path.active == 1);
> -	ASSERT(state->path.blk[0].bp);
> -	state->path.blk[0].bp = NULL;
> -
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
> -	if (error)
> -		return error;
> -
> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> -	if (forkoff) {
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
> -	} else
> -		xfs_trans_brelse(args->trans, bp);
> -
> -	return error;
> -}
> -
> -STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> -{
> -	struct xfs_da_state_blk	*blk;
> -	int			retval;
> -
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[state->path.active-1];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> -
> -	return retval;
> -}
> -
> -/*
> - * Remove the attribute specified in @args.
> - *
> - * This will involve walking down the Btree, and may involve joining
> - * leaf nodes and even joining intermediate nodes up to and
> including
> - * the root node (a special case of an intermediate node).
> - *
> - * This routine is meant to function as either an in-line or delayed
> operation,
> - * and may return -EAGAIN when the transaction needs to be
> rolled.  Calling
> - * functions will need to handle this, and call the function until a
> - * successful error code is returned.
> - */
> -int
> -xfs_attr_remove_iter(
> -	struct xfs_attr_item		*attr)
> -{
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_da_state		*state = attr-
> >xattri_da_state;
> -	int				retval, error = 0;
> -	struct xfs_inode		*dp = args->dp;
> -
> -	trace_xfs_attr_node_removename(args);
> -
> -	switch (attr->xattri_dela_state) {
> -	case XFS_DAS_UNINIT:
> -		if (!xfs_inode_hasattr(dp))
> -			return -ENOATTR;
> -
> -		/*
> -		 * Shortform or leaf formats don't require transaction
> rolls and
> -		 * thus state transitions. Call the right helper and
> return.
> -		 */
> -		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> -			return xfs_attr_sf_removename(args);
> -
> -		if (xfs_attr_is_leaf(dp))
> -			return xfs_attr_leaf_removename(args);
> -
> -		/*
> -		 * Node format may require transaction rolls. Set up
> the
> -		 * state context and fall into the state machine.
> -		 */
> -		if (!attr->xattri_da_state) {
> -			error = xfs_attr_node_removename_setup(attr);
> -			if (error)
> -				return error;
> -			state = attr->xattri_da_state;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RMTBLK:
> -		attr->xattri_dela_state = XFS_DAS_RMTBLK;
> -
> -		/*
> -		 * If there is an out-of-line value, de-allocate the
> blocks.
> -		 * This is done before we remove the attribute so that
> we don't
> -		 * overflow the maximum size of a transaction and/or
> hit a
> -		 * deadlock.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			/*
> -			 * May return -EAGAIN. Roll and repeat until
> all remote
> -			 * blocks are removed.
> -			 */
> -			error = xfs_attr_rmtval_remove(attr);
> -			if (error == -EAGAIN) {
> -				trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args-
> >dp);
> -				return error;
> -			} else if (error) {
> -				goto out;
> -			}
> -
> -			/*
> -			 * Refill the state structure with buffers (the
> prior
> -			 * calls released our buffers) and close out
> this
> -			 * transaction before proceeding.
> -			 */
> -			ASSERT(args->rmtblkno == 0);
> -			error = xfs_attr_refillstate(state);

I think you can remove xfs_attr_refillstate too.  I'm getting some
compiler gripes about that being declared but not used, and I'm pretty
sure this was the last call to it, so probably it can go too.  Other
than that this patch looks ok.

Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> -			if (error)
> -				goto out;
> -
> -			attr->xattri_dela_state = XFS_DAS_RM_NAME;
> -			trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args-
> >dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RM_NAME:
> -		/*
> -		 * If we came here fresh from a transaction roll,
> reattach all
> -		 * the buffers to the current transaction.
> -		 */
> -		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
> -			error = xfs_attr_refillstate(state);
> -			if (error)
> -				goto out;
> -		}
> -
> -		retval = xfs_attr_node_removename(args, state);
> -
> -		/*
> -		 * Check to see if the tree needs to be collapsed. If
> so, roll
> -		 * the transacton and fall into the shrink state.
> -		 */
> -		if (retval && (state->path.active > 1)) {
> -			error = xfs_da3_join(state);
> -			if (error)
> -				goto out;
> -
> -			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
> -			trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args-
> >dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RM_SHRINK:
> -		/*
> -		 * If the result is small enough, push it all into the
> inode.
> -		 * This is our final state so it's safe to return a
> dirty
> -		 * transaction.
> -		 */
> -		if (xfs_attr_is_leaf(dp))
> -			error = xfs_attr_node_shrink(args, state);
> -		ASSERT(error != -EAGAIN);
> -		break;
> -	default:
> -		ASSERT(0);
> -		error = -EINVAL;
> -		goto out;
> -	}
> -out:
> -	if (state)
> -		xfs_da_state_free(state);
> -	return error;
> -}
> -
>  /*
>   * Fill in the disk block numbers in the state structure for the
> buffers
>   * that are attached to the state structure.

