Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE92FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 03:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343685AbiDLDls (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 23:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbiDLDlr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 23:41:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFF4165B3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 20:39:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1uPO6022836;
        Tue, 12 Apr 2022 03:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iKnUSqkxr+eipCFCEnCSpwJ5x2XWr9J5+/ZpZpse+XU=;
 b=UjMDH1oBZrS4VzF3OwPuzfLskIfsGjNNY1D0KdIz5KpBN2uI1QGZUwbTcLTX99/sFtt0
 mizkmQNoqRxLWg2fPSXdM3awbsPtEN/S+6JdKHPBDemvxI20yxjtOCqh0DRcsbbxnz9I
 UlEwvBXSL2s2Kgt4ywuxaVdknLCyyomgBK1AsHdZD11hQKAJC485qbWZbM8VAYS+n/st
 2MDoR3eLxLmy0B4/Kb7nBjHBHq/bBC6lwNgQUVy8OIc75spskIj4UvbB51nbYI7MFl0S
 1FLoDKEF6fMJz4cTbMGquiDHaPfk0P1ZhJAnBInlNlk91YJW7cPjnB6ZWRhtnKR6pNBq Sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd5cpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 03:39:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C3bLfP027804;
        Tue, 12 Apr 2022 03:39:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k2atqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 03:39:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFjioAwrF/MgFp0rf9D+gaHhmnRT7FjM6/EY4rOL6Rsih+M4FHlF5wWr7tbg1Sps0dsPXuCfTkQYquDcSa/4w9/H84I1rvBLA1R+xhQZ1h9PRrKv3EqlO2kEZLFb+N10oyowEmCyvBLX/XELlt+KaFhwakjk0SQQNWp3UFGIld4xpTh3ISDBI4mu0ceOPpbCvDqkKyBI+EI3sqJ/CsO9JlXIJNnShz3BQSiJ8eQ50AOVQJHME72aLJIApaO+T5RvebOM7qyJg/dlmqVBu4EuZxmR2bVjBReVIFdENkIrW8r9j5KCo071lIdQYgKpr/1BvSwuUGaRhLeRR0UmmEENbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKnUSqkxr+eipCFCEnCSpwJ5x2XWr9J5+/ZpZpse+XU=;
 b=Yn38YsTxbgL5F8bds7C8nC2d4QUbH33GwvrJBDlrsSg1VlnOKQMiZhqh2vaLppngy69RhWxD23ZstAYNJcAysgZoOYRrARe/Lys/todX3aNd3qughh8tBQTahtprybI/4Q/eGqa+DEvEKAletYgolXRnbiwkZCuvGzsDdDRx/UxLuETrs4yhd9xWwQ73xaPgxzd5+eC2TQyVI+WlSRJqHlE1IZYkL/3seuxfWa06VLTCZs+cn9BrSZoVhm4sZFD9mvcFtK5jYSVBUej+q6eKqNIGS2nP3n8BblD6qhMdc5zOL6QmQDdMtugcgpxDT6wWzv3S0IQVa+DXVEEuLQ2l2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKnUSqkxr+eipCFCEnCSpwJ5x2XWr9J5+/ZpZpse+XU=;
 b=kLTIRXKLvfqn6EpGlh5kXjWpBjdy2/AEnJrMJ5tyPkWxAOZViIQzWGVPGo1KDcbS6dXez4Izf+2c1CI/xqiAaXAuMJ9z6b3WdC83zAxMBP2zd2Ri/V0FLbxcmLzbz6jE+EtqcpNagdXJCPsReJ4PSScMKFBA+gkofa1vFiEy8eI=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by DM6PR10MB3914.namprd10.prod.outlook.com (2603:10b6:5:1d5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 03:39:21 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::c95c:3552:3b30:30ee%6]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 03:39:21 +0000
References: <20220406061904.595597-16-chandan.babu@oracle.com>
 <20220409134721.471501-1-chandan.babu@oracle.com>
 <20220411220752.GA16824@magnolia>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9.1] xfs: Directory's data fork extent counter can
 never overflow
