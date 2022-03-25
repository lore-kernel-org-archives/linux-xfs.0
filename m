Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9955C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354158AbiCYGEw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347646AbiCYGEp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:04:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ED2218A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:03:11 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P0gsOn007614;
        Fri, 25 Mar 2022 06:03:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3J4X9ANMfMrOFakVLsd7OJ7Bh2pWmehgyGbIM9+GHLM=;
 b=MHAVXTuHfDrnDZUdTzuuUTm+OR3RoBmKlkkEYa3b+oXuPzBKzmy21jSUxXPvumsxWcbA
 nLZhSEuZuCVl7Q5NDhRuBg6YMj2hW9GhavaZqBDzo3Np7fRqFUNuh3T9qeeXB9vBy9OP
 /QUi3OGjGjtkInuNcrEtgVoCzVaDHpZm1qtJtFkw0UBuk+6nEGYgKhpwngbxcatTvfkN
 +nhy48QIDWqRaMkYoIccJx2DSKqOLq9nRDi9twxdwKwHRzqgG44Rad/V6Utf3A15e+uv
 ee1pe2BMQuNHrCH/bT6k6HDGYiVTAgNu4j5hQk/IjltDPhfB0WVNqbShqWYDlWu1lHbu JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcx1c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:03:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P6308j168195;
        Fri, 25 Mar 2022 06:03:06 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3exawjfxkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsESvr6nvG1c1CfREUzPWUf1/Rgn2zrlLoi9Way18SLhn4NAISXhrYBxD+3s0uwZSopXznqmyZdGb0/z7kd3CRYkD5tHNFylfAUEd7nkII7ckHy8zpUWcBxZhDQi8I1YceCiRDgvqnjkNENemOJLBMf3JJBMY569iMG27fAQ5wFhVwQ8DnJ0zZdOC8IFh4SsMwVmxirCJJdeO6wDoLbRlTwOLh1CP/QCNZRoKqgU/PqVEvM7G4CINipfEe61sSq8Xeqbd+zdKHcWMk7eb7NxNH63LgBdFLhD8k6rm+BobzuP7EWTYJIufP8rhIA/i+2gzys1Qk8js5fJlZoCQuD2dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3J4X9ANMfMrOFakVLsd7OJ7Bh2pWmehgyGbIM9+GHLM=;
 b=e3IaIZ2xtDFYaqrNp5JR/hO8ZBhRNqMeVfD7YCTkDIQev+/Olu2gpADvLLvptKr7ob/oqEexMd2A9K+nnMaND8u7MDwvJQfDmFPnF3HzV30Krh0GxXghc4bbfTfalnGKfLxM86HCZh6TXiyzjMTmRG4NW6F1NismBk0JY1lpnPrigVvOMpaVSsXDdb899pFWUmITMciep5fiErL/+/B9CzXn+Ujg/RlYyY2fKocjeNFTW81gpMW2InsoepnWVHqddv7Fp3iGzA2teHQlbNRC5TzEGn+EbObb/dQf0ArLxjwwNQ02u53j8vIsynR68KWwHbXjj8nfi8sQoiOHidUaTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3J4X9ANMfMrOFakVLsd7OJ7Bh2pWmehgyGbIM9+GHLM=;
 b=fFvmfipmFbbuPxFKlUYxca/dUuq4cxrZ7zIwETapv8OJEDvZt3RA6XDnhvBhWGDgjp15XjW3aPt2VlAb0dnguFCm5EUf+r9SMNqBRIRsl1WKzdbp19rQGjQbq48GkrJNCorHLVaXuMXOr35tU5nI4Y+bp8kZilidVlx+OH43UzA=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2776.namprd10.prod.outlook.com (2603:10b6:a03:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:03:03 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:03:03 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-17-chandan.babu@oracle.com>
 <20220324222809.GM1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
In-reply-to: <20220324222809.GM1544202@dread.disaster.area>
Message-ID: <87tubmwovm.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 11:32:53 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:196::7) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1085ed27-9bee-43fb-1fac-08da0e251f9f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2776095437E0697E7ADBB83AF61A9@BYAPR10MB2776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6IhawX28l6wVRENNhtNO4C0xoYynQ4hvPdaw7P/1Bylp8+DkunyhDQAEHuDWNpFRLl9itJEIKt661acBWRJ5KIiYi896w8EWHo/h1QmyDe06TTC61LE4/jgAUIjinNxOF4HsX92sFydDk01P19JjT2xmhKZJ3g5NzHlL33y+iFayu5/572rXuQe40ppiLEGUa3lk9ktwj93oj8A88RXaslJDP41F9I0COSSOstZ2pX0pN9sEGG7yo6v1WsXUC8GweJcSDhKjdhhZ7wXoPQxFW783EVh4Qx54ZU2/3w0ykuDdoFiUPoscMJvWmwd1HFZh/FmpgImh0x6S+DTZx1h3Hn3qohGhp4ctUgIge0LnkeFCMkQ74eKE8YKLaScETQsJLQ1F/i7+cmoFfaTmoGV0LpOVDSUEPXOD5F4cG/q6FKg7fUwYki7IyQly6o4i36wKroBin8qDuR49mSz1sYtxh/kE0RGZldL44j8+SGpVGc7eKSNRYwOPlJjGx1Y0SEC3GhLSVFcBp8mfmESpZvnu4ceXSIar6v9PymF4gMpKvoSdyZBM2h94naOn+f/K+u6xC5m2+/vtdk8UDZUB2yIAiKd/GPTXuRibi5kEGKyW4c9iHUqoAlU2SzugbytK3OxxmuRW7U43aDqih2FE6CwkhaVqqcsPi7zi/7dhqIFecHQ6993z3UGvRRTcRs2LUrCoE5BaPizi7qmKGUpB2dFxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(508600001)(6666004)(26005)(6506007)(53546011)(186003)(6512007)(52116002)(83380400001)(6486002)(9686003)(6916009)(33716001)(8936002)(86362001)(2906002)(66476007)(66946007)(66556008)(38100700002)(4326008)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2ExcLi7QUBa/41C+Jp8hGgHmJnwGddLbsO2h3sBWOZoeHn6JQcGgJ+2mbvE+?=
 =?us-ascii?Q?0c2kacrgZ2kPFQc8pbOmzv0XOoNShqLFg2tOWCZFXwNaPtazMe7KQe+i2d/u?=
 =?us-ascii?Q?zKIDMcrEW8k15zAsXQBiQVTCp2G1PxIAmOUP5/7j5aTm5HqIKDSWHFf6cqn+?=
 =?us-ascii?Q?2mwse0bGX8ofmyG1lilNMy7yjOaWYHb5sUcM35TRbG9+1wMmQ341OQP3muxm?=
 =?us-ascii?Q?y5m6m25EyH+72Ubh7l45pvJRevN2/c1kj591u1ngyPdKIYgA2nyJhBpOCiad?=
 =?us-ascii?Q?19XOXNWatqsHKcattV5Th4OVqOTMmK14htBCUGMQ3AmAC8lNi/6bYJZg+cCJ?=
 =?us-ascii?Q?lOEDNA0zs5bjr+6TbcTLG2dCzjkhLPpIA3bF/Re2jyi6vpMUajXG56AKCtIR?=
 =?us-ascii?Q?Urx77RTEfvANRPr8nZaR6q4hIjKQ3h6vzr0qnBoLJrP4A7xzuYRGLfs+EKSl?=
 =?us-ascii?Q?OMTWxTWpsiUsWnO2Qr1JE91T3D37MPUwj9zD8L+Z1xql43wI4oJ4S2lUOrup?=
 =?us-ascii?Q?es+jebfJ1JZoLtFzYQs1Y1Q3KtidvU03OG4xjFHDSWtgYHw0jdv/YSp8ledR?=
 =?us-ascii?Q?nRgS2LD0xZnQ+xdLQEAEZ8E01rmq6uQxzOYkFP8KFEw1R3SJMBsDk5hXQBGQ?=
 =?us-ascii?Q?So2KNsT+pseLRysYrs8tCOCBMAPwHSmSpkUt0ijtSY4uFZX4nswqKLzoqsgp?=
 =?us-ascii?Q?VP3ubwC4UI54oAkehWVNZDNMUnc11wLAy8EAAeYqJtecb/L3Chj3ifvamyOA?=
 =?us-ascii?Q?B5EAOKClCnoc33hKq6sTuVuntTj5fcNWTq5gXTJULt73wgKvWWC0g9sOe9Ko?=
 =?us-ascii?Q?dqqfY8kZMVBT5P0APOoVyuw0SKY+ZQoKDspzAfE3Nt9nfftnwjLxR/tCEbeh?=
 =?us-ascii?Q?admT7M6MJBZ8VOV8JH+2m4jfMvfmF1RnOyn62YFyrL2l16Ohfm0HJgwyB9f6?=
 =?us-ascii?Q?knmGUjj7UO6bXokzZbTyk59H3/dRuM3vGAS0CEFVQXsqoeAfMBhdOPXoqPYv?=
 =?us-ascii?Q?BgBIEaUG5tJCM9dGXI6dxFY5+vDUJYEVxaaNDMW3KdhrZDfMPZS9xhseNHve?=
 =?us-ascii?Q?96LKp8QlFP/fUlhuiPMqq+50K7pA7AWUvSbqXyntKDj+v3DOagPXEbRLfCq9?=
 =?us-ascii?Q?RxZT7BN+ecuKzRGF8Rt6uIvo10D43xxVkkayLRrm4vj687vN7Q9Z+pmFdKq+?=
 =?us-ascii?Q?LCDQXegSz8PqmlH8K116jthT6bHEhz426xRTYlkoGezPKXYY+1ZLvjMDuOhM?=
 =?us-ascii?Q?iOU8IZ9XO593CiWPzL6XNmEd8gEF0vX+4JPpvHYl9NPAHbyWNtTtfGwAFYHQ?=
 =?us-ascii?Q?WGWxmAdw+6ZpCJ6Cxo1NuoknWa/RKUAPy3Tj/+BGtJfnL0tn2Ty83Y8KWljO?=
 =?us-ascii?Q?amu1OYetQSi03aehnl1WPEt9QSFi43/f621vytGdWz0DPNZVoQpJvC03vDXU?=
 =?us-ascii?Q?4ZHLZYbZ/e8cM0goB9vfU5VUzePzXhoAcxvxa7hgFtcCfh2igHlilw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1085ed27-9bee-43fb-1fac-08da0e251f9f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:03:03.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9+jDbFPv+0CV+fO9kr3dLEBEp2kMpLe9PKfBsjv5RXAThzCgbXAzK1WNrx1/3EcTKj8FZD38W3EuFBbnURZ5FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250032
