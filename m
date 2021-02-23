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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A117CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6125C64E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 20:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhBWUTl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 15:19:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44506 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhBWUTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 15:19:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKEmlS043294;
        Tue, 23 Feb 2021 20:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Kko7VlPTlI87ybN2wOSZCdOAYh8l/wuiqXk2MAXX7qo=;
 b=TrQ2vAyDUr8gUui4F2N9ZjkLU6cqur8Pj2410cGGkPelgoFy11AomwJKiu3sXWGBTnyP
 C6t8oQmE07QJMUnkMNEEQ4L+cNzrZ+4Mwl7O3tR+yaSZPtZbhrYacPPLZsIr89e5Gulu
 cnfbcf+6T5sbrx1aZjnmY8M8krSXpynhohcj+xsxLLMlYPAtXRae4LB4x4Zz15/mXp/V
 Al+V8I+ND1wo/83seae+QLxhzh3aT+HF03R1M8fFttXQpZRWXDZEDF4U7uPM2xS77HnF
 U4k3DtC6iRFBMp86g+MdTotCDoE6hrkw9QjooQVFlinwsgde0Zn/Z7vtVGgfMS0K7VWi hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36ugq3fk85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKA8Nf116661;
        Tue, 23 Feb 2021 20:18:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 36uc6s80a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:18:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNBA+HpHAjNKUMcOTqxqtmA3OcwMbohv8d+EZRMbzZNXj4E9qz3993lWSbGKJ5+s6YP10Mk9R0U7aw/IAOUAwrp2N1Nb9trSLCXQ93FnM0MuLBa+IoRS6+yK/afFpFhBvORV0c3xhy7F94P6loiU0A29cyTP0eDqL9xsXyc19J1NIaVWtyi/6Jp0b4VRddlfLX6u62pmFZN81t4MsIdRF1XckG4TBOh54l3mCGVzT47sTGQkrl0e6WAZayCg/kdN+r6Gexd7dWTYTUMl745qAZOgwqy7a1L+cY6lf232onYbuZDmQAPT01Q3KH562sPVXQV0E7Zdg4k7lTiGf/9wVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kko7VlPTlI87ybN2wOSZCdOAYh8l/wuiqXk2MAXX7qo=;
 b=OBCYOq+zWOxV92Di4vTvED50tpM5yLzqCq/eUQZYE7ywVFhDKaKGWawOr30mqvYSJ+qHq5MBpO3yr2I4GxTPfpu2rcAAWu5SzyNYI3vjA0n2kNnvOIa8/NhSsQ0oqCdCf7madVIvnT5209lpS0e2nS22M1B5zBakNysJzkuCOwG6Ew+cI9a3Ty7gpvJhD4HWqkBYOfQRG+rWyYl6xOz2SSCkYhRjhLEwYCLUX1wyaV+ksnWv89gmkoly0PJvAfbYYNozStLUl72IccPgLZvYwesmG6PortLCxl2LrfR0erCpj2yzA5HdbU34jghPLBW0E7bqYXp9sIydgKCuZeK/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kko7VlPTlI87ybN2wOSZCdOAYh8l/wuiqXk2MAXX7qo=;
 b=BNvoLXPet7YpX0zqBNR/iZ8RLxRiDyw1NzKUV5FtmTOAeCbaa5XieGhJW10an9+KvepgZc8zhCMXF0o1SwrLPNsL+iO2BnjfCt5yK+dOj4Ltp+s8SNY/wMKllpvUcXVFQoojffU80kWrKgzp0HaVBPfiBVW+1euAX0pwPWeiaMo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH0PR10MB5211.namprd10.prod.outlook.com (2603:10b6:610:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:18:18 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::ac22:3fb8:8492:3aa6%8]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:18:18 +0000
Subject: Re: [PATCH 1/7] xfs_admin: clean up string quoting
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
 <161404922408.425352.8871380789546968040.stgit@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <17680305-b691-970c-726d-ca18a8ac3199@oracle.com>
