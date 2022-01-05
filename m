Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF20CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 14:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbiAEOPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 09:15:46 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13162 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237013AbiAEOPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 09:15:45 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4JTU004862;
        Wed, 5 Jan 2022 14:15:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=VCWGZfFdHIbeDSkpwzrjj3W9eeDxiszn4us8mn8wfCM=;
 b=hk62tXhVkiHkZWy/PBeurrzZNq/UuDK7qzygJu/UFyhMYjD6pU2CTRmIuNcjIfF4mgUB
 z4T7tAN36s5yYvnmhlLjTgVO+2O0I2Mo3rGO1fLvYQ4CNp+TAKRNvCHGIRE369eD4wY1
 qHB5VLVLhwYJQB3sdo/c+Aq6cIpKGbbh+xasmFSrw5PTU3MgZ162sGNZ7rmaJ/qoelPg
 7IXOBPdPkV+tJV3wMD9ffFi5ZAs0/nGKVIHiiNgFGmMSkQTOO11r0A1jdFwxr3XZ6sTS
 qkOxWllF+FvL8O8SdJ7KOQsKQCeCGDT7/RZNk2JWrJ1c2+i7GLHSbTBiJJx8WCoHSQFx bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3st4xqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 14:15:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205EBmCU186015;
        Wed, 5 Jan 2022 14:15:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3dac2yeah5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 14:15:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYLh27qV+W8cGKUiFCsKyMPgaAfPVjm9VHxewhRBU9zV522aM4V+6S6fR7/OgoJxOe9LXeVV9eXpJTWKAIrEHd05xnejGeg5+vOchZ+RQjMjRLMCcV2887JsJPGOa5fUr6DQoxjKM/QeIcXRx/1vCsmhYmXZBl0gs04dGPxw8dtQInxKVk4CGyGR7R5a5WUXo+XqznvL55JvzOPMmAg47EDCLUr5BFe357+69mB8tgE0CCFMt7lEHY17MZH3NuMLUAmBzvp9OtrxWDOuIAb7IaDlSVcE2M64Izr3dppzW0qDXTUi/djPODUfWXcGyN5UBGAVIWLNo3cNS6W+suwSdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCWGZfFdHIbeDSkpwzrjj3W9eeDxiszn4us8mn8wfCM=;
 b=PdUgMW/fYLSwZNxIMIrus+bEDUmhehzQXJ7RY8IdK/CQjw0vnIS1mdH+Vo47+wUuSJYsnCpHBLEnaLxi9Rpr2u4kScfcs89H5/dCiyvq6k7LQRA/R3vj2Byc0qLZV3zV8rP19tS4j0Dj8gDFrPJkLv/mgXpolrVVP5JWjFrDr1LrTXq0J3RxYREMeMOf1JMy70raCrCg4Icer4BjeP57+bRbER6tnBjnxQjwF03COfunqT8smZq/X7/IsydzKPisvCw8qqhxjyJeETVVbiUXzVXMwJeDNXhHGNQqjatVZTydKnMK3IzLVS6EARjxkE03xHS7SStMLz6trJmA2cCpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCWGZfFdHIbeDSkpwzrjj3W9eeDxiszn4us8mn8wfCM=;
 b=ePa2/Pmc0bQ8Ven6ntWzQrIPvKR1uDbPtjjNue88pucFBT+gCrrY+qAwz+TePAKBUJLy5hCZLb7qJrL5ShGZGhNcfAmQJffj6Lny7LacokqyNwhR8P2A3rgTfWKrdlRi5CZGUxJxzduZ5TOs91/zuA4xUY1xHL3F1wQbVG8ADl8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN4PR10MB5560.namprd10.prod.outlook.com (2603:10b6:806:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 14:15:38 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 14:15:37 +0000
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-11-chandan.babu@oracle.com>
 <20220105010824.GA656707@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 10/20] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and
 associated helpers
