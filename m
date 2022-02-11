Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C78C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Feb 2022 12:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349850AbiBKMKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:10:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349830AbiBKMKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Feb 2022 07:10:49 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75447E64
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 04:10:48 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21B9rdm4011212;
        Fri, 11 Feb 2022 12:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=U54OpHHjptQmmioOnVlYN5RD1tadDPteu2fR/F/aviw=;
 b=bE/KZxrBnk7exh5zJIwZ08Tucp2+1h/KFKSLXLh1mZVdXKLx/P0jkmT/INqPGlznty6a
 4lM0qwtEExznm6iiop+kVcZjzSdOItbmk53ygAplgvL9g6L/YTr4EVcbLR9fjb12i/bX
 s7w1HO4RRJ45nwdEW6szHCyL4r20s+fnTIq/VBn+cetAyUT4i+j+dOaur6fHWuRvmI2W
 iA48O/UCR/AniamF7qTVd7Na/Uvge5U5It4517z+hlolWSE7OwmTN1CR2Ez3rn9Qy7KH
 aTCq09fSb5/CthMc7Pqwwy0SMElQMhSMQj/EqaeQzjLAqImfYGsQMBuXs2yNPJhfduK6 ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5njr08h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 12:10:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BC6Fqa147987;
        Fri, 11 Feb 2022 12:10:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 3e51rv110u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 12:10:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kd4ozfPE755HUKb4jkFlqnxlPp9+NGzVtRGLoi+X70jGgRnAomnc/rBDb29DD+HPcIRnZrLRpmVYbFj5tki6XheSlwiPUs0JSVBU8YUMS/XKhx9hH69abcRT02Nxq9x1OjZxMgMxl/8U/NKgbajnfI7WwzE6QrX9wgRTzvNl6h/4jSIeOvkJRhTmXOkg99pNG8XfY+SCt9gsfOO0DU+1EdHQAxL4dWwXFofOgVQ391QLCg+03Tfq852EJlSkh24s/++dhNaTYKc5pIvItsZweoy9CoxV8MXG9d8o5KQECxWFZu5webl9yuTzISazHjtc0ogF6CUW9bxh0wEOQGobcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U54OpHHjptQmmioOnVlYN5RD1tadDPteu2fR/F/aviw=;
 b=krEQwYl9WZFE3xe6FiCacBMByFD+7F3QImbAHnQ/rixDPBzTGG7mhPqcX2sk2WSceQQqloCVP5TKnIbSkyXwbJXqaoA0I8PurBvoqfnBBEdHCADNlhDgkEUJKKWk8WZ91fWk6DVoWPeK+3/FlhicJ4qJXg+Y3ChzSFeo0ICUgOw/fcWrW/SJ3nw9RShLxNid9sk7k51KMvaRXwSru/mWYqRIlqo5zzRFAVy0h4ZIaxNZclHtrjPVUS66G7kw95lZ9IGZc4e9dCnWp2FUith/YxB6dyTtqkvxATMBTLC66Ma0GkZaFbxLb2X8rfugbpoqPiYw3+J+xN5DrscxFbegtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U54OpHHjptQmmioOnVlYN5RD1tadDPteu2fR/F/aviw=;
 b=KMNrZ0b6WLyAJcafYNLQoJlM3h1sSIok/8dC453NHKnT0kD0RF7VDDLkMqHxX0w8AA8HkOzdWOnabtaETyqU2N8rYsFklu722apWiyCY6/8pvTnPfjDBjFGVsAQ2Tnh50gTA/b2ApUBUwh5EePS0e8phpEg3YpccOOUCzKMU/tg=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CH0PR10MB5004.namprd10.prod.outlook.com (2603:10b6:610:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 11 Feb
 2022 12:10:41 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::fc8e:7310:2762:be9e%5]) with mapi id 15.20.4951.019; Fri, 11 Feb 2022
 12:10:41 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220207171106.GB8313@magnolia>
