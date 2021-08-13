Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F79C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 07:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5898D6109D
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 07:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbhHMHjC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:39:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32726 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239505AbhHMHjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 03:39:01 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7MU6k016134;
        Fri, 13 Aug 2021 07:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=agrNhNmUdrxGQKWtRHY/pp49o0ht+4JNZBQPQIpQqfo=;
 b=yw4PsSJBXeTpnU8/M6AInMfoy6YIH9vpC0cP7TgFLaO4Fdz7xXmfPjLpKElnhPbJmbdH
 Xk9U8RnjDHW3Y/1yYe8v4nJjg8+5tTSR+O/4VxA4I9++haX6eyqpPYHlRwxNp+f19KVF
 BUrPNhbrBslvfwVCWpMsFZY4o4UZikv9efbaPvg2cjy16ZGoJE7cHZ5NqWdoiXHZJPjo
 ZiOrhtUjGWNBxuYBw+LrOL75B3itMWWjv1uezsbDC2EMhz8jeVcJKF/rAjBeCOWwy8JA
 1H7+pMGGoxccIyKh4g9zUcmzHb5Es8IJXycvByuk6gBwc0EAp7RX28t38RZZvXRBY+ep dA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=agrNhNmUdrxGQKWtRHY/pp49o0ht+4JNZBQPQIpQqfo=;
 b=HIdWZszUHevrqbPORJpYJOeTjCMowShPokqwkvhDHbI0EhKieo5ERvzOXe93ZKJ3iLKt
 KwMAxq70lQsE5ux+s/fPSAMlf+9ncVmC7A/gh7sxQsHsDEMgixamcnIx91nOpWBRA+pO
 ANR9xfSHG+xNgEHTCjP7Y6bINNMyUYZlaOybNBUwmIkR0qCQG/3xC1HRxMQ9HoqXi8KK
 BWFDHKHJSYjE9yEGzQ5/swsWouwc8B/IYDXUMprrdwGLfog/UhPymFqE5rCkqUlJmwo2
 YDzBvprIPxbobJ5vx4vK3KSIp/eH+tNCPiOROqPHiA7JWy3P+IpE2FsvMQrDMGgWXJDo NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad13va97u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:38:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D7QWdb008076;
        Fri, 13 Aug 2021 07:38:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3accrdjuey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:38:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCpe2RoTjMtirrg2E5CoWamlrHakIK6mlTtCs/nyKgx9aqu2njNsyBLC+VPFH4LejFTOgHBfo23dn6x3y49uFO6oM6E7wRyJEbxAfmVGZVzUmliOOyZY5YwLETMsBgcMxrhwreHmi8O0zJ9nQZVorDVTeELbkl4lhZeCHTmJ5Y+AX50+n1zDFqR3Mze1RFMqmB5u6GGRinlLuuFKcwu6Qk90U7KHPJJnv/08q7baPWwPsmKbc0G1Pl03tjxCjGyf00sM0AL8XDsZAM2SfHxwEzvSvoXHnjVjeM2CJoB+gu0OCCVQr1gag4I+uAVxOd50RynNJ+lvgpUILrq5djd1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agrNhNmUdrxGQKWtRHY/pp49o0ht+4JNZBQPQIpQqfo=;
 b=SdWTQh527sM+2ZfymwcCj3wymgzWjXHTqOKm0wotoEPFKmm7BZBKU+YPXKzXL7hb8oXrnCkDtZC79yD5PyHGn/JYbfpwVFuuDNlit+cgYa8ZzVLu4wJZuozrUJCgSZkVGIVsD83CBLyu+c4QiFaTJcsgihCnQ8Qjk3SpRJeemYKEZxcdvpwzqK2ek9T6Gjq9/OB+rSXA5eFg1HNjLl7RSkes6XObObPO6lwj+a/nSl0lntQ96PVMchSrK2o04NoiLNa0RaL1UYiAzMTdXR6bpcKYu7SsvsDRJcrYDvzs3PiwQpf1o4bRnegBvrE/0MQxqXYgusQEYu77HHGVwWS5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agrNhNmUdrxGQKWtRHY/pp49o0ht+4JNZBQPQIpQqfo=;
 b=l7ckRaqmK/WdH7hNYEz6Qxbf3FTj+yOhBciF0u9Oo6038RGeceY+zzbCy+BHlngLta6Q30QElKg163htz4KbyNU/DZrNtN+FkHZ4pI8V1vcmIx9W+xPZJoyPFo0eWHXweQMbJSbsJedWiy5Js7uFXCwyxdvRmJjR+jVVABk0rps=