In-reply-to: <20220105010824.GA656707@magnolia>
Message-ID: <87ee5m8e11.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:45:22 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0026.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::18) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3adbd830-e89f-4383-2f04-08d9d055d88d
X-MS-TrafficTypeDiagnostic: SN4PR10MB5560:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5560B9BD0250659342A2451DF64B9@SN4PR10MB5560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNl73uQ4Qnk5QoJ9JuLgqTtKdqYOXkdzdvxC61Z/yAkpI0dxl/27x3wO2WPUj8CadlLGV2p4zjdfFK1Uez6C1CD6hm+CrlBqRQZUpJ9AZfI+Nc5YoIE3AXregLJ4nTVJypDkfNikH844KAmW04egzjfxZ6FJwEXY66sUiaXyubXY13CNGA4l8iNAExYGv5oTAAkzFtydO5l2rY9i40UdASsNUAB1F1u7kNu7peEC4q+g5KeLvE9iGNxJiFD+b/90LBjBdB5YHFF7cvGf4nIX7zDOL9Jv6FiD1CTU7FqSbRpfMDKTOc683U0cvSV9pOdG40TTSoAWiDwjtqVswJe7A/F5nyD6DrG5IIlu1KMac/A3ETbI15tcHVN2zlCQ6nnihMpl42k2Ugh3XNKJKSm30xnubjF+o8Ia9O5qhaB3nW1/SEQ4TQeuRxteoBRXeE1AUXTfx5PjIeWiqvstDI4qCqILMziw7ff49QLFg5YV2wpfed5zRHy+CApy3YOkJBi3YKiaxSLpCkaW6MTIYWHmbs/ZbDeTaBzEPzQ0UoNmPGTtGxDEO8rpBA87/DWAnCSyNtZoBrytPSa0TxAhwMZG4/qLzcmqfR3XcafjgMz2Zq+F8PzR07gyrDTwrNQ28btwfcwQv98jtk80vwAh9hq6FeKVX+FSY8LfxieLNPJoS4sKAe2UUHBsnGzXa/ATYF9Kt8EpAnsnnA54q22sKGPAcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(4326008)(9686003)(6512007)(53546011)(33716001)(508600001)(38350700002)(38100700002)(2906002)(6486002)(6666004)(86362001)(186003)(66946007)(52116002)(8676002)(66476007)(66556008)(316002)(5660300002)(26005)(6506007)(8936002)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LqFxa1eMoiCDM6vQ0D3PuYBZ4/9pewEVkMWtmBUUeWbxLnBEDdEnOt/fZKxT?=
 =?us-ascii?Q?Fpw0N5DZdMFcTS8ka+Y4yP9Ng361l9YksfEwdMLxlMZChh/SgRDhATDn5yXz?=
 =?us-ascii?Q?ZxeG+9LUhgmtLq6ifaMDuWhucPdxFgO7xRPV6iooFswyE4NcXGXqNWTZSknz?=
 =?us-ascii?Q?Bqy582fSl0yk/MCImKY8T02IFg0yD4AEOX3FiJlAaYnXnSBTfcS1LWDSQWhw?=
 =?us-ascii?Q?8hFHMuuzbqI7RMzhBMLO1322et8Vc+7aqvCHMLrrP6ruR8TuSNGsjmpCIML5?=
 =?us-ascii?Q?zAMwfcOglOeyktFn2nFUAg760VK3FslJsXAyLb8gLAP67+ocMywmOt/d/Tjm?=
 =?us-ascii?Q?QxT7vZK8a85j/PQRAstHl8qAmgB9L2VzdftCuGhFrAkZXWhzYf6ql6BGu9e1?=
 =?us-ascii?Q?eBMKU+u9/JT69Wj/bcN5dI+6aFbV/BZLPeLG+3KrMPI0Qen16lv/luYhEHoj?=
 =?us-ascii?Q?jJGKGIOdObw6OP24JSs91a2IyIPLdWiXqSnv4KnoVldp9YQmDHgGUoDi5obH?=
 =?us-ascii?Q?yD42KvhiBCNmGmWd0Y/6VoXsnynfjj3GxuCDVMNqe3kbNQdFsX0N33gTbMLI?=
 =?us-ascii?Q?Shzcn0mHl2jmV3y+BGWR9EeTjG6rA1Co/yx5o1b1q8tK8EWQp7jJpf/ugPcA?=
 =?us-ascii?Q?sWXyGToC/346n8h3FA1Vdle4eh2SV6p2Z0o9lL39IDbp2RrepoKJZMZ/YQCk?=
 =?us-ascii?Q?pfTPFfLjt0GtAi+r4g51PZEOCnueBNFtZvUA9qLKkJ/0tMvWPOr9xZX6IqAS?=
 =?us-ascii?Q?G4DF7kW82gSKHV/XixEuQyylBG0NoyOhBU4kIthD+yNHrwRdEt0qr6jFQXCE?=
 =?us-ascii?Q?xXewmY267jhWRr0ssbTI0sn+yVcBJrww7NgIOslnFqxCGUIT5jg+S7QEarbf?=
 =?us-ascii?Q?XFkttF4iA9o0KoMRl0uvf6msf6hDAMyUgbBKChgqSAQMe70hT9jMZxLz2uD+?=
 =?us-ascii?Q?5CQhTDkP8/5AF1yNyAXFD5xAUuAv6Y1G3lxpy6InKIDdt+rFkRC+pqoZWi7S?=
 =?us-ascii?Q?V0u+gKSCcg0LiZm6DMyFur8yXfWowcCOfYBDGDXH0qzTxI/SH0lH2JTGR0JY?=
 =?us-ascii?Q?uYj22IEEVcHU5fBhjPUfSGYGMYS5w/mKd57k/kLB6PgtrQxhHb+xH76U8cr2?=
 =?us-ascii?Q?GznfGG7KLUHkbQsJJrkTmarBBtinorStHFHHibfCCxS1+W5imP3YpVQlnDks?=
 =?us-ascii?Q?KTMWBx1dTOi1SVw2H/wbx9lw9+o+9wpEVZW7yQ9iXZo9Rj+BnxDtMxWH2rNr?=
 =?us-ascii?Q?S0CvbcueAMMX2CUxSEMJvrR+skPbarHMpXaf8/YB/SJdY+TQ0pznfhnn/dov?=
 =?us-ascii?Q?K+qXaCxMIUdDFw88PQNq3KARyqhkC5AuXHmMuZ7CbEtW1pZ3+GKjZe4vxSbF?=
 =?us-ascii?Q?pmEWRqtGbALkUoZktkHxkDoKC2Cst/wn9eYFs19hLyyHhLP80qMgwebl5NCO?=
 =?us-ascii?Q?jkg06wKD6tfBM+haMvnGrHiyFhDJN+rdo8bL4OscgumjuaA9JQvY94n/3Ivi?=
 =?us-ascii?Q?kCqenLSOrlsP6SGDFYpM4A5C0WRugup8YR3ZZSDMy8UfxwmKoat98If3ODPv?=
 =?us-ascii?Q?r8La1YStoWLMt5Wf4q1xzGMi7tA7/YtjnZ2zpLFQNXYjNbiF6Bu3hstjVHJx?=
 =?us-ascii?Q?K7txLpdIybXFqSvDGGxqDiA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3adbd830-e89f-4383-2f04-08d9d055d88d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 14:15:37.6412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gj4S8enrXJqAZ+FGYIQeiwqV0TyQnc/GA4QbRyk2bZcIZEIp3jPy8gyi5zDlpXduhCVCCmVODT3KM1wpdjkOkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050095
