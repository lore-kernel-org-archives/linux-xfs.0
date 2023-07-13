Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD94EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 06:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjGMGjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 02:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjGMGjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 02:39:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFF61724
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 23:39:44 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CLA0YO005107;
        Thu, 13 Jul 2023 06:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Xu2VJ1guNGq2bhD0L1vbuxY0XFwRZ8w3Dvvkb33LYNk=;
 b=VUAb91j+syGSfpZX6/tc1JYq4GdVHeN9pQG984WKL4Ncnz3iOxx9/cXqlTL795f4DBtg
 h6utBTAIFr+7CQ4K5k8R7MfdWiSDNYS4ZiOr7YB2uEXX50k5K8fzPS+sdjWhJ1IfLNjT
 o7jdiLsCiBJSfMteaRexu4qtbeL47vepdWabZydk5bcj4+loco3h9dXQPTtD9Am2hBei
 3aFds6Hu6mcXo2sw8jComg6+XY7xWq0MAaAfpy67lgGA30R6jMYiNGM9zUrvwYLFqiKu
 Opm+IFHrhUqdo4rLbfgMPYm3/74E6/XJ30d8KrM21RmtH8Mx3ag0DMem9NUvSCW3HQL4 aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud90jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:39:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36D4vATr007165;
        Thu, 13 Jul 2023 06:39:39 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx87tb9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 06:39:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjJATVeGg/kVZuUfb1oca95+wqIKcG+Ii6HY9PR+uWazlXjPv+pL2iGdd/Ra84DQEAc3nHn6D8htmL1BMTbSzu3HNNWWe9a7ZofPbzNGmrCWeoKMwfWiaWThGmpTaqW21VRgnR/vi1MJMD47daIsfuQdxtqplNe8B6J5X252Y+caE8ySCjzxc8Ct3tvgFWwRNZaBUaKXPEkMtHO074/42yGx3Ep5dHWQD80GjcvJCgsMAYKHOIopnGzW/CaCpuk0RyLXYgVIS9MDimPza9vomFgqGxMcUuSYSmZnqrDu45XIBZD/SE1jRzGl4ym70VHLCFhMNy3vtz7qSyVZTbKwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xu2VJ1guNGq2bhD0L1vbuxY0XFwRZ8w3Dvvkb33LYNk=;
 b=ja+K9xP1UUGRTll4HgXEx9waijpc0+EVWejiZhz9FblcI3uXRrZoOA/NHzOkZOQe/AgoeNjsfHniFJ+6y3U+LUf7xMWMJfgNrjTFq+ImkFw+JYDCR+SWphNKQwMkx0v24oQKWBFRlFNSwWApbAvg+cLXeyonhXa1uj/oe+WPpgaAu7QBC5SopmNhDeFwjuF/V/FbIfuhyu1PEgfNtB3c4dxq9zYJIWOUE7ySLSAd2p9j3QOc6QoykUu3s70Bsyl15NZpeU3CJoQ+jKptyIZtmxIsjmC3qreZkxWK9bs//p3yvyN9H3+VGJNYHpR7FUlF30OgBnlcX/dC5aEzyKrpCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xu2VJ1guNGq2bhD0L1vbuxY0XFwRZ8w3Dvvkb33LYNk=;
 b=mvGOHRtR09Mb1q8LdhD5iKVPWbgZan6N6g0osRuozyOxzV0QlWoCeosWPBnx+7jOabNxdBgDtoT1EW4Htcg6OzXcK5f//S2jgptu+63qbNZsQ1Uyn+YB0IG107hBrelpPQ/93NNWumuzOpzLAn2RYP4toSi49FsqtC1gKPWHhzA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SJ2PR10MB7759.namprd10.prod.outlook.com (2603:10b6:a03:578::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Thu, 13 Jul
 2023 06:39:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::f1fb:7883:7c6d:4839%7]) with mapi id 15.20.6565.034; Thu, 13 Jul 2023
 06:39:37 +0000
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-9-chandan.babu@oracle.com>
 <20230712171009.GH108251@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 08/23] metadump: Introduce metadump v1 operations
