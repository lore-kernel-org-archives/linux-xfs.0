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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C89C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE58164FE8
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Mar 2021 06:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCJGNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 01:13:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhCJGM7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 01:12:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A68jY2097991;
        Wed, 10 Mar 2021 06:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=W/JjDKg+Imo5L7/xwEKzj933unrwj8xzQ/ia9c37d/c=;
 b=gG7U/ORy4v9hjYJWveM37vmNKYzrXJ0eCHr24TZt2dItr/5m1EHI/U9hK6Wn/kfHMLb6
 0Jgaa4nDb7PCPGFYnxEh6R9vRvhsWkgHjO4Bkl3zIqfcQTfupNScr3nBw9NnDOtDCh3D
 wOfNnJuJLBY++m/zmsfgvhQmAwBBAbv/2tA+AsclhfjOcIUiOzPV34XE/P/OHfCSoXRW
 /Z9GG/GY5P/uxcUjwmSxYgkMwP/q0cKQUijX5JGeS7TmClmXeAWKTAbliFn00+zcyN73
 xldDC/83sJ0ggSj5LOGe4vMpkLGx4ozKCt7OlvmO8N1gGPkoea2jR+QOk2n2/dg8LTT6 kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3741pmht95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:12:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A6BRtc132551;
        Wed, 10 Mar 2021 06:12:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3030.oracle.com with ESMTP id 374knxw13h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 06:12:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOpsVqUXnayF1wHV+1Zv2LceAwkqv4fskf4+4vn8cAKNyQiVLAhYg+JkhYjc4xtujKp7H4BdZdk5+Bjs3pUXMCeiJGy5C7KjXPHePLk+deL4S/iPZ46KOGcJ7z9EHYswJ+tz0oag55tRkv0jqIaWHKJ0kTaAaieT/HOKo8izFUPWL+5jc8PyGnWmpwrWAnRHAyoyMtJX9katTLp+QQxYoUQuKwzZfEf54a23p2tZfBY4veQYPMMariXHj4NnPappmMoH9GWRAQOheKdeQ8jVcOAtLnXob8vmcy2sKVrytBQv97OnSINwiXh3qTLTvCaUs4BSyXN2eYhesHyqUtRLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/JjDKg+Imo5L7/xwEKzj933unrwj8xzQ/ia9c37d/c=;
 b=ex/80I5tlm4jwluCtPn6oa5Sm3wzgK8yvIae6HygH4H+NxGPZyz99cOW1kYUh6YOUysXO1auNqAFnuh6z2T0KRU65NtEgyW1C9xoK3NjkHgm0ktmZNcW5vtL3Dui58SBihfo5lIqvmuWFtx6nMPRSs7LkQk6tCayt6rYCnFteOqwBAK0KgMiRJU4gnMSfseT5s7CfT23zj660gA2P3XA23KPaspmIq1thIGFdvln9VrMDso+RKCD1c1CxoYOpdeVDMn6GpNJCpaBl1L6IRQAT+fahvPxJHDw6jTl7kuZ6uc5YX5K1LvWoveMwHe3AEcTFyQ8iCyr4vD83OUOu8Swrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/JjDKg+Imo5L7/xwEKzj933unrwj8xzQ/ia9c37d/c=;
 b=D/3C8x8gfu5/tLTZTAKuJe03s/9jhox5te0PKIz3mosczqatwZgaOBanJ9c0tFh0AP01XuMxqvFGJNq9EPzvsBNXEtmLKPmvYAsKKUEFHwgXf8352Y2IDEGCoBG4+vMid7TikTsNy063t9tFiXTnEUAxvLkad9BdW78sY1byzAU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2518.namprd10.prod.outlook.com (2603:10b6:a02:b8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 10 Mar
 2021 06:12:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 06:12:53 +0000
Subject: Re: [PATCH V6 01/13] _check_xfs_filesystem: sync fs before running
 scrub
To:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-2-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4a80e0fb-5322-dfd1-e1c2-7b47d7d40a56@oracle.com>
Date:   Tue, 9 Mar 2021 23:12:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210309050124.23797-2-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0195.namprd05.prod.outlook.com
 (2603:10b6:a03:330::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0195.namprd05.prod.outlook.com (2603:10b6:a03:330::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.16 via Frontend Transport; Wed, 10 Mar 2021 06:12:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 113ae95a-0338-4d74-d497-08d8e38b8a60
X-MS-TrafficTypeDiagnostic: BYAPR10MB2518:
X-Microsoft-Antispam-PRVS: <BYAPR10MB251815B1F9643A7101C73FBF95919@BYAPR10MB2518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: osdIAl10eT4ePGrSLO69CNll4HOmSmII6JiUtKWvPgM3CLmzcnf+6y0eojoEchOq/dfYGHwDV2zU9SOGRJp6v8izp/sOdxScglAPLvAwI+aLjznleXwDdxgzcFfwVEnJ4gNE/npWqOIAGuRIhUyop1QMYrL2IaaPyTkIybiyJYxWB0IG4wjYU6zCrCIlfSHIcrfmTPqlXBXNDpTfAJZrruzrTAyQlEhiGJFfCVMpL8FpzloINUheYPK7JnOJLPM77AvgfhMWXpYoQZTPKBi+nwbaIQ104B68CKeXmQNlb/wxk+4Vjd4+OXrlJUPP48PiaoxlB5PxGucj3YDNgbvf90MNkXql5IXGkwz+V//Hy2dC/s7gi5RkhL77vtAHOCybpOdkO5QDmFOyJmDycXZX54awSg2MSuflN4Q7+hls5RBbgReSt2MY0M8xK4QC0tVXko2XWVuTVsEl0rE272IfeLSi+zb0QF8H/AA0o4E7qE4eODehmPDURAmXtirJojmz1pyXuo5WE/MSoDIdDqw5uZP6eZ8q4ZLs0q2EyVX7vLtHx1HqXsJPFCEuCXlFt3KL5tWnjSrqxZXMTgW9OsXgZ85+XCHCYRehWknltLJwEfY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(8676002)(8936002)(53546011)(31686004)(52116002)(6486002)(4326008)(186003)(26005)(16526019)(44832011)(956004)(86362001)(478600001)(83380400001)(2906002)(2616005)(31696002)(66556008)(16576012)(316002)(66476007)(5660300002)(66946007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dmN1VUFZMTdHSjBvZ0ZwalI5Ym5Hckhqa0NRRGxNekpPZzlhNVpRelZ2S04v?=
 =?utf-8?B?OHI3emhJeW55VEpuQUZpU094VUdKSDA4VWU0VWJkekd4WS9WbkkxTy9ucVR6?=
 =?utf-8?B?OWRqOWlTYXNOek1OK1JRSElxZnQ0NzMxeHZlbkdTcjZPZUZYZERuTkNsYUdj?=
 =?utf-8?B?OFBYL3ppTTJ5OHFtQkZRUWVhZC9HRFBiMTFUSThPQ3pXNjhCc1lMeGxtWjNE?=
 =?utf-8?B?NmdUbjlTWHZ1Z0ZscGwzd1VNdzRWMWxndnhhc0UwUG5YYmtNa2ZVL1lzZml6?=
 =?utf-8?B?YitMSEZZdW5URVJXOG1lS3J4R21DVUFFcVVqTkZLR0dDQmN3RUsySzA3SnRj?=
 =?utf-8?B?ODU5VjV6QzZNNWpFSm5oZU9tR0Z2MkE3S1NLS3N5V0R5YXhUbU0zaDZHOUxU?=
 =?utf-8?B?MUIzVDNvV1V6RzIxWlBBd3pvNVQ2TFlBSGFlbmQzcWhvQ25OZGRONFI0OEdY?=
 =?utf-8?B?WE1lUjZTeFR3WERlTkVNWThsMDYyaXlpalZITGE4ekpTanlmNkVJajBrZ3Av?=
 =?utf-8?B?S1UxV1Z3bS80KzA5MGRud3IvSGZpYXBhMFJLbkIyOVZSTlBiVkMzNlpNZzlq?=
 =?utf-8?B?bTZVWmJETkdqeFN5UW10eVphSDRQdWNncG54dXRGQ2ltR2hQQlhNRmZJbTh6?=
 =?utf-8?B?UDZ0Ly9aYm5NalZBVktZTW44am1iNGdDc2JDTHdWSDc0N3EzSjVjc2VhYVpN?=
 =?utf-8?B?V2RuOUc1aGp5a0hIQzIvNE1UWVZGMEZSNHRLNXA2NkRoUm40Sjl1WTl2UnR6?=
 =?utf-8?B?aUlyVnhXeURpWVR6VlYyZzMwdGdGb2ZEZ1dROW1mK3ZkcnhJS28rZnBudG12?=
 =?utf-8?B?d3pRcHkwVnNWQTlrbDk0U2lnWS9xNmtKbUFkVU85KzdJbjIwZHFLSk5lOExx?=
 =?utf-8?B?dm5EZEwvTkhrSXZQN1J3ek1melZRZ3NreGlFcWdqUnhMNWVmNDlFbjkwOFpz?=
 =?utf-8?B?QnhxYnVyVnBFeGZ6cTlKVU0zeTZXdk9rS0ZzR1VoU3FpQjFZenk4QnoxK3NJ?=
 =?utf-8?B?VUI2R3dsSFJDeGhyUHdHQ0xRaGxMV0hYYjlmaXJVQzA1QXZRREVwRUJCMjE0?=
 =?utf-8?B?VzQ3QVlYK0twR1RzT0NycmtIQklxU0RlSVRvRklLU2QvdDZ1LzhrZkorcHNZ?=
 =?utf-8?B?dnQvTzMyN2N4QVJMRld6bE41aTN6RTF3aGwyV3AxNWNLUTUyMGo0VG9RMVBt?=
 =?utf-8?B?TWpkZ3dUUUk2Zy9odnBYeTRvZU1KN0UyZmlsZGVhS0dNb05xMmk5dEZEVFRN?=
 =?utf-8?B?MGRGYjVjY2ZOb2c4VHJoQkxieFh6RWVSblJxaGtyWUYxSWxHbWdUMGFKcGdU?=
 =?utf-8?B?Zkc2c3Zvb3lvUWFhaWlzSjJHSzJQZE9ab0ZzTE04Q0tMeXJ5SmJSaUtKY3F1?=
 =?utf-8?B?VlJmNExPQmpaYXAwQy9wcGhlazVNanRIMkhaOW02UEpIRG9SelpHbkpWREM3?=
 =?utf-8?B?VHJscWpDd044N1pnekYzNVJBOHZSS0t2YnVzM0pXTUp6SHpvdGZzaGJMMHhC?=
 =?utf-8?B?SFZrUUhucGZxa0Jodi9SOTltOVZVR0lnNFB3UWF5bVhPR2l0SXdneUxxMnJF?=
 =?utf-8?B?UldHclN2MkliRjZGVFJ1Y1IxZmFKV1l3cW9KNzY2OVJRbzJ4TUgwWG85cDF4?=
 =?utf-8?B?c0JqMEJkanBMa1NLUExxVFF1eXZkZHoreER0Vk1IUktRMU5wVDduRWkvMVZu?=
 =?utf-8?B?aE5qOE1VZzA4enpJbVI0NlhQYUc3Z1V6VTRnZDlkQUJjUGg2cFE1SXV2UmNt?=
 =?utf-8?Q?IamX9ZZ04UCQRc9cjIYDGlYfohMdySxsnPLu+Rh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113ae95a-0338-4d74-d497-08d8e38b8a60
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 06:12:53.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1lzuPFESgHt3QrjM8oOsZte8743rttYB4pe47irLp5WTX/583KuS1TO4ZwnmncA3afOHEAqE8hyRkoSFta967QsPIipT6eDPnhfKChQd9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2518
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100031
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/8/21 10:01 PM, Chandan Babu R wrote:
> Tests can create a scenario in which a call to syncfs() issued at the end of
> the execution of the test script would return an error code. xfs_scrub
> internally calls syncfs() before starting the actual online consistency check
> operation. Since this call to syncfs() fails, xfs_scrub ends up returning
> without performing consistency checks on the test filesystem. This can mask a
> possible on-disk data structure corruption.
> 
> To fix the above stated problem, this commit invokes syncfs() prior to
> executing xfs_scrub.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/xfs | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2156749d..41dd8676 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -467,6 +467,17 @@ _check_xfs_filesystem()
>   	# Run online scrub if we can.
>   	mntpt="$(_is_dev_mounted $device)"
>   	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
> +		# Tests can create a scenario in which a call to syncfs() issued
> +		# at the end of the execution of the test script would return an
> +		# error code. xfs_scrub internally calls syncfs() before
> +		# starting the actual online consistency check operation. Since
> +		# such a call to syncfs() fails, xfs_scrub ends up returning
> +		# without performing consistency checks on the test
> +		# filesystem. This can mask a possible on-disk data structure
> +		# corruption. Hence consume such a possible syncfs() failure
> +		# before executing a scrub operation.
> +		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
> +
>   		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
>   		if [ $? -ne 0 ]; then
>   			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
> 
