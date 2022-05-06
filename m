Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D30C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445022AbiEFXsS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 19:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445018AbiEFXsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 19:48:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74861712D4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 16:44:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246Iex9v026258;
        Fri, 6 May 2022 23:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+ykJ+U7F7yM8o2hueyQ2/xF8U7oYEGriGOA02DX/swo=;
 b=Rv9lnM2NZIJpGTCDXIkNJbV8ZKJZvCvgQvusgUcF6eW8rr0ctO6S20ST12iOW+JWlscl
 LwwSojn0hjyGvuzRrqYLrpSrvbyK3pFDUgp8v6s40FHD81T8bhpqW/kYh21alnUehc89
 yPAdBWbJKHaiIihrXXQ40/t9c3r+QNxQEdSPq7hV246a0cUfQ2vyVVf6ZQvmXspvZQGP
 bE466XVwDfmOuIzOK3BOq+c1vwXIzOzM6dVm4pFZ3ikuk/CjpWkY5bqVuwxP1VJPH6ku
 1Ekhfdv8e9hfwd1+fHr5TRz2hDV8Pf9ulO053wR40x7Sgr7nUI6Ya0Oo4ls5uVDcw280 FA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhceyye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 246NZWoF029514;
        Fri, 6 May 2022 23:44:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fs1a8uv1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 May 2022 23:44:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UawhwCDaRM1LOWRYF1ESi2M9kBeBrJTm4x2EIvaWhjxd1SypFoYWlOCeVOMlON6vPBE1Yk68aWa6MiIoYUeIphq0YHFNUNKVpHU9N/ubmeJekHQarXlEerODQ39UmlY25WOqxVswbPUuxE6HvSGQtZsNhkqjERdoN6Htu6b+U6XFJOjQ8FMHxT4HMwE8IF5r94mXZuEEtEm+aKJLAJI8q8ioAlMlnAZJCAi90DiGxFs3Uf4Lbb6hTmj7k3dL+G1O++rjAkqRkgtz9vF9mwBluwufVLCmyJcPh31356W16ohGJ9/B6ItF+buRs1fFPJOGUtBsW4I/2WzK7DpasKUrBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ykJ+U7F7yM8o2hueyQ2/xF8U7oYEGriGOA02DX/swo=;
 b=jCTpSF3sh6Js8pXhdmxRszxSqKhyimlpfQ8oQmJFbV2eBFtM7WjeacQ7e/Jzx34MdX3dIdb7jqSPkMCuBSp4oCnUniuT5Kt6/QYCUPfGU0gerOfkTdpiDRBxz3wUJVhHaAeTCqNrJ+jM32V3ZR09N9Md17eZ9VjZTgh4uHITu0TMh3sw8TB5g5x0hFkYNstnjaO81FyGtzyfS3e8cIDcdaQOwKaN+zp/GV/49HkGpMqbRHRd+WcHaC8V0FcnaTz0DAIDV6gggw2xU7A53xF3BZQEbJ6UNWHx+ufbxjvfpUecfjrujkNPfWe85+njyv/yAIE0Xzu81jMZkiYCC5NCMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ykJ+U7F7yM8o2hueyQ2/xF8U7oYEGriGOA02DX/swo=;
 b=jqV5ae5kryVK12OKOq3xgg8NumFavJPEBFIJlnyxJv294wbdjYMUB+gws59P6ZlglnouMRuGBv1wYxjSDdZoT5d5GamgXAKj6DS2ZEPHLN/qC2rywq9KL9+UyCu3pbNYQcApqbj363Wj0E+pronMzCLhZgT8tndYXWsNY+O6MHw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3761.namprd10.prod.outlook.com (2603:10b6:a03:1ff::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 23:44:29 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 23:44:29 +0000
Message-ID: <e52b09ab51a5bc9c4d27306fc2068eb1d3abaf58.camel@oracle.com>
Subject: Re: [PATCH 14/17] xfs: switch attr remove to xfs_attri_set_iter
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 06 May 2022 16:44:28 -0700
In-Reply-To: <20220506094553.512973-15-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
         <20220506094553.512973-15-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::35) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80075fb1-1581-43e2-f94f-08da2fba5c90
