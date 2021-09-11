Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3426C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78CB6103D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhIKONL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Sep 2021 10:13:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63404 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235941AbhIKONK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Sep 2021 10:13:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18B3vX5F032093;
        Sat, 11 Sep 2021 14:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+qguIJ++Kp6EX3iiSXyqib++8DjNILN9Pdx/FqZ0jEY=;
 b=PGsQxxR/Vprz03d8mO9OMKuqA9JGuvryX5qAz+xz0cQxV7UzBqny6lpEa1nQNnh6fWWk
 dxx0LlXBSv+uEUj2IqxDDwMnrYUnXxdAUBZrzHG8mX328kxc+AJGARh6Hdznr1TmcD60
 LIoByF52ibP3UsHhoLfq3fFdOMePgTe6bn/JsvkdStyNm1LCTu3r+oIdVjog3QfHU1uL
 AobHfLBOa7ykBiwLiB+JM2XHMA8VhtsLbE/irKeDnErlpVPi+blvE/BJ4IakIdjhh5HL
 vojzrgTUFn0SNHEWOzq3/2OOx2FXg1RO8VuPSa9skzTRq3bdadHWqYvEPSopwuudtqEy Ag== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+qguIJ++Kp6EX3iiSXyqib++8DjNILN9Pdx/FqZ0jEY=;
 b=BbCFmXNVbA7pqQ1DK0XUvc2h3nC0Y1q0mspDgiJNIumfbFh7zPDscSZ2V+b9Su7hsEhc
 fEIpQ7WkUAvNXFwqEnEcjSSuOivHt2DhAb4VB0jR+zpkcmmdStNSeWxtuEchglTH0p6o
 Ur3pWznIbJ7KvutKc7tkuHyDnlRuIQROrTyUsZV/wh7/lJZACA9xqYZ8rUEuMAzPysbo
 nrB/W78NhQi976jTIi0KChopTR4TWI/h3e/3NMgH8qi+DRec6Zn6EBTutnlXV2TiikRM
 PcnGM9rKZ2jP25loWOB0dSzjiHsSPWA+L5DsjiSSCCex09WgtDmx63WjN3W7fdYxF+HA bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0n0trgb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BEB0wM130558;
        Sat, 11 Sep 2021 14:11:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 3b0hjrrj6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BppvogRWCb0ND3PquuZUqAt7we2iGFI9gHrj7A5y3QHJSTcQFbri9cjgmD8gCByAnjFe36UPR58J3Yo2YIgJr1rW4yZ1GFyYTpZ970USFHlsR5kJdjluq52xbeWmHDh44XDIy40N2uWYAt+cqcSf//W6z1/Obo0DUgc/m4/coK2xBfz31qInkwWqcPCpPafuLM3s8gsrwIXKHd0MavoQ05uSY4YLOeZE5Frl+CbsZ7GgmGkW64ZKaI1cIXEcctHSIMXdOce+59lnFwhq6a7MUBUdq2CBQRSLv62lidnBkzOhI2y/w/+a6ODIYDfrumPTXlidW/1qHbTL13RkJFVnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+qguIJ++Kp6EX3iiSXyqib++8DjNILN9Pdx/FqZ0jEY=;
 b=cnFe9lmX6aSxc+pbWgtbdC2KRa75JxDk5jyDkQZIstVmo9URA1KkN00oGCYhUeufzTHfnPU9N55EzbjPDj02SRD/G2kB/+XV5IT2d6sVMLZ5yO5NbMnqrAxViMzF+tyG0PAPDi2txaTYayHZbKJZqiSdsQIyDKiT+ObUkPkED7S5uQZg+LhTBtd+LXL95qlsqgPU/0Ndbzafpa3HWmiNRnPyn2IquNGVTum9og69XsRUMaIXMtYrUPTkB7etQEDIb+uMKn0F8HP9UPQ3PZ2qG0yVRBxiTNn20/ppj1qzASOLxrK2VMxNnxdZQBWwP2v/NYtbPi4ExOoCBtLAGPxqRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qguIJ++Kp6EX3iiSXyqib++8DjNILN9Pdx/FqZ0jEY=;
 b=UXWY6aaQWpzwHHd8Y5OHtYyjDN8OnBNGOTw3voQSGM3tFcmvSCmdt/cYozW5kBhV7RAzlJBJvXP4AgMVEOTRQrAtzQopRkTDAiGRUty1oEqNg79Ywp5HKw2237gEGE611wZ6Y/rck0iXoaCLHqlpbE26smwAUqNJ5a8E01QDdxE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 14:11:55 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%5]) with mapi id 15.20.4500.018; Sat, 11 Sep 2021
 14:11:55 +0000
