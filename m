Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E57C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 15:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiCOPPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 11:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiCOPPy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 11:15:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B4327CC2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 08:14:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FD51Gd007317;
        Tue, 15 Mar 2022 15:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MhM8z2N/CvFQ+W3BsiycevZxYOnst2JQhvs6b1xixrU=;
 b=FvJvanpMb3byH4okZHAySLYiV1jdrLWDzvjdsUagjJ0FEwZ7i93bBQjZM3R2po0v4b5e
 t4LnHP96zASuL+WKFxHlY8QgJmY9sKQ2NJMBOua7A0UolFTSzMW3abF+g+YzrUSaN5DG
 cOBd+CGPuuNgUOdnGOlU9iS4AXpLc66/aLssxaGQA8hYE5zYYtF5yE43rYH75htyLJ6W
 /nxQSy6m0rAFb9nxSYnXEGRc9gJAFD2+0szlYLEaX/kYfcAQs9+VIrmvf5pqjhBumalr
 ZTWkiJO8x0R2F4n1yDZyLAZ8/R1x8BAiQsydscCHne1piOzyo/lbMhWk7re2wV/m8pvj yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et52puhce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 15:14:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22FF60QQ008480;
        Tue, 15 Mar 2022 15:14:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 3et64k1gh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 15:14:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8dNehYQC3CPWN9TTNSmdc3gysGIRAHbn6fIFYGkzRWWAfRTRxKXauXjKk8aUZVHAgIUCu7j/1PhxL2e+aLWF7ogAxPnDVFB0juyc26D8zJTIvozJxFlHNWHBYxH2Cj20B7zxe/hEtEJEYOKHynQpvIAkmUP0UZlXNwXlKx6MSkM7mNVhqnPW4RoGM0Ne6nfhNb/o28T6OIqEkH4t2bz5kijmGC5XF5nW14mbY3wet7RiAP//Zq5Ef/INovqveCPJHBbVRODhqr1xn5wEbDZSJm930T1M31+xRmeNhBw5mNwl2xKXKf/SJkmMIf7hmpixhbbOLibb9P2Bw86hjjodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhM8z2N/CvFQ+W3BsiycevZxYOnst2JQhvs6b1xixrU=;
 b=cMstEetcnZtZc39IfKC924G0Ami96Qw8ETe1adwyLDP09X2jPQKTiHFe4rUaAeAcFBptnnudwRuYLCxr2u2O0f0Li69F7Jxg7lPLox4nOhBMCFox1OVfYwsuU3m/eqfV88G9Pbi9cr4RPYENSzqITZpZ4oJJhgNKG7y2s+ji+YWanjxZPx2nsMO5iS2sSfHEOgYR+3EdFJSGh5e55BhT7ocolf+Y+JmTC/GDGas0VG28Tb6rXiFBf2swRo8G9o9Mo/1Ssr8Xh1PJ23GKg3ZptpVjm10yeqjsZ7uY90ECnxaJWaw19Z2xe4yE4oHfS2UXgKIBMQ51Z5dmwyWRYva4LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhM8z2N/CvFQ+W3BsiycevZxYOnst2JQhvs6b1xixrU=;
 b=OAI3zDCo0L37XNhDWJ/SG0Y1M6gKEoOL9ughotcfJlF8CyNtjAwVmTcPAwIJmnH+9WIElW18IeHFB1boIlsGjz3kWxVKlxnhCliLU1RQuzXcyplPydUJBuxMlk7nmzWSAZAjqqmz/i9ujuN2bM7VVFp1d3liELxZrT2uOGwtHv8=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by BN8PR10MB3569.namprd10.prod.outlook.com (2603:10b6:408:bd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 15:14:36 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::f46d:8bb8:d2c5:cdde]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::f46d:8bb8:d2c5:cdde%6]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 15:14:36 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-4-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: xfs_ail_push_all_sync() stalls when racing
 with updates
In-reply-to: <20220315064241.3133751-4-david@fromorbit.com>
Message-ID: <8735jj459o.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Mar 2022 20:44:27 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0091.jpnprd01.prod.outlook.com
 (2603:1096:405:3::31) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57856679-ffb9-4ced-1a6b-08da06968417
