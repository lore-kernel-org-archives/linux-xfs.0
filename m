Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECA5C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiCYGDB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiCYGDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:03:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5EC681C
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:01:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P00aos031973;
        Fri, 25 Mar 2022 06:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=K8QRy5evMwuP85wy/Z8KnzjPYjmD2voDl2MfvD56zXw=;
 b=mFZbyrG69AiQbZLgujpUq9L0NTav2ku5wKYiwePdnV17GzwBYrk8k+cKoLHxL96X+RRf
 0DcjwisP4PL4I4nO01Rzic8eK+M9sEOf99CAEGk7V1sDd37Q86Da2bFEljPtFMpiYwTT
 FCDx8ABD0i2IHRI5yFXlCAeoXFs9SPXyGvc4jVVN/HFc7vZXTVeXj72CFi8zopsPqJ+S
 o4vodXOjf27u7cZBF+La1FfNgGvQh8LecOBlEXy+PMFlsv0Um3lPTFCVoxKB9RXrAqnt
 rq1fRQ6Cjj2kPENqGegnnUz8wX06sxqaW7BS0h0qacNdpr0AiBzAskPAC58F01ZcrnrL pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y26efr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:01:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P61L21087224;
        Fri, 25 Mar 2022 06:01:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3030.oracle.com with ESMTP id 3ew49rey9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:01:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpZ8xJcyYvpmzHxWeTuokB+9DPGHv/VVhs8u6CtqrEkZJ2L4Qpty+CESX3H6j8co2+m443kp6AGtY2Y27lKrBLXX61ym2I71Gz5DPbvvI3gOj9xcP/yt4p2xXiOE3055Yx+40IINm3a/XciTLRDo63bSrlf3iNBwBaISOOPzZgJ2cWL/pLRwXbnlog3fNjJy8V7O/H5cl218p7oXVtyUR2/70chYPVw1KGqsvBZWw41cnEPo+C9zwPis/iB9Kf0kGsAIwI5W6IItfid+GKowxsnELiHE86J7QDP6WCywTxlyYCcZ+gtTI7h06RhsFWrTAJfr2eC2sxG3mEjjFATHQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8QRy5evMwuP85wy/Z8KnzjPYjmD2voDl2MfvD56zXw=;
 b=bx1T4MOFb9m4Q2CD0g2KkODqe/7WZWzjjP95yNqLj0u9xNViDFGf1oM9yTH/FMpsCxN1X50W7NRGJMUaldF5YQ38Gd0+lxUhQlnbaZc7e2EbJRoegouFrjaEPZh4e47lg7nADEWQRnEDA2RfjWnoo94XmTezGHUx69RAPOOQDlJJNfhdrX6DLSqllxNCzV7t1qUGmuc3dLx6D71m0ggwHSy0V1eKCkGa8iHZAK4wn8ifmteJiEc+ndKzIC/QMx9/2iS1uqt5gR3n/5IuRvRGpIC4IIzbEz19SyKEqd9aeaL3wGGbbhrlRSaFfVaAN6xarAhURiQ2c/Ae4PZbYrVgBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8QRy5evMwuP85wy/Z8KnzjPYjmD2voDl2MfvD56zXw=;
 b=t8VftdOrzHxfe3id1XzZI/TAgT3KCu0WkX0g8SFgS3DEyre3JMCFn4zIF3yG1NOR8qWPPYMFqrgOTYi7n/W/BGaVQpVX29MZeAHUwPEAZfzLCxxJevSQlFIIpLaymhxcJtG1GWJHfaY1JB8cr7/Y7/gEBiosFz3Db8igqYVvATc=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2776.namprd10.prod.outlook.com (2603:10b6:a03:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:01:16 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:01:16 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-9-chandan.babu@oracle.com>
 <20220324213719.GG1544202@dread.disaster.area>
 <20220324214030.GT8224@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V8 08/19] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64
 and associated per-fs feature bit
