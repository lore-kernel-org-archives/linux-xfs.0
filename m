Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFA9C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 18:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiHXSrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239586AbiHXSr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 14:47:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C37AC36
        for <linux-xfs@vger.kernel.org>; Wed, 24 Aug 2022 11:47:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OI41DC009390;
        Wed, 24 Aug 2022 18:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=a2vIQYt6NyssBl+Qdvv1uGik+ciflE+MmMgaaBA7Ct8=;
 b=f0F87+EmWUqIqQog47PRHjnvCv8zM3ZSf30pjvzgLEHbSc6DM/c+Tw6XFtX8hSiSM2y/
 14hElJsNOTGAgJgyYLXu2a5BXTbhLRsmcqPwQxKnutlt3nOhU0na9EFMWNJT4JqUOX/0
 u4Q41A5YPYPH2ULUEeA35xU0Odh25C7irWiSxVzoR7AOiUheQ2DBPDMPbSogKtfP7+o2
 2ucfPXavfNtbwbsv4xehBZNSTvj79WUYtXdp7Krrr2hu7K81X8Ys7ERU+shRleWHzwIA
 DTYMLS8jWmC5MuMiIbp/qVln9c2kV086tMdOdjZ74EuZUnGfk3P0SGFwbveld2N+Rxnn tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww25de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 18:47:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27OHBwHf011126;
        Wed, 24 Aug 2022 18:47:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n6kw37h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 18:47:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc/Lwhwi0+HpvCwFoikD7LhZZZY7aTzmuXMR6MG2eomGrqtm5bm7epHkzO7x8Juoik1xEp7xzeRJIEiMYqXx6l1L6u+s8MwsBvQJzJuqUvCYl3Bpn884vQTfNOBUvVEm6eOIED0PP0G7onXHb+PJhK22FBdqRtgqjqoHezXDssSXDVyYGJ64ETSvd/6E1DS4eji0IhbvYemhSyqjK5ntWVB8T6XyTMnWz3IG5OyTTQgqvlDLWOxr1OZxxY4J4vO5ZOuB3k10R8FI202Vy9poURjZtKQ4sP+c4BCBXSKjJJtVncsVOIfTycUGgedZDuLpwxouNA3pLjpYjSI/D/BFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2vIQYt6NyssBl+Qdvv1uGik+ciflE+MmMgaaBA7Ct8=;
 b=kRcYafCp0MXvYFg7kfzHyHzEgWy4qfK4//xZ3fB4QVXiOjShPUbN8Gj04GwqhUVedgKDWcs1J+V2GBmNZ1j7gHfkHw6lPgFivAqcRCTyCPsJSv2joxwgCWr00NQ4mAdJFo0y2P0IhLikm9U3aHajqEnX75J/dXAxaDdD0VByRfPllXn8W1bzAt4Z/tXtbU5gpl60fLZeAX91p8wc426fQrxGzzDuRwSCq24wU1xYRABq+NY0vMejZjzRTqCtdzXG/VWdrAf9yuSeYldgHXcZ8oCHwPVD3k3cvqmVbW2q3SgbFN5zwJHliX2rLfDc9ZQKzDXGC167u8+FI9H/k0LC/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2vIQYt6NyssBl+Qdvv1uGik+ciflE+MmMgaaBA7Ct8=;
 b=czu7U9JgVCveIW/WQK+PKTg51EJv6ix3gmy9ejCpY+Lm3GutK/71uAh29o1yLs8j756YnJicnNHmVX9md8k4fRBp/Ejccos0XO5wkfSj8011kMc8iIOiCq2v91dRphAL3cNXyQ7tlD+PQWUC8BpaqnJe5cKSsRRQxtdcGZKF0r4=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BYAPR10MB3126.namprd10.prod.outlook.com (2603:10b6:a03:15c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 18:47:17 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::e87f:b754:2666:d1c8]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::e87f:b754:2666:d1c8%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 18:47:17 +0000
