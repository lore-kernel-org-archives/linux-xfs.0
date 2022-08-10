Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423A6C19F2D
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 03:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiHJDI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiHJDIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 23:08:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF347E01B
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 20:08:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0Du5I002273;
        Wed, 10 Aug 2022 03:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uoh6aUc2lsWfoZnoADyc+ABogCwump9Y2JLurnqvnoM=;
 b=2KnhBfTajxtqNlgSrf6LfGqs+IxgaoD9AFV3yDhxRl5uJSBqukXK/N1gFPkVgJNl2RbM
 rA6R+i5l2YIlQKNi+LOCUZyYfoQE2n7txm+dPFEzCbQ4VZKtnZUV1B2vFFCqGLWLn7KE
 GTJnU8LO+ld9f125sejWx8iZuv3Kc7gShbGKS9ww+j6UxPycWiPHDtFPFT6GtHupcLHZ
 3Xqj7g2qT2FZH3TsH1jY4lZPk2pFfDzVA3c3SXceHr+xpy5glUPpUrIi0Eh449AUnyc5
 4aJ1wSZrapFu19tOXHqb0VwbYw0AgG6qNxghirbv9n5RVBcfRkYfnVHAO01UdouFVmdU EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj0nqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:08:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0EWiX005267;
        Wed, 10 Aug 2022 03:08:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhrh82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:07:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOkrftc8C/CIbPj3NPyDw/pY9Kx20anSfOs7NMZxYtFQWQVWTfKr6gzamjviWW4CL7X3RsFo5BbN9NirxyvTsoxHuxt3hG2SavYHTcwsrf1Ph4qBtOieQiMUzYbxfc149+4Rcxt8fniW2/T3R0uIHmT2pKrefM3ysP/LCM0BhpqEnmq3O8Dvix0Sstls3dZKIa+redM8xedTlFyE6amcYZzCd8Jpk6vdu7VXbAAZx05ib52Z8fQxtgmwvjLTltWyxuWyM+MemBbzwqDKfCMTR3nOW8kR9nl3IezT2YH5ip4DaCMljT4TLWQ9H3Uzef0KqajYpjkJFsZ3nFMKn1ROSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoh6aUc2lsWfoZnoADyc+ABogCwump9Y2JLurnqvnoM=;
 b=B2Y7NIf0fnX8g5c1+cKXI7tGN0KXcE9+g27/8MAiEJZipEsyq7MorjkByvDW3iU+KMjpKpWn34Nak6KH8yoYIKozpSNeyRkDPoeFcg9JZnmakRYyOjfoRwNlJ3NdCBunGb8zMP8CdZfllPJ+TzwUl7TLjXUh627S0Ec5CzfASAhoBoRTd7C4V7SaI6/Gtl9myW2+qlpJjFG7e7r+VaT/TmCsBiEUGAGofBK61xw+TEbPEls9BrIX67VOxUzbPKbh44DRgzFoF3FronwP2gb11ywyXvGRalZbYT5HJwXLRLHkYu+budK2cTxq1/oQRGOnD5EPzNqoG5Nj33Cdod9doQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoh6aUc2lsWfoZnoADyc+ABogCwump9Y2JLurnqvnoM=;
 b=uVyJjnIW6exyy6hqSs1o/DYmRk+8ba4WTjyqpsv+vMwFqAIF5hNjaHb8rFJ8hr2gwW9Duo/33tYc9CJu16XyzN2RnZguI4S7BCPqqSCkCqLPjJvQmYnipQ9VZJliftIgS34Z98APIlA++75mqB9vPF2Mx35Ej9aAAZjJV2PidNY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR10MB1627.namprd10.prod.outlook.com (2603:10b6:4:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Wed, 10 Aug 2022 03:07:58 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:07:58 +0000
Message-ID: <b77725bb10e353952f4f9eae8cf3d297c5237cf4.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 02/18] xfs: Increase XFS_DEFER_OPS_NR_INODES
 to 5
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:07:55 -0700
In-Reply-To: <YvKNe10WaSRRPdzf@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-3-allison.henderson@oracle.com>
         <YvKNe10WaSRRPdzf@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:254::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbccb430-8124-4299-b3bf-08da7a7d86f8