X-MS-TrafficTypeDiagnostic: BN8PR10MB3569:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3569033875728973DE499731F6109@BN8PR10MB3569.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dap/JMi+IEIqg2D6jl5JqlUinCxHSEB5h9h4GqdMxM/6M63hxFeYrWAfZG2Nrj+FWCRBLA9A0/e6hNcd044fgBz0erWYxMJfQcb3/9jyGzyGSxcOaxHkbQf/CHFu6wQlaQ90vkBX/a66QU0D+exdvU8zWDFrL+63u3EYr5iCPcy1iMvowoC3VqBxoFfGkT8wnOKoQlI/GZrdr+ku81l23deF4NTfIZEXAsuctl9/4qsMAbbMMJ/+GQi0obDxBD2YOfGXAPhVWTv3sJAZ4Iob5uwtnrKfhDlWl1n2a56RcIBegwXlMTmw/ooB7DfWBkrHfJ+2X//vrUMEbpKl15cO+LDzgWDQnqQfX2mwJuUxwdYrDupBNINgh1LzJmsJZQJLUSkRa5wvmxz2vXODPLUSdiC0xXkruoeWekPw94QrYAFv4O5OoDyyv7xpbGWwy0/2Muh5JteVTiUcAAEsQcFeJMl0VALkSvGEE69lQFCDLpF8gQGCQ5ulU9/80ydbtUoHma+fEMzlFM5DfuSEbC0lbigqMX9a4Sziq9e4IpyscPBg3ropw+yavPRWwCRx0loc8Kp9zEnbZ6LHysi1LJKtQY0rGpbempPOOZyFm0rXIb0RfAHYEEiMcxpQemf7UYTBdYdrFSJr4kZScv7co+qn45UpRzj57tQyRS46xO/GeaLnef5bmBSJvMMtJ90jsgCEeuOcDSVCFxFDL5z0LxwrZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(15650500001)(6486002)(26005)(186003)(5660300002)(8936002)(6666004)(508600001)(52116002)(4326008)(53546011)(86362001)(6506007)(9686003)(316002)(6512007)(66556008)(66946007)(66476007)(33716001)(8676002)(6916009)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k5H1u47xYehodeMOFyGjfV3Bq8EkgFnXumgBpdVF47YGaGuQhcwY3R+Up0Fo?=
 =?us-ascii?Q?zSyeH50wsIYVWP/AUrqOBKdo29ozf5FcN280qvnrGGf/KkLxtp4KduFV/M6e?=
 =?us-ascii?Q?NgKfBdcWbRgO0AwI/PbWATkh/tYOBDrs+0Aiv4ULgKog2vD6QfPGKgYEJgnL?=
 =?us-ascii?Q?J/JjzYUtLaYuO9JH2oC228+4dvxMiJfb76a0B1kSferhw8rYIcXe/TIJIkY8?=
 =?us-ascii?Q?E+qPE3K2LQrNb0b6U1dm2bjXCFGjUtVWJ+nPkLkF03cIqdPb7GSxtC3scIH+?=
 =?us-ascii?Q?eMGMCxgKZukzAk0V5171NQ7vyz1wkfER+sN3WapT6WEOzaR8FkzQ0niaKX8l?=
 =?us-ascii?Q?DIFTLQg/ZHAQTgYkr3SiSe4v8froIYTu104Z40aN+6pUtSng9EH6EOABCKFE?=
 =?us-ascii?Q?ptXkVVf2l3zMitiLd4uxYSZlER7CeTp2uIVTMDT8jiqvLVF6y7cQ4cyMusb+?=
 =?us-ascii?Q?QH+n0iAdcBr2oSgypf8YbaP5BEedk5jo8E9ihuvKs33lRr/RHsVs7fIhzb9I?=
 =?us-ascii?Q?Th+CDguJO5Qc9oU/BGfqUGgXE0YwkAvjogXpB0QFBLt+TR+y2gxtrKw0vsho?=
 =?us-ascii?Q?Mr4j6yCA4kL/KBIZ0h3GHTXIGFMZKxzqhAiGrl1ZEMUBc1dJU/lsGkIAYjWk?=
 =?us-ascii?Q?fS0peN0e8sfWKmKPBckqM/67ABO4aBRG+6agxeFkD+6TLMzb7N8JFdDchmXt?=
 =?us-ascii?Q?TC7dA9mmkTVrQpbSIAkfib5e9aJw7rcZjnaWlqL5yYxu/ckIzXVMlfeTKnjY?=
 =?us-ascii?Q?elaJHCqiXeBARL95GyEItnIra6kcBuaPYBrgDlgjMp2xyJRe4YrJERBJuMgE?=
 =?us-ascii?Q?/HEBz+kVWSRMHmfJzDdn4yppv3ZkrmwLDEZzXqJjFcy+WbTUUn5rJdEVtcE+?=
 =?us-ascii?Q?76y5h+3PPlRlUD/LDbwFP0beUxpFwBQzaFEb2Q3XW2bgwYI93KLrQHO3RMyx?=
 =?us-ascii?Q?JA0E/fN0Vk1jIgyqqsDUcJrdqAL5yUiu5LzESZQdBhkieTy99bjrRvEYCFWF?=
 =?us-ascii?Q?zcIybgyBv7QwJWwC0B26YXdUdqvDocNQ7sRYSiZ+KFqbUTrSc6gsQ1xclxAm?=
 =?us-ascii?Q?c06FP0+E6CL9FhdHfIZaFxHszPOtASzIhsE33PwGzS+3ouFxJjkCfk18EwOr?=
 =?us-ascii?Q?diMurFw+rHWnqE1lD5a+kbOXeChKo2HcNpL1OE9YKKMBzE/+zLPfOLJ/y8E+?=
 =?us-ascii?Q?++QSnCy3ad5iryBwOGmqFuSgDUCL2V0xIuiMVgy144kxnEDxXCYtqLmm9W9A?=
 =?us-ascii?Q?J9Z6jb/yninR2tMGiJBDiN3RO4dey6Ey5avGAmsQ2CU2L7ZGR8Wk8/ZHfsqD?=
 =?us-ascii?Q?Lof1GBrJsNmQmuWrexaJWnMg96YHTLztIYngJvGZe+NPe+vz3It73RqnhEvc?=
 =?us-ascii?Q?JYrhDf464BkV2UrRaBXAvkRJ0dZroWv4Ta02CTjS6a4NC7xG9map8Jo1CfLt?=
 =?us-ascii?Q?snl1Y+d5LJnypBhnYnMgbgAjy8Dm4YJN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57856679-ffb9-4ced-1a6b-08da06968417
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 15:14:35.9668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sob9Fy67sjQRYx6HtytCVnx6YNeq5I7mSmCIF/ANytzEFicq5t4TqfEVys6AQ4Lp9Yyzzy88ielfCKlcfZSVRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3569
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10287 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150099
X-Proofpoint-GUID: co43l7n7hBAjvcbn16JQ11GWcLXFStRc
X-Proofpoint-ORIG-GUID: co43l7n7hBAjvcbn16JQ11GWcLXFStRc
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Mar 2022 at 12:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> xfs_ail_push_all_sync() has a loop like this:
>
> while max_ail_lsn {
> 	prepare_to_wait(ail_empty)
> 	target = max_ail_lsn
> 	wake_up(ail_task);
> 	schedule()
> }
>
> Which is designed to sleep until the AIL is emptied. When
> xfs_ail_finish_update() moves the tail of the log, it does:

