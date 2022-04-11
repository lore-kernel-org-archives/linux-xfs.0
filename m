Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CF6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 05:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiDKF0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 01:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbiDKF0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 01:26:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3452B655E
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 22:24:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B1t0eP018415;
        Mon, 11 Apr 2022 05:24:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5iPsOfImIA+OajxethrvK1geNjwOt3GW0z+yRD5MofE=;
 b=kBkXtnUMJHBgvVXOqa3HjkYkB+2qLRxGw0coZ4SbyPTzQxsDhwPGUrQJuIbtZPxO0a+G
 E4bTmV+3jyheNnCrf1srSfQW7qFYFQktDlOcIuKip4ZMRqyxvwTMlTGyDCnre1rwDyfD
 VOlaT+hhEM4KgTwogH5bLcRCehFkSwcheFwpHsYKo9D89V+V8ouTLte6qPmx1PcauPuO
 mBeCNtm+dKuBtWO/zjuN+0ZX75l4bxTKsTep2XBYzwX40YtgP10azA7XXmw6fKKYGPDN
 KdoQd9LO3bPaTlfCsWZs8VPNqU0fcEaQQDGrAjNpx48fPkz9wQB8GuMmv/5xfjmHnmjJ Hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1acq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:24:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B5HAJR030274;
        Mon, 11 Apr 2022 05:24:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k13mv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 05:24:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpBuwwClFMZvdyyhFpVILEWy7lBoT/awBcXF0f9OpCgdCTwRqAtfluSMy6q8sL5PxT4YQ7QghhyLnJLo+Qx5w0keP2cajnsvgnBPAxkHfsl6/GgJ94Y6bRClbncWpdcWEymGP0L7bkxh664poqt7sTVzpQSRII33AUw7WXBGRwR7o3uAEVp2SqRvI9toB4dGNk6fsKUqEwcZkpDbEIwTMlct4DhPBL9TOg3fI4/QRNOaefT6CSlEbCRwS8pDXYC5HXwxehzCJKrVIUh8GlrFpRQlrC8eWMA+joJWxZwbsgsbK4LCM71QtbVhWo0nvfjjZAXy39Q4vs1hsaWPAgW+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5iPsOfImIA+OajxethrvK1geNjwOt3GW0z+yRD5MofE=;
 b=lmt4uxBdA7JLYDR3jv9qHTLC1NQzokc2EgQFJw9n3sYmjAkR8r70JpMBSPGBWKBXowKzNwtH1mz5be5PyFi/Xoi0qjsxPgvagIAcWRG58S4UbFF1ppBfndN9fZUVp1NpTph6kyi34TJ4t/wDDal77uuE+VOCIRj+d157JhoxC6H1jZLalym8FPKsNS78YAYuCTYJb8GI9XiGEpxavO2gAcr4yFrHUbY/mEY8n2rNNG6s88KCfQYbHbMxcpE+yWbDwJwmzLqLO/ci+7sAJFvaPZlHyobu1UJopJ3T4hVYmn1u4vpahAxn4FRS3npeZruesqc+SQdZ3zyw3MyfUtaGYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5iPsOfImIA+OajxethrvK1geNjwOt3GW0z+yRD5MofE=;
 b=AaB5wqFMq+tXpwUxLk1U1Bi3hv8IZO+MObszjX2RmL7aDWNR2mAO+RXEW8xr59DMxzDFx/jpU1XVrLjixQ8kQIHaGW4moQ3xxnq0QvByn1pciBKSFC40U0ZbxRr+8K3LAl+lu1tVqOIKMlWpQQ2FAnu5SWdNXd4h+IpdXhZTbSk=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 05:24:34 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 05:24:34 +0000
