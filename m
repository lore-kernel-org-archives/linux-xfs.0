Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FADEB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jun 2023 12:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjF2M1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jun 2023 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjF2M06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 08:26:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AAF3C0A
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 05:26:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35TAoRKA003668;
        Thu, 29 Jun 2023 12:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=BhvfX0SyQnZ4YV7cf9+zNJsGwkfZlSjzN3xolYZgPNw=;
 b=RKrJLDsdV04vSDHzdPP8h3W62edblDWK9j8pexDmwmXuNMWXTxQ52kenpTIaaF0XDFWk
 YMSmG+EB1tW1yiAXUz5mpHevvTD0AFniDXHrt3XYF+wlg+C/f9/hb0DejFepIwHN0Zi+
 4FUx3ryWc+htFiiGdPu525xSk7CBrBjfjQIz22gATFzzWhpNq1K4usErUM6z+m79hDWp
 9dHndcr/LXOF53Q9fPhrhBWuG2JPdH105pXpRXwkQbLjjiTfGF979mjHlCB3NFtYPdmE
 M4cnTNnL1niEsQFRu1dIWx9Azo5k8Rks4SEoL6k0GJJUpg0p8l/8FXX0/W78WQy6xNLP Mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rf40ea87q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:26:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35TAwNeY004026;
        Thu, 29 Jun 2023 12:26:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpxdbfjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 12:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWVZza32wj3JcsKdwDxdmcJ3BarEUqEubq4ej10afOSJe+/ZZML8o1x/ii8NfvkfL2LEUDSNb1aYuCA7maNzFCk0k4JbhH2aMTlWZ6MqjFhQHR/F+N6PXxJu30sunwXR+m/0ArkLcboOfV1hrD51x7fk4svC0lceTQFpKGyPTO7T41uwYtQXwkABZCTRWhp0jDHiV86+Y2tjcoARblOjuF8yJ1sUCcILIfhYMU41VYKZjCNH7V2sf3GL1x1bVbzlxuTUXrNLhNhuwRvdW4wfXyJmQYac8iFzeNd2aA85GQncpvpRmq+gXJCIqZcDkN2vs/vSNMLQ3FoVdRGl92jQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhvfX0SyQnZ4YV7cf9+zNJsGwkfZlSjzN3xolYZgPNw=;
 b=bvY45XxwZMrjh0JNU7CBtUqXi6uf8WuVrsEcVcWljkgb6ImWfVlGHol6Wbf/wAbeBD3/QC7rewp1IFocQ78t4XDQc7jG0YZHZ7tw+KgmZVFkh4xXNDhNujsiKpk0ZfL+G5fJiBy6P/veam1lgR/ZTW6Q/ClxvJUeX9aJC17LnHEahoS0XyIRK4aoC7Ca+XzeGEZtt+CvNjj6J/cEgTapA3HvHh6St8gDBYHwVMEsdVRMJyUiJfKVkQv3VAoLp1QYzRlw2kL/BwUFK3XBG4eP3pztkNyc/0jiy2cgQm0jcXy+ckrB2XFSdjCAXewAIUOQs08r8f9q2sTxntKYDl7+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhvfX0SyQnZ4YV7cf9+zNJsGwkfZlSjzN3xolYZgPNw=;
 b=sy7GAFe2RLiV1coF/QE+i8Lb3Yl24g3JBlV4prLpCDQSMM+BndzpF8wTZ5/urkA9zLCOIGnrCFEURyAj5zNWQaRINqPs4v23uE4A2AqUDLg1dF30M2DpZD298sAyWe9vR+Hhji3GLWd62GzwUBUKzNRK1FI6LAPw+g7woeD0Xz0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB7717.namprd10.prod.outlook.com (2603:10b6:510:308::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 12:26:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6521.024; Thu, 29 Jun 2023
 12:26:36 +0000
References: <20230627224412.2242198-1-david@fromorbit.com>
 <20230627224412.2242198-5-david@fromorbit.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: allow extent free intents to be retried
Date:   Thu, 29 Jun 2023 15:20:23 +0530
In-reply-to: <20230627224412.2242198-5-david@fromorbit.com>
Message-ID: <871qhu1mkr.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0294.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c8::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB7717:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aaa253b-2c8e-4fc7-5799-08db789c14bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TP1VJxXJxElcH/GnIsnAuB+DihbhEiolsXb4DZLkSWv8mNj/dj5Vd3vJ0dvnOs7dc/TtdGriSogPmh+5bIcZ25M/rdgLD2MfzfJmc27Bq2AOUaxnJ5ZsHBBvL25/q2zMx1aChGNmH3bN6m90XLOaNygHIdeY482J1X0BOr30dgT3EQFD33UYHTy25h/teLXUKKCoz8CSbYrP214JqWG3NDXDdMxLddjtO8ODyiG6KaMbCzYwVr1Xbfaz12TCc8uNUxi8cUZ+c1MhRwjpNXl38FQylso0ZSQoO+Y5eR8+YSElGi3igYg+0LHNaZmkvrBlZb0mKrSo5CxZxAtMbgT+KRewnMMrJ+AfW8lUPe7m+Kcz4KteHoMeYQoWOV2tE+fnpa2GT/v5RdHFuLIG5lB0kyIo2EQCUPG9wrpsIaAt21TtqqcazC3MpJ+kSp6MrYokgSd+cxV0XsDurSi5DiXeRbCXJ2eI5gOecTGWAUdHl0nkroEIDVBUl5TAefJuAMATNdU/Y7ZGzrF5SfgsdgvOTT1q62t9HX+ZUbutkZ73hlbvXOuhcUJvfMMPlAAZ6rkl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199021)(9686003)(26005)(186003)(6512007)(53546011)(6506007)(83380400001)(6486002)(33716001)(5660300002)(8676002)(6666004)(38100700002)(8936002)(86362001)(478600001)(2906002)(316002)(41300700001)(66946007)(4326008)(6916009)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rP8RdZnVmrsDOq+WuSOK2KEPkWCvAj565h/48js8e9N7P1/goswWo/hXBu+A?=
 =?us-ascii?Q?QwYSX3m2hylF0QKC8CMJxkHlCMCSAnaRURzoZjOxx6VGvLPAED3ctasWF3T/?=
 =?us-ascii?Q?aQet4bIgFQHLTbmPkoSp7Jr7Oi+FOrchReCQX2GAKzS9hh9cP8wiSDl/0Oc1?=
 =?us-ascii?Q?unzCLhBTEFxepyVqelbGNmaCAY7MNQCFAhMDMD2esORVn/lAqayes1c709Cn?=
 =?us-ascii?Q?UVtfOPcozNkfg64xx02NiVf6X5Znab2gR5CJNdTMZgkCy3StD2ndEZvpbYfW?=
 =?us-ascii?Q?Wq80miv9IUPsNqlyQ7FrezXRW8nU3BACAAn6ZrWA6SMSwISL3VOHO5FpfgfR?=
 =?us-ascii?Q?D3SPOc+1vhJ/zUF5zPK+maNdv5/MJ0QDondiiCZb8n2IubGim+BXfUOoqMMe?=
 =?us-ascii?Q?2pzLGmxLpzli8hLHvE0+bMdu/R0taAFtUssSgyH7CMdN8NP8D2zDu2ctFu6E?=
 =?us-ascii?Q?/QXcIpnuXkD5XcO95gOyJsVvGibt1t2YSNOqgSu/CoPH7QIhCYv4lAj8l/vP?=
 =?us-ascii?Q?EXdkdGGEqOdL0CLSmXU6I9G5CEZv7n7vzxMoCTYV+sAMODbk9s2g4iaHHSu7?=
 =?us-ascii?Q?CuUGUFWTGqIZZpPIHwlrjvjTdVk2QPKwYstCNdHotMwVJ1mV3Vn7QqiCdAKE?=
 =?us-ascii?Q?7+OEOSyOxf5Z3m6gSTFLRohUzcpy6YcJjnDM2qVlS5zihRRSYWBRgaAfP2/z?=
 =?us-ascii?Q?yZifmDH5rzcETVii3ZHgD7gqooXET7+TaohJGXJRum647c4rG2So20xRPz0H?=
 =?us-ascii?Q?Qm8ySSE19SstWXYFZUv4uOHlnlo7dv1OB2GeOOYGttSHSB5GdBIY15/6izqk?=
 =?us-ascii?Q?urZ+7xGFjTeoIF0BEcYBCHyJpLkd+vDOShtoimaVW7wbcpWaqZp3YSaZTl3F?=
 =?us-ascii?Q?YJ3G1LnJTbcZRq6wdCDTCXsZe/xxpDNPca7294MAbnBo4A4Ohgee6IymLuO8?=
 =?us-ascii?Q?zY9oPqoEfZRIPtpqcfDmOMgEDUZu0Jjp4PgTi8IgCRWNCdxM7jEnB3r3Ddb/?=
 =?us-ascii?Q?hc2cI5nFbDS/k5ASRHwnPYSazNuPu9nprJwphie4c/bgTi8iDaz3Z8W4gcar?=
 =?us-ascii?Q?FVJjYkMlMteG58K2EWJIvRP+J/BxATByfvbomuHmpkocIFQ9BYTDjmimYOYg?=
 =?us-ascii?Q?T6g5b+tydTIAitTzuAXGwmV+/dOhkl+bvxXP0wxdzS4rZW4tlG1Hd43ai9+i?=
 =?us-ascii?Q?DfhNlM3aIq1ShjcRNc3OtuvCw4MN0T3yU7tn7+8MsKnrwQ5lUUjyCF/6H298?=
 =?us-ascii?Q?1z8axx4UyO2DlaxkhJhxJql42SdMjxLnQhQbCO1GaYzBy/RDqmyRYbXvRhVp?=
 =?us-ascii?Q?JyaeIRUKn3vRhY0pD+xzg9AutE41rrTQShrLopo5ywLwoy8Ozrf64aCyON2D?=
 =?us-ascii?Q?ZkouPBKOiIhav/5Wyz9wL7LBLu42pcYBVydHpcjR210zgup43ins8BHYc/iL?=
 =?us-ascii?Q?vB8VwHt9Bqx9PRNsokyRubfqhvQoqkHu+UYJYnc5fwNUyvXsMrmsYq7Q0Rps?=
 =?us-ascii?Q?h9XgeKz4+Nxy1J/wjShGAhQfnR2s/DWiEksf3C9gdMEniB+YloM1vLpbRSuN?=
 =?us-ascii?Q?m1mxnv8qcV+5SoYwptwmjaCCfMsXjsaN4Wb+WZRN?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kJYOrVTiktc5hx9jCup/S5JyMd77y2mvBGG9u1BnTsnXK80dw1kP30PVBuArmZIGvJzRoLMocrYLPApqWXEhdvsaxS7/EXXRgrD4IypE9q1WJ517w4YEuB45CqSJ9a7gFKfvC/xFA9U4hryeDhDM8kCHQ8QAJ5i9auqTd6JgKF7gShP7L/VUhoHAqKJf85kO4QfvipB8a1NQZ6fHfAvuo8tlg4e97PkYRl9KhDezpgBW6/7rDvM5Z4dq0CzBmR4zH2QO0LJSa39jtNaCQeZC+QUCQHJEgIMdztsim22AYJJkcjZjmauxdOp2BIn51c/ZrJeqWTxzhD18i7cUU6I3uaCmS2Y/Mzt40Q2WFCyUEqojb9AUxwrGGyTm1TWBadR9yqbwIm106pD8/z3p4erBr+tSnS6qEMP5JADY+k99ZWZ6dMKmdqEFafRfwG1GY9xcxB+C/kLz4+d/32bpuB0Ml6DfsfBZKkD9+ZLAdhVdeGpvhqlRYRzG6uoXMnYuHXJgSWb1fNk/sIGVpX+oK3cb+BLKWNWQ0VepojFY9V1z3V4naoVmW7PBk5PvFDz6F0CaiuaHlC2dJ+sZB/ZEXxFurO8v6LpNdbEKziCa70DFqOydO4JGFqOhawxlMuqpBmeAIEcviV5ns5alg2fiiZ3U7wL/dzvP13MSyFNqiVLZJ5FM1XFwAk50ZIYPDiqNiaQFjnbiteIAQByKVTvFAN8E4NH9G1KRam4C6r5z4EsHCYm8x/u2R/APQ95MpfcRu515ed3/ygMwv7t0CWqnIFnXyQuZFDkdij8v0bQHQ/TcE/I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aaa253b-2c8e-4fc7-5799-08db789c14bf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 12:26:36.3330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPV/PBnXb0/kjiOe4cxpx1+NEUbFOO9g0ZTi1kHh6nkT1jbV4vnx+iaFJPqn15o1RpFcRxbtwR+kFQ9ocN2O8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-29_03,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306290111
