Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95238C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 10:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345669AbiDKKor (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 06:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbiDKKoq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 06:44:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1447E3F897
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 03:42:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B9G4KR014133;
        Mon, 11 Apr 2022 10:42:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Kjz2Lgy+3OH0rf6R3ieCwpMZSi08aDV/ZfgOG2bhEyc=;
 b=HstX8wb79aJUS7lT/6zdsxR/FGEFadLQWoxObEhal3XvuK6Xs5HAvvLxdUi7CXaxVXWI
 9rfTdmkKTTejHwHJYq1rTzkZTTC/n0KpALQgiQ8GfFsjxWuoQmougiMmDHHoqwe3He9y
 lA1qQVf5yrYJ71CIMKYrbvKkUOUEb2Q4rGAJZ2pcHY9JKAZfV+rSNt1Nt6LY/0G0Ii1t
 Jwo5Sk/oXpS9U4yQMu4ZRPmmcCzxn2JEBIx8FKoEHxV6KPqyxJuNydbaw+g6omv+7StQ
 VgJM3VeiDYRdXtEbBi7Fl2VV1NdVTjkimaErJ/2q++qcPG0UEJ2rILQatTjafiLZHgsd 5Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptu843-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:42:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BAg6If032901;
        Mon, 11 Apr 2022 10:42:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9g4a4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 10:42:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XW6T3+yyDpxY1DLU9/cEoIGeCWIQi5r2uSjo80lKvUtYgvMAOTCgf6Q/f20lIAnOm/if6LI7bmY2rQCFvxa1eZhjWPuWRNrh2tUSg3vgXqfJf/7h3hNkMwaDyPKL5wTNyRgUiRHrujW87QaIlhADRXtzN6KHHFuekoWrLxtBK7si/mURSmEZQzJPuNDe1Q/VfpR1VWBl37B+ldX3Dpn7cPztBi3DlCNitm1MJt05XNATX/JGNF4oi5mAMqkdzWkEkrJ4nOUoICR4+RBbfFFdAdAUrvlkykzsG565s0xNqKkneyPEtKYPS/57ByWmw7bXu1rMEQ9DkwnbwY7Oj5F7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kjz2Lgy+3OH0rf6R3ieCwpMZSi08aDV/ZfgOG2bhEyc=;
 b=ApeVu/G3AdX9ouMwpVHz1FxiGSRysLCf1lygnbCSZfVYZpKSGolG7Ve/vJyA0ffU4oHrjoPcon5IitWtHhmo1vstaz/HRNnMuj8ASoyVYiWv7eXxUkBK73WIDBvutJ56Qq1qYZhGDfz/WIko+SCCoPAChYAa8pv7eAo0sQH+gofN7/FjXrZ7aRL+l1ctk/nY60IGv5305zOUW0Y/pty2VlR7zVMQeT9PBAWxDFEYr0UftpCgoyXvVu4rT6rDPrEdgdqv5WKdEPDKWw7gti2yaRgWQ/LCz9y2WZF9280UVldnmpiYX11U9e5m1UFCnQvEUwQlwizjgKq68wvUtEFQbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kjz2Lgy+3OH0rf6R3ieCwpMZSi08aDV/ZfgOG2bhEyc=;
 b=GQtrcbkwvNdrrIrxCtg6+G84T18JuNpxeJG/y/pAuXSGLTjd0L7GLgv4EnKi3iiXz4E2qqq2GC65qdXiCj9QHrHfpt93KA7+31XCPdK3UtUCfjgqJDvFotQd3Qms+AGSMHmrYSiX4KNE9Odfh4AiF3nJB3myrEkYK5t7TxnMnaI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 10:42:29 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 10:42:29 +0000
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-5-david@fromorbit.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] xfs: convert bmap extent type flags to unsigned.
In-reply-to: <20220411003147.2104423-5-david@fromorbit.com>
Message-ID: <87lewbvr3l.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 11 Apr 2022 16:12:22 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e440a631-581f-4e64-9840-08da1ba7f9ce
X-MS-TrafficTypeDiagnostic: BN0PR10MB5048:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB50485AD048F6691899C0FBFFF6EA9@BN0PR10MB5048.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5Y8Evk/sk8rp9JkJQ5vAQ+a9v1Q7UDUabsVPnqZ/z+3Kfw+8YWXQdbOSogFyr5d4JppNXcLA1bvOKlPpZhujYgqQSOzX8mMExIv1Q4B9FN8OjLfkwcGlvHxuFk6C1X0N17geSe+IS4vuA/fTcBLRBbrYXq/xlkshBjm6bkYN93k27G0ianO74/OSXr9hvQ/MEV5J13Hv8bv6COuxSAg7w20P/5KOqS5hEppVPTpWMe9eF+hZeEKzIlE9uuId3SZaN10658/inQnpQ0X7B1O59e6scJEzZiE7xqCDKDj/6C3Kbx37KOPbbvmC2eFZ0ZoDeEZW/9lI3g/4zDZrQAzL24V1O7R6gFGVrr8R1V5IqgfcKE0ksCGN0EWTYr/codjHL83YZnFNbq9GXMoVFsD8DcYkXW7zcWtS3H3mvXD3PHLjFQLg5F4bq2tMNdJvkw6cmZMeyA6YeLo3+FrkMY1PBfu/qfR4T4nWgLPpXyFlFA/coaMUhXG/LnjaNFtlavSyyR+TfbIbFjnMlYmQIKTwLy0Zo45bIKL/vEyFEEUdI0XbbrbFjyvNDm8E4xrmwEBIXmiMKTOg7rpMOZ2oMRnWiB9s0iO83aDncLRYciEPHKRl6PRuAdRW/FPa5gCp1IjRa0DkgZga0y4U6SYeoWcBzwUHAwW6sVNX5FLYJJsMGK/jqexHNxGtmnQzGQHCZm44WNXauOOP3KdVrXhXNOjYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(8936002)(38350700002)(38100700002)(2906002)(5660300002)(9686003)(6512007)(66476007)(316002)(6506007)(52116002)(53546011)(26005)(6666004)(186003)(33716001)(508600001)(6486002)(6916009)(4326008)(8676002)(66946007)(66556008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FdyZU9QXisGN4vBmWfCeIFu4XMnxjMWus+APgAjnuP8eQgH8mwCacFg6Z1/v?=
 =?us-ascii?Q?mfrvStIQb9WWSqFOnCqfrjzxKaxtJZVDT7hx6BHEgHUV3IQVrqnxzqLH1jBY?=
 =?us-ascii?Q?KKxxf7YGSepfk6poREI04Xa06SCCYuvrBX2VLmR4o6XTu8DgHnj+vgBo3ZeA?=
 =?us-ascii?Q?9krpbT0cttaeJvwx7OFjA4OK2CeC2efWjiLZ2XB7CZYv4sfXXiXIqO3AxxNN?=
 =?us-ascii?Q?Ey6XHWrpxQ2QC2OM7I9Ec5fC2iKHMYrzc88wfHwjLNahgZngVX9cEsOxeF1Z?=
 =?us-ascii?Q?bJSChU3VOXHNvxb5WlAuVYPi2mvH4VVmS7nHhDHO+OYRNPcvAd9H4AFi+yd3?=
 =?us-ascii?Q?7ZtnKAx17cQhRTsUvnR/xsZ/ebGC1XcWOtWXNaccSyZt2I4doSwHLNk8lEGg?=
 =?us-ascii?Q?yMDRdBcwrIkhrsss2RBh8r8yvBy4YCe/OAdBihEJaYZ5qfbFhctJLfG86n5N?=
 =?us-ascii?Q?MWABC2XCst7LwFTpTMy6004Vx30hL7Bjkd4Fan6KBWKRF6SHgcKjsRL8s+ai?=
 =?us-ascii?Q?qGJfZ6tPLe7LxjAt3xzY1boQDMx+Tbtu4fki4msuZWRu+XkYU0tpRLgJ30ZF?=
 =?us-ascii?Q?E3OZ2Sod7DrCPL3WdiYtu9MhTSDhxREtgRI0Fv5h8uwEhjsM+3fO/P47wzFE?=
 =?us-ascii?Q?IbomPujP+M/iEia9ozbaU+gjhPDDJUKbKEr8r/0d4L+W6UN5G8VLBEOaRAXm?=
 =?us-ascii?Q?h3Hpy4v56UxSt7QSFw97GFuJeNsGzFvw3lE2ZIQ9jstHl8Abnu4uWGXpny71?=
 =?us-ascii?Q?4A9Bsp+/34oj1swsbCbm+lQ8zPwIlhZ4mOrlhG1XFrDaZfElqK4E8AJKx1lu?=
 =?us-ascii?Q?EGyG0NjiyYRX8sFQz5E5PwObMHgCWGIylTuK8B+sgN3Of6qmK41XTCgRxc4T?=
 =?us-ascii?Q?lLBnC3Sqq3k9E2TuBHOW3k/dy2ry/Zkw18XgjtRZ2Bj4tz4OEqbw+TQKCTsv?=
 =?us-ascii?Q?+NdhCQVVrgARrKhwkCay9/bnKm2WU1GrcEB/XrHeKvRJINUlyPulHR27MDMO?=
 =?us-ascii?Q?coVNYHcdRpVDiwPxPJtPfcjLdjjHfsqaTOq8rUvxImyxl7hSBCFUVglUfAi6?=
 =?us-ascii?Q?+TAqSHVtplqug3HWQiIDFs9kLxeUhzx7Zgau13LZVLfHkeOB8x9nF6X2GjXx?=
 =?us-ascii?Q?0Zhz+beO0fTSbE1T6BAsCVLUglgoPO3RA3u5ha4AHISxKhJNik8xXntd3Pym?=
 =?us-ascii?Q?Y058k7fKbx63QKbTDm/v+CCS6Az0I1KSrKAJMGGSQn+wx//bVvJMQJYXawby?=
 =?us-ascii?Q?1CqYtB+Gt4yovKUcreMUQv3bVJtW5fQZ4yy2PORhrff6uP7IuxtQpY6geH4K?=
 =?us-ascii?Q?qWc9V1CQiTkSGOhIareXUYdaUWK33oCDc/HJIeV38pHMDX4Pc+CfM9eRdOo0?=
 =?us-ascii?Q?hErQrzCjtUIbpqkQaiRxU67nXgcpN8+EDOFShOOodLIgtrGwWhudyycVt0N0?=
 =?us-ascii?Q?+2ppI6qQ5N1Kr3xSWthCffHdLYvBRas2qMD6qNajSFY5jtmSqTukHYyIG0US?=
 =?us-ascii?Q?9m9QiIqOzZ3X2DIXs6vf6EF7SzJFF0YauwaJYufuBLj5ZMF8gQymvuTKwdgD?=
 =?us-ascii?Q?s5zHsHPvRIQejbBeMkrdZ13or+RWzxdNQmP+05g1XCe000AkAun96EABiVRB?=
 =?us-ascii?Q?lYXTCqVVQir1rMcbXf35TYRyLnuDrYSXPUcMGwem34MmOfEO0ayPBmq98fjT?=
 =?us-ascii?Q?u1DPYzpgSC9xyG3pANKvtKyZU2ecM+XpujvfUYT81Jz62xx8Ak5ZIO+uB+/d?=
 =?us-ascii?Q?jj5DrSGzY03CgzS30qwfMMq2va0+D+I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e440a631-581f-4e64-9840-08da1ba7f9ce
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 10:42:29.3869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpwyRcokd8FbveXI7PMThlZY+qk1x4qYQS9qGG8Lgl6PMsflf3MtLOr8vVWNXNtg4Wx2Nwle0FoeWIwhyVlNjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_03:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110060
X-Proofpoint-ORIG-GUID: tf-pjNzFJysInaQBtwEWCTYar2bUBf2n
X-Proofpoint-GUID: tf-pjNzFJysInaQBtwEWCTYar2bUBf2n
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Apr 2022 at 06:01, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> 5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
> fields to be unsigned.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 14 +++++++-------
>  fs/xfs/libxfs/xfs_bmap.h | 22 +++++++++++-----------
>  2 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 74198dd82b03..d53dfe8db8f2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1399,7 +1399,7 @@ xfs_bmap_add_extent_delay_real(
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	xfs_filblks_t		da_new; /* new count del alloc blocks used */
>  	xfs_filblks_t		da_old; /* old count del alloc blocks used */
>  	xfs_filblks_t		temp=0;	/* value for da_new calculations */
> @@ -1950,7 +1950,7 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_bmbt_irec_t		r[3];	/* neighbor extent entries */
>  					/* left is 0, right is 1, prev is 2 */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_bmbt_irec	old;
>  
> @@ -2479,7 +2479,7 @@ xfs_bmap_add_extent_hole_delay(
>  	xfs_filblks_t		newlen=0;	/* new indirect size */
>  	xfs_filblks_t		oldlen=0;	/* old indirect size */
>  	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	xfs_filblks_t		temp;	 /* temp for indirect calculations */
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> @@ -2626,7 +2626,7 @@ xfs_bmap_add_extent_hole_real(
>  	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
>  	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
>  	int			rval=0;	/* return value (logging flags) */
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
>  	ASSERT(!isnullstartblock(new->br_startblock));
> @@ -4801,7 +4801,7 @@ xfs_bmap_del_extent_delay(
>  	int64_t			da_old, da_new, da_diff = 0;
>  	xfs_fileoff_t		del_endoff, got_endoff;
>  	xfs_filblks_t		got_indlen, new_indlen, stolen;
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	int			error = 0;
>  	bool			isrt;
>  
> @@ -4926,7 +4926,7 @@ xfs_bmap_del_extent_cow(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec	new;
>  	xfs_fileoff_t		del_endoff, got_endoff;
> -	int			state = BMAP_COWFORK;
> +	uint32_t		state = BMAP_COWFORK;
>  
>  	XFS_STATS_INC(mp, xs_del_exlist);
>  
> @@ -5015,7 +5015,7 @@ xfs_bmap_del_extent_real(
>  	xfs_bmbt_irec_t		new;	/* new record to be inserted */
>  	/* REFERENCED */
>  	uint			qfield;	/* quota field to update */
> -	int			state = xfs_bmap_fork_to_state(whichfork);
> +	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
>  	mp = ip->i_mount;
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 03d9aaf87413..29d38c3c2607 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -124,16 +124,16 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
>  /*
>   * Flags for xfs_bmap_add_extent*.
>   */
> -#define BMAP_LEFT_CONTIG	(1 << 0)
> -#define BMAP_RIGHT_CONTIG	(1 << 1)
> -#define BMAP_LEFT_FILLING	(1 << 2)
> -#define BMAP_RIGHT_FILLING	(1 << 3)
> -#define BMAP_LEFT_DELAY		(1 << 4)
> -#define BMAP_RIGHT_DELAY	(1 << 5)
> -#define BMAP_LEFT_VALID		(1 << 6)
> -#define BMAP_RIGHT_VALID	(1 << 7)
> -#define BMAP_ATTRFORK		(1 << 8)
> -#define BMAP_COWFORK		(1 << 9)
> +#define BMAP_LEFT_CONTIG	(1u << 0)
> +#define BMAP_RIGHT_CONTIG	(1u << 1)
> +#define BMAP_LEFT_FILLING	(1u << 2)
> +#define BMAP_RIGHT_FILLING	(1u << 3)
> +#define BMAP_LEFT_DELAY		(1u << 4)
> +#define BMAP_RIGHT_DELAY	(1u << 5)
> +#define BMAP_LEFT_VALID		(1u << 6)
> +#define BMAP_RIGHT_VALID	(1u << 7)
> +#define BMAP_ATTRFORK		(1u << 8)
> +#define BMAP_COWFORK		(1u << 9)
>  
>  #define XFS_BMAP_EXT_FLAGS \
>  	{ BMAP_LEFT_CONTIG,	"LC" }, \
> @@ -243,7 +243,7 @@ void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap);
>  
> -static inline int xfs_bmap_fork_to_state(int whichfork)
> +static inline uint32_t xfs_bmap_fork_to_state(int whichfork)
>  {
>  	switch (whichfork) {
>  	case XFS_ATTR_FORK:


-- 
chandan
