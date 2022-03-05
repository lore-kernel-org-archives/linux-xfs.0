Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC16C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiCEMob (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiCEMob (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:44:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A6C1C1AF8
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:43:40 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 225AM0aD009883;
        Sat, 5 Mar 2022 12:43:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : message-id : in-reply-to : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=B1SeLwVqQrhpyk1DBVlB30IJfwJhPZjFwiCPl3ayrsM=;
 b=qMReCRaqT9ZgDm6t5qE+f9XOpPulc39kIvanzb6E6zz6eHq4fLdrgZSXD6weiKG+CCGs
 M28vW4hD5qDhIJVtzLhFx9+6OduYnla2u75lnTJGt8jfV1oKm5PjyRUryfSeCYWlGpjG
 X+TpYGIyLUDE0JUw6b1fWrXhdrgjA9cBIEYMHMuH+YT2/9VwvFB6Xpd97Y04cCkMWGH2
 XfDSlq3NkWeyNTjyeSNskIOzl2ptDL6f6ih5EE0TwQMTQkphxwbW4yxTyRFn6eO2NRC6
 G2eOE5pLc92p0/kYOaF+6HtEiXq2o/lgIcdWP3ndiTtJcjZuBW6f1m6R4Q4hQL54Ljjf mA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyragnkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225Cb0A1113092;
        Sat, 5 Mar 2022 12:43:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3020.oracle.com with ESMTP id 3ekynyqvvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:43:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MefoFYiTj+OJw38h8uDPT0khoL3R0Le/hEZwfcLwvKX5Y6dbcxspun2jIeSswjhAh4AtnEbfE6BAPuoiwpR2jggWVp+i/6kNFOM8Q75jj+Xnf3BQ2M0LpeVBX3dR/+eeshDFWW3Vap0zerUxDurXEXFJ3LPiFZcSw8T9F36DGrFhozFfzLcWWG+osvuS6ewINChSKDDd+F1T8qANULvLkJjanxis5CnjmKdWX3oTRdLfJ4tqtC16dpv0No6P0yfBwDneOEIdX3YzQ5sMJarKq9fHG+DNdctIXQiKVTQLDFXrRNvUa1QF5jbKBuxhFzrBwJIaq36VfEYxZwGEWiZjxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1SeLwVqQrhpyk1DBVlB30IJfwJhPZjFwiCPl3ayrsM=;
 b=Y3pZrX06vKSQYwBLIHrUE6oAHLgYy4S7of5O/awEHsuhGMjXLovSXJ4rqazxknq8GBimttTzQY2jE4qynWoGqcULlgsOv1GqNwFLeJ7HQLRZt4r94b+tIUJKs18+7W20GQE5yqhq+F0JOdd48b2+H7J/rmr19wy+LHjW+EqM+TSm7EAGBPzfLJdc+S6B/F/LCF5KNTkNMcGHgCS70K62BL+AonNaMdfX1im0Ov/x9D+T1C58eNVrFvNRG+/cfJ6Z94RzfWlf1wRX1v7XTXHTzzXJKaZbzcj5oXnq1nC4sw1tifH+QK9RM05Mnj4WOeCzshfaw69M6Z5rSXj1aAgqBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1SeLwVqQrhpyk1DBVlB30IJfwJhPZjFwiCPl3ayrsM=;
 b=qP53i4Ohf30o0/8ByAgHhSS8g3QetNgZlOu0rq2G6eihg1Rua4iTzANggr/2BWe4nUK5ZZyVmn8jZ2DOTniJKsHuedA+GHMDkgwc2oOUtt/bjjomtEPuXxFc6sHgxn0XdATV+GY0cBMPK0/Aw4qfIo3/M2SBPlFOn1HOJfiMKh0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:43:31 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:43:31 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-7-chandan.babu@oracle.com>
 <20220304012952.GZ59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V7 06/17] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <87bkymgd21.fsf@debian-BULLSEYE-live-builder-AMD64>
In-reply-to: <20220304012952.GZ59715@dread.disaster.area>
Date:   Sat, 05 Mar 2022 18:13:21 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:404:42::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95c10f82-cd2d-411e-128c-08d9fea5c117
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821676AE4CB53ACD2F0E6A4F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uN1b8Gk1Pjyg6rCqSR0cgQ0yk9KpxdhNOQc+dHMndtzbvrBoRLa4vIKxXl8csEi8awHixgq18C7xXZ7ZMUajULxfhYVn1cNb13f56Vm7laUqDScRrvbNO9LAX+IP6uDWkC2ymKmi6pl6Fgp7/yAHsOeWdXeMye8USRAXwqGppN2Z8ZguPdkof/ZfI0ruU9tKYYB95tsSl1F1cnXa5Eeyw1wga7OaPVwt1eURw3b/YEanJArlvPWFe60OZ6FDWGE9a67KgK5vrG42OtO6zf9bItxIJ7MewchQLSC3RYogFnCeuOH+PTHWx0ACCCxsUOuhox4hUUw65f5+kJJ7BcDNLpSYBtpZgoC/zEllBDKdijyLqUqAMk6zkiDw5Jdldt0+wHZartv865aaXUhyENo38eNj/GwnTzlLovRzRUhxtDCxJrwefmXQqJquCsKK5iCaJrWtMKn9OLJCReX67arUBFDKzidmRV7YJtzTQt2mpe6PVkBJ8D97c/wDyyp7RxNcnO4cfsH4nIKBerHc1tLAFnNENMDfU/vkOROoKtBcS74JGKRFQl72Yv2uOxH0/ODf+DNUL0oXIbWjVlvJZ+iuUY6Eiq416TSjyhFzWzhWfoztC8mGWqQ1R3VY+OlpYIioTtT19ROqy8OJGP2tTjzsX0UVD3jAas223g+sbmc9TvSS9H/qgziUB6u8kc9qBl2PUSitnCstaPr9VM8oU1ZVRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZNzYaHg/ZP2EG4u5r3D7zV65NpGOUEKuQ7xB0aCi/mkL32LhsfVKj2J90Y+u?=
 =?us-ascii?Q?mC0b0I2soOfQQC0XhfDnJwQo2icneIZjp6y/OsrjJVvqMXtsCpczs+vq21A8?=
 =?us-ascii?Q?bglaKURoxBhPdiHiSth34b/9ZvHdgWrjFvrq3DnZoRbQbJdWZ6zW5vj0VrRM?=
 =?us-ascii?Q?nkG0DPEfZUaF7d6cko+65z+y76efpK5aySbhVdUrD52Lec14znKnjkiW8Fej?=
 =?us-ascii?Q?7VZceNRyN3f6OLVfS26qdhBfnrIwqCuFNKaAvz45tb8WGMctFRVCznC00zSO?=
 =?us-ascii?Q?1X+XhT4NwqFvwkJB8imjL8p2xZN2g1gL6jliSI5p3wVP/vLwuaF6xmfHrIu0?=
 =?us-ascii?Q?1czMohxW7ous+n9b27lnp+n7NYW2v/PNhB8DHr60Z43ZirUYhQHJW+Qr5Igj?=
 =?us-ascii?Q?gJUtaZzAVcmKtUloszNuvWTOuje+UsfUb9N5cOOU6KVv0IaUg3nhD3+Fa9cp?=
 =?us-ascii?Q?uHjxWuNWuO0FuRM/1NOA/E2YbceIswkg/CP7gKFlcMd17V1pJ8jPDnBOjtxm?=
 =?us-ascii?Q?xqKDBwKgqYCFEnnwZTH9WawSOCQGdxh0yXTrcrwzqAQVW0kgBnfoh3tNYc4D?=
 =?us-ascii?Q?yoADCmYrcqlTuSyUcIIq4P9M5O+V3ZJPegJkca/mVMbWJ6nvh9/hPtfmJW/m?=
 =?us-ascii?Q?J3eo18egf7Lg3ObfbR/f+WVnXdg4BZbcuuhd28q09fP36qrjZ/0sb2HkkGxi?=
 =?us-ascii?Q?pnZNgPwDAfmfq+0P4aajQNb/1IaBcTqFYuJjrkqc7xTJd2URX6Gnb65Kknt6?=
 =?us-ascii?Q?yAUJBmqiKsyt4O6A5Sgw5x5XjJqxaZ4eRWIEP0S66mqAlYhj4tZFOZM/Ce0K?=
 =?us-ascii?Q?GCE+tj3G1A4oTMX6ozMW4NgnTgpqvUVCsbxSdQ8QvgeSntwqKKxvpvjhxIDY?=
 =?us-ascii?Q?JXOKvDvwl38QN52lNvN3Dp6gMLwGr0Y82DXlyYrVxtHMYEWVntl26co+ivH8?=
 =?us-ascii?Q?WXIsdryoNNC6t8bSZ7bjkENX4cL4B8V/J88XZWapfVRrRXNKq6BQ8vk++Bf4?=
 =?us-ascii?Q?Yqq+qrPnR2KFTXkEo+Tsik7zUnHG9RkPjPLDAIPZr4ygLGySP8WZvBdrawS2?=
 =?us-ascii?Q?bd2dRSxQftU+mtZBF4M1OteQ3JByVoNtkar0ULaKY+O0787MOfSI0BwVtOZf?=
 =?us-ascii?Q?v/eULnYGLEqRi8rS7FzxlmFZjJt6S1YbR+fGigmEXG/pc43e/LdnCIv07usT?=
 =?us-ascii?Q?f5KdwyyhdbrgEzdIafotHYtMs37b4n8F5HEL3r2qpdfD4+AxM93lgvMLMPZZ?=
 =?us-ascii?Q?94F3s/+uxsMfeVyNcbUacFYSIffpEymH7LEQpeN1ZKb6NT0ZvmSrcY7MII7L?=
 =?us-ascii?Q?yGuQcs7Qbjr2xCoBhmxqL6+d9y9bUZq0Jn8nk/6AdzCx04WOFFsoGQak8zxr?=
 =?us-ascii?Q?8b5yUo6u7FKOz9XVId0nW+0EkGbfy/JMs2HsuMw8saFjgYnSkyMlRhguc72k?=
 =?us-ascii?Q?TaJnxaaav/7VtFWZcnRpAOkYabMorUUlGSN8aO2TUlscKR9h4SM77r68VUX7?=
 =?us-ascii?Q?tnSkJ67qswfqFcONP0pYcXbMyphutVfz0PJ21HteRmUdu0RPm8xfJ9dLlBXU?=
 =?us-ascii?Q?1K65k3pvfKGiri6d6zwuGBTn/rLj0WvoV8xoMXsQm4OaVN18G3+Aem9cKY7P?=
 =?us-ascii?Q?troba5f8pQxH4+PJ8CJgZwA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c10f82-cd2d-411e-128c-08d9fea5c117
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:43:31.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxxmcObi4+COUYsHEkfNbnXuAorbG9a2RJv0AfirySR/j/GtPvm9AM06efPDlS1NynWELoap2F1ZQ3KSL+hnIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-GUID: xQzOGXNqLtGubdr0fe_QaA5keM1QUQbs
X-Proofpoint-ORIG-GUID: xQzOGXNqLtGubdr0fe_QaA5keM1QUQbs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 06:59, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:27PM +0530, Chandan Babu R wrote:
>> A future commit will introduce a 64-bit on-disk data extent counter and a
>> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
>> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
>> of these quantities.
>> 
>> Reported-by: kernel test robot <lkp@intel.com>
>
> What was reported by the test robot? This change isn't a bug that
> needed fixing, it's a core part of the patchset...
>

Kernel test robot had complained about the following,

  ld.lld: error: undefined symbol: __udivdi3
  >>> referenced by xfs_bmap.c
  >>>               xfs/libxfs/xfs_bmap.o:(xfs_bmap_compute_maxlevels) in archive fs/built-in.a

I had solved the linker error by replacing the division operation with the
following statement,

  maxblocks = howmany_64(maxleafents, minleafrecs);

Sorry, I will include this description in the commit message.

>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
>>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>>  fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
>>  fs/xfs/libxfs/xfs_types.h      | 4 ++--
>>  fs/xfs/xfs_inode.c             | 4 ++--
>>  fs/xfs/xfs_trace.h             | 2 +-
>>  6 files changed, 10 insertions(+), 10 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 98541be873d8..9df98339a43a 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>>  	xfs_mount_t	*mp,		/* file system mount structure */
>>  	int		whichfork)	/* data or attr fork */
>>  {
>> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>>  	int		level;		/* btree level */
>>  	uint		maxblocks;	/* max blocks at this level */
>> -	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>>  	int		maxrootrecs;	/* max records in root block */
>>  	int		minleafrecs;	/* min records in leaf block */
>>  	int		minnoderecs;	/* min records in node block */
>
> Unnecessary.
>

I agree. I will revert the above change.

>> @@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
>>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>>  	minleafrecs = mp->m_bmap_dmnr[0];
>>  	minnoderecs = mp->m_bmap_dmnr[1];
>> -	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
>> +	maxblocks = howmany_64(maxleafents, minleafrecs);
>>  	for (level = 1; maxblocks > 1; level++) {
>>  		if (maxblocks <= maxrootrecs)
>>  			maxblocks = 1;
>> @@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
>>  	if (bp_release)
>>  		xfs_trans_brelse(NULL, bp);
>>  error_norelse:
>> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
>> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>>  		__func__, i);
>>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index 829739e249b6..ce690abe5dce 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -117,7 +117,7 @@ xfs_iformat_extents(
>>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>>  	 */
>>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
>> -		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
>> +		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
>>  			(unsigned long long) ip->i_ino, nex);
>
> Isn't ip->i_ino explicitly defined as an unsigned long long? If you are going
> to fix one part of the printk formatting for ip->i_ino, you should
> probably should get rid of the unnecessary cast, too.

Yes, xfs_ino_t is an alias for "unsigned long long". I will remove the
typecast.

>
> Otherwise looks OK.

-- 
chandan