Message-ID: <a7cf0d91eb5e937efe3a5f634dfd336d36bae384.camel@oracle.com>
Subject: Re: [PATCH 6/8] xfs: add log item method to return related intents
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Sun, 10 Apr 2022 22:24:32 -0700
In-Reply-To: <20220314220631.3093283-7-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
         <20220314220631.3093283-7-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::41) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52be5dad-2373-4577-cdee-08da1b7b906b
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948B9FF5BF2EC7505DD803395EA9@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+VKruKv6Vu2/fdhC8KDOz4N6hnYyJ1Dku9pn2DwCIGSfCeHBj1ZAdGSYiVLMZBSrr+1gcgZMEAHQ8sEWIMVAPNobor4K0vdj2Dmm46uUlVCWbbQQE3cJi+eedjASrFmqIc+k553BK1YQaBRj+qeGPOa81H+gtWeTgCJv0yETNr42WmrnP4CXGUyuSS3NKDdc7SLEEa0j+k2m5q2STcqNsAmLNrA/BYd13XvupvUyMubfBb/HXXn901yI2diirlFd/Y+4/e58+bGmmFOCRkFP3BNfFm5u2pWbEtfepdpaDO7V2Tq321rqxxc9AwnqTPx8es/vXEcd7ARX0Rb+R5W4lVZ0CVBYhjtMbkd2r2Sou8xzTjwg1goiVRrEvXseChUaygLe0mcoXb0D4Y3sJDbg4tQ1lKG51B7iqFVwgwyikiBXM80elOplO7+9EVasOCRZQwSIh//za3FzIhCNIq5ymQyTJgpxaoJBjVe+bWAg6Xb4Pl9WL1gVVUenvnJFO0ORR7m1etoUVZTnr0f8B7bpRYkS/WbvxFcpt5yJIHOVqWHxa3P/B5Yt1pxzErPwZMjEciPjwoIAgyPRkV/bY4QUcVkkTaeIibC0IWQzfz+/6X8LcOgLSS1HzpLmtJ1O6/nAPuftpnN6S4D9f2XClbu/0URRq3KvrjE4KmVdncNii3PzuakzcNFRtWaC6cAz81A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(38350700002)(38100700002)(2906002)(316002)(5660300002)(6512007)(66476007)(26005)(52116002)(6506007)(2616005)(186003)(36756003)(508600001)(6486002)(66556008)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmVZd3J4QmhyMXVKVG9IYVRMYmphRzJsRlQ1VkxTTnpRZkxKS3NwMi92VlM2?=
 =?utf-8?B?NVRTR0cvcDdxeDlyc0wrU1Z6Q0h1eitjVEJvN3B5UDNEbE1mMVhlQ0dGNWNW?=
 =?utf-8?B?UzBQYjdONjBPL2xEK2lKeG1OVVFqTVpYUFBJaGxzSVpyZEhZK0EwazRFSmFN?=
 =?utf-8?B?OUNmam9sQzhQbkRveUJwOHVjL3kzTEo5bHJqNnk0K1ByMWlLcytWakFuZXlE?=
 =?utf-8?B?TzBwTmVNT0JRQ2o5MlVIWVdDbFUxWm85RU1zbytSVEJ6YmZ4VWxPM0QreDR1?=
 =?utf-8?B?eFJyT25ZWUIzOVdEYk5qclhPY2VtT1lTbFA1Q3FXRkpQMTRkMDhxOVhYN0pV?=
 =?utf-8?B?NStNZU9FL2NQaUk3LzkxWWRNektwc0crMUpOQmlXeEVrSFFQUlhiN2RTY2RG?=
 =?utf-8?B?TmlYSWV1c29IOUVsR3poaEpmaGpDVXdRZUw4NEk5TGR6NE5BbDBnSno3aDFW?=
 =?utf-8?B?a2dnODhzaUJaUVo0bGNUcUZzWmJyclUxTUgxOHhVYTB4TnhuWEJteHBmczM2?=
 =?utf-8?B?S0hTNnllcG5tSEwrKzVORXFMSE1DUk02RFQzS1ZiZHo1dlpTQk9YK1RQM3Nj?=
 =?utf-8?B?WXc0M3NFUVVJV0hmcGxIN25CQ0RGYnJRQVVIUVZoTVZnMHAvTXR5OHhWL3U5?=
 =?utf-8?B?cEIraWpTekpNc056YlJiVFpvTXVGYTg4aDFyZGJGQ1M1TE1DWElUMlhPTGdK?=
 =?utf-8?B?c1NBUFlNd1BYRHhHaisrVVBUZE9ab1I1NUt2NmQ3RFkwZFFBYmx3cS8vM3Bz?=
 =?utf-8?B?bVZ0NVBVVXVvMkgvOXkxUDdpV0twUk85WDl5Ujh6bUdRQXF4bGJvcDRycSs1?=
 =?utf-8?B?alVrZVBudmJjSUxYbklSeHc1dWxjZGtDaW5GR3ZFajhGMnoyMnRyd3AzMnlx?=
 =?utf-8?B?Slp6c3hydXFIM3JOTTVZOVNlbXB5TmpONXFld1A3T2VuSm5pdGtLU1ppYm9Z?=
 =?utf-8?B?SzBRNHpkR3ZzenJ1TCtWQ1M2cGgxYUJUaWo1RGVDaGlyU3JqcDB6WkRuLzJ5?=
 =?utf-8?B?SC8yTG9TaXdidThIN1NVdE9LRXpEQ3U0b3FDbVZJQzVzS3loOEYveG94UDVR?=
 =?utf-8?B?OGtQWHordkFiVG9STTRvaXFNeENlMThmOVpwV2JRZGJvQ3ZDUzBlUVliSVZs?=
 =?utf-8?B?L0xXZVZhbUhkUm9XZFduaVpwQ2lFQXBBKy9adVVBOW9EbGovYXQrKzdrd3RV?=
 =?utf-8?B?VVRhMHZYdExjT21GNS9jOExOcnMyMWlQajN1WDZwMzRyT3hjV0VrVHl4bGxo?=
 =?utf-8?B?SGRoTnZDSWsweEt5enBZYnRBNUFMdUx5RHpZZG1pWnpZejlmU3JGQW1yRVdi?=
 =?utf-8?B?cXZEWkxEREhwWExiUCtMWXpIMEZ2MTN0eStzTjdnSVppbjNpSXhFL3lmZ1Uv?=
 =?utf-8?B?dmt5RkY0SEY0c0RBamhsT3lmc0VwRzVSVDhGbHR1Q1N0aGZOeTVhdWcvVUV3?=
 =?utf-8?B?TmVKL3BQVFVHcEl6dU93eG9wN0ZDR0tBTnMrdk5Jdm5vVFhDN0dVOEhhN01V?=
 =?utf-8?B?S1lGQTZidXhpTE14czcva2dUZUpjaHk2bmI4WTFDSnVKUzg1WC9DWEhYaDhs?=
 =?utf-8?B?cnJpUmIwZHFZM1g2KzArV2ZoTnA4RXFyVVYyblRBSlg4MkY0bGEwakxDbDdT?=
 =?utf-8?B?TWFVSStQNFJwWUc1RUl4WnptY08rekZrajJESXhubENCZURHUWxGYmwzaHhN?=
 =?utf-8?B?TERaUXZPVk8yMVdQR1FKaS9UeDlKMVNQdzA2dS9idHpzMmV0ZUFFdjg0QTFE?=
 =?utf-8?B?cmVGRjMyZVJQQzk5MkxEYlgzMS84WVlzck03UzRWc2w5S0dGTzU1RVBJaGRQ?=
 =?utf-8?B?MHk4QW9ZY2daT3RlWVpPa2NCRmpnbWpIcHVXOGlzbXhMdGdacm9nOTNOM3NL?=
 =?utf-8?B?ZitLTmtMVmhOR0tXSWh0QUd1UDJaL0QzbUZucFNwNnVFWHpIMVBVS0JvdXFL?=
 =?utf-8?B?V0pIRlZ2WEJMd3BXSllHcTNaS3hMb3JQR1VBYm1qdXJvMFZkNEh2QithcHNx?=
 =?utf-8?B?b3hFeHpuc2tKZEdwTmZteVZUWjhNTThEeEViOHNER3Z3bG4zMVNzYkRJbUlK?=
 =?utf-8?B?SWZEaW54M3JKRE1POGtmSVBLd2I5NjlvSVI0SWw3V3NPUW1MbVFmUlUwdFV2?=
 =?utf-8?B?K3FHM24wQldaaE5ycFRtbGxxMWNqQjNsd2Q2U3B1UFRXeDJOa2VDSXBtWVRG?=
 =?utf-8?B?NVp4UW5wSzRwT21TNE1iaWU1Rm1pTTh1N3VmaVo5OXBIdVFabFc3SCtVam9y?=
 =?utf-8?B?UHU2VUZUQkg0TkF6YU1CRVU3b3llVDY5bUlEbGtOcnF2ZVQ5aFNzTDFzZGtk?=
 =?utf-8?B?TGN0alI0Y3NnWkVIY3c3TkZMQXFYY3JzYU9TODJhV3gzYUd4QVY1MGk4aGI1?=
 =?utf-8?Q?4u/Ovd6f3y4I9plo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52be5dad-2373-4577-cdee-08da1b7b906b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 05:24:34.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74bC/VhhZ0UOk7a2ODaMIwjamz87kkCQmORiAPOyO9TE/rZ3w64z2UehbQ1ldZFyTAKFM9etZYkKv3lEoEJkqoAWvzNycQXKx4tu8/0UCPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_01:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110030
