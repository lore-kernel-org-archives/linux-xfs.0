Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2ECEB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 05:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjFVFiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 01:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjFVFiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 01:38:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A782171C
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:38:16 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKKEGT003664;
        Thu, 22 Jun 2023 05:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=d2i5X6gekWMoOjMY6nbXHsGrJTsR1kOPmYwa6KyzRuA=;
 b=wwPSPJB0eeQqSzauoSriCmOm27xxjQvUIUh4deVLe3S3+W2HKY8AJ/z1ey2rbpRVAYhT
 qy+r1Ub7OvjparsPMn/Ro+y4eDLSW63/H3Jcg5g4iwFThIGy926XUhAHMvOU8xIuVZ1u
 D0XnoYPho0xTlCsAM76G2YbDKsvR4ul8JDudmPEYV6OmE9qTIKy5cdZKgy2PiDzmpigN
 7aPDR7trx+iVeGcu5qT57JQfjjFEVQuSYTgtMCIkFo3lGeD9z+1okEgHz/bF/1gXm/6r
 fc75Mo2zIm1BnZKicBaQSiQ43obbwDXrcwq3+PM5rq5vCj1h5rInshtAgZx6XdkNEqUs 9Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r95cu0yjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 05:38:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M4ZWQH008323;
        Thu, 22 Jun 2023 05:38:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r93979gfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 05:38:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A5U+GXcojw0u4ciSSBvpLuAGjrV6NEIuaRjRlVpLLwkjGrjRdWAQ4gCJ8J+wtwLD5wWFNNLPCAalT/o3iubjkGoXqErsfJs20uYNijfWL4hdCAIsfeoY7sv1KhW2RvbAT2iEyIELtGMHiSj/XNSm6+1oBCSQundtsfvxJQOUq/Oh2CzZVjJw0RX1GDtTFzPPIhikoyN/wJo+TPvxI48JvO6DK89aDGTiOAozurF2fec4InwH6dMNM3VKc9RtRFuQnRa/gaAg/5SLRqyMcP91vOdM89VIXy8NEWwe42q4xsTmmEFBpEu+w1keaG7Tn5MjeA3A3UI+MQhajeoDN/adwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2i5X6gekWMoOjMY6nbXHsGrJTsR1kOPmYwa6KyzRuA=;
 b=kxZY00r/Bs73IHHxxKTSyU5crI3p3S/JkJqmBjsN46Z/LYaIXPlhlDRkivvbwj1wvv6k/bN1mJuDFTAnJHLJc4WmnO9737wzH3RrXcvresrLejag9yHgIUJrMTMbU3bV1oeDueouG3sC9v2+p8z7XyMvyrt+Rku7s8NPRwr3L4HwJK0oIE4Ht5QQYeYST8a4fzxDHolS2XIdyh9qZ2VrxOBQl6BaA5fs2Ye20ZKs0N9K4pkjrW9lxRDXElQjF3k3KC2UkowcZY6VBt+oRu+vOn/q02GpUt1tyqbStZYmxtGjZPfNPeehwFoQZnMeqFE2cfMpcbo8utjIuEcxeuUkLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2i5X6gekWMoOjMY6nbXHsGrJTsR1kOPmYwa6KyzRuA=;
 b=TfYZQxde+ej/s8zWnMXtWpckwiCIPnqa6iXTjK5hKnumLyrSq78sKE74YucMdbzlQUahktG1xH+8QEQBmlDfJfnnrjGHgKrKJSESRNTt/S+pbuEO0zbGJHAA8SptCImRpFtAhyOuNLUUMImyuoy8JKgck/yMDfrZgoSHv1Zd9s4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB6736.namprd10.prod.outlook.com (2603:10b6:208:42c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 05:38:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::8fff:d710:92bc:cf17%6]) with mapi id 15.20.6500.036; Thu, 22 Jun 2023
 05:38:11 +0000
References: <20230620002021.1038067-1-david@fromorbit.com>
 <20230620002021.1038067-5-david@fromorbit.com>
 <87a5wumafo.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZJIlmbuHIhu5BMG+@dread.disaster.area>
 <87h6r0nnvy.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZJPb/OR1q68NHgm4@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: don't block in busy flushing when freeing extents
