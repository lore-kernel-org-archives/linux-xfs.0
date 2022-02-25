Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23043C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 06:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiBYG74 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 01:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiBYG74 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 01:59:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357C782D2A
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 22:59:24 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21P4e4VZ030036;
        Fri, 25 Feb 2022 06:59:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MVuVyR5VBvLbrFmCAwEVnaCfTmHCD/+vagy1A9LMu+E=;
 b=PiqQFWs1pKer/74GtjWayME0dyxXXxUpYuqR77FTYtdc3t2TNYYm4EHUJqMu1RDy8liQ
 unGN8fVwj9OsgwvV3vnksILL7OGiChkOOmxVDmLu0RJMebFUKNJJTNpxV6UeqPj1+g8Z
 2x92pNqg6q4jhKIDrui9wr/4mfOMd4H7Q8t7qvjWBfU295kaEmbeOTvsRdTe0M87Qfyl
 VoRcV5yxL1CqtUODE0zLGfgX6SIMEkCRdORu71Fo5MYluo4pFngxfxLEfzcEFf6y6Gb/
 xvLm5zhg6ZH+tLlymeEP/ileYlA/PcUf+linp4Bx58v85qp57hbdFiDaHJS0eDy7vkxZ EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect7asdss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:59:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21P6f0Bx171051;
        Fri, 25 Feb 2022 06:59:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3020.oracle.com with ESMTP id 3eat0rpvx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 06:59:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZ9/gsupfUuVdXSngTSw72liys/qq8e3J+oNc10f+/lOOtNdbgMHZi2P7H7m+Eql+WfipTkWhrM5aqj+5FK0JsAlZitebX56uY03yKr3wgCdee1ZegAK6ub4O5mpDI8T9MbBmy8kTeQEUEcI6bvmwgO/S49r+cQOseovJDPkIPzG3/UrwPNUV7Z+Wi4V88ssFSoYictFT5OEQ84PeDsP4E3PPbon9IaF2oJRmhR0zy7OHF2QgL/b6u/ubksDuidRyfC6uQe+gPgOn7ePAsMcPIKsWB9hOgLK0zTHT4+EXJZcr8CTmLykk9MsLPuU56Vdn9tnbLmswsW+ZkarovOJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVuVyR5VBvLbrFmCAwEVnaCfTmHCD/+vagy1A9LMu+E=;
 b=EUz2pTtlMCA/QCVcShaTCZo7GVE4sCmGYLYk8aGvCpjhMAsgecy/C8oJV6VWdjOqXRg9zcpPWZka/+dWZjYDBX7+/Kzeq5xiDxIsnBRXtA/hLrXmpAyUaqLBQo69Rcjqtr02/eXYqJy+ttC8wmHaQwhdIPdExnRWRidHkLzAezlhnmiwbUsM4chD5djzdZJJ1PUIpYoc4N4TuOrw3xgudou31AlRBSgZum3ah/HECMB6Dc3BHBxRCXdy6eryyKlsrMLMEfNfJ/i5FOJedi3caENumgJyGz3HvNZoPkDr+GMtYT2yNN8oFn7o0qAdoCw0OD8n2mysp/qCtFz9gn6fKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVuVyR5VBvLbrFmCAwEVnaCfTmHCD/+vagy1A9LMu+E=;
 b=ycSkL+z8VmogG8zi6xLjo2CATyncPDq+4/pgAlWTRce9qLD9tupJJz4XFVSEY50CEt0N/AYaO328LWqu9lukMmfZjSjO46TzDHDTHHgfy5XKKpRdAPg+dhST2n/MHYYaqB8jmit0tL4TWZ8DMU66LEoQ6dpjThh0v4P/DeX2j3c=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB4380.namprd10.prod.outlook.com (2603:10b6:5:223::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 06:59:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%7]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 06:59:12 +0000
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-16-chandan.babu@oracle.com>
 <20220225051010.GK8338@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V6 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
