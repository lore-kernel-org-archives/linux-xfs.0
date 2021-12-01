Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56914C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 07:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhLAHhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 02:37:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:2340 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242420AbhLAHhy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 02:37:54 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B16rs51007156;
        Wed, 1 Dec 2021 07:34:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IUdWn4g9mt473M3StjvYwmtiPmGie721poRc9MW05fc=;
 b=dBDSbCfk+mFDPu0ffzLnx6F1P/hF9PD+JWO0RCooudMIuVyeM/w5NJEv1doSJt8AkLuB
 ygBByJ2yfNcOrd2vzl5waYsQqlKo8NaW/sWAqvRtpd7dt1jUbrgDMlABDYXk+4ZxKWmL
 SpKFoWSsBfrxGRG6VKtSwNfsYgyIiI73Nk8Q1ALpccVC1Y+RysL9F62G9NkzpC7Ss9ku
 Y0zqVPZrfnmYAGq5OTZbKvkwXAMsHw1FdH9iPo7n/+R+uENAWFMzlXxxb0fn0z0tP4Uy
 71b4/Jo74mz0MDHPH9307fxRCAl8wskXV3EhIuL+iVuHDHuXXKQNsv51qiC72DZeF/Pu 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmueeq6he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:34:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B17FmqD022850;
        Wed, 1 Dec 2021 07:34:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3ck9t176s5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Dec 2021 07:34:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUFmJuap39A6a3jg2YmTvk5b2BjAo7BLolW90fVtnVYX9EWnp7bN5Af/z0N8NSC2MGxy++nmVt3QoZ6pOCWdgzdhPxNRHfShs1Ovyl24SwmbetXFqGsa2g9gxxylV63XzhBLGlFOd7HSz9Lo2+acJORi1RMUG0b3x5PlGoegUvmnc/0YkBtp1gvEMyniqxFPnE2SEh/0VIXLEpJLDhWAJAE5EtZhRHQipeySj+U/ToOUpeDrDQIcwtJzNocIFNdWS3lveQdngmlCWHEwdJ9Famp47Pl45h/7AMGKjCKGFynmdpvuZwtR2TDR0n6H3Gkn2LDS3nFI4sNE+ygIwH4aug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUdWn4g9mt473M3StjvYwmtiPmGie721poRc9MW05fc=;
 b=N79QK9GyydsHh1JtI3ihmXkC5ftWoTLDnZgklrRgIs2j7vLeL1lkysx4ValZsO6L76rfYOq1A/3adIWVsoM3yDrDbfAbwfT0kAU1dMSVtC7JuYHkB7ciTQDamXxASLaws6P0FKn34gqgKE0a3XmUpP1/Y2nWtg3Zhzh6T5lXwjas9zSXEDBLEnBMigdlI1quhcTP0sR+b8EuEH4VdO6yfhwnNP4Sj5tInRC37oWIaNQHRRvXNwtJny+flEM8CVkVVPF6J8zgqTqSe199KHguWHburDelIPm2kTvpZtOOIkqUWNolMa6GCF6BSGBCurcjcIMp83EeMesOK0k4xBnPGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUdWn4g9mt473M3StjvYwmtiPmGie721poRc9MW05fc=;
 b=fVQrpy49ZVZRlL5gPqWnWenylE4VfcKHFEQ/D0yhUkmGxfKML7Z6JWkamOdui9xP8Bf45nJs1+eVhn4TL5ZlLffpmdWeDzLIlURgMb+75xhCv0q00e3he42UbREHeu2nnq1OSXcbLZqvFw34hNlWb8CdkLXnmmULVrDvSKOdHHE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2759.namprd10.prod.outlook.com (2603:10b6:a02:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 07:34:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::fdae:8a2c:bee4:9bb2%9]) with mapi id 15.20.4713.029; Wed, 1 Dec 2021
 07:34:13 +0000
