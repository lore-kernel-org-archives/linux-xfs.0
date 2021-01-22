Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAADC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF4223884
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Jan 2021 03:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhAVDRy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 22:17:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43990 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbhAVDRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 22:17:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M39bFi008925;
        Fri, 22 Jan 2021 03:17:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=V64M0wB4BE/SLhQVQZ3snrpqw3r/aI66wNu3ySGatIY=;
 b=nmHoa06551hhh1vUXSGxg5hGEZjp8Em+3Sgu5VKdTN8o+tlZPh/OniRJ7Uzp/kQKBnBs
 T7Bw28fJNQTDbopUS7Uvd/TcAQSXV3TB00ajoWXfW/5xxQ3Yr29lfKYpRTS5h0O5Mc0M
 EcCAoPqLzYZf9a6DOOa9tpCPYhpUE+uSyedI6nj2Vk7wdp4Qe0FF2PsqAEcbz9tS6wO2
 Nk8cOLTFdSMjBf1Ny/5ib/9hn+kTUtbDpt6xj5tS/l//YWHGkyS4Ho0Iy5b0fy2tD+l4
 jJY+b4zeYMYkx6ScSixPyZbLh+YOFmfiAJ12t/qrXr11NzT5bw4koKkZgwt4d9AMxbjm qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3668qaj7m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:17:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M3Amm6055958;
        Fri, 22 Jan 2021 03:17:01 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2056.outbound.protection.outlook.com [104.47.37.56])
        by aserp3030.oracle.com with ESMTP id 3668qy3wtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 03:17:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERM0pQLr+/7zn19ci551qM14Pj9q2+oBxOJhLkp6qaxVg8PCtyaQIMKBvCnmORjSHUF/akYB4nFUTQPiKvr/h1wLe4lE6vbdIW121gsGA6rxLfFDTHvsfb8OSvIl2Vhh5w7Aj3W/1DEorvzS1TOVRPGA3txWq47s/XZFRpAy2prUnFbBXTDYRMfF4RC2PN2kilPDE6rj2Rk6dIloYo8lIsnQUzHmsRRYANv6v6fO0azUlzodJOVka2QqRFrSFikfPo/W9TGoPbZNPYq7bdXwSfikRV7rnnoj3yV8cRLnFv2UlSmVV00GjPHSNECiLbQQivCG9g8YE9IQ6HjMKFV7ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V64M0wB4BE/SLhQVQZ3snrpqw3r/aI66wNu3ySGatIY=;
 b=PCGPchSJE9aIIYqyKjSSk/QnJPWR87HgeSU3kwDxXqso2zL70x+PdjwaJJR4sXEJnPMSR8/ppc4VEUGFA24GqLvv47zjUqA/bojtoGV6boToU0jTSebMwhOS2CXjY84+Z+pZ5d1Rknu5wAOvbYikWwIvZ6OrG+gQCE+3zTfQMJCCXiz0Xg+GKFs+YT0nxsg7frl/ksxQmx2k/tyttnmpVMiReP/MBuJk5fJHkHBdMe6If8uWq5qwPzMNXywNKVZoJDWlbjtXe6C+8nzvECFiex7OyfuzFhjSdI7Mttzj3RlTpFYSTqy2IwoNlDneMldTmujCsPU8wfW39wHvxGO6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V64M0wB4BE/SLhQVQZ3snrpqw3r/aI66wNu3ySGatIY=;
 b=qYyQX4gqNKdik9l3XVbER2O7y+3dUqYZ51rucmRJM8FCxKzMg8dlqZTQqYoTOPM/4YZfbaOxxyzBB7L9MbPVVuWSdnndGXszPvD/sAXy2z8BQAixQfhSnvCmoaRlQen+yJgYj7Qru1EEdZmLDjrn9iGhJNfbaVvJ6NefdbZtEBI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3110.namprd10.prod.outlook.com (2603:10b6:a03:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Fri, 22 Jan
 2021 03:16:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::9105:a68f:48fc:5d09%6]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 03:16:59 +0000
