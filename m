Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4CAC433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Jan 2022 16:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiAHQQ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Jan 2022 11:16:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4970 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbiAHQQ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Jan 2022 11:16:28 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2082rZfa030488;
        Sat, 8 Jan 2022 16:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Jv616C9gAvJSKHLxcb+Rj2HRxDkqy0plT8vW/rPAYZ4=;
 b=uoeE7dmESUisBI5lCJhGAg0DmxnJBqvND0BHVawgWcuD26xlL1mNeVcgTd6rOuqf3QtO
 eaEXYHtJ7Tt3tycDNYc9ppYj6AhMR5HAg8id08H2ym4NApAmisIFTs9C1vbUKOXSHvQ8
 m7gW6p1K+EiUrV3p3dLplPW5bdZadxL33Bhfr9rQj6Q/D/Z7cpwhh+tXG9hz6w3wfDnp
 OMMCV1khxJR+fS5fLzQRs43Is9BlFaEnBii3CN5hW50EC4Drvx9pqDXKVXuFl3OjAzaU
 3D5kxIBsc7n2z8UO2cLKAYI4oExRxxIb0mfuhekxjL97XJzPBGbgyYO+xfL4wHOE4+Y/ SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3df27t8h3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jan 2022 16:16:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 208GBWo2172276;
        Sat, 8 Jan 2022 16:16:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 3df42gs9yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Jan 2022 16:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/yUycioU4de+p7KtxMq4k5qcT8i/ud4dW5NhNcMFhFwnUx/OFryxzjdpE8QQmsMHwco2uJkCy5X2MVH36ZzLoBFJfrCC3Z3Xdj5ymfSS6A9Q8bAVw0DQi2iNxu4Ln+DykvMWo0SqBpUQiAfHZR68PAWDc+8yBm5m2/k1i95q05xtJ0rW5NkZXSW4P1nGOmQOkHleH3qf/us6UelveTeOFYSeV/2eWUx8o/c3zlSpcxENArF5F9wZU/315rEtHGcaTx6qSSVQIYcHhVKCj/jwTcyrAswE1X6PIIurKQza0RUox4ipx1cxtyaVWkLSDrcrIIeEkv+q5Cuf7Hk7XXydg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jv616C9gAvJSKHLxcb+Rj2HRxDkqy0plT8vW/rPAYZ4=;
 b=P5YvV4La43UePqBScCgEcTBeHDOjk9p4U3xfr8fsyQAJzeywmAbsuT2i4JgB8b5sLbFt8DpT7fc6CtOax/G/mmDzrp9EHUYB1+ylPh/NspjwmAo4PcPaJY30hcz5spJYHWPogcPOdb3APWWlH/Nv3yZBP997yWiuoB4DtSu/bJFsjxItxi7qd3HCYw6QlJ7cJacRu5ZgoS4qRkC9u81oO59ZqKdIvq/rns0+IwF+JTzv14/mZVFpIIbL5bWvgRXQQifJKlgLQ2mCOYuXILLbw6aGsJE7hlKK2fuMI7JoHc0pA3d/e9FLeIUU/zmOb+vo4KAERM+LgrttZnnvGHSFxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jv616C9gAvJSKHLxcb+Rj2HRxDkqy0plT8vW/rPAYZ4=;
 b=m+iHK0bgMwE7k8avmQO2sPOIKbeA5gtxJY+i9xY5Ew3tMvBJYewaDqHlzL9XQGLGY8N31NVO7qwKTZ3hjS4QCA3xYWMZbTgZSOphOylqNYq+v22qHqiYKjCZNLBQ6JFco8r6B8Zkl7WZqN4g+hCLgV9Eex2X8bSKIcdOKAteg48=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Sat, 8 Jan
 2022 16:16:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.011; Sat, 8 Jan 2022
 16:16:21 +0000
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-20-chandan.babu@oracle.com>
 <20220105011731.GF656707@magnolia>
 <8735lzwmex.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220107190346.GS656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 19/20] xfsprogs: Add support for upgrading to NREXT64
 feature
