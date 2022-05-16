Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2660C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 11:01:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbiEPLBe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 07:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbiEPLBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 07:01:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A94E38B9
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:01:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G9NV6P000545;
        Mon, 16 May 2022 11:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2Q7lvrSg6T0V7OANAuz2XoON/lI/FZhGx6hYc56rBus=;
 b=OyZJVxmZBEcvnxy55gokyuOAzN/R41+GELQmOf3L6YfvDjxq8W5LxRUNvSRGkXfL/9xI
 BMt2xWtgJ/Q904bM6I3gXs+GUM7Ow1WmyycWfBgKndRPxAsgOyT3GIy8BDrH9n2GPnsU
 Mm34kkd9zrW2aTBWuU9f5McWBd6RjHvvTFLG12AVX3/nIzAamT3Ayq63XXcwiiFCEbvj
 rWPBbzz+8SmZjYwuaQ+RqIeFw+DRLpGKSjtai7u4ThjgAlwhaPpCRBgPn7GT5dAjAbQT
 S+vHLVTooV4/1SDkcNHSToCMb4wqAjaRRFQwGZLPt/qmqPnOC3jFkPtbXHFarnd/Ew9I fQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22uc2xv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GAtuKY005880;
        Mon, 16 May 2022 11:01:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v1n486-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pn4to9zc6Oirg3F1FXEAfcaGp/gWapzQ+Iwbt2nLU10KpAHzgQNjREOsxpiLNkXO5s7btE4+6EnLc2R+uLjJAUtCsvxAQIsNuZB2w8aRViH0EnjxvHm/wPhg/C1l43K8mNFwqPOXLAMbpjiMNE1QH8oeNVte2nB2m6T0V3Y01VNrB1BBsQLW8dBZfaZXfBjk5pVQDLXyqiHYWv0yWilF4v34qijGQixwKU3Na4B52nIv3dYrTetQgp3BgMdyLq8/MMAis6vFTsgPqfDFfPUyqp/MCBVDBEzbrQWd6k/PUGGJJiIERLs9hjZcAtUkEMsiby2Wo94dtlGoBAiAa8YOpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q7lvrSg6T0V7OANAuz2XoON/lI/FZhGx6hYc56rBus=;
 b=VES8r01qxAOmlR4DNGcxPWLaQNE74B3jwWv4+BvmziMq60wgpDsAyTLbzuAvHdYnWGATEUg2shmH8O3SSIRjoekS5/JoBhFEQXqPt8fMhnlSrXTLHq9zBIpxbZP6s8rYki3g5t29ewxlTe6WWwXTEY3qL45+RWybB1J5UcoCPRrXzzkQq27BAaO8s2Er/jYYOP9Soxk44ser+il9t3jTc+MM1HBFxvB10CplO+Wu91RuO8tS+G4jOkze6ji+mmaQo/yzPF09WFQUp+4fhyn/GEybsQmvWH2qdGA69cWKP0t4sNBkSspixlNEOXrLAnuG2r9/SgrPSp0ygf4nHgWHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q7lvrSg6T0V7OANAuz2XoON/lI/FZhGx6hYc56rBus=;
 b=bf+gujKuqILUNVUFq4h5HEPU1W9Zub3kqob7tBComw2ockP4dEQzpSOrhsY1pjSaW0xB8JmWMoxdhj6QKw6ZZIyltrhDQjVvsDDTvoXr8QRKPozIqdodD4Rfor02zOL+0bGkhvExpyL7NgdTW+KvoFrI4A/i89DOzqEDcPVjUmw=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB3444.namprd10.prod.outlook.com (2603:10b6:208:73::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 11:01:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:01:20 +0000
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
 <165247404480.275439.7642632291214731611.stgit@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: check free rt extent count
Date:   Mon, 16 May 2022 15:13:29 +0530
In-reply-to: <165247404480.275439.7642632291214731611.stgit@magnolia>
Message-ID: <871qwtspvq.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0209.jpnprd01.prod.outlook.com
 (2603:1096:404:29::29) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd7c0165-663a-449b-b446-08da372b685f
X-MS-TrafficTypeDiagnostic: BL0PR10MB3444:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3444242379744BC99D70F12CF6CF9@BL0PR10MB3444.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p1DLuFyG5bw5nGzEMo2d5a39cz3KPQbYrqcd+BLnzFDmBWmoKksbIhOwHWCKRZgFXQnwe9y0H80dqQQANUI+tRkE7iWvS0UB0F/PldJl7JbbC+dPJoNOxv31mNouRWpTfMatQxyaYAU5DcMdx8dE7+BH0N0jpLbbiqiI2cUeI2su21qnyKk/Uyfv/cls/9iJnW27z2/+K4yKgAgTDcGb+s4zRHd3pN7AV/lHNNPFavTvKqBvqVBtlAcHh0H68M1D/fEQmouUJQtL882eVEqTJ5HMTNgwpGKr/bAMbDTeO1kwKvAVwAKjtcuzduOeAzo6WCATrI/eUz36gxmuBr0Wp8EgFomfl+ETZv69d6AYX2YV0EMkxX3WgP/N3mcE8Mc5/HIyl2ki+ofNza8eP/N6CBwv421b5Ta3i7kgrh/mCzZveidGyRZpJLuos+ZqYSKBColQuQW6ajcuCmzIf0Ukf826UujpzbZ72wWiKYfsfYrFcfoRx8GYj23uyjXwoTaY3H4JoWyE7rc2E1Sn+9KuC+OR9AuBEPBJxFaqS2PYDXEpEs5DPIU8sKM5mQTBO+tJFIYH+H/g0XuK/GMGOHLB7RBRVJxeieZ6sgRn5I3DH1Hy78OpLdk2XyrZFgNqH11CG6PR3zhJ2Ev+u5Prcpn6Zjl8X9LeDf1qlSL4h0a9rRrG4Y7H+BFoTZ0wXhta/R99s2OtQC+vBMkEdw4R2EGA8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(5660300002)(66556008)(508600001)(86362001)(38100700002)(2906002)(6506007)(6512007)(83380400001)(66946007)(4326008)(6486002)(38350700002)(316002)(6916009)(8936002)(33716001)(186003)(52116002)(8676002)(53546011)(26005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kBLoSMQ/CIpT2s+zT77vDGVhsV046qSshHeLuqVefJ/IujLfDrJBgVJXFJ06?=
 =?us-ascii?Q?U3TZXPo6LBgQMw5ZlPY3s3iGK07o6KjA5iOwDBttgkU76MuGErhRNDeMFJ9V?=
 =?us-ascii?Q?9BMpVmeEHz6kHlmzs9APMgxw4wvZLeR/OBHzz0zzpLxEaJKRt/OUOojwaYpt?=
 =?us-ascii?Q?ThiCh/Yt85S4KD7XfXfjL3sbsKQtkeFEOKeDoiN/EID29qkcxeAuXoWxXcnd?=
 =?us-ascii?Q?S11T6+wniucFs+OX9HxXJJDzsmsaiA1nXBo7Y3NwixpSH0e5JMxfv8I44vDm?=
 =?us-ascii?Q?HsI3SHjN7bpBcM4UDKz/prF7NTZ3sxcO2/yeHGLRK+8oEXo2IDR7lsaon7Wq?=
 =?us-ascii?Q?/iKwQaquZozOtw+qEbLOk6qEpHdPpb47sjtHw847oN63RjCcJvuA5haOkvyy?=
 =?us-ascii?Q?D2Tm/0AaQl86t3TJINDBlGl9AkQA5KJ6tGUXJoxl2eIN0qGq4NUAfFnASQ0P?=
 =?us-ascii?Q?iz9MdMsOfvZZ4AJBFg+Xgi2LJSkgEzt1zhqf96w3513wFbjyGk+laiaAnZiS?=
 =?us-ascii?Q?83IuXNX4fz3y65TcoXDmDzpTRQQF7dhGwqwRcK4Z0l/Mph7mPxH0L6HTX9Ov?=
 =?us-ascii?Q?MJ6mGC6vQZwkdZl2Y0XJBe1/pzDOE7El/ur+FPUYRgApdw63PP+WSARwV0tg?=
 =?us-ascii?Q?v+IkwyEBwHYZn0yB1SeJ6URjVGLtUrc1lIDlBhf6OqU3Vb2N9NxjOmdEAign?=
 =?us-ascii?Q?P+Z+XW7NqsP4NxI8EJX/5QXPg4fIjWSevlCKo/JOfUgL81TCJcskp/ydfwTH?=
 =?us-ascii?Q?WeguNuYm/A9ISImPw1BKTKZBPzJXd90I8gvFIN2mSUcHiFD+FrV6LF0CpY2A?=
 =?us-ascii?Q?oo68sUg+6E5Vs2pH4sSfCdmXZecc4rd/1xE+J/wzrndDGt6gQRWKj1tQvn1M?=
 =?us-ascii?Q?PvVqRztQyg4Vs6UzG7SbRvL6SGU9nZf6oh/IDnt5lyAaY0gbRvxHGS5Zzgge?=
 =?us-ascii?Q?8dyrnDdaCQC/JCvkgkcrXOtpUXaJRekj20RuQtfTD1SG9gsS4B1lXLcY7gPZ?=
 =?us-ascii?Q?2bRhdC6dRmiZUAYbIT48BFlpzb+Bevookm60CMSroQYV9t6sireO50Q32i9b?=
 =?us-ascii?Q?CsPCXlZp+iUQ5czwZ6zhTowFWasgmGITwv+hsKkJoA7ONRqf8RvCeKPulEah?=
 =?us-ascii?Q?z9WKYiGM5J1IuvzQH2Q9SmxFQYbXIQVnunc5HvxwrqK4YtsziuQHcfKDB76x?=
 =?us-ascii?Q?KjJd0VNM36r6vPHfrkcFF3cvzFq8eZwrmifXYjT3wjIzwABOWEkM0zZMXKrC?=
 =?us-ascii?Q?szhb6XiNkBlwcjUfhDlu4FCw+qnvxhevlfzZbxWHqhfblP9H6qBASXm3oytJ?=
 =?us-ascii?Q?aECCNHMRGX8sWuvSNCwYau7mF1ivibsT+Tmhlbya10cAVe1Ih/Jfet2fZWTP?=
 =?us-ascii?Q?2hYaySp2Sbf91luwSBVSQivTwMM31F+z7lDZhqGaIycJ+palLkKxo/wRLFIQ?=
 =?us-ascii?Q?edo+5rA7x2smxdBc9/VnY1H3tOHUjpEN1Jm5KYSz2gIZd6z5HYn8NOfwdGaq?=
 =?us-ascii?Q?PGW5RAuHFUXRA9CQp79QQk87nkDO4kBohx8O5jYdm8O1o13xoyaUs6ig0IBY?=
 =?us-ascii?Q?uUaUL0kkMdyCiOD0czfA8LdJStS51ZrdwxQqWOhi8qkgKkN7XHmCSAv0S+4M?=
 =?us-ascii?Q?mJNW8PIUrrtUIoCAlZfHnuv7jfOnHMOy/n09OQa1lroeXpivQrbaoC/Gb33q?=
 =?us-ascii?Q?2Tyo1WEQJRAZGvS6jsBbIdUrgRz/mmebU6xIQYVrHKbWqOrrkRyqgTufncTu?=
 =?us-ascii?Q?xrIS95cExA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7c0165-663a-449b-b446-08da372b685f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:01:20.2458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wz6tzG6lCihiC2VUp/9C9Mc/MWxi0SYqDxCwI/4gs2f5GZ6fsUJwKX2KsoggKzv++5jxEeP2U2Np9sThf23DfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3444
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_06:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160064
X-Proofpoint-GUID: GQVnWoMK03vyHWS3adO0GcxfQ8IDsrvf
X-Proofpoint-ORIG-GUID: GQVnWoMK03vyHWS3adO0GcxfQ8IDsrvf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 01:34:04 PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Check the superblock's free rt extent count against what we observed.
> This increases the runtime and memory usage, but we can now report
> undercounting frextents as a result of a logging bug in the kernel.
> Note that repair has always fixed the undercount, but it no longer does
> that silently.
>

This changes look good to me from the perspective of logical correctness.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/phase5.c     |   11 +++++++++--
>  repair/protos.h     |    1 +
>  repair/rt.c         |    5 +++++
>  repair/xfs_repair.c |    7 +++++--
>  4 files changed, 20 insertions(+), 4 deletions(-)
>
>
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 74b1dcb9..273f51a8 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -602,6 +602,14 @@ inject_lost_extent(
>  	return -libxfs_trans_commit(tp);
>  }
>  
> +void
> +check_rtmetadata(
> +	struct xfs_mount	*mp)
> +{
> +	rtinit(mp);
> +	generate_rtinfo(mp, btmcompute, sumcompute);
> +}
> +
>  void
>  phase5(xfs_mount_t *mp)
>  {
> @@ -671,8 +679,7 @@ phase5(xfs_mount_t *mp)
>  	if (mp->m_sb.sb_rblocks)  {
>  		do_log(
>  		_("        - generate realtime summary info and bitmap...\n"));
> -		rtinit(mp);
> -		generate_rtinfo(mp, btmcompute, sumcompute);
> +		check_rtmetadata(mp);
>  	}
>  
>  	do_log(_("        - reset superblock...\n"));
> diff --git a/repair/protos.h b/repair/protos.h
> index 83734e85..03ebae14 100644
> --- a/repair/protos.h
> +++ b/repair/protos.h
> @@ -36,6 +36,7 @@ void	phase1(struct xfs_mount *);
>  void	phase2(struct xfs_mount *, int);
>  void	phase3(struct xfs_mount *, int);
>  void	phase4(struct xfs_mount *);
> +void	check_rtmetadata(struct xfs_mount *mp);
>  void	phase5(struct xfs_mount *);
>  void	phase6(struct xfs_mount *);
>  void	phase7(struct xfs_mount *, int);
> diff --git a/repair/rt.c b/repair/rt.c
> index d663a01d..3a065f4b 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -111,6 +111,11 @@ generate_rtinfo(xfs_mount_t	*mp,
>  		sumcompute[offs]++;
>  	}
>  
> +	if (mp->m_sb.sb_frextents != sb_frextents) {
> +		do_warn(_("sb_frextents %" PRIu64 ", counted %" PRIu64 "\n"),
> +				mp->m_sb.sb_frextents, sb_frextents);
> +	}
> +
>  	return(0);
>  }
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index de8617ba..d08b0cec 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1174,9 +1174,12 @@ main(int argc, char **argv)
>  	phase4(mp);
>  	phase_end(4);
>  
> -	if (no_modify)
> +	if (no_modify) {
>  		printf(_("No modify flag set, skipping phase 5\n"));
> -	else {
> +
> +		if (mp->m_sb.sb_rblocks > 0)
> +			check_rtmetadata(mp);
> +	} else {
>  		phase5(mp);
>  	}
>  	phase_end(5);


-- 
chandan