Message-ID: <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 11 Feb 2022 17:40:30 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:3:18::16) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d7161a-e3d4-45a8-45d9-08d9ed578597
X-MS-TrafficTypeDiagnostic: CH0PR10MB5004:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB5004F7D2A1E62FC02BDAE513F6309@CH0PR10MB5004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAmjoDf0pOkUPo/YUzCmIp8DXxyx7T08jtspZxrBPZFFVUf1PKIO6FEORP2mIYp7zLf81oUFRFkLIP/bWD+nSbs/K3CiZhKrLiSGhypMANSofeMAOvPxUZp/AeyjBHDeC5jPIbud6/q+Vel0+HwnKiIrIvI6MOMlEavWVQSH3uL3Ez22Ftuix0hLp4OhnsBPbfEU7xlcNhIjZgbqezBnPg/aP16ooeHq3Md9meAliiz4T0u3S4PRVuDbtmRhLrJsfTlyQgrkTmjL8evLpBY1c7zTrFqLnsWb6Z6Bz1YtfYDIgavP0L1mQ7N10a0mWPH9gAUFuPdSEd4MezcXu4ldfHIbivL2DRtlZkeR+A0Iuq8tm6OABWK+13fZ6ExBGR5wV8sjdeYirC9xY0eUuky/yPFhLsX5LEGHJorkkFDaEuKkOlFwzRC2m6Bh3Yw96dQqgDXQ4q/1pC4AYLWSSuEI5DCwCdL+oOLz5fWM8YrIlO113AcRrQPHFaOZRZ95uwS2cALqfV5dXCDGqJBOtn240Zb0CVavByTPsp5hjcYCcAfWUvLQnIk0DEkMN5O/0CwuYlm13HI2oqYnX8W63ilwUJZVGpGmtpWUEj7X5HsrLW5Fn6bYa0wU8b7MVscCNimHEEC4NyUYiWgEqtVrCJpdf1pDTCF6i+/jw1yY4XAnDMVcXRUbS2gA8mjYdTIT9TgtS0SOW6D/3LBXbbA1dIrclg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(508600001)(316002)(9686003)(6512007)(52116002)(33716001)(6506007)(2906002)(66946007)(26005)(186003)(53546011)(66556008)(8676002)(4326008)(6486002)(38350700002)(66476007)(8936002)(6916009)(86362001)(83380400001)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jMbsRSLHZq2n8cLg5EuYWTK+ZQ2/ZopUgQSDOJ7NSJkUOc5CvlT0Nk2lvmn5?=
 =?us-ascii?Q?3KktIVGu2V+bbwENHJrqpz2gXc2sTFJuk2RmeetpDWQH50WmA62q5k4a9IrX?=
 =?us-ascii?Q?Xw1/9QagO9fHLAuR/o8DXEEBwAXkgIG8iRDbV8zi7IgRGJ67ks/MeYVRTN7G?=
 =?us-ascii?Q?+OK0ukuH63qlcLg2Kczub1Dc5cqrnRB0JjDwZKH2HFMRi6fKXSSDy4OLr6kE?=
 =?us-ascii?Q?/KcuoipHpKuBgiSpRxM14Zm6tLMsidubs4HohQlpeRFymG8BvYx9xRXejrL7?=
 =?us-ascii?Q?AsmiSoleUSeo+AUxS0/jFe9OwhN74wy/MDR15cRn3kfqaopU4EekLTOihqEy?=
 =?us-ascii?Q?tRKOdMAuxedIrWiuUjVHxfe5D63zM8nH8iqfzwCKMAEkacTokDo3mTuv/sYv?=
 =?us-ascii?Q?bpN+h2j4SmydqYOWf3GRz7cLvda9dchKncJMtn4anWnjYQr7dmENWArSwDIz?=
 =?us-ascii?Q?SqXdZZbiD+NWeKGTtQcbgm/uhLB1u1yzARAC/EiL1VkXwFbbuay2j7LW9r55?=
 =?us-ascii?Q?hI99IajjS+SqOoU0fNPO4xESzNAaWavStz4MDreynr6GlbX4g1uTwntkfTcj?=
 =?us-ascii?Q?3jPbMES+em/LANki0fwQ7CHzAbqWeAGwBp4jHOSZSdZ0XKbDuBsuhkGL9rcQ?=
 =?us-ascii?Q?/EVy4r96z0ZwxLjFisNCbDI7/SghYtxSSDk4AYqrF7XNSO2vsPYGZr8krwBZ?=
 =?us-ascii?Q?8x5SweYv0cnqwiGbNfsgMe4urnXC12QsOczQLyVFviva9/AQ3E50QjCEg+UV?=
 =?us-ascii?Q?BXCrweJYVnr8c/QSKnCW7b7nKSl/x0nYDJe+p9zpA/hzmZGI0HB51p2SeO7M?=
 =?us-ascii?Q?EFAvJ+n43sV0mZctNK1iPH3Z00qzLBk+ns0cIVfzq8x21Aqd6kif3RxCHY/a?=
 =?us-ascii?Q?QbTHopQyEHYxrq7d2vKwr6o+X8sPtzQ7DGlaMwW//4RR+tYABum9qbcAVcyU?=
 =?us-ascii?Q?kp3rPzjot/QrNgAfwZgzUZ5vWLxoejuQpgFh7nln359Qa3uaX2VjDXuH6KzW?=
 =?us-ascii?Q?UMzMI2C/1x8HGdGJPROdTRMZEjNqqugOzHU/Ek3h/QrFiEb5vxkSGh6YMgBe?=
 =?us-ascii?Q?r/0LFnDPKDGRxDWYhX/1SGF5c4YSj5+CFFWqGYNEnzzdgknE2b+n9lUT0biN?=
 =?us-ascii?Q?kZ2PY4smPhB0Dw6cJw3cKwaWWMGDRuJNi4HWvQGcJz224yfUCqCBZfatrfUh?=
 =?us-ascii?Q?ylqiFnbCXUWqrLN8q12NMDBMCm5FwmklsU+1MuWaX1mTDA653i26xuWwgxKj?=
 =?us-ascii?Q?+SAXnenAcAVT+PHjLk/72PDb2PmI0ng1AFUbWhJ8BdSfjn3dMLG1UvPSw/YG?=
 =?us-ascii?Q?encG9lHEcoYlwPMunwFLhvldmIb5Gzz17HIWyo99MpGyV+U/BHbj/VcdDAZO?=
 =?us-ascii?Q?7WJRfZQPya7rwhIvsGCmHwQWi9zi0cVyRK5CiHc6yyLF2hNU/AaqSffmGtvR?=
 =?us-ascii?Q?sB6ktt/I6Qn2sen3nML0Ic/rPCqO+U5hz/8yTYeVW7escwC+UWTzWJMunOHZ?=
 =?us-ascii?Q?TpQhBgOX1WSO+jZO+bTIFkIvHJThD9KLsJ+7eI6Z+f4k57pb1x3NFrSLeiZj?=
 =?us-ascii?Q?qTe20A5Au9KINqBxGrt6HUFYnOTY+xSRB/2C7fl9wOxGfqPLINL4FOOAs0wv?=
 =?us-ascii?Q?CeyzKuxI2Wn8V7EIoZhHO1c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d7161a-e3d4-45a8-45d9-08d9ed578597
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 12:10:41.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIV/APfa2LRg+zNxgx5yzeWVzKdjLAwX7YcWKiqQi1PQ8oNl9Y8mkrP9yKs37MDafU6JMxgbUL3M/wlu1qZVaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5004
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10254 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110070
X-Proofpoint-GUID: XsL2ON8U5_hbNFqdGIpI5RWX9GkgskIR
X-Proofpoint-ORIG-GUID: XsL2ON8U5_hbNFqdGIpI5RWX9GkgskIR
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
> On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
>> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
>> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>> >> This commit upgrades inodes to use 64-bit extent counters when they are read
>> >> from disk. Inodes are upgraded only when the filesystem instance has
>> >> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat flag set.
>> >> 
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> ---
>> >>  fs/xfs/libxfs/xfs_inode_buf.c | 6 ++++++
>> >>  1 file changed, 6 insertions(+)
>> >> 
>> >> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> >> index 2200526bcee0..767189c7c887 100644
>> >> --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> >> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> >> @@ -253,6 +253,12 @@ xfs_inode_from_disk(
>> >>  	}
>> >>  	if (xfs_is_reflink_inode(ip))
>> >>  		xfs_ifork_init_cow(ip);
>> >> +
>> >> +	if ((from->di_version == 3) &&
>> >> +	     xfs_has_nrext64(ip->i_mount) &&
>> >> +	     !xfs_dinode_has_nrext64(from))
>> >> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> >
>> > Hmm.  Last time around I asked about the oddness of updating the inode
>> > feature flags outside of a transaction, and then never responded. :(
>> > So to quote you from last time:
>> >
>> >> The following is the thought process behind upgrading an inode to
>> >> XFS_DIFLAG2_NREXT64 when it is read from the disk,
>> >>
>> >> 1. With support for dynamic upgrade, The extent count limits of an
>> >> inode needs to be determined by checking flags present within the
>> >> inode i.e.  we need to satisfy self-describing metadata property. This
>> >> helps tools like xfs_repair and scrub to verify inode's extent count
>> >> limits without having to refer to other metadata objects (e.g.
>> >> superblock feature flags).
>> >
>> > I think this makes an even /stronger/ argument for why this update
>> > needs to be transactional.
>> >
>> >> 2. Upgrade when performed inside xfs_trans_log_inode() may cause
>> >> xfs_iext_count_may_overflow() to return -EFBIG when the inode's
>> >> data/attr extent count is already close to 2^31/2^15 respectively.
>> >> Hence none of the file operations will be able to add new extents to a
>> >> file.
>> >
>> > Aha, there's the reason why!  You're right, xfs_iext_count_may_overflow
>> > will abort the operation due to !NREXT64 before we even get a chance to
>> > log the inode.
>> >
>> > I observe, however, that any time we call that function, we also have a
>> > transaction allocated and we hold the ILOCK on the inode being tested.
>> > *Most* of those call sites have also joined the inode to the transaction
>> > already.  I wonder, is that a more appropriate place to be upgrading the
>> > inodes?  Something like:
>> >
>> > /*
>> >  * Ensure that the inode has the ability to add the specified number of
>> >  * extents.  Caller must hold ILOCK_EXCL and have joined the inode to
>> >  * the transaction.  Upon return, the inode will still be in this state
>> >  * upon return and the transaction will be clean.
>> >  */
>> > int
>> > xfs_trans_inode_ensure_nextents(
>> > 	struct xfs_trans	**tpp,
>> > 	struct xfs_inode	*ip,
>> > 	int			whichfork,
>> > 	int			nr_to_add)
>> > {
>> > 	int			error;
>> >
>> > 	error = xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> > 	if (!error)
>> > 		return 0;
>> >
>> > 	/*
>> > 	 * Try to upgrade if the extent count fields aren't large
>> > 	 * enough.
>> > 	 */
>> > 	if (!xfs_has_nrext64(ip->i_mount) ||
>> > 	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64))
>> > 		return error;
>> >
>> > 	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> > 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
>> >
>> > 	error = xfs_trans_roll(tpp);
>> > 	if (error)
>> > 		return error;
>> >
>> > 	return xfs_iext_count_may_overflow(ip, whichfork, nr_to_add);
>> > }
>> >
>> > and then the current call sites become:
>> >
>> > 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
>> > 			dblocks, rblocks, false, &tp);
>> > 	if (error)
>> > 		return error;
>> >
>> > 	error = xfs_trans_inode_ensure_nextents(&tp, ip, XFS_DATA_FORK,
>> > 			XFS_IEXT_ADD_NOSPLIT_CNT);
>> > 	if (error)
>> > 		goto out_cancel;
>> >
>> > What do you think about that?
>> >
>> 
>> I went through all the call sites of xfs_iext_count_may_overflow() and I think
>> that your suggestion can be implemented.

Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
xfs_symlink().