In-reply-to: <20220107190346.GS656707@magnolia>
Message-ID: <87sftyursn.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 08 Jan 2022 21:46:08 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:403:a::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30e2106b-b981-4948-23e9-08d9d2c2356b
X-MS-TrafficTypeDiagnostic: SN4PR10MB5560:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5560E5D53D7FCF62117F6B23F64E9@SN4PR10MB5560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dQZsUy3vRrq+ZmRphNJhdLIbfmcO0aX++NC1aVBbrIfna+hCOCp+P2oATBDYloXXTLMfQBgF3037pHJQqgrY+O8+VaLxrtfM7rxe6x7CIGsvEKJaNt9ahL/DDSs9/PTgBdfnELf2y5Ogym0QSYYgc25XV1DB6VWmkMM1/ssCeQzDvyExi73ApXS2mRRzfpiJ/cfTjG4uwGGpy3DkF0hQedeu1DpRseUVanrEgJrOiUBUcOtCqK1v02Gm0xQJBqiLRAWoSrb+XGoNmAbvOFI2CFKYGQmi2JVZOia2KbAYVIrJUXUdIRnpSzxWYm0WRsre5O/tuP/kQ7byHc4VKb+SKx6D1DgdZs7+ThK3pp4y91ASuUUzg8YPL8rPPnDUXfPOapVDMY/5BK/EMqSO3pAiEVhpwyLVXDaFjrw9f1a3cvaeuX47PuLouq1ssukTJl8TRuUeM8sdI1UiM/6BTQB2faXv35ypU39PcYSfbc819cVm1rla+uOdLoH8jmLgJ1T0g5Oq7fe3mg5KYSidL7fuIzfUuumu+auebY2l/9iP/1ewM4akcblsNces4bC71G73tW+GtZaNVawX9Wn1AWLJAg3e/emJEW8+y05hDZB5oDwpRmaI4TJ6yOm2NmJbLGMouEOy72S7nxu0lyYF+3aY0Cayf+Yf4fZK2RgJzLqHzV1rckARXFt++E80iVaFAw9lwO7k22mI9HNlVC/dmpqKwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(38350700002)(38100700002)(8936002)(33716001)(66946007)(6486002)(8676002)(316002)(5660300002)(53546011)(6506007)(6666004)(86362001)(66556008)(52116002)(4326008)(83380400001)(66476007)(6512007)(9686003)(186003)(26005)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69dwAwCvraMiMlq5/xmz44IjklMizFMtRxDC2P93Va/tjnNYMUXP15SyQY2p?=
 =?us-ascii?Q?eNBSKs7hexnlxPxubvN0H7NjcOm4gqrM+o7BT7J/fv1A5NWU2ED1TdJiQ1DK?=
 =?us-ascii?Q?rwG2KnhwN1ZBFzMdd7ZIpGk1msNewmL4H3MqgxdJ4S/2xYiftxUPdWvYGZH7?=
 =?us-ascii?Q?S4+gedfp+7k7Weuive6ILaAmJW4I4jmO6W9Vr+foRzzOvTwJxdNk14ofo9Be?=
 =?us-ascii?Q?Jt4ZvMvRlBUlm/tNdKMHshJcnVHObyAa0WZFD+nUkQVEOXHppV71sqOe6veH?=
 =?us-ascii?Q?4z54NI0Sd9l2iaomTCKCanBL/oMxoP+UYKLJL+g8TRDBlHI/8yTUS1K34PMh?=
 =?us-ascii?Q?yCyswWufqTS3X8ucitQH1wlx4aM4PnK7YRZBJSJvq26dNvdrjONn1JWzK4R9?=
 =?us-ascii?Q?etIVT0NMzN6tjTcgqx5Y+NN5kWpUyVv/E2RSM52Wt7EsNnbuWbqHgrHwRye8?=
 =?us-ascii?Q?4SliMViWpu4iBfbOkJXiXpSKmsoKl44JTOvekWqoOdFB7fjeluiYur3VwBhX?=
 =?us-ascii?Q?bwkh3JNyjWDNSbGQ2Sy/Z1Fw3kWZ1qcjszYpnxalYFEZ1xwNAd9Cq7K1ethV?=
 =?us-ascii?Q?ZMkZI9Uahah53DCBHCqPLIbKNssuZ3lKTHzqis0Vnq5tCajjucgJVHD8lloQ?=
 =?us-ascii?Q?Km7bjDlOX0eWvRmWiR06JpxvA7TPZ4CQZyJc8gZe3w5vRHXdfXAKVFSKPERo?=
 =?us-ascii?Q?0PbAILSXu72oAbxdgO7Vei7FgNtjKuTNqcS75XTcHk32q3GMZpVnYTfcFj0p?=
 =?us-ascii?Q?xp9mr7TyRVpPTDTkOiJb4LPbi7+j8Hj4W7PFbB7FqBjDkhjwtPNjiFH+Dn7A?=
 =?us-ascii?Q?lAruto8qsKIYqj4iErjDDi/acPRPMrJOIr4mvp+2NWS7N4Y30vGBvxPCwlwr?=
 =?us-ascii?Q?R99Mf+xrnhGOwBI0IxYE5hUttLFZzl7CYzi7ed5qiBCvjmHYZJt/CI6xV38z?=
 =?us-ascii?Q?b4JPwPqSJ5X2luTBCT413s0WZxG+0X62BZWYbqMxAdjdRcX97tBzVSbu2day?=
 =?us-ascii?Q?Dmb+KRQEpw/PbNFTthdKPQkOaaQV2DKIrxLSQT1+BXnJHoyBzZQJGAIEc0xS?=
 =?us-ascii?Q?40s51InhQ7LKIUJTgRDGo3xwp4yVd8NGVQmNrRy76XggeG0usajAjkI4dE/K?=
 =?us-ascii?Q?H3ckSta+UwjJ/eFZaZg03UnZtSS/gWlWXdeXN5A2sju8FJEi/ArImstsNGGF?=
 =?us-ascii?Q?Ym/ynWwPb3FWOBVGhl0xZ2JjIR0Qoz9qyFGCc3YK5hCY1SH6nADTwGoCFGlx?=
 =?us-ascii?Q?cCInvgd6sGItuos+ACLAAqNGLG32BDSz0qkIXMZUuUwVxRgB/fwtO1DoG+Kx?=
 =?us-ascii?Q?LI58xioEoeEcD+RMpQp9KdBFmdQpVc+UgOcNvtQjW6ySRg6XTHmdhS8+9E4g?=
 =?us-ascii?Q?fRuxp9jWEpRGBXf4vbO8r2tGgg7HvdctdroZba0H0KPzsMLnzVbQkt4w2lhg?=
 =?us-ascii?Q?ZYsGtMel4/tPDjnPwNJQKCd6s5Rc5f1nbVEXR5JhJcHaOJ04U1sZXrJuOyXA?=
 =?us-ascii?Q?cB8V55kbNF7iY4l/FSqi19ihNjADFeyK5HZdbAnG+mvXaat7z1WMPERbYQNe?=
 =?us-ascii?Q?ozdlmYAAToLxhM+Wja8W3b+fnLDUMyeGp82vHkGXvK/Yo8S8omHE0StgZeW0?=
 =?us-ascii?Q?2dvl3nG7Qz9srV9+X3rN9W0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e2106b-b981-4948-23e9-08d9d2c2356b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2022 16:16:21.4892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3YWQJrBzQzwcbpihwf7Dhab61x0SPJ2YIFyEKbw12qo++uNS1BfuI2egvV387SdC78gF/uv82wJHz2LQjUccMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10221 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201080127