X-Proofpoint-GUID: eRk9SYEUk-ZvfSpZmsWtUXHyp3gI2msK
X-Proofpoint-ORIG-GUID: eRk9SYEUk-ZvfSpZmsWtUXHyp3gI2msK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:58, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:47AM +0530, Chandan Babu R wrote:
>> This commit enables upgrading existing inodes to use large extent counters
>> provided that underlying filesystem's superblock has large extent counter
>> feature enabled.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c       |  9 ++++++-
>>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++++--
>>  fs/xfs/libxfs/xfs_inode_fork.c | 27 +++++++++++++++++++++
>>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>>  fs/xfs/xfs_bmap_item.c         |  8 ++++++-
>>  fs/xfs/xfs_bmap_util.c         | 43 ++++++++++++++++++++++++++++++----
>>  fs/xfs/xfs_dquot.c             |  9 ++++++-
>>  fs/xfs/xfs_iomap.c             | 17 ++++++++++++--
>>  fs/xfs/xfs_reflink.c           | 17 ++++++++++++--
>>  fs/xfs/xfs_rtalloc.c           |  9 ++++++-
>>  10 files changed, 136 insertions(+), 15 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 23523b802539..6e56aa17fd82 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -776,8 +776,15 @@ xfs_attr_set(
>>  	if (args->value || xfs_inode_hasattr(dp)) {
>>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> -		if (error)
>> +		if (error && error != -EFBIG)
>>  			goto out_trans_cancel;
>> +
>> +		if (error == -EFBIG) {
>> +			error = xfs_iext_count_upgrade(args->trans, dp,
>> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>> +			if (error)
>> +				goto out_trans_cancel;
>> +		}
>
> Neater and more compact to do this by checking explicitly for
> -EFBIG:
>
> 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> 		if (error == -EFBIG)
> 			error = xfs_iext_count_upgrade(args->trans, dp,
> 					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> 		if (error)
> 			goto out_trans_cancel;
> 	}

I agree.

>>  
>>  	error = xfs_attr_lookup(args);
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 5a089674c666..0cb915bf8285 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -4524,13 +4524,19 @@ xfs_bmapi_convert_delalloc(
>>  		return error;
>>  
>>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>>  
>>  	error = xfs_iext_count_may_overflow(ip, whichfork,
>>  			XFS_IEXT_ADD_NOSPLIT_CNT);
>> -	if (error)
>> +	if (error && error != -EFBIG)
>>  		goto out_trans_cancel;
>>  
>> -	xfs_trans_ijoin(tp, ip, 0);
>> +	if (error == -EFBIG) {
>> +		error = xfs_iext_count_upgrade(tp, ip,
>> +				XFS_IEXT_ADD_NOSPLIT_CNT);
>> +		if (error)
>> +			goto out_trans_cancel;
>> +	}
>>  
>>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>>  	    bma.got.br_startoff > offset_fsb) {
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index bb5d841aac58..aff9242db829 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -756,3 +756,30 @@ xfs_iext_count_may_overflow(
>>  
>>  	return 0;
>>  }
>> +
>> +int
>> +xfs_iext_count_upgrade(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_inode	*ip,
>> +	int			nr_to_add)
>
> nr_to_add can only be positive, so should be unsigned.
>

I will change this.

>> +{
>> +	if (!xfs_has_large_extent_counts(ip->i_mount) ||
>> +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64) ||
>> +	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>> +		return -EFBIG;
>> +
>> +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
>> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> +
>> +	/*
>> +	 * The value of nr_to_add cannot be larger than 2^17
>> +	 *
>> +	 * - XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL
>> +	 *   i.e. 2^32 - 2^15
>> +	 * - XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL
>> +	 *   i.e. 2^48 - 2^31
>> +	 */
>> +	ASSERT(nr_to_add <= (1 << 17));
>
> That's a comment for the function head and/or the format
> documentation in xfs_format.h, not hidden in the code itself as a
> magic number. i.e. it is a format definition because it is bound by
> on-disk format constants, not by code constratints. Hence this
> should probably be defined in xfs_format.h alongside the large/small
> extent counts, such as:
>
> #define XFS_MAX_EXTCNT_UPGRADE_NR	\
> 	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL, \
> 	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)
>
> And the ASSERT checking the incoming nr_to_add placed right at the
> top of the function because the assert then documents API
> constraints and always catches violations of them.
>

Ok. I will implement the change suggested above.

-- 
chandan
