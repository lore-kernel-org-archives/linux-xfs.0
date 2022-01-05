Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3731C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 13:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiAENpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jan 2022 08:45:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25552 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbiAENpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jan 2022 08:45:12 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 205D4HbD025012;
        Wed, 5 Jan 2022 13:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tu+b36p3U9q1Bs9CiHtuwYkM7Ck1XQdCeigos3cW4+s=;
 b=ANdXE5zW5QWgoiqrtlG7OILjG5FSDTtCYFU+5AHoIAp6P3gj9klqtdKU5FPGkpCPJNz7
 FPD5OUDC218JOQG9+KiPE9nqfwPsXmAEdvquCIF9ZfCFgfnUFmcrkSFWP/4eP2XlGFQR
 ud1emk7S/U4eAcw0SC0oV0JD4DTsRCyvZpzY2oatUKGBEFkmpdZKRZeIfmr8ln+E2a1A
 9wCtlaPQFj1UFXtHxzBtMU4nMVYB5AIoD1QWHfWgRYd76GngCa5vsdMlXm0f+UYgD7U9
 /njQ78zxchXYh6YDOhQAxmNaPVTohJAIf2AiZzdcn4PLO/TJqBpGXta9xRluNdPTrErl KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc43gctcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:45:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 205Dfm9F079396;
        Wed, 5 Jan 2022 13:45:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3dac2yctcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 13:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6gcnVr3FeHZN7LXSvA2NsRDb4jaLaA2eTFLgQUQQPU+kje/6wUQhnPuMwlqEdQTVa5F5ZDqrK5SSs5zLBB2Co6FFkhxHsKS1ZgLwpkVBbzgEJJFWOvPTgcsN+g8Mrr58QFSSV+/vOH8AIaSDtmwpDy4FUttPUUoqCW6IygKsy10Cs3WJjURZ4UwI8RCJT+mM5dQlDXE3OPRbvAqS/oh6KE8jvttDX6fU45nncZaQ+g3azno9gDpXAh+yZSwmxMVZocBlUGZDwzpmesNBKPR8GfRSNyoA+wAfOQ2p6aYa4tywq9lmJSwyi12v8h/kuFXWhS8jT/lTCaq2uV25mYLpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tu+b36p3U9q1Bs9CiHtuwYkM7Ck1XQdCeigos3cW4+s=;
 b=ZACDmPNkaulfI64uakoT8WaQT4ODoF9NPmbrA0NaMm3cPWqL+zp/4tuY1bLKpCg/u1hl0PAinH9a2NG0BlCMCa9qI08cQrWS4vo/kBOwSyD+Yk8ok9wnBl91NY6VAnocrMbq5e6KktdPEEvcd8vu4DHQrsIKglYdYb4jg8gIEljlbG7fK0CJBhwMWjuzCs5aSQeK4Qc4Ks/osUy6qm/y9MFrw8LljtZawedyPjdDARqfumJsyPH1WGRxk8uH9gBfDbv0TptsCxCzFssk0vMg45D5Z50YNGrtaTKkqrmv97pUEe1S6UWz8+NP/YVjgnDOWtip0a3ozQjgE6PTcXjI1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tu+b36p3U9q1Bs9CiHtuwYkM7Ck1XQdCeigos3cW4+s=;
 b=jkfZYe+9m5X5/StLEGZ719lmuDHLsTkN5KSaTSPj1XMZ+eg3oUw3IujXpthN1IcvKWMEe6DqJqZ0vuypN2FgRZ6kMoaBSNayj9dS5bTIFTdYtvaWAN6wj9oAQkL6k7wfJvEnKKnjsfLcIAK4qEmutDOeKm7OX2MPJk/50OdWlC4=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2926.namprd10.prod.outlook.com (2603:10b6:805:d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 13:45:06 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::75ca:e478:6788:d21d%7]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 13:45:06 +0000
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-9-chandan.babu@oracle.com>
 <20220105000524.GO31583@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 08/16] xfs: Introduce XFS_FSOP_GEOM_FLAGS_NREXT64
In-reply-to: <20220105000524.GO31583@magnolia>
Message-ID: <87y23u8fft.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Wed, 05 Jan 2022 19:14:55 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0144.apcprd04.prod.outlook.com
 (2603:1096:3:16::28) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aa7c0fe-86f0-4236-375d-08d9d05194ec