In-reply-to: <20220411220752.GA16824@magnolia>
Message-ID: <87o8170y3k.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 12 Apr 2022 09:09:11 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0011.apcprd03.prod.outlook.com
 (2603:1096:404:14::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f749c96-30dd-4432-8d73-08da1c3607ba
X-MS-TrafficTypeDiagnostic: DM6PR10MB3914:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB39149F80366788ED07F076D5F6ED9@DM6PR10MB3914.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aj0hj+6pscl78q9WqIG5rmQpxUMnrvOCfjyQy9N8aLXfXnWkGIfjCzIHlFPLwFIPC71msL8KJ+xqN0lHKNczFQOgAuOtsG1NrhOR0pw9bvcXirO2G9m7X3O7flAFruTVB1AkES/U1O4X8MQ9Q49JTxJTRpTyJ1CSUsfhHOUUam/CGvnipY6BeScYXftiI73xwH9K6kM5zF9KoFlDz+Xj/RCC7rHmwecBYKNXphokj2i1AaNWrzHaYdF1MU+nt647zSWUBdxAOR82kmcJXjUWc+sYtkpeuqP7P1rSoORIhFgqG/GB2r0j9Jt7hq2XBsNj5typuxHZOgPlUYUsAiHfBQbyTpwDYqNZUyMs/QNJuSOyJMq91gnkITaC7OAVIyxAqdbua0Uh7Jv3c1OXKcQEfyzwgygau4BiC05BXctzI3UyenAjQL1MIbciZsWNPipX2xKCgAhXsqAJBQ2pRBqrTG4hqvSPeMvjDmwaAYg1SokKphbajTbq6J6hmuh/aA18wc3ZlNDfD1HxCkVmM/k7Jb5O0yxp9wkDUyy0eiepOIUTdM/B3B9ABYcXsSKB7N0XJMOKDXxYr6zflBRQzUsuYr4RSxdj17DvZx+CR2ATV0TrB/XtVY8ZZ0oD+eESCtiatwqNSnwlQbz2DmBZB7YGZSbaN5Gg/BvN7phmneYxkBUBrwe4of+8O7tKLz4uGciU5sewfuMRfaAo7u6VEZZsXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(38100700002)(4326008)(8936002)(5660300002)(186003)(26005)(508600001)(2906002)(33716001)(316002)(8676002)(83380400001)(6916009)(86362001)(66946007)(66556008)(66476007)(6512007)(6506007)(53546011)(9686003)(6666004)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f0abix8259JPQP6jRKB5DH5sqT2ca7kqImLFbGWLiIttRy2Wt28dTFwOKJ9Z?=
 =?us-ascii?Q?BS7aSKOGExzp9pE3P/vNMLy+e8OA62VuaTDiYeT685h10xGfKAhua2gN+bLf?=
 =?us-ascii?Q?dTZ309ba51kaYLXvzmjAnyQjJe48hXC7GxTYpdOrWW5RymMB8k6sBJirpsCt?=
 =?us-ascii?Q?uovb02l6LJp9itmaJQtSWujZ0ABLiDZg0bXiEMjGcxuRzZA/i5nY/L9Zhdlv?=
 =?us-ascii?Q?U/cGaiJ2KbEuGSsc/Zs+FUiPKj7KuYTE6d75xo3XbBriliwQc9lv+WATsxSN?=
 =?us-ascii?Q?SteWwEjHIn0JTHUKUHJcmhGgOOSi0zBZxXtP28VljtIIgDUqBqwhet735SQN?=
 =?us-ascii?Q?R5luKPYqEXWsvejFWmiyZM+d8SH33gOw8bV3HwhWB4aJqHdJBTyuF0qVekgj?=
 =?us-ascii?Q?jS3Qf9hWUmgFwG6pm1YixVmhUIhXc0/yax1fq3l/zyliul27eTqrjS0+s6hK?=
 =?us-ascii?Q?3GrSv4eusZhuh/ecxvGY1Dm8/DxshpB5PD6VIIVGkHUwUD7SnThRHK7lU3Zu?=
 =?us-ascii?Q?xlryhd4v9+G3JwYQMWFx4QSgbVrHL0rYsIzTGRslTsXVUw/PfYbZ8DhMFqIt?=
 =?us-ascii?Q?EGQrUCzcRrUbbhk5qnHgeloqAf6zWVjI4ZyLDy51tfXLRoyQm4pBUo8OWmA5?=
 =?us-ascii?Q?XsPoOm2AX5uNPMnbOjplkJbekuvq4mEiNVMpODaY0NCL9S/FHvQfcwEu5Fup?=
 =?us-ascii?Q?JVB5wzHcHLGyDh0uSg6LIIzwJ6T3fOLs38NGaSK/yYWR3Oz4mOQJVXr32GGE?=
 =?us-ascii?Q?25OxHJfcza39LSsFspx5mZuxu76U1v5UfKJVEnjdvpftS5d0DFYVAwbukhXE?=
 =?us-ascii?Q?GSM5gizSQGjgBR/d3CgG9wj2lr+GdlKxgv5dgMEsQJedaew44ayGAlb4ZyfI?=
 =?us-ascii?Q?dQempKccpAuCr2/NaCxsGj5vwPgGWzG1tfJZzqX+VcdORF5oKQ71LfjF1Gua?=
 =?us-ascii?Q?VrN6Ja4vEulvKzrusmei6hoXxvztfX7VylGQ3t9onBLI5Q2agGJ9RURPmyw0?=
 =?us-ascii?Q?2nAuswQsHDeYqorp3S29EjemNsrafHo2tPKERxUHNakPA4pTWGlI9l2cLakP?=
 =?us-ascii?Q?ya1hyeWSuXwJsPxoDM7j8QL6n4iCP1PL/1crTEDeKat2YgTPX5GXDlrkiUim?=
 =?us-ascii?Q?r5l2i2dA4DFp4BZSH+j0okFVEzE7CrTwu5umE/XLo9Y5qeEXlEB5H88a8hvc?=
 =?us-ascii?Q?FfF6nj2MaN9lpde5GD1SNVIvr0Ccklz8MzMQivJc5TphC6m2oKv57hv/8AHz?=
 =?us-ascii?Q?I3o4ZbnV1HS183pLVRqKLMhHKu3Wyv6ElZqtELdCl4F75FEkee9MyHHnVmmj?=
 =?us-ascii?Q?tC6rdrrsvw9twquvAKhPXlK0+/7QDEVlMw4JCoDCCmoXjVfAwIEWHYMvdYAo?=
 =?us-ascii?Q?dcA9etOd1vzVDZ0kdD65KubPAUBBPF1VWLJllBgp4mOcl3Xskjw7AyHB5Uqj?=
 =?us-ascii?Q?76ahjlFDn7bEPa8LJaYqKg3Uu+QglI4nlOBux0K3NPLV+IYt1fHNbHngGZm3?=
 =?us-ascii?Q?ovxnZXGGkW7BADy6orYF0fNRVv00S9lGO6JE8PIVb2vC/7oq4F9G+AK87Nm2?=
 =?us-ascii?Q?iv8spqt5mO1TOskU+au7ngEThXrPJw/IEwYV308rTtVy2Z0Vle+gCxPo4b7r?=
 =?us-ascii?Q?V/alZ8Kk7QpCY+Fvf4wa1VUr05LW6gqzAhc60aSX1J8OrP3RKDvd7FOT8WNP?=
 =?us-ascii?Q?ScFIwp3Q6nqE5KdK9tNU2707x+qYDVAImX5JRuwS59Cj/MLr/2phEcB9HzMU?=
 =?us-ascii?Q?OcDb3r0cBHBPHeNp4JqHKu0Q2yUOF4w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f749c96-30dd-4432-8d73-08da1c3607ba
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 03:39:21.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfIBpTm7HIm50DLuKYiiEGfLn0AWhLNA1zm/356CMmxGB3Wixf9FsViHZwX9cOHs2Ml9rIQPBcx/3R+d1RfeNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3914
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_09:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120013
X-Proofpoint-ORIG-GUID: CmOTMjqWLvpY8sninD00kukvQuMpz-T8
X-Proofpoint-GUID: CmOTMjqWLvpY8sninD00kukvQuMpz-T8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12 Apr 2022 at 03:37, Darrick J. Wong wrote:
> On Sat, Apr 09, 2022 at 07:17:21PM +0530, Chandan Babu R wrote:
>> The maximum file size that can be represented by the data fork extent counter
>> in the worst case occurs when all extents are 1 block in length and each block
>> is 1KB in size.
>> 
>> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
>> 1KB sized blocks, a file can reach upto,
>> (2^31) * 1KB = 2TB
>> 
>> This is much larger than the theoretical maximum size of a directory
>> i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
>> 
>> Since a directory's inode can never overflow its data fork extent counter,
>> this commit removes all the overflow checks associated with
>> it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
>> data fork is larger than 96GB.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c       | 20 -------------
>>  fs/xfs/libxfs/xfs_da_btree.h   |  1 +
>>  fs/xfs/libxfs/xfs_da_format.h  |  1 +
>>  fs/xfs/libxfs/xfs_dir2.c       |  2 ++
>>  fs/xfs/libxfs/xfs_format.h     | 13 ++++++++
>>  fs/xfs/libxfs/xfs_inode_buf.c  |  3 ++
>>  fs/xfs/libxfs/xfs_inode_fork.h | 13 --------
>>  fs/xfs/xfs_inode.c             | 55 ++--------------------------------
>>  fs/xfs/xfs_symlink.c           |  5 ----
>>  9 files changed, 22 insertions(+), 91 deletions(-)
>> 
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 1254d4d4821e..4fab0c92ab70 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -5147,26 +5147,6 @@ xfs_bmap_del_extent_real(
>>  		 * Deleting the middle of the extent.
>>  		 */
>>  
>> -		/*
>> -		 * For directories, -ENOSPC is returned since a directory entry
>> -		 * remove operation must not fail due to low extent count
>> -		 * availability. -ENOSPC will be handled by higher layers of XFS
>> -		 * by letting the corresponding empty Data/Free blocks to linger
>> -		 * until a future remove operation. Dabtree blocks would be
>> -		 * swapped with the last block in the leaf space and then the
>> -		 * new last block will be unmapped.
>> -		 *
>> -		 * The above logic also applies to the source directory entry of
>> -		 * a rename operation.
>> -		 */
>> -		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
>> -		if (error) {
>> -			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
>> -				whichfork == XFS_DATA_FORK);
>> -			error = -ENOSPC;
>> -			goto done;
>> -		}
>> -
>>  		old = got;
>>  
>>  		got.br_blockcount = del->br_startoff - got.br_startoff;
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index 0faf7d9ac241..7f08f6de48bf 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -30,6 +30,7 @@ struct xfs_da_geometry {
>>  	unsigned int	free_hdr_size;	/* dir2 free header size */
>>  	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
>>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
>> +	xfs_extnum_t	max_extents;	/* Max. extents in corresponding fork */
>>  
>>  	xfs_dir2_data_aoff_t data_first_offset;
>>  	size_t		data_entry_offset;
>> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
>> index 5a49caa5c9df..95354b7ab7f5 100644
>> --- a/fs/xfs/libxfs/xfs_da_format.h
>> +++ b/fs/xfs/libxfs/xfs_da_format.h
>> @@ -277,6 +277,7 @@ xfs_dir2_sf_firstentry(struct xfs_dir2_sf_hdr *hdr)
>>   * Directory address space divided into sections,
>>   * spaces separated by 32GB.
>>   */
>> +#define	XFS_DIR2_MAX_SPACES	3
>>  #define	XFS_DIR2_SPACE_SIZE	(1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
>>  #define	XFS_DIR2_DATA_SPACE	0
>>  #define	XFS_DIR2_DATA_OFFSET	(XFS_DIR2_DATA_SPACE * XFS_DIR2_SPACE_SIZE)
>> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
>> index 5f1e4799e8fa..52c764ecc015 100644
>> --- a/fs/xfs/libxfs/xfs_dir2.c
>> +++ b/fs/xfs/libxfs/xfs_dir2.c
>> @@ -150,6 +150,8 @@ xfs_da_mount(
>>  	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
>>  	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>>  				(uint)sizeof(xfs_da_node_entry_t);
>> +	dageo->max_extents = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
>> +					mp->m_sb.sb_blocklog;
>>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>>  
>>  	/* set up attribute geometry - single fsb only */
>
> Shouldn't we set up mp->m_attr_geo.max_extents too?  Even if all we do
> is set it to XFS_MAX_EXTCNT_ATTR_FORK_{SMALL,LARGE}?  I get that nothing
> will use it anywhere, but we shouldn't leave uninitialized geometry
> structure variables around.
>

I had left it to be initialized to the value of zero as an indicator that the
field has an invalid value. But I think your suggestion is indeed correct
since we can assign the field with either XFS_MAX_EXTCNT_ATTR_FORK_SMALL or
XFS_MAX_EXTCNT_ATTR_FORK_LARGE. I will post a v9.2 patch soon.

-- 
chandan
