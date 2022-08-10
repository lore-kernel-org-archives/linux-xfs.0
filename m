Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A384C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiHJDI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiHJDIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:08:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071F77E319
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:08:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DoX6026699;
        Wed, 10 Aug 2022 03:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=v/tLx69vTX11WdWQV9Zwbi9meqegAxboToeD4cfZ0E8=;
 b=HzebS9rl6JkcHca0ddCQ67rNw2eaEfqm+4ulzjpdg4YEw79m2IET3hjWPqotDLc3iRb3
 Q02YR75r2kAutleNPe8FkqVScHGKTe03lgBp9ztMS9CWA4tr4xcekBRXmcuqX1CfALxM
 jOHSo5Vzg7QxYBDzYA7D6LmSbmYixhNeb4zMTONOjVFmBUCT7gIco4EGo7A/U3zw64Sq
 V/u82hqFDqIlqAH9nyM84yD2mAXpWYGw4d//l7vD+3dP6WhX65vLydLMTog4/BEBpOL4
 ddivtVmiyStJOFA4p5HLQOm+7XdOe6Wl+KLYSiGTy5eNwpomTGruUDpf43RDZOTR8hsN bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90pwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279Nt1A7038487;
        Wed, 10 Aug 2022 03:08:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh8fx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7sX5CLuEX6AI0Xit9Zj6g5IE2zl3HJAbBHAxYOxHAhlEkLJw30Izo39I58nojkoR9EBZtA9kS7UR5DZz3MUcwcSZ9uFMjgUXvHviRe9AdpoMF+d96bx4zSkIoJA2nDDnEXGnZu66Kg4fKh4KKGDQ4W4wUTJAqQxBNK+Mn2p5x8FxNuyxmKjdG/LPLTcu+pZHiaXh56a3W3w+bGDDGqJAkjDK0lJAbZwRTPzz2OuY9Y555030f6SEejOiZm8x5HZcwa0GFHdScpXD7xoYjLRx0xJgFe7YTOq3XUzEigLLkyk50RjT9x1kBO4po45pbt08n+uQnyzMmCZzUrT+mR1Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/tLx69vTX11WdWQV9Zwbi9meqegAxboToeD4cfZ0E8=;
 b=MrqS5eV94ypsQjgQRGGXfQHMvQXmd/z1wiNM1jII9Saezeks6LL4/72mitu2Q50JpB8mjCV1SGjEGyVGyjIxA3//o2fTO82xAPjNIyNHiAmP+cjYrmMN20N5W3epXl1ZGPaa9UvN3S8OhABYdzlcdfHI2bVeW8MjfAhDN4EM9LHaBRVxn25pntEBqO2Navxrz7QIB/87R2NcoMvgzLm4uBotpdE4MC3/vmcKzAYwk8i6fXR4WRlnWYIP1vnVOWkIYWaUPigHb0WTAtMZP4dCR4UQeqOqh0VrYs9EPCR9OSZAlp0xZspSn7X0Qa3rsRoyh6yrF4dg1XEH125PoaIdag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/tLx69vTX11WdWQV9Zwbi9meqegAxboToeD4cfZ0E8=;
 b=TQEuAEIabcQcoLAHSiTBFBAGNE3RekEUpPCRmD7KjBGkpsEK7mY5Sr7EQTFg0scyu5PDVHyBSxr4yAEEZVCyZIVJKYlj7aCY3LwlvqgRN3fSHiFnWQlRx+W96AxzBvXjQqVVGQmH2KAXLvPQ7usGL74fVC7Gh1lir2pnDrNsCQM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1627.namprd10.prod.outlook.com (2603:10b6:4:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Wed, 10 Aug 2022 03:08:28 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:08:28 +0000
Message-ID: <3c6f563991973ef7eb43025bd70ba74343e94c50.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:08:26 -0700
In-Reply-To: <YvKQ5+XotiXFDpTA@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae58abc7-173f-417b-5c30-08da7a7d9917
X-MS-TrafficTypeDiagnostic: DM5PR10MB1627:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: opVOIVhQ/Wogl3t7ovi+Eh4X2RDmg7SW4cQofqrLZ+9Ah/Hz9tKhscePDyx5ApOShAvABt63XUqVXSKysE8tRikFK3OZoAjMkAk3GMUYLpNm4Hn1ApqdS6BZVvDYM6yrsoahw7J3oUO2NpXC0id5MuWmOpqGXNbHGNv/08WZr3CTgpQ42mzOlnh2mYtZwcix/qry/K7lqv5SN4uRGZS3yTRh3j/lUMDbQ8M2gUcGP1Kck3uz1Iq1Y8HTPY1HskH5sO/aoVBWRr/Spmc1EROtXDxsHP7NaMECY6SAgKOAcbCW967siT5jwbGOPqYuerqqBDXGSEdgrqh1ilKKQnF7XSuobRBWmBVyRm+gXC+iyXnnDK7wnBIVScqjYxwFGl4ZVh/oneoEhGWMUnmoiEBqS5lnw/E+jBAPsB0l1scYE7XzIXhxrvAbI3wUXhLsPviUEmt+EFmKEhBA9H3VMXCyBrN4nTqd7YhCCYqbnmmHjmqe/6cJONyXLmplNrb4kGgacdxvVkjS6hHcSnox/3Ng5dJJyUPnZktvpzC+g4IaXaQ1iYWaTOas9EcDEIkOut/mvToI+xmnlRN/U3rG1P8aayqe0fiOTtpb6AcY39BtHgUXQPJ1hNwtRx1gAQzjwFgAiMqE6YXbb+Tl4Dogv8aTzbfnYrtglXgtCbXmbVtcO3VckDutp5H4ctgHHy1daPszdYSiRyYOwoBzaMx6yeKO2KgwZdnfv2bF7SOsoUXMKQUqQY3vcRFE2ZF/C1D8AD+2FViJBGxj2dgqi86D+dVjQQlOL1bhPS1yXnmAQhD+YFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(39860400002)(346002)(136003)(6512007)(2616005)(186003)(5660300002)(478600001)(6486002)(26005)(66556008)(52116002)(66476007)(6506007)(66946007)(86362001)(41300700001)(36756003)(2906002)(83380400001)(38100700002)(8676002)(4326008)(8936002)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3RZR2ErZ3ExNEpsOWlJWHRRYUFobDRQSEdobFhLTzRXcjhyRnhCMFE2Y2R3?=
 =?utf-8?B?WFEzeFRvMVVNYmFIbkdGQk93OFJHN0hPNGFtcEh3TDZlMlk0cnFLZThyaE1q?=
 =?utf-8?B?V1NUV1Mwcjl4WThXNkVZK1pESkI5Rjc3WEFmWlZrbUJVMWdqN3pmMThoRDhO?=
 =?utf-8?B?ZG9sUWtoN3gweUx5Ritid3o0NjltN2w1OGVzL0lxaXVMNGd0QmdpYUFFTk4x?=
 =?utf-8?B?VzhvZ0xCQUVIdzFUTTlPYkQwYmhTNDNKWGFCWDc5VXViSHR1MmRGRGE3Rk1t?=
 =?utf-8?B?SEErNnhXM3JkMGlKZStQZkpCU2R2L1lycWoyUjlwd2NUNWs5M01pcUNCV3c2?=
 =?utf-8?B?R3RqY3haa0F3Ni9XV3dBNTdoYUVIZEJCeG9yUHhwYTFvcnA2WnJlZVlKN0F6?=
 =?utf-8?B?VUFHZzFXK252TFppbGJ1NlE4bGZlcnJnUyt1M3JoTE43Tndxc3kvTVdsczJq?=
 =?utf-8?B?R2djOWxGakl3WENhdWU1ZlpINENSYVNHVW1JRVN2RjVONEgvS3NVc2gyTWxX?=
 =?utf-8?B?QVVxUlIzZzdYQjU5ZkhKVlB3dUc0cEpaSHl5L3UrZEJqZEo2aFVkYlJtRWc2?=
 =?utf-8?B?TmQzbVhZd1hQS3diVlNralNUNHFnRE9pRVBhcWJPbWpORjI4TVhNYkt6eVNk?=
 =?utf-8?B?SWhwUXZGUDFQRzBLSjdpUDMrMkkrRkVGeDFzQ2ZyamJob3BTNzNOeit6c2p6?=
 =?utf-8?B?ZHRSTVVlRjlqMDdpcitNbmlrbklRby8wdElqQWFyUkJ0QU9CcTZVYVRYWTRu?=
 =?utf-8?B?SGdtcmgvMkhadm9MdTZNWEdOWURxMGc5MFI0UWxKZ1BvQXliT0JmL3JCL25v?=
 =?utf-8?B?MGsyeEdNT2RnN2dEdE92azRLL0ZyVktYQ0Q4dHBDRTNNeG1yN1RiV0kyRlpZ?=
 =?utf-8?B?QnFsYXFZUFN3NXJjMFptOHA0bjNwN3hXZDRaTU9qVHVoMFM3R2F2eDFCRWxk?=
 =?utf-8?B?YkhQK3VnR0I4bXJlVk05dyszRVg0d0xQQVRwNGxtYUVuUGE3aW5YSVAzN3Fs?=
 =?utf-8?B?V1RXenAyWEhaVWdReXo0NjJFcXUwMk9Mb0hYWnA5MTk1OUhMckZndlh4Rk50?=
 =?utf-8?B?VzV6SFQ1WGd0S1BQS21NK2RTSzJNRzJ6ZjBsU3h4M1FHTHFiSlF1c0dGUTFt?=
 =?utf-8?B?MzZGa2loeU43Mk84ajJHWjY3dUJaTDVwMXNCWWE0UUc4Y1oxUzQ3aVpxRkJ1?=
 =?utf-8?B?WmhqV3JvTTdSSk1UTzFPVkdkK2FyOUVPdjh5dHFmRW4rMWRXRElJM0dXV0gz?=
 =?utf-8?B?cXdDQzMxdzhjUE9yNTRlVXpaZHAvZE1aZVhVNFViL1dLNzhJUkRMbXlodnJ6?=
 =?utf-8?B?bFVER2d3amVNam9Ncmdma25kcjBWU3JobHNOM2NLVkttTUdQZ1lWVlRzYWxO?=
 =?utf-8?B?WE9vNlltNjJFcDhOTTVnRVpodm1Db3dsdDJla005U0pJanlRekpseXc4a1VL?=
 =?utf-8?B?ZjFVVzdTVGxKVFdBZytqTXhJVjB3cURQNUg0by9kTEI2aGpSemx6MnZmcFVI?=
 =?utf-8?B?MzZFNXRzMkdNemdTR0NsdXhZNVhNSWRua2pXR3MyZHJlVWpYeDdrL0NJN1FG?=
 =?utf-8?B?cDZZUTdtQ01qTGVqaW90UzlVNXRnbFg5azZYTlVVMDBrRytENlVaZk92TlNv?=
 =?utf-8?B?U2p2SFpMUkx1ZDRKTFYwd0tFRzU0QlJVLzg4ait4blJWT1BXaG0yTkpZS3hT?=
 =?utf-8?B?UzRQRkZNNnBlTWZtNlR5MjZnVDZsZThnalZPYWxHWmFhN0dPTkxabFJvSzlt?=
 =?utf-8?B?VkZjeHlaSm90Q2JNK0xKZ0x1N2lNQ3pxTU9IS3JIUXcvMkdxd3FIODZBYjAv?=
 =?utf-8?B?cVhweG1LOWZhc0lOeS9lejhNaDBNUHA1NmV1a3NWMlhmaExDVFZsQnd1aFc1?=
 =?utf-8?B?TlNlRlpFQUlLalBIdzNwNkgyaUJQYUJ4Nkc0dTZuYzJ5bW4xNGZkakwzanFF?=
 =?utf-8?B?cjlsWmFWamwwckZCMTZtNlFkaWhIczhSUmdTMzUvMmJZV3NheC9RSmhzRGtR?=
 =?utf-8?B?NEI4V2hwb1VSbjdoc2tpZXdKd1l3a01RMy9EM2pMaFN4bU1IQlFZbDlNRmNR?=
 =?utf-8?B?THNweEh2MmVvNEl5SWllSkFkWmZoLzErdkh0YjB6L0Qwa0dUMEVKdGFnL0ND?=
 =?utf-8?B?UGZhMzdiR1pzcVdFMFNtanRQTFhZOU84OHJ4VXNxNlB0b1BTdFZzdmN4ZExP?=
 =?utf-8?B?REE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae58abc7-173f-417b-5c30-08da7a7d9917
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:08:28.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7dpOYsp9gSYOhZNcqkoRXRdTzkLxbH8Y8/NL4L/F8QP2gPTM5+AYJxlyFnbTLCPy9hGwtUKl/1tGPSNyZJUpGDXemjkrYXUDVNpzr0UKrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100008
X-Proofpoint-GUID: zA1WVeSl5CFeRdqSPaLzH5k6cw--aHrs
X-Proofpoint-ORIG-GUID: zA1WVeSl5CFeRdqSPaLzH5k6cw--aHrs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 09:52 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson wrote:
> > Recent parent pointer testing has exposed a bug in the underlying
> > attr replay.  A multi transaction replay currently performs a
> > single step of the replay, then deferrs the rest if there is more
> > to do.  This causes race conditions with other attr replays that
> > might be recovered before the remaining deferred work has had a
> > chance to finish.  This can lead to interleaved set and remove
> > operations that may clobber the attribute fork.  Fix this by
> > deferring all work for any attribute operation.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_attr_item.c | 35 ++++++++---------------------------
> >  1 file changed, 8 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 5077a7ad5646..c13d724a3e13 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -635,52 +635,33 @@ xfs_attri_item_recover(
> >  		break;
> >  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> >  		if (!xfs_inode_hasattr(args->dp))
> > -			goto out;
> > +			return 0;
> >  		attr->xattri_dela_state =
> > xfs_attr_init_remove_state(args);
> >  		break;
> >  	default:
> >  		ASSERT(0);
> > -		error = -EFSCORRUPTED;
> > -		goto out;
> > +		return -EFSCORRUPTED;
> >  	}
> >  
> >  	xfs_init_attr_trans(args, &tres, &total);
> >  	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE,
> > &tp);
> >  	if (error)
> > -		goto out;
> > +		return error;
> >  
> >  	args->trans = tp;
> >  	done_item = xfs_trans_get_attrd(tp, attrip);
> > +	args->trans->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
> > +	set_bit(XFS_LI_DIRTY, &done_item->attrd_item.li_flags);
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > -	error = xfs_xattri_finish_update(attr, done_item);
> > -	if (error == -EAGAIN) {
> > -		/*
> > -		 * There's more work to do, so add the intent item to
> > this
> > -		 * transaction so that we can continue it later.
> > -		 */
> > -		xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr-
> > >xattri_list);
> > -		error = xfs_defer_ops_capture_and_commit(tp,
> > capture_list);
> > -		if (error)
> > -			goto out_unlock;
> > -
> > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		xfs_irele(ip);
> > -		return 0;
> > -	}
> > -	if (error) {
> > -		xfs_trans_cancel(tp);
> > -		goto out_unlock;
> > -	}
> > -
> > +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> 
> This seems a little convoluted to me.  Maybe?  Maybe not?
> 
> 1. Log recovery recreates an incore xfs_attri_log_item from what it
> finds in the log.
> 
> 2. This function then logs an xattrd for the recovered xattri item.
> 
> 3. Then it creates a new xfs_attr_intent to complete the operation.
> 
> 4. Finally, it calls xfs_defer_ops_capture_and_commit, which logs a
> new
> xattri for the intent created in step 3 and also commits the xattrd
> for
> the first xattri.
> 
> IOWs, the only difference between before and after is that we're not
> advancing one more step through the state machine as part of log
> recovery.  From the perspective of the log, the recovery function
> merely
> replaces the recovered xattri log item with a new one.
> 
> Why can't we just attach the recovered xattri to the
> xfs_defer_pending
> that is created to point to the xfs_attr_intent that's created in
> step
> 3, and skip the xattrd?
Oh, I see.  I hadnt thought of doing it that way, this was based on the
initial solution suggested to the first patch of v1 (xfs: Add larp
state XFS_DAS_CREATE_FORK).  But what you mention below also makes
sense. So I suppose if no one has any gripes then maybe it should stay
as it is then.  Thx for the reviews!

Allison

> 
> I /think/ the answer to that question is that we might need to move
> the
> log tail forward to free enough log space to finish the intent items,
> so
> creating the extra xattrd/xattri (a) avoid the complexity of
> submitting
> an incore intent item *and* a log intent item to the defer ops
> machinery; and (b) avoid livelocks in log recovery.  Therefore, we
> actually need to do it this way.
> 
> IOWS, I *think* this is ok, but want to see if others have differing
> perspectives on how log item recovery works?
> 
> --D
> 
> >  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> > -out_unlock:
> > +
> >  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >  	xfs_irele(ip);
> > -out:
> > -	xfs_attr_free_item(attr);
> > +
> >  	return error;
> >  }
> >  
> > -- 
> > 2.25.1
> > 