Date:   Tue, 23 Feb 2021 13:18:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <161404922408.425352.8871380789546968040.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BY5PR03CA0028.namprd03.prod.outlook.com (2603:10b6:a03:1e0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 20:18:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b31e6c64-8d02-466d-77a5-08d8d8382848
X-MS-TrafficTypeDiagnostic: CH0PR10MB5211:
X-Microsoft-Antispam-PRVS: <CH0PR10MB52118A28B12F1B0C3B90E5D695809@CH0PR10MB5211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1N5PxVT09Nf8fiXJ1fUjBldkGUXnSSzFFk0xe6UkQEB46yfI3Tz/CyZbszfFlFCJdqfA4nVz/5cWJJoJvU8T+fKMG0wu+48QeLcQZvz/alTnAkT4tIe3GFvXzEkO5FTJVEKAfa4k17uci/Ow/6iWzASzUX7V3w4OlKOvTnvmiAjXQOopVF+lx6VHuVsjH1LPJ7VNxB8QfQ+dJZUZ5mIUTTTll3wIXLUbR8rNdwSF2WLExtO8trQWcbT4U4TI42WDYvJocCPShoCKsE+RkjhK/FEFgRcbYkYq7gWaNUPsZK/aU0U/xv+xJ9CT3XXNq13XcsmfO0DAkQe6G/nsZAa/fUhLRgFIuZ5E5nXec/fibX2xkQvMxhOHryxUqRvJsD6K/xr539Y8zHlWuhiCD/sGQ5YUL6pmd4vVY0dxeC9O+trgz7PJDBkyWCr/pJ34X2iHJwKAB7RBZw1AJ+Rssu2bZwtFMxLiZ4XRu7P3XFwlkFJp69Gzk+kRBlK4Gy6iL5HJEDAkxuxA7KPhkT805UqMWr/Ry3tyRMZOCSU1mxL0z2VH9FarDReSSkdAtB/bNq2plV23nLzyzhW1qtTSdqrPlFMcXTrZLvtrmQ2C+QShqfY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(346002)(366004)(376002)(5660300002)(44832011)(8936002)(66476007)(6486002)(83380400001)(2616005)(186003)(26005)(54906003)(2906002)(16526019)(36756003)(31696002)(53546011)(956004)(31686004)(4326008)(66946007)(16576012)(316002)(478600001)(8676002)(66556008)(52116002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RzRNYnlGNlAzcTFHZlRwK3NBV0N3bFhEekhOWDUwaXN1bXh3d01ZMWN1a1Bn?=
 =?utf-8?B?STErOXVEc0xIQkNxMExtcUFVMTUzd2tFTS9ZRnoyenF4TDZDOGRIVnlpUHp3?=
 =?utf-8?B?THlaZjV4V3Ewd0hyRTlyNVFQSG9PN3NsNTNsNEYvK2pGYVZPSG4xRHBzU2Yz?=
 =?utf-8?B?VkFTdzRsenRtUFNsUTI1cWJGVzgwanI2Z2tXd091Zk44OXd6VmMxMUtXWkZ4?=
 =?utf-8?B?S0kyS0t6Z0EwN1dPcVVydjZnSlNEV016djcxcStVb1poOFRXdm51L2loRGZO?=
 =?utf-8?B?S1llaTR1a0V4UHk4UnVNQitJTVRvNTZXRlJxenh1OU41N2MzazR6aFJYQVVL?=
 =?utf-8?B?R2dFbU9QOGx3YVVMYXF3OGMxYWRtR2xHVWFKWktMK1V4ekdpaW5pVWVoSXJX?=
 =?utf-8?B?MkRsVnNDSk1heWgxWTdTcjM4bENtQ0w4aWN4YVJ5OG9INWtQV0YzMzZpRk9u?=
 =?utf-8?B?dU9jUWhVc2VLaXRFR1pFU0QrKy9iTUtvQnFOSXB6YWd1Ym04c21JVWVOTFRN?=
 =?utf-8?B?RHRYM2JYL21uRzJlNVdCK1dsNkVJMyt3TnFyRzNXM0dUQzBrYTJOT0JWWk52?=
 =?utf-8?B?V0VBSDFuYnFwTDlvZDl6dmtFdEl5Zkp2cjVXVUxRYS9rY05HZzlaSDNKb2pT?=
 =?utf-8?B?NktKNWI3UFk5eTZWYktBYzhhTndaajduT3p1bTl0TlB5cHFpZ3VVTFJpOVVP?=
 =?utf-8?B?UWxNVjRlT3EvUUJJNk1jeHVsR2wwSUdNbExzd1E0WWRVeW9ZbkJFd0pwZFBF?=
 =?utf-8?B?R2pkbVJibmlOanVNeEM3b0F3NnVrVDFCYTdEc1JzTHh5VWhBbkFteTBwYmY1?=
 =?utf-8?B?cEJtTHVIMjlSWGxaeXFRQU1ZVExRcUl5VFpWbGpMUzBZMnhSdUtTUkI2U1lr?=
 =?utf-8?B?Q0V3N3U2Ymdpa2huYmU0dmxHVjcxMjU0eEpyRjFMYzZRZVM1V2I4K3Y4N0NM?=
 =?utf-8?B?MVd3WDRLYStwNWVpRWpFVTNBd2NUUWZMNk5mOGFyZTlXSHhPQ3dkanRqUDJ4?=
 =?utf-8?B?N1M0QWRab2Rva2FtSmNhbHRzSTdDSEo5UzdyZjdRZGw3YkQxWHMzbW1zbUxn?=
 =?utf-8?B?U0VjWDZuaDVKZDRIYXB1SWtNNWxReWFDbzB0b3BnR0F4TDB4YnhPYjA0MUVi?=
 =?utf-8?B?TmdWV21lYWk0ZDVnUGxVSE44cHJSakRGa29qdGV4S3ZCcFZCN3NGYUdrS3NJ?=
 =?utf-8?B?L2grRklHeHprb0hqaUR0UnF6bTVBUlpWTFpRemhsMkh5cCtneUJ4UFV3US8y?=
 =?utf-8?B?N2t6VnVtZzAwV1AweDdITjg3N0orSlhSWFlCa2VTSE1QQStOeGM1YU9UazF3?=
 =?utf-8?B?RlV1Z1dHN1dicURMMnhla2ZveVI5aWlVK1FDMGk4M0lYYXR5NUxucEV1Zll1?=
 =?utf-8?B?NmdZTlB1ekdkRGxxS2Z1cXRtcnljK2RtSGFEZFd4QWV4eWJBSDdWNkNWbU9h?=
 =?utf-8?B?akVGanVveEVVQ2VQQzMzSHFXSHhJNnJPUUxjQU9rV0hSZlpTUklUTlZ4akRs?=
 =?utf-8?B?MU1LVnN4a1J6aUF4eWdKckFlcDRMaUpTajJVNmgvWTZkWDZkOUtMRjNkQjdn?=
 =?utf-8?B?STVxSUVQUURqZjJmZmxoUmJ0dDlpL25EU2ViR3JMUFg3OEhndmgwRFJ6TzlQ?=
 =?utf-8?B?ZjNXSkhnVkl2SVhrWUdDcSsvdkJtYm03WHluRDNNWUx3RHVQVkhjOGhMc2ZB?=
 =?utf-8?B?M1ZLR1U3RlgwSEt1a241WkJMcGFDKzB3dzdXNjRpZXpiWVN0eVRHOFBLZ3p5?=
 =?utf-8?Q?zyPjbgbXABcztBILD0GQvqfbZOlwNf/Dw3C/8lI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b31e6c64-8d02-466d-77a5-08d8d8382848
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:18:18.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uvM6Zu0qxjHniRYdzlzI4ADpPo4rqf5dcU6Wl9z16V3KPAFRoztQ2Og0Snr+EBEK/xy1udLgRB+bYZxrlWYzUv2FzmpXp1RM4yavomaVMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5211
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230170
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230170
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 8:00 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up the string quoting in this script so that we don't trip over
> users feeding us arguments like "/dev/sd ha ha ha lol".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   db/xfs_admin.sh |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index bd325da2..71a9aa98 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -43,7 +43,7 @@ case $# in
>   
>   		if [ -n "$DB_OPTS" ]
>   		then
> -			eval xfs_db -x -p xfs_admin $DB_OPTS $1
> +			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
>   			status=$?
>   		fi
>   		if [ -n "$REPAIR_OPTS" ]
> @@ -53,7 +53,7 @@ case $# in
>   			# running xfs_admin.
>   			# Ideally, we need to improve the output behaviour
>   			# of repair for this purpose (say a "quiet" mode).
> -			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
> +			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
>   			status=`expr $? + $status`
>   			if [ $status -ne 0 ]
>   			then
> 
