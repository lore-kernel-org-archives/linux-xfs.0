Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE15C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 16 May 2022 11:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbiEPLBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 May 2022 07:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbiEPLBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 May 2022 07:01:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408655F55
        for <linux-xfs@vger.kernel.org>; Mon, 16 May 2022 04:01:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8vQ3d016856;
        Mon, 16 May 2022 11:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IydmQ7qV6eJ8vihqV0Epj6BLlXrz3YazRbYxqiezHcc=;
 b=cmIIaZnpEbE6SGIDhsPBvUWd11Pbz2truH3v84v2w+LuZxTgudtsKgH3k6DoqngWWi06
 mNOcViaudZl0ecM3nbDjqQPkppH89GSQQaVv3fdE82skrDlRdGbX41Tu6ZSbEUEwuwjm
 ZDGODemmdLk2CVTphK+lU6U65r8POXc9WPEv+LjhVImwywyupbQD+SLGP6FRkW/CRhMZ
 8f+4NTLTmsPWw8H9en1QRXPz7tQhaIRwOgNpwgt3hHWq8YfjLh5yApmXKQ/milSMi0hL
 AwW0fHpTW6mvF3bkzvD8O/IYrWQwBfyH1kOn++ytdm/KjWdw9vtuWBAD4DHME3CvC/Zf Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaaw8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24GAtuSH035941;
        Mon, 16 May 2022 11:01:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v78uyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 11:01:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oN6ufP9eZ5tEdV1d6WXz9L9w/QpmykQMpC7KTohsGspPMznY8J8NYUCzzqIHn1QTRyHJJjM2Qboq1Cw5rmeld+Z2xjopdgdUVqdkKrUlT8WOo9ZJH1XKxI+mozg87jWKprvDTUvhhdVloyfUn+6bXpstiipEFP2qfsbT3ovGal1ei9DEAvoeb9RFmr60oSzGjVDqmXmnANydUNPeHCKYxWgDgFnRK133GSjOkw2lm67KpkRJZfEk7k4MyLAdU+NSH0fBuNbpD0Z2gX0HtWNT3mHnvjERN7pKwRp8pQqmgB/6jXBBApRPS8X2DXnNtaBi4EqFeJULjOVdTVvnpuVFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IydmQ7qV6eJ8vihqV0Epj6BLlXrz3YazRbYxqiezHcc=;
 b=gakuw0p0pHoenfswDhRixx7hXTElDPB4nEG0wNQM4z7FAGnhMhOGC3Jbl3/YsQiAFQnVJ1o+MIW2SR7R34r88sU9Gf3CXfQ3BZqkBJLcjEJMuGIVpmN/GMzm3zqf3aylyqM8NXzQZBj1SXKxQa6v7c6OxOGOGL+b2NhIy0tSHPXEAT1KqunRgulF/CpChmyeFDLxR1UDsZTkMISqmdsxEu7l3sedrAp1kDqgZJCWNVfJEhipGFXUo/syE9frwKDjwZJvcx3SYNzmlc1rKbQ9Ox/+aPhDcx9phVLgFopZdalJtSwkPrPlcb3cm6gK8v0AIEF9DM4RsY+3RpHPwBkBCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IydmQ7qV6eJ8vihqV0Epj6BLlXrz3YazRbYxqiezHcc=;
 b=VfYXhBc9HAk3XTQub11H6s8/JCr3DbmM/Kj5DNdXlJF7lbRd8NsC6vq2pCr19YFLk4RddJfZEnrpnL/G0uYFsIbOdUeH2erHs8mq22Ru8vVuPTijlcLB0YKtzJrn7LOY3QDPaWbBNk5Wh7zasjdqOsWn191woBA+rwWtdrvX/x8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BL0PR10MB3444.namprd10.prod.outlook.com (2603:10b6:208:73::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 11:01:33 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 11:01:33 +0000
References: <165247403337.275439.13973873324817048674.stgit@magnolia>
 <165247405039.275439.3383676012677373945.stgit@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: check the rt bitmap against observations
Date:   Mon, 16 May 2022 16:20:58 +0530
In-reply-to: <165247405039.275439.3383676012677373945.stgit@magnolia>
Message-ID: <87wnelrbay.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0038.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::26) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 649d41ea-95ee-41c9-d140-08da372b6ff0
X-MS-TrafficTypeDiagnostic: BL0PR10MB3444:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB3444E441E8F8E42C91459EEBF6CF9@BL0PR10MB3444.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWUmbdOWYy5jICxwhNrqKabwfWa1zChT6LKyelzdT7OnstgsYn/tpY/Oq7bqWX1dkFatT0lXZCtXwz6NTZkhMWhmwWJCxKbPDcbnJN51onWX6Uo4b4IkI4K78i4xCJLds7qP+MmnLmB53CJ43BS2G7ebSDtnv512BF3wfV3eO1BAQVi6IuGN9uPBsOKaW8fbc6k+n75mqsNFATY5r7MT0+M2aNIfcPs+HwUsyZrUcWP02XHif3nDe2tGUySvS4BB3Yc/WLVVKFVgM/59ySDpCRd/k2rd3oR0OKhCfV6Igh6Aq1ZxsHfeJW22QRlSMGqGXwZbxRXKl0Lfny2TG9Ckn+JvYzPrBzmcYc/wHUISQJ3hprJOugJLDALjGnMNfF0ChDvJBzl++C+cArVRx7LMDxro1VLtQqQq7wffF082f/48yUfcqJ91VV6uDX8UfzW5BK5Ouu72ltElheVrCgqnKiFh5myIPKSh0h+BmHVtSzowjTtW+uV87CxtR15EyoAMbsqDGHIMIDJsM1F/3f46ahKHIPiOFE8Hf1hkErJgXwl0a0/PxMubFon120BQYjRxhvW6SQ/+70t3MtiEaMEHqBC81D48r4uLtk0f1H3WgcvkdvD/8j5c3Lz/+l3RuYNh+x9LyUN+bXj8CL4bghUJVEpx/Zf1n2s9nGozowEGHT7+4rDQsGKPY35eDfRUsQ+oVgbL4UmB9PdaLDEKhu/ONQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(5660300002)(66556008)(508600001)(86362001)(38100700002)(2906002)(6506007)(6666004)(6512007)(83380400001)(66946007)(4326008)(6486002)(38350700002)(316002)(6916009)(8936002)(33716001)(186003)(52116002)(8676002)(53546011)(26005)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oGn/COeKT8ztWoFeJFFFS3utiZPVgqr++C5st4OhMj7xRq4o2ll9J0dm2r70?=
 =?us-ascii?Q?e+BjMkVqhHl8siUJmLWUmIf7UcKT2S65odSssbUPs7cqD0+XXRuUWbS8Bltv?=
 =?us-ascii?Q?B+hydol0tA+t/L0yIdIQpPjcMsbICWGOBHxvAiKUIU79X8ryrtMLZTNqVsbA?=
 =?us-ascii?Q?Qeo/NNNGurWfz/jtcQmJAPCGUE8P2b8YRUmra1dnbsArOyEKBaufEU7YIbPt?=
 =?us-ascii?Q?1waBCXjxcLJJzmctRN8zSvZj6drkJZPmpuFQ/Oq3+/ykxpCnwzSjzRGkR+kQ?=
 =?us-ascii?Q?GL+wO526SFozpnOVEuzFqNuW0Hj7Cgfsb2WDd3FCgD3ugKIyX29I0ddCLZl3?=
 =?us-ascii?Q?gxJjCLdVSaBPxl3l6FKOy+cLypzN2b/9Fb4or9ZQTQFBi4IP1NQfZ8iHUAAj?=
 =?us-ascii?Q?BgoZ/MgPqrRX8fJNaBnql+VcsNDZbmbxnGLKJeUyyiOaD9zsBkQRyaTjlD75?=
 =?us-ascii?Q?ODCKh/lw/0HvT8ebGlhOgy6urwW/9mnzvnfXD7dRF3sGeKEd3Embj19rADmj?=
 =?us-ascii?Q?vwDkX/v4JZj1e0/aaREdFXA4+oxYTwZ+CNp7DEIpUfangw2u4QxC/wAbOHA/?=
 =?us-ascii?Q?a2IdzkM3L8c3/f4ckVrD0da2bs5AKrob6xTVrbY26u+1GIT0TgixQNgEmrKP?=
 =?us-ascii?Q?6MN885FXu2aFRMY8qXz5WhkaiZHr0ckasn1tncDQ8dw+n2QQq5SF4mtRkQwX?=
 =?us-ascii?Q?cITV1qQ655eIdbAFB61MFQ6FqAqsN0ha3yPDHhzdZWlXMMZl8bledY2YVaPg?=
 =?us-ascii?Q?if8QOKqvRuQ85aBKEaSd/CKT7IDqRQ8+Hc7WieUBui+IjSp+TimEDguOqvEJ?=
 =?us-ascii?Q?n3eNlvPODc+2VzbG/Wv4tfWSNiEyVnIyk6zGOJ0FdLdDG4nHCSgmqMpCA/Sg?=
 =?us-ascii?Q?gu7HHDSkYNw5sNEwvT4WANFqtBFCO0rpAmwoe91DvBeROI/0ygL1ySiMjiC6?=
 =?us-ascii?Q?JU1YLRRoP7VPXxg9osJrTsQYuZNh81/6wx0lrJvw+ub4AH0MS05r9NiOasOT?=
 =?us-ascii?Q?jL2R/Tj04dEWU5MpBeuDrF+7XRdOw+WwHQnW5wTRYEjn4cMmHkSCYDsBicYT?=
 =?us-ascii?Q?MxUogKMAz+iTiNDJs8lFfVpGh242+SGTmmEarWs9JMfsmahbP5qJUtk32SqD?=
 =?us-ascii?Q?jGfRtocX+Ey2m9cHM3CkIBvXUGDvd/RcrbXdTlIQ74Bp9jY3mTlvVtsY1P09?=
 =?us-ascii?Q?hQYGh0ReffuXdEvj/EbbDXOPqSe8CAFlGt0woZSOi9EPlV8nNBIBXeQ7jH36?=
 =?us-ascii?Q?9MsXTSv6UyeT8tCmmbxmf2pU+RX7NGzhXbYmrjJX38Dqgpd/QGZwXgRfCN00?=
 =?us-ascii?Q?kcvodJGZYSPoc2r8w4NO4LbVb4N3VJXJzvMgnJebXY80Ca2Dc9r3WSZLT3YK?=
 =?us-ascii?Q?Ye0Mw+FbDPXqntTQksFS+tACsXXj/7lpPf2MhbTRSaz/jFb3zF2OrOjorFDk?=
 =?us-ascii?Q?bTP0jrCpRof6ODjakxRFIwgex6YB5eQVGo3w8wa8XBtG0Um41sZfUt9Z0El/?=
 =?us-ascii?Q?ZDP8rugxj1hMe8A/CLRSG4qETlhEMOLtJehZcnJURpT+TZTa8JZ2ArGMW/UF?=
 =?us-ascii?Q?CzsghSccotcggNOUCSPz8Hrl++bbyxpxLnBFwI2IIOAR1G+JzlIFR3TVPNsV?=
 =?us-ascii?Q?igXd6Ki46AA9dBofHx94pKfmm4I2o8GR/u0ljxMJnnuFzrMgzejnsS74iyLb?=
 =?us-ascii?Q?E9RPgUY3LWL/UKn43h7UFgozWwgAGWaRFbT+aOeWpbZWIlZH3AdwzxKfboRG?=
 =?us-ascii?Q?S82NDr8UEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 649d41ea-95ee-41c9-d140-08da372b6ff0
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 11:01:33.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvkQCg02+MuW7AsevmyNgIgXrkO61xD46BxuZ3j21btqzw4EPyutZG0todWZOubjuy0DeZvr8YaDWlL9C1xc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3444
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_06:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160064
X-Proofpoint-ORIG-GUID: vrpiDz91ajKp7Uk-bpXjGAfHww2pUB4I
X-Proofpoint-GUID: vrpiDz91ajKp7Uk-bpXjGAfHww2pUB4I
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 13, 2022 at 01:34:10 PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Teach xfs_repair to check the ondisk realtime bitmap against its own
> observations.
>

