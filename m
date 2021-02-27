Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F10C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3947964EE7
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhB0AtV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:49:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36708 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhB0AtU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:49:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0jBd6100412;
        Sat, 27 Feb 2021 00:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jwNUDGnmVBoDhwev9Th9NiPvVLvmm/iGYMlKjBYSQYw=;
 b=lkNaLvuBhH5+t58FYtTh4P0KCPDEM/vtHVyfh8N8EU3q0qyrQ/vnLlmuKU8iDCc2ikls
 tO0Sf535VQhp3y17H8zX0w+yzQEb0iO1/6neQkOsDwk2Hb1QPzgyrFvrmIeNhSlY+mFY
 HXqh63xW50yq1YZzvDGdzh57clelx+eQWZwyrpYNDHwo1qwBaorkGbng33an4nCiOwjs
 lsj66Fq3EJDcc9CVLwg2SWCrFKCWVNZ/KtoIBS8nfY5rh4BF+Mx0B+iAzWR/NYyTPbMs
 Rd+h0klDpGdKP8uoXBkVUC6WiB9E7aIO2YYK1QDG90x+MdqjCK2MCQo+kvkkrScToev6 vQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3thu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0irlG174797;
        Sat, 27 Feb 2021 00:48:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 36yb6rrx3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:48:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In/zk7P57qlaWjQgWXx2CbIanNu3viEzlHMw9FZzbItp1N6JGqgjP5QY76fPdStGyYpp13A2Vfs0VdeWv3Fkyzeiuf2Uo6sW5VlFULe1uQErbV+c8LrGoT1eZK0NiitBY5Qa9xVDiuOr07fR7JHtUiHUextlKY1nf0x/T0pWJrabxqXQIc6T72r08nTg6NouRT9SdMUCILL7CV48zoW4wH7En0r42r4oKHbJe1YkMd2n/E6LYhE7sRwuwGA8w0wpaZw3StiXnQcOM4QC3XyCZHH2neEMnWbbVX1geDCkSb9TZt4mM1EILZLi9x332UKgesJEOpQkq1VKurRgK/9GMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwNUDGnmVBoDhwev9Th9NiPvVLvmm/iGYMlKjBYSQYw=;
 b=SbgaF4hFrohncvqCmm+jUrtEkoxu4v1TT63tSqLX340GdgPQFbl/Xot87LpnEyPxbFOq23HRZ8vJf+GgMyBVckZGSO+v6R2kTZYZYs/5RqeDGG4ekm6GDtJKufH2KLvcNd21GxO94Gvalt6DtnP2Vm5ayc8fncpi3Q2FDZ2gyDli/Jvn1ZqWj0CG4yBcdq3V+Ni6BzSengOPen8zGrrfGBOXMiRw+4u2hHd6FFyRoUnVfZLK1gZILcSqUBnpGXtPfO49opFX4QmiRb9d6oZUCrpfEHEB0zsxufVL0BsEJfWn4fSzD89Fpj/cukVmuH3+qhcHFGtluucvxQ9FXUEPlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwNUDGnmVBoDhwev9Th9NiPvVLvmm/iGYMlKjBYSQYw=;
 b=QF/Ntkl2oNEsxHCno9EoD3ffTLKEv7PNen2j5nzAptkaAKmGPeMqG06n9VdX2cIDsFgblxzEXwtYeTTDMRxcscTlCSHxAYXt8TzVxbKdyBL3m3lMSkFqE4sxyVRyfBKT4S739pkuYgnJoYN5Xtzay60yLNrO8jWBRM6SEs/XcLM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3335.namprd10.prod.outlook.com (2603:10b6:a03:15d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:48:33 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:48:33 +0000
Subject: Re: [PATCH v15 03/22] xfs: Hoist transaction handling in
 xfs_attr_node_remove_step
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-4-allison.henderson@oracle.com>
 <20210226030227.GQ7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ba4e335c-9e37-1359-8407-8c8f2b002f57@oracle.com>
Date:   Fri, 26 Feb 2021 17:48:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226030227.GQ7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR13CA0151.namprd13.prod.outlook.com (2603:10b6:a03:2c7::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:48:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36aaea6a-06ed-4ad8-0d64-08d8dab9688f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3335:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3335ACB6EBB6E4AC25E64960959C9@BYAPR10MB3335.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GoYCT9zyf97Mw6hJyVRR6wxnPhsvK+OYgLDx7lBH+O/lYTSdl0CzN5sRPye22Hh6MFP/nbktg0lyb/5ZOQoaFhbh1zhvBbbpnbzjhTlI9VtFlsEyOYPLQ/uqqYiVah7bd7RsbLvacFgj/ZCIK7p9scfeykWd/a1z0uwJuBNgp3YcolZCXjefc/raECR7rPCYUjxAYMOuBAF8TrmxpsOhJPPEp0nPILLTFEH45D6IWn9aOEYujvUjj3oSVhWJv3PAfiW74CnW1mWzGAbdtwXfRPPOktjOVQsf6ebJzHTVA0sbk1I4J+iAglHXq3mBXNG5sI4RAdUg85RyLIK3p1UJq1EEojEQGdL7g5A7uo0SfjP/BDQAM/nN3ickFKFRyDoLW/i281nv5m80MUkUq6DbLfomCEPTlrfhKuwmB+0cPjWJwnSnqPZ+S33WAEfRb5aGCnBYZFNX6lbngecc1QesvGmV9A23lDbKtiWXOtbqHtgkszEvkUOW9oed9Jdpx38o/OelSaSIfEdSk7IVO3b0jmOI/3IkkkQ3yH1xnqT3stsAYyjcEq94yzg6LZ+MSg/VyrU/ZPDEvyki0zlARbKnaAzp/iB0NChK05RRltYXH/g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(39860400002)(396003)(8676002)(31696002)(26005)(8936002)(52116002)(66946007)(2906002)(66476007)(36756003)(5660300002)(6486002)(44832011)(83380400001)(186003)(16526019)(53546011)(6916009)(16576012)(316002)(66556008)(31686004)(86362001)(4326008)(956004)(478600001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0MxUWZ4T2VmcUdaZGQvQWh2aXRXcmdndWNGSGZZWERPRFFMQVRYUW4yY3JO?=
 =?utf-8?B?enF5YkVSdUlpRFErYnlGVFByZ3ZrTHhiOTY0OVZzb09hRDFLSGIxWWJQZXFD?=
 =?utf-8?B?cm9wQ0lhd1YyaFFVeVcwNFV2Ny9MMEVIVkQzODNwbUpocllwa2VHVGRVZEg0?=
 =?utf-8?B?NHdkNldZakQxdmFZMk03ZGFUenREbUxmZnJTZS9icG9FL2w3Z0xRSVdrdFQz?=
 =?utf-8?B?KzZBTXdnZ2cwRzJOOUdVb3praHo3OGw1WWpOMEVTVmdqa0ZiMzVrQjlBN2V3?=
 =?utf-8?B?N3NvMzdndXVlK2xMWTZZYTIvZ2JsR2t5SWFsTHlrTFhrZCtzZHNiRXBXUlYr?=
 =?utf-8?B?bGxTMlJUZm1uR1VKTDR4YWY2V3F3bklTQlJWS3VlSjgya0ZKb2ZFRXB1WEFW?=
 =?utf-8?B?WHROQ0hQTnNqQW5kM1pJOFVvN3NHMEJKOVVpWmhRU0xxUGxySFJ1RUFxTHZH?=
 =?utf-8?B?ODZJTS9KRjNCZThMZkZVMU51c04wYVg1RUkrSkp4M1ViN0x1eHo4Nk1xUnBG?=
 =?utf-8?B?NUFDcUREZDVGSW92V1FZeVZBejlRbFBnV2ZIV1hWd2JKaHlBZENZdktvUjBT?=
 =?utf-8?B?TitWTVZHV283NDZZVnJXZ2FnNlRJMHBBakRNNExLdnVNNnVZckJlcmZEM3hD?=
 =?utf-8?B?SHh1Si9menR1L1paOUFmVjFFRTVMa3RhdXJUWmh6UFVtRDFBOFB3STBMc0Vn?=
 =?utf-8?B?bEo3NzI2TlFOSFc5bEZFTmNkN3ZFa0tSWUU0RkV0VzNObHRNdE96NVh3MTJX?=
 =?utf-8?B?SHA3NlgyeU1SaXc3anIyRjZXQzludjZKTytFdmMvL1Joc2cyQWFmYjI0aE5j?=
 =?utf-8?B?NVVLQ3N6U2U3VzA2M0pVYW1BVnhhdks3cTJoM0ZKeHQ0M3A0ZHdXVUVuOGc3?=
 =?utf-8?B?RWlxRzhSWUFlS3RZcnNCZkpVVEJ1cWtCM1RwZnJSMHhhZHZ6TmFvd3lhWXhs?=
 =?utf-8?B?bGpzSUxheHZaTGNLcDdFYXJFSW9idThHYjNYTTBFZWxtZ1hnaTJyV2RmUU1l?=
 =?utf-8?B?dzNzWEpZK2lxaXRmYTZ0ZUU5QXVUOUpSL0dLM3hoRm5vNDFnYVNDa2RONURZ?=
 =?utf-8?B?clNsZ3kxM2dWN1pYdFNVbkNMcUJsbzFnWEtVYXRzL1B3VWxFd3p5MSt5Q1Vp?=
 =?utf-8?B?ODBHZGU5UTZvVlhvdlE2Sk1nQUZUZWM0czF0RlpxVlErYkdhRStlTG1mUERX?=
 =?utf-8?B?dC90Y1hpZ2ZNMVJ3OVVVK05ieDZqWFZUZ3dad1hTQ0VsUm5qYXZ5R0lJWStq?=
 =?utf-8?B?OFRrcVFqQXVVanpjSUR2VkhhOFpwcU9neDVKdkh1Qm9rTXFZcVd1WldOeVNI?=
 =?utf-8?B?UWIvZEdzZ3pNazRYNUVqaVpVYWMybGlKTkovNkZHbXM2M0ZpeDIzU0pTZWpt?=
 =?utf-8?B?WUVvSEJGUHlyWmRvYmlHL0pBVzFZaWNOU0RydmpCQk5nVFU2RG11MVdwZWJk?=
 =?utf-8?B?VnFUbVN2NzR0MWFXdk5ha1FXU1pTQXVJeHRCMGZMQXhFdDdZWXBWYmIyelA4?=
 =?utf-8?B?cDdKQ0xLV0NDN01MaEVhNm1kVG5mY1R4QlpZYmdhdDF5QTlDWnlzbW9PdWJv?=
 =?utf-8?B?ZThZbm5tSWtQbkFFTXo0TVpqdFJsMGxWTHNEL1NZTWdwTktoRm8zM0xPK3li?=
 =?utf-8?B?VHZNY0JyeUdaQzNIcVJqaVBqWmloZWFhOEE1Vkp5RzNpTjg3ckdPRmF0eU14?=
 =?utf-8?B?MUJwZHVHeHg5RkhwM3I0RmNuQzhzYUIxRXBsZ0RNUmtjbzlrSW1BK2QwcGl5?=
 =?utf-8?Q?EgW1zveUSr8TBJZOiVwBPwOErW+prS8E4vuqlG7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36aaea6a-06ed-4ad8-0d64-08d8dab9688f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:48:33.2976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONPMYFVyA9zKDpkShmhqSILeGx42R1AiWT3cUW2DXc1gVcJWp5bzE0hhN0wxJDbWIINUE7hK2p1kYEohsVyYNRAiSd7yzAceTT4LHmRfzGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3335
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 8:02 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:29AM -0700, Allison Henderson wrote:
>> This patch hoists transaction handling in xfs_attr_node_removename to
>> xfs_attr_node_remove_step.  This will help keep transaction handling in
>> higher level functions instead of buried in subfunctions when we
>> introduce delay attributes
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Great, thank you!
Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
>>   1 file changed, 22 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4e6c89d..3cf76e2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1251,9 +1251,7 @@ xfs_attr_node_remove_step(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_da_state	*state)
>>   {
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> +	int			error = 0;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1265,25 +1263,6 @@ xfs_attr_node_remove_step(
>>   		if (error)
>>   			return error;
>>   	}
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> -
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>>   	return error;
>>   }
>> @@ -1299,7 +1278,7 @@ xfs_attr_node_removename(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_da_state	*state = NULL;
>> -	int			error;
>> +	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> @@ -1312,6 +1291,26 @@ xfs_attr_node_removename(
>>   	if (error)
>>   		goto out;
>>   
>> +	retval = xfs_attr_node_remove_cleanup(args, state);
>> +
>> +	/*
>> +	 * Check to see if the tree needs to be collapsed.
>> +	 */
>> +	if (retval && (state->path.active > 1)) {
>> +		error = xfs_da3_join(state);
>> +		if (error)
>> +			goto out;
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			goto out;
>> +		/*
>> +		 * Commit the Btree join operation and start a new trans.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			goto out;
>> +	}
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -- 
>> 2.7.4
>>