Message-ID: <f212e83a973b5a8d888366777f03d3b3c83a0a06.camel@oracle.com>
Subject: Re: [PATCH] xfs: Add new name to attri/d
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 24 Aug 2022 11:47:15 -0700
In-Reply-To: <YwTx+k8G4IijFDRA@magnolia>
References: <20220816173506.113779-1-allison.henderson@oracle.com>
         <YwTx+k8G4IijFDRA@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bb47e81-6ef1-4da3-4b23-08da8601113e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gc2hJcU7gs758SzFMroSnWCGe5vr7iMS70pEdxYfO7lGg4j8M5IvkFd2HzA61ztiHmqIaqvF5NHZy6nYe3VuNLQNZ2HnR/AEerzPpEc8QtTDGoVqlKDuQzOojg+lwHXZK8jcvUst9e4E1jqVN9/PYGe+DbEGjy7bQpyXST6KUu4E8vfMFrm4TM12mfKo3vu+h5YOeDVw26sW381rOR6D4UnVg1xcs+2o5ZYixAg4fOQq+2jh0XHPdiCXIJYRQFDO9CB/nyyiZ92Hcj4aJwpV9zjbYdqdK5zyZ874PmnOY92V7yyAhc7yCnmwoea/QoBQegcTnYC7sz1qoMJMgI4dGo1ffiemxPeBS1Z7YQ3QgZ28r8YO0ETw8E/LpZav+ehB1JhFC+qMuUW7pG9ja73c7pyZSxrsr0n2jWUXnH3C8TkzYHG79eHfs+PXs/U2Ql0U445624PNj/DuFJIXWvcVqvzM8/SCvA4jm8YPEGWTbgXjRADYf0btVaLSgsDD/A2wQNI0mx30qh9XK63CebhYE56chXqdXsc/CHdVrDk3dFVWzNwxrZclFwme6Y8TPZqe2dg4xkgV/beKTS6WWiB4K90nLK3UISQf7FQj9L9xpS6gX5zQmZe5kZAu/GtjisvfRE/wZYcRNcMoIORsUU8Fu5mazoyf17e8QuelHyvoBhycVtPRFRR+u4fZC4xB9xjeIvEijLpwueoNepdoBEunyFpgnr0a15j9hRQNbvNwu9INhjzPZ4NGWgLz3yvZIF31D+w3cHX8E7eIKHNqfxCQQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(376002)(366004)(136003)(86362001)(38100700002)(38350700002)(8936002)(2906002)(41300700001)(8676002)(6916009)(66476007)(66556008)(66946007)(316002)(30864003)(6486002)(2616005)(186003)(83380400001)(5660300002)(478600001)(6506007)(6512007)(26005)(52116002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZitQNHZ5MjFHWWxiYnArRE1DNzdZaytscmg1LzExK0NRem1FM0NBbUlmdVhW?=
 =?utf-8?B?djVUZ1hPeVZjM2ZqSUF3SnBieC9YaGMrTXBmejdnVTNtM1FzdHBHRzZlRzNC?=
 =?utf-8?B?YVd2bEZuZ09LTG5lUElaQnFXWjFvZWFRWHZ1dEJsbllPQ0lMbHpVeWZDSXJS?=
 =?utf-8?B?TlMyN05oSmF2WjBtSXErUjJMWUVtNVVuV000WkNwelhqNmQ3Z25QYW05bkY1?=
 =?utf-8?B?Q0dlZ3NXSkVwVDJoMkgyTDZsR3laNHhSaHNJTm1WMXBKRnhFenBtMXJ2ZTFW?=
 =?utf-8?B?OEd5d0daTWhDMmcrOUh4ZkNqMFBtaFZPaDJFVG1VMXRwYmNHeDBsMXcrKzFx?=
 =?utf-8?B?MFcrdWRicHg0Tk1Bckh2RUxhV3NISXo3TXV1QnZOQTA0aUJCb2FBUDlGM0t4?=
 =?utf-8?B?b2V1dnkyby9KWnZuZURUMmxSNGFNekJodWNwdHhRUEFZV2tySTAxbVZVcE4z?=
 =?utf-8?B?NW1KeFJWSG9qK29mZ3NjSGVIbm5qMmhnajFXdk95a2JLRHM2bitCQlE0NjJk?=
 =?utf-8?B?djZqV3Z5WVBNVmR2Umh1ZFhwcDhIK0NQVVZkbWFWN1pMTWZ2QWF2a2w2MkUv?=
 =?utf-8?B?V3hQRXpYcXk2Y2JONXI5SUVvUm56NXI3L3pGT2NsaEtzMU9GQ3BiR2ptM3R2?=
 =?utf-8?B?Nkg3MDlGQlpQcTdRamdzdG9KaElkSFRzWlRJdGhGNCtqQ2RMcTZ5WnExTEto?=
 =?utf-8?B?ZFp6cEs2Q0s0YUlOYkJiRUhoY3ZyWVpQWnpMd1FzQ3dPZUpmRmFpWDJITnhG?=
 =?utf-8?B?QUE3Q3AvRjJDd3BKQm4ranVGcEYwc3IyNVBEb1BZNU1vc21oazBwWDhpOW4x?=
 =?utf-8?B?aFV6a0ppL1hTNUxpbTRpZSt3YUlNamhQQnkrbTREMWtxOWtIZGFWa2ZwVDBt?=
 =?utf-8?B?eHpvRmhsUDNodkFmelRZYnBiMTlXOU9WUm9hTHJsWFFIdkpEWWNOcXdsczlH?=
 =?utf-8?B?RjRoV043S21XMXhnYjlxVTFMbzFteHpMNSt6azVrY2czNHVEUTd5OWZkT2tT?=
 =?utf-8?B?LzIvYlE1aTg2ejVjV1c5K1dRMHBiYjNNYUo2VVNkYktyai9pVTVuRmI5ekts?=
 =?utf-8?B?a3hiUjRrVkd2MCtNeSs4ZDJvNW5GNm9RL1JBM2d3ZlJsZnl3SHRWUUpUc3kz?=
 =?utf-8?B?VGtUc3NYemY2SWRiRU9aN3ptaDNhUFJ6RzAxTE9EUVdsYlQzblZEdWNZMmVk?=
 =?utf-8?B?SzcxVFphODhJTFk2bHR0NzU1QlRVb1QxUmlNcERMa3NBZktXUGRtRURrMmIr?=
 =?utf-8?B?OGlSMXluM3pRNHhSZlFCQlhKSEVNWlcrV1JVd3NlWFdreW9HekpBdHZYTzht?=
 =?utf-8?B?b051czgxMGRJd2YvMlN4eVdKTjhNL1IyQUZSN29IWGxSelVya01ENEtFNFVj?=
 =?utf-8?B?M3dIZm1YVDFTbldtOXVHMTVmRnhjMG5Fc1BkenZSQVB6M20vTHh3VXZqaitM?=
 =?utf-8?B?emx0OUJnK09Dd1JyeFhyQTlNNlRmbVlpMEZRcWZaaHJISmUyMWQ0QlljUE82?=
 =?utf-8?B?alhnMko1aVFxek1JSmJDUDNxUkFwQy9LOWExNzM1QnBURUxFRmFRTnpWZStj?=
 =?utf-8?B?VWhUMFlLWEk0SWpQQWRDT3RiY1JWOUdtQ092SVJxOXdlNUhjMHJtTWxmcHI2?=
 =?utf-8?B?UGxBeXE5djlLWlVqMDh0U3U0NnFQWjNqUDVzc0orMVhJZDlSKzZWK250ZElv?=
 =?utf-8?B?NFlYeVZNTGFud0lSdnZUU3daTDVDV2JnSjNHYnFnbGRGb2xiSjN5WkJRWFdX?=
 =?utf-8?B?NElqa0FsZllyaDZnSTBrYTJDem8rU1d1UGJIT1c0RTJHWnJybGtqMDgxc3ln?=
 =?utf-8?B?SWtWM0lwbVNtY2tKREVPV1Zsb0xJdjZ5TTV6c2VjQmRsUkVNQytEc2NKdXZp?=
 =?utf-8?B?L2J6M0lIeUFrd2RVMERhMDYwd0t6UmVNcWhEbXRKRGNMMFB2d3pnc2RSbEdC?=
 =?utf-8?B?RnQxOTk0YmFlZTNoTDVBRHNGVHliSHpUOEZIWE81VkpnNlJpV0ZKMmo1NS84?=
 =?utf-8?B?L25xSkxvNjNmUWVSNkU1cklOejUwYzlsMTRiTUFoREpOTURDQjNhUWhpQUpS?=
 =?utf-8?B?VXM0d0dLSFo4TWlXR1dvOXdZeEtUa1M3cmxEMlVpcWs3dzVXNHFRR05FTUNo?=
 =?utf-8?B?d0IyVFlqUzdVN2QxdjFzNnN3cFlQQjBtMTErcmw5cUEvc2Q1QmM4bS9KcHRL?=
 =?utf-8?B?QlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb47e81-6ef1-4da3-4b23-08da8601113e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 18:47:17.0305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 64OVu4BBXuF8XBAZnDPykpElb2Y5rU/3fjZvUHz8nhxggvtC/Xu5cbiFjgRLYUcT3H3aD/9fzR97wa+IQhLDpQfS7SEHJTkLJVS22bMCEyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_11,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208240069
X-Proofpoint-GUID: en5wd7In5MOlwTDjMoo_HoIBTdIOwbjk
X-Proofpoint-ORIG-GUID: en5wd7In5MOlwTDjMoo_HoIBTdIOwbjk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-23 at 08:27 -0700, Darrick J. Wong wrote:
> On Tue, Aug 16, 2022 at 10:35:06AM -0700, Allison Henderson wrote:
> > This patch adds two new fields to the atti/d.  They are nname and
> > nnamelen.  This will be used for parent pointer updates since a
> > rename operation may cause the parent pointer to update both the
> > name and value.  So we need to carry both the new name as well as
> > the target name in the attri/d.
> > 
> > As discussed in the reviews, I've added a new XFS_ATTRI_OP_FLAGS*
> > type: XFS_ATTRI_OP_FLAGS_NRENAME.  However, I do not think it is
> 
> How about "NVREPLACE", since we're replacing the name and value?
Sure, sounds reasonable to me.

> 
> > needed, since args->new_namelen is always available.  I've left the
> > new type in for people to discuss, but unless we find a use for it
> > int the reviews, my recommendation would be to remove it and use
> > the existing XFS_ATTRI_OP_FLAGS_RENAME with a check for
> > args->new_namelen > 0.
> 
> I think it's worth the extra bit of redundancy to encode both a new
> op
> flag and a nonzero new_namelen.  xfs_attri_validate probably ought to
> check that alfi_value_len==0 if op == XFS_ATTRI_OP_FLAGS_REMOVE.
> 
Alright, will add a check there

> Also -- should xlog_recover_attri_commit_pass2 be checking that
> @item->ri_total is 2 for a REMOVE, 3 for a SET or REPLACE, or 4 for
> an
> NRENAME operation to make sure that the number of log iovec items
> matches what the log item says should be there?
I suppose it wouldn't be a bad place to add a check for that 

> 
> I /think/ the log recovery code already sets item->ri_total to
> alfi_size, and won't recover the item if it doesn't find that number
> of
> iovecs?
I'm pretty sure it does, I seem to recall running into that while
trying to get the recovery routines working the first time

> 
> > Feedback appreciated.  Thanks all!
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       | 12 +++++-
> >  fs/xfs/libxfs/xfs_attr.h       |  4 +-
> >  fs/xfs/libxfs/xfs_da_btree.h   |  2 +
> >  fs/xfs/libxfs/xfs_log_format.h |  5 ++-
> >  fs/xfs/xfs_attr_item.c         | 71 ++++++++++++++++++++++++++++
> > ------
> >  fs/xfs/xfs_attr_item.h         |  1 +
> >  fs/xfs/xfs_ondisk.h            |  2 +-
> >  7 files changed, 81 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index e28d93d232de..9f2fb4903b71 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -423,6 +423,12 @@ xfs_attr_complete_op(
> >  	args->op_flags &= ~XFS_DA_OP_REPLACE;
> >  	if (do_replace) {
> >  		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
> > +		if (args->new_namelen > 0) {
> > +			args->name = args->new_name;
> > +			args->namelen = args->new_namelen;
> > +			args->hashval = xfs_da_hashname(args->name,
> > +							args->namelen);
> > +		}
> >  		return replace_state;
> >  	}
> >  	return XFS_DAS_DONE;
> > @@ -922,9 +928,13 @@ xfs_attr_defer_replace(
> >  	struct xfs_da_args	*args)
> >  {
> >  	struct xfs_attr_intent	*new;
> > +	int			op_flag;
> >  	int			error = 0;
> >  
> > -	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE,
> > &new);
> > +	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
> > +		  XFS_ATTRI_OP_FLAGS_NREPLACE;
> > +
> > +	error = xfs_attr_intent_init(args, op_flag, &new);
> >  	if (error)
> >  		return error;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 81be9b3e4004..3e81f3f48560 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -510,8 +510,8 @@ struct xfs_attr_intent {
> >  	struct xfs_da_args		*xattri_da_args;
> >  
> >  	/*
> > -	 * Shared buffer containing the attr name and value so that the
> > logging
> > -	 * code can share large memory buffers between log items.
> > +	 * Shared buffer containing the attr name, new name, and value
> > so that
> > +	 * the logging code can share large memory buffers between log
> > items.
> >  	 */
> >  	struct xfs_attri_log_nameval	*xattri_nameval;
> >  
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> > b/fs/xfs/libxfs/xfs_da_btree.h
> > index ffa3df5b2893..e9fb801844f2 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.h
> > +++ b/fs/xfs/libxfs/xfs_da_btree.h
> > @@ -56,6 +56,8 @@ typedef struct xfs_da_args {
> >  	struct xfs_da_geometry *geo;	/* da block geometry */
> >  	const uint8_t		*name;		/* string (maybe
> > not NULL terminated) */
> >  	int		namelen;	/* length of string (maybe no NULL)
> > */
> > +	const uint8_t	*new_name;	/* new attr name */
> > +	int		new_namelen;	/* new attr name len */
> 
> I think the pointers and ints should go together to compact this
> structure, and possibly that the da_args should get its own slab for
> faster allocation.  Neither of those cleanups should be in this
> patch.
Alrighty, I will re-arrange this and take a peek at args slabs for
another patch.

> 
> >  	uint8_t		filetype;	/* filetype of inode for
> > directories */
> >  	void		*value;		/* set of bytes (maybe
> > contain NULLs) */
> >  	int		valuelen;	/* length of value */
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index b351b9dc6561..8a22f315532c 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
> >  #define XLOG_REG_TYPE_ATTRD_FORMAT	28
> >  #define XLOG_REG_TYPE_ATTR_NAME	29
> >  #define XLOG_REG_TYPE_ATTR_VALUE	30
> > -#define XLOG_REG_TYPE_MAX		30
> > +#define XLOG_REG_TYPE_ATTR_NNAME	31
> > +#define XLOG_REG_TYPE_MAX		31
> >  
> >  
> >  /*
> > @@ -909,6 +910,7 @@ struct xfs_icreate_log {
> >  #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the
> > attribute */
> >  #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
> >  #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> > +#define XFS_ATTRI_OP_FLAGS_NREPLACE	4	/* Replace attr
> > name and val */
> >  #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags
> > type mask */
> >  
> >  /*
> > @@ -931,6 +933,7 @@ struct xfs_attri_log_format {
> >  	uint64_t	alfi_ino;	/* the inode for this attr
> > operation */
> >  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove
> > */
> >  	uint32_t	alfi_name_len;	/* attr name length */
> > +	uint32_t	alfi_nname_len;	/* attr new name length */
> 
> As I said in the other thread, this new field should replace
> alfi_pad,
> for no net gain to the structure size.
> 
> >  	uint32_t	alfi_value_len;	/* attr value length */
> >  	uint32_t	alfi_attr_filter;/* attr filter flags */
> >  };
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 5077a7ad5646..40cbc95bf9b5 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
> >  xfs_attri_log_nameval_alloc(
> >  	const void			*name,
> >  	unsigned int			name_len,
> > +	const void			*nname,
> > +	unsigned int			nname_len,
> >  	const void			*value,
> >  	unsigned int			value_len)
> >  {
> > @@ -85,7 +87,7 @@ xfs_attri_log_nameval_alloc(
> >  	 * this. But kvmalloc() utterly sucks, so we use our own
> > version.
> >  	 */
> >  	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
> > -					name_len + value_len);
> > +					name_len + nname_len +
> > value_len);
> >  	if (!nv)
> >  		return nv;
> >  
> > @@ -94,8 +96,18 @@ xfs_attri_log_nameval_alloc(
> >  	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
> >  	memcpy(nv->name.i_addr, name, name_len);
> >  
> > +	if (nname_len) {
> > +		nv->nname.i_addr = nv->name.i_addr + name_len;
> > +		nv->nname.i_len = nname_len;
> > +		memcpy(nv->nname.i_addr, nname, nname_len);
> > +	} else {
> > +		nv->nname.i_addr = NULL;
> > +		nv->nname.i_len = 0;
> > +	}
> > +	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
> > +
> >  	if (value_len) {
> > -		nv->value.i_addr = nv->name.i_addr + name_len;
> > +		nv->value.i_addr = nv->name.i_addr + nname_len +
> > name_len;
> >  		nv->value.i_len = value_len;
> >  		memcpy(nv->value.i_addr, value, value_len);
> >  	} else {
> > @@ -149,11 +161,15 @@ xfs_attri_item_size(
> >  	*nbytes += sizeof(struct xfs_attri_log_format) +
> >  			xlog_calc_iovec_len(nv->name.i_len);
> >  
> > -	if (!nv->value.i_len)
> > -		return;
> > +	if (nv->nname.i_len) {
> > +		*nvecs += 1;
> > +		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
> > +	}
> >  
> > -	*nvecs += 1;
> > -	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
> > +	if (nv->value.i_len) {
> > +		*nvecs += 1;
> > +		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
> > +	}
> >  }
> >  
> >  /*
> > @@ -183,6 +199,9 @@ xfs_attri_item_format(
> >  	ASSERT(nv->name.i_len > 0);
> >  	attrip->attri_format.alfi_size++;
> >  
> > +	if (nv->nname.i_len > 0)
> > +		attrip->attri_format.alfi_size++;
> > +
> >  	if (nv->value.i_len > 0)
> >  		attrip->attri_format.alfi_size++;
> >  
> > @@ -190,6 +209,10 @@ xfs_attri_item_format(
> >  			&attrip->attri_format,
> >  			sizeof(struct xfs_attri_log_format));
> >  	xlog_copy_from_iovec(lv, &vecp, &nv->name);
> > +
> > +	if (nv->nname.i_len > 0)
> > +		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
> > +
> >  	if (nv->value.i_len > 0)
> >  		xlog_copy_from_iovec(lv, &vecp, &nv->value);
> >  }
> > @@ -398,6 +421,7 @@ xfs_attr_log_item(
> >  	attrp->alfi_op_flags = attr->xattri_op_flags;
> >  	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
> >  	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
> > +	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
> >  	ASSERT(!(attr->xattri_da_args->attr_filter &
> > ~XFS_ATTRI_FILTER_MASK));
> >  	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
> >  }
> > @@ -439,7 +463,8 @@ xfs_attr_create_intent(
> >  		 * deferred work state structure.
> >  		 */
> >  		attr->xattri_nameval =
> > xfs_attri_log_nameval_alloc(args->name,
> > -				args->namelen, args->value, args-
> > >valuelen);
> > +				args->namelen, args->new_name,
> > +				args->new_namelen, args->value, args-
> > >valuelen);
> >  	}
> >  	if (!attr->xattri_nameval)
> >  		return ERR_PTR(-ENOMEM);
> > @@ -543,6 +568,7 @@ xfs_attri_validate(
> >  	case XFS_ATTRI_OP_FLAGS_SET:
> >  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> >  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> > +	case XFS_ATTRI_OP_FLAGS_NREPLACE:
> >  		break;
> >  	default:
> >  		return false;
> > @@ -552,6 +578,7 @@ xfs_attri_validate(
> >  		return false;
> >  
> >  	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
> > +	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
> >  	    (attrp->alfi_name_len == 0))
> >  		return false;
> >  
> > @@ -615,6 +642,8 @@ xfs_attri_item_recover(
> >  	args->whichfork = XFS_ATTR_FORK;
> >  	args->name = nv->name.i_addr;
> >  	args->namelen = nv->name.i_len;
> > +	args->new_name = nv->nname.i_addr;
> > +	args->new_namelen = nv->nname.i_len;
> >  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> >  	args->attr_filter = attrp->alfi_attr_filter &
> > XFS_ATTRI_FILTER_MASK;
> >  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
> > @@ -625,6 +654,7 @@ xfs_attri_item_recover(
> >  	switch (attr->xattri_op_flags) {
> >  	case XFS_ATTRI_OP_FLAGS_SET:
> >  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> > +	case XFS_ATTRI_OP_FLAGS_NREPLACE:
> >  		args->value = nv->value.i_addr;
> >  		args->valuelen = nv->value.i_len;
> >  		args->total = xfs_attr_calc_size(args, &local);
> > @@ -714,6 +744,7 @@ xfs_attri_item_relog(
> >  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
> >  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
> >  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> > +	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
> >  	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
> >  
> >  	xfs_trans_add_item(tp, &new_attrip->attri_item);
> > @@ -735,10 +766,15 @@ xlog_recover_attri_commit_pass2(
> >  	struct xfs_attri_log_nameval	*nv;
> >  	const void			*attr_value = NULL;
> >  	const void			*attr_name;
> > +	const void			*attr_nname = NULL;
> > +	int				i = 0;
> >  	int                             error;
> >  
> > -	attri_formatp = item->ri_buf[0].i_addr;
> > -	attr_name = item->ri_buf[1].i_addr;
> > +	attri_formatp = item->ri_buf[i].i_addr;
> > +	i++;
> > +
> > +	attr_name = item->ri_buf[i].i_addr;
> > +	i++;
> >  
> >  	/* Validate xfs_attri_log_format before the large memory
> > allocation */
> >  	if (!xfs_attri_validate(mp, attri_formatp)) {
> > @@ -751,8 +787,20 @@ xlog_recover_attri_commit_pass2(
> >  		return -EFSCORRUPTED;
> >  	}
> >  
> > +	if (attri_formatp->alfi_nname_len) {
> > +		attr_nname = item->ri_buf[i].i_addr;
> > +		i++;
> 
> /me wonders if the recovery function should check item-
> >ri_buf[i].i_type
> to ensure that nobody's switched the order on us, but can't confirm
> that
> the i_type ever gets used anywhere.  I don't see it in the ondisk
> format
> documentation, so this might just be a wild goose chase.
Yeah, I was sort of wondering that myself, but I guess since we have it
we could add the check just for sanity.

> 
> Sorry it took me a week to get to this. :/
> 
No worries, thanks for the reviews!
Allison

> --D
> 
> > +
> > +		if (!xfs_attr_namecheck(mp, attr_nname,
> > +				attri_formatp->alfi_nname_len,
> > +				attri_formatp->alfi_attr_filter)) {
> > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> > mp);
> > +			return -EFSCORRUPTED;
> > +		}
> > +	}
> > +
> >  	if (attri_formatp->alfi_value_len)
> > -		attr_value = item->ri_buf[2].i_addr;
> > +		attr_value = item->ri_buf[i].i_addr;
> >  
> >  	/*
> >  	 * Memory alloc failure will cause replay to abort.  We attach
> > the
> > @@ -760,7 +808,8 @@ xlog_recover_attri_commit_pass2(
> >  	 * reference.
> >  	 */
> >  	nv = xfs_attri_log_nameval_alloc(attr_name,
> > -			attri_formatp->alfi_name_len, attr_value,
> > +			attri_formatp->alfi_name_len, attr_nname,
> > +			attri_formatp->alfi_nname_len, attr_value,
> >  			attri_formatp->alfi_value_len);
> >  	if (!nv)
> >  		return -ENOMEM;
> > diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> > index 3280a7930287..24d4968dd6cc 100644
> > --- a/fs/xfs/xfs_attr_item.h
> > +++ b/fs/xfs/xfs_attr_item.h
> > @@ -13,6 +13,7 @@ struct kmem_zone;
> >  
> >  struct xfs_attri_log_nameval {
> >  	struct xfs_log_iovec	name;
> > +	struct xfs_log_iovec	nname;
> >  	struct xfs_log_iovec	value;
> >  	refcount_t		refcount;
> >  
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 758702b9495f..97d4ebedcf40 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16)
> > ;
> > -	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	48);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
> >  
> >  	/*
> > -- 
> > 2.25.1
> > 