X-Proofpoint-GUID: pMqMGa119EVRds87K732pgUHPOwKOV1E
X-Proofpoint-ORIG-GUID: pMqMGa119EVRds87K732pgUHPOwKOV1E
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jan 2022 at 00:33, Darrick J. Wong wrote:
> On Fri, Jan 07, 2022 at 09:47:10PM +0530, Chandan Babu R wrote:
>> On 05 Jan 2022 at 06:47, Darrick J. Wong wrote:
>> > On Tue, Dec 14, 2021 at 02:18:10PM +0530, Chandan Babu R wrote:
>> >> This commit adds support to xfs_repair to allow upgrading an existing
>> >> filesystem to support per-inode large extent counters.
>> >> 
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> ---
>> >>  repair/globals.c    |  1 +
>> >>  repair/globals.h    |  1 +
>> >>  repair/phase2.c     | 35 ++++++++++++++++++++++++++++++++++-
>> >>  repair/xfs_repair.c | 11 +++++++++++
>> >>  4 files changed, 47 insertions(+), 1 deletion(-)
>> >> 
>> >> diff --git a/repair/globals.c b/repair/globals.c
>> >> index d89507b1..2f29391a 100644
>> >> --- a/repair/globals.c
>> >> +++ b/repair/globals.c
>> >> @@ -53,6 +53,7 @@ bool	add_bigtime;		/* add support for timestamps up to 2486 */
>> >>  bool	add_finobt;		/* add free inode btrees */
>> >>  bool	add_reflink;		/* add reference count btrees */
>> >>  bool	add_rmapbt;		/* add reverse mapping btrees */
>> >> +bool	add_nrext64;
>> >>  
>> >>  /* misc status variables */
>> >>  
>> >> diff --git a/repair/globals.h b/repair/globals.h
>> >> index 53ff2532..af0bcb6b 100644
>> >> --- a/repair/globals.h
>> >> +++ b/repair/globals.h
>> >> @@ -94,6 +94,7 @@ extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
>> >>  extern bool	add_finobt;		/* add free inode btrees */
>> >>  extern bool	add_reflink;		/* add reference count btrees */
>> >>  extern bool	add_rmapbt;		/* add reverse mapping btrees */
>> >> +extern bool	add_nrext64;
>> >>  
>> >>  /* misc status variables */
>> >>  
>> >> diff --git a/repair/phase2.c b/repair/phase2.c
>> >> index c811ed5d..c9db3281 100644
>> >> --- a/repair/phase2.c
>> >> +++ b/repair/phase2.c
>> >> @@ -191,6 +191,7 @@ check_new_v5_geometry(
>> >>  	struct xfs_perag	*pag;
>> >>  	xfs_agnumber_t		agno;
>> >>  	xfs_ino_t		rootino;
>> >> +	uint			old_bm_maxlevels[2];
>> >>  	int			min_logblocks;
>> >>  	int			error;
>> >>  
>> >> @@ -201,6 +202,12 @@ check_new_v5_geometry(
>> >>  	memcpy(&old_sb, &mp->m_sb, sizeof(struct xfs_sb));
>> >>  	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
>> >>  
>> >> +	old_bm_maxlevels[0] = mp->m_bm_maxlevels[0];
>> >> +	old_bm_maxlevels[1] = mp->m_bm_maxlevels[1];
>> >> +
>> >> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>> >> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
>> >
>> > Ahh... I see why you added my (evil) patch that allows upgrading a
>> > filesystem to reflink -- you need the check_new_v5_geometry function so
>> > that you can check if the log size is big enough to handle larger bmbt
>> > trees.
>> >
>> > Hmm, I guess I should work on separating this from the actual
>> > rmap/reflink/finobt upgrade code, since I have no idea if we /ever/ want
>> > to support that.
>> >
>> 
>> I can do that. I will include the trimmed down version of the patch before
>> posting the patchset once again.
>
> I separated that megapatch into smaller pieces yesterday, so I'll point
> you to it once it all goes through QA.
>

Ok. I will wait.

-- 
chandan