In-reply-to: <20220225051010.GK8338@magnolia>
Message-ID: <87h78na0ug.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 25 Feb 2022 12:29:03 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:4:195::8) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57d04035-8a02-4ea4-a661-08d9f82c53ea
X-MS-TrafficTypeDiagnostic: DM6PR10MB4380:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB43804B3A547B97ECEBA7DCD5F63E9@DM6PR10MB4380.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dW37Nwg3tc5RSsP4es3stWlMKpn8BPPj4tByqTvNlJtr4dNn9eGNR7h9cO83PjG9qkQTrkk/I4TtC3Lz4n7nHEfVyOu55oiZ/Pmhs2EswpPjJzX+/s9+0nTK066QUwp3nwaQ3WsmLPTRt+rICRs9JqCQnNMZoUTthJ1/kYCzaPxUs/K2VFwA3hLvnMqSSzrwZ1ULTzZDyJvfNOuxw1gsWwou87XhDZ1/8L4iHesK9slLVkDTqzvufpINivGNbb1VyLKKGSYp8Z58hmcaAmBkpjGqdAOvtSPNoihSmF3ztOjMt4lWl8Cugx3fxILh/+YLcNyPhus99RkqhwTIQz/6J5WyNrrjt+sbEbfXB0xAvpwDmCWnPAHHQGDWye2vWgmjQE4Rx+J0+T8rQOC0ROLq0k5chm8pm83YbaT7U7v99qhJrv8zLUQxoPk/cCMcsyUizdB6+vjJKsY0AfHtL3FztcpGG+BNzKyHIzVFnomREthvbCG0HAWK0HAYfgVWZRTnPQb8hXPbEIcgE7sqWgmCuTlb+oEOyAn0p7fSUGiEISHH8LahZF1v9YDc1Fr7ricIVcprYc+0ExDWawgVeVvMw+S83+/vQTwn5+3bg3G74OnHZ16sJVuRjpugrDv8lrlBsDhpk5ULmMf1wktWuhpWiORnagBOCfaMgFZVsJajh9AQJTz32pb6jGjRfyNrZE64iaZtd4qngOswNYBl2W3O4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(6916009)(6486002)(33716001)(86362001)(508600001)(6666004)(6512007)(9686003)(186003)(4326008)(8676002)(83380400001)(38100700002)(38350700002)(26005)(66476007)(2906002)(66556008)(66946007)(316002)(6506007)(5660300002)(53546011)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UisTCdCfzNMqxhdBxIFP00YOG2+ezaWdYkFgbFX1+/G9pqtIdXKG7JhnsUtL?=
 =?us-ascii?Q?Wrz9qF3cgbLdTj13iaEMvwzGV+3NOVUrjeIPo9Kw2qUtrVDzK5J1+fjoBOSD?=
 =?us-ascii?Q?fOTaheQw+fWJJ5aY+P/HGobDOdg5Zgv4U8VlaB6LhE3tDH4rWtBjHmCqbHQ4?=
 =?us-ascii?Q?ChCoyucZq7I1hjLQ0iJPxOTapb/kFV/2MgbsYvV72AbEy0cZ94vJshQ6Hi+s?=
 =?us-ascii?Q?nQOl589oBZpP7rlhmzIqLTRPrEDJD1yOaLRgGjnPveZJYbGYj3OmFn/z8bCj?=
 =?us-ascii?Q?behngF/BYQBJoY1wjTAmvsawlCGcqrOJ2UO+z3LusJCf4wQWKqA+vvHyS/Ed?=
 =?us-ascii?Q?xmTP0Egce9scpTsIe8LSbRUdDzJCVBJz5Oi9jmkMcS1PHBsneEoCUITGso8D?=
 =?us-ascii?Q?m8iz1fq+/Z1MFFKqpWMuYROj2KHUkuLs+xVttthEsjvli/A/SYhcCxX9HymL?=
 =?us-ascii?Q?D1jOQBTgupTmr8PmfogHtweJByRdutBgQUmUSl31G/WCIafiilYwwohWK82J?=
 =?us-ascii?Q?TmY9PqE4immKBLfPmMulSdjg0ewZxEij558ciP9UiWQQGDlekLrMFH1BnMdu?=
 =?us-ascii?Q?Ll86ap11PpcC6RXnrmAY1Ba7kBWVlkTtdz3lqUDyhO62wRBNZMVGQZjxLoin?=
 =?us-ascii?Q?88dolJU9RrIL/9vXrg67Fs5yKQD95LlDKRqS77DOExMnNrQQpz9mx04jKrdW?=
 =?us-ascii?Q?DytbQhy4LnWcnLAS/aqIbU28JIV9S4uUOstIaZctxYKer8kPUlhmgsOm9hU9?=
 =?us-ascii?Q?+avVSS4vwb5wsqgdkwJD4oxctirQLUho5gpltnMSCW4BttvNF/TY+fueU58b?=
 =?us-ascii?Q?NCMY0zCCwWxaRiB+MRVN0eBaWXMeU82fVLioeLt7eOpTgzpVO4RkevYo4a2s?=
 =?us-ascii?Q?yG3Zt7a7zoxbpwl47xE5udAZ9ev8rysxFdU7xFCCgHygy+2AdxkfK2NQ48X4?=
 =?us-ascii?Q?LjnBKXbl1gvN23QDzzs+Kd/A6MT/dgPlEYE88luwecKG7jhyprogWjkGGtUk?=
 =?us-ascii?Q?c4vnY06ClPJl9+t+gaB/o8+vR+Ps20IXqIM0NOFrSa3WGBOhuoPt0B3aGstv?=
 =?us-ascii?Q?Zf056C2G96JQCiTuvzr8pMdPf5QErzmE0OqWMrtpdq2zbm8F9VlvzWEzYyku?=
 =?us-ascii?Q?zoLAdmS/gQ5SJZYbCeWcFVPRnjyqxSwfOpI7RRt0FZFX/mrCE+QrtVa/3WOE?=
 =?us-ascii?Q?AOl1x5pgdjr0bldZN6qUBeq5p/HLVcnebASE+njlIKEtaQFMHlXagZyWnaZx?=
 =?us-ascii?Q?C2vex+Mrn3b007C7msn3s72jI5XEQ2uZ7r/YEDDVzkObX7f+EOi2PuWVRvaJ?=
 =?us-ascii?Q?W4Rxq5zaTWVqsIwggjrb4HoVFhuYOgoLjVaCyarOjxmXCSCXTRFNqVYUspvV?=
 =?us-ascii?Q?xT7WWSA2KmsSJHdzw1vTcW1vBSB5jSzLAFSGGWG0QsxTMprosKwT0Trgqv6P?=
 =?us-ascii?Q?E4pqaXlz8u7nf/BWXdN7M8iOZTkAPCZ54k7ffLOccjY8RrNYhnqmxzLn8/oi?=
 =?us-ascii?Q?YcWcRmnlAjcZgQADGuC2dfprOZaTkvzY60M3/eNj4xPk277n5Yoq07T84NEI?=
 =?us-ascii?Q?F0qv5hiwUiK+GfIL2uL7WQxtvR68XykS1tTzHf3oEevnvxom79RpP2jEakMP?=
 =?us-ascii?Q?RDb6BqnzEzDCFV4/mVwHwuk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d04035-8a02-4ea4-a661-08d9f82c53ea
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 06:59:12.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HW+KXs9LU9lSDYgfUdzWO7GDQMar5RmkFroguKO2PXIz5dzfywoHIFCX7c5A0XKgPGl/rGCe2PVOC/syn74vfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4380
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250035
X-Proofpoint-GUID: rr1c7sMK68x7Z49EbzR7VHXsXCP_cMJg
X-Proofpoint-ORIG-GUID: rr1c7sMK68x7Z49EbzR7VHXsXCP_cMJg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Feb 2022 at 10:40, Darrick J. Wong wrote:
> On Thu, Feb 24, 2022 at 06:32:09PM +0530, Chandan Babu R wrote:
>> The following changes are made to enable userspace to obtain 64-bit extent
>> counters,
>> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
>> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>>    it is capable of receiving 64-bit extent counters.
>> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>>  fs/xfs/xfs_ioctl.c     |  3 +++
>>  fs/xfs/xfs_itable.c    | 30 ++++++++++++++++++++++++++++--
>>  fs/xfs/xfs_itable.h    |  6 ++++--
>>  fs/xfs/xfs_iwalk.h     |  2 +-
>>  5 files changed, 52 insertions(+), 9 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2204d49d0c3a..31ccbff2f16c 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -378,7 +378,7 @@ struct xfs_bulkstat {
>>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>>  
>>  	uint32_t	bs_nlink;	/* number of links		*/
>> -	uint32_t	bs_extents;	/* number of extents		*/
>> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>>  	uint16_t	bs_version;	/* structure version		*/
>>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
>> @@ -387,8 +387,9 @@ struct xfs_bulkstat {
>>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>>  	uint16_t	bs_mode;	/* type and mode		*/
>>  	uint16_t	bs_pad2;	/* zeroed			*/
>> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>>  
>> -	uint64_t	bs_pad[7];	/* zeroed			*/
>> +	uint64_t	bs_pad[6];	/* zeroed			*/
>>  };
>>  
>>  #define XFS_BULKSTAT_VERSION_V1	(1)
>> @@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
>>   */
>>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>>  
>> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
>> -				 XFS_BULK_IREQ_SPECIAL)
>> +/*
>> + * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
>> + * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
>> + * xfs_bulkstat->bs_extents for returning data fork extent count and set
>> + * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
>> + * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
>> + * XFS_MAX_EXTCNT_DATA_FORK_OLD.
>> + */
>> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
>> +
>> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>> +				 XFS_BULK_IREQ_SPECIAL | \
>> +				 XFS_BULK_IREQ_NREXT64)
>>  
>>  /* Operate on the root directory inode. */
>>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 2515fe8299e1..22947c5ffd34 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
>>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
>>  		return -ECANCELED;
>>  
>> +	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
>> +		breq->flags |= XFS_IBULK_NREXT64;
>> +
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index c08c79d9e311..11e5245756f7 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -20,6 +20,7 @@
>>  #include "xfs_icache.h"
>>  #include "xfs_health.h"
>>  #include "xfs_trans.h"
>> +#include "xfs_errortag.h"
>>  
>>  /*
>>   * Bulk Stat
>> @@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
>>  	struct xfs_inode	*ip;		/* incore inode pointer */
>>  	struct inode		*inode;
>>  	struct xfs_bulkstat	*buf = bc->buf;
>> +	xfs_extnum_t		nextents;
>>  	int			error = -EINVAL;
>>  
>>  	if (xfs_internal_inum(mp, ino))
>> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>>  
>>  	buf->bs_xflags = xfs_ip2xflags(ip);
>>  	buf->bs_extsize_blks = ip->i_extsize;
>> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>> +
>> +	nextents = xfs_ifork_nextents(&ip->i_df);
>> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
>> +		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
>
> Nit: space between type ^^^^^ and variable name.
>

