Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8818C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6890F64EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBYGUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:20:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43996 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhBYGUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:20:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6FMJw119762;
        Thu, 25 Feb 2021 06:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3bRVPyx8cGAVAotGDLgKeW04B/Gw978CEb3aQaf4wwo=;
 b=wDJNVKFokCJNDByRW775k2XGngNFmZw9WH8ZnhZVPAXtB3rGGpdwom5r5DXC0rkhKFpi
 7zpon1HJv/7NF4q5szk8ILxClLfmXMBj6Pk6hq2BScB7p3POATlfGq5Obl9e/zn1JbS+
 M5u1r/KsuTXCsDrB0yUqoM38D/PhxWYuiYslhqioIMwsTrNxeCXBXZzG8iNIOfm4cswt
 Bog2LyhbpcdOXfjMGZzirIkbstZGyINgJQfqVhMpgFpd7KmJyP1FiI4SqwM4FyvAG8EM
 uFfIEJFXHFaZHP1Z/JHyO9zsbrMxmNHi2+WtDOTqZYg+gY9VkBTrxtYYrSJlWjLbNefs sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36tsur5byx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:20:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6Agls184348;
        Thu, 25 Feb 2021 06:20:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3020.oracle.com with ESMTP id 36ucb1mvfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:20:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ociA6mi1ts+821YrYBZUxO+eJ/G9t9DUfoKsXiuZr6UFIwP6f18nkc/u3SRkaVJuCw8Q4wD6sXFIuriHSfNFCs/HvWF/+grXvtJ3SKakuXWB4lKIN9/J9rwtaMAfx016+dazkL9L+ckQCfWND/EHuwK0woAzVwv1HualLo1zK+dAKvwBBGP/v+8qKd7rfeMu0E6d5qYF70Ifgv8MSDLS4XjUyU9NaALL4QYgLBNOUhy1xMsgSAW+WHsHJtHwx4oA8NYlrVGxIRBnYmSyKgiCdh87GGMXboVSysEZCGgf2iTbxdHrG30uQaJPrFIV69wriqqFLFof1TsTA/XiRdB4AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bRVPyx8cGAVAotGDLgKeW04B/Gw978CEb3aQaf4wwo=;
 b=aEUwkN23GKHyO4OlU2hCKTNp0W0em5LjinsZW7C7KWCoC7cVrYcjV0gnNPBB3rdamcIESwYeLlxh9D2S9HEUDouCf7kld5WmiIkxYnIU1xrPDjfPidptVfVGVHctmREoGz2tiJITDoUp90EkHvEeMUKfM9EUf0BT/BH3dc2JbP8czgbgqM9UaNI2Svst/9v1xv1LZYLBE7KOfSoyrCxstrpKy5OGEeBVb4EWBaLE/lN4ovV+XCxmlzKLAqmOyTRwp0zS91h7ssYI/wK5+kxlu0fgXSoQmiga+1OwMYDf+KfGb89wxUvwpxIHsTo6qVaItwK68xQP+EGPqeZuMjQTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bRVPyx8cGAVAotGDLgKeW04B/Gw978CEb3aQaf4wwo=;
 b=EfaH44cTajNrY5Mn4CT2D6JookojB1xiGdFycRYDZ5JKG7quTjCgDBnvbb7fv11HFdEvUEgoQQuoSVMEM2XvFrwSRLty7aGby7GrkToMG+vjExrCMsfqNPvoVzWPVgYbIH3h+ienHYW3YdENzG465bYEdBsBSBaKDrfdEELr4Kg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Thu, 25 Feb
 2021 06:20:05 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:20:05 +0000
Subject: Re: [PATCH v15 10/22] xfs: Hoist node transaction handling
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-11-allison.henderson@oracle.com>
 <20210224184328.GK981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <857652c5-df14-8406-1e5e-3853c631e1ef@oracle.com>