Authentication-Results: fromorbit.com; dkim=none (message not signed)
 header.d=none;fromorbit.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1614.namprd10.prod.outlook.com
 (2603:10b6:301:8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 13 Aug
 2021 07:38:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 07:38:28 +0000
Date:   Fri, 13 Aug 2021 10:38:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: pass the goal of the incore inode walk to
 xfs_inode_walk()
Message-ID: <20210813073812.GX22532@kadam>
References: <20210812064222.GA20009@kili>
 <20210812214048.GE3657114@dread.disaster.area>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812214048.GE3657114@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNAP275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 07:38:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e7e19d2-7c95-48de-b976-08d95e2d5755
X-MS-TrafficTypeDiagnostic: MWHPR10MB1614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1614A574418E01355CC6A8DE8EFA9@MWHPR10MB1614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWrcWU6y8CqQQD8CzX4dxNfRRBzKUre8LtLZ+rlHaTpfol78sJv06+85wH5xq8dg2P3QCemuTN1cZVmg+rV8eNC0jwr4322MxSdqXUD5MWnmfYgsdDOUl21b4ZoqOSAZm+AE3SrQgbnV8ZZVHT7+cTuS0Yy6vQta0LAxUH2CpwDnWyXPZPzu8aPgYtn0+iTvn3wU4aZTrqdvGMHYZg3hvFbvSdh9yhbtEVkMgxjMVQqFOiNbpOIdJxNjyp5MzQcvcDv4Di4m+0wFZPj06edPpfj5ulhPZEq/NQumfOgPSlPygu13vTl+6DltVX9kCg7mUYVo8k/EKjAzzg9gG6v85MuPZmkINJvX02mGq+vvLK+a8L9Ddz62a/js3Ya6BCYSct0H2X2X6ik3q7dEd87d+jGVNLUauQCWxGjHNdytSwaK3DKLlBoV14OnmOjFyl1C5xR7MmU6wcUDMocSrGUpD0rh+XA6+khp69QSZ86URqzvQegBovlS/7uGokOfyglpetO+odGkg+UCkvV9OtJZMCFvmWc0N+9Jg2uIFjjHKZZqaaCjthArfD2GaiveTamwpVCd0tU8gEIF0n9Xe2thn2NZcyDEABUUEIGGwSnw3NC6feta7l5m4sBb5843BSiSOP4lnrnaa3Wx3yXwaWJe4+ubJsVGEYwu/DtoKzZJkcMj94ACanmSu5AkxYtnhBtmDOqgTWTIN9qG/ry6xEX/iV/1rzA5j7MU35EoWvYXqHZuMQgZZuc2s9MHwEsl7qyFOb/zU8t2QpSwDXcx5tw6J19mFwUSNXfaNl6oMBW2MWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(110136005)(66556008)(66476007)(316002)(86362001)(2906002)(956004)(83380400001)(186003)(66946007)(4326008)(6666004)(38100700002)(38350700002)(44832011)(966005)(8936002)(6496006)(26005)(478600001)(52116002)(9686003)(33716001)(5660300002)(33656002)(8676002)(9576002)(1076003)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3okL3TsINDHGC++1tkT1UNtQK/FABAtBgWmGaKO3XZ5QyogvQaCTVs2lr+kp?=
 =?us-ascii?Q?yPHTxe9hSqZu2FhINWxvRHvn/BSCZSoi/fTjFILkwMarBc+bBH5j24N7YdDs?=
 =?us-ascii?Q?0v2jDNKkmucgLQHDapzgTjpxqPTEUdraTzhmelSKG0M4pLoOzburzzYCYbIR?=
 =?us-ascii?Q?Yab3tR897yQYkZ6rOP9GI+ADv+FUlAIAtT56e/vvJ1BjeOr3csC03gRI1ipn?=
 =?us-ascii?Q?SD8Xxm30us0Og6BanbPktk3RMPz2zyrAAtWYBt5QE6Fm3z5I1d+0x1VSpgda?=
 =?us-ascii?Q?lIv2wvGJhvSxEqsnwH6hyfycH2UibVCHmGkPDhavHtNGtBtEHnj1oHAaAhkd?=
 =?us-ascii?Q?+tg++jCKaHXF5e+uW7r/4ix3q22kcVLCX/etT+TzfT4F0o/+8UNEq6pnKwAF?=
 =?us-ascii?Q?+t/S8VqsY2zi3X0zmMgXONA/cjJ7eDvuSXgW4Beb/LU6BjRWeOV3WJuArphZ?=
 =?us-ascii?Q?3ZgJp8ihHXlv+p47UlEEdlk4iRHxmvcvU2XDZ4j1WED9OkWDuGqG/GtN7wHL?=
 =?us-ascii?Q?GhVXjUctW3OcPmpxPtW4CCXkV6HMw+JbLieUEuMT8XuCwtWeJ20ZAfp2zny+?=
 =?us-ascii?Q?g5aVb556uDb4bQhnekiCHreB7fv+D4NNmPdMXMhO+2gaXwihnhkT9WDq+F8U?=
 =?us-ascii?Q?JCsoGDRjLtUZMPlGqpuOxUM93UPTAmNDTJJldFeVneGhAqRL80xenfgvnQaq?=
 =?us-ascii?Q?xP+dnXeFFhFch9kM/PhvTnPzrAe1dUI3LSEG/Tex21qkxTKkRD5kNsCeUkph?=
 =?us-ascii?Q?iakeUZ/vdaNeodFnryjuKgD0KaTXOSR66s6TvEtW2OgnYDuM0eLluzVkRkeX?=
 =?us-ascii?Q?6l8kdd7//VKVmvDQygXSfEd1CJo/edizaXnGLRPh8xKNZUUJS7dXNy6/mpsX?=
 =?us-ascii?Q?/8BjU6uu63dFvTaMryPOZFOJbD40cmknkeW0T5pSAjQOaqSjrNCTNshpbY26?=
 =?us-ascii?Q?b3YxDV5yQ1e4rrgi3emvWdA2PhFmo52tgwI4yCDermmVb4QFpj8rBzKQ6zy9?=
 =?us-ascii?Q?/WBuCqqHj2vjkUnia4BgGRQtdPxVVTvhEcH+ErdITNDVBBXY/VFVyuipDRcY?=
 =?us-ascii?Q?YeDlJKhYg7OwF1U5nDzRT//p8nVwYPFHlXhEZ34u3s9zS41+00xhsJb3PE3r?=
 =?us-ascii?Q?5IBIISYGRF4dFL0il1No9X0CfbP/eucIDdMvwcewT4eBzKVYN1JA6Y8mKRmf?=
 =?us-ascii?Q?wdtCZd2dMXnh0ar2A1ClDE9B64Q5zhWr1BCln++7SPqjnGQ9Bd6f8QMxmNlK?=
 =?us-ascii?Q?UtxKqekz2IzPCmMJ0vv0m5tj/C0H7KHIrCTWK3Wc1Om7eg1k++MGe5hsEJxS?=
 =?us-ascii?Q?1S1/lUlY35fvL/AKHUmHTEIE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7e19d2-7c95-48de-b976-08d95e2d5755
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 07:38:28.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b53q9lEZWEADNO7l1CZktPEBJMQH9mN59pq9rlYsfuBmo9yRDsITLbhLGDcmnd3cQZPoYgosaE19MvfyjttBNNM/kAlh3LZw0ca197KYpFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
X-Proofpoint-ORIG-GUID: oUtCXCJFvv24cqQk2blWsaG6uTE1mskG
X-Proofpoint-GUID: oUtCXCJFvv24cqQk2blWsaG6uTE1mskG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 13, 2021 at 07:40:48AM +1000, Dave Chinner wrote:
> On Thu, Aug 12, 2021 at 09:42:22AM +0300, Dan Carpenter wrote:
> > Hello Darrick J. Wong,
> > 
> > The patch c809d7e948a1: "xfs: pass the goal of the incore inode walk
> > to xfs_inode_walk()" from Jun 1, 2021, leads to the following
> > Smatch static checker warning:
> > 
> > 	fs/xfs/xfs_icache.c:52 xfs_icwalk_tag()
> > 	warn: unsigned 'goal' is never less than zero.
> > 
> > fs/xfs/xfs_icache.c
> >     49 static inline unsigned int
> >     50 xfs_icwalk_tag(enum xfs_icwalk_goal goal)
> >     51 {
> > --> 52 	return goal < 0 ? XFS_ICWALK_NULL_TAG : goal;
> > 
> > This enum will be unsigned in GCC, so "goal" can't be negative.
> 
> I think this is incorrect. The original C standard defines enums as
> signed integers, not unsigned. And according to the GCC manual
> (section 4.9 Structures, Unions, Enumerations, and Bit-Fields)
> indicates that C90 first defines the enum type to be compatible with
> the declared values. IOWs, for a build using C89 like the kernel
> does, enums should always be signed.
> 
> This enum is defined as:
> 
> enum xfs_icwalk_goal {
>         /* Goals that are not related to tags; these must be < 0. */
>         XFS_ICWALK_DQRELE       = -1,
> 
>         /* Goals directly associated with tagged inodes. */
>         XFS_ICWALK_BLOCKGC      = XFS_ICI_BLOCKGC_TAG,
>         XFS_ICWALK_RECLAIM      = XFS_ICI_RECLAIM_TAG,
> };
> 
> i.e. the enum is defined to clearly contain negative values and so
> GCC should be defining it as a signed integer regardless of the
> version of C being used...

You're analysis is correct, but I'm looking at a newer version of the
code and I blamed the wrong commit.  It should be commit 777eb1fa857e
("xfs: remove xfs_dqrele_all_inodes")
https://lore.kernel.org/linux-xfs/20210809065938.1199181-3-hch@lst.de/
That commit removes the "XFS_ICWALK_DQRELE       = -1," line which
changes the enum type from int to unsigned int.

So this suggests that we should just remove the check for negative
values.

regards,
dan carpenter


> 
> > Plus
> > we only pass 0-1 for goal (as far as Smatch can tell).
> 
> Yup, smatch has definitely got that one wrong:
> 
> xfs_dqrele_all_inodes()
>   xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
>     xfs_icwalk_get_perag(.... XFS_ICWALK_DQRELE)
>       xfs_icwalk_tag(... XFS_ICWALK_DQRELE, ...)
> 
> So this warning looks like an issue with smatch, not a bug in the
> code...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
