Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F76AC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1056D60F6C
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhHaSOZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:14:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43648 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238033AbhHaSOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:14:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFi4Zw004092;
        Tue, 31 Aug 2021 18:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=N2KhfhitPZFImFo0bOs0mIUy7PSGIrL8iM40vVtZx9w=;
 b=tZjZV3+u0ftqbPVovBDlf9NDUx/LhVsOd6EP6TSdDqAL6WDqsCXYPLTRv6EnPTyvo3q9
 Capglfkx0StR4bvnBgs/+sNu4ELjPESIOg0E921w2i1U2XIuaUb3RRrx5Q7dVI62f91F
 V+dbxmRes+Vs+h0RvkgNKEoNUq1RJ/NfTM4lQelUymBYsrnFRv+80IWUfjr0Ntf4TUiS
 m1ugCzU67yZKG4awpoaM1DXSxcHbcUoz+no5HsXIgKntubQLIN0/MovQPJGA9vcAvHyv
 iwzGUDvAYrcb6aY58JNOtDKFtRoaoGtCi4NGmr+uqXeAGVh7OtfMB0DHRMyHvOypSXfj Tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=N2KhfhitPZFImFo0bOs0mIUy7PSGIrL8iM40vVtZx9w=;
 b=JBRW17V92Ncv/yo6n5HA16BBfBM0bJbDAtJ+HRW9SWCUeVRXTy178fGz5ervQACN2sz5
 WX4B6tI/NSdIYo6PRxAxG18Qi5/zOGC3JUKBL5lvDwFKNz6aNSM4RdmBhPcb5jLHvwvP
 Wjpkkbut6saS5pFGuyWox11qa5/DoUmpMUo0kNSCoFR3j5ab0wkTCTXFSJdE3zxHA51V
 CwFl2oipzmhdACh40fYp6fIZsOQAqg5lOUAHAwK2BHWm8L/BqSfcNQgkUT/YWML6QWsO
 AlCBx7uMZmGASIv1BW+X6c4L0f+WUYVRMdc+AKrgPgBtQNKhft5Zg+QSc/ALznFW/AAn +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asf66hw5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:13:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VI9phm092326;
        Tue, 31 Aug 2021 18:13:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3020.oracle.com with ESMTP id 3aqxwu0mah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:13:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaW3dNmUInCwlECH999J3VzTurmaa5CjVLadTcUuqQKBPjDC1elAvnmSQ8pZeY8AJGJtHX05PotqsRzgdjeIOQ0KrUwfcz7JuPki2GosRllMMYyVQmSq3u2ty4av8D+WIt81gi8cBsEat1sUa3IF/GK+Tgps/MIVRJrHe+TkT0hKyRCwI0zHLnmNah071biAdLUeuPvzakr4zT9rxrzimecODDNz8Ons7J9iiDF9VCKZmxJo7zt9LigsK8E1UeOJvU2iGdH9wDZrVvofzL++lGFX2vW9IlOAjP26UeYOQtZEiH85sqSCX5oBoO8ap/CeUnaG6uVYIceSUjOhhXyINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2KhfhitPZFImFo0bOs0mIUy7PSGIrL8iM40vVtZx9w=;
 b=nxgJjdohmAlVBRtFh2ioQEn0uNMKxhkt37kApqNH3wZxegCneevGn9GA7Fq2QpV5H1cGQ2GkxQSRChsjyqtbPCk+4WmbjdqXVw/ryaUqtfO1VObZU4eYm0FoEsLsGFvxM+6KelFYt/YakVL/oaEP8YEwuAshzZfeLgiIg0X41XwmY5uYog+bgAYcFxwH8GIvjYe3Uk0oXIwp5KVpO7Hh56eCbdnAnyDY0tz3yJOpA9YHOC/yP8lZv4gJQQKQkUnhQOcKXz4cG9LDVD5dDZi6qA/CdCcRz/duTicTSH21qt4V3BN7xLuMbmNmcHL9RnRhF6oXah953j8obemXJwMnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2KhfhitPZFImFo0bOs0mIUy7PSGIrL8iM40vVtZx9w=;
 b=gpN30EGu0bAdQnvLtZxE0JTIU1Yp73NvTmSXvnulq6xSI/Kh4Yx2wsaui4bssddURwfD86yjjG2zrV8WOM6lpicUJag2WR+oOkvX5kjyJz1ZlG89GfCOCc3NnfCjqSRb7YgoO1D5MR+2hyzal62hSr6KIpzeNHYQ00cAAr20hKY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB5533.namprd10.prod.outlook.com (2603:10b6:a03:3f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 18:13:21 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:13:21 +0000
Subject: Re: [PATCH v24 11/11] xfs: Add helper function xfs_attr_leaf_addname
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-12-allison.henderson@oracle.com>
 <8735qr9fu9.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8bf7a438-2ec2-b699-0753-2564c5dc06fd@oracle.com>
Date:   Tue, 31 Aug 2021 11:13:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <8735qr9fu9.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0152.namprd13.prod.outlook.com (2603:10b6:a03:2c7::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Tue, 31 Aug 2021 18:13:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 754f70fb-5e10-4504-bf08-08d96cab03d2
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5533CEDADDB4D688075DF6A595CC9@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YdihJSxQG5rKit6kb6S/LUYtxW6jwFBpVs27Z2PoCz4elwk81F7SYEPeVxb6gT+WbilsbJMOSEUUonU8aTg8/BWz6F4rV8XcfXZY90e5ksOEOZA6UidE76vbxZXheGAw5zJntsU40LSqYBiMb9ErrYW4nPLaZ/2MQ5upFgkvXTNOAWnctuC5NP9wXYFzGHxsSJlQkjpsASiQiPQFCmHsk0joMXrWkWIszwIvJPrnyD06KFeKrQCQEQ+6O2WHUX/R/tnkHpgRRb2qKyYIeu+ssQPIw+Q2/KFhd0IbDabUUoypfmOj4qhp7mLste2io7rx0Y3JD0KK6+BsEGVsl/Gf4tJVWwHZrOnEIZkQOb9H3z1lxnN+byIiLoQcYVAoO3OvC04ozmZ2wwbJVZtxPJqUG88fzbvThfbRIEriXg1jOSMveau7ba7mLm7i09ERwVdpICShtjBPhg1LK/I3hOJQNBc7lVpGaKUy+koc8kkKxG4kr0M7xOgaX+Zzu37oIueKDGxXlJ1uKUMJyo6rAtfhp3tYN+gMIgvFqLyxe3kNkzSlA1szEATrP1PTr6DJwZupu9UlqPflT3zY2/ilyN6coD1ChDHCIc+yEUml7uOFC2PuNtqN1e+AWS6hn6cd89U4A8LTwyFFMlWLhG8SR/GJKzY+BUjn0ytL/QE/xmBzFMBD0OMp6y1mIYH8KLrYMRURpzbgjTytjNf7vASZ30QcYU+6rrbgdC6gyUI13z78y4fUFn0+5AVNPD60IQLnumb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(376002)(366004)(5660300002)(16576012)(6916009)(8676002)(31686004)(31696002)(26005)(316002)(66946007)(66556008)(52116002)(6486002)(186003)(86362001)(44832011)(8936002)(38100700002)(83380400001)(53546011)(66476007)(36756003)(38350700002)(478600001)(956004)(2906002)(4326008)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emtqY1VPemxTbDRSbHhIWHhxYW1LWk1GN0pXY2JyNHhBdFYrWkZxVGRocCs1?=
 =?utf-8?B?eElNd3RTc0lSTXhRbGRVenR1RXc4K3Y3cnpIaEFBbVRzTDRTcXVHbkFTSjdV?=
 =?utf-8?B?ZEFvTEpzSHUrRWZMQkFmWmxXRkJyTm4ydXRsVWpiNEtoYjVhTjVWTS9qYU92?=
 =?utf-8?B?NG5ocWxXVkhOWlNlL0JaK3hhTzVwVE1wejd4YVB5Ni9vR0xYTzdBSGtEY1E5?=
 =?utf-8?B?MERkM20wR1ptS21STm8xaFJMMWI0SUNxdTc4aDhQZFNtS1Y4dE1JVUJ3cFF0?=
 =?utf-8?B?TUNrTVlpYnJJUlErQmM3eVFsbHkxOEM0ZEJuNXlGQW5kU3liWFgxektBSVVj?=
 =?utf-8?B?WDBPQlJkZzhTTEE5TG5wR1FoSEllakwvUkZ2a011UzRqWU9DUkJuSW84bm4x?=
 =?utf-8?B?MktWbWJwMXkxdi9odEIwYVlYMDI5bkhoeXMxRjBaL056d004T01qVURRczJK?=
 =?utf-8?B?TVNEMzlqUGJocnl2VWczMTA1V0RWK1UrRDRNZjN5YUNudGZjRStOakhMd0RB?=
 =?utf-8?B?OUtGNURGd0U4cFFlMEFlSVVHS2QvUGF5MGU1QXQrbTg2WW1sZml3RkpiV0Nz?=
 =?utf-8?B?R25wU0Zjd2N3dlRIdmwrblA0aGJjdHRmQWtKc25LWU53K1FpbDg0bzZqN203?=
 =?utf-8?B?VFFkY295MFYwOVhadE9xQm5kcVd6bCtZaFM0aDNiWnI3N0I1U0Yxc2NrMitD?=
 =?utf-8?B?eG9aeTdIRURwQjkzSVRUa1VvZU44WGF1Qkw0bHo4S0pWSlRJTVFIclZaN1hG?=
 =?utf-8?B?QTN4a0NJdVZZWjBvRWJxaGdVZHNtbDlwVzZYMjMrTFJrQWRFSDFtUGxPUlZw?=
 =?utf-8?B?LzVTMzNBMXJhbkhZZkNRMnRmV3lWS0NiRkp4R08zc1duQko1cFZkTWxDOVNF?=
 =?utf-8?B?dkVyRG1SVFRBdDBhNlB1c0YzSC81dE5TaE04L09UK1VOSTJDbzE0TUsxd2Nm?=
 =?utf-8?B?cGRQUU9Dd0pJaUR0ODVGdkRhWkpObDhzblNUeS9pUWVFNXcxZ0ZnOGEvdWhF?=
 =?utf-8?B?QndOUTAzUjFhNVF0RUpkcHV0RHdsRUpTUmdqbHZmMndhSUo4NDFLc2pOdE9v?=
 =?utf-8?B?TFhuU1NSUzNPaUdDV04vRHRTYk1uV2VCY1dYN0VKdzQrUzZSaXZCUlg5WDRw?=
 =?utf-8?B?ZC9ydWhFV1VnWGJJTytleUtUMVpjOGRWTlFDSGVxcm1zNVVJeUZmOEcraGVa?=
 =?utf-8?B?U3RPQTV4RmRjTVk4MjRsY3Q0eFBEdTdjWEJRYks4NHBYak42YmlIUTd4NlIw?=
 =?utf-8?B?cWlOLzlqOGxiWWt4dkhUSjlqRzg0VW1wT3pjd1htekpuUitDcEU5Ry9XRnpw?=
 =?utf-8?B?Rkd5VW9zMUVPNjN1Z3ZETm5pK0NHbGl0SUdHM1VwT05CbFZNa09nYXNyRjcv?=
 =?utf-8?B?Wkp1d3cvbjlZNHdWTXpwVk1Zdy9NU01VbzVNc1VmTTNHUTZTZnFRcGxDMklG?=
 =?utf-8?B?QWFtSkx2dHlab3FPNGY4TU1idEEwWStlQ0ttOE1BdmZPSDB6NU80b282Zm9q?=
 =?utf-8?B?bzVnMmZFTVpldG9POUtHT1hBZk55SG5taVREMHh5dnhaenc4V0ZhdW1NQ2tn?=
 =?utf-8?B?RjFJcTEyeWZVNkpidEhwWjJkaHdsVXRKTTg5R1c3eUI3ZkdQRWlBREIzUENw?=
 =?utf-8?B?b1huN2p6UVdsMnlzUTNoTnBHMDEwdzBmc3pDTWFuVWJXa1ZlNmZucjRVcHhQ?=
 =?utf-8?B?RzF5QW1HTXFkRWJQaC9wNDFFMG10elhxWVBJSFloZjFQM1ZsdTFzNGs1ZzBW?=
 =?utf-8?Q?L5Ta45Vg58fNSI/c3xTXiMVQImugX+CITkHl7gn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754f70fb-5e10-4504-bf08-08d96cab03d2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:13:21.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5W3fXe/TqO/pYS6lrs1WvNk6jtam8V1GXo+41vx+ps8ES4szqrYjwNDssqlqs6xeTqqab21XkoaWRXoAT3FOtEjXo55DtcBoKia4mYXMJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-GUID: i70hVDBN56LLqvQBFrFWMlhbGosQ8CZe
X-Proofpoint-ORIG-GUID: i70hVDBN56LLqvQBFrFWMlhbGosQ8CZe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 7:17 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> This patch adds a helper function xfs_attr_leaf_addname.  While this
>> does help to break down xfs_attr_set_iter, it does also hoist out some
>> of the state management.  This patch has been moved to the end of the
>> clean up series for further discussion.
>>
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

Great, thankyou!

Allison

> 
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 110 +++++++++++++++++++++------------------
>>   fs/xfs/xfs_trace.h       |   1 +
>>   2 files changed, 61 insertions(+), 50 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c3fdf232cd51..7150f0e051a0 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -284,6 +284,65 @@ xfs_attr_sf_addname(
>>   	return -EAGAIN;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_leaf_addname(
>> +	struct xfs_attr_item	*attr)
>> +{
>> +	struct xfs_da_args	*args = attr->xattri_da_args;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error;
>> +
>> +	if (xfs_attr_is_leaf(dp)) {
>> +		error = xfs_attr_leaf_try_add(args, attr->xattri_leaf_bp);
>> +		if (error == -ENOSPC) {
>> +			error = xfs_attr3_leaf_to_node(args);
>> +			if (error)
>> +				return error;
>> +
>> +			/*
>> +			 * Finish any deferred work items and roll the
>> +			 * transaction once more.  The goal here is to call
>> +			 * node_addname with the inode and transaction in the
>> +			 * same state (inode locked and joined, transaction
>> +			 * clean) no matter how we got to this step.
>> +			 *
>> +			 * At this point, we are still in XFS_DAS_UNINIT, but
>> +			 * when we come back, we'll be a node, so we'll fall
>> +			 * down into the node handling code below
>> +			 */
>> +			trace_xfs_attr_set_iter_return(
>> +				attr->xattri_dela_state, args->dp);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		if (error)
>> +			return error;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> +	} else {
>> +		error = xfs_attr_node_addname_find_attr(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_node_addname(attr);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * If addname was successful, and we dont need to alloc or
>> +		 * remove anymore blks, we're done.
>> +		 */
>> +		if (!args->rmtblkno &&
>> +		    !(args->op_flags & XFS_DA_OP_RENAME))
>> +			return 0;
>> +
>> +		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> +	}
>> +
>> +	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
>> +	return -EAGAIN;
>> +}
>> +
>>   /*
>>    * Set the attribute specified in @args.
>>    * This routine is meant to function as a delayed operation, and may return
>> @@ -319,57 +378,8 @@ xfs_attr_set_iter(
>>   			attr->xattri_leaf_bp = NULL;
>>   		}
>>   
>> -		if (xfs_attr_is_leaf(dp)) {
>> -			error = xfs_attr_leaf_try_add(args,
>> -						      attr->xattri_leaf_bp);
>> -			if (error == -ENOSPC) {
>> -				error = xfs_attr3_leaf_to_node(args);
>> -				if (error)
>> -					return error;
>> -
>> -				/*
>> -				 * Finish any deferred work items and roll the
>> -				 * transaction once more.  The goal here is to
>> -				 * call node_addname with the inode and
>> -				 * transaction in the same state (inode locked
>> -				 * and joined, transaction clean) no matter how
>> -				 * we got to this step.
>> -				 *
>> -				 * At this point, we are still in
>> -				 * XFS_DAS_UNINIT, but when we come back, we'll
>> -				 * be a node, so we'll fall down into the node
>> -				 * handling code below
>> -				 */
>> -				trace_xfs_attr_set_iter_return(
>> -					attr->xattri_dela_state, args->dp);
>> -				return -EAGAIN;
>> -			} else if (error) {
>> -				return error;
>> -			}
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
>> -		} else {
>> -			error = xfs_attr_node_addname_find_attr(attr);
>> -			if (error)
>> -				return error;
>> +		return xfs_attr_leaf_addname(attr);
>>   
>> -			error = xfs_attr_node_addname(attr);
>> -			if (error)
>> -				return error;
>> -
>> -			/*
>> -			 * If addname was successful, and we dont need to alloc
>> -			 * or remove anymore blks, we're done.
>> -			 */
>> -			if (!args->rmtblkno &&
>> -			    !(args->op_flags & XFS_DA_OP_RENAME))
>> -				return 0;
>> -
>> -			attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
>> -		}
>> -		trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
>> -					       args->dp);
>> -		return -EAGAIN;
>>   	case XFS_DAS_FOUND_LBLK:
>>   		/*
>>   		 * If there was an out-of-line value, allocate the blocks we
>> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
>> index 1033a95fbf8e..77a78b5b1a29 100644
>> --- a/fs/xfs/xfs_trace.h
>> +++ b/fs/xfs/xfs_trace.h
>> @@ -4132,6 +4132,7 @@ DEFINE_EVENT(xfs_das_state_class, name, \
>>   	TP_ARGS(das, ip))
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_sf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_set_iter_return);
>> +DEFINE_DAS_STATE_EVENT(xfs_attr_leaf_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_node_addname_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_remove_iter_return);
>>   DEFINE_DAS_STATE_EVENT(xfs_attr_rmtval_remove_return);
> 
> 