X-MS-TrafficTypeDiagnostic: BY5PR10MB3761:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3761DF5B2764BFBCEF7CFC1F95C59@BY5PR10MB3761.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcPu5UVAx1NNn7NwSFOzBHaPmcY1TzPKccSWBrjRhcpPI8hTmR130sma1adzWFPuO1NTLWGgjouQLZfKs/Eiwz0a4lsLDALmG0aGMqzGbeLlDio1784/8+nW0TlPNEWZ6Jzjf15PsKB3j9vF1q18ZzDprrgcFAzf/RnfWhaygDuQhURnu3XgWzeK4craB18FrXSrl1GaSizSc9TyHRtF85aHOweHT2BDGoxlHF3/AvMQfU57QOvKP5Hzj4VhIcFRBQrul0+hEHuED0SLHJzmaNZ1jzRyckPTLOfRpLgeCA3G8106tJKKQQkC/cbdxe+X8k5onarMG3te5RUf6VgprxMsS3JPa905qX2AvhmqLBCx2KkbB5zKPsCDna3dflw0sE8FidrJvveTGZsRxej/scpX52RZTsqDKYNPo7taPlKBi/lLrlkVAlQnotD2MBMCl/zt0DB2gIjyzga3GIhdF+YXgON0A1mdeWqHUkWZEnIxRV3yT34vJM8ayUHL3O2s/fh7sWKabp2ghxxxkPdtw6d4HHqykmf64EzL+csct292gUuQ7H+R9pgzMWoPaKpZoXBfhsHWXMA9NIcmTkvXfoGseYqsXgD7HL6kpa+prMMjAFUqIUwryjNwPF1rhBnhlNZSNz0dcASejBNSKyPlSQGLQeghalaUqwJF/3ibrxXxrfn6C/w5CYr86G8ztE0VURfK0DkC5u3e/A4ExZEXWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38350700002)(5660300002)(186003)(6486002)(38100700002)(8676002)(66556008)(66946007)(66476007)(2616005)(508600001)(2906002)(6512007)(6506007)(26005)(316002)(36756003)(86362001)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1RnaUZibVJnQW0zbnJmQXppZGhGUkhUaXZlTFN2Q1lOY3JVN1g3MFlqMVNs?=
 =?utf-8?B?RHV1eFF4MGlLeG84YldTdzA3ckJSL3c4enAyZ3RHQXVKTk1vejhkQ3RYQjBV?=
 =?utf-8?B?cHR2dHhrelZ3U1B1Z0FyRXVnNlY1M3VQb1owQWRNbExRcVltL1Jpc29SVTNx?=
 =?utf-8?B?MUlPcUwvS0hCTXpoeFR3YmFNNW1uQ1U5M1hxY21iOU9LYXlwcVZTQzZleSt2?=
 =?utf-8?B?UXo1N2NwOEF2dTFzNUhKRHJ3QjljR3VCa2tuSzI0cHVPdXppV2pBSjhjWlJ4?=
 =?utf-8?B?U0xObHVWOUQrSnJQdnhyS0JTM2prVysvQmJUNWxNQnNNaHpvaXBDcGVXcVFX?=
 =?utf-8?B?Lzh0M01NbktGYmlDcUppV3pPeE1nZS95SnFjRmY1ZXpzSWs4M25sQ1pySjRL?=
 =?utf-8?B?RkoxQnV1YTZHQjhVY1p0S0VWcVZaYlBHU3hCV0xjVnBsUjVqWlNUS2FEZFRR?=
 =?utf-8?B?WEVJZUhZOXhqQmZ4VGY3bXU0VDJpeGNTcUdSS1l6TnF5QnRRaXpicGcrR1c4?=
 =?utf-8?B?V3o0Y2szbU01QXhBeURSUFBvQms3WTljSjNmdFBIMmdsT1NYclMzakJHTk9I?=
 =?utf-8?B?WE1RV01ZOEJPbVFDNFJmdTh5N1NLTFpXVEFwcXU5VG03L0xYNVVjNWNtdDdH?=
 =?utf-8?B?bXdPMVRyUS9Ia0Q3V1dGb0t4VUFtOTZGVUd6d09mcUcwdk5lVW5zOUoyTGRU?=
 =?utf-8?B?ejlQUUFLQlRmVFYwQmx2TEtyMlJncDJDN1FGZTVjR05NOXJVRklKWURKNmY0?=
 =?utf-8?B?WCtRN0lTZmtPUlVIYW1BOGRkL3U5RDljU2Zjc0d2UnR6OExXWnRHV3kxMERy?=
 =?utf-8?B?ei9NVk9pQm1pK1E3b29haVc4WkJYV3lxMGRpSXpaeWFyekRtdGRncDAyWHh6?=
 =?utf-8?B?M2RUVzY4ZWl2N3VzaTF2YVpBM1VmZG5GU0l2aVNDSXlqaHN4TElXRTVxQmg5?=
 =?utf-8?B?aks4eDh0N0ZhSklCMGV6SDNUVS84SmhlZ0ROSjJUSk10Q3FPb3ZsWEM1Tzhp?=
 =?utf-8?B?bDJpS09LdEVGZUkrV3A3YkhuUDU3SlRETGFOdEJLU2JGeWp4YzJXWjBjS25P?=
 =?utf-8?B?aDBxSmRnVEJmQmFEbXNDUlhHa0pYRTA1ajVoYVdIN0VTa05wQmpyZW9XQ2Za?=
 =?utf-8?B?dWNySHk1SXNTZ1oxdURRdU52VHZhR1hvdmlxQjBVSmJuWmhPUlB5bFNEayt1?=
 =?utf-8?B?SUhyTmh4T1hsSzJrN0YxWC84UGxQVXFidW9BczNXY204WnRxSFV0cEx3d1Vx?=
 =?utf-8?B?U2tuMFpXSDJ0alJRSS9BVmQzNW5wZnAxZlQyTU9KSmFOYlcyNUZoVFpnK0JU?=
 =?utf-8?B?R0hJcmM0SkJDaXhRY1JUa2Zud3l2NWV4bGJzSHVYaVBGRlpibDMySjNJTXZx?=
 =?utf-8?B?L3QvWUNsQkZpbm9DZEpYM05SWDBvVDJvNE5VeGZiUG5rK0F0dThlcFNXR3p1?=
 =?utf-8?B?V0h0YlN4REFOQnJaSW1qVWtoeGswenJna1k0dlhRN3hvbWZVeC9ONmNhdVhQ?=
 =?utf-8?B?Znd5RmJNMlN2N0dIVlFDWDYrK2FIL29ZazhLem5hN2tGTW05ZEEwUnluQy94?=
 =?utf-8?B?VXJ1VWNZWTR1Q2pBVEpaa3VKV0NVRDZ5VEtENVJsQWdxK0JUakJ4SENVZmRY?=
 =?utf-8?B?blBWdDU1MzhtMTY0b2ZZT2duMHYyRURUeUM2amVVYjlHZ29FbzJ5WDg2U2lT?=
 =?utf-8?B?RlRnQ1pVbUdVTU51b1pBMlhUSFdLUUNGa1pjMUxHK3FKWVBKcnl4a0hWcHc0?=
 =?utf-8?B?K0VHNUZVdmJML2JiZzdOL2hsbGdQYndaR2dObTBqdldkS25LbUZ0cml1dXVt?=
 =?utf-8?B?OHRCUXgwM1JsalpFeStMY1ErTURKUHlheUY5N2d1ckJROHRZV20rY21UQk5L?=
 =?utf-8?B?U2ZjaXpISlNOZGZ0OWZ4aEtFT2s2VkFZb2FRaWZEOUE3djNZUTRLOUsrTEhU?=
 =?utf-8?B?T2orQythcVhoanptNFZ1bTA3NEgwWUFjYy8zWS9jQXkwSXhFWDcydHQyYkFz?=
 =?utf-8?B?cTNQYUZVaWlvVE1iWG5hTGI5dWVNTlM4MWw5QmNhOUdhak1WL0Z3U0ViWlFC?=
 =?utf-8?B?TkhLZ2czVTVXUTJhMnNNMSswQ0FzZDlrSWhwaTlzLzY0eTZqQjRIMi9XSkE0?=
 =?utf-8?B?ZVFXcllNbkVycGRXd295N0IwMFhhMjdQbTEzaWQyeEdrbnpNTEFYcTlSbUtT?=
 =?utf-8?B?TkdiaUdiMURqZnZabHBDcG91Mm1uMElFdmJ1UE0za083bDdFekpYa3NkK0w1?=
 =?utf-8?B?L3M0Wi9BVGNYcGJ0clNwTWZrRGFobDd1WVV0OXV6ZTl6NjJ5dlRpWXdCQmlJ?=
 =?utf-8?B?WUIvM3htalpBT1JVcnc5SGRaVTdockFlVmxZcytlRmV0c0crQUtyQlYvblZ5?=
 =?utf-8?Q?BsSg/aORjWCstQNs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80075fb1-1581-43e2-f94f-08da2fba5c90
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 23:44:29.0867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWtoAu+n/kit6i3ku31jeh2KVwvY/5PRvugp0wcFJBM1ivNw+fHR3tDi64OOxJTyQ+rc3X9p9U+wOjOGPZ2RWKtOqfVpKGH2zgSmcECGKf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3761
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-06_07:2022-05-05,2022-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205060118
X-Proofpoint-GUID: GNMOKOVuPxj6jxtiqsrtRAPUDVlhPWK6
X-Proofpoint-ORIG-GUID: GNMOKOVuPxj6jxtiqsrtRAPUDVlhPWK6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2022-05-06 at 19:45 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that xfs_attri_set_iter() has initial states for removing
> attributes, switch the pure attribute removal code over to using it.
> This requires attrs being removed to always be marked as INCOMPLETE
> before we start the removal due to the fact we look up the attr to
> remove again in xfs_attr_node_remove_attr().
> 
> Note: this drops the fillstate/refillstate optimisations from
> the remove path that avoid having to look up the path again after
> setting the incomplete flag and removeing remote attrs. Restoring
> that optimisation to this path is future Dave's problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Ok, I think this looks ok now
Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c | 21 +++++++++------------
>  fs/xfs/libxfs/xfs_attr.h | 10 ++++++++++
>  fs/xfs/xfs_attr_item.c   | 31 +++++++------------------------
>  3 files changed, 26 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7ec3c1e8ea16..e2067aead818 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -499,13 +499,11 @@ int xfs_attr_node_removename_setup(
>  	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
>  		XFS_ATTR_LEAF_MAGIC);
>  
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, *state);
> -		if (error)
> -			goto out;
> -
> +	error = xfs_attr_leaf_mark_incomplete(args, *state);
> +	if (error)
> +		goto out;
> +	if (args->rmtblkno > 0)
>  		error = xfs_attr_rmtval_invalidate(args);
> -	}
>  out:
>  	if (error)
>  		xfs_da_state_free(*state);
> @@ -778,7 +776,7 @@ xfs_attr_defer_remove(
>  	if (error)
>  		return error;
>  
> -	new->xattri_dela_state = XFS_DAS_UNINIT;
> +	new->xattri_dela_state = xfs_attr_init_remove_state(args);
>  	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new-
> >xattri_list);
>  	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
>  
> @@ -1348,16 +1346,15 @@ xfs_attr_node_remove_attr(
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
>  	struct xfs_da_state		*state = NULL;
> -	struct xfs_mount		*mp = args->dp->i_mount;
>  	int				retval = 0;
>  	int				error = 0;
>  
>  	/*
> -	 * Re-find the "old" attribute entry after any split ops. The
> INCOMPLETE
> -	 * flag means that we will find the "old" attr, not the "new"
> one.
> +	 * The attr we are removing has already been marked incomplete,
> so
> +	 * we need to set the filter appropriately to re-find the "old"
> +	 * attribute entry after any split ops.
>  	 */
> -	if (!xfs_has_larp(mp))
> -		args->attr_filter |= XFS_ATTR_INCOMPLETE;
> +	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>  	state = xfs_da_state_alloc(args);
>  	state->inleaf = 0;
>  	error = xfs_da3_node_lookup_int(state, &retval);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 7ea7c7fa31ac..6bef522533a4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -593,6 +593,16 @@ xfs_attr_init_add_state(struct xfs_da_args
> *args)
>  	return XFS_DAS_NODE_ADD;
>  }
>  
> +static inline enum xfs_delattr_state
> +xfs_attr_init_remove_state(struct xfs_da_args *args)
> +{
> +	if (xfs_attr_is_shortform(args->dp))
> +		return XFS_DAS_SF_REMOVE;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return XFS_DAS_LEAF_REMOVE;
> +	return XFS_DAS_NODE_REMOVE;
> +}
> +
>  static inline enum xfs_delattr_state
>  xfs_attr_init_replace_state(struct xfs_da_args *args)
>  {
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 740a55d07660..fb9549e7ea96 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -296,12 +296,9 @@ xfs_attrd_item_release(
>  STATIC int
>  xfs_xattri_finish_update(
>  	struct xfs_attr_item		*attr,
> -	struct xfs_attrd_log_item	*attrdp,
> -	uint32_t			op_flags)
> +	struct xfs_attrd_log_item	*attrdp)
>  {
>  	struct xfs_da_args		*args = attr->xattri_da_args;
> -	unsigned int			op = op_flags &
> -					     XFS_ATTR_OP_FLAGS_TYPE_MAS
> K;
>  	int				error;
>  
>  	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP))
> {
> @@ -309,22 +306,9 @@ xfs_xattri_finish_update(
>  		goto out;
>  	}
>  
> -	switch (op) {
> -	case XFS_ATTR_OP_FLAGS_SET:
> -	case XFS_ATTR_OP_FLAGS_REPLACE:
> -		error = xfs_attr_set_iter(attr);
> -		if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> -			error = -EAGAIN;
> -		break;
> -	case XFS_ATTR_OP_FLAGS_REMOVE:
> -		ASSERT(XFS_IFORK_Q(args->dp));
> -		error = xfs_attr_remove_iter(attr);
> -		break;
> -	default:
> -		error = -EFSCORRUPTED;
> -		break;
> -	}
> -
> +	error = xfs_attr_set_iter(attr);
> +	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
> +		error = -EAGAIN;
>  out:
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
> @@ -432,8 +416,7 @@ xfs_attr_finish_item(
>  	 */
>  	attr->xattri_da_args->trans = tp;
>  
> -	error = xfs_xattri_finish_update(attr, done_item,
> -					 attr->xattri_op_flags);
> +	error = xfs_xattri_finish_update(attr, done_item);
>  	if (error != -EAGAIN)
>  		kmem_free(attr);
>  
> @@ -581,7 +564,7 @@ xfs_attri_item_recover(
>  		attr->xattri_dela_state =
> xfs_attr_init_add_state(args);
>  		break;
>  	case XFS_ATTR_OP_FLAGS_REMOVE:
> -		attr->xattri_dela_state = XFS_DAS_UNINIT;
> +		attr->xattri_dela_state =
> xfs_attr_init_remove_state(args);
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -600,7 +583,7 @@ xfs_attri_item_recover(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	ret = xfs_xattri_finish_update(attr, done_item, attrp-
> >alfi_op_flags);
> +	ret = xfs_xattri_finish_update(attr, done_item);
>  	if (ret == -EAGAIN) {
>  		/* There's more work to do, so add it to this
> transaction */
>  		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
> >xattri_list);