In-reply-to: <20220324214030.GT8224@magnolia>
Message-ID: <875yo2y3j2.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 11:31:05 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0099.jpnprd01.prod.outlook.com
 (2603:1096:404:2a::15) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4942b7e6-beae-442a-50d9-08da0e24dfd7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2776C94D92B56464BF6916F0F61A9@BYAPR10MB2776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FlkOnVPf8/5EVy6oAHEnD98lvRqC5GEea6USyT4hvTKMI/+x2CAm97TIlYTqCbKhb2AaNYdofjHBPCvLAB0v5+vPDFbmWQAoEa64gSgwriP0/8+GfBWFG4av6A7f2/ICKUPlfbXpMxmP28w6USH0zrkVz/OmzVY++fejI2Mnlk7FHJ2HdgIcCaCvsaS6c6byB0JPQ5FXd0CUvnn+Q0cxG0349BEaR6DZdw0RDNRwX7BO31wmVgeSts9WxxQ0ksvh2aK4fGPLwEqeaQMl3kmcS+BsGUt6gi23QiQTNW+Gotc1bxrF1gi2b4tQfnE06bFabSY4gO6JvX09r2wReJuyhsUwNmRs1Rm1H0DDL4lNgPFSqD/GWLKvYkgBeI27cVGJ6PSatFytkthQ/yCWEE7EEo/Nho7BZ1A7nm3Rt/ygXwzHlVBBuI0B8Aogc26+btZiQBtsa/HYK2pYx8EFB9vXUuk/V2aKVZW2JzvgPa/jbwPmWCTbXLDyDencRL3jm8hjsa7Jsc1uEu4B0I8sOM6q4S5DseC53ygT9kDrwpWbnTuv2BUQK3GSj6aUTupIpC77vHsRWA31yVGsu+B+3njAnEZ/CnOLpbf6sQBTfOBuEpz1iGB6B2/Digj7aJbo5WGV+fiF1vk7El/zfBB1jUk+MaB6H8MKpi9a2HpYI/z7zdTx6cY09O5EkVb/uplxKUO5e9PO9WUtV6GHeyGGR1e1ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(9686003)(6916009)(86362001)(4326008)(8676002)(5660300002)(316002)(66946007)(66476007)(2906002)(38100700002)(66556008)(38350700002)(508600001)(6486002)(53546011)(6512007)(186003)(6666004)(26005)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6IKV6apV/nB6uhN7PMvslTVNB53Huhfnpe3YGfu/MWNyPDDyrtr9kNxaJhMk?=
 =?us-ascii?Q?nI68ShsZMUJZqHVqrp8/yMftQREvjr2HO0C2Yk2krrP+LJ2T1b1sd2B0B/hC?=
 =?us-ascii?Q?ARgftSo7IMCoEOvie0BZRvg9PwevBxLMIz3Iz49h01FwQkKYB3+chz9NQi3V?=
 =?us-ascii?Q?97T9sPmauhkneF9NWyA8VR2N+SUwgQS4QuIFGe39gqhTGruk1v8n+CJDy+zl?=
 =?us-ascii?Q?aTTtNT1ZvyxKTo4/952BnHK+Oz92bLJdFQp/D7pXk79UdjLzs0bGYJsc59FX?=
 =?us-ascii?Q?AYYs4X0t0FIEOykdQYKosiO4tUWsXFvJ1V+KfVXWKsWqeN+SxMMl0gzoZygJ?=
 =?us-ascii?Q?frjZIREjsy9NMEkzDlpN+9CY2/j/ZdJsPk5vn/xqJAiBlFgOn9wR7OWlqAVk?=
 =?us-ascii?Q?16ZQ2w3PgEaYB+zF/4eIkFsHc6JF7q4Yc7XMYrJaeR/vIvgByQlqkBRn54ly?=
 =?us-ascii?Q?y2UVCvy/5yEcFGMjQMYGruqlLCCogL9GbcM669rBB1KGAm+B/nCObzaDSATu?=
 =?us-ascii?Q?631HBF60wyBhWzahT0tRFB1pQ/LGnHzG5NAin0dzskIdpmTLghIovOWQNUhq?=
 =?us-ascii?Q?mhg5QLZNwqSkGx6Q4ed2hc62+7e09P9PJ37jvBKl9KUiSqZoDn5L9Dko/4uM?=
 =?us-ascii?Q?eqAyV0fy33igbiFpjQljpEfWmMKnr2Y4oxmHwmAkESgqlkX+VZ/YFbQmGf8f?=
 =?us-ascii?Q?4tZPxPJN2dAL0KpXMATixD2SspRhI8zG01hcFwQ+GUAsucmAymk2ZbiV1rbv?=
 =?us-ascii?Q?sD/COiOGBdXns/mXuDQzuZBa4E7WtJVX8gcswZg+1P+bep+QZt4aJqLA7f6G?=
 =?us-ascii?Q?FRpiZJmphYBgjdILkEccjEB28JbT7Slxp0U4rHkOcm+s/upY415TnaqxXQAe?=
 =?us-ascii?Q?Fzdu1MWpzCad4Ch+YxuAeAuyrTPvabIYgaLP5ULml8+iQ83VuGMQmKY9gHkx?=
 =?us-ascii?Q?t1WFuc7pQ1vgO31hFGd1edIKCR67RzC8G8IrLtbV10rpwrfM1VoRB+RLduAh?=
 =?us-ascii?Q?g0TqI8aH2LRdhYHNv/6VVpayXlyjaoZ/iCUlAqm4WPdO8f2HoKJK+XMlnout?=
 =?us-ascii?Q?FcYnmTVmt42IE4MuEY7QwyqgMuVIL2IQvBJ6XNUhkpHTrvpLt8+ufE6IflKK?=
 =?us-ascii?Q?KPmxc3Rm9n3oCEAtw4VoRTGHVMvS12kc7pTowFJj478pO5RAMcHIcDuxwdei?=
 =?us-ascii?Q?wNha61QCr2sNso4plNc8nRXhbU/ea5gGbi+2WugQAFTXeQSne2r5pH8+Gn9q?=
 =?us-ascii?Q?G1xUUz29581EZfDWnf6kbZ7ShVxY6B/GxFTEKPTy6fq6T/5p86p3BmfPuvVN?=
 =?us-ascii?Q?07wrQf/vHBne3FzLYS9E3MkeREYUGOFL0mUSJasnB/0qAce+ah5Tydq6bi/R?=
 =?us-ascii?Q?9vQud0Gb9nI4gjGbIrpj5+ucfLa1uN5aHza2HdINjPzwemPjZLOVS93MI+Bq?=
 =?us-ascii?Q?vJHrz9H4DybQUPdXknfTP4gLOhPMyEuEdBGDqiT2vKapGnK+8wwI3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4942b7e6-beae-442a-50d9-08da0e24dfd7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:01:16.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 56pP/Lfj+5rUwjJoLdbqxAt0ijcH6DUgKQOY+OXxpf8AFIvtRy3wRqMv4euTFnRz2sanzWpkx6r+KFYSwoDt9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250032