Message-ID: <1631f724-ce5a-3b7b-cbe2-6cb6daca45cd@oracle.com>
Date:   Wed, 1 Dec 2021 00:34:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v25 02/12] xfs: don't commit the first deferred
 transaction without intents
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20211117041343.3050202-1-allison.henderson@oracle.com>
 <20211117041343.3050202-3-allison.henderson@oracle.com>
 <20211123232853.GX266024@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <20211123232853.GX266024@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0060.namprd07.prod.outlook.com
 (2603:10b6:a03:60::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.6] (67.1.131.99) by BYAPR07CA0060.namprd07.prod.outlook.com (2603:10b6:a03:60::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 07:34:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22103347-e8f8-454c-f9c3-08d9b49cf90d
X-MS-TrafficTypeDiagnostic: BYAPR10MB2759:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275975B433BAC38C5C990DC795689@BYAPR10MB2759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7T+vf1oZjcehQ+pW4QIO+0XXcAnEc6juw6Q/eQHzGPQdYQHv+td79VT71f7h7rnA6ZuVCiEMmnhjbczMzo8f3lDqS7vHBEUo1lH55Ke14EKV5zQmDFCRM0krlQ/JydMj1Hp1QTfx3YYBWnIciItuc3kriikrNqYF3rwJfa39l6w72NEYihtydHEPm/pU6fI/gktr0gamTGoqhamEX4JVTfLIz3Z0EvYtOWNx+hlsLHoQNDFp8fufY/hltaC/r7IEL7DRrQx+2bWVaJ205pes3GnEx2qB5qNeflAXlZYr0xXrZWUa1vBpgXMywy9kiJb4zc+hhDb77Y/WhdKVHo+dzMVdLyAr3kaSSNsHZkUXm+mJtZbBYv9Dl+zBOgKfmbTfCoQUnQzo915a0hSZ/jzyjJDgDtjvDmV6YP5zzUls0DCYtT6WqBNNt8aDVp+g3919RH2bUnqwsSy27DPJf/lyuBAyQl1OSoQNCDb3yuIhqAALgFgNZgSMjYDK9OHP2MpDh2wYSy8zyfBNJoMe7lDu1kme1qhOxPnXbNQXMVtFDhrEBG7zGikVwoM/gtVMkaQNsSQOPbfkkIvvWZDtbrIRpaZ8rZR9yW7PpGYscePLQbhWlOdrZmUSfqKHwebW/MMbpLyplavpSOLBBwC+J1sy3URY6bCtXezar7tLNgQ/EIxb8UtsuTNUkdJczhCTpgDRPH2sDqrtiUhd3ixakNfLfPNl0hccdznVPwoL00D/p+NJw4N4qG9+sg6AsT5Ti+qO25HN+01lZwUCr32NhOcslQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(52116002)(8936002)(2906002)(26005)(44832011)(86362001)(36756003)(6486002)(66476007)(31686004)(53546011)(83380400001)(5660300002)(16576012)(8676002)(66556008)(316002)(956004)(2616005)(6916009)(31696002)(186003)(4326008)(508600001)(38100700002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWEvU0EzcDIyMUtGOXo4OVUyK2Z1ZjkxRENEZy9DaXhZUUZPR2wrTlo4YStC?=
 =?utf-8?B?M0h4Zit2OTBwR1l2UVNNMDJmcGd4SHpaUENDc2NSQ3JuQjVUUDloOHBJMGRY?=
 =?utf-8?B?RDNhcjRZbDlrVnVZc25xZ0tNR24vUnBJYS9wVm5tVk5VTmZHZVRURVBpZGtI?=
 =?utf-8?B?b3cyYzU4aDFYa3FsL3MrK29ZcWRiRnFOYlNPZUNVeUNuejZwSUhpN09GU1Zt?=
 =?utf-8?B?MTdQRy9WQi9vZWsyRlF2TkpXUmszOHY4Zzh4eVV4aGYwaHhsUTkwdjBjT1lR?=
 =?utf-8?B?TTFsKyswN3hDMGFiQ3Y2T3BBbkdRUmxIdW1ZZ3NVV2hpajZzZ1ljM3NHTEpv?=
 =?utf-8?B?RFJYbGlWc1N3ZWJrbnIzajlVME93Q01aR0poSzI1dGlMa1I2SFA5bG5xY0gr?=
 =?utf-8?B?WU1PWHNvcDdpQ1YxWGJWeWs4czc4eFBoTWMxYmhMZTVFUW85QjJZRjYxZmcz?=
 =?utf-8?B?ZHdJb20zVUxkMFJLenJRT2NLbjJlWTlRU1ZLN3pJK0VwV0Z6a3hocC9DSmZR?=
 =?utf-8?B?NDVyQTMrcDh1VnFJSS9oTkxDaE5hUUNOeTlWRE55Q3pRTU5tMmdVbE9iWGVv?=
 =?utf-8?B?OVRueWFYcDRLdmJxc2UzTEloemJLT3FjcVE1SHBrQWg0c3UwYWY5a284RllB?=
 =?utf-8?B?b0hGaHpHVzBTSWdyUVBTNHNSMDRUSXRKWVg5TzdkajBPY3ZnSy9INWFyY3Vm?=
 =?utf-8?B?Zkc4NTJVUkx6UVlaOVEyQ0lnRmFoSWF3dFI4NDVkUGpPbnlBRHBhMlhoa282?=
 =?utf-8?B?a3pCZ2dJVzdMRUtwUkxtanpmSGwzLzhYOWpLWmtvWStzWTIyTUljSU54TGJW?=
 =?utf-8?B?VWV1SEg3RzduTGw4SEcvUy93Q25VaFcydWZ0cjhMQllHM2xWNGx5bXFGVlpM?=
 =?utf-8?B?YUNqVlN3KzVrMWJtY25DV1IvdDRtbkRSNEV3NjZITDJySGR0YngyQ0FSbjhy?=
 =?utf-8?B?RUZnOFFJSjBLcDZCSno4M2Jvc01OaDdLQUxDT3d6eXNyWWdSenFFUCt1RjJM?=
 =?utf-8?B?UjVRbHFxbE1GVnRrUnpQWXBUVVltSUFBUXRIN2Y0SVVBSDA5UDlacnlScDV4?=
 =?utf-8?B?Nm43SVFNWWtTcVNZRjc3cWNvT2pmNU9CVHJPYmw5TGdkKzB2OS9tTVB2ZzdF?=
 =?utf-8?B?aUpHVVM3MmFZS3EvaDNnODg4VlVRT0FYU09rTTNTYW4xNy9Kc2I5MmhmUy82?=
 =?utf-8?B?TFdzTkozSStVbGVZMmtmbWpTZWFoVnRzbEVzelNPcGNBMDBjQm9uS3I0bHNO?=
 =?utf-8?B?NUxCeXVTdUFybnhSTk9EZ3F2SGp4dVlYbDdod1RmSHVoQkJZQnhnWWRKNXhN?=
 =?utf-8?B?d1JqUzE0RDg2TlgrOVJpNlhrL1dkZk9uSWNrZTY4ZlpNdHJBS2lOc0NpNFE2?=
 =?utf-8?B?MkNqZkZSMlQvOFZlcmRSTUJ6eGFRbEZiUFhWSWhhUUxPdVFCWUlXcDAxZGdv?=
 =?utf-8?B?a2VKdXNacEhWQTRGL2Evc0lLSVQ5YzgwSVcvSmpXL0pkQndHT2hrSUhEb3Vn?=
 =?utf-8?B?eGEvTXJUN0JzWTBQaUgwUHdSRnVFU01DemtUQzJESjl6Wmg1RjNEMjkwU25H?=
 =?utf-8?B?ejVlWHpjQ2w1V2tBc2V5MkVVYU45V0hiN2RjeCtoeW13YUM5dmpUZlEvdTNt?=
 =?utf-8?B?TytiK0hDZkJia2l0Ly9sWkxoMEZYbVRYOHhPYVFqTVBkRlgwbGJZaHlyelNV?=
 =?utf-8?B?RE1nNkR3NWN1bGJjMWRiSmVqankyNk9wV0lvaE1kQlBtanJQWHRNWU9QcVJt?=
 =?utf-8?B?WWU5Tm1vcnl5UkZ6bXozb1RBVTF5WU5DUHlQWEk0NjJEdnNQcTBqeXVtZVhs?=
 =?utf-8?B?VnVXV3NZV2djU2ZESGRMb0xzR1BWdngybkYwaXg1eXRVaGpYSlo2aWtVKzBJ?=
 =?utf-8?B?RisvOGVGeHV0dWdObjUxTnhJNW1wQUFncG95QjZVbEtodnUySWRocXJHRHBq?=
 =?utf-8?B?TERrVXdrcWVYWHVHYkJWU1g5SFJvQUVwcFprbVJYWXdWeWE2L2x3UG5hbUJ6?=
 =?utf-8?B?cTdyT3RrMUorSGIwUS94b1Izeko3S0dpKzVibG5RYlNVZGpYNUhmU21yTk45?=
 =?utf-8?B?K3pmNmpxTVNpU1piQS9UWVhBeEdpUVd5aWY3dzgzUlhuSHZrVFJUT0E1a0Jp?=
 =?utf-8?B?K0ZKSFQvOHpRN3BtR0FyelZORHVUTHdyWVRsbEpRVFB3enNsSWpSNVhlcE1O?=
 =?utf-8?B?WE9yeG5JRmVUUkN0V21hSGpIbURGeldWbUxZdzdWQVExb2ZMd1c4S0o1R2wx?=
 =?utf-8?B?Nml2amt1dndpQzk2VTUza1ZMcEN3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22103347-e8f8-454c-f9c3-08d9b49cf90d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 07:34:13.7629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmtveSyU0s8R4wTtlpGmOzcVt/alMYeZqryr/DvGqZ2DzZ3PVh6z70S+1niBT9AxRwiSBIareYS2X+08ZHktJ9utLxqPZSewzY73euMNlis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2759
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10184 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112010042
X-Proofpoint-ORIG-GUID: mI_RQhyjI28HPVkZ8rHfgAP6KKmVpBVC
X-Proofpoint-GUID: mI_RQhyjI28HPVkZ8rHfgAP6KKmVpBVC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/23/21 4:28 PM, Darrick J. Wong wrote:
> On Tue, Nov 16, 2021 at 09:13:33PM -0700, Allison Henderson wrote:
>> If the first operation in a string of defer ops has no intents,
>> then there is no reason to commit it before running the first call
>> to xfs_defer_finish_one(). This allows the defer ops to be used
>> effectively for non-intent based operations without requiring an
>> unnecessary extra transaction commit when first called.
>>
>> This fixes a regression in per-attribute modification transaction
>> count when delayed attributes are not being used.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
>>   1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index 6dac8d6b8c21..51574f0371b5 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -187,7 +187,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>>   	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
>>   };
>>   
>> -static void
>> +static bool
>>   xfs_defer_create_intent(
>>   	struct xfs_trans		*tp,
>>   	struct xfs_defer_pending	*dfp,
>> @@ -198,6 +198,7 @@ xfs_defer_create_intent(
>>   	if (!dfp->dfp_intent)
>>   		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
>>   						     dfp->dfp_count, sort);
>> +	return dfp->dfp_intent;
> 
> Nit: This ought to be "return dfp->dfp_intent != NULL" to reinforce that
> we're returning whether or not the dfp has an associated log item vs.
> returning the actual log item.

Sure, I can add that in
> 
>>   }
>>   
>>   /*
>> @@ -205,16 +206,18 @@ xfs_defer_create_intent(
>>    * associated extents, then add the entire intake list to the end of
>>    * the pending list.
>>    */
>> -STATIC void
>> +STATIC bool
>>   xfs_defer_create_intents(
>>   	struct xfs_trans		*tp)
>>   {
>>   	struct xfs_defer_pending	*dfp;
>> +	bool				ret = false;
>>   
>>   	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
>>   		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
>> -		xfs_defer_create_intent(tp, dfp, true);
>> +		ret |= xfs_defer_create_intent(tp, dfp, true);
>>   	}
>> +	return ret;
>>   }
>>   
>>   /* Abort all the intents that were committed. */
>> @@ -488,7 +491,7 @@ int
>>   xfs_defer_finish_noroll(
>>   	struct xfs_trans		**tp)
>>   {
>> -	struct xfs_defer_pending	*dfp;
>> +	struct xfs_defer_pending	*dfp = NULL;
>>   	int				error = 0;
>>   	LIST_HEAD(dop_pending);
>>   
>> @@ -507,17 +510,19 @@ xfs_defer_finish_noroll(
>>   		 * of time that any one intent item can stick around in memory,
>>   		 * pinning the log tail.
>>   		 */
>> -		xfs_defer_create_intents(*tp);
>> +		bool has_intents = xfs_defer_create_intents(*tp);
>>   		list_splice_init(&(*tp)->t_dfops, &dop_pending);
>>   
>> -		error = xfs_defer_trans_roll(tp);
>> -		if (error)
>> -			goto out_shutdown;
>> +		if (has_intents || dfp) {
> 
> I can't help but wonder if it would be simpler to make the xattr code
> walk through the delattr state machine until there's actually an intent
> to log?  I forget, which patch in this series actually sets up this
> situation?
xfs_attr_set_iter is the function that figures out if we need to go 
around again.  That function was merged as part of the refactoring 
subseries.  From here, I think it gets called through the 
xfs_defer_finish_one function below, it's just a line or two below where 
the diff cuts off.  The *_iter routine needs a place to stash away the 
state machine and other such things it needs to keep track of once the 
operation starts, which in this case is the item.

I'll fiddle with some ideas, it might be possible to use the state of 
the attr fork to figure out a chunk of cases that might not need to be 
logged, and then just return null in the create_intent call back.

> 
> Atomic extent swapping sort of has a similar situation in that the first
> transaction logs the inode core update and the swapext intent item, and
> that's it.

Thanks for the reviews!
Allison

> 
> --D
> 
>> +			error = xfs_defer_trans_roll(tp);
>> +			if (error)
>> +				goto out_shutdown;
>>   
>> -		/* Possibly relog intent items to keep the log moving. */
>> -		error = xfs_defer_relog(tp, &dop_pending);
>> -		if (error)
>> -			goto out_shutdown;
>> +			/* Possibly relog intent items to keep the log moving. */
>> +			error = xfs_defer_relog(tp, &dop_pending);
>> +			if (error)
>> +				goto out_shutdown;
>> +		}
>>   
>>   		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>>   				       dfp_list);
>> -- 
>> 2.25.1
>>