X-Proofpoint-GUID: 8FkpGUP3DXD_8N-rkT8m0Ccpwn3bMvlF
X-Proofpoint-ORIG-GUID: 8FkpGUP3DXD_8N-rkT8m0Ccpwn3bMvlF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To apply a whiteout to an intent item when an intent done item is
> committed, we need to be able to retrieve the intent item from the
> the intent done item. Add a log item op method for doing this, and
> wire all the intent done items up to it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks ok to me
Reviewed-by Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_bmap_item.c     | 8 ++++++++
>  fs/xfs/xfs_extfree_item.c  | 8 ++++++++
>  fs/xfs/xfs_refcount_item.c | 8 ++++++++
>  fs/xfs/xfs_rmap_item.c     | 8 ++++++++
>  fs/xfs/xfs_trans.h         | 1 +
>  5 files changed, 33 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 45dd03272e5d..2e7abfe35644 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -201,12 +201,20 @@ xfs_bud_item_release(
>  	kmem_cache_free(xfs_bud_cache, budp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_bud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &BUD_ITEM(lip)->bud_buip->bui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_bud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> +	.iop_intent	= xfs_bud_item_intent,
>  };
>  
>  static struct xfs_bud_log_item *
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index ed1229cb6807..1d0e5cdc15f9 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -306,12 +306,20 @@ xfs_efd_item_release(
>  	xfs_efd_item_free(efdp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_efd_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &EFD_ITEM(lip)->efd_efip->efi_item;
> +}
> +
>  static const struct xfs_item_ops xfs_efd_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> +	.iop_intent	= xfs_efd_item_intent,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 642bcff72a71..ada5793ce550 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -207,12 +207,20 @@ xfs_cud_item_release(
>  	kmem_cache_free(xfs_cud_cache, cudp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_cud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &CUD_ITEM(lip)->cud_cuip->cui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> +	.iop_intent	= xfs_cud_item_intent,
>  };
>  
>  static struct xfs_cud_log_item *
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 4285b94465d2..6e66e7718902 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -230,12 +230,20 @@ xfs_rud_item_release(
>  	kmem_cache_free(xfs_rud_cache, rudp);
>  }
>  
> +static struct xfs_log_item *
> +xfs_rud_item_intent(
> +	struct xfs_log_item	*lip)
> +{
> +	return &RUD_ITEM(lip)->rud_ruip->rui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_rud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED |
>  			  XFS_ITEM_INTENT_DONE,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> +	.iop_intent	= xfs_rud_item_intent,
>  };
>  
>  static struct xfs_rud_log_item *
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 93cb4be33f7a..6182c97cb8e7 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -77,6 +77,7 @@ struct xfs_item_ops {
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
>  			struct xfs_trans *tp);
> +	struct xfs_log_item *(*iop_intent)(struct xfs_log_item
> *intent_done);
>  };
>  
>  /*