X-Proofpoint-GUID: WH9Tt5f9lMMeftCc9NqnGG7WOvSU3GPj
X-Proofpoint-ORIG-GUID: WH9Tt5f9lMMeftCc9NqnGG7WOvSU3GPj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:10, Darrick J. Wong wrote:
> On Fri, Mar 25, 2022 at 08:37:19AM +1100, Dave Chinner wrote:
>> On Mon, Mar 21, 2022 at 10:47:39AM +0530, Chandan Babu R wrote:
>> > XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
>> > which support large per-inode extent counters. This commit defines the new
>> > incompat feature bit and the corresponding per-fs feature bit (along with
>> > inline functions to work on it).
>> > 
>> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_format.h | 1 +
>> >  fs/xfs/libxfs/xfs_sb.c     | 3 +++
>> >  fs/xfs/xfs_mount.h         | 2 ++
>> >  3 files changed, 6 insertions(+)
>> > 
>> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> > index b5e9256d6d32..64ff0c310696 100644
>> > --- a/fs/xfs/libxfs/xfs_format.h
>> > +++ b/fs/xfs/libxfs/xfs_format.h
>> > @@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
>> >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>> >  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
>> >  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
>> > +#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
>> >  #define XFS_SB_FEAT_INCOMPAT_ALL \
>> >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>> >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> > index f4e84aa1d50a..bd632389ae92 100644
>> > --- a/fs/xfs/libxfs/xfs_sb.c
>> > +++ b/fs/xfs/libxfs/xfs_sb.c
>> > @@ -124,6 +124,9 @@ xfs_sb_version_to_features(
>> >  		features |= XFS_FEAT_BIGTIME;
>> >  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>> >  		features |= XFS_FEAT_NEEDSREPAIR;
>> > +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
>> > +		features |= XFS_FEAT_NREXT64;
>> > +
>> 
>> Shouldn't enabling the feature be the last patch in the series, once
>> all the infrastructure to support the feature is in place? i.e. if
>> someone does a bisect on a XFS_FEAT_NREXT64 enabled filesystem, they
>> can land in the middle of this series where the fs tries to use
>> XFS_FEAT_NREXT64 but the functionality is not complete.
>
> The last patch of the series does exactly that, by adding NREXT64 to
> XFS_SB_FEAT_INCOMPAT_ALL.
>

If a bisection lands on the current patch, the "Unknown incompat feature"
check would cause the filesystem mount to fail. Hence, I think the code is
safe since it does not allow partially implemented NREXT64 feature to be
executed.

-- 
chandan
