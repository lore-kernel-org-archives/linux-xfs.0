Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16336C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2B5610EA
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 10:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTKtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 06:49:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17956 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTKtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 06:49:00 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K9wxvA005087;
        Wed, 20 Oct 2021 10:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+tWg/GWFsh7M+J8usZHCcddyiNcrwrl0HXAgYk9gTCU=;
 b=fo+1WVuvuptVHqMvWzIUX3RSg76YIZ9gNMkNz0dk//5aggmaAuHqoEyQxmjTrHUas+JJ
 eryJ7LDVNYZRSC85rLIBdnZMDx4/Eg0+0CXqdtvI5+8/ZUZx38C6mAyJ/tVGhWXqiZvj
 Yz/b7JK1v3YRmprst5mC92XXtnPOpsWZi2ua+jq9hXWCoVpIF4l0ObZ2qJFua22VBPCC
 zeF0EmFqSMjJ9QyfonpbSpH/tM5GYG8QbxUMDF4IzQpfLd2yZ22SI8ecxKPGk5x8/2wh
 sacBVLM1qjQRNxUH/EtYNa+U/S0ZPfw2pjop0Yc/ofrmmJRPlA1DKAmtfGT1cA++ObjT 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bsruc89cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19KAjZcF030550;
        Wed, 20 Oct 2021 10:46:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3020.oracle.com with ESMTP id 3br8gtx9f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9+BloHVq/Q/od+J0ehJ9n9XTglJgSNsmdEWlHTAzD153IOLMiL2iiZkAYmTTdxGgLKZHxLX9STCn1LXkMhOGJhmQgWWQefJ4HCxNm01cR13arp/NEGzO2YjHrirlLbm+eIbrh/OIWCL3dV5ms4ruTogq79Egv/6b9ENe64oXlW41J3Ss5jsySNgo2C7cHsqbk/3do/KJVM2G4YsE2Kpw3VJVrqz2Y5xhVCuUnruxQQyyd7BkjZQ8D1tE0zSBbBfmHKu5TXBm0jYQjNKSklym8FplPESsR/z/q2QTklTmorOcnBBmJVm4V5RbNrgdvHRWjfdY9dbI4dGlvkMa7W2oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tWg/GWFsh7M+J8usZHCcddyiNcrwrl0HXAgYk9gTCU=;
 b=XSUW0BzZX9NYTD4rUs9aeytO4i1D1cOXp8akFJfCFbXc/WKo4hV7S6FT+DbMz648fp/ATLlPrt8mU03qIRFjKQxsFAN25dwhEDYkpz7W4xBOqX0gtGcu94Ap3Mffcd/6+VLOfFNqmJ1+8VL9UBttMEHUmQjGXD8At8QLbUCiEIk1kKS7FFpeOJ/EYnp1QSwQPP4CYl1OAaIKPSlsx58ifLZCTJ3kYD1kXqNf8Q+ZwhbhKsrGoQJX/O8ipuD1b9xMVERD2OBVm/vRYaZkMMMqUzMNm+m3wP1R+U/BBHl4aGI6gB59XIO302PHRL4l+VRaxw1kZEEAu5faboEeMcsA6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tWg/GWFsh7M+J8usZHCcddyiNcrwrl0HXAgYk9gTCU=;
 b=EUoeExeOmN/aHNeOeEZyG3XvdA6yrIsJBrIdE27W+fCfwBIMr7QbCkwHfhQf4tpDPh4MamTeBovq9QY56IH+qPRB14Ainl8IgfNFYdcimyQldCdIdWbebdpklYaHgxmKVuY3a7K6y2b6vMeaxHkameqHiOD0W3mCtI2XWJElfyo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4731.namprd10.prod.outlook.com (2603:10b6:806:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 10:46:42 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::e8c6:b020:edfa:d87f%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 10:46:42 +0000
References: <163466952709.2235671.6966476326124447013.stgit@magnolia>
 <163466955467.2235671.4983293287731225085.stgit@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: remove unused parameter from refcount code
In-reply-to: <163466955467.2235671.4983293287731225085.stgit@magnolia>
Message-ID: <87v91sgeih.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 20 Oct 2021 16:16:30 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:404:28::36) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.50) by TYAPR01CA0048.jpnprd01.prod.outlook.com (2603:1096:404:28::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 10:46:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6147cd79-1e22-40e4-3670-08d993b6e709
X-MS-TrafficTypeDiagnostic: SA2PR10MB4731:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4731181D2021966089B9FC12F6BE9@SA2PR10MB4731.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BfAYiPl1ONj8MjYvpOD1jTp2OxzQzrsfHYXwspypPJQL8kwJxCLI4+W0uw2MO94N6oSJ1Nfv9S1CmqFXSsUQF0l2l1NKJUu9t38hULZ7+fOKnmIMrZqPasNqB8dHIyQNEUSPnxoz+ktegG4oLPYqphVU+CJY8qz8GOacp0lTgtGjJjkOSUIM7SizB5u/6e/oLVBjpLdP02DECVHwA8vsrXfgCGL7F3IDfG/U2mR9W+1xYp2Eiae2bSiqnyRDbjJzFW07TgIzpkI/BInyIm/RvWwVEB/XNYJ0nQCwbl3STDxLeO4kqMtwkXllEw28vd22BmPiqHgOHvsocJTP/kIHznjB/mfGhWElK/XTRzSTuNsNmcedQHnbeWeRj2g3IW/7urYIjJicP80o8cYZ8CzJA6YVmRx9pk4QVFh+0dsCOjOZOSaX/wY3tWOj+4sO/5B9OoH+ztx7uLnR7LCawYDQO8cr5ixjsBBmBJXZvf2KB1b/Nvo2dCwzDVMlyvXuzgNAPYhUVYJQF8EzAnpEeceuwqu/+y+bz6fmY373AmPOV5wI6GMpYvKrMu7fa/owJ9hi06VXUXJBucpuEf8bNzIubJD/3joISHY01TE/B/5uCLmmDfnnzx+ywoBW8BTSXNMMvMccAJ2QRtlniGjfMhAvqcyGEeKQZ0A4Gk2cKx7Xi6TRS/3xZHSQPuMc6fiEn7jiHz5OfxXfWvfK3M4JdreTdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(2906002)(8676002)(6496006)(66476007)(66556008)(4326008)(83380400001)(5660300002)(52116002)(6666004)(66946007)(6916009)(38350700002)(38100700002)(26005)(33716001)(6486002)(186003)(53546011)(956004)(86362001)(9686003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YaItuoTaBlNvuWo3f94gMSa+ooFx54Te7wckqOY47yXYWWpb+a5ZKUtI2qxK?=
 =?us-ascii?Q?pnaAeUtz+CgtDHmjSqx+KiXWJK0EvG2Op5uahm2GTv1uf8BO7C1u6yqt6jwC?=
 =?us-ascii?Q?dyXXh9WS+L8VfFTKPhd8sOEF0511s3JBscxjgW1Ki41zWS2Io6d/bTjkJgyM?=
 =?us-ascii?Q?hikxuYTL/v6oENJgjOfVTCn2yUbDj6GCkC6MAH3kDbhzFPWBG8OKWORGxXWe?=
 =?us-ascii?Q?X0kxI1lMjIxyLhZW2QBHHCrBkaM4kC+FUMdybGHK2KNGWK8NgE3MsIkDseyT?=
 =?us-ascii?Q?l+aitLo+6zY+y4wgywBpSx/2iQOzapnzjR0n64iUXa0MZarZBO+MZ16PDEay?=
 =?us-ascii?Q?//P3oWKXq4uwMETE2u8D+9wLgRUZZQ9YfW01taauC+fMTU8wPKt1Tdvj7jRg?=
 =?us-ascii?Q?xyJ3qko0wIM8gwnswz75p36qEPx+ifdJ9cAGmMq+d2a/vGvTW+xtbnpvmzGs?=
 =?us-ascii?Q?819ZUQKwfBCGUqo1yP/q4QH68hEC4rj7i/Dnwmx4VCifbyrR1OESYWaTCJ5T?=
 =?us-ascii?Q?82kuqUw0EnxM2h9LQxQ/JTHA9f2DsCVCiSIlA2ZcXZVrP9Y1BHYEzP2Kko9o?=
 =?us-ascii?Q?2K7KptvfmFkE70yWYO02zmf9eY0g2C9+GrGrDCSiVavY0aUNzWacltE6IrdL?=
 =?us-ascii?Q?iyshdWnH7Qd53H+jk8P7/9ny228g0+mOzGXrGzZYSitWXkMdGH194B+Vq50D?=
 =?us-ascii?Q?rOxc+tVTw2YQYB++98lwbU4vAIuewpg7pCY3yQwcE6R51EKblX6TebdB7p88?=
 =?us-ascii?Q?jyYSPK73E1jEv/pHjFMaCt0wmeFitStsIlFOLUKBQV2fMmv5EUkPxFwGJsZq?=
 =?us-ascii?Q?3d3brvYZiCqok+IN3IBpyojIRRcDtnNJrwDhbtmE5mdXoAHDMlicdkZ4UVSY?=
 =?us-ascii?Q?KpnU+LRgsmK3c60Nk/R3qgQYbyY3IdgqqUQRQYY/c+P+8XNaGe8QhZD53+hl?=
 =?us-ascii?Q?6wInU7IyrWLezA/renws29ocuVHayy7rUngMin1cbax8zCKKeYhqGmVRS4qH?=
 =?us-ascii?Q?o/kPMnJCjgmT6Oqn+X5ioc5490Gy6ki+7i5/xIRSXmbZ9ttWszKBPznEExps?=
 =?us-ascii?Q?WuaNZcoE71HNp45NDwmvInopCaVmGkMvq3htqU1S/HHHfHT3gCXG+YSNpWJO?=
 =?us-ascii?Q?LETw0eX5R2M60aNQEfeo1bQNDslr8mjdDmn8ew/vmYsOv7i66Xmw8BZ/0iH9?=
 =?us-ascii?Q?HRiSej70fzOGhMRXNe4OzkEbeS/va1APVW9Bs/9wxZXR3vremGin3kv9nmBy?=
 =?us-ascii?Q?UwGhNfbrN3c6yNNf0mDG0PxGPWsH70rjgTkYEgx99fqYfby6xJNM3cBt/7Wj?=
 =?us-ascii?Q?s3gu9W4kxhx6zLch/LwPWc3qBs5PPTdh27E9GcmA/9GxDb5b2doBuRjj6x1N?=
 =?us-ascii?Q?VSo72T8nu6S5sdsn8xM4jhVT05Ol3dVpP2yi/sPPnck3r5YpAZHKwoEW/F82?=
 =?us-ascii?Q?nfaASiz7xRNAtXuoBTsZqnc8NMHpg98PdDXtXV761JYVUCkur6I+BWCIiPDL?=
 =?us-ascii?Q?wsS2H4SLFig941tge4Eo0/Rncy9qTZx5f/X4EC9qdepo62XsIlhnqpi317bE?=
 =?us-ascii?Q?6tzl2MV9Yc5ROgFhiK+2A6sIOW2DhCBdFX/sFGwyOrXbV0xBfSiUbBwdQ8cp?=
 =?us-ascii?Q?MLzPvUORP/t3SJ/1AXAdX8Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6147cd79-1e22-40e4-3670-08d993b6e709
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 10:46:42.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNwEdMd90Q2sPlYHIjXoiLojULqLGXo5IhRrlXOSLp5fbjQt5zZ4B40zMa4FoQrV2n8p9l8gSF/C9Rewgdh8DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4731
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10142 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110200061
X-Proofpoint-ORIG-GUID: RUnbe2K0tarnErOQO--dt2Ysk8MruDmF
X-Proofpoint-GUID: RUnbe2K0tarnErOQO--dt2Ysk8MruDmF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 20 Oct 2021 at 00:22, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The owner info parameter is always NULL, so get rid of the parameter.

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index bb9e256f4970..327ba25e9e17 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -918,8 +918,7 @@ xfs_refcount_adjust_extents(
>  	struct xfs_btree_cur	*cur,
>  	xfs_agblock_t		*agbno,
>  	xfs_extlen_t		*aglen,
> -	enum xfs_refc_adjust_op	adj,
> -	struct xfs_owner_info	*oinfo)
> +	enum xfs_refc_adjust_op	adj)
>  {
>  	struct xfs_refcount_irec	ext, tmp;
>  	int				error;
> @@ -977,7 +976,7 @@ xfs_refcount_adjust_extents(
>  						cur->bc_ag.pag->pag_agno,
>  						tmp.rc_startblock);
>  				xfs_free_extent_later(cur->bc_tp, fsbno,
> -						  tmp.rc_blockcount, oinfo);
> +						  tmp.rc_blockcount, NULL);
>  			}
>  
>  			(*agbno) += tmp.rc_blockcount;
> @@ -1021,8 +1020,8 @@ xfs_refcount_adjust_extents(
>  			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
>  					cur->bc_ag.pag->pag_agno,
>  					ext.rc_startblock);
> -			xfs_free_extent_later(cur->bc_tp, fsbno, ext.rc_blockcount,
> -					  oinfo);
> +			xfs_free_extent_later(cur->bc_tp, fsbno,
> +					ext.rc_blockcount, NULL);
>  		}
>  
>  skip:
> @@ -1050,8 +1049,7 @@ xfs_refcount_adjust(
>  	xfs_extlen_t		aglen,
>  	xfs_agblock_t		*new_agbno,
>  	xfs_extlen_t		*new_aglen,
> -	enum xfs_refc_adjust_op	adj,
> -	struct xfs_owner_info	*oinfo)
> +	enum xfs_refc_adjust_op	adj)
>  {
>  	bool			shape_changed;
>  	int			shape_changes = 0;
> @@ -1094,8 +1092,7 @@ xfs_refcount_adjust(
>  		cur->bc_ag.refc.shape_changes++;
>  
>  	/* Now that we've taken care of the ends, adjust the middle extents */
> -	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen,
> -			adj, oinfo);
> +	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen, adj);
>  	if (error)
>  		goto out_error;
>  
> @@ -1190,12 +1187,12 @@ xfs_refcount_finish_one(
>  	switch (type) {
>  	case XFS_REFCOUNT_INCREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
> -			new_len, XFS_REFCOUNT_ADJUST_INCREASE, NULL);
> +				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
>  		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_DECREASE:
>  		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
> -			new_len, XFS_REFCOUNT_ADJUST_DECREASE, NULL);
> +				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
>  		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
>  		break;
>  	case XFS_REFCOUNT_ALLOC_COW:


-- 
chandan