X-Proofpoint-GUID: H2wDpGh_E1A5yRgn01cyFCPpCQL50Uew
X-Proofpoint-ORIG-GUID: H2wDpGh_E1A5yRgn01cyFCPpCQL50Uew
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 28, 2023 at 08:44:08 AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Extent freeing neeeds to be able to avoid a busy extent deadlock
> when the transaction itself holds the only busy extents in the
> allocation group. This may occur if we have an EFI that contains
> multiple extents to be freed, and the freeing the second intent
> requires the space the first extent free released to expand the
> AGFL. If we block on the busy extent at this point, we deadlock.
>
> We hold a dirty transaction that contains a entire atomic extent
> free operations within it, so if we can abort the extent free
> operation and commit the progress that we've made, the busy extent
> can be resolved by a log force. Hence we can restart the aborted
> extent free with a new transaction and continue to make
> progress without risking deadlocks.
>
> To enable this, we need the EFI processing code to be able to handle
> an -EAGAIN error to tell it to commit the current transaction and
> retry again. This mechanism is already built into the defer ops
> processing (used bythe refcount btree modification intents), so
> there's relatively little handling we need to add to the EFI code to
> enable this.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_extfree_item.c | 73 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 70 insertions(+), 3 deletions(-)
>
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 79e65bb6b0a2..098420cbd4a0 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,34 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI when we need to roll the
> + * transaction and continue with a new EFI.
> + *
> + * This simply copies all the extents in the EFI to the EFD rather than make
> + * assumptions about which extents in the EFI have already been processed. We
> + * currently keep the xefi list in the same order as the EFI extent list, but
> + * that may not always be the case. Copying everything avoids leaving a landmine
> + * were we fail to cancel all the extents in an EFI if the xefi list is
> + * processed in a different order to the extents in the EFI.
> + */
> +static void
> +xfs_efd_from_efi(
> +	struct xfs_efd_log_item	*efdp)
> +{
> +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> +	uint                    i;
> +
> +	ASSERT(efip->efi_format.efi_nextents > 0);
> +	ASSERT(efdp->efd_next_extent < efip->efi_format.efi_nextents);
> +
> +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> +	       efdp->efd_format.efd_extents[i] =
> +		       efip->efi_format.efi_extents[i];
> +	}
> +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> +}
> +
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> @@ -378,6 +406,17 @@ xfs_trans_free_extent(
>  	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
>  	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
>  
> +	/*
> +	 * If we need a new transaction to make progress, the caller will log a
> +	 * new EFI with the current contents. It will also log an EFD to cancel
> +	 * the existing EFI, and so we need to copy all the unprocessed extents
> +	 * in this EFI to the EFD so this works correctly.
> +	 */
> +	if (error == -EAGAIN) {
> +		xfs_efd_from_efi(efdp);
> +		return error;
> +	}
> +
>  	next_extent = efdp->efd_next_extent;
>  	ASSERT(next_extent < efdp->efd_format.efd_nextents);
>  	extp = &(efdp->efd_format.efd_extents[next_extent]);
> @@ -495,6 +534,13 @@ xfs_extent_free_finish_item(
>  
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
>  
> +	/*
> +	 * Don't free the XEFI if we need a new transaction to complete
> +	 * processing of it.
> +	 */
> +	if (error == -EAGAIN)
> +		return error;
> +
>  	xfs_extent_free_put_group(xefi);
>  	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
> @@ -620,6 +666,7 @@ xfs_efi_item_recover(
>  	struct xfs_trans		*tp;
>  	int				i;
>  	int				error = 0;
> +	bool				requeue_only = false;
>  
>  	/*
>  	 * First check the validity of the extents described by the
> @@ -653,9 +700,29 @@ xfs_efi_item_recover(
>  		fake.xefi_startblock = extp->ext_start;
>  		fake.xefi_blockcount = extp->ext_len;
>  
> -		xfs_extent_free_get_group(mp, &fake);
> -		error = xfs_trans_free_extent(tp, efdp, &fake);
> -		xfs_extent_free_put_group(&fake);
> +		if (!requeue_only) {
> +			xfs_extent_free_get_group(mp, &fake);
> +			error = xfs_trans_free_extent(tp, efdp, &fake);
> +			xfs_extent_free_put_group(&fake);
> +		}
> +
> +		/*
> +		 * If we can't free the extent without potentially deadlocking,
> +		 * requeue the rest of the extents to a new so that they get
> +		 * run again later with a new transaction context.
> +		 */
> +		if (error == -EAGAIN || requeue_only) {
> +			error = xfs_free_extent_later(tp, fake.xefi_startblock,
> +					fake.xefi_blockcount,
> +					&XFS_RMAP_OINFO_ANY_OWNER,
> +					fake.xefi_type);
> +			if (!error) {
> +				requeue_only = true;
> +				error = 0;
> +				continue;
> +			}
> +		};
> +
>  		if (error == -EFSCORRUPTED)
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					extp, sizeof(*extp));


-- 
chandan