Date:   Thu, 22 Jun 2023 11:06:50 +0530
In-reply-to: <ZJPb/OR1q68NHgm4@dread.disaster.area>
Message-ID: <87cz1onjk2.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0165.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:383::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f7b6d2f-5466-4e17-99d6-08db72e2ddd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kdf5rQYUfvD/UUInZwhv8d80VBgXX1pFlfxDa3fTGga0DgltQ7JJOF+2c07RpBeBckdbI192cH+Bpt6Dl8GAeKr1hAyiyBm8dnTmX7X8i3jPNCDDf+rEnMBjjHHSuFm+WabLzYvoSAAyDIpirtdtcBnFEQdcEy0pUJEzy/+cgoL24UCvc3HAiJPS9kRJxLO1PGYdLqfQiJTne27shL7p7bDYyw7rpk+0TYTVMK5AKziFvG+L/0083S9uaZpVb+h7TDWLlYAImHN5QsuNccZw4KVmdt0yS+rT6oZtL5/HeKfJurRZgC476Nl5DheJlAeicj0drbPPBQaL8D0BKTwpFcggW1VCmPG/11QkB2vg5//L0yJpBl/okmcMfBkfK5l30fVHJaVIOdECOyhiWVHbTO/O8qPwytrdPt2oj8NwXHPurbbR1BexjI9aBlMHIcFOnPJjxWREi+MnR5ocFkZ9DvwvxV9bfTutgpqx9qN968BusJMubMMGXPUMz82q6Nkbc8IV/hu/fbUXs2HxQneSOzHnwuXfor2lswjtElF3X6qed/ROS+8qxC2d9xJUID9d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199021)(33716001)(8676002)(4326008)(6486002)(66946007)(66556008)(66476007)(6916009)(478600001)(6666004)(316002)(86362001)(83380400001)(6512007)(6506007)(26005)(186003)(38100700002)(9686003)(53546011)(5660300002)(2906002)(41300700001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8jaMT3Ua6nrLmbYT3DzT74+fgCLvdjiXWkb7dP5mfOFilfqGAbLFT7fQ0p1t?=
 =?us-ascii?Q?fiyycyTBcGaLUkTrF0q8df9RL+uPoJvJf8i3njkx+bmC1c58QI+NE84zPPwX?=
 =?us-ascii?Q?kzncbkgJCaj74zdRBV3d9kIWJPhF/kUZHJSKT+m9fbSAcjmgulg6+ZC1sSjk?=
 =?us-ascii?Q?1nJKX24pfJwlprf3ejODqvkn92p6tY9S8t84KpCgr9KjYrq0HfXzmhfAR5lb?=
 =?us-ascii?Q?KrjQwFVRzNqFKEI8X4yfbTcC6kPP50qli1KmiF6+33HnpB+qa/MwH9CZoouK?=
 =?us-ascii?Q?KSBPj6Kqabz/ucC7kPHIXxoQYdOrMiwl/C63oR+b7B1Sp4Y3qpMne/mtWxjF?=
 =?us-ascii?Q?KQnWVGvezdd3h9rpxwT0biFExx6/+4bMoQNVyFHTbHFT6yc6SBghExYU3LQL?=
 =?us-ascii?Q?eJmMUJF5HowkXxguX4EvoqvkjBmNYJFfreqKEweGcDhJT2TVItBWiBg9SkvP?=
 =?us-ascii?Q?FNz7+PtDopl8IKPFMA/c6499AFuCjeMjuEB0Nj8O3j1q/mJzKHa53VMFio8R?=
 =?us-ascii?Q?mKZE5OqCvNNLILpUW5sMAq1l/ofpsqHsit6uK1pGyH/Xo75zH5c4xywHyylw?=
 =?us-ascii?Q?9YwGOwHhsnoq6DN7b1EhDa3heUzV3jBoS0PseCLqcwxeoxMcUpCE1U/4A9ub?=
 =?us-ascii?Q?id1jAmAblwgaNYkunq7PrmQVqyVGms0QGITHW18B/suDRgq6vEKKLmcAWmZP?=
 =?us-ascii?Q?YslE0u65y8klcwFE8Z/gzUjBY5x/URTXvXOUviz2sFAXz9E8CaQec368FyjU?=
 =?us-ascii?Q?I982gyOgRqr+hDIXqtjWYJfpNf+cjwsjB/KG71/AEN4zumtrGzIpSZ0owpvk?=
 =?us-ascii?Q?F9Jj4GbL3LOrWfOS82bQiUiT7oZNbS3xtfyiHO8fgXTNgqsXBsqdynOLz2Ub?=
 =?us-ascii?Q?2IW98f+FoLE6PAKTTXqkprG17iMe2sSPDjUpSW66hjZ4h4yLQrSvHP62j8x2?=
 =?us-ascii?Q?PiPyy8AM+e75VtAMq+ji8PGLZHI5hrZ2ffJg4krwfYMTOEM4t4IQtuH8aWuS?=
 =?us-ascii?Q?faTXc7RdeY00QrsWkhECWp7U1xAlu9FKGIjFhdj0ICQMAXPKk4GkY4p8C//z?=
 =?us-ascii?Q?1ppm1QJKtQHg6qwAIGyOPZxmGib480ZZL3hSejuaMp5ekksVFBUxVOwZpn4b?=
 =?us-ascii?Q?AjQOXng7qirj41cJ2XZIoqkgWjjfQMwmp62Xl4QW6O4sLMAMdBg1/1ZhCbU3?=
 =?us-ascii?Q?astiUsQ5WGBCMmAiQ06+povxABsTQmh7SifCUmjhpo6B68giOT5KRiQMQsip?=
 =?us-ascii?Q?dNRttDCT5VgrVqts7ITUxMv/6mOxKBvJgiixKmDIcpYiKhRYwSH2LapxzPkk?=
 =?us-ascii?Q?QoKYrpfLy5iKS0NEZFmENWm6JvL9mfo+//7F+rMJCeTMi+0GgnmIsbDyHSf9?=
 =?us-ascii?Q?AEzbaPQ1TlmMrgjgHQp11cIn5/wZtG/Q+o2++2SFtJzsDOAYqqwarCs7dzrf?=
 =?us-ascii?Q?HuGmXhImmbVBlYsHUu2O+RFUKLh0GhKTB10+XYheOzGpQtD2EGgo6HIrpdrP?=
 =?us-ascii?Q?vypIaTNnKfiX4qZqiO0uDoEN4RS+FKIxdHzZ5NSHINGZmn+YTmUAup3wtPvx?=
 =?us-ascii?Q?snbr3trN3bNVqF8BAMpmuSDFsrq3tmADdAYFZayBFmR8rj3cT3vgbmyMceN4?=
 =?us-ascii?Q?hg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +sfVrElf1rEQIV1ihJSYVnz0aLTFrlJ1VyIXY3yANkN28TgmzSUeQgs7GywmMk53phbz8PkkE4O7Bwxhzhwd4mLg6yQHLkcvzseJU0808cjfEtDwCvJSLI8qCxq4yUQS90W3zVm2PrBET3mtJW76zX7OxONTZBHZXCs4LDbEoCTvANg/sZMmhYAKjlPYkx6it+cqA+QYqzkiZOSVZ1YQ45c/FeQnItBZvIWus5QUTE0EWo08Vwp02g0syLLcTlJyXBM7RurkGwWplr5M6ts332ik+ePuZRmw5wOD4g3WGoqymOr4K2kU4knJnawrEXuiozwiK4nvGoiVZYf6oW0eoE0UUFDiLBA3KMa7IMzXxEB1+zTE0fT7B6bsMZoXrTNCCq4lqWzmZDRkAHGskWiY1VoNiKqn3V3+zBpVLfJOOawxzzAW+xv82uPpXw41EE+e2RDUYg40vx/Yr7WJ/ojzhlfBvA/66tbNa9IGG25Ht0HUK7rXw8lMuzu4RmnNcFxnxmsEPY9RBJ6KZlk6HsRh25gsgAH6buAGT1MRaRls6vFSuO8QRE6FvOK3R7FGXuZCO/Q69AYhV3O+qqdbs6MBqX2rlXZdUlD7l2aTXhugWv50KxsgwY3lusNJ4j53PT4W0cqYx9YGvY36cpLZdbBBQEYXcxfakCatFpxLBpcFJdjtL/ENTRTTi3Guw7hTBCD+bQYZZvWTGECaDvjkUARRz1H0m56ElGlHRjqNcvHI+Snq271PUu9wEjYFEXoiBFbuqkHGolugqF/9y9ASSiwlgAqq88xyfj5FmZvD0KLjJFw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7b6d2f-5466-4e17-99d6-08db72e2ddd6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 05:38:11.5210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpxtKa2i1yMN5tRT2/XhrLVOv7Taq9OPTdJxijBZY0YHqF3d9a0Qbd8L2M32AhkXyvXbxoAmWaynSaU8RUMqRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_02,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220045
