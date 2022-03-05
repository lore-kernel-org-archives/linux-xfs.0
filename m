Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18260C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Mar 2022 12:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiCEMqD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Mar 2022 07:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCEMqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Mar 2022 07:46:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEE41CC7FD
        for <linux-xfs@vger.kernel.org>; Sat,  5 Mar 2022 04:45:12 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 225A9XDJ028756;
        Sat, 5 Mar 2022 12:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NMAii8QrV6ts2d/+xwOCc286UUVicF3nycxQRrSVBDs=;
 b=mvL+xeliprsfV0hkGJLZA4bYKVMQpM44UvsW5PAZJdp/nSV3OH1+kHvDmXO7knq+QiH4
 cunTsOX8rqehlwCZa8ajnJU2LYT2KS8hfiCeYc5FibcjtOoSneu4qT4Cli0WTn+hNTFV
 e1FIUFxehjf2IKQ1UEmVnRYwCZOOg0ybFDfexStGcnrVO/2KrmEaupuDVaJABdIIcvM6
 FHARyPJ2WXkFrie0Sr+J5fgqWTKrTftjBByGYoasZbz2lEyCly/Zn/aRbVDcqISOpGSX
 YgZQWt2DkgPg+VYFzssKJPGvm8MmRO84SKU/Z1L9liBpbpWkbutpxgCpDfGQe1jhoQW9 zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfs8n6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 225CadRQ137049;
        Sat, 5 Mar 2022 12:45:08 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by userp3020.oracle.com with ESMTP id 3em1afssw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 05 Mar 2022 12:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ppv8cGdUvFjtdFwivw7n5HLxlo5sucrOQutpXP4192YgkCRagikHC0tbCyYTbzu1vzKgrhpc8r6vIy7faLg5I/WF0yaQdEe6LFbSiJdQ1TFnuPL8KWFFUSC02XE8aEB/nHfSkYq3393oLD2o23+3IieCVFMiO3KFHP+MQ3KN1o/tWUPJsW/wgUpv7Kj1cu/809lZ10HoWeBbh/96PzQovAS0r+tRXBLB1Z3mDvKy7Xv9HfufZLGavjgdDfcryH1TPc3tgVe5lfEFn466AkoZcvbCmVc9+ght4mMbT3MI7bgtk0G2pH+WzBW7Zkiv2XLtw5QifhBND6nPjPliU+NVLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NMAii8QrV6ts2d/+xwOCc286UUVicF3nycxQRrSVBDs=;
 b=fU90+4P+dkFAVaJdAP/k5FhifnqFTKxu06ow5xEJYADutuGRlaIDtiY/mlbtbz5IlsyLVLTqLqe6LmU/HL8ho5qDxycu3n+2n7hghiBJ1FiDB9bzjLp4/xlJ/3mE7CPkmTLQY8ZrCz0/EhqUwlupCCV/7ddOu6OKQmWD4DLNNEQcKdZd0tBb5H3GZH3X9fxzfU3BlrsfmMUsU7xD4sXZPpHIg10BmbuUzxHVXUlh203rRLaq+++WeR7U+1dXiuG4ebVQuGyUU6Kse03R7uKhQUSzAKLOG9AFZ19DYFzSqrJvl7LKwQ3HDHsEAC+Oc7TpB1GFwN0YMefs/e3HyNDWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMAii8QrV6ts2d/+xwOCc286UUVicF3nycxQRrSVBDs=;
 b=x8afb02mMYI6dHE++VkDaezJbJxT1soMpx0Ew3QJ9ADad9Lc9nSDRM1B9jKSfTpmalt3anzYU3SSpGM+rJLW7vbV4BkrPYy8VBnrk5S4JyyZYkFzY1m7qcVJCesE5JvSPRxGHXjMtdGOjy4sWUWqnL2e2XIiLz60ywUM2/q4+KM=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB2821.namprd10.prod.outlook.com (2603:10b6:a03:85::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Sat, 5 Mar
 2022 12:45:05 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%7]) with mapi id 15.20.5038.019; Sat, 5 Mar 2022
 12:45:05 +0000
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-14-chandan.babu@oracle.com>
 <20220304072524.GI59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode
 explicitly rather than through iop_committing()