Subject: Re: [PATCH v2 4/9] xfs: cover the log during log quiesce
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210121154526.1852176-1-bfoster@redhat.com>
 <20210121154526.1852176-5-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <84fe695b-bd08-cdee-3bce-1d0ab3d07aec@oracle.com>
Date:   Thu, 21 Jan 2021 20:16:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210121154526.1852176-5-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.214.41]
X-ClientProxiedBy: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.214.41) by BYAPR03CA0001.namprd03.prod.outlook.com (2603:10b6:a02:a8::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Fri, 22 Jan 2021 03:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feb42aad-83ff-4c6e-34cd-08d8be842e1b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3110:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3110F42DA50D4E2BD143EBB495A00@BYAPR10MB3110.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:318;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cRE8dem6pGeEeSsmp4jvJ0GcuFkIASAX4cQTIvEuLsUD5GeSVzU88s9L6xDYHpyyKJox9thlG0QfPyR8AL8Aay13p7jES5yS2V9gqXwPCV5ClQGs4/4xgdhJsOgehhMCVagGtnzwhJMxPzYLZDBMu/Rj+rgBQfZmeDQXK8b7PcAEEKIEkDM3+aHA6UiJqaW3spWeGG+iJwK0RQwqZhJOfEtM6YUsikVx8bG2M7EHYWazvRo0AxfTtZ5pq6bsjjQSCHQ1hi/1v/VUuXIlr1ymTH45CowWF2jv+P4Ks9Fv4GWlfQ3EAynegpWM8SG8KycVrakwEDMdfMN0xc8TNEeDNTJ/jp1HJee/ZemGb0tvLGqypLhUwpAwYdzwy6T/QY8G4VzjdOT80Gl3JlkLRzHwGmauERfqC3ZJb8i6liJFBLijqFmK66t1sbPU8nr713hx0K9YGqNBGjJCjMi2C/i0+1uZiQ0HKLn5ThfjEUK0YTg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39860400002)(36756003)(478600001)(16526019)(186003)(52116002)(2906002)(956004)(16576012)(44832011)(83380400001)(66556008)(5660300002)(53546011)(31686004)(8676002)(316002)(2616005)(6486002)(31696002)(66476007)(8936002)(26005)(86362001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZDJ4UGppVlB4WERKRjE4OXRra0ZPWXBYaXlrajFMdHhRRzl6S0t5SDFMMTJr?=
 =?utf-8?B?RURXb2IyM01HSzNDZGEzSDk4VzdSMjBBSGg1emdqUmtHRzM5ZkpZZEYyZk81?=
 =?utf-8?B?RVpUNUxMQjRXSi9RcFg1Rmwremhqby84UnBoVURQMDlldWpvSzFMcUF4NXpC?=
 =?utf-8?B?Y0FlZ1pyeFhIb0wwZUZ2ZkVmN3ZpYlo3aVRIRXBxckVDQld6azd2UFl5NzFP?=
 =?utf-8?B?SlcwTDR1YUxaYkd6b3Y0clJMdVI1amJ1RW5ZUldpcEV4TVRmWXVMcVF3U3JX?=
 =?utf-8?B?MHNickJrMU0xTU1XbGpIUTdPa2p5bGtSYVpsemN6VGlXSkF0akJjUmM0RTY4?=
 =?utf-8?B?dVp2UGNNM3JJRHBYbmVqdUlKYmp2UnV4a1JXT09URWV0SEh0bW40dHdta3Jm?=
 =?utf-8?B?WEJjcHY4NVJtVE9NdFJwSmtUeU8xZWZjME1IMWpYbEdiM2Y5clRjWWpNUWpk?=
 =?utf-8?B?ai9SUmpZMHBkM3NBOGZEYUU4NmZBejQwR3ZsakdPRFlGUEJhSVpHT0lPOGdU?=
 =?utf-8?B?cy9RbmxzdngvdGFMc2NpekVTR3VlRGduenBTMnJ4cXhKeVBsczJSS25iZlRH?=
 =?utf-8?B?bmpaVlRSRDgwMkZNNVJFUnp2YlFmMWd4Ym1URWtzd0NmTHgyK1RrTFFDSlZY?=
 =?utf-8?B?NVljY1FVRjRxK0UwNGRxOVJUcU9zNzhZY0tkWDhGYlZUWnl0aXA1MDhzQ28v?=
 =?utf-8?B?UllZNE9nR1NnZ3RWcnFtN28rdkJCbmEyc0xRKzUvc09OcTN1OXFNSDhjRjFC?=
 =?utf-8?B?dzBBc2MzM3dWZTg1R2s2QkVMaHJLQmd3VklaQmZ5UkZCMW5WMnVWTHZ5WFZ1?=
 =?utf-8?B?cmNVRXRzemJOcTdDbyszemlyLzlyeWFEdHpKcjRKbUZ3L1daaThDbVJwM2Iv?=
 =?utf-8?B?MUJoYnFTNkdtT0dJVDNBL2syL2FJRkFNTldWK3lwTmZSdzZDb3I1WXNCMWhq?=
 =?utf-8?B?TGJvVzE4dXl6ellyeG82ckgrczd3KzNNR2UvTDFRaFlla0dPN1VxK0k4VDNs?=
 =?utf-8?B?UHNCV0pYem9yam0xMUNmbXgzLzVDM1FZYzB0NXFYZ1VqdElubUJCbStIMktC?=
 =?utf-8?B?cmp4aEEyWDBPcmI2WWtIWHI4eUxxYUQ5RjVlbVdvc1BXSWRpNGttYXFEeFJR?=
 =?utf-8?B?Sm1QZ1U4WGFjaHh5cWFrM2d3dm5TV1M4em1sTzRwb1VRbDZIWjZQZkVoWklu?=
 =?utf-8?B?NnU3S2ZxazgzN3FLd1lRWDhramVaNVJPalgvaE9oaFFpUHNiRTFwWVRJOG42?=
 =?utf-8?B?RGVUcjEzMHJ3UXZ2YWJEZTk3NVd3UTBtQ2xlK1dpaDZ1R3RIYnJzZXZCRFdq?=
 =?utf-8?Q?DJBTrbZCntSO0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feb42aad-83ff-4c6e-34cd-08d8be842e1b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 03:16:59.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqnMnEibumPGucmuB7EK7BMgaCquPqmboXc07456jYoJnLCGF7UNKAktNfnDGsHB1Kr8xiNGjRuzmd5Gwl7HytDN14m6r3lERjObIz/LH80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3110
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220015
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/21 8:45 AM, Brian Foster wrote:
> The log quiesce mechanism historically terminates by marking the log
> clean with an unmount record. The primary objective is to indicate
> that log recovery is no longer required after the quiesce has
> flushed all in-core changes and written back filesystem metadata.
> While this is perfectly fine, it is somewhat hacky as currently used
> in certain contexts. For example, filesystem freeze quiesces (i.e.
> cleans) the log and immediately redirties it with a dummy superblock
> transaction to ensure that log recovery runs in the event of a
> crash.
> 
> While this functions correctly, cleaning the log from freeze context
> is clearly superfluous given the current redirtying behavior.
> Instead, the desired behavior can be achieved by simply covering the
> log. This effectively retires all on-disk log items from the active
> range of the log by issuing two synchronous and sequential dummy
> superblock update transactions that serve to update the on-disk log
> head and tail. The subtle difference is that the log technically
> remains dirty due to the lack of an unmount record, though recovery
> is effectively a no-op due to the content of the checkpoints being
> clean (i.e. the unmodified on-disk superblock).
> 
> Log covering currently runs in the background and only triggers once
> the filesystem and log has idled. The purpose of the background
> mechanism is to prevent log recovery from replaying the most
> recently logged items long after those items may have been written
> back. In the quiesce path, the log has been deliberately idled by
> forcing the log and pushing the AIL until empty in a context where
> no further mutable filesystem operations are allowed. Therefore, we
> can cover the log as the final step in the log quiesce codepath to
> reflect that all previously active items have been successfully
> written back.
> 
> This facilitates selective log covering from certain contexts (i.e.
> freeze) that only seek to quiesce, but not necessarily clean the
> log. Note that as a side effect of this change, log covering now
> occurs when cleaning the log as well. This is harmless, facilitates
> subsequent cleanups, and is mostly temporary as various operations
> switch to use explicit log covering.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
>   fs/xfs/xfs_log.h |  2 +-
>   2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0fb26b05edc9..7c31b046e790 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -91,6 +91,9 @@ STATIC int
>   xlog_iclogs_empty(
>   	struct xlog		*log);
>   
> +static int
> +xfs_log_cover(struct xfs_mount *);
> +
>   static void
>   xlog_grant_sub_space(
>   	struct xlog		*log,
> @@ -936,10 +939,9 @@ xfs_log_unmount_write(
>    * To do this, we first need to shut down the background log work so it is not
>    * trying to cover the log as we clean up. We then need to unpin all objects in
>    * the log so we can then flush them out. Once they have completed their IO and
> - * run the callbacks removing themselves from the AIL, we can write the unmount
> - * record.
> + * run the callbacks removing themselves from the AIL, we can cover the log.
>    */
> -void
> +int
>   xfs_log_quiesce(
>   	struct xfs_mount	*mp)
>   {
> @@ -957,6 +959,8 @@ xfs_log_quiesce(
>   	xfs_wait_buftarg(mp->m_ddev_targp);
>   	xfs_buf_lock(mp->m_sb_bp);
>   	xfs_buf_unlock(mp->m_sb_bp);
> +
> +	return xfs_log_cover(mp);
>   }
>   
>   void
> @@ -1092,6 +1096,45 @@ xfs_log_need_covered(
>   	return needed;
>   }
>   
> +/*
> + * Explicitly cover the log. This is similar to background log covering but
> + * intended for usage in quiesce codepaths. The caller is responsible to ensure
> + * the log is idle and suitable for covering. The CIL, iclog buffers and AIL
> + * must all be empty.
> + */
> +static int
> +xfs_log_cover(
> +	struct xfs_mount	*mp)
> +{
> +	struct xlog		*log = mp->m_log;
> +	int			error = 0;
> +
> +	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
> +	        !xfs_ail_min_lsn(log->l_ailp)) ||
> +	       XFS_FORCED_SHUTDOWN(mp));
> +
> +	if (!xfs_log_writable(mp))
> +		return 0;
> +
> +	/*
> +	 * To cover the log, commit the superblock twice (at most) in
> +	 * independent checkpoints. The first serves as a reference for the
> +	 * tail pointer. The sync transaction and AIL push empties the AIL and
> +	 * updates the in-core tail to the LSN of the first checkpoint. The
> +	 * second commit updates the on-disk tail with the in-core LSN,
> +	 * covering the log. Push the AIL one more time to leave it empty, as
> +	 * we found it.
> +	 */
> +	while (xfs_log_need_covered(mp)) {
> +		error = xfs_sync_sb(mp, true);
> +		if (error)
> +			break;
> +		xfs_ail_push_all_sync(mp->m_ail);
> +	}
> +
> +	return error;
> +}
> +
>   /*
>    * We may be holding the log iclog lock upon entering this routine.
>    */
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b0400589f824..044e02cb8921 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -138,7 +138,7 @@ void	xlog_cil_process_committed(struct list_head *list);
>   bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>   
>   void	xfs_log_work_queue(struct xfs_mount *mp);
> -void	xfs_log_quiesce(struct xfs_mount *mp);
> +int	xfs_log_quiesce(struct xfs_mount *mp);
>   void	xfs_log_clean(struct xfs_mount *mp);
>   bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>   bool	xfs_log_in_recovery(struct xfs_mount *);
> 
