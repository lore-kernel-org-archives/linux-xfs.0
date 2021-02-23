Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189E5C433E9
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD6F264E89
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhBWUTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:19:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhBWUT2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKFG4E193182;
        Tue, 23 Feb 2021 20:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dNM0xI5HipE9AEB5bkV7qHVZag3Xx8fYxLU3i9EOkhQ=;
 b=elRZK4tA1EzH2mAFA8zDzsBFKyuojOye+6cMtpg+kQEXbqh0WYfRnNrq7YTfrz2vpYD1
 OHVOHsButg87R2GD5Yqz9L6W4brWQRVAllnDfvh8KdcHoLeiZSijkaSVMCxWWzKv5QWI
 F9IzvVB3kT9ql9O+tih5Hx3Vrp0zTZ2uYUxwUCgQTCgLXZRgJCff5i6AKjTRhmox7ELp
 0DlWMy9ylUlACeItZr/THJ9OP5bBBZRmRnHXwr2KVLBLAONrwCkSvc+eozgPCv31/NnI
 +aw9Igsn2NdDlUgNU8vBZhJMeXpZli9f1MzjZn5UGgOGrDzdL499R11Dg6VXrDK6joyr Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsur0rnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKAb00121531;
        Tue, 23 Feb 2021 20:18:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by userp3030.oracle.com with ESMTP id 36ucbxypbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgqV9zKjdtzwJG0rHo3I+OXIp7BCQS5DVqLz0VLMi0sC77QV6kqJeFFz/M6aNwA1REPl2710Cs2BeR2U3tJk8YHGnXhQHzeVXbd21QKAEQaO0WuskohKa3/ym1p38vCiRpKFlRoGantMcG7nXdKUT5qeVuDbYNHRAJ8jpamfXn6GYCxJafoTbA36CILDXG3fKEGVkwfzA8O4kYHFNCme6FppD9wcJvC095Dh06m1czkOy1BW5cqevn7BC8VxaBbcdsWoxb071jTdgmBh5Dp6WQuQsHRjj972kQJR11Z2a7fBNKUCO5iQqHEadyLPHl/tQ1e0Jq2jaxY2I64zHXlgwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNM0xI5HipE9AEB5bkV7qHVZag3Xx8fYxLU3i9EOkhQ=;
 b=UDm0db6eTaonDzdlf44aWDVeA2lr4ER9V4Yq2PXqZy0Yxxsg7p82g34VM9cutJsXprtPY8GKRsr/Ii7fOqlOUXU5ATX/TOy++358bvUIEIzToq4JadGEzxwUwYoh9xPeLvarmxJaCDTPTu3FVxbyvEg/aki9BjJ4hJQTAcOn/Szj57tvisGxMcbZjx6K3lsS0Y4s46QPQ9XXRHm3PPSgkbY1bvNAisg19NHG82n9oW6njkZhjMd20dLUNQYy7ht6stwhN4BR8/nvRPPxYhH8eOfi3GHxcKircHBRPhMOSpoAdsIVFnFcIVhh4ksgtYQzmoRrjh8bLOXjqk55YFOZXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNM0xI5HipE9AEB5bkV7qHVZag3Xx8fYxLU3i9EOkhQ=;
 b=kSpl/2zgC4cKv5gi++5jdDo8iXm/cXGEvo5vZ/SQJBlYQeIB7r//tq1849tP2k+LqVLf9GNJ5erSVjLFdC1oM8MbS4kkXwf3wqcL+/7CvIdvhncl3/bNcSiss81aN2r2DQSsMhiqSAUwFHJW1Q0PjX04jNhYv+g/QTqZGDlHAWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5211.namprd10.prod.outlook.com (2603:10b6:610:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:18:40 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:40 +0000