Just after invoking xfs_iext_count_may_overflow(), we execute the following
steps,

1. Allocate inode chunk
2. Initialize inode chunk.
3. Insert record into inobt/finobt.
4. Roll the transaction.
5. Allocate ondisk inode.
6. Add directory inode to transaction.
7. Allocate blocks to store symbolic link path name.
8. Log symlink's inode (data fork contains block mappings).
9. Log data blocks containing symbolic link path name.
10. Add name to directory and log directory's blocks.
11. Log directory inode.
12. Commit transaction.

xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
occur before step 1 since xfs_trans_roll would unlock the inode by executing
xfs_inode_item_committing().

xfs_create() has a similar flow.

Hence, I think we should retain the current logic of setting
XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.

>> 
>> However, wouldn't the current approach suffice in terms of being functionally
>> and logically correct? XFS_DIFLAG2_NREXT64 is set when inode is read from the
>> disk and the first operation to log the changes made to the inode will make
>> sure to include the new value of ip->i_diflags2. Hence we never end up in a
>> situation where a disk inode has more than 2^31 data fork extents without
>> having XFS_DIFLAG2_NREXT64 flag set.
>> 
>> But the approach described above does go against the convention of changing
>> metadata within a transaction. Hence I will try to implement your suggestion
>> and include it in the next version of the patchset.
>
> Ok, that sounds good. :)
>

-- 
chandan
