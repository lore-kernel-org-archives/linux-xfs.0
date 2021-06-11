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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB6DC48BE6
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12A261364
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 21:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFKV5V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:57:21 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45516 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229777AbhFKV5U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 17:57:20 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BLlY7o009761;
        Fri, 11 Jun 2021 21:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VadF0wDHxbvWj8dgA+GnnrRWAoBmEP7fW80+WfKmThQ=;
 b=aAPb98zc5UyexKZK7htfQOvUphyTG/l6KL5wBtAuG+P5aQgNPjcpd44YskeUnEAJ+EqR
 R7jNlcUVSS3Sqp0jD7U4XYmXsrvmRcvndwVQL7vgB14uDtqnhruEOA3aOrsmDJjVpnFD
 181Wf9ff4FmgpzhH8TguaS+sSTh1ZctmwT3PSTJRqXXxyt3EvAvSqBdP63jZbhbTDO2N
 j5R6JFSDilbGT12wI+S13M0gw9+xSiFksZy17ZvOpI43wqEZun1Kw5kwuLBydRKyJWra
 ODTKhEKD2L5C6r+PeKWMrM9A096BI0Me3KMRPa9p9RgVDsjdy4ZfkFxkk0bOBDWN6Pak Dg== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3944a1g7fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:15 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15BLtDZJ156187;
        Fri, 11 Jun 2021 21:55:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 390k1u9e3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 21:55:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrHH0uMn4zw+D2+Cggk64X/hh95i1HB4tBI8z8F+28RZ/lkauKikACdUw/sOClien6v/IB5Jnp7bqGl70DFT2S3SuP8JW6LudshUuZJNo5VgnjYgf/Emg77kJ848MZxQV0sM6+x526jLU/oZI/E5gWu0zUr5+RmySrcMuVNRgbcG1lxFaLnhyYmkKrKDV6pgGYZNpEBYyZ8lSlnA6EZ6I0nPw0vyddottXU0/xrifG48F0LCHw/QOq8f+sCnm34cXA55O6kBZjVIfUvWtubTMrFhPX9v7UZh+KwoQ/JENsU/JlIwEJeGv3I8ARCroyZYkKkHCSdoFCw7S6fVrDN2JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VadF0wDHxbvWj8dgA+GnnrRWAoBmEP7fW80+WfKmThQ=;
 b=YrPOW5bFwTxqwGCxjzJUpEbKFMN57bfLqazVF6GaEy2MnH6weizDRdieTbNwoZ1g17jaeKoD9hSLIIlDTAjErKj2lToLjDish/dhPomfpekubyD72znXpZyGWVseUKcBtmk8deqz+NZBEB0/qWClYL958EUVtGox2N3LEJ1PBfWO5YQ4k8GyOWPSoWlTIU8YUZyL2q4+fwAN2MAyn7gqbcmxUoLZXo5wUw67ZGS8ym3I+Hk+vamTtuKpPT0Hh9cAegLoEaweKZv88HLyDToWibCnzKh7p97EtWR/ieyUeuaPoqBcDTgSHFOHTyC+49hhRqtzLVEBrO2pw1KziKnXvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VadF0wDHxbvWj8dgA+GnnrRWAoBmEP7fW80+WfKmThQ=;
 b=Xn1+dKUOOpqyk+XUs0KjZ515DW+ZUuUPumXSal9RqyKH9DFkANFmhRVIadxjyp7uMqMipXxIgWr+Xx68lJpiMqiu9RtJ1E1encts66Fd64Ih88LA5BI8aYNqtcyAD/DZR6bSlJNlJhIUzs4S/wXR/TEvjfqCTt+rqTcvKifSr+8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Fri, 11 Jun
 2021 21:54:59 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 21:54:59 +0000
Subject: Re: [PATCH 01/13] fstests: fix group check in new script
To:     Chandan Babu R <chandanrlinux@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317276776.653489.15862429375974956030.stgit@locust>
 <87zgvyp0sy.fsf@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <591d650d-6f71-84b8-0e3d-bad84f3f2817@oracle.com>