I will fix this.

>> +
>> +		if (unlikely(XFS_TEST_ERROR(false, mp,
>> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
>> +			max_nextents = 10;
>> +
>> +		if (nextents > max_nextents) {
>> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>> +			xfs_irele(ip);
>> +			error = -EOVERFLOW;
>> +			goto out;
>> +		}
>> +
>> +		buf->bs_extents = nextents;
>> +	} else {
>> +		buf->bs_extents64 = nextents;
>> +	}
>> +
>>  	xfs_bulkstat_health(ip, buf);
>>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
>> @@ -256,6 +278,7 @@ xfs_bulkstat(
>>  		.breq		= breq,
>>  	};
>>  	struct xfs_trans	*tp;
>> +	unsigned int		iwalk_flags = 0;
>>  	int			error;
>>  
>>  	if (breq->mnt_userns != &init_user_ns) {
>> @@ -279,7 +302,10 @@ xfs_bulkstat(
>>  	if (error)
>>  		goto out;
>>  
>> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
>> +	if (breq->flags & XFS_IBULK_SAME_AG)
>> +		iwalk_flags |= XFS_IWALK_SAME_AG;
>> +
>> +	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
>>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>>  	xfs_trans_cancel(tp);
>>  out:
>> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
>> index 7078d10c9b12..2cb5611c873e 100644
>> --- a/fs/xfs/xfs_itable.h
>> +++ b/fs/xfs/xfs_itable.h
>> @@ -13,11 +13,13 @@ struct xfs_ibulk {
>>  	xfs_ino_t		startino; /* start with this inode */
>>  	unsigned int		icount;   /* number of elements in ubuffer */
>>  	unsigned int		ocount;   /* number of records returned */
>> -	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
>> +	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */
>
> I wonder if this could have been left an unsigned int and the flags
> below assigned adjacent bits instead of widening the field...
>

Yes, this should be unsigned int because ...

>>  };
>>  
>>  /* Only iterate within the same AG as startino */
>> -#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>> +#define XFS_IBULK_SAME_AG	(1ULL << 0)
>> +
>> +#define XFS_IBULK_NREXT64	(1ULL << 32)
>
> ...but was your purpose here to make it really obvious that we've
> separated IWALK and IBULK?
>

... Sorry, I should have fixed this when I had removed the tight integration
with IWALK. This should have been defined as,

#define XFS_IBULK_NREXT64	(1ULL << 1)

I will fix this up as well.

>>  /*
>>   * Advance the user buffer pointer by one record of the given size.  If the
>> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
>> index 37a795f03267..3a68766fd909 100644
>> --- a/fs/xfs/xfs_iwalk.h
>> +++ b/fs/xfs/xfs_iwalk.h
>> @@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>>  		unsigned int inode_records, bool poll, void *data);
>>  
>>  /* Only iterate inodes within the same AG as @startino. */
>> -#define XFS_IWALK_SAME_AG	(0x1)
>> +#define XFS_IWALK_SAME_AG	(1 << 0)
>>  
>>  #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>>  
>> -- 
>> 2.30.2
>> 

-- 
chandan