In-reply-to: <20220304072524.GI59715@dread.disaster.area>
Message-ID: <87lexolgaf.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 05 Mar 2022 18:14:56 +0530
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f22f1f42-aea4-46b9-d4b3-08d9fea5f90d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2821:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2821F6927B0BCF83C091B0D3F6069@BYAPR10MB2821.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1NXKqBW1EV5bHTfHoVCwCJKQ0RaH0WQ7CU59/mkB9yKljMhgJj+6ovwS9gMzoG+BmI+y7BAdnGYXQ9FjVNfEqyhWhh1QrGrHDMpk/awIhuxk/h+uFqU454+F7iiW9DMnQvWqy1xB46JtgFeXbEXCksUwDk2O29+wpsmqLMS6J0O+YsTNzeKcEuAnjdRQ9UtnUfVri2cqatKSXXLiOiNiCCKlHKk2Fhnfg82lvXVp1msdf7GdsKe5mlUp91NvlOSePOwMaj2lZYa9Rn5hWQ5sAYW9J1enzP3iStOWd4trF1CcGbh1hHDCk+/+pvQEVRE4nOX20opPmtfC/KKMx2J4FBGOIweu9XL+IziKHPNXtfPNBmEGka2kbutruAf6zJSzAJ0jQYih04wh5cUJ935RAYqOMa402Nz5J2yc1Vk4OxIkHSBVgEPtIEvGSDqPPzTyCE58myqFRHVlZmb5bYI9jhV9n/Byb5nHJeQXXQMAtUl1IbAy3iZOXgk1ZE4XFCN89+2/bz4EQOl4ETZmySdEQshRuC1SwONtTDtBawYZmkMr/zq7oHc31nl/a7MV05X9AN30x1HpDhqUu9SBc5hbyN796rAGaaaaG5wRzt4Fxwwm6oYA9VY4oqMC9QU9BhbL7ofGm93VsYkw+6kOXJPfv7sujjwwjkCKwb3FYSuqe3uYMVx7cTJnNXpX1gZ5lrxwWpaJwsRpUrhvV95wbCMOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(83380400001)(26005)(2906002)(66556008)(86362001)(6486002)(186003)(316002)(66946007)(6916009)(33716001)(53546011)(5660300002)(6512007)(6506007)(52116002)(8676002)(66476007)(4326008)(38100700002)(38350700002)(6666004)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1KtAf/4/BfwkeDWfxzcA1f6qs3cotx/F4YhQnYZGp03Md5Nvpsdq1RBDl5eg?=
 =?us-ascii?Q?EDb1HhChuzLvVloPytxEhAEwDXBFIVJViaufxKvPsMT/kklZQ06ozvVVKZAc?=
 =?us-ascii?Q?vvonItm2xwAfgPyXg0W8QK8/ateFpdFms5K2I5GERZbIGq8m0+k9FMPgQ2Tb?=
 =?us-ascii?Q?sVmYZ0K06e7nFEGop0+LY3fOSKmFCmwJJwNfeWvzB3g3/l36G5SUvQX/TxyU?=
 =?us-ascii?Q?GKBgNa2ZaEpsbqKTFRAskk/MxaaSouIUqLlx9jpVZVZIvvUSJQYnaRes8m/L?=
 =?us-ascii?Q?0CaSbGgklLMHXydgsEq5LxMg0/t5LWSoQleUFhE3geG9nwd7/MsA8f+OqNLd?=
 =?us-ascii?Q?+tEOKUEHl9eNdmSnW+inM3GPxZqJYZeAxCsTFOcPufsMEFfVb2/OYfhfSBx+?=
 =?us-ascii?Q?NZ2QaJLov+FRTwWrJvAz5NOWsdUB9xJ+bz9lDwBPekJKl5FJhvpjwZxQ2err?=
 =?us-ascii?Q?LHs+u9WGKOVHKchFZzIR0StCWf51QMLTscbePEnoNpKLoitehf3sBcECrcrK?=
 =?us-ascii?Q?4KnhNx1c5131PcjaldNowHRg2uhmkjq8lMEGC/Idblo4oLPfDkSuoiEcn7oB?=
 =?us-ascii?Q?CbaRgxqmaZ7euTBl8ArrS3kGqNLDiQv8ufa1aWCAlNVG6HIZegLi8pZpvGHO?=
 =?us-ascii?Q?A6/ra6S56+Sy/MXfSRUAEFVBOTN1hTh8YDG+TwqyhJSgN5oWFAkhFc2cWFZ3?=
 =?us-ascii?Q?cihpCewUl2kw0aVCAUs0mzdwYRNCEp4RKDafYw41hPzStT3PpjplUvkO+Uh/?=
 =?us-ascii?Q?CEH+8MHpbGbJAkXG6BJsURy5Kz1Vq2mQtMhu6WkWtQHZxz7wfLzJLtOiRFCb?=
 =?us-ascii?Q?z9V6EWjHaaso8QK3LUxzsVofgRfdRLHVt88RF4jZ363auQ/Sp64U76snYO8U?=
 =?us-ascii?Q?dYs6DDfwi+t2VY1Cknm9EUqN1hWmJsOZQZ7xnjAYHnOrPX5LO7iasQ8u+ah+?=
 =?us-ascii?Q?tXkWxNNS4PxFnoKRjRFFGKGs95ENGSWBvjVKUFWJq6Kr13cNtuOiRvofIZA0?=
 =?us-ascii?Q?wGtIVvlD13/qKlqHm265GtJ0w5AdQapkTFvNkklXd9bxeF0FVVRmxdFS42Op?=
 =?us-ascii?Q?KHVpai+5R83LRvEDDHwgcuUWhtX1JO4jH3wnJETR5rIOz1Tz2Tfhc6GFIIP6?=
 =?us-ascii?Q?MURMTD1RHYmzBXRQ1r9C9aiuNNQhJbOl3F9opuX3YsiJKa4L89FiQswbWcVz?=
 =?us-ascii?Q?RR7WLKhdyqGGMhF9IqhB0po94VsgXtkDh2b8G8e+pI7PTrR6zbKYXRdJjv0O?=
 =?us-ascii?Q?tR+f7+Wy0LfOXsNub4qt2KT9F8Xk4wC+XokGrHEGFtA0gI3B1jMABpqiLi45?=
 =?us-ascii?Q?uCbE2tYlw+z9eHZ1kr8VcfszUTtS0Ke9T1yaYpJkcSn6A+tGxSxbIv9j88oV?=
 =?us-ascii?Q?sfyAeNhnqRNf8VkACCqdCZ6ExEazi1yYuOd4gK7RI7U5rbj5EtS2Ev5WYm/0?=
 =?us-ascii?Q?/QC8lUjAszF0ab8GK7vVeChPcVqEEgZejQYOfpFxEnDQrrF70m1z0xzZ6DhZ?=
 =?us-ascii?Q?X9nM0TOgtC39YYS7lZc+jZvN7uRSYrA9Ww8DfEZtwHTpwjmEmH13XLR5OsCq?=
 =?us-ascii?Q?cQHC+SPXmfizkm2cp/E87K7H9RdzzIEniQHS0HYKeSejHXdBiwlisDIHFAkR?=
 =?us-ascii?Q?c0NWi3wo/6+4Ik5mKfTokPA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22f1f42-aea4-46b9-d4b3-08d9fea5f90d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 12:45:05.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9fXePcAOycflp78HnElxytJn/YQX177vZ6LR0nAmmE9XpOo7wHaGFTmsi5J/mQ6kehoSdC13cf+QQScp8lo2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2821
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10276 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203050070
X-Proofpoint-GUID: l6poDaUB07fKKZbzOgPYf-605xDAdY1C
X-Proofpoint-ORIG-GUID: l6poDaUB07fKKZbzOgPYf-605xDAdY1C
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Mar 2022 at 12:55, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:34PM +0530, Chandan Babu R wrote:
>> In order to be able to upgrade inodes to XFS_DIFLAG2_NREXT64, a future commit
>> will perform such an upgrade in a transaction context. This requires the
>> transaction to be rolled once. Hence inodes which have been added to the
>> tranasction (via xfs_trans_ijoin()) with non-zero value for lock_flags
>> argument would cause the inode to be unlocked when the transaction is rolled.
>> 
>> To prevent this from happening in the case of realtime bitmap/summary inodes,
>> this commit now unlocks the inode explictly rather than through
>> iop_committing() call back.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/xfs_rtalloc.c | 11 +++++++++--
>>  1 file changed, 9 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
>> index b8c79ee791af..a70140b35e8b 100644
>> --- a/fs/xfs/xfs_rtalloc.c
>> +++ b/fs/xfs/xfs_rtalloc.c
>> @@ -780,6 +780,7 @@ xfs_growfs_rt_alloc(
>>  	int			resblks;	/* space reservation */
>>  	enum xfs_blft		buf_type;
>>  	struct xfs_trans	*tp;
>> +	bool			unlock_inode;
>>  
>>  	if (ip == mp->m_rsumip)
>>  		buf_type = XFS_BLFT_RTSUMMARY_BUF;
>> @@ -802,7 +803,8 @@ xfs_growfs_rt_alloc(
>>  		 * Lock the inode.
>>  		 */
>>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>> +		xfs_trans_ijoin(tp, ip, 0);
>> +		unlock_inode = true;
>>  
>>  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>>  				XFS_IEXT_ADD_NOSPLIT_CNT);
>> @@ -823,8 +825,11 @@ xfs_growfs_rt_alloc(
>>  		 * Free any blocks freed up in the transaction, then commit.
>>  		 */
>>  		error = xfs_trans_commit(tp);
>> -		if (error)
>> +                unlock_inode = false;
>> +                xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +                if (error)
>>  			return error;
>> +
>
> whitespace damage.
>
>>  		/*
>>  		 * Now we need to clear the allocated blocks.
>>  		 * Do this one block per transaction, to keep it simple.
>> @@ -874,6 +879,8 @@ xfs_growfs_rt_alloc(
>>  
>>  out_trans_cancel:
>>  	xfs_trans_cancel(tp);
>> +	if (unlock_inode)
>> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>  	return error;
>
> That's kinda messy, IMO. If you create a new error stack like:
>
> out_trans_cancel:
> 	xfs_trans_cancel(tp);
> 	return error;
>
> out_cancel_unlock:
> 	xfs_trans_cancel(tp);
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return error;
>
> Then you can get rid of the unlock_inode variable and just change
> the if (error) goto ... jumps in the appropriate places where
> unlock on cancel is needed. That seems much cleaner and easier to
> verify.

The above suggestion is correct. I will include this change in the next
version.

-- 
chandan