X-MS-TrafficTypeDiagnostic: SN6PR10MB2926:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB29266D53E4B99A9C4DCF5AF7F64B9@SN6PR10MB2926.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFDfyN5IW7Upe5DNkdUFOb7vaWT0/YgcPBBvJywT/K6hbrWyaJ7sQwLq2y4w9FhMA9AbnNq9ZzGMCAcnkkU+Fx2m9SFlhYR1HcfTgIybCGKPdhkpuYaRR+U83FyfIUS5dliQsXkht/O3dh1XfzuPSiFy/iv3MVHtkMkW9NI3imkvAqkxH5eiiOt+nQXHoRhDCgEABpj5CVnM3gjFa7gDmCRPCR9+Mmxz8dak+G9MCjmphQ4JYz07sqZmBLBrqzl2KZfNmRs4gkVmmtTfNbO1g+jTTRjEN6zxA6+9+VZzO7IP5ynh9gw8GAqjZpxze5GD66OHmj5I/KkCJMJWeLAycvOhhaAN7jxZaIIVyt+3nfEi/Wr5w0u5s+vHS+CsdQOMJPy6CQlCs0Y2CSbDYaQ+s8aXNCYcFCyvIBe9bVcNsUTvR40s8jC8v9yFGeLG0d99EAc2VdIhJWl3FOZG5oVATDQDWa7h/wfm+5KDrxygkWDGZ+mPpAMurJyf/4VEcPY869HYcrVhgW+/2bBrz09xSAXplUCwwyW83CW4ovo7jPUI3S5M8BriX5bVUWB/yYLc4iOGHG5leghw5qXvbprTgZl5n9wHAG97YWbsxbHqMdUhQoF9CN0zZ9nE3nw/bEz9ocT3YnoBioqo5e3AzMAJhZVh0XVw/mcAKxbDSiRZgJsVMiBoKDNwXNAZBwy8p9SQcBlERZMliIKTz1fv+Xr2Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(33716001)(53546011)(186003)(316002)(38100700002)(6666004)(86362001)(5660300002)(52116002)(8936002)(9686003)(6506007)(6486002)(8676002)(66946007)(26005)(66476007)(83380400001)(66556008)(2906002)(6512007)(6916009)(38350700002)(4326008)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?enfDG8xiUpfDfO7ityrySipySP2UL+xfq4fIGJ0q8+3tukqVAFXouhTr21wS?=
 =?us-ascii?Q?w5CDqAZwBEDmFIXJkR9qhmbomK5alzozriUfIuN+tJu1KMnidGuqZXvDkq2m?=
 =?us-ascii?Q?WbrRcf7ZP8qajC453giKaFhtv0BwodFtw1KDXrd3xsVBpZ3YDAL+YzK0qrnu?=
 =?us-ascii?Q?vVvSsar103mh053kg7MToUQFgPRIyZxpppvza1tCGqjnS//ntx1ZIwlk+vje?=
 =?us-ascii?Q?ggT8w83HTSRIRZ4KqX684I4PyTB26OuJeobRZ/jec/3CrMnFEaEUvtdgUJYc?=
 =?us-ascii?Q?iJUm0F22qrP0Kw++p7kfMM5a2tgv3Q8cEPkDsUmmXaKSKItNWE1HEm39Va38?=
 =?us-ascii?Q?RAo0h+jjF69tFJCOOTm/HzpuL8DETqitD0eAzWLGrKZmStlEM8xD1dSsWxEe?=
 =?us-ascii?Q?zirs+l3t2PdpRCy2B4EZrTyMZx277BzssnvsQ9qXdzfYtpken310zPlp86mt?=
 =?us-ascii?Q?ldGaPsxvQiASiOkU4kfbdRe8mafEev8EO8LohYfB1dMyofQNwHS0LieNtHi0?=
 =?us-ascii?Q?jB+t1H0QGtMYHzTF4++iPg7gynbX3E3OlwsikBoX5wbCbiCtbXPkxpLagjZQ?=
 =?us-ascii?Q?3lFOx2DlHUKbHu1EjHT3f1rYhK1OOq3g0GboFps8BN2GmSU98LWsueI6cKQT?=
 =?us-ascii?Q?Y+wBQOGGW+gonM/dTQpOnCf9Z4TVrNfPTeqdwFoCPL9kU3a2HhEMaprGGIaL?=
 =?us-ascii?Q?gSrOS6tz8kv7StRmxNt5f1jmy+S6Kz3TFJ6/Q/ZLuiWYSXOAAecWvDuCwjG1?=
 =?us-ascii?Q?EtIoN/7pMYRGPjlqufWFMfszdmiVHO7Oj3Ju1bPjfK2oWPSQTXXqmPEU4sR4?=
 =?us-ascii?Q?6duRNb2FCJOlu+R6yN5vbEocFgX0SbZe5FbzD0pdkZFd+sX9E06dtV1AnA4T?=
 =?us-ascii?Q?kLN6nsBHaX21SEGlw9vj1JyNwhAKzlFjSabZk2DVBYPtTDP69DqfZx769A+0?=
 =?us-ascii?Q?rbsBTa5eq6vc24OnGFlzNh4P0wzFdM4eN0bQ5gp774cqH/6bvINXomSzD7Q5?=
 =?us-ascii?Q?dDanSrp9AlY9lULH+L9lZwKXVh7n6htFtbkB+SnJWuYU8in44IaF2GT6FtAA?=
 =?us-ascii?Q?qm+fIJnvNjHjkCT6nd+wJvUP0zFDe5BBpAZqou17Pxs/LB8b+Cz57x0/nxdh?=
 =?us-ascii?Q?nze/hm7aDsZR6zSPIPGEENvqrLlUSJSwdNxQTWc4R1oaWS/PPYYRUfJ4S56F?=
 =?us-ascii?Q?WSGtbj9S5FubbeypvB793yvyuR6LB/CnXqKwf2Fd0dxqRnyKDe31rD8G/Ief?=
 =?us-ascii?Q?Fc3JX6iF+OaQMy/RhPYGRmts0Un8Z6Acim8yPmGA40QnA+e2Qcargf4UPDxa?=
 =?us-ascii?Q?sZFzxATnm+hhOeF6ahTsdTk4bpKP+ROP5Zlv6c/bdLIyP0W3nn351WYfQub4?=
 =?us-ascii?Q?Lxbdfktzlhh3/oxlNaf8iIYMMNk7iwfKMj9lk1jAvKY4/pYpYQSYFSx3QxDc?=
 =?us-ascii?Q?2VHI349RxnTj3npGIYqA6Zjhmkp46hwLrpFlbHNjXm3t6JwgX8r1F2Rm6b46?=
 =?us-ascii?Q?8pZTJPZu5Lktv7j/fQOJQD6vE91zbYi0CxPvMk5faVpbQQauIh/hi9iatfwk?=
 =?us-ascii?Q?lx7gGqOQmFdnvhdBTIbF+ZeP1/Fu/kDrKI5YLctf3Z+r8EqN4Ve+1WFDobRS?=
 =?us-ascii?Q?A5dgQIgP6VsNDVPDIjXFYL4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa7c0fe-86f0-4236-375d-08d9d05194ec
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:45:06.1790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hDYoLJlt0IMbYWoR6J8YeCxcP4gfN7UXrJC4vm20/I/bboBx0dFUZAU6PwNDxOWiwH/CrCWsgkE/NgwsUlXGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2926
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050091
X-Proofpoint-GUID: MRoLOoh3IKaCXNqschlkojJE6jwxyJtG
X-Proofpoint-ORIG-GUID: MRoLOoh3IKaCXNqschlkojJE6jwxyJtG
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Jan 2022 at 05:35, Darrick J. Wong wrote:
> On Tue, Dec 14, 2021 at 02:15:11PM +0530, Chandan Babu R wrote:
>> XFS_FSOP_GEOM_FLAGS_NREXT64 indicates that the current filesystem instance
>> supports 64-bit per-inode extent counters.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 1 +
>>  fs/xfs/libxfs/xfs_sb.c | 2 ++
>>  2 files changed, 3 insertions(+)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index c43877c8a279..42bc39501d81 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -251,6 +251,7 @@ typedef struct xfs_fsop_resblks {
>>  #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
>>  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
>>  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
>> +#define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* 64-bit extent counter */
>>  
>>  /*
>>   * Minimum and maximum sizes need for growth checks.
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index bd632389ae92..0c1add39177f 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -1138,6 +1138,8 @@ xfs_fs_geometry(
>>  	} else {
>>  		geo->logsectsize = BBSIZE;
>>  	}
>> +	if (xfs_has_nrext64(mp))
>> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
>>  	geo->rtsectsize = sbp->sb_blocksize;
>>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>>  
>> -- 
>> 2.30.2
>> 

I think you accidently missed typing your response to this patch?

-- 
chandan
