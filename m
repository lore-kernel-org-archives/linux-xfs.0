Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FD7C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 06:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiCYGE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 02:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiCYGE0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 02:04:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D3CC6824
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 23:02:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22P01aq8031953;
        Fri, 25 Mar 2022 06:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Tx3KaNk4ygfQ+Owo3TpBveJpmf2ZMkNYEf7/TF4HElE=;
 b=0hhQLKM52sR3cixr+ytPYl+yWlDO5kGLpKgfi1A37MwUYzjXyM8YHhNweXqXu6Js2ahF
 eYpVC3M/loIIG4L06aA9CW6KPN+6O+NyBa1L62AiF2CQPvtTT0G/x1vFDcDzBF/iyN7i
 tC6E4XunGkL8l9xRYuiKrbltp9vlWEw6fx2eQ/DUKvfbL515t9pn/xF7iCusuK6F9sNH
 CGnJIgXCMRDGpFwN43+S8tc8gKSZXnCFkGrblbBMfVvZHyLmFiRk4R5J/bRGSg/N/dY7
 gJYMsUeYjdiPVzpDdfRWDvTfbowsrvnUrtT7fqiMXo2fCH/I+wYv8sytzOxt0D7RiQB+ LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y26egs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:02:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22P61tN8087319;
        Fri, 25 Mar 2022 06:02:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by userp3030.oracle.com with ESMTP id 3ew49reyba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 06:02:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZzxPDNPdLhmb/+HcvjrrgR/9bPNoodTpL4rPKxwrV0ix5RTBP4ATQgUpuKoUMNqrmsXV9rjqRDwAPmDgaBWx+0H72hC2+pEPF+03PZ4HPl3rfSi5Q7BywoxVLt0BCwNCNk+dF0alYf5ftHg/7jip7ELQNuFKY4CGLTpAHUbM5s3ovaEjArULkgiWJSfWwPO8c0z5zZ7aDt2GZEubebThhzkMVEZXUX8RMONVzYewqDk9B+Yn/yJQzUUll2W3yVsW1FHETXCdw3ydnmJzsKCkVHMBbkbtPcwWJs97xZR/iTIxu1D3YXtAdx6BQ5sDVGU38n76VXDoCXBqea5JHYubw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tx3KaNk4ygfQ+Owo3TpBveJpmf2ZMkNYEf7/TF4HElE=;
 b=F21Lf1HkdInfakz036Wf9VZ1dBQN+cmXF88X6v+sJmQRGFoowWMMGlBmmf9/xx0gW2PHQVQUAqN0l7PvzdcWiAFZhQOqVgworrmhAotXJd9q0CB50jINk8I7uPKxqkXjYSm4wWoxJAfRxaJshVfT6p/ESZ2lnN1w2Jre71yhvy9LiBEApAH1HZ+EfyC9IDcqUn+vAEeXpcXteUWU85YTgrzLVWpyXf2kbu2sVbftDmNGo15kIQn16NK2xQ7xudEpVih5gZFPPzEcfSk/0T4mPhrTflEFB7/Prqa+xKqiz5iEeCpdDpBaDW7moDt8yrU0UTMupqUSzGSdn8N1mr6YKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tx3KaNk4ygfQ+Owo3TpBveJpmf2ZMkNYEf7/TF4HElE=;
 b=gaZACKBzOQzLoJTbQQ8npXXx6BF7O6ssSM9z38udtPUrAEAtDH2zSET22zjtkuShP4DDtcVHuSdB1NGJ4hK7wCN8t4Nt8urcqIBz5PzyVVwNYmCFOwgrDkt6kRvRIscYXqBm741U4+PpU2vQVsgc2jSKnPsZr0NSA5jq/7o9iL4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2776.namprd10.prod.outlook.com (2603:10b6:a03:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Fri, 25 Mar
 2022 06:02:39 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::f8e2:79c8:5da6:fd12%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 06:02:39 +0000
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
 <20220324221406.GL1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220324221406.GL1544202@dread.disaster.area>
Message-ID: <87wngiwow9.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Mar 2022 11:32:30 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::9) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7377899-afa3-4835-7716-08da0e251166
X-MS-TrafficTypeDiagnostic: BYAPR10MB2776:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB277618990BF9E4206EA20286F61A9@BYAPR10MB2776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRlr0H7XHw1ICIAdGsRJC+Uzm2VAQb/m2ItiPEnvnzwhVfdmTiXoDbVo6dcl8mIr4SRhQicXTHD2dy06qMfSOpLTZBM5k5fhVD/5gFIQJimd5cmgnQHHkaf9KPw9eLaQg9KXFQJywqE6T8hScBGj9+zPgQdAYk9GWcEGntlXUayhjGJuYERSdFFGtl7r/QNWtqd4JigAKf320UQLhM6d9XHq1EjRAU3tESk8rDiUPy69WqOURAwb3KhI+3krb1L8OBKheSfPZ4asnouXxe7MCsdQj5c2eNXu+/2uDbaEkZrQ3Hh/dEV0Yqq9fR01m1YcG6TDmHMHdjD7jaL/XhhEh2+Gp1bE8E/JP5/xd5nzp1k97oemwpT4bZS5U36yiLzBqE0mJMPOWcfqvIa7LDeRcrEdXW5+wlRUb+7W57RD7Yjt0K8IgWqa/v675vWh0rEbMWX7jeE6osUU4QYTlwN5npFkJDNLQFJATHSzsCzuCSo+D2iI8nSv47X899w3amrbvOb4Kmlg+tBOaJ/kYZgd6Wk1SslVddBv2QoJfpQWPWKA+FoHOmv44DMKAcpJK8Usu+1Ox9R0jIYMngLNLapHRTvM2NFRWee/tagNYk4PqJ64/zjoCei0RfLz0yK9bDY3aPlyYLgOTjkDYb1MV2bP17k/7rZRNgtmJ3JWoFsytag9NqMJ2nMLFTbGNzmU8X1Mrz9fpKciOvN7EBBVt/qUgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(508600001)(6666004)(26005)(6506007)(53546011)(186003)(6512007)(52116002)(83380400001)(6486002)(9686003)(6916009)(33716001)(8936002)(86362001)(2906002)(66476007)(66946007)(66556008)(38100700002)(4326008)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uxTDppFJr239OdzATXmBbT7D6pMX+/To57TJiozV/J2VBZ8RpXUAYMgfjiKG?=
 =?us-ascii?Q?ZmAzidqbCLpIJNW3LjrImvkn6jygYS2s4UpEW/QnSnIGZdZS5DMM5jrtIjsP?=
 =?us-ascii?Q?RDHPwK5Ypniv55W48HjOEyIuBNV1MLn0UEHuioQwqU/p1ba/e+5BxKs+DLzC?=
 =?us-ascii?Q?4uAennInkUYx2/0dVlI84RrOKBNKI4k9m2Vwso70HOY029G5FjbsZ9/lSfUO?=
 =?us-ascii?Q?dXxDbw485FbYdTiViHgjTvG9I+jN9vRgTp7zBzDr1nhdmeWxxM3GNatY95nR?=
 =?us-ascii?Q?uOEddYHI1SnoNHj+ECus2IiJr/7diHegoRWTFv27sJgiLxZ2djvZnij98bvR?=
 =?us-ascii?Q?GpaqEcJSxYcnDMP6/r2BUNgxdA+spKIpQ0NmihDC7ytjikmDGWJzD+deYHbQ?=
 =?us-ascii?Q?ZioWdsdqG1Z5ThDeS8r8TJzKdgx3HauVADvSpxNBQ3PTqQbE8/X74zrJ41zv?=
 =?us-ascii?Q?hqmKBTnoAsP2nLB6CgqMyKq7TOGgsvnyoTzb3vQEZOMUMAjxuol5fCSa8T9O?=
 =?us-ascii?Q?GuYzzXks7rmQvTS/hgTlgxRB5t8p48kw+KP7S8Q9faewxXos5s3vC+76r4cD?=
 =?us-ascii?Q?a+JQMHOi6Izeb9Y7wX3M89JdktXfUHo8K1PSAVdpegnynJNfDE8c6Xlbm5Ly?=
 =?us-ascii?Q?3XBd5nBwTf4ZMniR4e0VotS5yzY3r4U1gf9HW0uQ07HeG8SFNFTV3IrAtY5Z?=
 =?us-ascii?Q?SG6A8UlnOYoZQUNlhSgj9klcxRhBPaaClxa9zJduj8WskUGHKjogwtS6drjr?=
 =?us-ascii?Q?3qlAiMpWlWlcDi58Ej5j+Qnqc26pm5Hul+7COBT1WRQNHdOEh+uDxZS7Nu28?=
 =?us-ascii?Q?zUu0lQny8UMuh+xp6Vmhe4Ytaw3bZCA2y6F5X+Lv1nrLFH/n9SJaJedbAYZ8?=
 =?us-ascii?Q?zmIY9NZFopAjSkYHMBw8mnBt87n2zjXbYPOsf0RdLWGc7+Ti5gkGCjQ3DSWb?=
 =?us-ascii?Q?AK4tVKNuUWfn1uzSeZ+lMtq7Mrj7HLED4O5qT0v4c7JfDiTb7fxw0VpYOd2e?=
 =?us-ascii?Q?cDXPEypQ+ICsJizTxYzhDg+vkx+Mq7Q+ixH93Iz2LNDyrMpBQmGLEosqteuy?=
 =?us-ascii?Q?gcnBkWyPD34hzlnoR6W1Wuwi8ymmt6htp/XZg1zLZEuZZwp0IONuNuNAM/dS?=
 =?us-ascii?Q?RFGB+zZf/r1hJ4IRZNBPNFdp8uhMCkU9iZ6JzylzyiFxYx0EKHxZY6xVwOeI?=
 =?us-ascii?Q?ZuVcDqPC6m651HniixqyvBWMJ2i5TkwgycLNp/jXNPcenjmf3VwJlHDCstha?=
 =?us-ascii?Q?tDZ9z8Ny/BcmT5CUYFSmwFR0DrXfgEmRXkKBfMFP+UfDiTt0K6Kj4YvISuym?=
 =?us-ascii?Q?Kqdz63L8BdUm17Uw75z3qFD2cp/XAQP/+UGP8d0CZrS3KJXHHrtMUP6cm6R1?=
 =?us-ascii?Q?GhnIB8/GlbbHwX+KgyZTjBbbbnKUehThPIl7j3tT0rQmjxd4n8ppIvVPebW3?=
 =?us-ascii?Q?5eMiwD7XBDVgrx5E2LoaN9EOFZezGfC6jZDNLAk9kijqz5Eq39e18g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7377899-afa3-4835-7716-08da0e251166
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 06:02:39.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A2cFr454fOzklbTy/j3KwUoKKVHqlEElP4cSN9q8kOwPYa7R/8y07ozN+dXXWzSbaVDFo1/+iEIji2m1JL3Xgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10296 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=898 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250032
X-Proofpoint-GUID: 6ht4oWKbwNQxDWNCoxtdSRzbjAZwUl2W
X-Proofpoint-ORIG-GUID: 6ht4oWKbwNQxDWNCoxtdSRzbjAZwUl2W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2022 at 03:44, Dave Chinner wrote:
> On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
>> The maximum file size that can be represented by the data fork extent counter
>> in the worst case occurs when all extents are 1 block in length and each block
>> is 1KB in size.
>> 
>> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>> 1KB sized blocks, a file can reach upto,
>> (2^31) * 1KB = 2TB
>> 
>> This is much larger than the theoretical maximum size of a directory
>> i.e. 32GB * 3 = 96GB.
>> 
>> Since a directory's inode can never overflow its data fork extent counter,
>> this commit replaces checking the return value of
>> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).
>
> I'd really prefer that we don't add noise like this to a bunch of
> call sites.  If directories can't overflow the extent count in
> normal operation, then why are we even calling
> xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
> be a sign of an inode corruption, and we should have flagged that
> long before we do an operation that might overflow the extent count.
>
> So, really, I think you should document the directory size
> constraints at the site where we define all the large extent count
> values in xfs_format.h, remove the xfs_iext_count_may_overflow()
> checks from the directory code and replace them with a simple inode
> verifier check that we haven't got more than 100GB worth of
> individual extents in the data fork for directory inodes....
>
> Then all this directory specific "can't possibly overflow" overflow
> checks can go away completely.  The best code is no code :)

I had retained the directory extent count overflow checks for the sake of
completeness i.e. The code checks for overflow before every fs operation that
could cause extent count to increase. However, I think your suggestion makes
more sense. I will include this change in the next version of the patchset.

-- 
chandan