Date:   Wed, 24 Feb 2021 23:20:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224184328.GK981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0139.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0139.namprd05.prod.outlook.com (2603:10b6:a03:33d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Thu, 25 Feb 2021 06:20:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a37f5dc-5918-4169-d49a-08d8d9556474
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510A8F3E0FBEF97EC9A923A959E9@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aRJ4PSAikUhyUMRPo9bkpJgxfFwL6ta2WyTduBRMvSB2NxTvIqOWh5In2dAFwLm9r4XkH0T9Hz9TkuiIjJT5yuISWNfo1EecPsqFTBsAVxE2DeuO+RC0HJongHKFsGcNzXXb4iCPvaGaSWdkp6eOPQRlgGcXaQ2Gqwh8HtiAVyQ/cpxRjRj2ncOb0nCEO5kaTHvQ1lIfALU3Hs2f4aMYI0sRsTnenVDRWM4VmlHOzTNRn8uGI+3nfi5GFroi3sXQeGQ3K3Xeh+vsXFM+51I/dm0kb5gaWZcCBT59jWSUAREnN5dhTzPXF0L6inEZKshef/z4DNoPxz6qFM0yiqLxnEz+Q4Hi0NwUgttbcq7yO9w0X0FxhuQcJWA37PUS5q+BzsRJRYlLI+C4HwnOsL56shXusHEkIn5qKMmb0VGkCAlgKEmgLNG8hW+/IV+yXzlGSyRK+7TFEgAprRZ7FU+Tf5sY7xiehsnO+xfAO4W7Z4z/qGB8lmEiFJ/5CKNiNsM02vc/tS/+VT/uYKACTPWJBCZyr+CRVOPrUjGVgxFwGSLs8RGesDFMBPS7kLDZ/nqgRmV2p2ZVEaVdD/OHoz8PhpLWqm8J4kutOC+8yeNCRhA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(366004)(39860400002)(26005)(66476007)(6916009)(52116002)(8676002)(66556008)(2616005)(478600001)(16576012)(83380400001)(86362001)(2906002)(186003)(6486002)(5660300002)(36756003)(4326008)(16526019)(31686004)(66946007)(31696002)(44832011)(8936002)(316002)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0hnRHkzYkkyTWxDcWtleTJ3REJvWUpPaE14VUhkWkRPVDZSREx2VkdGajdJ?=
 =?utf-8?B?ZmR1c2xjSDdiNlA5MkQ1VjJPK3lDSUk1dHRERW1keDNLTlFSaUtpYnU5K2Ex?=
 =?utf-8?B?cEZBcDdLQ0FmZkVHQnFGUlZoZWE3NjNUeWNJSEhaTkd2bFRZWVQ0aWIzMG1x?=
 =?utf-8?B?L3grSDJwZGxINTBaaWpxUGJZUEtEY1lyWlJSVkk3V00zUmVsdDZXakVBYjN0?=
 =?utf-8?B?WHdrNzFMUU1LbEkwaWlUaitsTnRaSjZGMWo2WFliSUFUSlVvRmFvdXFRNWlj?=
 =?utf-8?B?cVdaVWFtVWk5ODBTa3NwcVFTWVVTUWpjYXFDM0kyb3BUUU9NVnFBRWJkd0U0?=
 =?utf-8?B?bm81NE5yQnZBbEd6MUFvV3dRYW1xaXZ0TzI5RnNqSlhwYzFBekVjQ1J2MW81?=
 =?utf-8?B?M2pteEtnOUY3dzNPczA4ZVI0UjMwWVIxWUdxNTlxV0JSQTU0V3FYemlKR3Yr?=
 =?utf-8?B?dmZaRk1RY2EzdWdvYWQya3hnVTFSTnhDTWVnWS9ocVV0akN5M1d6bVVVdlpq?=
 =?utf-8?B?SmxDbm5DTFBUSVo5WG1kTmZPMmlORnhUaTJEcTJEZitwUkxZZ1RKNHJnbWx1?=
 =?utf-8?B?V2w4QmN5ZWlEVTNIbW13NjhqWkFsb1hWMldtSTNKMldyemw0NUU1SENnSGFU?=
 =?utf-8?B?TTBzYzZiRlVNWUpTWlJjTHFpckxpb2diTURuUzZGL0w4TzlzdnZCZUpFSHUx?=
 =?utf-8?B?aE5DVFRaL3Q2ejUrc0N3amR1Rjc0SktzMjFrTUJlQjl1VTBSYUx6WnozN3Js?=
 =?utf-8?B?b0lmb202S0lWaFllVDIxQlZpUmdydDY3VnlIRHYyZDRPTmMzZzYrNHd2aEdU?=
 =?utf-8?B?S2F2SkhQV3hZNDdLWlRKUHNzdURTTjBLTHRWM29JaWFwc3VlYU04S0szYmI5?=
 =?utf-8?B?M0dUN1JCQURMN0Q1b3FnN1psUDk2QmpXWWZQQUtkLzJ1YWZOOEM5R3praGJm?=
 =?utf-8?B?eUM5SHROc3hHY1NpcXF5L1E3NVFwOWQvbUNPODE0TTluRkJwbldUZXo5ejl2?=
 =?utf-8?B?bHZncU1KTVkvNGNlanlLZDVBWWRMVTIwNVVNSmJXdVhOa2IrNU5ocVVFcFNC?=
 =?utf-8?B?QnlQUk1lYytacGRXU0VmU3Vua1JRaDF6aG9peGsxVHhCT3pBU2hOMDBZemFl?=
 =?utf-8?B?QjFSWHRsdjFtbDdBaWRaVlU0bUtBTjF0RzZHdngwU2xIZVpNWTk5YlprYm1h?=
 =?utf-8?B?cVNrWWRnYUtCMS9KUkNHRXAvT1pBUk03M096QXdoSm5PK1czNFdROW9ncHMx?=
 =?utf-8?B?NVowcHg0eGpRbEpvWExVWlQwaHZyZkRJRHBRU0psN0RKUjRaS0FnVWc1cUVZ?=
 =?utf-8?B?QlNacy9XQVhHRkh1aFkvYXVPakRiWWQ3cnBhUWZXR0hFblZ3TzVEd1RBU3BJ?=
 =?utf-8?B?RlBoSWI1aXhvODBpN2pqVEJRclZLamxiSWcza01uMktDUFAySW5RTHh4YnVu?=
 =?utf-8?B?VHJ3Q1YrQU1OUVdyRGFlZGtEc1o1TUlWQ2pKcVpkYS9JclNuNnlaS3NLN29G?=
 =?utf-8?B?SkhkUzlDYUtCdTNKNElvck1CczNjYXMyQmlnVU9wbkVPamh4eldzejFHYzZs?=
 =?utf-8?B?c0Q1MzcrbzhuMFpJS043YzZiQlE3QmNZWDJvcGd2Tk55L3h4M093R1I2NzhS?=
 =?utf-8?B?WlE5aTFSMlVNUm54aUNpK0JsTFYwZXIyU3h0dkJlcW5hbjB5UWtnZElqUUV6?=
 =?utf-8?B?T0k0UW4zMlEyZUJKT3N2bkJUNHZWYk1GT2MxbzM5ajNVazE1c1RnYUE3UUUx?=
 =?utf-8?Q?XpoK/TwPgAs9QWSVq5QrZTocO+eu9GnC560rwPx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a37f5dc-5918-4169-d49a-08d8d9556474
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:20:05.5005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbeBOi+yNDJd5SW4ZoTty7mIxjceGWAMvsr8z/O7wphG5015nm0gW0cwLIAFEDp10habr6cX1rCeS6xqwhsQAwP8S0mppOsjvcYZazSH8Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 11:43 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:36AM -0700, Allison Henderson wrote:
>> This patch basically hoists the node transaction handling around the
>> leaf code we just hoisted.  This will helps setup this area for the
>> state machine since the goto is easily replaced with a state since it
>> ends with a transaction roll.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 53 +++++++++++++++++++++++++-----------------------
>>   1 file changed, 28 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index bfd4466..56d4b56 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -288,8 +288,34 @@ xfs_attr_set_args(
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_try_add(args, bp);
>> -		if (error == -ENOSPC)
>> +		if (error == -ENOSPC) {
>> +			/*
>> +			 * Promote the attribute list to the Btree format.
>> +			 */
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Finish any deferred work items and roll the transaction once
>> +			 * more.  The goal here is to call node_addname with the inode
>> +			 * and transaction in the same state (inode locked and joined,
>> +			 * transaction clean) no matter how we got to this step.
>> +			 */
>> +			error = xfs_defer_finish(&args->trans);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Commit the current trans (including the inode) and
>> +			 * start a new one.
>> +			 */
>> +			error = xfs_trans_roll_inode(&args->trans, dp);
>> +			if (error)
>> +				return error;
>> +
>>   			goto node;
>> +		}
>>   		else if (error)
> 
> 		} else if (error) {
> 			return error;
> 		}
> 
> (I think we usually try to add braces around all branches of an if/else
> if at least one branch requires them.)
Ok, will fix

> 
> Otherwise, the factoring looks Ok to me and this does improve on the
> wart from the previous patch:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great, thanks!
Allison

> 
>>   			return error;
>>   
>> @@ -381,32 +407,9 @@ xfs_attr_set_args(
>>   			/* bp is gone due to xfs_da_shrink_inode */
>>   
>>   		return error;
>> +	}
>>   node:
>> -		/*
>> -		 * Promote the attribute list to the Btree format.
>> -		 */
>> -		error = xfs_attr3_leaf_to_node(args);
>> -		if (error)
>> -			return error;
>> -
>> -		/*
>> -		 * Finish any deferred work items and roll the transaction once
>> -		 * more.  The goal here is to call node_addname with the inode
>> -		 * and transaction in the same state (inode locked and joined,
>> -		 * transaction clean) no matter how we got to this step.
>> -		 */
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>>   
>> -		/*
>> -		 * Commit the current trans (including the inode) and
>> -		 * start a new one.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>>   	do {
>>   		error = xfs_attr_node_addname_find_attr(args, &state);
>> -- 
>> 2.7.4
>>
> 
