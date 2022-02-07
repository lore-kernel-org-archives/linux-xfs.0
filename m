Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35067C43217
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 06:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237658AbiBGGRu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 01:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiBGF2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 00:28:01 -0500
X-Greylist: delayed 1939 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 21:28:00 PST
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F5AC043181
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 21:28:00 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2173HNdB021140;
        Mon, 7 Feb 2022 04:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=bYOdMFNNBEHYWu+iQeuecn4vUj0uT3urOdYaRXZmw2M=;
 b=GsOvE7EpyW0gZR46y6Ww/rV0fC+Cg5V7teAVlyneCFyfKo5duqXgHlFeYr8jLkggybSU
 1IA88LFSu0uf5rufvkbx44cL7XhWjeRxtjRwFDK8SUZ8X5Vj/YXpqOhLiX2RKXE/FTdx
 t8YKv6rzZ3QW+Ns90PUyd3y02gfo7m9PEzGK6Q/NUxItOmK8pG+rBNgu+7AYIUJ4spnG
 d/DOEbg0ly/zQpyFMUczqpyhl/keHPOE5DNkheDPoU/FlVb6O964Zj95oetXHtXR/GQo
 wiG4MPQqB2Gx6kr+oQBzvPjljG+/1RFdSyjHPcByf+6PSu6TnPCu1mhNb9tvbUzhHlAr CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1fndcqex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:55:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2174jgLF186153;
        Mon, 7 Feb 2022 04:55:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3030.oracle.com with ESMTP id 3e1ebwcvm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 04:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsqWqjMTTJ6Sg52uzhX969u0txdaDZ0dqrAJTYzh56WBMpblV5Nl3WAjT5cXo5KWj/8CdHIlKxpRFBQkpXdZEROUv4VXaEOIedy9J7bVoaflQEDIHuvsowWOGuRlKJYikiuukKddqYL4TKoA7+zomby27E4bPm8iiOCh4CuOX0yBejFNfRo1OMGV/ANgTT9dFov1llljm1XQf+3DTYWCJFuA1aNk2svbismgaxw+8hpsnHWn4NpLOMtaMUcxODe22MUNsG5GlA6dkHD/nxnZ3/xwOcZur8hF8aCFsaOEynaAzYHrX5vkC2su7b3/5wcYDe1znALJyPT0wBAQNtlGQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYOdMFNNBEHYWu+iQeuecn4vUj0uT3urOdYaRXZmw2M=;
 b=OVwkOY4vAFpVnIoErSOhN/l+vHb2/zngUFIX794kJt/ET0xKlX43kkuQXJT78GJOpMPgkSy8vapckcCn28rEVnJOPoAlN9LJHW6OiAxdkVmu0Fmj942KK9zopyDuGYMTHBJQrYCGG6h3jalAeEKVDcgOoHrnNFfPJL3DQR4ZY+Y2v0WVDl10rHdhFBxoBhVDldK9uYPcW5j6HSADGcX0oJQjk0LinuOCQRJ1eLzjV/JGc+940cRmpmcx5ZEXRFPSCRa8QB+qS0sfZORo9yxxO3h+9viRXfLkLdIZyOdnjvaG+8KO1MNQMKwIYmeC7TCOtNtG1kb/zdVsUK6YysFlPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYOdMFNNBEHYWu+iQeuecn4vUj0uT3urOdYaRXZmw2M=;
 b=IIS7CuDWMggFU90bigXua/9GlNBg7/F2C5lCAn48zfVgBSiOsatJqBTz/O448BGIbow6WfA1phWyfuJTbUQw0cnd6FSM058i5xFgEmgt+/1F1JLWAFrQajs8eRUU4e+ggf5817vgXib7UQ3ai3fJqo3d3dsDxzEaXLm05EvblKA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM5PR1001MB2156.namprd10.prod.outlook.com (2603:10b6:4:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 04:55:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 04:55:27 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
Message-ID: <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220201200125.GN8313@magnolia>
Date:   Mon, 07 Feb 2022 10:25:19 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:404:e2::17) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8009e099-1590-44c2-b4c6-08d9e9f60ebb
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2156:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB21564F16671E539AC45FBC91F62C9@DM5PR1001MB2156.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ngt7ww+icapmVKUi6THsaFssoDDYMEZn+hfABIaPWm0t2kzorSSsxpFOYdSWrJm0zdoaWtR1LJxDsXoy+2TW6erqB7tVJnDno8sRo+p3r83IDd8ywJ1nr2wGPKJf5rLSjrPkU2AF44RUshjuBcntb4O4yAbxnDwr4km7hydwAE+IzWAD9FRejmMZ5zGan9+Ln0ESJbmo3/VYXBOzPE1lmWdV+mT4zlBBYWRqmngFUbGLovomNx++l2vvgxLG/wEkc0bS1Z8vNbgetYOV1YMLHgmrIMiLwS0Y/EpmLKGs9csn2nizQQU8D6xBTG9uBXFzNGGWvSAWs2uMPznaw2NwxrnIk1xMw/D+Q05XyEwt+pKqfPXbJuk/ZLCZGanbAq7jDrqVn2zzCPZIvoGF9ZI7SYA30TlKwJ9fOgZv2ytEIiNuTmGWvvWQ+BhOfqfKzPK+njIwkJF3rrSOay2VgL0Buv1Mg4LcrOqAkbmIodfJuKWIkKYVuuWtAW9jNSMCQzMLjqqsZ4WKc0OquMwF2HTRxRyisbgPTEjk2oDLLzQkkmilc2dhjFqGsSHFEDU314wLW3rLohV5/qqpmUeVnZPibfFWD5JlURvrqiMW8fexbu2hqI6Se4U42hXf89bjOGZhnYBBEgoEfF6dr8a22TDosVuAMWkXMtEjadhP3bSFTY36kBbE8I4+aujMvzll8P3wRVxYjRhhd75YJGa93ngJVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(9686003)(38350700002)(6512007)(508600001)(6506007)(6666004)(53546011)(52116002)(66946007)(83380400001)(8676002)(8936002)(66556008)(66476007)(4326008)(6916009)(186003)(86362001)(26005)(316002)(38100700002)(2906002)(5660300002)(33716001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?41njhXBEC2EDML8S/n+9V5IBNLxb2XWpYTmJLxdcwBNtSrUqQee7bBQwKchi?=
 =?us-ascii?Q?0na4WGFWlbioFOZXRYHIpYBkywTXnK13AVhXPnMkQgv0Yb6ZfwWGHSLiZZhX?=
 =?us-ascii?Q?8m/satXtRg2fCNtH9ii8r4fJ4TIuiVQ69ChivB5iO7+s/JcQYLgUA89c4LOv?=
 =?us-ascii?Q?zQ1lPVrnaFWYdUsTfE4EBTDFMPpm8gug+UkSZxK8i/kncBuI5duvcXGmldqk?=
 =?us-ascii?Q?mSVkYPoIiB48z1+lXgQPJrOoFXRmz0I0hlrZKCInVjckWDKfAH7RHQLXqb3K?=
 =?us-ascii?Q?AaPx+qdZmV93UKW70gHaHOBYSv6vfZ7kgLH/flWDQgOdTSRz8AUPxw+HTc7G?=
 =?us-ascii?Q?1ZHI1UAGUwE5gSgd6Y5+3/HOjS3DR6OfYwMBYO//yFDxwKFqIQ48v4/QiDVm?=
 =?us-ascii?Q?2plzxY+47+Um7NkT31g/TgwDGAoReOsj9xER7tqUYI5JKOE89mzE7QvsbWjN?=
 =?us-ascii?Q?58Ycbb28bg+NWNO0lpvEuB5kZkE4glOBDaVe0/8pkB/ejYhqdWSM/LDSiTyP?=
 =?us-ascii?Q?vxrB/Tu713tVCVLV1VSyBdHPGTs0vE4tbnmc1KvwSGEz6eOd33qyngxOke/+?=
 =?us-ascii?Q?UlZh7LmTou1wqmrMcEehm/rTwtccEqzDb5iUuLsg6QxOAS8kqS00pj+q0IoK?=
 =?us-ascii?Q?o6cvzcpLT4ao49WjyltyphzDk2GCJJ2jPcRCCoY+9Qy53ew0mW9SWkhi1stV?=
 =?us-ascii?Q?VjEsvhtGQ1RPcb5qzV5R6xFhceVvrxST4PUh+o+Y3qqavepa0ECfHdg4ryKo?=
 =?us-ascii?Q?MTS9+eQuJHxzdnMb7RQ6Hnmwpw7cJtrba5uZlPG54JHdhYNq16sG1NvztERY?=
 =?us-ascii?Q?P7UJG009zBDpyNKIie8GFZu8mtvvOHgkgy1uyqQAEpv49eZxnV69Lg7OthJp?=
 =?us-ascii?Q?phMXBu1RSrn8ZY89uvwltbj6i5MMKxAX/TuvefpaLJsXJbIS6OHHg3GdP7vf?=
 =?us-ascii?Q?1TuZ0U/8huMxDsg+qa8jH+8k5Kc1YNFJSYJF6XxMRs/3boiVyT9Zr9yy2sGe?=
 =?us-ascii?Q?XYCAXRmbT4qKkvn/yHdBOwFmeJSMrwOH03XSa0kRAbzK6OKVfM3coAwFckgV?=
 =?us-ascii?Q?GX7ekImWylZlaXmHlVg8Xfy+8ggyrKugMymGVvyy1Y2SN9vKVM6oCo0OrZBU?=
 =?us-ascii?Q?75oEgPNZWoiFch0wEwBURVzGlRiYtVyoHMgLR8+tpH5gUUZQfbjRgZJ/r4/l?=
 =?us-ascii?Q?KF37DKerqPTefBn0mfKyUH7GFcWEuISKYxXXt+2JYpoGp/xH7xjzhJT7/MoR?=
 =?us-ascii?Q?Uo5pVJz1xOBA6x+1jDG0QRzdlYSR/Oi5yTnOQJSVqdkImuyQT25f/LjNLp7H?=
 =?us-ascii?Q?LW+s3lnidKOusDUqKHY3sfGEZnMrDPL4+qNDj7J9c7NPfYEEtsxkp1OyotvQ?=
 =?us-ascii?Q?dhPU6vaVs6gNF8DsZAgJIJ3MLan8gKqRCUOSkbswrMajtzUumLpOKsGAa5Nj?=
 =?us-ascii?Q?fqnD7+BjpRiiMOEtUOWI59he+iSMjr28JNVAbh9sP+rEmRTSd3IY85bsxii1?=
 =?us-ascii?Q?boYnix8HQsbenLRLtw1wdS4Nn8Hi65clQFqT7F2KZGki3JY3py2VtqncXoPy?=
 =?us-ascii?Q?8OdQ7Xpv3/Datpe5WRdUD9hQgyynmQ9CMN86aoKNxBw3r/oGzxXZjSYWYu7Q?=
 =?us-ascii?Q?UmmibRk8lKDRRMGVrur3OoE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8009e099-1590-44c2-b4c6-08d9e9f60ebb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 04:55:27.2444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPMeWZVFlA1f+SSzO268Gb23B/JAY0ZNTlDaC3VFF42U1/6lRt9rG7qBHlFGu4IEL+y6SpOHG+1fWwgUJrUPOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2156
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070029
X-Proofpoint-GUID: M2a4GgLnsI_gmWZqw1VDsDd7JfA0fj4H
X-Proofpoint-ORIG-GUID: M2a4GgLnsI_gmWZqw1VDsDd7JfA0fj4H
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
> On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>> This commit upgrades inodes to use 64-bit extent counters when they are read
>> from disk. Inodes are upgraded only when the filesystem instance has
>> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> index 2200526bcee0..767189c7c887 100644
>> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>>  	}
>>  	if (xfs_is_reflink_inode(ip))
>>  		xfs_ifork_init_cow(ip);
>> +
>> +	if ((from->di_version == 3) &&
>> +	     xfs_has_nrext64(ip->i_mount) &&
>> +	     !xfs_dinode_has_nrext64(from))
>> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>
> Hmm.  Last time around I asked about the oddness of updating the inode
> feature flags outside of a transaction, and then never responded. :(
> So to quote you from last time:
>
>> The following is the thought process behind upgrading an inode to
>> XFS_DIFLAG2_NREXT64 when it is read from the disk,
>>
>> 1. With support for dynamic upgrade, The extent count limits of an
>> inode needs to be determined by checking flags present within the
>> inode i.e.  we need to satisfy self-describing metadata property. This
>> helps tools like xfs_repair and scrub to verify inode's extent count
>> limits without having to refer to other metadata objects (e.g.
>> superblock feature flags).
>
> I think this makes an even /stronger/ argument for why this update
> needs to be transactional.
>
>> 2. Upgrade when performed inside xfs_trans_log_inode() may cause
>> xfs_iext_count_may_overflow() to return -EFBIG when the inode's
>> data/attr extent count is already close to 2^31/2^15 respectively.
>> Hence none of the file operations will be able to add new extents to a
>> file.
>
> Aha, there's the reason why!  You're right, xfs_iext_count_may_overflow
> will abort the operation due to !NREXT64 before we even get a chance to
> log the inode.
>
> I observe, however, that any time we call that function, we also have a
> transaction allocated and we hold the ILOCK on the inode being tested.
> *Most* of those call sites have also joined the inode to the transaction
> already.  I wonder, is that a more appropriate place to be upgrading the
> inodes?  Something like:
>
> /*
>  * Ensure that the inode has the ability to add the specified number of
>  * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
>  * the transaction.  Upon return, the inode will still be in this state
>  * upon return and the transaction will be clean.
>  */
> int
> xfs_trans_inode_ensure_nextents(
> 	struct xfs_trans	**tpp,
> 	struct xfs_inode	*ip,
> 	int			whichfork,
> 	int			nr_to_add)
> {
> 	int			error;
>
> 	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> 	if (!error)
> 		return 0;
>
> 	/*
> 	 * Try to upgrade if the extent count fields aren't large
> 	 * enough.
> 	 */
> 	if (!xfs_has_nrext64(ip->i_mount) ||
> 	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
> 		return error;
>
> 	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
>
> 	error = xfs_trans_roll(tpp);
> 	if (error)
> 		return error;
>
> 	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
> }
>
> and then the current call sites become:
>
> 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
> 			dblocks, rblocks, false, &tp);
> 	if (error)
> 		return error;
>
> 	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
> 			XFS_IEXT_ADD_NOSPLIT_CNT);
> 	if (error)
> 		goto out_cancel;
>
> What do you think about that?
>

I went through all the call sites of xfs_iext_count_may_overflow() and I think
that your suggestion can be implemented.

However, wouldn't the current approach suffice in terms of being functionally
and logically correct? XFS_DIFLAG2_NREXT64 is set when inode is read from the
disk and the first operation to log the changes made to the inode will make
sure to include the new value of ip->i_diflags2. Hence we never end up in a
situation where a disk inode has more than 2^31 data fork extents without
having XFS_DIFLAG2_NREXT64 flag set.

But the approach described above does go against the convention of changing
metadata within a transaction. Hence I will try to implement your suggestion
and include it in the next version of the patchset.

-- 
chandan