Date:   Fri, 11 Jun 2021 14:54:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <87zgvyp0sy.fsf@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::43) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR03CA0030.namprd03.prod.outlook.com (2603:10b6:a02:a8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 21:54:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73ce8b04-2695-4b08-7db4-08d92d238e84
X-MS-TrafficTypeDiagnostic: BY5PR10MB4164:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41646BD05DD53FBEE00B8C4995349@BY5PR10MB4164.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1zeXUPSKq2rXbdms9EnzGOGuM1tJQInEFqApf0vWhON+N065JRL9CqFxsPems8IfwX8VX1eE7DFWJDjbj3Y6D0PW5jrRJokR7uv7FgeDQSAnmekXmoygNZ5233ujb9EmQhehGAqsc6+8kjh8zK9PDuwcbpQJh1wdkyFJTVoeLClAqZbDT1CjWABptWttwhQZYM4qYzos5gJ/Kinsq9pkspmqJthVfQDOtQ6jH3Tcew/jWcdwi+QOlzpRwVhEn3oE6cDdNsXYZIaYq3LDwe/Zcyzsg0VOQU+JxUH81+T6g472WCwpcamPjKOmSj/wCbfm/XME4DP9/c2raGTgQ6JCh0w5QiZwK0ElF4xoxl3YgAxck5IyeKWdoEie+Wbjvo4TMfNXxwLHtLHiBBau7s3i83jnoX74HO75MhDsUFDugUXPUKD8fnI3AVk2y01k5WNQZqAXS7n4MUprEXvyD2HsTYtR2ZDyrqLGKQ6pfD2bUFBJdQ++fw/SDLXZ8xim38MFtNKrGzO+i09iavjFozwbLjb6sfGnphFh2ISBQi1X0Vi1QHvY0WFsgTj8kARbj64/ZHC7bq/xWkELVxIz30myLUweXWK10qB39eqFn55vye3VCAlJ7fRP00HaBwS1BXAUuOn4LiGqfs8FoVFdTnNEjuYOyPEOGC5gV31xC/N85rlzwL+x+vMfzHfSRIjxIM1ljVOm7xaIlk9C/NXCt9IjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(52116002)(316002)(8936002)(110136005)(4326008)(8676002)(478600001)(16576012)(66556008)(6486002)(2616005)(31696002)(66946007)(956004)(44832011)(66476007)(38100700002)(4744005)(38350700002)(5660300002)(2906002)(83380400001)(31686004)(16526019)(36756003)(53546011)(86362001)(26005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDNIS2hsWFZ3WTc3QnJITElvdmRJcE45M2VxMWtVc0ZtMmhoM1lkSytubnht?=
 =?utf-8?B?Y0JWaFRiVVc0R0F4RUttNEhuTE92RzlHNDdJTjJQejh0WTFsMDYwM0NtYk5I?=
 =?utf-8?B?TjNNWXA1eDVwY1RxM0JaWFU1UzNPMnlad1ZCWjQ5M1hiaUVzV0VUU0R6d3Rk?=
 =?utf-8?B?RWpKSENQUy9BRTdiZXkyWGVxbWs4NEtlWWErUU44c1hYOUZ6Z1Qya21mYTk5?=
 =?utf-8?B?ZHR2NjZVRCttdWROVjFrUTZOZ3pucUJXUWZoVitjd3Bxc1Y2dW5ydFJtTmUz?=
 =?utf-8?B?czFXY1lzbGhDZGF5RkJURHViU2xMY2thRUpOZFNsbitWb2Q0Q01PZkVxVWx0?=
 =?utf-8?B?Nmt6Q2l3cC94cHpLNHJTYmZLZTB4VFFjWm5kVmxLZjdvREFDblJNemtUeDVI?=
 =?utf-8?B?Y0I2WWtyZjZ6dnQvTURrQ0wzeERkbzVuM3VtbDh4aFIyZGJaQlBDa2FwZzgv?=
 =?utf-8?B?MEdlVTV2N2FnTDA4RE1VTWN2bEFSRGtSaG5BUVp5UnE2c1Q4d2htYUJ2ajZJ?=
 =?utf-8?B?UVVRaisrM052akZOaVRsVHJlZVgzTS9HNmpSMU1CMUZ4S1RVNlc5TGdKbDR1?=
 =?utf-8?B?QWpVWXNHNTRXZ200RjlhUlpab3pXRCtERzR3TTdmNVJEMzBneVpxTXJiMHNl?=
 =?utf-8?B?V0JqZHk1dEdjampNc0lZMDFyWnQyQ0xtNFJxWXVFQXorcElidlNXZ0VYM0tG?=
 =?utf-8?B?SnFIYVY0TmFjb0NoZno1V2U4WUxRaEtobUFPOEZubXNaSW56ZDdlV3NxOHpY?=
 =?utf-8?B?cU0xUWNVa3U2WDh6WHhIMm1UamZCalA2MmMyNHpQZWo1MXRGNk9iQU1tWFRo?=
 =?utf-8?B?ZmRacHdmYVh2cVNPcitRM2JUa1I0MnkrTThGYU1FWkY2WUo2NWhVa3R2dC8x?=
 =?utf-8?B?bnNSSloyVVRLb2FFb1lNK1lrVWVvU0FORDRKcjFSdnZFTWZjUFl6Z0E0RHF0?=
 =?utf-8?B?NmNwTHhnUGREeThjTkh0QXljb1E3Ujd5bHdCemI3T1U5V1huaWhsUzVOYjJO?=
 =?utf-8?B?VVNmM3Y5d2ZreFpFNUliaUxBaG5zK0tDSVVHdExtc015YlhiZjhLc1d1dEhk?=
 =?utf-8?B?bm1mSXlyODhsTlpwdVhKem9vanZCR0R5aXhONE4wS3RTRXlleXpML3Z5QWR0?=
 =?utf-8?B?bnBVWGpNYjdJQVVCeVMxTHhiQUJrL2NBdkhhUlVWU3pDbE5xSFN1dXB1dGlX?=
 =?utf-8?B?amh3OUhmT3hvN1NBZ1k4clZ0T3ozTHdlUkh3bzhwN0hEQjE0TklWa3F0U0dC?=
 =?utf-8?B?NHdQdStualpuQkhmQlVyUHhxcmFIbmJSYjN1WWhDL1UybUVsdWt6ZzhGMkc5?=
 =?utf-8?B?NHNMSzZ3dXBzZ0pTb1JjcHZhdFFjT0FpMlNHa3dEQUR2Sm1PVmtkSHU1VUdE?=
 =?utf-8?B?VEtkTnF2ZXhGK1hlWHpIY0FVaFhyRTR3L1M5TE5LUVJGNUd6UGpxdHgvTnQy?=
 =?utf-8?B?c2kzWFNIcEVndHFBY0lxWTI5ekdTRTFiNklrWUtjd1JDNWlOWDZhNzhMU1h6?=
 =?utf-8?B?SERMV3phYzZkTzdlb2JVa2tBYXVEZ25hNWtNRU9sdE1OUlVnbW1Zb0ZlYzZp?=
 =?utf-8?B?UGZZQUNhVGJLb0U2NEgxYjNTQjU5akhGb0xNV3JjOUxHRG5FN05MNDBuZFIw?=
 =?utf-8?B?b1RXbFhFNG81N2J5TjRNckFiUFVzVHp1RGVBZVlCbzNJd2FRa2owYUJFQktj?=
 =?utf-8?B?OUVDaHZvYzFJRVBqeGNHVWZVSC90bWNOOUkrTlpTTVp0cVJFVk9tVzI5SHZS?=
 =?utf-8?Q?4Mgm8rt+rMxGqAeP+rrK1424ZV2M3GdzY+hMNQF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ce8b04-2695-4b08-7db4-08d92d238e84
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 21:54:58.9879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXDIeMD6eufWzVpp0yar/OmoszvWdOoOp3Pn4E7pxsNhAgTFWBK/cKPQQjeZOzZmWaMc6kC1kZQT+2LRApjqRn4Bt5FJRsQu15JKA+1NBZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10012 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110137
X-Proofpoint-ORIG-GUID: G-qwYPv0NDdpLj9HSTQgo55Y7QBj62Ge
X-Proofpoint-GUID: G-qwYPv0NDdpLj9HSTQgo55Y7QBj62Ge
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/10/21 1:43 AM, Chandan Babu R wrote:
> On 08 Jun 2021 at 22:49, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> In the tests/*/group files, group names are found in the Nth columns of
>> the file, where N > 1.  The grep expression to warn about unknown groups
>> is not correct (since it currently checks column 1), so fix this.
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

>> ---
>>   new |    5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>>
>> diff --git a/new b/new
>> index bb427f0d..357983d9 100755
>> --- a/new
>> +++ b/new
>> @@ -243,10 +243,7 @@ else
>>       #
>>       for g in $*
>>       do
>> -	if grep "^$g[ 	]" $tdir/group >/dev/null
>> -	then
>> -	    :
>> -	else
>> +	if ! grep -q "[[:space:]]$g" "$tdir/group"; then
>>   	    echo "Warning: group \"$g\" not defined in $tdir/group"
>>   	fi
>>       done
> 
> 