Subject: Re: [PATCH 2/3] xfstests: Rename _test_inject_logprint to
 _test_remount_dump_log
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
 <20210909174142.357719-3-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <c2203940-699c-a0ac-b0c5-2007188d5e34@oracle.com>
Date:   Sat, 11 Sep 2021 07:11:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210909174142.357719-3-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0133.namprd13.prod.outlook.com (2603:10b6:a03:2c6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Sat, 11 Sep 2021 14:11:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 532ed2d7-daa9-4990-2f1b-08d9752e1c01
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB429012BB0462D4472FD7849595D79@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzZ0wEDLEV2/Q7M2w1hUd6ATgQLxtp+oEqfeQ+7N1zO+hPcFA5MjihGPse/OfiwXzIZ6MbWscNZigw/tFTImNEdgAGLYlCw76/TDtDbb3HDddAzzAXYDDvhwn4m8Qvbw4Ra6xXQMLtVie/bNCsHkqA0HdORlPTjYUXnroNFLNnigzLl0P+YmEN6M4fupR8F0Trq/g0JXm+/27guquCY+PiuhpXQJPREgagxS/qYCF4hFhZktZzIyx5eqLAk/cAr5+sodyigDmVCseM78GzVNLfl76s0l38YV3v9OyhmA5lBleEZnzgCFsYmRQp1/NKOlGVw+Tf27Lhm+r07quShfKzX7ywcG0vBrxCgH5zvGRlPWjbCs1MSfIsB5RZPt0xomPej6JnliK/gELl6NZDzJb979fDY70mPeL36erlxM50EcUV0vcvsPxIKKJBweRgYtHzfzgVRh6kE+2OJgQzLyxG5qtbDTnlgKqwVWB+rM1xLwBys2lqa15lide9nzFDN01xYQK9YqGilOdRWPItsRLibTZ027XtYKAMwgRMTnKlZQQfP5LCaCogyFc1aHyp1auFQiQ3SX78v/cZglkqf5BGN3vco7hz0SSKsPBG+XOK7/+RPPaiCBRx4oFFXaUR0Mh7l8SUYBrZj3UU/BzaYJ0qPDMQ2X4rJYVOdu28Qep3lVkpeXeJJA9dj44MP078CZ7kHE24aJ2s44IVMLfSmiHBzB1AFD/BWOzYOQLoOR9xge2aSpHJ/F3Os67lUqpdkluyXtZlu9WTi3LFMwVsbERg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(396003)(39860400002)(8676002)(66476007)(316002)(6486002)(38100700002)(26005)(31686004)(450100002)(16576012)(66556008)(31696002)(478600001)(66946007)(8936002)(44832011)(4744005)(53546011)(83380400001)(956004)(38350700002)(2906002)(86362001)(5660300002)(52116002)(2616005)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0s2UXFLb3VPNWJUUDhCRTlVZW5GMWNVU2tFYng1dkdNNjRrT1hpWENqMVhU?=
 =?utf-8?B?WGwrYjJSOWZvUkZMeHpneXkwQU1vQ0JhRHFRQ1ZubllCdFV1aGNJcmE4UXE3?=
 =?utf-8?B?ZjlVRTJBenZHUEZValF2NjNHWmpOV1FwZVFhdEoxdU1FOWJxL00wODY5OFk0?=
 =?utf-8?B?RU5sSSsrY1FabHQ3TUVPQVNxK1VHMU1pdzd0TEZudXp5S3lWQ1N1RGljSEYx?=
 =?utf-8?B?aUtJZmdmMUdpajJFNGQyaEh2aFJnazFZS3p3TlpBNnpBTFlMakh5QURwMC9W?=
 =?utf-8?B?RE1oK0pleXlTQlh1dk0rSzJCY1FHMFNldlE3QzVhRUZ6TkU0akx0cjdKeWY1?=
 =?utf-8?B?eU01Z3ZFenlBR0ttRTdOZURmVlgydUZ4b01ERFdObVBWc0R0RHBHU251RzdT?=
 =?utf-8?B?cTQ4UmxwVG9zM2gycmFBZVNtcmhpd3k4K1IvKzlhU1FMRVo1b1l0NmVZNndK?=
 =?utf-8?B?dzdnRlRIYTRuUTAvcFhvMEh3RG80WlFQbkI2V2dPOXhkNWs0VVEvZXBtRWwy?=
 =?utf-8?B?M2t1bWplU3hrVzg2MFlKc0RYQkhuM253ZXQ1TkFSQ3Z4YVZqb2VmaElVMkRl?=
 =?utf-8?B?VUZyOTdwWGk0MkNFR21QTHFOVFBqTWtablRrbzE5bFAwRGRjQUtNVFhkaUZM?=
 =?utf-8?B?Smo0NFd5cVZCd1prZzIwY1BKVnNVeWMzemJoQkc0R3REV1pONWR0RzExMExw?=
 =?utf-8?B?RC9ZT2lNdFFjVEpkdzExM25WZlpadHdMSGpZN3JOTFU0eHFkRUhRZUoyVmF5?=
 =?utf-8?B?WkZlTjU0QStaZENITHVnTVVrYkxPTUdZR082MXI5S2ZURDc3ZXlOSlhPbEhJ?=
 =?utf-8?B?MlpvTVo1ZTdpRTJGeEt1dFR2OVJnUHlKZ1ZmaXVXTzhVMEl1ei9GaWd1bjFM?=
 =?utf-8?B?NWl5SUl4ejNqKzhYdWgrMHUxemlXVUxabEN2NEkwQmwwdHF2WVJUSnRuTlJh?=
 =?utf-8?B?eGtOZmx4Q3VNMmtERE9zRFd2S3N4Q2NiSFV6NWxLa25vNFAzWXorN3ZLNHBR?=
 =?utf-8?B?enZ2UjdvVmVOT1BFVysxY0VkWEoyZ2krb1lValZlaWxMcEJZa0pic1BKSUNH?=
 =?utf-8?B?Z2F2NE43R1NENU84WkpQVnMybEFVYm0yTC8wMVdFSlAzR2NzUzRMWmRhK0Vu?=
 =?utf-8?B?Z3lpdnNUS2MrQXhiUDNHdHAxK2VjTEZUcXY5cXR1WDdtY3ZoRnhPc0xWaG1x?=
 =?utf-8?B?ZUJYY0xmY1NjNWgrcFdLd0NoS293bEt1b2RMWDZmLzJKNUh5TklYWFl5MjZx?=
 =?utf-8?B?VjFWbEFGQU9tM2tXTjYvQ1I1VWludWt2dTI2ak1vRlJiNE1xMUVOTFZXL2VV?=
 =?utf-8?B?cWNzcVYwaHNBUW1YczJFZS9qNW5CRU00d1FRTkV1czlKVDZsOWRtZnVicGhm?=
 =?utf-8?B?MENNWStjTlM0WU9mb1IyZVR6TGp3bUhGOE1aU09PUEh0ZktHaEd1anMzNzA2?=
 =?utf-8?B?cGpmU0dkNWlwN0hLdEoxLzFRZ1AzdXRXRE1Vdi9JYVprSU1UUWNXRmNnWGZE?=
 =?utf-8?B?ajB0Z0oxcHhVT3hiS3ZZMEdNUkdNOVFnUjRUZFRjRHF0VCtZRXF0Tis0ZlRD?=
 =?utf-8?B?eEhXbHN0aHJ0c1diSVd5VFo2N1VTWlVETk9KZ25FUmw3aGQxTnIzelVoVnpX?=
 =?utf-8?B?SzNMQlNud1h4d0xBYTdhM1FISUxsaXhCWUN2bVJjUndXYmo4OGc3enlMSlhr?=
 =?utf-8?B?ZTVXVmxDSVZvVS9sRTVjU3ZaeWQ3ZUZPNDlwRURjR0QzeHJpVDBxVG82QU8r?=
 =?utf-8?Q?iqdtOwMen2/YGLFo6u/3O6h3FaiAbHvK55p4vQG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532ed2d7-daa9-4990-2f1b-08d9752e1c01
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2021 14:11:54.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ahb33hLSaWmJ5RhxoRYtnqbL7LXMuSgUhZ29UJGECFo/nbOU6O+eW8FUW1FEEGl1cDvulnpf8v5/ozAvKKuDKYxf4tfLP1wOQORGe6BZYfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10104 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109110097
X-Proofpoint-GUID: OoDvBePpupbH0xK3Qygw5TqCsjq7P3KW
X-Proofpoint-ORIG-GUID: OoDvBePpupbH0xK3Qygw5TqCsjq7P3KW
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/9/21 10:41 AM, Catherine Hoang wrote:
> Rename _test_inject_logprint to _test_remount_dump_log to better
> describe what this function does. _test_remount_dump_log unmounts
> and remounts the test device, dumping the log.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

I notice this function has no callers, but I think it's a good utility 
function to keep around.  I think it looks ok.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/inject | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/inject b/common/inject
> index 3b731df7..b5334d4a 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -126,7 +126,7 @@ _scratch_remount_dump_log()
>   }
>   
>   # Unmount and remount the test device, dumping the log
> -_test_inject_logprint()
> +_test_remount_dump_log()
>   {
>   	local opts="$1"
>   
> 
