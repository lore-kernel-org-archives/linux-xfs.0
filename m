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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC58C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC9964EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhB0A6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:58:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53644 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhB0A6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:58:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0qHEj116488;
        Sat, 27 Feb 2021 00:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ddBnHDbOSCLHJOpMlxofO5kHnaJOGmCg3qpUq27xZVs=;
 b=sp8gqnHwIs+VCK8vM7A07k2cSCryA0avqYBLYWtbT3lt8muBGKvHV5FkLcSTq7T0X9bW
 JxVlNTRjWrYd1blDdTwrhVg7nF9N0yfcJ47L70Nwr/MVJzjCfsaRondG9fN4NiEDtksy
 Sq2s1WCBctJdG7hYgaLt5Xb8I3E2qPt/LFG9XGCWyq6sGXemS54ekQpLyGHw6/78byTr
 qZFDaEBHFEjGtpLqjKiCXYf2IbVcUz0VYWd/FlnUvDy6tlNevjlaiZV67ZOBfkwkdAr1
 Q1WSHUFDY75r1N4XvNrfLXGIDy58VoianY52BkE90jq5m0e6OcZRCED6lDxGelBHhVHJ Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsurbpph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0isOb175020;
        Sat, 27 Feb 2021 00:57:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 36yb6rs2ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGbgtFWx7+EJ2bJC+/ZjmADFHlcVCBQJ88Y+GIx/LMJpI02j90q4agxB1nQ4WPY+o/Jddm85hWOVNOPxBUi17XjynbKXjYGX0/j5B0y+860r1+k8ZbCvkc6KrCYgGJxdLoWkGIF+Cm4f/lPndK7VAkSNtHUDCqNRXLaSd/yPASBpp1lRdlTWBCb0w9K0yDE+qRv0pYwN+YHVQALGu4mnSgqflgrGMynkIngEVg7IHEEUz2lL1u5Fu9xPKjETjQ1GdWbqzZbH5OLBmy3ziB95A66GOtAaUf481mcyHPPh0avgoYr5KQk1qhNRD9vDa75s4b+7GpCJnFqCDyIeuXlPqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddBnHDbOSCLHJOpMlxofO5kHnaJOGmCg3qpUq27xZVs=;
 b=FsMA/sZ1bAWIGRWl4bF6bZa/9MbcwBFySZH/iM6jlI8oIIGZndDbiuj90aFI5VY1O6iCJ3eLjPVp4znBGBzmL4GNLr4qDVSs4L28QYOLawjkfv0r5Nr1uKs9o3QbjSnbJGB90VZvciMzs02QyKeNUYIaojiv1umstQ7ySIXD8D5pZeXHDVaH5At6TreZjX9qoimddl79G6zXiS1sz7xP9P0RBd5Y9EcFDLwSHgsEbkx3HBzftXTgMxx5pwtmaobjeFQmvBMX2VlUcXS1peYIo9NorTBcSVjA85Q6huKFPSFuyu4duzLwEIyhMINXzdzvaXcim0v0YMFL0Q6ik3geJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddBnHDbOSCLHJOpMlxofO5kHnaJOGmCg3qpUq27xZVs=;
 b=G47+oGPUopCueipl2qC9Cy0SUDVJFdU9kymw3iESnQhePn37Z25xLDR49SjzZiODyNJ9Ye8+UliGxYWfqo/IaWvW+qq1d+TWTdWaSPboQVqWRk9FnfslYEZJeE5Py6x8sMLXV7IOPyyIh/JknuucSXwfzcwpb/jzhQRnujQ+HTM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3858.namprd10.prod.outlook.com (2603:10b6:a03:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:57:17 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:57:17 +0000
Subject: Re: [PATCH v15 15/22] xfs: Handle krealloc errors in
 xlog_recover_add_to_cont_trans
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-16-allison.henderson@oracle.com>
 <20210226050614.GA7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <63a61a0b-1a3d-c6cd-7165-94d254fed751@oracle.com>
Date:   Fri, 26 Feb 2021 17:57:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226050614.GA7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0186.namprd05.prod.outlook.com
 (2603:10b6:a03:330::11) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0186.namprd05.prod.outlook.com (2603:10b6:a03:330::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.11 via Frontend Transport; Sat, 27 Feb 2021 00:57:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaa16c38-c04b-4972-5282-08d8dabaa135
X-MS-TrafficTypeDiagnostic: BY5PR10MB3858:
X-Microsoft-Antispam-PRVS: <BY5PR10MB385882FFBFAE1754C34502AB959C9@BY5PR10MB3858.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KdGa1CVaMXZ5c/jUp7hPfMVJyMC5aHAHmaWi924P/cFziYQHO6EeIAfqBgBmN8OlRzL+D5Gy+hChVE0AOSsVdCLTVxNFQ2GkeJ08F87m/2DT/MzoUvZWRwQVCi907I13G3vmDmki32ygoBMKCjId5EJMq7U9uyvNF/0O31LwaVv+PoSFxeMkovCHFE88JNDH1Qkt7Y0dzvzBEz6Mrj+U3UH0LuVKLDyPJuu7BBKAng/hR4szl9UFlAfvp2iS+QszSD7GUPLRdnTqWU8oBwhWi77Y95ZupeiYz6KTfZ0II+vTYTQAdmkBEUivCL/Xb7rOQojvqKnuOrxDgbVGOVnSFLjGGbf/Lw1epRI4AYzhG3bqX6NVlcrzda7ThhvWFoz6l7WSHpZGBJEi6rZKAvw64ENJyE9phH3hGxzIouoPhaJNMcLOg6RowyK32j/Xynhyh9XI6cPH56f+6eJhYJe27aK4uSnKyCgMIrNYgeO+VRFurGUiIuM5E+LyqnASvYEdFFTZEpruAZD/PwZYxM5S5hcf2Z/FnQw18W/rI5Pa30S4r+YWqTiAj7KEfk9YducOCPempe2DQMJa8XEih8IdvKTvl2SlJ4sAQ/EjEDSjTGg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(52116002)(478600001)(6916009)(86362001)(4326008)(2906002)(31696002)(83380400001)(5660300002)(6486002)(316002)(66556008)(66476007)(36756003)(16576012)(186003)(8676002)(26005)(16526019)(956004)(2616005)(44832011)(31686004)(53546011)(8936002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bnN3bmdFYlVERHFNTElIL3QxYzJEcDM0MTNBRkN6UEVtRjJtcjhjWExabS9Y?=
 =?utf-8?B?eTRGS0RvMjRteEdaQnptU2RqZi90azRYeGNoZ3dDbmkvS0NDUjZZSUozRm8w?=
 =?utf-8?B?YlA1UDdmTHZuLzZlNEhjTHNPTm5IZWVFWCtmdHkyODg0OFpYRDdqaFdyVGxu?=
 =?utf-8?B?RUcrM0poSUcrZUE3MVFLcTI0b2w1MmJPeWxRQzVhTVVreTM1eGtXejY1RXVn?=
 =?utf-8?B?MEMvQ3NaSUIzTFU3b2dZbDc2bjJ2cTcwRS9IbWd2T1Z5dlE0d0pVd2pKREI0?=
 =?utf-8?B?V2RwVmFMaGIwMUVCd0FSNkR2S2JvWUZQUTJZSGY2VlhBVFdaTDhBMTYwazYr?=
 =?utf-8?B?eEl3dTg1ZWY5MlBNcE1pby9YYzFlTjFnT0ZVWXRyVkV1S00wZkZGYmFnNlhp?=
 =?utf-8?B?VDdhUitVNWIrNEhrZEdXU2srYWJDZzJ3MFZTeG5tTUZQYjNiamNnWVFuRjBn?=
 =?utf-8?B?dTcwTk81R2tDMHRYMi93MHZ6NjF0SzZ6MWRGQW94T2Z6L2tUcFZ0RVhLZ0h2?=
 =?utf-8?B?MFpBNlJlUkRsTkpxOUNnS2QzZHJsSVkwMDJyUENZL1hBQVlPcmpBWTRQVWlx?=
 =?utf-8?B?VTg2ZGhRSTJsM2RyRExtTytvMTBadVF4dStYVGdVZHZiVWNHZWtjb3k3NU5S?=
 =?utf-8?B?V1hWRCtoT0NkOUNESHRyVlI0NDNHRFVMN0d4SkZKazFwc1RvbDYyNzBqbnIr?=
 =?utf-8?B?L1JvalpUWXN5azJobitpQ0lheHIwRVpObzhGS0ljci9hK3NDd2dwQzB0cmVw?=
 =?utf-8?B?T3ZPcFRCYUFGeGY4TTZKdkJlZUxLSTgyN1ZpakpDTkJvMlBVanIyQUN3Zm1F?=
 =?utf-8?B?T2ZTNk1wWGo3ZmthaHYrQml2QjM0Y3I4R1JkTG1vTXh5aUdIUjlJbHc0cnVF?=
 =?utf-8?B?VVJjdHJCL0thOExiam5KT29QaTJtVlJvbEhIUUFLK0hHN1U5Q3h1cmlFcnA2?=
 =?utf-8?B?K3RxQWdjd2FXL05CNlRkdW5mUytRbFEzbFByMitzZWN0MnkyeXFYQ1BLWG1P?=
 =?utf-8?B?M0JBaUNlM3h1TFY2S3YzZkZPYkduZVBwdDI2N1JQakVMdXpBTm81RXdPcVY3?=
 =?utf-8?B?d1RtaFZ2QnNTUndjZlpVK2RHNVlRaytMZE1PanlqODZNOVBaVVBXMy9wam5U?=
 =?utf-8?B?OTRSZjV4Y1J6QVY1WDVQUFE3c0NSN0RyK0owZlNMcmdvQ2htYVBydFEwN0ZH?=
 =?utf-8?B?QjBDTEcrNG55SFRyTTgyb0FLOVI5enROMmJjRU40VmN4U1dzeEtQRzBtYXk1?=
 =?utf-8?B?OTZNK0psVkdadlF4ZlE0UnYyV1kvWS9CSlBNQk9lSlM2TTNVcnhySkNxY244?=
 =?utf-8?B?aDdNbngxTloxKzNVMk11eWpvSlhMbFVlanZaNUY5N04rNHExUm9JQTdiMzEw?=
 =?utf-8?B?ckZvOFA4UVhmeVlGcTViLzgvRTJlV3BtV0RyZlBiKytvU2JIZWlhbDZHaUEy?=
 =?utf-8?B?V3FoK3dxTDdHa2FaZjhSZkZMNG5FY3o5eis0eUVUR2dIWGVURzIwK0F0VXFj?=
 =?utf-8?B?Z1hEWVJWSXg3YlI4VXRxTFNQVS85TDRTSEhWdG9VYmtlcUtPaHMvcFBSSW9R?=
 =?utf-8?B?RkY3MjhybGU5UEFaRyt4OCtFWEN6WTl0VDBNT3Vwa0J5YVJRYU1ITEp6czdq?=
 =?utf-8?B?OEFSbG96UUw3L093OGczRmd4elNIUFlGZTRDeFhpZCtVWW9IM3dBaFhwWENo?=
 =?utf-8?B?OUpOV2xvdmQ1enRvbE9rbHJHWTRlRHFScXpudDR2NEVWWmtyRHE4QjcyMklL?=
 =?utf-8?Q?VUpQNF2GenJU6WnfN8YtUZOEnYmtW7hT0neYkO/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa16c38-c04b-4972-5282-08d8dabaa135
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:57:17.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2fgTphCmifs0o0KlOJdI/fF2Sn0/tAiy9appbTIgM0HK2pBzTPGcML0Je3+xiaV2QgAuxoCVgfBtjI4Izz78XD78tdWEomdJS/EugbQAEE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3858
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 10:06 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:41AM -0700, Allison Henderson wrote:
>> Because xattrs can be over a page in size, we need to handle possible
>> krealloc errors to avoid warnings
>>
>> The warning:
>>     WARNING: CPU: 1 PID: 20255 at mm/page_alloc.c:3446
>>                   get_page_from_freelist+0x100b/0x1690
>>
>> is caused when sizes larger that a page are allocated with the
>> __GFP_NOFAIL flag option.  We encounter this error now because attr
>> values can be up to 64k in size.  So we cannot use __GFP_NOFAIL, and
>> we need to handle the error code if the allocation fails.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/xfs_log_recover.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>> index 97f3130..295a5c6 100644
>> --- a/fs/xfs/xfs_log_recover.c
>> +++ b/fs/xfs/xfs_log_recover.c
>> @@ -2061,7 +2061,10 @@ xlog_recover_add_to_cont_trans(
>>   	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
>>   	old_len = item->ri_buf[item->ri_cnt-1].i_len;
>>   
>> -	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
>> +	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL);
>> +	if (ptr == NULL)
>> +		return -ENOMEM;
> 
> Given that we update i_addr anyway, perhaps this should fall back to
> kmem_alloc_large+memcpy to avoid introducing another failure point?
Sure, I can add that in. Thx!

Allison
> 
> --D
> 
>> +
>>   	memcpy(&ptr[old_len], dp, len);
>>   	item->ri_buf[item->ri_cnt-1].i_len += len;
>>   	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
>> -- 
>> 2.7.4
>>