X-Proofpoint-GUID: Yfe0bsnMqkrWLDlI17I9tyse_hFiqKOD
X-Proofpoint-ORIG-GUID: Yfe0bsnMqkrWLDlI17I9tyse_hFiqKOD
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 06:38, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:18:01PM +0530, Chandan Babu R wrote:
>> This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
>> an inode supports 64-bit extent counters. This flag is also enabled by default
>> on newly created inodes when the corresponding filesystem has large extent
>> counter feature bit (i.e. XFS_FEAT_NREXT64) set.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/inode.c          |  3 +++
>>  include/xfs_inode.h |  5 +++++
>>  libxfs/xfs_format.h | 10 +++++++++-
>>  libxfs/xfs_ialloc.c |  2 ++
>>  4 files changed, 19 insertions(+), 1 deletion(-)
>> 
>> diff --git a/db/inode.c b/db/inode.c
>> index 9afa6426..b1f92d36 100644
>> --- a/db/inode.c
>> +++ b/db/inode.c
>> @@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
>>  	{ "bigtime", FLDT_UINT1,
>>  	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
>>  	  0, TYP_NONE },
>> +	{ "nrext64", FLDT_UINT1,
>> +	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT-1), C1,
>
> Nit: spaces around the '-' operator.
>

Ok. I will fix that.

> --D
>
>> +	  0, TYP_NONE },
>>  	{ NULL }
>>  };
>>  
>> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
>> index 08a62d83..79a5c526 100644
>> --- a/include/xfs_inode.h
>> +++ b/include/xfs_inode.h
>> @@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>>  	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
>>  }
>>  
>> +static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
>> +{
>> +	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
>> +}
>> +
>>  typedef struct cred {
>>  	uid_t	cr_uid;
>>  	gid_t	cr_gid;
>> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
>> index 23ecbc7d..58186f2b 100644
>> --- a/libxfs/xfs_format.h
>> +++ b/libxfs/xfs_format.h
>> @@ -1180,15 +1180,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
>>  #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
>> +#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
>>  
>>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
>>  #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
>> +#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
>>  
>>  #define XFS_DIFLAG2_ANY \
>>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
>> -	 XFS_DIFLAG2_BIGTIME)
>> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
>>  
>>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>>  {
>> @@ -1196,6 +1198,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>>  	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
>>  }
>>  
>> +static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
>> +{
>> +	return dip->di_version >= 3 &&
>> +	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
>> +}
>> +
>>  /*
>>   * Inode number format:
>>   * low inopblog bits - offset in block
>> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
>> index 570349b8..77501317 100644
>> --- a/libxfs/xfs_ialloc.c
>> +++ b/libxfs/xfs_ialloc.c
>> @@ -2770,6 +2770,8 @@ xfs_ialloc_setup_geometry(
>>  	igeo->new_diflags2 = 0;
>>  	if (xfs_sb_version_hasbigtime(&mp->m_sb))
>>  		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
>> +	if (xfs_sb_version_hasnrext64(&mp->m_sb))
>> +		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
>>  
>>  	/* Compute inode btree geometry. */
>>  	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
>> -- 
>> 2.30.2
>> 


-- 
chandan
