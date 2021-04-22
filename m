Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFCFC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8896C6141C
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 21:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbhDVVRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:17:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4032 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236851AbhDVVRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 17:17:32 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MLD3hR030637;
        Thu, 22 Apr 2021 21:16:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IgXRYbrwm5pC5H7F3cK/Jzf7qomWlSjrXmdyFzXgFyM=;
 b=a/ATBV5ybRrcX05Q4qWQRG/QdCp41NAVD6YtGYFgeJTzkvEf6MCgqO8YFR3ef+qLABKF
 s5+Ufd6J/mPUR0dRQN+C9h6b9U5oo2vYUGBDkT/O60HweD9FXcW3OAUexVL1ETBqbuWe
 rRVMK0d+7kD9QuUVJSR4+oV0crV60I/O5fVF8LVu/KQaC/nHPkjzSpteaPRqoJzhkojh
 u5fSPKqmCtfHCYbszLdGHkO6xBFkBZMTUEm8AfjbvB5bhD+KCZAqf1ObdSmrj2d/vUud
 KR0HJibBaD6AIoreJ54/V3QBpWZ2kPvi1uwxINwHQ6ylEHBOddo0jkEbsiNz1fzdC2ch ZQ== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 382uth0fb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:52 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13MLGpvr154025;
        Thu, 22 Apr 2021 21:16:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 383cg9m9b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 21:16:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8KqdKyEeOPnjPQpCUkOf+KeqTunXlhnPL2SsjWbH4SS7gWkg7HfZjA1D+tL24RlyGRjhMkRyl4z3g18m1qY2KA/XyUnww9FuQb60EMAaHpHSb1AA8L7MW1eqs5n/JkeZ3/8myhJROYp5IjtxmdAAVKfbPaeXObaFIr9/w1mUgla73671M71HizSisAWM2cPvRRR5Xc9qquU53kGy8hEVExqVUfuNe+HJItlAhsmFsv9gnvBukhLA0/VSuV0aG7ltXsIbxDbWJZIuJ/6r34FR+j16Zj6fLfHtmOp0w7bT6A3EcIn7OlVamDf3cY0/6901Z4v2Ji0sa4LyMz3TAwyzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgXRYbrwm5pC5H7F3cK/Jzf7qomWlSjrXmdyFzXgFyM=;
 b=TaG+AkSp6MhPXKw6p2eex8wL0j1ukq1+Fcx1CDPIlio6nbxoDsDgVwBagbjUX6ZLOuWVmrWPfvVjzejsaE37joQObOe1Qu5P2NhB71jESZqyaI565TXk6bhZR+hoizE7zvij0CCRbWH69TxmfWUFkH6hOhElIdEMaQdyb6ErIxNyzms8UV41jhbi84OLH1IHIYSdGzUDZc4xoAyjh7iZL0E0va+rKXFRzHVu+qLPkosU444BSiLBGRfknh/nkYJSykIqEq+dmXoE0xK0f7O3043rjXBAQWS9NPAfarcRgAxCSaEqzJloIydtJP286ggDKvvSrC9+emn7PQnVblpqGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgXRYbrwm5pC5H7F3cK/Jzf7qomWlSjrXmdyFzXgFyM=;
 b=KC091k3wnRQ8ZZZiIe4rUpUrPNvbM4KVm7jqnkAWJUYmxAadKPphFo2ySQImBB4zcfORTP77tBzILvbANi8Mg0qiiCI3C3Qr2ZkDrQnCtBGNevOQSDE0uGdcLclRlrXZnqn/+QidV16h2/OMOk8j3/A+rxunNBqDp23/PoJzpvs=