... xfs_ail_update_finish() ...

>
> 	if (list_empty(&ailp->ail_head))
> 		wake_up_all(&ailp->ail_empty);
>
> So it will only wake up the sync push waiter when the AIL goes
> empty. If, by the time the push waiter has woken, the AIL has more
> in it, it will reset the target, wake the push task and go back to
> sleep.
>
> The problem here is that if the AIL is having items added to it
> when xfs_ail_push_all_sync() is called, then they may get inserted
> into the AIL at a LSN higher than the target LSN. At this point,
> xfsaild_push() will see that the target is X, the item LSNs are
> (X+N) and skip over them, hence never pushing the out.
>
> The result of this the AIL will not get emptied by the AIL push
> thread, hence xfs_ail_finish_update() will never see the AIL being
> empty even if it moves the tail. Hence xfs_ail_push_all_sync() never
> gets woken and hence cannot update the push target to capture the
> items beyond the current target on the LSN.
>
> This is a TOCTOU type of issue so the way to avoid it is to not
> use the push target at all for sync pushes. We know that a sync push
> is being requested by the fact the ail_empty wait queue is active,
> hence the xfsaild can just set the target to max_ail_lsn on every
> push that we see the wait queue active. Hence we no longer will
> leave items on the AIL that are beyond the LSN sampled at the start
> of a sync push.
>

The fix seems to logically correct.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2a8c8dc54c95..1b52952097c1 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -448,10 +448,22 @@ xfsaild_push(
>  
>  	spin_lock(&ailp->ail_lock);
>  
> -	/* barrier matches the ail_target update in xfs_ail_push() */
> -	smp_rmb();
> -	target = ailp->ail_target;
> -	ailp->ail_target_prev = target;
> +	/*
> +	 * If we have a sync push waiter, we always have to push till the AIL is
> +	 * empty. Update the target to point to the end of the AIL so that
> +	 * capture updates that occur after the sync push waiter has gone to
> +	 * sleep.
> +	 */
> +	if (waitqueue_active(&ailp->ail_empty)) {
> +		lip = xfs_ail_max(ailp);
> +		if (lip)
> +			target = lip->li_lsn;
> +	} else {
> +		/* barrier matches the ail_target update in xfs_ail_push() */
> +		smp_rmb();
> +		target = ailp->ail_target;
> +		ailp->ail_target_prev = target;
> +	}
>  
>  	/* we're done if the AIL is empty or our push has reached the end */
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
> @@ -724,7 +736,6 @@ xfs_ail_push_all_sync(
>  	spin_lock(&ailp->ail_lock);
>  	while ((lip = xfs_ail_max(ailp)) != NULL) {
>  		prepare_to_wait(&ailp->ail_empty, &wait, TASK_UNINTERRUPTIBLE);
> -		ailp->ail_target = lip->li_lsn;
>  		wake_up_process(ailp->ail_task);
>  		spin_unlock(&ailp->ail_lock);
>  		schedule();


-- 
chandan