Date:   Thu, 13 Jul 2023 10:06:05 +0530
In-reply-to: <20230712171009.GH108251@frogsfrogsfrogs>
Message-ID: <87mt00joww.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0039.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:380::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ2PR10MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: a17ccf48-9001-4a69-faa8-08db836bed44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: waHQ2H3yjO0N+jP3ulX7tbnK7uq4xkmJoL4cVK/UOZEh6aTu5rjh+noCEUjhMyxka3X8YnPYm2cC7P9K/2CfcymEjdcwo23kUXp/sDeiAyoaCPy4J2U/eMJyaXJV/iPQSlWM+dlj+7yiD2SjX1mwimNXCr5AltHZ+/HmrUF3f2WGVAyJOBVkFpgxAkYGZ8JxZkyyB0hd8GQOkp3p4RBvQFxbR6Dw8k/s/Yg0BUDzOW5lwyR38BxvEQNZpAwWuwZWBjOCgPj00YxUk6O4d6/9Zl/lb/jNOugzH4UOGIgL2LUKKazbXkZIGz1zV0NHagXN5vbvW7c1StJ9/jjZC9IBqkh8ir0WLAU6CSXLp+DkzlHjMtSqEkJ+ND5pSzHllGQt/Nj8kHNGqU4LaNmjC8wb0RAaFFYOXl+gmCcarJAnF9DZQSDlmHTqGZYFmePg5WCXaLoiM7jmcUAcQUxBP5tD/mNls1sjufaC528OUPVIWZ1bJDeOxw1WV2GR8KBRgslc7qA3E3EpXHGXyDeeVcGL0J/tTaWZC6vLc1CTUrOuI8O7Vo6QHa9tplXb/kJdkzLX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199021)(86362001)(5660300002)(8936002)(8676002)(41300700001)(316002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(38100700002)(33716001)(83380400001)(6666004)(478600001)(6486002)(186003)(26005)(6506007)(53546011)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZcaxvA/FTuJtYN+55DOM5J0ggTydWA2eAbjEnrbzP2lKNJN2dkigdjs9EIDf?=
 =?us-ascii?Q?tcNs10mwvo2zUnRfLyLyRdHp22tzI50adGP+W6Hjsq2f/Dxm6bgbgK4KImd7?=
 =?us-ascii?Q?M6Ckn6vbpFetjIGA1zvNLeBVpEd+aKXuqjxOKeyg5OLMn/7a1xdisZGJjwDU?=
 =?us-ascii?Q?t4t2Ih+hlm2q24SCUm9M+kbkPwVm4MLT2MAlRd1jIPLECyLSF2nfCZVG4qDQ?=
 =?us-ascii?Q?vlegDo9AP2c/X+zgNH6vdk1bc2rWEFKltZhr5ICjQl+JrCOcVykOqT54v5q8?=
 =?us-ascii?Q?YXHDnBTRvP0NCXn0t6wJzNd6C0hs3+WoCelSvoUyLNZjSmfBsbeUhrnU9XDS?=
 =?us-ascii?Q?w5EJJGk0VCxu27/3Ycz4AKFp+iQeRmPu2pAywzs4KGadFKMbY9kUpQNzpIcj?=
 =?us-ascii?Q?y7JmVoR7/oO3+milnxayvqLtzFz9hQjfGQqkQq6Mh0/QZcVJJFzcgT359ahb?=
 =?us-ascii?Q?u8k0sqZhMTbFa24Nq1d8sCjysy3N6wV3UM1pZCOKe1FK/oKuW9X7UvIGCamp?=
 =?us-ascii?Q?OwOxF81u/V7gan5MpuDSYPDJnjFgzRSsFbB1IkbdZdN3/K85D3k8KWy8lL7s?=
 =?us-ascii?Q?TJI1e3YGL++p2Sv9/Hh+0ZJdf/iTMWKrO+cpKxVrDIzpzP7EUn6tA+PpQ+TF?=
 =?us-ascii?Q?JwuNhT+fxumJioHwjTcTJYaQXxWVMw0lbpCCBYxuk/8Ro0bx8I6w9msEtLUI?=
 =?us-ascii?Q?h+6vXRvj1GOhMvA563clCiqVC2jdpCcjmdYUTK2spBW1d8ACKvx09v5Kcjft?=
 =?us-ascii?Q?IMnxYg3iDRkupde78HX1hnQJB2wyJ3UGKxbGLFhSynBXraHQPQPaLUMEUcOg?=
 =?us-ascii?Q?PiO3VLB6kzxabIYFfABIaYyqlkgkkNZlcph1TZgOZWV0TTE25mvBmuMz4Gig?=
 =?us-ascii?Q?Tz6VzEQuSx+44AKhpvicnc0c6EIDgivvkRSxzixWeezpbUBYg16CLPjHb2m2?=
 =?us-ascii?Q?fsoKL+M2JI0mLephjc6vneO/IM6U+HOTS5guC8uLqtsZAF+m7qmi+PaRFgbR?=
 =?us-ascii?Q?Sqfma7nD+Kt/8Z6enFyjJwUayRdaip4u5RWTYZ3svjTpH8AL1gkreznS8m2v?=
 =?us-ascii?Q?zEkJKRpyAlWmH/XvuI36SbHtO1XZXJelUoT1qZ9DW6bm1YJMfM0MiqH2eH9H?=
 =?us-ascii?Q?mbkooiXcIPn3Ud3KYwxq6WaYIWxAWBazo9zPRIACzAGUITYigHS5ADfyyfXf?=
 =?us-ascii?Q?dfr2hzcib7I9TSRnN6/C0/HpXbWEHpmPorripODNQY8IDk1SmvPVLiw6/3d+?=
 =?us-ascii?Q?PvaV2y7l1nYv9eqvZdcEIAnVwEFIyEWcxg9Nrh2VzBY4+ZdgUEVKNVO9dnup?=
 =?us-ascii?Q?xFdOC6ZfOIE7PJ0P4n2IjAAvNjVqxcA8/MOi1sryhsktTDQdkiPCT6snMadG?=
 =?us-ascii?Q?JbDnfsAa9vbwonv3ffW3L2WCBpTEfBonlzM9TLuXGYRVxnI2FFqiqDMtYS7K?=
 =?us-ascii?Q?GYTTnTM9SIJiSkpR02OO/4SAfeBnM7sS1RriJn3smQ8wMjbnRSw+Gce6b326?=
 =?us-ascii?Q?NDxntfmtJ3gF99D7k7DQm+IZQeS2gm0bHdlKM4djC9RQF9Udw0HoMY1J+ZwK?=
 =?us-ascii?Q?eivKC3JdZnvXVhk1eacdxoZpBOIeFGz9KdL6ZuVW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vPFeihfy+xvyWiIiRWOncziTSrx2ri73MOeOS0iFaDg3P8kEsh+7Sk1QF99QB+Zr8YmDYGMtr+L55qVcpsuP/yMOp8J8Shtj5qbJ3z+/iDcY4kXDQjYiLnwUzCnTNm17LrGI2QkNUGaClMorU6XF0Fhdem3NRCCoE9E1OqPpKyWWFWC/CSUKesd46caytkue1EUnqHlu5HQ9jgXvQfi8GbaFtXbuwoIHlmZ9eA6LpqWoyxETg4rBy2Q6rQuohzMbLTyi99OMwFQWz8s+t6kIOWFi4wwNTp85SQdL5Mq9wME0SNuSsRhkPpwRnG63JnH09+gCDpUrAUu805grnndYsANAOTIxlbwqAHEYxegdjeEszTcb9Nzf6O2G2CieqZFzf9q0wQgshwzGBsfcGvss4bu/A6n8Up0DDcp5AMsxyf2Ta2UwzBp/2+XT6TTBVKPCNd8hj/PslLln0ZyOdZLm0POjbJgSGwagmwBJH8fs1l5WxbCLyAqa1NnVUx5dkGpkVguq6Mz0puHCabQ3T0g+pKvwY7cbcaI5inZVK6nqQO6hoof2Otwum8j7YMHLkpXO3dAYJUVLTwNkVWqy+HZ5KTF/PlogoRM2EaTDvDhhx4+s7fEKri89nk3e5SVDnfhYbjKkME3DV2rKHkxcd6W//rtPvJazQEpPOBQYX0KotP7g07eNeqrspr/JaGxwO7wbsVLzZZigwuHxwg80PzeWrFfKM4pRnsrO47Lip7Pf6kqG7S8SQRA+nC0sQF102QCkhusKM0jAJAza+0SiKTAUjjltxIifkY+iIUtUKUvp/mw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17ccf48-9001-4a69-faa8-08db836bed44
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 06:39:37.0055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2/LqrKRBnJ4J1xdvmJlTiNhP3kY3MyEhhcf8ptmz93dyPXWFuKmrMNfT30WQ6jy94TDftS691GQt+hyEo0wmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_03,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130058
X-Proofpoint-ORIG-GUID: PG5It1jSbgfUDiVcl8-dpRi2CbJu3WuV
X-Proofpoint-GUID: PG5It1jSbgfUDiVcl8-dpRi2CbJu3WuV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 10:10:09 AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2023 at 02:57:51PM +0530, Chandan Babu R wrote:
>> This commit moves functionality associated with writing metadump to disk into
>> a new function. It also renames metadump initialization, write and release
>> functions to reflect the fact that they work with v1 metadump files.
>> 
>> The metadump initialization, write and release functions are now invoked via
>> metadump_ops->init(), metadump_ops->write() and metadump_ops->release()
>> respectively.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 123 +++++++++++++++++++++++++-------------------------
>>  1 file changed, 61 insertions(+), 62 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 266d3413..287e8f91 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -151,59 +151,6 @@ print_progress(const char *fmt, ...)
>>  	metadump.progress_since_warning = true;
>>  }
>>  
>> -/*
>> - * A complete dump file will have a "zero" entry in the last index block,
>> - * even if the dump is exactly aligned, the last index will be full of
>> - * zeros. If the last index entry is non-zero, the dump is incomplete.
>> - * Correspondingly, the last chunk will have a count < num_indices.
>> - *
>> - * Return 0 for success, -1 for failure.
>> - */
>> -
>> -static int
>> -write_index(void)
>> -{
>> -	struct xfs_metablock *metablock = metadump.metablock;
>> -	/*
>> -	 * write index block and following data blocks (streaming)
>> -	 */
>> -	metablock->mb_count = cpu_to_be16(metadump.cur_index);
>> -	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
>> -			metadump.outf) != 1) {
>> -		print_warning("error writing to target file");
>> -		return -1;
>> -	}
>> -
>> -	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
>> -	metadump.cur_index = 0;
>> -	return 0;
>> -}
>> -
>> -/*
>> - * Return 0 for success, -errno for failure.
>> - */
>> -static int
>> -write_buf_segment(
>> -	char		*data,
>> -	int64_t		off,
>> -	int		len)
>> -{
>> -	int		i;
>> -	int		ret;
>> -
>> -	for (i = 0; i < len; i++, off++, data += BBSIZE) {
>> -		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
>> -		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
>> -			data, BBSIZE);
>> -		if (++metadump.cur_index == metadump.num_indices) {
>> -			ret = write_index();
>> -			if (ret)
>> -				return -EIO;
>> -		}
>> -	}
>> -	return 0;
>> -}
>> -
>>  /*
>>   * we want to preserve the state of the metadata in the dump - whether it is
>>   * intact or corrupt, so even if the buffer has a verifier attached to it we
>> @@ -240,15 +187,16 @@ write_buf(
>>  
>>  	/* handle discontiguous buffers */
>>  	if (!buf->bbmap) {
>> -		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
>> +		ret = metadump.mdops->write(buf->typ->typnm, buf->data, buf->bb,
>> +				buf->blen);
>>  		if (ret)
>>  			return ret;
>>  	} else {
>>  		int	len = 0;
>>  		for (i = 0; i < buf->bbmap->nmaps; i++) {
>> -			ret = write_buf_segment(buf->data + BBTOB(len),
>> -						buf->bbmap->b[i].bm_bn,
>> -						buf->bbmap->b[i].bm_len);
>> +			ret = metadump.mdops->write(buf->typ->typnm,
>> +				buf->data + BBTOB(len), buf->bbmap->b[i].bm_bn,
>> +				buf->bbmap->b[i].bm_len);
>>  			if (ret)
>>  				return ret;
>>  			len += buf->bbmap->b[i].bm_len;
>> @@ -3010,7 +2958,7 @@ done:
>>  }
>>  
>>  static int
>> -init_metadump(void)
>> +init_metadump_v1(void)
>>  {
>>  	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
>>  	if (metadump.metablock == NULL) {
>> @@ -3051,12 +2999,61 @@ init_metadump(void)
>>  	return 0;
>>  }
>>  
>> +static int
>> +end_write_metadump_v1(void)
>> +{
>> +	/*
>> +	 * write index block and following data blocks (streaming)
>> +	 */
>> +	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
>> +	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
>> +			metadump.outf) != 1) {
>> +		print_warning("error writing to target file");
>> +		return -1;
>> +	}
>> +
>> +	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
>> +	metadump.cur_index = 0;
>> +	return 0;
>> +}
>> +
>> +static int
>> +write_metadump_v1(
>> +	enum typnm	type,
>> +	char		*data,
>> +	xfs_daddr_t	off,
>> +	int		len)
>> +{
>> +	int		i;
>> +	int		ret;
>> +
>> +	for (i = 0; i < len; i++, off++, data += BBSIZE) {
>> +		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
>> +		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
>> +			data, BBSIZE);
>> +		if (++metadump.cur_index == metadump.num_indices) {
>> +			ret = end_write_metadump_v1();
>> +			if (ret)
>> +				return -EIO;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static void
>> -release_metadump(void)
>> +release_metadump_v1(void)
>>  {
>>  	free(metadump.metablock);
>>  }
>>  
>> +static struct metadump_ops metadump1_ops = {
>> +	.init		= init_metadump_v1,
>> +	.write		= write_metadump_v1,
>> +	.end_write	= end_write_metadump_v1,
>> +	.release	= release_metadump_v1,
>> +};
>> +
>>  static int
>>  metadump_f(
>>  	int 		argc,
>> @@ -3193,7 +3190,9 @@ metadump_f(
>>  		}
>>  	}
>>  
>> -	ret = init_metadump();
>> +	metadump.mdops = &metadump1_ops;
>> +
>> +	ret = metadump.mdops->init();
>>  	if (ret)
>>  		goto out;
>>  
>> @@ -3216,7 +3215,7 @@ metadump_f(
>>  
>>  	/* write the remaining index */
>>  	if (!exitcode)
>> -		exitcode = write_index() < 0;
>> +		exitcode = metadump.mdops->end_write() < 0;
>
> Now that I see ->end_write in usage, I think it would be better named
> ->finish_dump or something like that.  It's only called once, right?
>

finish_dump() is a much better name for the callback. I will make the change
before posting the next version of the patchset.

-- 
chandan