Authentication-Results: eryu.me; dkim=none (message not signed)
 header.d=none;eryu.me; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2870.namprd10.prod.outlook.com (2603:10b6:a03:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Thu, 22 Apr
 2021 21:16:49 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 21:16:49 +0000
Subject: Re: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
 <161896459378.776452.5480197157832099240.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e811b979-78a0-e5fc-8377-b467d99bcddb@oracle.com>
Date:   Thu, 22 Apr 2021 14:16:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <161896459378.776452.5480197157832099240.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0067.namprd02.prod.outlook.com (2603:10b6:a03:54::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 21:16:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41b7d92d-22dc-4175-b1f9-08d905d3f131
X-MS-TrafficTypeDiagnostic: BYAPR10MB2870:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2870FE70693BD1D9CF9AD33095469@BYAPR10MB2870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DDfHgdbc+n+a839Jp98FYXc86szvgVDMN5FQ2qt27S29t2luWFapqkNQMmeiWYrfdsxmfG95ksBFfRG+H/WG/27lCZEqUGWwxtjizPS1hNK6pOpIbf6wDXnbjCETaNdTHiI1gB8bI8wKe+JrSZ9Yuz8ccDECGDuKkqRhdlrMZ5PmABmSu+pMOu1biBq5MduH2YrZTvlm3MUHOQd/tqCCgtPg29mDEQhkBsGqInvmm6/WXzZvla4IvXJiHVtGZL4wb0xOplIPuxgsS/0V/S9Vn+KRD0+ysTAha38utNEMnGrvTMYm1jgBzpSRwh5+Dmce14OgVQAxH972/TcN7iyawbDw8S52IqqFrXv862xwUhCeklupXl69NfnP0NfSHJNkxaZVfFzQQF0biALviI02HI+tYcpd2ipd8b1Tplu7gcKNGmSFi6vBN2HeAcg0H1dbF3l1qGA5NLxGSVX2gtiuhWyNPO3XR65XUGQm0M2i3cmQqodJ9lCLnX+UJ4fMqA/x4v9vUBgRroBIaEUOShnMM6bijyVepqz8ZApB/b/inGhrCsubCfxpjEn1S0cQfWLC+z4MnYGDN6E6S55BoSHHCd0ioko5bDMEzNZFxYlq8i6RVQlgkceUqxkQS+oQBbPNYN2vmdAhA0dmLhRoAqHL1FspL8CHtVidjzWlzSxWrvTFLE/2zxbJPDD6TSlLiGy02iZT3I8l+q1vVsPzggLTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(66476007)(44832011)(66946007)(31696002)(316002)(52116002)(6486002)(38350700002)(16576012)(86362001)(31686004)(66556008)(956004)(53546011)(38100700002)(36756003)(478600001)(16526019)(8936002)(5660300002)(2906002)(2616005)(26005)(4326008)(8676002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjhzWG5WbTNIbGFjeU9UcmNsRUZ5NWMzZW5tcU9MVlQ5TGFrS3lrVlRPSHln?=
 =?utf-8?B?TlJteVc4UTV1MEM2aHp1WnlYTG1TWG1MVzM3Y3E3SXhjcXNIUnN1a2hiWm9i?=
 =?utf-8?B?V2ozNGZXQm5uVldBWDZqT3hrN2VHZmU3VzJDM3V6cVUzekc5T1pidGI4VUNJ?=
 =?utf-8?B?OUZZS2tXQ1pHSTVzeE9nVC9PWW9BTkFvN0xRaVhGbDR6K3FSL01uVFZoUUFH?=
 =?utf-8?B?dmpTVlE0Y1B1SHJnYUJJVWIxUjJ5bC94OEVxOGRkalVsMm5KNFo0MkdacHVa?=
 =?utf-8?B?ZjRFeWh3TjdaYUo3c2Y2dENhdldDL1JGSEM5Z2g0T1ovR3ozZjAxd05ERDd1?=
 =?utf-8?B?OVRJUWJmb29hKzRUb3Q2NVBScnVWNEZMMVVBMTlyRnRzR3ZZMWxNRmhlTW4w?=
 =?utf-8?B?ZGpyQTR0Z0IwZFRXNjMrYWVZanRVY0xlSmdWa3dROXFSUE1ZdjN0OGlsNEw1?=
 =?utf-8?B?ejlsallwT1F4V0ZWVncvbGRzamphZU8xYzl3UnpuWXl1RUhsMGpSYWpRbC9F?=
 =?utf-8?B?OW9NTzVXV2hrc2h4Skc2bFFZOTFIMGZPOWYvVzMrNXFKbjdvakEydmVCa0Vq?=
 =?utf-8?B?NU1FMThyRUFnbFJSUldURU5aSVZQVFlUNXNaNFR3Q2VzY1RmS3dnb2NQcGRz?=
 =?utf-8?B?aVc1b3JlN3RpRVYyVytickhuVnBCSkV5dUhhR0l0NTc2U1lURk1qczJ0NGhH?=
 =?utf-8?B?WmRoak5JdDZhVU9wM3VIZjQzRDkzdldzY211R0ZETzM2UG9oVVRlWEhJTUg2?=
 =?utf-8?B?S1NOVkYwY2N2TFdRN2FBN0Z5R2dIazR1MkZGL2JLM1RMYTdISkwzNUhvYklZ?=
 =?utf-8?B?SjVVTVBXUkEyWmVjOS8wdnBrMUpyNXpOS2NCMkJTRXMyWkxldFU4NHB2Yi9S?=
 =?utf-8?B?T0xwVEs5NUNieTdUWUNkVFVNa0pmOGpDUG9CN0lsOHNnWHhuM0djYmJ2OHBY?=
 =?utf-8?B?cjAvV3RKQ3hiVkpIUk9HWnNlV0VXS3hZMlNTamlIb1k4bVpOWk1DeU5iNkRp?=
 =?utf-8?B?azJzMldRMnBJeXRnNUQ1R0ExUDVwemVTUGk2NDJzcVRBUFRTRm4vaEZ3bzhM?=
 =?utf-8?B?NEVPT0NUbWxNU0RMUk1WckJxNThMNXFZZEh6RTZWc3MrdldaWTk2QURpdVI1?=
 =?utf-8?B?SnFXUWkxRUtqc3Q0MFJSMnRBQ1ltZlRteHRhUlNBUC9XRGgrbFVWTGVlUTla?=
 =?utf-8?B?eGNVU0U0UUlDVXlZV05zK203MXNwYXVyK29HcForeDlJa1lHb0JUV253YktC?=
 =?utf-8?B?ZllsVEVzQ1E1eEtMNTNUTmRqaTIrWnVhLzkySzROZzd3ZENXTFAyVEJqN0py?=
 =?utf-8?B?ZTdWdGE1ZVBoU0Iwc1YvZzVWd0RicEx1ZGtjRWpmRC8weDFHTDRWMWZjZFU2?=
 =?utf-8?B?c0F6WDU5YnBEZ0pvWDAzWHJmQlg5QThUWERYZWZYalZWMm9Rbkx5aExFWlRD?=
 =?utf-8?B?aVNVV1RjMXlVSWpNYVY3WFZDR0VnSldnRWNjaWlCZDI5MnJxek5BY0xJeG5L?=
 =?utf-8?B?cE9JeUdsOFBicEJHZlczQ2RyT3NIclBzaHE0VXlkSER5MmZXMWNMSk1YM3I0?=
 =?utf-8?B?emw5WlpNVVUvMEp2M3R5RlVzTzFyeUF2aU13ZTdPOUlzWkdOYmUrSHRrT2Z1?=
 =?utf-8?B?UUFTcmZxUkN1TlNvSWNGT09ONTN5U3EzRUs2aG1KSkUwd3dtWllKS01qMWpk?=
 =?utf-8?B?LzVzZmRIUWN4VDZUVTZzUEREUEZMb3NpQTlqY2ExQXVLWHpDODRsQm9LUzZF?=
 =?utf-8?Q?J1YqZ5qyb8ecOVPSc2NX/3pU1oZoT13jMxOK8DM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b7d92d-22dc-4175-b1f9-08d905d3f131
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 21:16:49.3923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdJgW+pN8h2Z/SKSWpKj2mULJW/PQ1gdlAWr1b+ad1QCXfq/ZVE2jSOn9yVt/RE+XaqexJqKcCJHSUyhQu7HHeusZPRF4QkIZUy8cSEO/wY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2870
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220158
X-Proofpoint-ORIG-GUID: FxWANaMTl9hDjkPWbMmhk3k3PJnu5LqC
X-Proofpoint-GUID: FxWANaMTl9hDjkPWbMmhk3k3PJnu5LqC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/20/21 5:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add these new ondisk structures.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/xfs/122     |    1 +
>   tests/xfs/122.out |    1 +
>   2 files changed, 2 insertions(+)
> 
> 
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 322e1d81..c8593315 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -181,6 +181,7 @@ struct xfs_iext_cursor
>   struct xfs_ino_geometry
>   struct xfs_attrlist
>   struct xfs_attrlist_ent
> +struct xfs_legacy_ictimestamp
>   EOF
>   
>   echo 'int main(int argc, char *argv[]) {' >>$cprog
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index b0773756..f229465a 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -97,6 +97,7 @@ sizeof(struct xfs_inode_log_format) = 56
>   sizeof(struct xfs_inode_log_format_32) = 52
>   sizeof(struct xfs_inumbers) = 24
>   sizeof(struct xfs_inumbers_req) = 64
> +sizeof(struct xfs_legacy_timestamp) = 8
>   sizeof(struct xfs_log_dinode) = 176
>   sizeof(struct xfs_map_extent) = 32
>   sizeof(struct xfs_phys_extent) = 16
> 