Looks good.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/phase5.c |    1 
>  repair/rt.c     |  168 ++++++++++++++++++++++++++-----------------------------
>  repair/rt.h     |   11 ++--
>  3 files changed, 86 insertions(+), 94 deletions(-)
>
>
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 273f51a8..d1ddd224 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -608,6 +608,7 @@ check_rtmetadata(
>  {
>  	rtinit(mp);
>  	generate_rtinfo(mp, btmcompute, sumcompute);
> +	check_rtbitmap(mp);
>  }
>  
>  void
> diff --git a/repair/rt.c b/repair/rt.c
> index 3a065f4b..b964d168 100644
> --- a/repair/rt.c
> +++ b/repair/rt.c
> @@ -119,6 +119,85 @@ generate_rtinfo(xfs_mount_t	*mp,
>  	return(0);
>  }
>  
> +static void
> +check_rtfile_contents(
> +	struct xfs_mount	*mp,
> +	const char		*filename,
> +	xfs_ino_t		ino,
> +	void			*buf,
> +	xfs_fileoff_t		filelen)
> +{
> +	struct xfs_bmbt_irec	map;
> +	struct xfs_buf		*bp;
> +	struct xfs_inode	*ip;
> +	xfs_fileoff_t		bno = 0;
> +	int			error;
> +
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
> +	if (error) {
> +		do_warn(_("unable to open %s file, err %d\n"), filename, error);
> +		return;
> +	}
> +
> +	if (ip->i_disk_size != XFS_FSB_TO_B(mp, filelen)) {
> +		do_warn(_("expected %s file size %llu, found %llu\n"),
> +				filename,
> +				(unsigned long long)XFS_FSB_TO_B(mp, filelen),
> +				(unsigned long long)ip->i_disk_size);
> +	}
> +
> +	while (bno < filelen)  {
> +		xfs_filblks_t	maplen;
> +		int		nmap = 1;
> +
> +		/* Read up to 1MB at a time. */
> +		maplen = min(filelen - bno, XFS_B_TO_FSBT(mp, 1048576));
> +		error = -libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
> +		if (error) {
> +			do_warn(_("unable to read %s mapping, err %d\n"),
> +					filename, error);
> +			break;
> +		}
> +
> +		if (map.br_startblock == HOLESTARTBLOCK) {
> +			do_warn(_("hole in %s file at dblock 0x%llx\n"),
> +					filename, (unsigned long long)bno);
> +			break;
> +		}
> +
> +		error = -libxfs_buf_read_uncached(mp->m_dev,
> +				XFS_FSB_TO_DADDR(mp, map.br_startblock),
> +				XFS_FSB_TO_BB(mp, map.br_blockcount),
> +				0, &bp, NULL);
> +		if (error) {
> +			do_warn(_("unable to read %s at dblock 0x%llx, err %d\n"),
> +					filename, (unsigned long long)bno, error);
> +			break;
> +		}
> +
> +		if (memcmp(bp->b_addr, buf, mp->m_sb.sb_blocksize))
> +			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
> +					filename, (unsigned long long)bno);
> +
> +		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
> +		bno += map.br_blockcount;
> +		libxfs_buf_relse(bp);
> +	}
> +
> +	libxfs_irele(ip);
> +}
> +
> +void
> +check_rtbitmap(
> +	struct xfs_mount	*mp)
> +{
> +	if (need_rbmino)
> +		return;
> +
> +	check_rtfile_contents(mp, "rtbitmap", mp->m_sb.sb_rbmino, btmcompute,
> +			mp->m_sb.sb_rbmblocks);
> +}
> +
>  #if 0
>  /*
>   * returns 1 if bad, 0 if good
> @@ -151,95 +230,6 @@ check_summary(xfs_mount_t *mp)
>  	return(error);
>  }
>  
> -/*
> - * examine the real-time bitmap file and compute summary
> - * info off it.  Should probably be changed to compute
> - * the summary information off the incore computed bitmap
> - * instead of the realtime bitmap file
> - */
> -void
> -process_rtbitmap(
> -	struct xfs_mount	*mp,
> -	struct xfs_dinode	*dino,
> -	blkmap_t		*blkmap)
> -{
> -	int			error;
> -	int			bit;
> -	int			bitsperblock;
> -	int			bmbno;
> -	int			end_bmbno;
> -	xfs_fsblock_t		bno;
> -	struct xfs_buf		*bp;
> -	xfs_rtblock_t		extno;
> -	int			i;
> -	int			len;
> -	int			log;
> -	int			offs;
> -	int			prevbit;
> -	int			start_bmbno;
> -	int			start_bit;
> -	xfs_rtword_t		*words;
> -
> -	ASSERT(mp->m_rbmip == NULL);
> -
> -	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
> -	prevbit = 0;
> -	extno = 0;
> -	error = 0;
> -
> -	end_bmbno = howmany(be64_to_cpu(dino->di_size),
> -						mp->m_sb.sb_blocksize);
> -
> -	for (bmbno = 0; bmbno < end_bmbno; bmbno++) {
> -		bno = blkmap_get(blkmap, bmbno);
> -
> -		if (bno == NULLFSBLOCK) {
> -			do_warn(_("can't find block %d for rtbitmap inode\n"),
> -					bmbno);
> -			error = 1;
> -			continue;
> -		}
> -		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> -				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
> -		if (error) {
> -			do_warn(_("can't read block %d for rtbitmap inode\n"),
> -					bmbno);
> -			error = 1;
> -			continue;
> -		}
> -		words = (xfs_rtword_t *)bp->b_un.b_addr;
> -		for (bit = 0;
> -		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
> -		     bit++, extno++) {
> -			if (xfs_isset(words, bit)) {
> -				set_rtbmap(extno, XR_E_FREE);
> -				sb_frextents++;
> -				if (prevbit == 0) {
> -					start_bmbno = bmbno;
> -					start_bit = bit;
> -					prevbit = 1;
> -				}
> -			} else if (prevbit == 1) {
> -				len = (bmbno - start_bmbno) * bitsperblock +
> -					(bit - start_bit);
> -				log = XFS_RTBLOCKLOG(len);
> -				offs = XFS_SUMOFFS(mp, log, start_bmbno);
> -				sumcompute[offs]++;
> -				prevbit = 0;
> -			}
> -		}
> -		libxfs_buf_relse(bp);
> -		if (extno == mp->m_sb.sb_rextents)
> -			break;
> -	}
> -	if (prevbit == 1) {
> -		len = (bmbno - start_bmbno) * bitsperblock + (bit - start_bit);
> -		log = XFS_RTBLOCKLOG(len);
> -		offs = XFS_SUMOFFS(mp, log, start_bmbno);
> -		sumcompute[offs]++;
> -	}
> -}
> -
>  /*
>   * copy the real-time summary file data into memory
>   */
> diff --git a/repair/rt.h b/repair/rt.h
> index f5d8f80c..2023153f 100644
> --- a/repair/rt.h
> +++ b/repair/rt.h
> @@ -3,6 +3,8 @@
>   * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> +#ifndef _XFS_REPAIR_RT_H_
> +#define _XFS_REPAIR_RT_H_
>  
>  struct blkmap;
>  
> @@ -14,17 +16,16 @@ generate_rtinfo(xfs_mount_t	*mp,
>  		xfs_rtword_t	*words,
>  		xfs_suminfo_t	*sumcompute);
>  
> +void check_rtbitmap(struct xfs_mount *mp);
> +
>  #if 0
>  
>  int
>  check_summary(xfs_mount_t	*mp);
>  
> -void
> -process_rtbitmap(xfs_mount_t		*mp,
> -		struct xfs_dinode	*dino,
> -		struct blkmap		*blkmap);
> -
>  void
>  process_rtsummary(xfs_mount_t	*mp,
>  		struct blkmap	*blkmap);
>  #endif
> +
> +#endif /* _XFS_REPAIR_RT_H_ */


-- 
chandan