X-MS-TrafficTypeDiagnostic: DM5PR10MB1627:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43K66VGblAZ9AypggadpBrQic+4Hh+zGULCCu6KcnrGJCL1CwC3jJbM+2S8apg+m4/BQ0iSUvUc9g7zbcdah8+h6MbEsoc9740pDuoAVNeJAL9nkq57KF7Jayt+0eE8KZ8oiXHiSy4p2IeWih5F0QzfxMCMAW54mMaU5eb9gP2BHx3IVyTW7B0MankSx2F7APwKoq+WIEtT5qnMjCQbRClk0X3Dxc6m72JAQMqrs+zeYSldVW9fF4E45k/9+A81i0A8M17K4ZH8RKjaq9zg5EOqzQNeq21ivyC2zCqz9TvhKHbWntn4H/HlbnJuLC7zm33Fvn10NEhE0MxCoAikPXmX1VfnUzAJhwx3jCyh6UCKqAyzkxyOHlBNn8uUBR0luNyVZkSKg81PXV2Fu3PZfH384sCS2BMXvdvm9wDRnVcd8Ab+lYLk6dfTY4hO0uvxlhfH2ZIiiQTHrcz7m6DwwO65gCvu9WvRx06rrtbXyrFXOkK/PhJRaEI1NWYHzIhozY8+RdDFXRst4555nCTAJyVnjHOEt+M74Y58lB5z+IF68kuV/P+q1V6Xu+/B3MlwyUe3I8fqMvL6gJ94+Oy0PllJgqMKgtVkkTQ1KUrMw409RqWzdsTK9o/chPH5pl8R1Thi/wadPerrx7DPcOtXYWtm3Japi76aHzSbiK/uG3Nxn55J9q3tV7iTxK4qqBwUO2lnF4NKz3UZnP/N0t7WSjqpwsWhmlGUP39mUprtl98MwtJl/RltWcXSlG0rvu3F9Rl3fIxhG0Tg6M0k5m0G5a9eD07T2mTDv2g04oUOpD3k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(366004)(39860400002)(346002)(136003)(6512007)(2616005)(186003)(5660300002)(478600001)(6486002)(26005)(66556008)(52116002)(66476007)(6506007)(66946007)(86362001)(6666004)(41300700001)(36756003)(2906002)(83380400001)(38100700002)(8676002)(4326008)(8936002)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2hJczFuZDNDMnhFd0UxVWwwQXRvZlNuR2hkOXY5YlIxQURpY3lxc0VwRGY3?=
 =?utf-8?B?ck0vL21qaVZnUEZJWjY5WkNIaDdkMitjTDh5Rzl4b2dkSEhBQ3lUWnI3Uk5n?=
 =?utf-8?B?ZklzMUxNZldFWUZYc2VDRUx2YnQwMDk5R3BCR01UZEpXKzBXbTVLeXZ2eEFQ?=
 =?utf-8?B?ZFlsY3RTY29vRzNTTldVMWluZkEwVGt3R04xVy9peVFGN3BUNEVMTlhpK0ti?=
 =?utf-8?B?Nnc5ZTV5U1BRNVlYbU1wcS9JcW1zZlQ2Z2YrZ2MvZ1pCcE9iaDJsVGpsempJ?=
 =?utf-8?B?L1duT3R4T3I1NHpuT2tUSGtUT3drcXJrZGRhMEE4THJhdTlHR1BzYzkveGRt?=
 =?utf-8?B?azZhcm9SdEVoOUhvWFE2MlhtYkJTLzdwN3RGNEkyRDlqUlZjZTJMd3BFSWdo?=
 =?utf-8?B?VmVRRklpV2lxZktnelRVMldBZ2ZtTFQyZm5MaVc1UDI1dHNZQzNyb0VPSHFL?=
 =?utf-8?B?Y0V4ekMrWnVZNHpZbkZHZ3pHTjAwYVAvZFJrMUlQVjAvZVF6aldQRzVIYTJk?=
 =?utf-8?B?aERacEFVSlRoWEJUMzdJbjRzZHhKcklqMFdVZnZvZk5uVk5CdE02OUpmMHU5?=
 =?utf-8?B?MzZGRnJ2SWdnQkV3TXIvaDJmbHB1MFFwU2g1aldoNzBoL2d6bGl6RVFJSG1F?=
 =?utf-8?B?clZmOXJvM3NUZUlOSW9EdGZ4VmxKY1pWMFc1L3NZb0xwekRkdVkrU3NQcGFv?=
 =?utf-8?B?amp2QXppNkV5YXY1a2xWeWpiNTFTOENxd3hXK1NVR01wanl3WjVhQi9WVVFv?=
 =?utf-8?B?dmREc0F1ZjlFMjZ0OXdDRmFKT1o3Nk12RDJqZEZBQ0w0d2I1dHMyNStqZ3pM?=
 =?utf-8?B?ODUrSnNLeHBFZ0dZM2MvTFRVWm1kTTBVaHE0a1ZSSTBDNnAvTUEwbFcvN1c0?=
 =?utf-8?B?cmZtNEN3Ni9JbGl4M2pkellITlFyblZnYkR0S1AvL1laV2w1K2VkWU9jelpF?=
 =?utf-8?B?SU5FaUgrZ0VINXRUTWhsejVYbGNUNlNBQlRxOTZSaXZrek1LZnJRZjVVR0dM?=
 =?utf-8?B?YWIyWCtrWFVpenVUb0U2UDB6SVJKWHZvZHdTYURXRWxwbU0zUGlQdEdEQzdM?=
 =?utf-8?B?d2prNVU0S0IzQXkySGxTNlpwTU5DT3UrRDhpbnB3TDZaeVNhalBVWWRRek1L?=
 =?utf-8?B?dC9Jdm1MbTdrRGNucDRaSWRsVWoxUDNySFdqNXBKdkNuSXVCdGJZVDdUWFph?=
 =?utf-8?B?WHdIYnhFcTIvNUMwd0djbHNTSEFxNThHYjQ4NTc3dk92Vm9hT3ZEZ24yVzNS?=
 =?utf-8?B?MHpBL1JxTWgremtJY1ovUGNIWTBqV291b0c0R0ZsU2UyUTFDMUQxaitYK0pL?=
 =?utf-8?B?TnA4VkdkVDM5NGQwbXhyOVNzZEZjaGNxRTczSVVlNHF0WW1WM2tFVkQwdUZS?=
 =?utf-8?B?dy9JZmRZUVZxRmhNWkxHM0hBR3ZUT09PNndIRWgzYWxMSVdNcGd5cDEzTGJa?=
 =?utf-8?B?Sk1QQ0FWVkM4UmtUcDg4TVAwUDlzL2lzd3drVFpVcVV0dklFdmFhNVcvZjBH?=
 =?utf-8?B?blBuTHlmTkpGVlhWYWs3Ykl2ZnlVeENHSWpza3QySWlJajNvMWpkWFM2YXdk?=
 =?utf-8?B?L2s1OXNDRXRkTmNud25oQ0pycjdTTHlwQ2lkcVJPUHRsajNFV1dDZWtPRDVn?=
 =?utf-8?B?SFgxVlZLcVRjVnQwTlFtVTIvOWhZOGRGYTkxL1JqUFlqS3ljeGtVS2Vyci8y?=
 =?utf-8?B?QnpKaFNzY2NLRmt5NFBhN29VaTNNT3JFWmt4ZWU3bVJGTWQ5Q2IwQWVCZDJv?=
 =?utf-8?B?M1JOOFp4MHNMdGhmKy8ydWs2SG9hakwzY01ONUF6OEdpZSsrbmdzRmxyMUd4?=
 =?utf-8?B?SndqSW9yencvc1dVUHQzaXFMd2RGM2xyT0ZUa21qSEpZZ0RIZ2wzS3F1MWEy?=
 =?utf-8?B?dSt1WUlSaVdiRVlCNFpLVnA3bDhkVGVaazdJckRjWlRDeDdLTFR3b3ZHNVdP?=
 =?utf-8?B?aG5Da3U4Yk0rRUt4R0JUeGpUMkdJaC9tUU9lcit6dW1SdTBKUkdkcTd0Z1M2?=
 =?utf-8?B?NHRicXRIUnMxZzJxTnBqTFFFMzBnSXhpN2QwOWduUTdkMmNCVXlsb3gvdHVQ?=
 =?utf-8?B?V0JGSGhMWjNZaEV1QjlPV25ZUnpreTY2ODJkM2gwUjA1ODFBb3N2ZDk4VHI1?=
 =?utf-8?B?U3lRMnpWUlJ4aVM3RHZhdC9Nc1VtajRlN0kzZEJGZElWWjJDckxrcGZIbGlK?=
 =?utf-8?B?S1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbccb430-8124-4299-b3bf-08da7a7d86f8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:07:58.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ce1nTQysIQecYDb/sbDpI1DPi5TIBw3JpE0JI5jM5sycxwIp3By5Dnah24NxOKuO4z4vgH/iSB9Yapdvn3vW3XERVyXlmGd9KvForJLcBBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1627
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100008
X-Proofpoint-ORIG-GUID: vuxSmLKAuNpFc1XnNcDzgvoLCQe5OVmo
X-Proofpoint-GUID: vuxSmLKAuNpFc1XnNcDzgvoLCQe5OVmo
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-09 at 09:38 -0700, Darrick J. Wong wrote:
> On Thu, Aug 04, 2022 at 12:39:57PM -0700, Allison Henderson wrote:
> > Renames that generate parent pointer updates can join up to 5
> > inodes locked in sorted order.  So we need to increase the
> > number of defer ops inodes and relock them in the same way.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 28 ++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_defer.h |  8 +++++++-
> >  fs/xfs/xfs_inode.c        |  2 +-
> >  fs/xfs/xfs_inode.h        |  1 +
> >  4 files changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 5a321b783398..c0279b57e51d 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -820,13 +820,37 @@ xfs_defer_ops_continue(
> >  	struct xfs_trans		*tp,
> >  	struct xfs_defer_resources	*dres)
> >  {
> > -	unsigned int			i;
> > +	unsigned int			i, j;
> > +	struct xfs_inode		*sips[XFS_DEFER_OPS_NR_INODES];
> > +	struct xfs_inode		*temp;
> >  
> >  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> >  	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> >  
> >  	/* Lock the captured resources to the new transaction. */
> > -	if (dfc->dfc_held.dr_inos == 2)
> > +	if (dfc->dfc_held.dr_inos > 2) {
> > +		/*
> > +		 * Renames with parent pointer updates can lock up to 5
> > inodes,
> > +		 * sorted by their inode number.  So we need to make
> > sure they
> > +		 * are relocked in the same way.
> > +		 */
> > +		memset(sips, 0, sizeof(sips));
> > +		for (i = 0; i < dfc->dfc_held.dr_inos; i++)
> > +			sips[i] = dfc->dfc_held.dr_ip[i];
> > +
> > +		/* Bubble sort of at most 5 inodes */
> > +		for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
> > +			for (j = 1; j < dfc->dfc_held.dr_inos; j++) {
> > +				if (sips[j]->i_ino < sips[j-1]->i_ino)
> > {
> > +					temp = sips[j];
> > +					sips[j] = sips[j-1];
> > +					sips[j-1] = temp;
> > +				}
> > +			}
> > +		}
> 
> Why not reuse xfs_sort_for_rename?
Initially I had looked at doing that, but it would need some
refactoring as it is not meant for an arbitrary number of inodes.
Either some logic specific to rename would get pulled up, or we'd need
another helper to repackage the parameters, but it's such a small bit
of code, I'm not sure it saves much LOC either way.  

> 
> I also wonder if it's worth the trouble to replace the open-coded
> bubblesort with a call to sort_r(), but TBH I suspect the cost of a
> retpoline for the compare function isn't worth the overhead.
Yeah, it would make sense if there was lot of other places we sorted
inodes, but with only two callers it does seem like a bit much.

I am fine with what ever method folks prefer tho.

> 
> > +
> > +		xfs_lock_inodes(sips, dfc->dfc_held.dr_inos,
> > XFS_ILOCK_EXCL);
> > +	} else if (dfc->dfc_held.dr_inos == 2)
> >  		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0],
> > XFS_ILOCK_EXCL,
> >  				    dfc->dfc_held.dr_ip[1],
> > XFS_ILOCK_EXCL);
> >  	else if (dfc->dfc_held.dr_inos == 1)
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index 114a3a4930a3..3e4029d2ce41 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -70,7 +70,13 @@ extern const struct xfs_defer_op_type
> > xfs_attr_defer_type;
> >  /*
> >   * Deferred operation item relogging limits.
> >   */
> > -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> > +
> > +/*
> > + * Rename w/ parent pointers can require up to 5 inodes with
> > defered ops to
> > + * be joined to the transaction: src_dp, target_dp, src_ip,
> > target_ip, and wip.
> > + * These inodes are locked in sorted order by their inode numbers
> 
> Much inode.  Thanks for recording this.
Sure, thx for the reviews!

Allison
> 
> --D
> 
> > + */
> > +#define XFS_DEFER_OPS_NR_INODES	5
> >  #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers
> > */
> >  
> >  /* Resources that must be held across a transaction roll. */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 3022918bf96a..cfdcca95594f 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -447,7 +447,7 @@ xfs_lock_inumorder(
> >   * lock more than one at a time, lockdep will report false
> > positives saying we
> >   * have violated locking orders.
> >   */
> > -static void
> > +void
> >  xfs_lock_inodes(
> >  	struct xfs_inode	**ips,
> >  	int			inodes,
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 4d626f4321bc..bc06d6e4164a 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -573,5 +573,6 @@ void xfs_end_io(struct work_struct *work);
> >  
> >  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode
> > *ip2);
> >  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode
> > *ip2);
> > +void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint
> > lock_mode);
> >  
> >  #endif	/* __XFS_INODE_H__ */
> > -- 
> > 2.25.1
> > 