Subject: Re: [PATCH 4/7] xfs_db: don't allow label/uuid setting if the
 needsrepair flag is set
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404924136.425352.783422563005701204.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6a807b7d-9dd8-ba1f-7713-9996105b2b7a@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404924136.425352.783422563005701204.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::23) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0013.namprd03.prod.outlook.com (2603:10b6:a03:1e0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 20:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbc2fd56-41f2-4084-3959-08d8d83835c8
X-MS-TrafficTypeDiagnostic: CH0PR10MB5211:
X-Microsoft-Antispam-PRVS: <CH0PR10MB52115A6732D5A77273559F0B95809@CH0PR10MB5211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjPWv4HrJxjvbUyBX/hgy9TiT7ZYa9TraoxXRqteu8F1DDbL78urHhfNPqYjLGThYr6sn2cgkKyGs7GQSR+N03RSMSiVeYGN4IEfR9cte+cWhKN5XGogRcXyjMN31AKouLCX1+Au+Hw4Uryk6j0nmnp1+jA0OL8iw8siSBYDVHVYNRAhLtrqICa20WPLOrSZmoJ3gHWOov85d0Nh1lKrqObfdr/S6fJK0aUwUnS29I5iXlHczWNVO3bXfBXURGc7jski35gwkimY+MUPMyyk5v5/sXR7CM25csjn/co7ROgerfsRhoeSJcBCGdTNBKOd5JEruqgqGiFQlPeQie3QYTWOzSXqvA4WFRs4ryagvKNL0a1Ylo06X4nCmFFgQY2lh6oncoEkjW6goRdI3/CQUGXPv/dxyR+FZrm+E7Nn/xgP4WL/zW1atjED8yvOYpWtJT0TfPvpF6Q1cgqsVTx/lZvB4vx8mEiGeZmFfNrzMkMHGxiJQ9E+P8yrfeVYXPk7nEBrT27BJAYf8jzPCjszFAsep6yjwVVubhE8v14EKIoSlmg5nKcY2UnLBLNE5PDkyBhZnMQK+f5kSRRJZHYyBgoWoIq6cSJ7hdYqMOlh6sY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(5660300002)(44832011)(8936002)(66476007)(6486002)(83380400001)(2616005)(186003)(26005)(2906002)(16526019)(36756003)(31696002)(53546011)(956004)(31686004)(4326008)(66946007)(16576012)(316002)(478600001)(8676002)(66556008)(52116002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHRTdmdEMDlOMWFwQXViY0Y4bVhNaW5WU1JXZ2VyQ1QvY3R1ZklTUzV3R1BN?=
 =?utf-8?B?c3dBYlVnT0c2ZGZzdVk4cTg2eDNKTnRPQldnR3V1STVRcFZ5cnVCaWRyK2g4?=
 =?utf-8?B?OUNhUlk2RXpBQk5sVk9XYnBEVElsaXJNYTlOakxZQ1dZejZ1ZHFnYkUwNjNq?=
 =?utf-8?B?Tm9seFR1T1BtNjkwUGcxRktxeVgzRjNOR0JFWDJYVEVqT0I0Y21EZHhPbEJE?=
 =?utf-8?B?d2NyTWlrc0NKRmpzVlMyL3lWdDJpNFdPY2JOQmZTRkhwZjBIZ3VpKytacHhO?=
 =?utf-8?B?VWY3MTZOVHU3cGQ3RnE3T0tYVEU5VHFGV1cyNnJSU0xKMnJQay9JN3owYkha?=
 =?utf-8?B?c29vMllJemRLU2VWRk1ZbUZjRkZ1MW5FTjlBUmJMUnE5SndkS01PdjFaQVFa?=
 =?utf-8?B?ZzZKd1d0SHRpQ3BZdWlUbmpwbmlrTjBMSkRkMDF0N0dvcnROdHEzMnNFM3Jw?=
 =?utf-8?B?N1F0dEFKdG82UUlmWnhZMXFzQVRvRERlcWxRS094WnpvVllvdUxPQUZ3bVZJ?=
 =?utf-8?B?WEpGMmxTVENTTExRa0hhbDRZZk5HRk12Q0hHcG1MV3c4N3ROTWExT3Y5SUds?=
 =?utf-8?B?bTgxbWNZK0FKaGdQT2FNNGcvWTROUkJKUG9YOHpRSGh5L3lCenpKVVFsSTBj?=
 =?utf-8?B?b051OXFkY2RPZ3piTTFFamFmRUs5bXdNM1BuYm1ISGk0aEhkdXhqV21FZExF?=
 =?utf-8?B?TlY2YUZGOVR4SU5IU3JIYkp1a01rRTZOOU85bXVmMWMzd1paVHc2Y01MTlVr?=
 =?utf-8?B?VEJHVWZkcjBLbG1aSjhSUk1iMmg5aGpEK0lZRERsdU9ML3VHZXdSVmFUMzJu?=
 =?utf-8?B?eGdoa0RGZDBFQUtUZW9yZk5Hd3pQcXBDdkdXYytuMmJodHZtUEJYMzY3d3pn?=
 =?utf-8?B?WjRPTlpLZkxtbUdHd014Y2FRdTdJc2NKaTBXVG50dVJTdGRxWld5NlMybUU3?=
 =?utf-8?B?T1dUTjhpT25JOFlBRGlqYStHMDVyU0dNU0FqYVVsbVJTRGl4K0liQkdrNGZU?=
 =?utf-8?B?K1JHWCtqR1FVZUg3RlptNHhMc1RNTTRaTE1QeWNrQWNIMDZnWjhLOVhpcDRU?=
 =?utf-8?B?bEE4WW80Z0RsLy9OK1FlNVFXcGZraGpNSHFWY1I5STVOZzAwSmV1N2J4cXRM?=
 =?utf-8?B?a09nZ1Q4MGVkVy9ibEdyZHdCTFduMmVxRFpwbGpLQVFXM1BNbWpFZjlGQ0Qr?=
 =?utf-8?B?UitYQ0xZUVFFWlIza1RGdGErbTc2TzFZa1hIV08vZjd5cUtpL1JmWVUxSDd6?=
 =?utf-8?B?M3Jrd01xRDNCUzA0UDBPOHJORk96MWMvc3NUY21zZ05vN2RoWkNzQ0tGL3FQ?=
 =?utf-8?B?OWxGYUQ1R1lkZGdTUmp2NkR5Q01SQ2szVkRoeGhhZm43a3dmWitQa045akpG?=
 =?utf-8?B?RHJ3d0NZcCsrbWh0WWFLVTJuN0tpZU93V0dOVFVST3B3Ty9SMTB4dldTdXBT?=
 =?utf-8?B?VE5VYkhKVytPTTVwcExzd095bWpGS2NjalhSMG50bCt5aWpia3Y0YXlOc29C?=
 =?utf-8?B?ZHliWmVpa1hRcFJ6UTllajQ0ak5zN0Ntc2F3anAzRnp6SFZJRm9hWHo1L1My?=
 =?utf-8?B?OS96Q2xVbldVMlVnWHZvck8rZVZSeXU3VnBhVHN2Z2svTTdoQ3BGbnlNK2lE?=
 =?utf-8?B?Z1hPQUYvQ1UrS0lCaGl4cmkrZ25rcWpiNm1POUhtTVEvUXcrS3ZOOWpQVnRw?=
 =?utf-8?B?MTVlWHpESzFmd24zV3dnYXBRZjFvYnRuT1l6NWh1T0pDa3pzNGRhVGRTSWUv?=
 =?utf-8?Q?ITXxgbz1zPd6PiWPH+qLIKOw/VSiYTkdTO2R84U?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc2fd56-41f2-4084-3959-08d8d83835c8
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:40.7317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yb6AzSAdhdB/8Lqinh6elLW3GiZDm2Ew1FStXsibSuinAz4O3q9lt9/5qBhSl3mwfhbNUFRgvi12D5L7zcaYDf3xC8BLygbneT0czG42bTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5211
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The NEEDSREPAIR flag can be set on filesystems where we /know/ that
> there's something wrong with the metadata and want to force the sysadmin
> to run xfs_repair before the next mount.  The goal here is to prevent
> non-repair changes to a filesystem when we are confident of its
> instability.  Normally we wouldn't bother with such safety checks for
> the debugger, but the label and uuid functions can be called from
> xfs_admin, so we should prevent these administrative tasks until the
> filesystem can be repaired.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   db/sb.c |   11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> 
> diff --git a/db/sb.c b/db/sb.c
> index d7111e92..cec7dce9 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -379,6 +379,11 @@ uuid_f(
>   				progname);
>   			return 0;
>   		}
> +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> +				progname);
> +			return 0;
> +		}
>   
>   		if (!strcasecmp(argv[1], "generate")) {
>   			platform_uuid_generate(&uu);
> @@ -543,6 +548,12 @@ label_f(
>   			return 0;
>   		}
>   
> +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> +				progname);
> +			return 0;
> +		}
> +
>   		dbprintf(_("writing all SBs\n"));
>   		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
>   			if ((p = do_label(ag, argv[1])) == NULL) {
> 