X-Proofpoint-GUID: oFJK72_nzTsjxJ-PgE8Ui9gDXW37TVpO
X-Proofpoint-ORIG-GUID: oFJK72_nzTsjxJ-PgE8Ui9gDXW37TVpO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 22, 2023 at 03:28:28 PM +1000, Dave Chinner wrote:
> On Thu, Jun 22, 2023 at 09:29:46AM +0530, Chandan Babu R wrote:
>> On Wed, Jun 21, 2023 at 08:18:01 AM +1000, Dave Chinner wrote:
>> > On Tue, Jun 20, 2023 at 08:23:33PM +0530, Chandan Babu R wrote:
>> >> On Tue, Jun 20, 2023 at 10:20:20 AM +1000, Dave Chinner wrote:
>> >> > From: Dave Chinner <dchinner@redhat.com>
>> >> >
>> >> > If the current transaction holds a busy extent and we are trying to
>> >> > allocate a new extent to fix up the free list, we can deadlock if
>> >> > the AG is entirely empty except for the busy extent held by the
>> >> > transaction.
>> > ....
>> >> > @@ -577,10 +588,23 @@ xfs_extent_busy_flush(
>> >> >  	DEFINE_WAIT		(wait);
>> >> >  	int			error;
>> >> >  
>> >> > -	error = xfs_log_force(mp, XFS_LOG_SYNC);
>> >> > +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>> >> >  	if (error)
>> >> > -		return;
>> >> > +		return error;
>> >> >  
>> >> > +	/* Avoid deadlocks on uncommitted busy extents. */
>> >> > +	if (!list_empty(&tp->t_busy)) {
>> >> > +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
>> >> > +			return 0;
>> >> > +
>> >> > +		if (busy_gen != READ_ONCE(pag->pagb_gen))
>> >> > +			return 0;
>> >> > +
>> >> > +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
>> >> > +			return -EAGAIN;
>> >> > +	}
>> >> 
>> >> In the case where a task is freeing an ondisk inode, an ifree transaction can
>> >> invoke __xfs_inobt_free_block() twice; Once to free the inobt's leaf block and
>> >> the next call to free its immediate parent block.
>> >> 
>> >> The first call to __xfs_inobt_free_block() adds the freed extent into the
>> >> transaction's busy list and also into the per-ag rb tree tracking the busy
>> >> extent. Freeing the second inobt block could lead to the following sequence of
>> >> function calls,
>> >> 
>> >> __xfs_free_extent() => xfs_free_extent_fix_freelist() =>
>> >> xfs_alloc_fix_freelist() => xfs_alloc_ag_vextent_size()
>> >
>> > Yes, I think you might be right. I checked inode chunks - they are
>> > freed from this path via:
>> >
>> > xfs_ifree
>> >   xfs_difree
>> >     xfs_difree_inobt
>> >       xfs_difree_inobt_chunk
>> >         xfs_free_extent_later
>> > 	  <queues an XEFI for deferred freeing>
>> >
>> > And I didn't think about the inobt blocks themselves because freeing
>> > an inode can require allocation of finobt blocks and hence there's a
>> > transaction reservation for block allocation on finobt enabled
>> > filesystems. i.e. freeing can't proceed unless there is some amount
>> > of free blocks available, and that's why the finobt has an amount of
>> > per-ag space reserved for it.
>> >
>> > Hence, for finobt enabled filesystems, I don't think we can ever get
>> > down to a completely empty AG and an AGFL that needs refilling from
>> > the inode path - the metadata reserve doesn't allow the AG to be
>> > completely emptied in the way that is needed for this bug to
>> > manifest.
>> >
>> > Yes, I think it is still possible for all the free space to be busy,
>> > and so when online discard is enabled we need to do the busy wait
>> > after the log force to avoid that. However, for non-discard
>> > filesystems the sync log force is all that is needed to resolve busy
>> > extents outside the current transaction, so this wouldn't be an
>> > issue for the current patchset.
>> 
>> Are you planning to post a new version of this patchset which would solve the
>> possible cancellation of dirty transaction during freeing inobt blocks?  If
>> not, I will spend some time to review the current version of the patchset.
>
> I'm working on moving all the direct calls to xfs_free_extent to use
> xfs_free_extent_later(). It will be a totally separate preparation
> patch for the series, so everything else in the patchset should
> largely remain unchanged.
>
> I haven't finished the patch or tested it yet, but to give you an
> idea of what and why, the commit message currently reads:
>
>    xfs: use deferred frees for btree block freeing
>    
>    Btrees that aren't freespace management trees use the normal extent
>    allocation and freeing routines for their blocks. Hence when a btree
>    block is freed, a direct call to xfs_free_extent() is made and the
>    extent is immediately freed. This puts the entire free space
>    management btrees under this path, so we are stacking btrees on
>    btrees in the call stack. The inobt, finobt and refcount btrees
>    all do this.
>    
>    However, the bmap btree does not do this - it calls
>    xfs_free_extent_later() to defer the extent free operation via an
>    XEFI and hence it gets processed in deferred operation processing
>    during the commit of the primary transaction (i.e. via intent
>    chaining).
>    
>    We need to change xfs_free_extent() to behave in a non-blocking
>    manner so that we can avoid deadlocks with busy extents near ENOSPC
>    in transactions that free multiple extents. Inserting or removing a
>    record from a btree can cause a multi-level tree merge operation and
>    that will free multiple blocks from the btree in a single
>    transaction. i.e. we can call xfs_free_extent() multiple times, and
>    hence the btree manipulation transaction is vulnerable to this busy
>    extent deadlock vector.
>    
>    To fix this, convert all the remaining callers of xfs_free_extent()
>    to use xfs_free_extent_later() to queue XEFIs and hence defer
>    processing of the extent frees to a context that can be safely
>    restarted if a deadlock condition is detected.
>

Ok. In that case, I will defer review until the new version of the patchset is
posted. Thanks for working on this.

-- 
chandan
